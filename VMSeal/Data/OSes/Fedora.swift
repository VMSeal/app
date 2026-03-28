//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Fedora.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-10.
//

import Foundation

let Fedora = VM.Guest(
    name: "Fedora",
    urls: [
        .Intel:
            "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Workstation/x86_64/iso/Fedora-Workstation-Live-43-1.6.x86_64.iso",
        .Silicon: "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Workstation/aarch64/iso/Fedora-Workstation-Live-43-1.6.aarch64.iso"
            
    ],
    sha256sums: [
        .Intel: SHA256Sum("2a4a16c009244eb5ab2198700eb04103793b62407e8596f30a3e0cc8ac294d77"),
        .Silicon: SHA256Sum("73e91eb64022b59ed0b19fb706dc2053034dc0abbaec03f59fc7754a29777cfb")
    ]
)
