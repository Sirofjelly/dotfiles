#!/bin/bash

set -euo pipefail

trap 'killall Dock' EXIT

declare -a remove_labels=(
  Messages
  Mail
  Maps
  Photos
  FaceTime
  Calendar
  Contacts
  Freeform
  TV
  Music
  "App Store"
  "iPhone Mirroring"
)

for label in "${remove_labels[@]}"; do
  if dockutil --find "${label}" &>/dev/null; then
    dockutil --remove "${label}" || true
  fi
done
