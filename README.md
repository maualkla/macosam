# macOS Audio Mixer

![macOS Version](https://img.shields.io/badge/platform-macOS-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

**macOS Audio Mixer** is a high-performance audio routing and mixing utility for macOS. It allows you to combine multiple hardware and virtual audio inputs (Microphones, Loopbacks) into a single unified stream, which can then be used as a source for streaming, recording, or video conferencing applications.

## 🚀 Key Features

- **Multi-Engine Architecture:** Optimized Dual-Engine design to prevent Core Audio shared unit crashes.
- **Low Latency Mixing:** Real-time software mixing of $N$ audio sources.
- **Independent Monitoring:** Route your mix to a Master Output while simultaneously listening through a dedicated Monitor Output.
- **Custom Gain Controls:** Per-channel volume sliders, mutes, and master/monitor gain boosts.
- **Hot-Plugging Support:** Automatically detects and updates device lists when hardware is connected or removed.
- **Persistent Settings:** Automatically saves and restores your volume levels and gain configurations.

## 🛠 Prerequisites

To use this app to its full potential (e.g., capturing system audio), you will need a virtual audio driver. We recommend:
- [BlackHole](https://github.com/ExistentialAudio/BlackHole) (Free, Open Source)

## 📦 Installation

1. Download the latest `macOSAudioMixer.zip` from the [Releases](https://github.com/YOUR_USERNAME/macOS_OAM/releases) page.
2. Unzip the file.
3. Drag `macOS Audio Mixer.app` to your `/Applications` folder.
4. Open the app and grant **Microphone Permissions** when prompted.

## 📖 Usage Guide

For a detailed walkthrough on how to set up complex routing (e.g., mixing game audio + microphone for OBS), please refer to the [App Description & User Manual](App%20description%20document.md).

## 🔨 Development & Build

If you want to build the app from source:

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/macOS_OAM.git
   cd macOS_OAM/macOSAudioMixer
   ```
2. Open `macOSAudioMixer.xcodeproj` in Xcode 15+.
3. Select the `macOSAudioMixer` scheme and your Mac as the destination.
4. Build and Run (`Cmd + R`).

### Generate Shareable Build (CLI)
```bash
# Archive
xcodebuild -scheme macOSAudioMixer -project macOSAudioMixer/macOSAudioMixer.xcodeproj -configuration Release archive -archivePath ./build/macOSAudioMixer.xcarchive

# Package
mkdir -p dist
cp -R "build/macOSAudioMixer.xcarchive/Products/Applications/macOSAudioMixer.app" dist/
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
*Created by [maualkla](https://github.com/maualkla)*
