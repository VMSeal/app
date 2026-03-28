//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Architecture.c
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-02-15.
//

#include <sys/utsname.h>
#include <string.h>

#include "Bridge.h"

SystemArchitecture getArchitecture(void) {
    struct utsname systemInfo;
    
    int rv = uname(&systemInfo);
    
    if (rv != 0) {
        return UNKNOWN_ARCHITECTURE;
    }
    
    char *architecture = systemInfo.machine;
    
    if (strcmp(architecture, "x86_64") == 0) {
        return INTEL_BASED;
    }
    
    if (strcmp(architecture, "arm64")) {
        return APPLE_SILICON;
    }
    
    return UNKNOWN_ARCHITECTURE;
}
