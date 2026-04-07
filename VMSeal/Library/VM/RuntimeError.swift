//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  RuntimeError.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-04-06.
//

extension VM {
    struct RuntimeError: Error {
        let localizedError: String
        
        init(_ message: String) {
            self.localizedError = message
        }
    }
}
