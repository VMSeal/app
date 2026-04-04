//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  App.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-12.
//


import Foundation
import SwiftUI
import Virtualization
import AppKit

@main
struct VMSeal: App {
    @State private var supervisor: Supervisor = Supervisor()
    
    // True if *any* modal is currently in use.
    @State private var usingModal = false
    @State private var error = VMSeal.Error()
    
    @State private var installer: VM.Installer = VM.Installer()
    
    init() {
        self.supervisor.restore()
    }
    
    var body: some Scene {
        WindowGroup {
            Dashboard(
                supervisor: $supervisor,
                error: self.error.trigger,
                showModal: self.showModal,
            )
                .sheet(isPresented: $usingModal) {
                    Wizard.NewVM(didCancel: hideModal) { name, description, specs in
                        hideModal()
                        
                        Task {
                            do {
                                hideModal()
                                try await self.installer.install(
                                    name: name,
                                    specs: specs,
                                    supervisor: supervisor
                                )
                            } catch let e {
                                self.error.trigger(e.localizedDescription)
                            }
                        }
                    }
                }
                .sheet(isPresented: $installer.active) {
                    VStack {
                        if installer.progress >= 0 {
                            ProgressView(value: installer.progress)
                            Text(installer.status?.rawValue ?? "Working on it...")
                        } else {
                            ProgressView()
                            Text("Please be patient, this may take a while...")
                        }
                    }
                    .padding(10)
                    
                    
                }
                .alert(error.message, isPresented: $error.occurred) {
                    Button("OK") {
                        error.occurred.toggle()
                        
                        if error.crash {
                            VMSeal.quit()
                        }
                    }
                }
        }
        .commands {
            Menubar.NewVM(showModal, usingModal)
            
            CommandMenu("VM") {
                let toggled = Binding<Bool>(
                    get: { supervisor.currentVM?.cdrom.state == .inserted },
                    set: {
                        if let vm = supervisor.currentVM {
                            do {
                                if $0 {
                                    try vm.cdrom.insert(vm: vm)
                                } else {
                                    try vm.cdrom.eject(vm: vm)
                                }
                            
                                try vm.configure()
                            } catch let e {
                                self.error.trigger(e.localizedDescription)
                            }
                        }
                    }
                )
                
                Menubar.InsertCDROM(toggled: toggled)
                    .disabled(
                        supervisor.currentVM == nil || supervisor.currentVM?.state != .stopped
                    )
            }
        }
    
        Settings {
            self.settings
        }
    }
    
    func showModal() -> Void {
        self.usingModal = true
    }
    
    func hideModal() -> Void {
        self.usingModal = false
    }
    
    static var architecture: SystemArchitecture {
        return getArchitecture()
    }
    
    static func quit() -> Void {
        NSApplication.shared.terminate(self)
    }
}

extension VMSeal {
    class Error {
        var occurred: Bool = false
        var message: String = "Something went wrong!"
        var crash: Bool = false
        
        /** Displays a user-facing error */
        func trigger(_ message: String?) -> Void {
            self.occurred = true
            
            if message != nil {
                self.message = message!
            }
        }
    }
}


