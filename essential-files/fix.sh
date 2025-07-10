#!/usr/bin/env bash
set -e

# Configuration
SCHEME="${1:-MyApp}"
AUTO_COMMIT="${AUTO_COMMIT:-false}"
VERBOSE="${VERBOSE:-false}"

echo "Starting automated Xcode build fix workflow..."
echo "Scheme: $SCHEME"

# Step 1: Run the build (allow it to fail)
echo "Step 1: Running build..."
if [ "$VERBOSE" = "true" ]; then
    ./build.sh "$SCHEME" || echo "Build failed as expected, continuing..."
else
    ./build.sh "$SCHEME" >/dev/null 2>&1 || echo "Build failed, analyzing errors..."
fi

# Step 2: Extract and encode errors
echo "Step 2: Extracting and encoding errors..."
if [ ! -f "build/full.log" ]; then
    echo "Error: Build log not found at build/full.log"
    exit 1
fi

ENC=$(./filter.py)

if [ "$ENC" = "Tm8gZXJyb3JzIGZvdW5kIGluIGJ1aWxkIGxvZy4=" ]; then
    echo "✅ Build succeeded! No errors found."
    exit 0
fi

echo "Step 3: Sending errors to Claude Code for analysis..."

# Create a temporary file for the Claude prompt
TEMP_PROMPT=$(mktemp)
trap 'rm -f "$TEMP_PROMPT"' EXIT

cat > "$TEMP_PROMPT" << 'EOF'
You are a senior iOS/macOS build engineer. I'm sending you a gzip-compressed, base64-encoded snippet of an Xcode build log that contains errors.

Please:
1. Decode and analyze the build errors
2. Explain the root cause(s) clearly and concisely
3. Provide specific, actionable fixes
4. If possible, suggest the exact code changes needed

The build log data follows:
EOF

echo "" >> "$TEMP_PROMPT"
echo '```' >> "$TEMP_PROMPT"
echo "$ENC" >> "$TEMP_PROMPT"
echo '```' >> "$TEMP_PROMPT"

# Call Claude Code with the build context
echo "Calling Claude Code..."
if command -v claude &> /dev/null; then
    claude code \
        --system "You are a senior iOS/macOS build engineer specializing in Xcode build issues. Focus on practical, actionable solutions." \
        --prompt "$(cat "$TEMP_PROMPT")" \
        --files . \
        ${AUTO_COMMIT:+--commit "fix: resolve Xcode build errors 🤖"}
else
    echo "Error: Claude CLI not found. Please install it with: npm i -g @anthropic-ai/claude-code"
    echo "Alternatively, you can manually decode the base64 data:"
    echo "$ENC" | base64 -d | gunzip
    exit 1
fi

echo "✅ Analysis complete! Review Claude's suggestions and apply the fixes."

# Optional: Show quick build retry option
echo ""
echo "To retry the build after applying fixes, run:"
echo "  ./build.sh $SCHEME"
echo ""
echo "To run this fix workflow again:"
echo "  ./fix.sh $SCHEME"