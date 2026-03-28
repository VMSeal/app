//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Device.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-22.
//


import Virtualization

struct Device {
    protocol Configurable {
        func configure(configuration: VZVirtualMachineConfiguration) throws -> Void
    }
}
