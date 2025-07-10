#!/usr/bin/env bash
# Install git hooks for automated build checking

set -e

if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p .git/hooks

# Pre-commit hook - run fix.sh before commits
cat > .git/hooks/pre-commit << 'EOF'
#!/usr/bin/env bash
# Auto-run build check before commit

set -e

# Load project config
if [ -f "config.sh" ]; then
    source config.sh
fi

SCHEME="${SCHEME:-MyApp}"

echo "🔍 Pre-commit: Checking build..."

# Only run if fix.sh exists
if [ ! -f "fix.sh" ]; then
    echo "⚠️  fix.sh not found, skipping build check"
    exit 0
fi

# Run build check with timeout
if timeout 120 ./fix.sh "$SCHEME" > /dev/null 2>&1; then
    echo "✅ Build check passed"
    exit 0
else
    echo "❌ Build check failed!"
    echo ""
    echo "Build errors detected. Run './fix.sh $SCHEME' to see details and get fixes."
    echo "Or use 'git commit --no-verify' to skip this check."
    exit 1
fi
EOF

chmod +x .git/hooks/pre-commit

# Post-commit hook - run fix.sh after commits to catch new issues
cat > .git/hooks/post-commit << 'EOF'
#!/usr/bin/env bash
# Auto-run build check after commit

set -e

# Load project config
if [ -f "config.sh" ]; then
    source config.sh
fi

SCHEME="${SCHEME:-MyApp}"

echo "🔍 Post-commit: Checking build..."

# Only run if fix.sh exists
if [ ! -f "fix.sh" ]; then
    exit 0
fi

# Run build check (don't fail the commit if build fails)
if timeout 120 ./fix.sh "$SCHEME" > /dev/null 2>&1; then
    echo "✅ Post-commit build check passed"
else
    echo "⚠️  Post-commit build issues detected"
    echo "Run './fix.sh $SCHEME' to see details and get fixes."
fi
EOF

chmod +x .git/hooks/post-commit

echo "✅ Git hooks installed successfully!"
echo ""
echo "Hooks installed:"
echo "  - pre-commit: Runs build check before commits"
echo "  - post-commit: Runs build check after commits"
echo ""
echo "To bypass pre-commit hook: git commit --no-verify"