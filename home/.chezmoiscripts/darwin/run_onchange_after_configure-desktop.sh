#!/bin/bash

set -eufo pipefail

defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer