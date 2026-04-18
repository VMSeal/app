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
        private class VMView: VZVirtualMachineView {
            var vm: VM?
            
            override func setFrameSize(_ newSize: NSSize) {
                super.setFrameSize(newSize)
                
                guard newSize.width > 0 && newSize.height > 0 else {
                    return
                }
                
                if let display = vm?.display {
                    
                    // Size must've changed since last resize!
                    if newSize.width == display.sizeInPixels.width
                        && newSize.height == display.sizeInPixels.height
                    {
                        return
                    }
                    
                    try? display.reconfigure(
                        configuration: VZVirtioGraphicsScanoutConfiguration(
                            widthInPixels: Int(newSize.width),
                            heightInPixels: Int(newSize.height)
                        )
                    )
                }
            }
        }
        
        struct Frame: NSViewRepresentable {
            var currentVM: VM
            
            func makeNSView(context: Context) -> VZVirtualMachineView {
                let view = VMView()
                view.vm = currentVM
                
                view.virtualMachine = currentVM.vm
                
                view.becomeFirstResponder()
                view.automaticallyReconfiguresDisplay = false
                
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
