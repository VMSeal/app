//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  CDROM.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-06.
//

import Foundation
import Virtualization

extension Device {
    struct CDROM: Configurable {
        var bootablePath: Path?
        
        private func createCDROM() throws -> VZVirtioBlockDeviceConfiguration {
            guard let bootable = self.bootablePath else {
                throw PathNotExists(path: "Unknown")
            }
            
            let attachment = try VZDiskImageStorageDeviceAttachment(
                url: bootable.url,
                readOnly: true
            )
            
            let cdrom = VZVirtioBlockDeviceConfiguration(
                attachment: attachment
            )
            
            return cdrom
        }
        
        func configure(configuration: VZVirtualMachineConfiguration) throws -> Void {
            let cdrom = try self.createCDROM()
            
            configuration.storageDevices.insert(cdrom, at: 0)
        }
        
        init(from path: Path?) {
            self.bootablePath = path
        }
    }
}
