//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Platform.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-04.
//

import Foundation
import Virtualization

extension Device {
    struct Platform: Configurable {
        let platform: VZGenericPlatformConfiguration
        
        func configure(configuration: VZVirtualMachineConfiguration) -> Void {
            configuration.platform = self.platform
        }
        
        init() {
            self.platform = VZGenericPlatformConfiguration()
            self.platform.machineIdentifier = VZGenericMachineIdentifier()
        }
    }
}
