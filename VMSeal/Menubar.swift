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

import SwiftUI

struct Menubar {
    static func NewVM(action: @escaping () -> Void, disabled: Bool) -> some View {
        Button("New VM...", action: action)
            .disabled(disabled)
            .keyboardShortcut("N", modifiers: [.command, .shift])
    }
    
    struct InsertCDROM: View {
        
        @Binding var toggled: Bool
        
        var body: some View {
            Toggle("Insert CDROM", isOn: $toggled)
        }
    }
}
