//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  JSON.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-26.
//

import Foundation

struct JSON {
    static func encode<T: Codable>(from object: T) throws -> String {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(object)
        
        return String(data: encoded, encoding: .utf8) ?? "{}"
    }
    
    static func decode<T: Codable>(at path: Path) throws -> T {
        if !path.exists() {
            throw PathNotExists(path: path.stringified)
        }
        
        let blob = Data(
            try Path.read(path: path).utf8
        )
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(
            T.self,
            from: blob
        )
        
        return decoded
    }
}
