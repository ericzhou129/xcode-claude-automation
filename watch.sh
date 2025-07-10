#!/usr/bin/env bash
# Auto-run fix.sh when Swift/Obj-C files change

set -e

# Configuration
WATCH_DIRS="${WATCH_DIRS:-. Sources}"
WATCH_EXTENSIONS="${WATCH_EXTENSIONS:-swift m mm h hpp cpp c cc}"
DEBOUNCE_TIME="${DEBOUNCE_TIME:-2}"
SCHEME="${1:-}"

# Load project config
if [ -f "config.sh" ]; then
    source config.sh
fi

# Use scheme from config if not provided
if [ -z "$SCHEME" ]; then
    SCHEME="${SCHEME:-MyApp}"
fi

echo "🔍 Watching for changes in: $WATCH_DIRS"
echo "📁 File extensions: $WATCH_EXTENSIONS"
echo "🏗️  Scheme: $SCHEME"
echo "⏱️  Debounce: ${DEBOUNCE_TIME}s"
echo ""
echo "Press Ctrl+C to stop watching"

# Check if fswatch is available
if ! command -v fswatch &> /dev/null; then
    echo "Installing fswatch..."
    if command -v brew &> /dev/null; then
        brew install fswatch
    else
        echo "Error: fswatch not found. Install with: brew install fswatch"
        exit 1
    fi
fi

# Build extension filter for fswatch
EXT_FILTER=""
for ext in $WATCH_EXTENSIONS; do
    EXT_FILTER="$EXT_FILTER --include='.*\.$ext$'"
done

# Track last run time for debouncing
LAST_RUN=0

run_fix() {
    local current_time=$(date +%s)
    local time_diff=$((current_time - LAST_RUN))
    
    if [ $time_diff -lt $DEBOUNCE_TIME ]; then
        echo "⏳ Debouncing... (${time_diff}s < ${DEBOUNCE_TIME}s)"
        return
    fi
    
    LAST_RUN=$current_time
    echo ""
    echo "🔄 File changed, running build check..."
    echo "$(date): Starting automated build fix"
    
    # Run fix.sh with timeout to prevent hanging
    if timeout 300 ./fix.sh "$SCHEME" 2>&1; then
        echo "✅ Build fix completed successfully"
    else
        echo "❌ Build fix failed or timed out"
    fi
    
    echo ""
    echo "👀 Continuing to watch for changes..."
}

# Export function for fswatch
export -f run_fix
export LAST_RUN DEBOUNCE_TIME SCHEME

# Start watching
eval "fswatch -o $EXT_FILTER $WATCH_DIRS" | while read -r; do
    run_fix
done