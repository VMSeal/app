//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Network.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-31.
//

import Virtualization

extension Device {
    class Network: Configurable {
        let network: VZVirtioNetworkDeviceConfiguration
        let attachment: VZNATNetworkDeviceAttachment
        
        func configure(configuration: VZVirtualMachineConfiguration) throws -> Void {
            configuration.networkDevices.append(self.network)
        }
        
        init() {
            self.network = VZVirtioNetworkDeviceConfiguration()
            self.attachment = VZNATNetworkDeviceAttachment()
            
            self.network.attachment = self.attachment
        }
    }
}
