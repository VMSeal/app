//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Notice.swift
//  VMSeal
//
//  Created by Developer on 2026-03-23.
//

import SwiftUI

struct Notice: View {
    
    var title: String
    var subtitle: String?
    
    private let fontSize: CGFloat = 20
    
    var body: some View {
        VStack {
            Text(title)
                .font(.system(size: fontSize))
                .fontWeight(.bold)
            
            Text(subtitle ?? "")
        }
    }
}
