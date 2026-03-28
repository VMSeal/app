//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Mouse.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-04.
//

import Foundation
import Virtualization

extension Device {
    struct Mouse: Configurable {
        let mouse: VZUSBScreenCoordinatePointingDeviceConfiguration
        
        func configure(configuration: VZVirtualMachineConfiguration) -> Void {
            configuration.pointingDevices = [mouse]
        }
        
        init() {
            self.mouse = VZUSBScreenCoordinatePointingDeviceConfiguration()
        }
    }
}
