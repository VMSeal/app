//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  ButtonRole.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-04-24.
//

import SwiftUI

extension ButtonRole {
    static var maybeConfirmRole: Self? {
        if #available(macOS 26.0, *) {
            return .confirm
        }
        
        return nil
    }
}
