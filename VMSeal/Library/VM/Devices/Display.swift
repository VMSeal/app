//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Display.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-04.
//

import Foundation
import Virtualization

extension Device {
    struct Display: Configurable {
        let graphics: VZVirtioGraphicsDeviceConfiguration
        let scanout: VZVirtioGraphicsScanoutConfiguration
        
        func configure(configuration: VZVirtualMachineConfiguration) -> Void {
            configuration.graphicsDevices = [self.graphics]
        }
        
        init(
            width: Int = 1920,
            height: Int = 1080
        ) {
            self.graphics = VZVirtioGraphicsDeviceConfiguration()
            
            self.scanout = VZVirtioGraphicsScanoutConfiguration(
                widthInPixels: width,
                heightInPixels: height
            )
            
            self.graphics.scanouts = [self.scanout]
        }
    }
}
