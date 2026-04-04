//
//  +---------------------------------------------------------+
//  | Copyright (c) 2026 Axel H. Karlsson and contributors.   |
//  |                                                         |
//  | This file is licenced under the BSD 3-clause licence;   |
//  | see the LICENSE file in the project's source directory. |
//  +---------------------------------------------------------+
//
//  Audio.swift
//  VMSeal
//
//  Created by Axel H. Karlsson on 2026-03-31.
//

import Foundation
import Virtualization

extension Device {
    class Audio: Configurable {
        let device: VZVirtioSoundDeviceConfiguration
        let stream: VZVirtioSoundDeviceOutputStreamConfiguration
        let sink: VZHostAudioOutputStreamSink
        
        func configure(configuration: VZVirtualMachineConfiguration) throws -> Void {
            configuration.audioDevices.append(self.device)
        }
        
        init() {
            self.device = VZVirtioSoundDeviceConfiguration()
            self.stream = VZVirtioSoundDeviceOutputStreamConfiguration()
            self.sink = VZHostAudioOutputStreamSink()
            
            self.stream.sink = self.sink
            
            self.device.streams = [self.stream]
        }
    }
}
