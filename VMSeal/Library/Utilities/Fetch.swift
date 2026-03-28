//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Fetch.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-16.
//

import Foundation

func fetch(from sourceURL: URL, saveTo storageLocation: Path) async throws -> Void {
    let (tmp, _) = try await URLSession.shared.download(from: sourceURL)
    
    do {
        try FileManager.default.moveItem(
            at: tmp,
            to: storageLocation.url
        )
    } catch {
        return // do something
    }
}
