# Xcode + Claude Code Automation

Automatically pipe Xcode build errors to Claude Code for instant analysis and fixes. No more copy-pasting screenshots!

## 🚀 Quick Start

### Option 1: Let Claude Set It Up (Recommended)

1. Navigate to your Xcode project
2. Copy the prompt from [HUMAN_SETUP_PROMPT.md](HUMAN_SETUP_PROMPT.md)
3. Paste it into Claude
4. Claude will handle everything

### Option 2: Manual Setup

```bash
# In your Xcode project directory
curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/xcode-claude-automation/main/setup-from-github.sh | bash
```

## 🎯 What This Solves

**Before**: Build fails → Screenshot errors → Paste to Claude → Apply fixes manually

**After**: Build fails → Automatic analysis → Get fixes instantly

## 📋 Features

- **Automatic Error Detection**: Captures all Xcode build errors
- **Smart Filtering**: Extracts only relevant error messages
- **Claude Integration**: Sends errors directly to Claude Code
- **Multiple Modes**:
  - Manual: `./fix.sh` when you want
  - Auto: `./watch.sh` monitors file changes
  - Git: Pre-commit build checks
  - Continuous: Periodic monitoring

## 🛠️ How It Works

1. **Build Fails** → `xcodebuild` captures all output
2. **Filter Errors** → Python script extracts relevant errors
3. **Compress & Send** → Errors sent to Claude Code
4. **Get Fixes** → Claude analyzes and suggests solutions
5. **Apply & Continue** → Fix code and keep building

## 📁 Files Included

### Essential Files (Core Automation)
- `build.sh` - Runs xcodebuild with proper logging
- `filter.py` - Extracts and compresses error messages
- `fix.sh` - Main script that orchestrates everything
- `watch.sh` - File watcher for automatic detection
- `config.sh` - Project-specific configuration
- `monitor.sh` - Continuous build monitoring
- `install-git-hook.sh` - Git integration

### Optional Files
- `.vscode/` - VS Code integration (tasks and settings)
- Setup scripts for different scenarios

## 🔧 Configuration

Each project gets a `config.sh` with:
```bash
export SCHEME="YourAppName"              # Xcode scheme
export WORKSPACE="YourApp.xcworkspace"   # If using CocoaPods/SPM
export DESTINATION="generic/platform=iOS" # Build destination
export CONFIGURATION="Debug"             # Debug/Release
export BUILD_TYPE="build"                # build/archive
```

## 💻 Usage Examples

### Daily Development
```bash
# Start file watcher (recommended)
./watch.sh

# Code in Xcode, save files
# Errors automatically → Claude → fixes
```

### Manual Check
```bash
# When build fails
./fix.sh

# Claude analyzes and provides fixes
```

### Git Integration
```bash
# One-time setup
./install-git-hook.sh

# Now git commits check builds automatically
```

## 📱 Supports

- iOS apps
- macOS apps
- React Native projects
- Flutter projects
- Any Xcode project type

## 🔄 Requirements

- Xcode command line tools
- Claude Code CLI (`npm i -g @anthropic-ai/claude-code`)
- Python 3.9+
- Optional: fswatch for file monitoring

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

MIT License - Use freely in your projects

---

**Never copy-paste build errors again!** 🎉