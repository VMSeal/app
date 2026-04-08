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
    @State private var installer: VM.Installer = VM.Installer()
    
    @State private var error = VMSeal.Error()
    @State private var newVM = Modal()
    
    init() {
        // Restores saved VMs from disk
        supervisor.restore()
    }
    
    var body: some Scene {
        WindowGroup {
            Dashboard(
                supervisor: $supervisor,
                error: error.trigger,
                addNewVM: newVM.show,
            )
            .sheet(isPresented: $newVM.displayed) {
                Wizard.NewVM(didCancel: newVM.hide) { name, description, specs in
                    newVM.hide()
                    
                    Task {
                        do {
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
                InstallProgress(
                    progress: $installer.progress,
                    status: $installer.status
                )
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
            CommandGroup(before: .newItem) {
                Menubar.NewVM(
                    action: newVM.show,
                    disabled: newVM.displayed
                )
            }
            
            CommandMenu("VM") {
                let toggled = Binding<Bool>(
                    get: { supervisor.currentVM?.cdrom.state == .inserted },
                    set: { _ in
                        if let vm = supervisor.currentVM {
                            do {
                                try vm.cdrom.toggle(vm: vm)
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


