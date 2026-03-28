//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Detail.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-23.
//


import SwiftUI

extension Dashboard {
    struct Detail {
        let selectedVM: VM?
        let selection: Set<VM.ID>
        
        var unselected: some View {
            Notice(title: "No VM selected.")
        }
        
        var multipleSelected: some View {
            Notice(
                title: "\(selection.count) VMs are selected."
            )
        }
        
        var empty: some View {
            Notice(
                title: "You don't have any VMs, yet...",
                subtitle: "Create one via 'File > New VM...' in the menubar."
            )
        }
        
        var vm: some View {
            HStack {
                if selectedVM != nil {
                    VM.Frame(currentVM: selectedVM!)
                } else {
                    Text("Something went wrong displaying the VM...")
                }
            }
            .navigationTitle(selectedVM?.name ?? "Unnamed VM")
        }
    }
    
    @ViewBuilder var detail: some View {
        let d = Detail(
            selectedVM: self.selectedVM,
            selection: self.selection
        )
        
        if self.view == .Info && self.selectedVM != nil {
            d.info
        } else if self.supervisor.vms.isEmpty {
            d.empty
        } else if self.selection.isEmpty {
            d.unselected
        } else if self.selection.count > 1 {
            d.multipleSelected
        } else {
            d.vm
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
