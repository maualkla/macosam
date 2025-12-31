//
//  AudioEngine.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

import AVFoundation
import CoreAudio
import AudioToolbox
import Foundation
import Combine // Required for ObservableObject conformance

/**
 * Component 3: Audio Engine
 * Manages the AVAudioEngine instance, graph setup, and core audio routing.
 */
class AudioEngine: ObservableObject {
    
    // Published status for UI feedback
    @Published var isRunning: Bool = false
    
    // Core engine components
    private let engine = AVAudioEngine()
    private let mixer = AVAudioMixerNode()
    // The activeInputNode reference from the plan is no longer strictly needed
    // since we use engine.inputNode, but we will leave the previous property definitions
    // as placeholders for later multi-input development (Phase 3).
    // private var activeInputNode: AVAudioInputNode? // Placeholder for future expansion
    
    init() {
        // Setup the basic graph: Mixer -> OutputNode
        engine.attach(mixer)
        engine.connect(mixer, to: engine.outputNode, format: nil)
    }
    
    // MARK: - Control Functions
    
    /**
     * Attempts to start the engine. Must be called after configuration.
     * Stops the engine first to ensure a clean state before starting.
     */
    func start() throws {
        engine.stop() // Always stop before starting to clear the state
        
        do {
            try engine.start()
            self.isRunning = true
            print("Audio Engine started successfully.")
        } catch {
            print("Error starting audio engine: \(error.localizedDescription)")
            self.isRunning = false
            throw error
        }
    }
    
    func stop() {
        engine.stop()
        self.isRunning = false
        print("Audio Engine stopped.")
    }

    /**
     * Sets the master output device (Virtual Device B) using Core Audio.
     * Does NOT start the engine.
     */
    func setMasterOutputDevice(device: AudioDevice) throws {
        // Must be stopped before low-level configuration
        engine.stop()
        
        let outputAudioUnit = engine.outputNode.audioUnit!
        var outputDeviceID = device.id
        
        // Use Core Audio to tell the output unit which physical/virtual device to use.
        let status = AudioUnitSetProperty(
            outputAudioUnit,
            kAudioOutputUnitProperty_CurrentDevice,
            kAudioUnitScope_Global,
            0,
            &outputDeviceID,
            UInt32(MemoryLayout<AudioObjectID>.size)
        )
        
        guard status == kAudioHardwareNoError else {
            print("Error setting output device: \(status). Did you install the virtual audio driver?")
            throw NSError(domain: "AudioEngine", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to set output device ID."])
        }
        
        print("Master output configuration complete for: \(device.name)")
    }
    
    /**
     * Adds a single input device (Mic 1) using the engine's input node and Core Audio.
     * Does NOT start the engine.
     */
    func addInputDevice(device: AudioDevice) throws {
        // Must be stopped before reconfiguring the graph
        engine.stop()

        // 1. Use the engine's built-in input node (only way to access hardware)
        let inputNode = engine.inputNode
        
        // 2. Disconnect any existing routing from the input node
        engine.disconnectNodeInput(inputNode)
        
        // 3. Set the device ID using Core Audio on the input node's AudioUnit
        let inputAudioUnit = inputNode.audioUnit!
        var inputDeviceID = device.id
        
        let status = AudioUnitSetProperty(
            inputAudioUnit,
            kAudioOutputUnitProperty_CurrentDevice, // Same selector for output or input units!
            kAudioUnitScope_Global,
            0,
            &inputDeviceID,
            UInt32(MemoryLayout<AudioObjectID>.size)
        )
        
        guard status == kAudioHardwareNoError else {
            print("Error setting input device: \(status)")
            throw NSError(domain: "AudioEngine", code: Int(status), userInfo: [NSLocalizedDescriptionKey: "Failed to set input device ID."])
        }

        // 4. Connect the input node to the mixer
        let format = inputNode.outputFormat(forBus: 0) // Use outputFormat for the input node's output
        engine.connect(inputNode, to: mixer, fromBus: 0, toBus: 0, format: format)
        
        print("Input device configuration complete for: \(device.name)")
    }
}
