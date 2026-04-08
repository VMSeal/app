//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Modal.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-04-08.
//

import SwiftUI

/** Describes the state of a sheet (modal). */
@Observable
class Modal {
    var displayed: Bool = false
    
    func show() {
        displayed = true
    }
    
    func hide() {
        displayed = false
    }
}
