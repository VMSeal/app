//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Bridge.h
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-15.
//

#ifndef BRIDGE_H
#define BRIDGE_H

typedef enum {
    INTEL_BASED = 0,
    APPLE_SILICON = 1,
    UNKNOWN_ARCHITECTURE = -1
} SystemArchitecture;

SystemArchitecture getArchitecture(void);

#endif
