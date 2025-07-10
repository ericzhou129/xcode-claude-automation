#!/usr/bin/env bash
set -e

# Configuration - modify these for your project
SCHEME="${1:-MyApp}"
WORKSPACE="${WORKSPACE:-}"
PROJECT="${PROJECT:-}"
DESTINATION="${DESTINATION:-generic/platform=iOS}"
CONFIGURATION="${CONFIGURATION:-Debug}"
ARCHIVE_PATH="build/${SCHEME}.xcarchive"

echo "Building scheme: $SCHEME"
echo "Destination: $DESTINATION"
echo "Configuration: $CONFIGURATION"

# Create build directory
mkdir -p build

# Build command based on whether we have a workspace or project
BUILD_CMD="xcodebuild"

if [ -n "$WORKSPACE" ]; then
    BUILD_CMD="$BUILD_CMD -workspace $WORKSPACE"
elif [ -n "$PROJECT" ]; then
    BUILD_CMD="$BUILD_CMD -project $PROJECT"
fi

BUILD_CMD="$BUILD_CMD -scheme $SCHEME -destination '$DESTINATION' -configuration $CONFIGURATION"

# Add archive path if doing archive build
if [ "${BUILD_TYPE:-archive}" = "archive" ]; then
    BUILD_CMD="$BUILD_CMD -archivePath $ARCHIVE_PATH clean archive"
else
    BUILD_CMD="$BUILD_CMD clean build"
fi

echo "Running: $BUILD_CMD"
eval "$BUILD_CMD" 2>&1 | tee build/full.log