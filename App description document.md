# macOS Audio Mixer - App Description & User Manual

## 1. Application Description

**macOS Audio Mixer** is a lightweight, powerful utility designed for podcasters, streamers, and content creators on macOS. It acts as a bridge between your physical hardware (microphones, instruments) and your system's audio, allowing you to mix them into a single, clean feed for recording or broadcasting.

### Key Features
*   **Multi-Source Mixing:** Combine multiple microphones and virtual audio sources into one mix.
*   **System Audio Capture:** Easily integrate your Mac's system sound (calls, game audio, music) into your stream using virtual drivers like BlackHole.
*   **Dual Output Architecture:** 
    *   **Master Output:** The final mix sent to your streaming software (OBS, Zoom, etc.).
    *   **Monitor Output:** A separate feed for your headphones, allowing you to hear exactly what your audience hears without latency loops.
*   **Real-Time Control:** Adjust volume levels and mute status for every input independently.
*   **Settings Persistence:** Your preferences for gain and volume levels are saved automatically.

### System Requirements
*   **OS:** macOS 12.0 (Monterey) or later.
*   **Hardware:** Apple Silicon or Intel Mac.
*   **Dependency:** A virtual audio driver (e.g., [BlackHole 2ch](https://github.com/ExistentialAudio/BlackHole)) is strongly recommended to utilize the full routing capabilities.

---

## 2. User Manual

### Part 1: Initial Setup

1.  **Install a Virtual Driver:**
    To capture system audio or route the final mix into apps like Zoom or Discord, you need a "virtual cable." We recommend installing **BlackHole 2ch**.
    *   *Download:* [Existential Audio / BlackHole](https://github.com/ExistentialAudio/BlackHole)
    *   *Install:* Follow the installer instructions.

2.  **Launch the App:**
    Unzip `macOSAudioMixer.zip` and drag `macOSAudioMixer.app` to your Applications folder. Double-click to open.

3.  **Grant Permissions:**
    On first launch, macOS will ask for **Microphone Access**. You **must** click "Allow" for the mixer to function. This permission allows the app to "hear" your microphones and the virtual driver.

### Part 2: Interface Overview

The main window is divided into three sections:

*   **Inputs (Left/Center):** A list of all connected audio devices.
*   **Master Output (Bottom):** The destination where the final mixed audio is sent.
*   **Monitor Output (Bottom):** The device (usually headphones) where you listen to the mix.

### Part 3: Step-by-Step Usage Guide

#### Scenario: Streaming a Game/Call with a Microphone

**Step 1: Route System Audio**
Before opening your streaming software, go to macOS **System Settings > Sound > Output** and select **BlackHole 2ch**.
*   *What this does:* It sends all computer sound (Spotify, Game, Zoom) into the BlackHole driver instead of your speakers.

**Step 2: Configure the Mixer Inputs**
Open **macOS Audio Mixer**.
1.  Find **BlackHole 2ch** in the list and check the box to enable it. (This picks up the game/music audio from Step 1).
2.  Find your **USB Microphone** in the list and check the box.
3.  Use the **Sliders** to balance the volume. For example, lower the Game audio so your Voice is clearer.

**Step 3: Set the Outputs**
1.  **Master Output:** Select a destination.
    *   *If recording in OBS:* You can often leave this as a different virtual cable (e.g., BlackHole 16ch) or simply use the Monitor if OBS captures Desktop Audio.
    *   *Simple Setup:* Select **BlackHole 16ch** (if installed) or another virtual device to act as the "Microphone" input in Discord/Zoom.
2.  **Monitor Output:** Select your **Headphones**.
    *   *Crucial:* This allows you to hear the Game Audio (which is currently silent to your ears because of Step 1) and your own voice mixed together.

**Step 4: Stream/Record**
In your target software (OBS, Zoom, Audacity):
*   Select the device you chose as the **Master Output** as your Input Source / Microphone.

### Part 4: Troubleshooting

**Q: I don't hear any sound.**
*   Check that the **Monitor Output** is set to your headphones.
*   Ensure the **Mute** button (speaker icon) is not active (red) for the input channels.
*   Verify volume sliders are up.

**Q: My friends on Discord hear themselves (Echo).**
*   This happens if you mix the "System Audio" (which includes their voice) back into the "Master Output" (which acts as your microphone).
*   *Fix:* Use a more advanced setup with two virtual cables (one for Game Audio, one for Chat Audio) and only check the "Game Audio" box in the Mixer.

**Q: The app crashes or shows an error on start.**
*   Ensure you have granted Microphone permissions in **System Settings > Privacy & Security > Microphone**.
