#!/usr/bin/env bash
# Configuration file for Xcode build automation
# Copy this to your project root and modify as needed

# Project settings - MODIFY THESE FOR YOUR PROJECT
export SCHEME="MyApp"                    # Your Xcode scheme name
export WORKSPACE=""                      # Path to .xcworkspace file (if using CocoaPods/SPM)
export PROJECT=""                        # Path to .xcodeproj file (if not using workspace)
export DESTINATION="generic/platform=iOS" # Build destination
export CONFIGURATION="Debug"             # Build configuration
export BUILD_TYPE="archive"              # "archive" or "build"

# Automation settings
export AUTO_COMMIT="false"               # Auto-commit fixes (true/false)
export VERBOSE="false"                   # Show build output (true/false)

# Usage examples:
# For iOS app: DESTINATION="generic/platform=iOS"
# For macOS app: DESTINATION="generic/platform=macOS"
# For specific device: DESTINATION="platform=iOS Simulator,name=iPhone 14"
# For iOS device: DESTINATION="generic/platform=iOS"

# Common scheme patterns:
# - Single target: usually the app name
# - Multiple targets: check Xcode scheme selector
# - React Native: usually the app name
# - Flutter: usually "Runner"

echo "Configuration loaded:"
echo "  Scheme: $SCHEME"
echo "  Workspace: ${WORKSPACE:-'Not set'}"
echo "  Project: ${PROJECT:-'Not set'}"
echo "  Destination: $DESTINATION"
echo "  Configuration: $CONFIGURATION"