//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  DiskSpace.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-04-24.
//

import Foundation

class DiskSpace {
    static var free: Double {
        let fileURL = URL(fileURLWithPath: "/")
        
        // otherwise...
        
        let values = try? fileURL.resourceValues(
            forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey]
        )
        
        guard let capacity = Double(exactly: values?.volumeAvailableCapacityForOpportunisticUsage ?? 0) else {
            return 0
        }
        
        return capacity
    }
}
