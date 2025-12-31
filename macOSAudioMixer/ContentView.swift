//
//  ContentView.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MixerViewModel()
    @State private var showPermissionAlert = false
    @State private var micPermissionStatus: PermissionsManager.MicPermissionStatus = .notDetermined
    @State private var showSettings = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack {
                Text("🎧 macOS Audio Mixer Setup")
                    .font(.largeTitle).bold()
                Spacer()
                Button(action: { showSettings = true }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }

            if micPermissionStatus != .granted {
                permissionRequestView
            } else {
                mainControlView
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 650)
        .onAppear {
            checkPermissions()
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
    
    // MARK: - Subviews
    
    var permissionRequestView: some View {
        VStack(alignment: .leading) {
            Button("Request Microphone Permission") {
                PermissionsManager.requestPermission { granted in
                    self.micPermissionStatus = granted ? .granted : .denied
                    if !granted { self.showPermissionAlert = true }
                }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            .alert("Permission Required", isPresented: $showPermissionAlert) {
                Button(role: .cancel) { } label: { Text("OK") }
            } message: {
                Text("Microphone access is essential for this app to capture audio. Please grant permission in System Settings > Privacy & Security > Microphone.")
            }
        }
    }
    
    var mainControlView: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // --- Output Section ---
            VStack(alignment: .leading) {
                Text("1. Output Destinations")
                    .font(.headline)
                
                HStack(alignment: .top) {
                    // Master Output
                    VStack(alignment: .leading) {
                        Text("Master Output (Recording)")
                            .font(.caption).foregroundColor(.gray)
                        Picker("", selection: $viewModel.selectedOutputDevice) {
                            Text("Select Output...").tag(nil as AudioDevice?)
                            ForEach(viewModel.deviceManager.outputDevices) { device in
                                Text("🔊 \(device.name)").tag(device as AudioDevice?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        // Master Volume Slider & Mute
                        HStack {
                            Button(action: { viewModel.toggleMasterMute() }) {
                                Image(systemName: viewModel.isMasterMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .foregroundColor(viewModel.isMasterMuted ? .red : .gray)
                                    .frame(width: 20)
                            }
                            .buttonStyle(.plain)
                            
                            Slider(value: Binding(
                                get: { viewModel.masterVolume },
                                set: { viewModel.setMasterVolume($0) }
                            ), in: 0...1)
                            .frame(width: 100)
                            .disabled(viewModel.isMasterMuted)
                        }
                        .disabled(viewModel.selectedOutputDevice == nil)
                    }
                    
                    Spacer()
                    
                    // Monitor Output
                    VStack(alignment: .leading) {
                        Text("Monitor Output (Headphones)")
                            .font(.caption).foregroundColor(.gray)
                        Picker("", selection: $viewModel.selectedMonitorDevice) {
                            Text("No Monitor (Mute)").tag(nil as AudioDevice?)
                            ForEach(viewModel.deviceManager.outputDevices) { device in
                                Text("🎧 \(device.name)").tag(device as AudioDevice?)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        // Monitor Volume Slider & Mute
                        HStack {
                            Button(action: { viewModel.toggleMonitorMute() }) {
                                Image(systemName: viewModel.isMonitorMuted ? "speaker.slash.fill" : "headphones")
                                    .foregroundColor(viewModel.isMonitorMuted ? .red : .gray)
                                    .frame(width: 20)
                            }
                            .buttonStyle(.plain)
                            
                            Slider(value: Binding(
                                get: { viewModel.monitorVolume },
                                set: { viewModel.setMonitorVolume($0) }
                            ), in: 0...1)
                            .frame(width: 100)
                            .disabled(viewModel.isMonitorMuted)
                        }
                        .disabled(viewModel.selectedMonitorDevice == nil)
                    }
                }
            }
            
            Divider()
            
            // --- Input Section ---
            Text("2. Input Sources (Mix Inputs)")
                .font(.headline)
            
            Text("Select multiple microphones or loopback devices to mix them together.")
                .font(.caption)
                .foregroundColor(.gray)
            
            List {
                if viewModel.deviceManager.inputDevices.isEmpty {
                    Text("No input devices found.").foregroundColor(.gray)
                } else {
                    ForEach(viewModel.deviceManager.inputDevices) { device in
                        DeviceRow(device: device, viewModel: viewModel)
                    }
                }
            }
            .listStyle(.inset)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            
            Spacer()
            
            // --- Info ---
            VStack(alignment: .leading, spacing: 8) {
                Text("How to Capture System Audio:")
                    .font(.headline)
                Text("1. Install 'BlackHole' (Virtual Driver).")
                Text("2. Set Mac System Output -> BlackHole 2ch.")
                Text("3. Check 'BlackHole 2ch' in the Input list above.")
                Text("4. Set 'Master Output' to your Recording Cable (e.g. VB-Cable).")
                Text("5. Set 'Monitor Output' to your Headphones to hear everything.")
            }
            .font(.caption)
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Helpers
    
    func checkPermissions() {
        self.micPermissionStatus = PermissionsManager.getStatus()
        if self.micPermissionStatus == .notDetermined {
            PermissionsManager.requestPermission { granted in
                self.micPermissionStatus = granted ? .granted : .denied
            }
        }
    }
}

// MARK: - Extracted Subview for Optimization
struct DeviceRow: View {
    let device: AudioDevice
    @ObservedObject var viewModel: MixerViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Checkbox
            Toggle(isOn: Binding(
                get: { viewModel.isSelected(device) },
                set: { _ in viewModel.toggleInput(device) }
            )) {
                Text("🎙️ \(device.name)")
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .toggleStyle(.checkbox)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Volume Controls (Only show if active)
            if viewModel.isSelected(device) {
                
                // Mute Button
                Button(action: { viewModel.toggleInputMute(for: device) }) {
                    Image(systemName: viewModel.isInputMuted(for: device) ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.caption)
                        .foregroundColor(viewModel.isInputMuted(for: device) ? .red : .gray)
                        .frame(width: 20)
                }
                .buttonStyle(.plain)
                
                // Volume Slider
                Slider(
                    value: Binding(
                        get: { viewModel.getInputVolume(for: device) },
                        set: { newVal in viewModel.setInputVolume(for: device, volume: newVal) }
                    ),
                    in: 0...1
                )
                .frame(width: 120)
                .disabled(viewModel.isInputMuted(for: device))
                
                // Volume % Label
                Text("\(Int(viewModel.getInputVolume(for: device) * 100))%")
                    .font(.caption)
                    .monospacedDigit()
                    .frame(width: 35, alignment: .trailing)
                    .foregroundColor(viewModel.isInputMuted(for: device) ? .gray.opacity(0.5) : .primary)
            }
        }
        .padding(.vertical, 4)
    }
}