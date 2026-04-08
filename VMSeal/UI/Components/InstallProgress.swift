//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  InstallProgress.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-04-08.
//

import SwiftUI

struct InstallProgress: View {
    
    @Binding var progress: Double
    @Binding var status: VM.Installer.Status?
    
    var body: some View {
        VStack {
            if progress >= 0 {
                ProgressView(value: progress)
                Text(status?.rawValue ?? "Working on it...")
            } else {
                ProgressView()
                Text("Please be patient, this may take a while...")
            }
        }
        .padding(10)
    }
}
