//
//  AppSettings.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

import Foundation
import Combine

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var defaultVolume: Double {
        didSet {
            UserDefaults.standard.set(defaultVolume, forKey: "defaultVolume")
        }
    }
    
    @Published var monitorGain: Double {
        didSet {
            UserDefaults.standard.set(monitorGain, forKey: "monitorGain")
        }
    }
    
    @Published var masterGain: Double {
        didSet {
            UserDefaults.standard.set(masterGain, forKey: "masterGain")
        }
    }
    
    private init() {
        // Load from UserDefaults or use defaults
        // Note: We use 'object(forKey:)' to check for existence, falling back if nil
        let defaults = UserDefaults.standard
        
        self.defaultVolume = defaults.object(forKey: "defaultVolume") as? Double ?? 0.25
        self.monitorGain = defaults.object(forKey: "monitorGain") as? Double ?? 15.0
        self.masterGain = defaults.object(forKey: "masterGain") as? Double ?? 1.0
    }
}