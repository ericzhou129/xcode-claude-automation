# Setup Instructions

## 1. Copy to Your Xcode Project

Copy these files to your actual Xcode project root:

```bash
# Navigate to your Xcode project
cd /path/to/your/xcode/project

# Copy the automation files
cp /Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging/*.sh .
cp /Users/ericzhou/Claude\ projects/XCode_auto_deploy_debugging/*.py .
```

## 2. Configure for Your Project

Edit `config.sh` with your project details:

```bash
# Edit the configuration
vi config.sh

# Example configurations:
export SCHEME="YourAppName"                    # Found in Xcode scheme selector
export WORKSPACE="YourApp.xcworkspace"         # If using CocoaPods/SPM
export PROJECT="YourApp.xcodeproj"             # If not using workspace
export DESTINATION="generic/platform=iOS"      # iOS, macOS, etc.
```

## 3. Test the Setup

```bash
# Load your configuration
source config.sh

# Test a build (will likely fail first time)
./build.sh

# Run the automated fix workflow
./fix.sh

# Or run with a specific scheme
./fix.sh MyAppScheme
```

## 4. Typical Workflow

1. **Make code changes** in Xcode or your editor
2. **Run fix workflow**: `./fix.sh`
3. **Review Claude's suggestions** and apply fixes
4. **Repeat** until build succeeds

## 5. Prerequisites Check

Verify you have the required tools:

```bash
# Check Xcode tools
xcodebuild -version

# Check Claude CLI
claude --version

# Check Python
python3 --version

# If Claude CLI missing:
npm i -g @anthropic-ai/claude-code
```

## 6. Pro Tips

- Use `export VERBOSE="true"` to see build output
- Use `export AUTO_COMMIT="true"` for automatic commits
- Run `xcodebuild -list` to see available schemes
- Check `build/full.log` for complete build output

## Ready to Use!

Your automated Xcode build error → Claude Code → fix workflow is ready!