//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Dashboard.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-22.
//

import Foundation
import Virtualization

extension Device {
    struct Entropy: Configurable {
        let entropy: VZVirtioEntropyDeviceConfiguration
        
        func configure(configuration: VZVirtualMachineConfiguration) -> Void {
            configuration.entropyDevices = [self.entropy]
        }
        
        init() {
            self.entropy = VZVirtioEntropyDeviceConfiguration()
        }
    }
}
