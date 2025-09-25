#!/bin/bash

HEADSET_MAC="$DEVICE_ID"         # Define DEVICE_ID as needed
MAX_WAIT=10                      # Seconds to wait for events

echo "Disconnecting headset..."
bluetoothctl disconnect $HEADSET_MAC

sleep 1

echo "Connecting headset..."
bluetoothctl connect $HEADSET_MAC

# Wait until bluetoothctl reports connected
for ((i=1; i<=MAX_WAIT; i++)); do
    STATUS=$(bluetoothctl info $HEADSET_MAC | grep "Connected:" | awk '{print $2}')
    if [ "$STATUS" = "yes" ]; then
        echo "Headset connected!"
        break
    fi
    echo "Waiting for BT connection ($i/$MAX_WAIT)..."
    sleep 1
done

if [ "$STATUS" != "yes" ]; then
    echo "Failed to connect headset via Bluetooth."
    exit 1
fi

# Wait until PipeWire/PulseAudio registers the card
for ((i=1; i<=MAX_WAIT; i++)); do
    CARD=$(pactl list cards short | grep "${HEADSET_MAC//:/_}" | awk '{print $1}')
    if [ -n "$CARD" ]; then
        echo "PipeWire card detected: $CARD"
        break
    fi
    echo "Waiting for PipeWire to register the card ($i/$MAX_WAIT)..."
    sleep 1
done

if [ -z "$CARD" ]; then
    echo "Failed to detect PipeWire card."
    exit 1
fi

# Force A2DP profile
echo "Setting A2DP profile..."
OUTPUT=$(pactl set-card-profile "$CARD" a2dp-sink 2>&1)
if [ $? -ne 0 ]; then
    echo "Failed to set A2DP profile:"
    echo "$OUTPUT"
    exit 1
fi

# Verify
pactl list cards short | grep "${HEADSET_MAC//:/_}"
echo "Done. XM4 is now in A2DP mode."
