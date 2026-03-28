//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Wrapper.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-07.
//

import Foundation


struct Architecture {
    enum Chip: Codable {
        case Intel
        case Silicon
    }
    
    static var host: Chip {
        let architecture = getArchitecture()
        
        if architecture == INTEL_BASED {
            return .Intel
        }
        
        return .Silicon
    }
}
