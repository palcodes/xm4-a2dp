# xm4-a2dp
Automatically reconnect XM4s and force A2DP card profile. ( linux )

## Problem
Sony XM4 often defaults to HSP/HFP (phone quality) instead of A2DP (music quality) when reconnecting.

## Solution
This script:
1. Disconnects the headset
2. Reconnects via Bluetooth  
3. Waits for PipeWire to detect the audio card
4. Forces A2DP profile for high-quality audio

## Usage

1. Find your headset MAC address:
   ```bash
   bluetoothctl devices
   ```

2. Edit the script and update `HEADSET_MAC`:
   ```bash
   HEADSET_MAC="88:C9:E8:54:7A:46"  # Your MAC here
   ```

3. Make executable and run:
   ```bash
   chmod +x xm4_a2dp_autoswitch.sh
   ./xm4_a2dp.sh
   ```

## Requirements
- `bluetoothctl` (BlueZ)
- `pactl` (PulseAudio/PipeWire)
- Paired Sony XM4 headphones

## Tested On
- Linux `[Ubuntu, PopOS, Fedora 42]` with PipeWire
- Sony WH-1000XM4
