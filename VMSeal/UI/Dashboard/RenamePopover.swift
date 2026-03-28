//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  RenamePopover.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-23.
//


import SwiftUI

extension Dashboard {
    struct RenamePopover: View {
        let callback: (_: String?) -> Void
        
        @State private var newName: String = ""
        
        var body: some View {
            TextField(text: $newName) {
                Text("e.g. Development")
            }
            .frame(minWidth: 200)
            .padding(8)
            .textFieldStyle(.roundedBorder)
            .onKeyPress(keys: [.return]) {_ in
                callback(newName)
                return .handled
            }
        }
    }
}
