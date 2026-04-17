//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Guest.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-22.
//


import Foundation

extension VM {
    struct Guest: Identifiable, Hashable, Codable {
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
                
        let name: String
        let image: Path
        
        var id: String {
            self.name
        }
    }
}
