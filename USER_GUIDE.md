# Xcode + Claude Code Automation - User Guide

## 🚀 Quick Start (for new projects)

When you create a new Xcode project, run this one command:

```bash
# In your new Xcode project root
/Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging/setup-new-project.sh
```

This will:
1. Copy all automation files to your project
2. Help you configure your scheme and settings
3. Set up automation options
4. Create a CLAUDE.md file for project memory

## 📋 What This System Does

**Problem Solved**: No more copy-pasting build errors from Xcode screenshots to Claude Code

**Solution**: Automated pipeline that:
- Captures build errors automatically
- Sends them to Claude Code for analysis
- Returns specific fixes and code suggestions
- Can run automatically when you save files

## 🔧 Setup for Existing Projects

### 1. Copy Files to Your Project
```bash
cd /path/to/your/xcode/project
cp /Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging/{*.sh,*.py} .
cp -r /Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging/.vscode .
```

### 2. Configure Your Project
```bash
# Edit config.sh with your project details
vi config.sh

# Set your scheme name (found in Xcode scheme selector)
export SCHEME="YourAppName"

# Set workspace or project file
export WORKSPACE="YourApp.xcworkspace"  # if using CocoaPods/SPM
# OR
export PROJECT="YourApp.xcodeproj"      # if not using workspace
```

### 3. Test Setup
```bash
# Test the automation
./fix.sh

# Should show: "Build log not found" (that's normal for first run)
```

## 🎯 Usage Options

### Option 1: Manual (when build fails)
```bash
./fix.sh
```

### Option 2: File Watcher (recommended)
```bash
./watch.sh
```
- Automatically runs fix.sh when you save Swift/Obj-C files
- Best for active development
- Press Ctrl+C to stop

### Option 3: Git Integration
```bash
./install-git-hook.sh
```
- Checks builds before commits
- Prevents broken code from being committed

### Option 4: VS Code Tasks
- Open Command Palette (Cmd+Shift+P)
- Type "Tasks: Run Task"
- Select "Xcode: Build and Fix"

### Option 5: Continuous Monitoring
```bash
./monitor.sh
```
- Runs build checks every 30 seconds
- Good for long development sessions

## 🔄 Typical Workflow

1. **Start file watcher**: `./watch.sh`
2. **Code in Xcode** as usual
3. **Save files** → automatically triggers build check
4. **If build fails** → Claude Code analyzes errors and suggests fixes
5. **Apply fixes** → build automatically rechecks
6. **Repeat** until build succeeds

## 📱 Common Project Types

### iOS App
```bash
export SCHEME="MyiOSApp"
export DESTINATION="generic/platform=iOS"
```

### macOS App
```bash
export SCHEME="MyMacApp"
export DESTINATION="generic/platform=macOS"
```

### React Native
```bash
export SCHEME="YourAppName"
export DESTINATION="generic/platform=iOS"
export BUILD_TYPE="build"  # Don't need archive
```

### Flutter
```bash
export SCHEME="Runner"
export DESTINATION="generic/platform=iOS"
```

## 🛠️ Troubleshooting

### "No scheme found"
```bash
# Check available schemes
xcodebuild -list
# Update SCHEME in config.sh
```

### "Claude CLI not found"
```bash
# Install Claude CLI
npm i -g @anthropic-ai/claude-code
# Verify installation
claude --version
```

### "fswatch not found" (for file watcher)
```bash
# Install fswatch
brew install fswatch
```

### Build not running
```bash
# Check if files exist
ls -la *.sh *.py
# Check if executable
chmod +x *.sh *.py
```

## 🎛️ Advanced Configuration

### Environment Variables
```bash
# In config.sh or terminal
export VERBOSE="true"        # Show build output
export AUTO_COMMIT="true"    # Auto-commit fixes
export MONITOR_INTERVAL="60" # Check every 60 seconds
export DEBOUNCE_TIME="5"     # Wait 5s between file changes
```

### Custom Build Commands
Edit `build.sh` to customize the xcodebuild command for your needs.

## 📁 File Structure

After setup, your project will have:
```
your-project/
├── build.sh           # Runs xcodebuild
├── filter.py          # Extracts errors
├── fix.sh             # Main automation script
├── watch.sh           # File watcher
├── monitor.sh         # Continuous monitoring
├── config.sh          # Your project config
├── install-git-hook.sh # Git integration
├── .vscode/
│   ├── tasks.json     # VS Code tasks
│   └── settings.json  # VS Code settings
├── build/             # Build logs (created automatically)
└── CLAUDE.md          # Project memory for Claude
```

## 💡 Tips

1. **Start with file watcher** - `./watch.sh` is the most useful for daily development
2. **Use git hooks** - Prevent broken commits with `./install-git-hook.sh`
3. **Check build logs** - Look at `build/full.log` if you need to debug
4. **Customize error patterns** - Edit `filter.py` to catch specific warnings
5. **Set up VS Code** - Use tasks for quick access to build commands

## 🆘 Getting Help

If something doesn't work:
1. Check the error message
2. Verify your config.sh settings
3. Test with a simple `./build.sh` first
4. Check that all files are executable: `chmod +x *.sh *.py`

## 🔄 Updating

To update the automation system:
```bash
# Pull latest changes
cd /Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging
git pull

# Re-copy files to your project
cp *.sh *.py /path/to/your/project/
```

---

**Happy coding!** 🎉 Never copy-paste build errors again!