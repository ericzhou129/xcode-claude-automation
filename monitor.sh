#!/usr/bin/env bash
# Continuous build monitoring with smart retry logic

set -e

# Configuration
SCHEME="${1:-}"
MONITOR_INTERVAL="${MONITOR_INTERVAL:-30}"
MAX_RETRIES="${MAX_RETRIES:-3}"
SUCCESS_THRESHOLD="${SUCCESS_THRESHOLD:-2}"
QUIET_MODE="${QUIET_MODE:-false}"

# Load project config
if [ -f "config.sh" ]; then
    source config.sh
fi

# Use scheme from config if not provided
if [ -z "$SCHEME" ]; then
    SCHEME="${SCHEME:-MyApp}"
fi

# State tracking
consecutive_failures=0
consecutive_successes=0
last_status=""

log_message() {
    if [ "$QUIET_MODE" != "true" ]; then
        echo "[$(date '+%H:%M:%S')] $1"
    fi
}

run_build_check() {
    local attempt=1
    local max_attempts=$MAX_RETRIES
    
    while [ $attempt -le $max_attempts ]; do
        log_message "🔄 Build check attempt $attempt/$max_attempts"
        
        if timeout 180 ./fix.sh "$SCHEME" > /dev/null 2>&1; then
            return 0  # Success
        else
            if [ $attempt -lt $max_attempts ]; then
                log_message "❌ Attempt $attempt failed, retrying in 10s..."
                sleep 10
            fi
            ((attempt++))
        fi
    done
    
    return 1  # All attempts failed
}

monitor_loop() {
    log_message "🔍 Starting continuous build monitoring"
    log_message "📊 Scheme: $SCHEME"
    log_message "⏱️  Check interval: ${MONITOR_INTERVAL}s"
    log_message "🔄 Max retries: $MAX_RETRIES"
    log_message "✅ Success threshold: $SUCCESS_THRESHOLD"
    log_message ""
    
    while true; do
        if run_build_check; then
            # Build succeeded
            consecutive_failures=0
            ((consecutive_successes++))
            
            if [ "$last_status" != "success" ]; then
                log_message "✅ Build check passed"
                last_status="success"
            fi
            
            # If we've had enough consecutive successes, reduce check frequency
            if [ $consecutive_successes -ge $SUCCESS_THRESHOLD ]; then
                local extended_interval=$((MONITOR_INTERVAL * 2))
                log_message "😴 Build stable, extending interval to ${extended_interval}s"
                sleep $extended_interval
                continue
            fi
            
        else
            # Build failed
            consecutive_successes=0
            ((consecutive_failures++))
            
            if [ "$last_status" != "failure" ]; then
                log_message "❌ Build check failed"
                last_status="failure"
                
                # Show the actual errors on first failure
                log_message "📋 Build errors detected:"
                ./fix.sh "$SCHEME" 2>&1 | head -20
                log_message ""
            fi
            
            # If multiple consecutive failures, increase check frequency
            if [ $consecutive_failures -ge 3 ]; then
                local reduced_interval=$((MONITOR_INTERVAL / 2))
                if [ $reduced_interval -lt 10 ]; then
                    reduced_interval=10
                fi
                log_message "🚨 Multiple failures, increasing check frequency to ${reduced_interval}s"
                sleep $reduced_interval
                continue
            fi
        fi
        
        sleep $MONITOR_INTERVAL
    done
}

# Handle signals gracefully
trap 'log_message "🛑 Monitoring stopped"; exit 0' SIGINT SIGTERM

# Start monitoring
monitor_loop