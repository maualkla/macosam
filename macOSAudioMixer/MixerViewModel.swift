//
//  MixerViewModel.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

// MARK: - MixerViewModel.swift (Final Phase 2 Fix)

import Foundation
import Combine

class MixerViewModel: ObservableObject {
    
    @Published var deviceManager = DeviceManager()
    @Published var audioEngine = AudioEngine()
    
    // Track selected devices
    @Published var selectedInputDevice: AudioDevice?
    @Published var selectedOutputDevice: AudioDevice?
    
    private var cancellables = Set<AnyCancellable>() // Move this up

    // MARK: - MixerViewModel.swift (TEST INITIATOR)

    init() {
        // 1. Subscription to automatically select the FIRST device IF it exists. (Comment out these blocks)
        // deviceManager.$inputDevices.filter...
        // deviceManager.$outputDevices.filter...

        // MANUAL TEST SETUP: Create dummy devices using typical IDs (You can substitute BlackHole IDs if known)
        let testMic = AudioDevice(id: 42, name: "Test Built-in Mic", isInput: true) // ID 42 is often the Built-in Mic
        let testOutput = AudioDevice(id: 46, name: "Test Built-in Speakers", isInput: false) // ID 46 is often the Built-in Speakers

        // 2. Controlled Engine Configuration
        Publishers.CombineLatest($selectedInputDevice, $selectedOutputDevice)
            .compactMap { (input, output) -> (AudioDevice, AudioDevice)? in
                // FOR MANUAL TEST: Check if the devices are already set, otherwise use test devices.
                let finalInput = input ?? testMic
                let finalOutput = output ?? testOutput
                
                // Immediately assign the test devices to trigger the configuration
                DispatchQueue.main.async {
                    self.selectedInputDevice = finalInput
                    self.selectedOutputDevice = finalOutput
                }
                
                // Only proceed if the manual devices are being used
                return (finalInput, finalOutput)
            }
            .sink { [weak self] (input, output) in
                guard let self = self else { return }
                
                // This is the core logic that attempts to use the Core Audio IDs
                do {
                    try self.audioEngine.setMasterOutputDevice(device: output)
                    try self.audioEngine.addInputDevice(device: input)
                    
                    try self.audioEngine.start()
                    print("✅ Engine Fully Configured and Started using TEST IDs!")

                } catch {
                    print("ViewModel Configuration/Start ERROR: \(error)")
                    self.audioEngine.stop()
                }
            }
            .store(in: &cancellables)
    }
}
