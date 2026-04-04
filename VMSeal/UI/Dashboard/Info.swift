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
            Spacer()
                .frame(maxWidth: .infinity, maxHeight: 2)
            Text(value)
        }
        .font(.system(size: 16))
        .padding(2)
        .gridColumnAlignment(.leading)
    }
}

extension Dashboard {
    var info: some View {
        VStack {
            if let vm = selectedVM {
                HStack {
                    Heading(2, "Hardware")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(4)
                
                GroupBox {
                    Grid {
                        Row(
                            key: "Disk:",
                            value: ByteUnit.HumanReadable.from(vm.diskSize, in: .GiB)
                        )
                        
                        Divider()
                        
                        Row(
                            key: "RAM:",
                            value: ByteUnit.HumanReadable.from(vm.memory, in: .GiB)
                        )
                        
                        Divider()
                        
                        Row(
                            key: "vCPUs:",
                            value: String(Int(vm.vCPUs))
                        )
                        
                        Divider()
                        
                        Row(
                            key: "CDROM:",
                            value: vm.cdrom.state == .inserted
                                ? "Inserted"
                                : "Ejected"
                        )
                    }
                }
            } else {
                Text("No VM selected.")
            }
        }
        .padding(2)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
