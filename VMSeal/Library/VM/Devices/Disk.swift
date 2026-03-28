//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Disk.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-03.
//

import Foundation
import Virtualization

struct DiskCreationError: LocalizedError {
    
    let message: String
    var fatal: Bool = false
    
    var errorDescription: String {
        return NSLocalizedString("Failed to create disk: \(message)", comment: "")
    }
}

extension Device {
    class Disk: Configurable {
        // Truncates a new empty disk which can be used.
        func truncate() throws -> Void {
            let fd = unsafe open(
                self.path.stringified,
                O_RDWR | O_CREAT,
                S_IRUSR | S_IWUSR
            )
            
            if fd == -1 {
                throw DiskCreationError(
                    message: "Disk file descriptor is invalid.",
                    fatal: true
                )
            }
            
            var status = ftruncate(fd, self.size.asInt64)
            
            if status != 0 {
                throw DiskCreationError(message: "Failed to truncate new disk...")
            }
            
            // Truncation finished...
            
            status = close(fd)
            
            if status != 0 {
                throw DiskCreationError(
                    message: "Failed to close writing of the new disk!",
                    fatal: true
                )
            }
        }
        
        func configure(configuration: VZVirtualMachineConfiguration) throws -> Void {
            guard let attachment = try? VZDiskImageStorageDeviceAttachment(url: path.url, readOnly: false) else {
                throw DiskCreationError(message: "Failed to create a disk image attachment!")
            }
            
            let disk = VZVirtioBlockDeviceConfiguration(attachment: attachment)
            
            configuration.storageDevices.append(disk)
        }
        
        let size: Double
        let path: Path
        
        init(
            size: Double, // <-- Size is expected to be in bytes.
            at path: Path
        ) {
            self.size = size
            self.path = path
        }
    }
}
