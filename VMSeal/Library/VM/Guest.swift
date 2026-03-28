//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Guest.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-22.
//


import Foundation

extension VM {
    struct Guest: Identifiable, Hashable, Codable {
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        // ------------------------------------------------------
        
        let name: String
        
        private let urls: [Architecture.Chip : String]
        private let sha256sums: [Architecture.Chip : SHA256Sum]
        
        init(name: String, urls: [Architecture.Chip : String], sha256sums: [Architecture.Chip : SHA256Sum]) {
            self.name = name
            
            self.urls = urls
            self.sha256sums = sha256sums
        }
        
        // Getter which returns the appropriate download URL
        // for the end user's architecture.
        var url: URL {
            // If the URL is nil, we have bigger issues.
            // It must surely be better to die quickly than
            // let runtime bugs linger around...
            URL(
                string: self.urls[Architecture.host]!
            )!
        }
        
        // Getter which returns the appropriate checksum of
        // the downloaded ISO for the end user's architecture.
        var sha256sum: SHA256Sum {
            self.sha256sums[Architecture.host]!
        }
        
        var image: Path {
            Path(
                Path.Places.isos,
                "\(self.name).iso"
            )
        }
        
        var id: String {
            self.name
        }
    }
}

func download(_ guest: VM.Guest) async throws -> Path {
    let iso = guest.image
    
    if iso.exists() {
        try iso.remove()
    }
    
    try await fetch(
        from: guest.url,
        saveTo: iso
    )
    
    return iso
}

func verify(_ guest: VM.Guest) throws -> Bool {
    let checksum = try guest.image.checksum(
        binary: true
    )
    
    return guest.sha256sum.matches(checksum)
}
