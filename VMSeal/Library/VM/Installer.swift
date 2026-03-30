//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Installer.swift
//  VMSeal
//
//  Created by Developer on 2026-03-26.
//

import SwiftUI

extension VM {
    @Observable
    class Installer {
        
        enum Status: String {
            case DOWNLOADING_IMAGE = "Downloading ISO image..."
            case VERIFYING_IMAGE = "Verifying checksum..."
            case CONFIGURING_VM = "Configuring new VM..."
        }
        
        var active: Bool = false
        var status: Status? = nil
        var progress: Double = -1
        
        private func download(_ guest: VM.Guest) async throws -> Path {
            let iso = guest.image
            
            if iso.exists() {
                try iso.remove()
            }
            
            try await fetch(
                from: guest.url,
                saveTo: iso,
                didProgress: { progress in
                    self.progress = progress.fractionCompleted
                }
            )
            
            return iso
        }

        private func verify(_ guest: VM.Guest) async throws -> Bool {
            let checksum = try guest.image.checksum(
                binary: true
            )
            
            return guest.sha256sum.matches(checksum)
        }
        
        func install(
            name: String,
            specs: VM.Configuration,
            supervisor: Supervisor,
        ) async throws -> Void {
            self.active = true
            self.progress = -1
            
            let os = specs.os
            
            let downloaded: Path = os.image
            
            // Only downloads if needed.
            if !downloaded.exists() {
                self.status = .DOWNLOADING_IMAGE
                let _ = try await download(os)
            }
            
            self.status = .VERIFYING_IMAGE
            
            // TODO: Make this async
            let verified = try await self.verify(os)
            
            if !verified {
                throw UserFacingError(
                    message: 
                        "VMSeal failed to verify the ISO downloaded was legitimate!\nConsider opening an issue if the error persists."
                )
            }
            
            self.status = .CONFIGURING_VM
            
            let vm = try VM(
                name: name,
                specs: specs,
                guest: os,
                devices: nil
            )
            
            let disk = vm.devices.first { $0 is Device.Disk } as? Device.Disk
            
            if disk == nil {
                throw UserFacingError(message: "Disk not found inside VM's internal devices!")
            }
            
            try disk!.truncate()
            try vm.configure()
            
            supervisor.add(vm)
            
            self.active = false
        }
    }
}
