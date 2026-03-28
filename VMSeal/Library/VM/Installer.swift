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

extension VM {
    struct Installer {
        static func install(
            name: String,
            specs: VM.Configuration,
            supervisor: Supervisor
        ) async throws -> Void {
            let os = specs.os
            
            let downloaded: Path = os.image
            
            // Only downloads if needed.
            if !downloaded.exists() {
                let _ = try await download(os)
            }
            
            let verified = (try? verify(os)) ?? false
            
            if !verified {
                throw UserFacingError(
                    message: 
                        "VMSeal failed to verify the ISO downloaded was legitimate!\nConsider opening an issue if the error persists."
                )
            }
            
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
        }
    }
}
