//
//  PermissionsManager.swift
//  macOSAudioMixer
//
//  Created by Mauricio Alcala on 05/12/25.
//

import AVFoundation // We keep AVFoundation for AVCaptureDevice access
import AppKit      // Often needed for system interactions on macOS

/**
 * Component 1: Permissions Manager (Corrected for macOS)
 * Handles checking and requesting microphone access.
 */
class PermissionsManager {
    
    enum MicPermissionStatus {
        case granted
        case denied
        case notDetermined
    }
    
    // Check the current permission status using AVCaptureDevice
    static func getStatus() -> MicPermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        print(" Getting status.....")
        print(status.rawValue)
        switch status {
        case .authorized:
            return .granted
        case .denied, .restricted:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .denied
        }
    }
    
    // Request microphone access using AVCaptureDevice
    // Note: The prompt is typically triggered the first time a device is used.
    // This function can proactively trigger the request.
    static func requestPermission(completion: @escaping (Bool) -> Void) {
        // AVCaptureDevice provides a static function to request authorization
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            // Ensure the completion handler runs on the main thread for UI updates
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
