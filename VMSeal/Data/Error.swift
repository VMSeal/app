//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Error.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-23.
//

struct UserFacingError: Error {
    let message: String
    var fatal: Bool?
}

struct DoubleConversionError: Error {
    enum Kind {
        case FromInt
        case FromUInt64
    }
    
    let kind: Kind
}
