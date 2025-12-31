//
//  ContentView.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

// MARK: - ContentView.swift (to be modified)

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MixerViewModel()
    @State private var showPermissionAlert = false
    
    // NEW: State variable to track permission status for UI updates
    @State private var micPermissionStatus: PermissionsManager.MicPermissionStatus = .notDetermined
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("🎧 macOS Audio Mixer Setup")
                .font(.largeTitle).bold()

            // --- 1. Permissions Check ---
            // If status is not granted, show the request button and guides.
            if micPermissionStatus != .granted {
                
                Button("Request Microphone Permission") {
                    PermissionsManager.requestPermission { granted in
                        // Update the state variable after the request
                        self.micPermissionStatus = granted ? .granted : .denied
                        if !granted { self.showPermissionAlert = true }
                    }
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(8)
                .alert("Permission Required", isPresented: $showPermissionAlert) {
                    // Corrected Button syntax for macOS alert:
                    Button(role: .cancel) { } label: { Text("OK") }
                } message: {
                    Text("Microphone access is essential for this app to capture audio. Please grant permission in System Settings > Privacy & Security > Microphone.")
                }
                
                Divider()
                
            } else {
                // --- 2. Device Pickers (The Selectors!) ---
                
                // Input Device Picker
                Picker("Source Microphone", selection: $viewModel.selectedInputDevice) {
                    Text("None Selected").tag(nil as AudioDevice?)
                    ForEach(viewModel.deviceManager.inputDevices) { device in
                        Text("🎙️ \(device.name)").tag(device as AudioDevice?)
                    }
                }
                .pickerStyle(.menu)
                
                // Master Output Device Picker
                Picker("Master Output (Send Mix To)", selection: $viewModel.selectedOutputDevice) {
                    Text("None Selected").tag(nil as AudioDevice?)
                    ForEach(viewModel.deviceManager.outputDevices) { device in
                        Text("🔊 \(device.name)").tag(device as AudioDevice?)
                    }
                }
                .pickerStyle(.menu)
                
                Spacer()
                
                Text("Configuration Note:")
                    .font(.headline)
                Text("Select your microphone above, and select your virtual audio cable (e.g., 'BlackHole') as the Master Output. You must also set your recording software (OBS/Audacity) to use the same virtual cable as its input source.")
                    .font(.caption)
            }
            
        }
        .padding()
        // Check permission on launch and update the state variable
        .onAppear {
            self.micPermissionStatus = PermissionsManager.getStatus()
            if self.micPermissionStatus == .notDetermined {
                // Trigger request if not determined
                PermissionsManager.requestPermission { granted in
                    self.micPermissionStatus = granted ? .granted : .denied
                }
            }
        }
    }
}
