//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  List.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-23.
//

import Foundation
import SwiftUI

extension Dashboard {
    var list: some View {
        List($supervisor.vms, id: \.id, selection: $selection) { vm in
            
            // We recreate a binding inside here because we need
            // to do an equality test.
            //
            // This makes sure that it is the VM in THIS iteration
            // which gets renamed, otherwise a popover appears for
            // every single VM...
            let isRenamingThisVM: Binding<Bool> = Binding<Bool>(
                get: {
                    renaming?.id == vm.wrappedValue.id
                },
                set: { _ in
                    // This prevents a bug where clicking outside
                    // the renaming popover doesn't cause it to disappear.
                    renaming = nil
                }
            )
            
            Label(vm.name.wrappedValue, systemImage: "shippingbox")
                .contextMenu {
                    Button("Rename") {
                        renaming = vm.wrappedValue
                    }
                    
                    Button("Delete", systemImage: "minux", role: .destructive) {
                        let _ = supervisor.delete(vm.wrappedValue)
                    }
                    .disabled(vm.id == selectedVM?.id)
                }
                .popover(isPresented: isRenamingThisVM) {
                    RenamePopover { newName in
                        rename(vm: renaming!, name: newName)
                    }
                }
        }
        .contextMenu {
            Button("New...", systemImage: "plus", action: showModal)
        }
    }
}
