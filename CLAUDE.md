# Xcode + Claude Code Automation System

## Project Purpose
This system automates the feedback loop between Xcode build errors and Claude Code analysis, eliminating the need to manually copy-paste build errors from screenshots.

## How It Works
1. **Build fails** → `xcodebuild` captures errors to `build/full.log`
2. **Extract errors** → `filter.py` extracts relevant errors and compresses them
3. **Analyze** → `fix.sh` sends compressed errors to Claude Code
4. **Get fixes** → Claude Code provides specific solutions and code changes
5. **Apply fixes** → Developer applies suggested changes
6. **Repeat** → Process continues until build succeeds

## Automation Options
- **File Watcher**: `watch.sh` - Auto-runs when files change
- **Git Hooks**: Pre/post-commit build checks
- **VS Code Tasks**: Integrated build commands
- **Continuous Monitor**: Periodic build health checks

## Key Files
- `build.sh` - Runs xcodebuild with proper logging
- `filter.py` - Extracts and compresses build errors
- `fix.sh` - Main automation script
- `watch.sh` - File change monitoring
- `monitor.sh` - Continuous build monitoring
- `config.sh` - Project-specific configuration
- `setup-new-project.sh` - Setup automation for new projects

## Usage Patterns
- **New Project**: Run `setup-new-project.sh` in project root
- **Daily Development**: Use `./watch.sh` for automatic error detection
- **Manual Check**: Use `./fix.sh` when build fails
- **Git Integration**: Use `./install-git-hook.sh` for commit-time checks

## Configuration
Each project gets its own `config.sh` with:
- `SCHEME` - Xcode scheme name
- `DESTINATION` - Build destination (iOS/macOS)
- `WORKSPACE/PROJECT` - Xcode workspace or project file
- `CONFIGURATION` - Debug/Release
- `BUILD_TYPE` - archive/build

## Benefits
- Eliminates manual copy-paste of build errors
- Provides contextual fixes based on actual codebase
- Integrates with existing development workflow
- Supports multiple automation levels (manual to fully automated)
- Works with any Xcode project type (iOS, macOS, React Native, Flutter)

## Developer Workflow
1. Create new Xcode project
2. Run `setup-xcode-automation` (global alias)
3. Start file watcher: `./watch.sh`
4. Code normally in Xcode
5. Build errors automatically get analyzed by Claude Code
6. Apply suggested fixes
7. Continue coding

## Extension Points
- Customize error patterns in `filter.py`
- Modify build commands in `build.sh`
- Add custom automation triggers
- Integrate with CI/CD pipelines
- Add notification systems

## Requirements
- Xcode command line tools
- Claude Code CLI
- Python 3.9+
- fswatch (for file watching)
- Git (for hooks)

## Template Location
Files are stored in `/Users/ericzhou/Claude projects/XCode_auto_deploy_debugging/` and can be copied to any new Xcode project.

## Future Enhancements
- Support for other build systems (Swift Package Manager, etc.)
- Integration with more IDEs
- Custom error classification
- Build performance metrics
- Team collaboration features