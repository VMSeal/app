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
    
    @State private var hadError: Bool = false
    @State private var errorMessage: String = ""
    
    @State private var newVM = Modal()
    
    init() {
        // Restores saved VMs from disk
        supervisor.restore()
    }
    
    var body: some Scene {
        WindowGroup {
            Dashboard(
                supervisor: $supervisor,
                error: reportError,
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
                        } catch let e as LocalizedError {
                            reportError(e.errorDescription)
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
            .alert(errorMessage, isPresented: $hadError) {
                Button("OK") {
                    hadError = false
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
                            } catch let e as LocalizedError {
                                reportError(e.errorDescription)
                            } catch let e {
                                reportError(e.localizedDescription)
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
    
    func reportError(_ message: String?) -> Void {
        self.hadError = true
        self.errorMessage = message ?? "Something went wrong!"
    }
}
