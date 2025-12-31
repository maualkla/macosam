//
//  AudioDevice.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

import CoreAudio
import Foundation

/**
 * Part of Component 2: Device Manager
 * A model struct representing a Core Audio device.
 */
struct AudioDevice: Identifiable, Hashable {
    // Unique identifier for use in SwiftUI lists and Core Audio calls
    let id: AudioObjectID
    // Human-readable name
    let name: String
    // For convenience: is it an input device?
    let isInput: Bool
    
    // Conformance to Hashable
    static func == (lhs: AudioDevice, rhs: AudioDevice) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
