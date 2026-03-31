//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Delegate.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-31.
//

import Foundation
import Virtualization

extension VM {
    /** Observer which ensures that `VZVirtualMachine.state` isn't stale. */
    @Observable
    class StateObserver {
        var state: VZVirtualMachine.State = .stopped
        
        private var vm: VZVirtualMachine
        private var observation: NSKeyValueObservation?
        
        init(vm: VZVirtualMachine) {
            self.vm = vm
            self.observation = nil
            
            self.observation = self.vm.observe(\.state, options: [.new]) { vm, change in
                self.state = vm.state
            }
        }
    }
}
