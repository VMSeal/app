//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  NewVM.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-16.
//

import SwiftUI

extension Wizard {
    struct NewVM: View {
        struct Submitted {
            var name: String = ""
            var description: String = ""
            
            var specs = VM.Configuration.standard
        }
        
        @State private var submitted = Submitted()
        
        // ---
        @State private var errorOccurred = false
        
        

        private var buttonSubmitRole: ButtonRole? {
            if #available(macOS 26.0, *) {
                return .confirm
            }
            
            return nil
        }
        
        var didCancel: () -> Void
        var didSubmit: (_ name: String, _ description: String?, _ specs: VM.Configuration) -> Void
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("New VM")
                    .font(.title)
                
                Form {
                    Heading(2, "Info")
                    
                    Grid {
                        GridRow {
                            TextField(text: $submitted.name) {
                                Text("Name: ")
                            }
                            .textFieldStyle(.squareBorder)
                            .padding(.leading)
                        }
                        
                        GridRow {
                            TextField(text: $submitted.description, prompt: Text("(optional)").italic()) {
                                Text("Description: ")
                            }
                            .textFieldStyle(.squareBorder)
                            .padding(.leading)
                        }
                    }
                    
                    
                    Heading(2, "OS")
                    
                    Grid {
                        GridRow {
                            Picker("Guest OS: ", selection: $submitted.specs.os) {
                                ForEach(Guests) { guest in
                                    Text(guest.name).tag(guest)
                                }
                            }
                            .padding(.leading)
                        }
                    }
                    
                    Heading(2, "Hardware")
                    
                    Slider(
                        value: $submitted.specs.memory,
                        in:
                            VM.Requirements.Memory.minimum...VM.Requirements.Memory.maximum,
                        step: 0.75.GiB
                    ) {
                        Text("Memory: ")
                        Text(
                            ByteUnit.HumanReadable.from(
                                submitted.specs.memory,
                                in: .MiB
                            )
                        )
                    }.padding(.leading)
                    
                    Slider(
                        value: $submitted.specs.diskSize,
                        in: 10.GiB...128.GiB,
                        step: 6.GiB
                    ) {
                        Text("Disk Size: ")
                        Text(
                            ByteUnit.HumanReadable.from(
                                submitted.specs.diskSize,
                                in: .GiB
                            )
                        )
                    }.padding(.leading)
                    
                    Slider(
                        value: $submitted.specs.vCPUs,
                        in: Double(VM.Requirements.CPU.minimum)...Double(VM.Requirements.CPU.maximum),
                        step: 1
                    ) {
                        Text("vCPUs: ")
                        Text(
                            "\(Int(submitted.specs.vCPUs)) vCPU\(submitted.specs.vCPUs > 1 ? "s" : "")"
                        )
                    }.padding(.leading)
                }.formStyle(.grouped)
                
                Spacer()
                Divider()
                Spacer()
                
                HStack {
                    Button("Cancel", role: .cancel, action: didCancel)
                    
                    Button("Create", role: buttonSubmitRole) {
                        didSubmit(submitted.name, submitted.description, submitted.specs)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(submitted.name.isEmpty)
                }
                .alert("Something went wrong!", isPresented: $errorOccurred) {
                    Button("Exit") {
                        fatalError("Crashed when attempting to create VM.")
                    }
                }
            }
            .navigationTitle("New VM - Setup Assistant")
            .padding(.all)
        }
    }
}
