//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Info.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-24.
//

import SwiftUI

/** Specialised version of GridRow */
private struct Row: View {
    
    let key: String
    let value: String
    
    var body: some View {
        GridRow {
            Text(key)
            Text(value)
        }
        .padding(3)
        .gridColumnAlignment(.leading)
    }
}

extension Dashboard.Detail {
    var info: some View {
        let vm = selectedVM!
        
        return NavigationStack {
            VStack {
                GroupBox("Hardware") {
                    Grid {
                        Row(
                            key: "Disk:",
                            value: ByteUnit.HumanReadable.from(vm.diskSize, in: .GiB)
                        )
                        
                        Row(
                            key: "Memory:",
                            value: ByteUnit.HumanReadable.from(vm.memory, in: .MiB)
                        )
                        
                        Row(
                            key: "vCPUs",
                            value: String(Int(vm.vCPUs))
                        )
                    }
                }
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .top
        )
        .navigationTitle("Info")
    }
}
