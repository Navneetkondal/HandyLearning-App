#!/bin/bash
set -e

# Project root directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

APP_NAME="handyLearn"
VERSION_NAME="v1.3.2"
VERSION_CODE="11"
BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
BRANCH_SANITIZED=$(echo "$BRANCH_NAME" | sed 's/\//-/g')

APK_FILENAME="${APP_NAME}_${VERSION_NAME}_${VERSION_CODE}_${BRANCH_SANITIZED}.apk"
DESKTOP_RELEASE_DIR="/Users/navneet/Desktop/Releases/APK_RELEASE"
PROJECT_RELEASE_DIR="$PROJECT_ROOT/APK_RELEASE"

echo "=========================================="
echo "Building $APP_NAME ($APK_FILENAME)..."
echo "=========================================="

cd "$PROJECT_ROOT"

# Run tests and analysis
echo "Running static analysis..."
flutter analyze

echo "Running automated test suite..."
flutter test

echo "Compiling Flutter release APKs..."
flutter build apk --release
flutter build apk --release --split-per-abi

SOURCE_APK="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-release.apk"
SOURCE_ARM64_APK="$PROJECT_ROOT/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk"

if [ -f "$SOURCE_APK" ]; then
    mkdir -p "$DESKTOP_RELEASE_DIR"
    mkdir -p "$PROJECT_RELEASE_DIR"

    # Prune older builds of handyLearn
    rm -f "$DESKTOP_RELEASE_DIR/${APP_NAME}_"*.apk
    rm -f "$DESKTOP_RELEASE_DIR/Handbook_"*.apk
    rm -f "$PROJECT_RELEASE_DIR/${APP_NAME}_"*.apk
    rm -f "$PROJECT_RELEASE_DIR/FlutterLearningHub_"*.apk

    # Copy new release artifact to project APK_RELEASE and Desktop Release folder
    cp "$SOURCE_APK" "$PROJECT_RELEASE_DIR/$APK_FILENAME"
    cp "$SOURCE_ARM64_APK" "$PROJECT_RELEASE_DIR/${APP_NAME}_${VERSION_NAME}_${VERSION_CODE}_${BRANCH_SANITIZED}_arm64_slim.apk"

    # Sync to Desktop Release Directory
    cp "$SOURCE_APK" "$DESKTOP_RELEASE_DIR/$APK_FILENAME"

    echo "Release successfully placed at:"
    echo "  -> $PROJECT_RELEASE_DIR/$APK_FILENAME"
    echo "  -> $DESKTOP_RELEASE_DIR/$APK_FILENAME"
else
    echo "Error: Output APK not found at $SOURCE_APK"
    exit 1
fi
