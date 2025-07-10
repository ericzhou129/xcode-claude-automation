# Essential Files - Core Automation Only

This folder contains only the essential files for Xcode + Claude Code automation, without VS Code integration.

## Files Included
- `build.sh` - Runs xcodebuild and captures logs
- `filter.py` - Extracts relevant errors from build logs
- `fix.sh` - Main automation script (sends errors to Claude Code)
- `watch.sh` - File watcher for automatic builds
- `monitor.sh` - Continuous build monitoring
- `install-git-hook.sh` - Git integration setup
- `config.sh` - Project configuration template

## Quick Setup for Existing Projects

### 1. Copy to Your Project
```bash
# Navigate to your existing project
cd /path/to/your/existing/project

# Copy all essential files
cp /Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging/essential-files/* .

# Make scripts executable
chmod +x *.sh *.py
```

### 2. Configure Your Project
```bash
# Edit config.sh with your project details
vi config.sh

# Set your scheme name (find with: xcodebuild -list)
export SCHEME="YourAppName"

# Set workspace or project
export WORKSPACE="YourApp.xcworkspace"  # if using CocoaPods/SPM
# OR
export PROJECT="YourApp.xcodeproj"      # if not using workspace
```

### 3. Start Using
```bash
# Test setup
./fix.sh

# Start file watcher (recommended)
./watch.sh
```

## What Each File Does

### Core Automation
- **`fix.sh`** - Main command. Run when build fails or manually check
- **`watch.sh`** - Auto-runs fix.sh when you save Swift/Obj-C files
- **`build.sh`** - Runs xcodebuild with proper logging
- **`filter.py`** - Extracts and compresses build errors

### Configuration & Setup
- **`config.sh`** - Your project settings (scheme, destination, etc.)
- **`install-git-hook.sh`** - Adds git hooks for commit-time build checks
- **`monitor.sh`** - Continuous build monitoring (optional)

## Typical Usage

### Daily Development
```bash
./watch.sh    # Start file watcher
# Code in Xcode, save files
# Build errors → Claude Code → fixes automatically
```

### Manual Check
```bash
./fix.sh      # Check build and get fixes
```

### Git Integration
```bash
./install-git-hook.sh    # One-time setup for commit checks
```

## Works With
- iOS projects
- macOS projects  
- React Native projects
- Flutter projects
- Any Xcode project type

Perfect for developers using Claude Code directly (without VS Code).