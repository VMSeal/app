//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Bootloader.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-04.
//

import Foundation
import Virtualization

extension Device {
    struct Bootloader: Configurable {
        
        let efi: VZEFIBootLoader
        let store: VZEFIVariableStore
        
        func configure(configuration: VZVirtualMachineConfiguration) -> Void {
            configuration.bootLoader = self.efi
        }
        
        init(efiVariableStore path: Path) throws {
            self.efi = VZEFIBootLoader()
            
            // Avoids error where bootloader creates already existing
            // EFI variable store.
            
            if path.exists() {
                self.store = VZEFIVariableStore(url: path.url)
            } else {
                self.store = try VZEFIVariableStore(creatingVariableStoreAt: path.url)
            }
            
            self.efi.variableStore = self.store
        }
    }
}
