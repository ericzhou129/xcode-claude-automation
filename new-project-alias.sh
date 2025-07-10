#!/usr/bin/env bash
# Create global aliases for setting up new Xcode projects

TEMPLATE_DIR="/Users/ericzhou/Claude projects/XCode_auto_deploy_debugging"
ALIAS_NAME="setup-xcode-automation"
ALIAS_NAME_ESSENTIAL="setup-xcode-essential"

echo "Creating global aliases for Xcode automation setup..."

# Create the full setup alias function
ALIAS_FUNCTION="function $ALIAS_NAME() {
    echo \"🚀 Setting up Xcode + Claude Code automation (full setup with VS Code)...\"
    if [ ! -f \"$TEMPLATE_DIR/setup-new-project.sh\" ]; then
        echo \"❌ Template not found at $TEMPLATE_DIR\"
        return 1
    fi
    \"$TEMPLATE_DIR/setup-new-project.sh\"
}"

# Create the essential setup alias function
ALIAS_FUNCTION_ESSENTIAL="function $ALIAS_NAME_ESSENTIAL() {
    echo \"🚀 Setting up Xcode + Claude Code automation (essential files only)...\"
    if [ ! -f \"$TEMPLATE_DIR/setup-essential-only.sh\" ]; then
        echo \"❌ Template not found at $TEMPLATE_DIR\"
        return 1
    fi
    \"$TEMPLATE_DIR/setup-essential-only.sh\"
}"

# Add to shell profile
if [ -f ~/.zshrc ]; then
    if ! grep -q "$ALIAS_NAME" ~/.zshrc; then
        echo "" >> ~/.zshrc
        echo "# Xcode + Claude Code automation setup" >> ~/.zshrc
        echo "$ALIAS_FUNCTION" >> ~/.zshrc
        echo "$ALIAS_FUNCTION_ESSENTIAL" >> ~/.zshrc
        echo "✅ Added aliases to ~/.zshrc"
    else
        echo "⚠️  Aliases already exist in ~/.zshrc"
    fi
fi

if [ -f ~/.bashrc ]; then
    if ! grep -q "$ALIAS_NAME" ~/.bashrc; then
        echo "" >> ~/.bashrc
        echo "# Xcode + Claude Code automation setup" >> ~/.bashrc
        echo "$ALIAS_FUNCTION" >> ~/.bashrc
        echo "$ALIAS_FUNCTION_ESSENTIAL" >> ~/.bashrc
        echo "✅ Added aliases to ~/.bashrc"
    else
        echo "⚠️  Aliases already exist in ~/.bashrc"
    fi
fi

if [ -f ~/.bash_profile ]; then
    if ! grep -q "$ALIAS_NAME" ~/.bash_profile; then
        echo "" >> ~/.bash_profile
        echo "# Xcode + Claude Code automation setup" >> ~/.bash_profile
        echo "$ALIAS_FUNCTION" >> ~/.bash_profile
        echo "$ALIAS_FUNCTION_ESSENTIAL" >> ~/.bash_profile
        echo "✅ Added aliases to ~/.bash_profile"
    else
        echo "⚠️  Aliases already exist in ~/.bash_profile"
    fi
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Usage:"
echo "  1. Create new Xcode project"
echo "  2. cd to project directory"
echo "  3. Run one of:"
echo "     - $ALIAS_NAME (full setup with VS Code)"
echo "     - $ALIAS_NAME_ESSENTIAL (essential files only)"
echo ""
echo "To activate now, run: source ~/.zshrc (or restart terminal)"