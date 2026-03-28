//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Keyboard.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-04.
//

import Foundation
import Virtualization

extension Device {
    struct Keyboard: Configurable {
        let keyboard: VZUSBKeyboardConfiguration
        
        func configure(configuration: VZVirtualMachineConfiguration) -> Void {
            configuration.keyboards = [self.keyboard]
        }
        
        init() {
            self.keyboard = VZUSBKeyboardConfiguration()
        }
    }
}
