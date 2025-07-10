# Claude Setup Instructions

This file contains step-by-step instructions for Claude to set up the Xcode + Claude Code automation system.

## Prerequisites Check

First, verify:
1. You are in an Xcode project directory
2. The project has a .xcodeproj or .xcworkspace file
3. You have access to run bash commands

## Setup Steps

### 1. Download the automation files

```bash
# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Download the essential files from GitHub
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/build.sh -o "$TEMP_DIR/build.sh"
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/filter.py -o "$TEMP_DIR/filter.py"
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/fix.sh -o "$TEMP_DIR/fix.sh"
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/watch.sh -o "$TEMP_DIR/watch.sh"
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/monitor.sh -o "$TEMP_DIR/monitor.sh"
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/install-git-hook.sh -o "$TEMP_DIR/install-git-hook.sh"
curl -sL https://raw.githubusercontent.com/ericzhou129/xcode-claude-automation/main/essential-files/config.sh -o "$TEMP_DIR/config.sh"

# Copy files to current directory
cp "$TEMP_DIR"/*.sh .
cp "$TEMP_DIR"/*.py .

# Clean up
rm -rf "$TEMP_DIR"

# Make scripts executable
chmod +x *.sh *.py
```

### 2. Detect project configuration

```bash
# List available schemes
xcodebuild -list

# Find workspace/project files
ls -la *.xcworkspace *.xcodeproj 2>/dev/null || echo "No workspace/project files found"
```

### 3. Configure the project

Based on the xcodebuild output, update config.sh:

```bash
# Read current config
cat config.sh

# The scheme should be one of the schemes listed by xcodebuild -list
# Common patterns:
# - For single target apps: the app name
# - For React Native: the app name
# - For Flutter: usually "Runner"
```

Edit config.sh to set:
- `SCHEME` - The correct scheme name from xcodebuild -list
- `WORKSPACE` - Set if .xcworkspace exists
- `PROJECT` - Set if only .xcodeproj exists (no workspace)
- `DESTINATION` - "generic/platform=iOS" for iOS, "generic/platform=macOS" for macOS
- `CONFIGURATION` - "Debug" for development
- `BUILD_TYPE` - "build" for development

### 4. Test the setup

```bash
# Load configuration
source config.sh
echo "Configured scheme: $SCHEME"

# Test the automation
./fix.sh
```

Expected results:
- First run: "Build log not found" is normal
- Success: "No errors found in build log"
- Errors: Claude will analyze and provide fixes

### 5. Update project documentation

Add to CLAUDE.md (create if doesn't exist):

```markdown
## Build Automation

This project uses automated Xcode build error detection and fixing.

### Commands
- `./fix.sh` - Manual build check and error analysis
- `./watch.sh` - Auto-run when files change (recommended)
- `./install-git-hook.sh` - Check builds on git commits

### Workflow
1. Start file watcher: `./watch.sh`
2. Code in Xcode as normal
3. Save files → automatic build check
4. Build errors → Claude Code provides fixes
5. Apply fixes → continue coding

### Configuration
- Scheme: [SCHEME_NAME]
- Platform: [iOS/macOS]
- Build Type: [build/archive]
```

### 6. Verify everything is working

```bash
# Check all files are present and executable
ls -la {build.sh,filter.py,fix.sh,watch.sh,config.sh}

# Run a final test
./fix.sh
```

## Success Criteria

The setup is complete when:
1. All automation files are present and executable
2. config.sh contains the correct scheme and project settings
3. Running ./fix.sh attempts to build the project
4. CLAUDE.md includes the build automation section

## Common Issues

- **"No scheme found"**: Run `xcodebuild -list` and pick a valid scheme
- **"Build log not found"**: Normal for first run, the build directory will be created
- **Permission denied**: Run `chmod +x *.sh *.py`

## Next Steps

Inform the user that:
1. The automation is set up and ready
2. They can start the file watcher with `./watch.sh`
3. Or run manual checks with `./fix.sh`
4. Git hooks can be installed with `./install-git-hook.sh`