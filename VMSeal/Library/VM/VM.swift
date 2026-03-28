//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  VM.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-15.
//

import Virtualization
import Foundation
import SwiftData
import SwiftUI

@Observable
class VM: Identifiable {
    var name: String
    
    var memory: Double
    var vCPUs: Double
    
    var diskSize: Double
    
    let path: Path
    let storage: VM.Storage
    var devices: [Device.Configurable]
    
    let guest: VM.Guest
    
    var vm: VZVirtualMachine?
    
    var configuration: VZVirtualMachineConfiguration
    
    let cdrom: VM.CDROM
    
    var state: VZVirtualMachine.State {
        self.vm?.state ?? .stopped
    }
    
    static func getDefaultDevices(diskSize: Double, storage: VM.Storage) throws -> [Device.Configurable] {
        return try [
            Device.Bootloader(efiVariableStore: storage.EFIVariableStore),
            Device.Platform(),
            Device.Entropy(),
            
            Device.Disk(size: diskSize, at: storage.Disk),
            
            Device.Display(width: 1920, height: 1080),
            Device.Keyboard(),
            Device.Mouse()
        ]
    }
    
    init(
        from name: String,
        devices: [Device.Configurable]?
    ) throws {
        let path = Path(.Places.vms, name)
        self.path = path
        
        let storage = VM.Storage(path: path)
        self.storage = storage
        
        let specs: VM.Storage.Backup = try JSON.decode(
            at: storage.Configuration
        )
        
        self.name = name
        
        self.memory = specs.memory
        self.vCPUs = specs.vCPUs
        self.diskSize = specs.diskSize
        
        self.guest = specs.guest
        
        self.devices = try devices ?? VM.getDefaultDevices(
            diskSize: specs.diskSize,
            storage: storage
        )
        
        self.configuration = VZVirtualMachineConfiguration()
        
        self.cdrom = VM.CDROM(state: specs.cdrom)
        
        // Make sure CDROM is removed if backup indicates so.
        if self.cdrom.state == .inserted {
            try self.cdrom.eject(vm: self)
        }
    }
    
    init(
        name: String,
        specs: VM.Configuration,
        guest: VM.Guest,
        devices: [Device.Configurable]?
    ) throws {
        self.name = name
        
        self.memory = specs.memory
        self.vCPUs = specs.vCPUs
        self.diskSize = specs.diskSize
        
        self.guest = guest
        
        let path = Path(.Places.vms, name)
        self.path = path
        
        let storage = VM.Storage(path: path)
        try storage.create()
        
        self.storage = storage
        
        self.devices = try devices ?? VM.getDefaultDevices(
            diskSize: specs.diskSize,
            storage: storage
        )
        
        self.configuration = VZVirtualMachineConfiguration()
        
        // CDROM is inserted by default.
        self.cdrom = VM.CDROM(state: .inserted)
        try self.cdrom.insert(vm: self)
        
        self.backup()
    }
    
    func backup() -> Void {
        try? self.storage.backup(
            backup: VM.Storage.Backup(
                memory: self.memory,
                diskSize: self.diskSize,
                vCPUs: self.vCPUs,
                guest: self.guest,
                cdrom: self.cdrom.state
            )
        )
    }
    
    func configure() throws -> Void {
        
        self.configuration.memorySize = self.memory.asUInt64
        self.configuration.cpuCount = self.vCPUs.asInt
        
        do {
            for device in self.devices {
                try device.configure(configuration: self.configuration)
            }
        } catch {
            throw UserFacingError(
                message: "Failed to configure device(s)."
            )
        }
        
        try self.configuration.validate()
        
        self.backup()
    }
    
    func start() async throws {
        do {
            self.vm = VZVirtualMachine(
                configuration: self.configuration
            )
            
            try await self.vm?.start()
        } catch let e {
            throw UserFacingError(
                message: "Something went wrong starting the box!\nDetails: \(e.localizedDescription)",
                fatal: true
            )
        }
    }
    
    func stop() throws {
        try self.vm?.requestStop()
    }
    
    func rename(to newName: String) throws {
        self.name = newName
        self.backup()
        
        try self.storage.path.move(
            to: Path(.Places.vms, newName)
        )
    }
}

extension VM {
    @Observable
    class CDROM {
        enum State: Codable {
            case inserted
            case ejected
        }
        
        var state: State
        
        init(state: State) {
            self.state = state
        }
        
        /**
         * **NOTE:** running `vm.configure()` and rebooting the VM is required for this to take effect!
         */
        func insert(vm: VM) throws -> Void {
            // Already inserted
            if vm.devices.contains(where: { $0 is Device.CDROM }) {
                return
            }
            
            vm.devices.append(
                Device.CDROM(from: vm.guest.image)
            )
            
            self.state = .inserted
        }
        
        /**
         * **NOTE:** running `vm.configure()` and rebooting the VM is required for this to take effect!
         */
        func eject(vm: VM) throws -> Void {
            vm.devices.removeAll {
                $0 is Device.CDROM
            }
            
            self.state = .ejected
        }
    }
}
