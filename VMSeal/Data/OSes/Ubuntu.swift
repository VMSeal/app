//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Ubuntu.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-22.
//

let Ubuntu = VM.Guest(
    name: "Ubuntu",
    urls: [
        .Intel:
            "https://releases.ubuntu.com/25.10/ubuntu-25.10-desktop-amd64.iso",
        .Silicon: "https://cdimage.ubuntu.com/releases/25.10/release/ubuntu-25.10-desktop-arm64.iso"
            
    ],
    sha256sums: [
        .Intel: SHA256Sum("32e30d72ae4798c633323a2684d94a11582bb03a6ab38d2b0d5ae5eabc5e577b"),
        .Silicon: SHA256Sum("9d383dd57220dec520fdec3be05da258d27d435c02fe6e296c5d0a505741a787")
    ]
)
