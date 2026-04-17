//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Frame.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-22.
//


import SwiftUI
import Virtualization

extension VM {
    struct UI {
        struct Frame: NSViewRepresentable {
            var currentVM: VM
            
            func makeNSView(context: Context) -> VZVirtualMachineView {
                let view = VZVirtualMachineView()
                view.virtualMachine = currentVM.vm
                
                view.becomeFirstResponder()
                //view.automaticallyReconfiguresDisplay = true
                
                DispatchQueue.main.async {
                    unsafe view.window?.makeFirstResponder(view)
                }
                
                return view
            }
            
            func updateNSView(_ nsView: VZVirtualMachineView, context: Context) -> Void {
                if nsView.virtualMachine !== currentVM.vm {
                    nsView.virtualMachine = currentVM.vm
                }
            }
            
            typealias NSViewType = VZVirtualMachineView
        }
    }
}
