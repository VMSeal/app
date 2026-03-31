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
            
            return vms.map { String.atob(text: $0) ?? "" } // decode the Base64-encoded filename.
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
        
        init(vm name: String) {
            // The VMs are stored in base64 format, so the path used is encoded.
            self.path = Path(.Places.vms, name.btoa())
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
        
        /** Avoid calling this method directly instead of `VM.rename()`, since this method only renames its directory. */
        func rename(to newName: String) throws -> Void {
            try self.path.move(
                to: Path(.Places.vms, newName.btoa())
            )
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
