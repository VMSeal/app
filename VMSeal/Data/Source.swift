//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Source.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-04-13.
//

import Foundation

/** Creates a `URL` object from a string, guaranteeing it won't be nil by throwing an error if invalid. */
private func constructURL(from string: String) throws -> URL {
    guard let url = URL(string: string) else {
        throw URLConversionFromStringError()
    }
    
    return url
}

struct Source: Codable, Hashable, Identifiable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    let name: String
    let urls: [Architecture.Chip : URL]
    let checksums: [Architecture.Chip : SHA256Sum]
    
    /** Returns the appropriate URL to fetch the ISO for the end-user's architecture */
    var url: URL {
        urls[Architecture.host]!
    }
    
    /** Returns the appropriate checksum of the ISO for the end-user's architecture */
    var checksum: SHA256Sum {
        checksums[Architecture.host]!
    }
    
    var id: String { name }
}

extension Source {
    static var all: [Source] {
        do {
            return try [
                Source(
                    name: "Fedora",
                    urls: [
                        .Intel: constructURL(from: "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Workstation/x86_64/iso/Fedora-Workstation-Live-43-1.6.x86_64.iso"),
                        .Silicon: constructURL(from: "https://download.fedoraproject.org/pub/fedora/linux/releases/43/Workstation/aarch64/iso/Fedora-Workstation-Live-43-1.6.aarch64.iso")
                    ],
                    checksums: [
                        .Intel: SHA256Sum("2a4a16c009244eb5ab2198700eb04103793b62407e8596f30a3e0cc8ac294d77"),
                        .Silicon: SHA256Sum("73e91eb64022b59ed0b19fb706dc2053034dc0abbaec03f59fc7754a29777cfb")
                    ]
                ),
                Source(
                    name: "Ubuntu",
                    urls: [
                        .Intel: constructURL(from: "https://releases.ubuntu.com/25.10/ubuntu-25.10-desktop-amd64.iso"),
                        .Silicon: constructURL(from: "https://cdimage.ubuntu.com/releases/25.10/release/ubuntu-25.10-desktop-arm64.iso")
                    ],
                    checksums: [
                        .Intel: SHA256Sum("32e30d72ae4798c633323a2684d94a11582bb03a6ab38d2b0d5ae5eabc5e577b"),
                        .Silicon: SHA256Sum("9d383dd57220dec520fdec3be05da258d27d435c02fe6e296c5d0a505741a787")
                    ]
                )
            ]
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }
}
