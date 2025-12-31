//
//  SettingsView.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings = AppSettings.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .font(.title).bold()
            
            Divider()
            
            // 1. Default Volume
            VStack(alignment: .leading) {
                Text("Default Input Volume: \(Int(settings.defaultVolume * 100))%")
                Slider(value: $settings.defaultVolume, in: 0...1)
                Text("Sets the initial volume for newly added inputs.")
                    .font(.caption).foregroundColor(.gray)
            }
            
            // 2. Monitor Gain
            VStack(alignment: .leading) {
                Text("Monitor Gain Boost: \(String(format: "%.1fx", settings.monitorGain))")
                Slider(value: $settings.monitorGain, in: 1.0...30.0, step: 0.5)
                Text("Amplify headphone volume (Software Pre-Amp).")
                    .font(.caption).foregroundColor(.gray)
            }
            
            // 3. Master Gain
            VStack(alignment: .leading) {
                Text("Master Gain Boost: \(String(format: "%.1fx", settings.masterGain))")
                Slider(value: $settings.masterGain, in: 1.0...5.0, step: 0.1)
                Text("Amplify master recording volume.")
                    .font(.caption).foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.horizontal) // Add horizontal padding to the button
            }
        }
        .padding()
        .frame(width: 420, height: 380) // Slightly increased frame size
    }
}
