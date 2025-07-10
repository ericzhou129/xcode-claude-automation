# Human Setup Prompt

Copy and paste this entire prompt into Claude to set up the Xcode automation:

---

## 🚀 Setup Xcode Build Automation

I need you to set up an automated Xcode build error → Claude Code analysis system for this project.

Please follow these steps:

1. **Download automation files from GitHub**:
   - Download these files from `https://raw.githubusercontent.com/YOUR_USERNAME/xcode-claude-automation/main/essential-files/`:
     - build.sh
     - filter.py
     - fix.sh
     - watch.sh
     - monitor.sh
     - install-git-hook.sh
     - config.sh

2. **Make all scripts executable**:
   ```bash
   chmod +x *.sh *.py
   ```

3. **Detect and configure project settings**:
   - Run `xcodebuild -list` to find available schemes
   - Update `config.sh` with:
     - The correct scheme name
     - Workspace or project file
     - Platform (iOS/macOS)
     - Build configuration

4. **Test the setup**:
   - Run `./fix.sh` to verify everything works
   - Expected: "Build log not found" on first run is normal

5. **Update documentation**:
   - Add build automation section to CLAUDE.md (or create it)
   - Include the commands and workflow

6. **Verify and report**:
   - Confirm all files are present and executable
   - Tell me the scheme name you configured
   - Let me know if the test run worked

This automation will allow me to:
- Run `./watch.sh` for automatic build error detection when files change
- Run `./fix.sh` for manual build checks
- Get instant Claude Code analysis of any Xcode build errors

The GitHub repository with instructions is at: https://github.com/YOUR_USERNAME/xcode-claude-automation

Please set this up now and let me know when it's ready to use.

---

## Alternative: One-Line Setup

If you prefer a simpler approach, you can also use this one-line prompt:

```
Please download and set up the Xcode build automation system from https://github.com/YOUR_USERNAME/xcode-claude-automation - follow the CLAUDE_SETUP_INSTRUCTIONS.md file in the repo. Configure it for this project and let me know when it's ready.
```