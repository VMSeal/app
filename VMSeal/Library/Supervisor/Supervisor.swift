//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Supervisor.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-21.
//

import Foundation
import SwiftUI


/** Class which manages the existence of the user's VMs. */
@Observable
class Supervisor {
    var vms = [VM]()
    var currentVM: VM?
    
    func restore() {
        for name in VM.Storage.all {
            var vm: VM
            
            do {
                vm = try VM(from: name, devices: nil)
                try vm.configure()
            } catch {
                continue
            }
            
            vms.append(vm)
        }
    }
    
    func add(_ vm: VM) -> Void {
        vms.append(vm)
    }
    
    func delete(_ vm: VM) -> Bool {
        guard let index = vms.firstIndex(where: { $0.id == vm.id }) else {
            return false
        }
        
        vm.storage.erase()
        vms.remove(at: index)
        
        return true
    }
}
