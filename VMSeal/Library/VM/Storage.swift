//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Storage.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-25.
//

import Foundation

extension VM {
    struct Storage {
        /** Computed property returning all VMs stored as an array of VM names (i.e. filenames) */
        static var all: [String] {
            guard let vms = try? FileManager.default.contentsOfDirectory(
                atPath: Path.Places.vms.stringified
            ) else {
                return []
            }
            
            return vms
        }
        
        func backup(backup: VM.Storage.Backup) throws -> Void {
            // Attempt to create the storage path gracefully.
            if !self.path.exists() {
                try Path.mkdir(path: self.path)
            }
            
            let encoded = try JSON.encode(from: backup)
            
            try Path.write(
                path: Path(self.path, "Configuration.json"),
                content: encoded
            )
        }
        
        func create() throws -> Void {
            if self.path.exists() {
                return
            }
            
            try Path.mkdir(path: self.path)
        }
        
        func erase() -> Void {
            if self.path.exists() {
                // We'll try our best, but we can't guarantee removal.
                try? self.path.remove()
            }
        }
        
        var path: Path
        
        var EFIVariableStore: Path {
            Path(path, "EFIVariableStore")
        }
        
        var Disk: Path {
            Path(path, "Disk")
        }
        
        var Configuration: Path {
            Path(path, "Configuration.json")
        }
    }
}

extension VM.Storage {
    struct Backup: Codable {
        var memory: Double
        var diskSize: Double
        var vCPUs: Double
        
        var guest: VM.Guest
        var cdrom: VM.CDROM.State
    }
}
