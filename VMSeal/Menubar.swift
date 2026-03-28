//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Menubar.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-20.
//


import Foundation
import SwiftUI

extension VMSeal {
    struct Menubar {
        static func NewVM(disabled: Bool = false, callback: @escaping () -> Void) -> CommandGroup<some View> {
            return CommandGroup(before: .newItem) {
                Button("New VM...") {
                    return callback()
                }
                .disabled(disabled)
                .keyboardShortcut("N", modifiers: [.command, .shift])
            }
        }
    }
}
