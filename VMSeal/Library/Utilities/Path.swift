//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Path.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-05.
//

import Foundation

struct URLConversionFromStringError: LocalizedError {
    var errorDescription: String {
        return NSLocalizedString("Failed to convert a string to an URL.", comment: "")
    }
}

struct PathReadError: LocalizedError {
    
    var filename: String
    
    var errorDescription: String {
        return NSLocalizedString("Failed to read from file '\(filename)'!", comment: "")
    }
}

struct PathWriteError: LocalizedError {
    
    var filename: String
    
    var errorDescription: String {
        return NSLocalizedString("Failed to write to file '\(filename)'!", comment: "")
    }
}

struct PathMakeDirectoryError: LocalizedError {
    var path: String
    
    var errorDescription: String {
        return NSLocalizedString("Failed to create directory at '\(path)'!", comment: "")
    }
}

struct PathNotExists: LocalizedError {
    var path: String
    
    var errorDescription: String {
        return NSLocalizedString("Path '\(path)' does not exist!", comment: "")
    }
}

struct Path {
    static func read(path: Path, encoding: String.Encoding = .utf8) throws -> String {
        guard let rv = try? String(contentsOf: path.url, encoding: encoding) else {
            throw PathReadError(filename: path.stringified)
        }
        
        return rv
    }
    
    static func write(
        path: Path,
        content: String = "",
        encoding: String.Encoding = .utf8
    ) throws -> Void {
        do {
            try content.write(
                toFile: path.stringified,
                atomically: false,
                encoding: encoding
            )
        } catch {
            throw PathWriteError(filename: path.stringified)
        }
    }
    
    static func mkdir(
        path: Path,
        withIntermediateDirectories: Bool = false,
    ) throws -> Void {
        do {
            try FileManager.default.createDirectory(
                atPath: path.stringified,
                withIntermediateDirectories: withIntermediateDirectories
            )
        } catch {
            throw PathMakeDirectoryError(path: path.stringified)
        }
    }
    
    // The core functionality of the public `resolve` member.
    static private func baseResolve(_ prefix: URL, _ components: [String]) -> URL {
        var url = prefix
        
        for component in components {
            url.appendPathComponent(component)
        }
        
        return url
    }
    
    func exists() -> Bool {
        FileManager.default.fileExists(atPath: self.stringified)
    }
    
    func remove() throws -> Void {
        try FileManager.default.removeItem(at: self.url)
    }
    
    func move(to destination: Path) throws -> Void {
        try FileManager.default.moveItem(at: self.url, to: destination.url)
    }
    
    func checksum(binary: Bool = false) throws -> SHA256Sum {
        if !self.exists() {
            throw PathNotExists(path: self.stringified)
        }
        
        var contents: Data
        
        if binary {
            contents = try Data(contentsOf: self.url)
        } else {
            contents = Data(
                try Path.read(path: self, encoding: .utf8)
                    .utf8
            )
        }
        
        let sha256sum = SHA256Sum(from: contents)
        
        return sha256sum
    }
    
    struct Places {
        // Home directory of the app.
        static var app: Path {
            guard let path = try? Path(from: NSHomeDirectory()) else {
                fatalError(
                    "Sandbox's home directory is not available; if you're getting this error,\n"
                    + "your system is in need of help... or, there's a bug in the app."
                )
            }
            
            return path
        }
        
        static var documents: Path {
            Path(from: FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask)[0])
        }
        
        static var vms: Path {
            let path = Path(self.documents, "VMs")
            
            if !path.exists() {
                try? Path.mkdir(path: path, withIntermediateDirectories: true)
            }
            
            return path
        }
        
        static var isos: Path {
            let path = Path(documents, "ISOs")
            
            if !path.exists() {
                try? Path.mkdir(path: path, withIntermediateDirectories: true)
            }
            
            return path
        }
    }
    
    // ------------------
    // --- NON-STATIC ---
    // ------------------
    
    let url: URL
    
    var stringified: String {
        self.url.path()
    }
    
    init(from source: URL) {
        self.url = source
    }
    
    init(from source: String) throws {
        self.url = URL(fileURLWithPath: source)
    }
    
    init(_ components: String...) throws {
        
        if components.count < 1 {
            fatalError("Internal error: At least one component must be passed to the initialiser!")
        }
        
        let first = URL(fileURLWithPath: components.first!)
        
        var rest = components
        rest.removeFirst()
        
        self.url = Path.baseResolve(first, rest)
    }
    
    init(_ first: URL, _ components: String...) {
        self.url = Path.baseResolve(first, components)
    }
    
    init(_ first: Path, _ components: String...) {
        self.url = Path.baseResolve(first.url, components)
    }
    
    init(_ first: Path, _ components: Path...) {
        self.url = Path.baseResolve(first.url, components.map { $0.stringified })
    }
}
