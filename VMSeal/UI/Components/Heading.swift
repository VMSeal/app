//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Heading.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-27.
//

import Foundation
import SwiftUI

struct Heading: View {
    
    var text: String
    var level: Int
    
    private let MIN_LEVEL = 1
    private let MAX_LEVEL = 3
    
    private var font: Font {
        switch level {
        case 1:
            return .title
        case 2:
            return .title2
        default:
            return .title3
        }
    }
    
    init(_ level: Int, _ text: String) {
        self.text = text
        
        // Don't know enough Swift to know how to do this
        // idiomatically...
        
        if level < MIN_LEVEL {
            self.level = MIN_LEVEL
        } else if level > MAX_LEVEL {
            self.level = MAX_LEVEL
        } else {
            self.level = level
        }
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .bold()
    }
}
