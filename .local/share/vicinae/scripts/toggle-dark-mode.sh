#!/bin/bash

# @raycast.schemaVersion 1
# @raycast.title Toggle Dark Mode
# @raycast.mode silent
# @raycast.icon 🌗
# @raycast.packageName System

osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to not dark mode'
