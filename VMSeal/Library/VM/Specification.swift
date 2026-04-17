//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Configuration.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-15.
//


import Foundation
import Virtualization

extension VM {
    struct Specification: Codable {
        var memory: Double
        var diskSize: Double
        
        var vCPUs: Double
        
        var source: Source
        
        // Determines if the guest
        // can connect to the internet.
        var airgapped: Bool
        
        // Default configuration which should
        // be fine for most.
        static var standard: Specification {
            Specification(
                memory: VM.Requirements.Memory.recommended,
                diskSize: 16.GiB,
                vCPUs: 2,
                source: Source.all.first!,
                airgapped: false
            )
        }
    }
}
