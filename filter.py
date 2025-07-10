#!/usr/bin/env python3
import re
import sys
import gzip
import base64
import json
import pathlib
from typing import List, Optional

def extract_errors_from_log(log_path: str) -> str:
    """Extract relevant errors from Xcode build log."""
    log_file = pathlib.Path(log_path)
    
    if not log_file.exists():
        return "Build log not found."
    
    try:
        text = log_file.read_text(errors="ignore")
    except Exception as e:
        return f"Error reading log file: {str(e)}"
    
    lines = text.splitlines()
    
    # Patterns to match errors and important warnings
    error_patterns = [
        r'\berror:\s+',                    # Standard error messages
        r'\bfatal error:\s+',              # Fatal errors
        r'\bundefined symbol:\s+',         # Linker errors
        r'\bld:\s+.*error',                # Linker errors
        r'\bClang:\s+error:',              # Clang errors
        r'\bSwift\s+compilation\s+error',  # Swift compilation errors
        r'\bBuild\s+failed',               # Build failed messages
        r'\bThe following build commands failed:', # Failed build commands
        r'\bCommand.*failed with exit code', # Command failures
        r'\barchive FAILED',               # Archive failures
        r'\bTesting failed:',              # Test failures
        r'\bwarning:\s+.*deprecated',      # Deprecation warnings (important)
        r'\bwarning:\s+.*will be removed', # Removal warnings (important)
        r'^\s*\^\s*$',                     # Caret indicators (show problem location)
        r'^\s*~+\s*$',                     # Tilde indicators (show problem location)
    ]
    
    # Combined pattern
    combined_pattern = '|'.join(error_patterns)
    
    # Extract matching lines and some context
    errors = []
    for i, line in enumerate(lines):
        if re.search(combined_pattern, line, re.IGNORECASE):
            # Add some context around the error
            start = max(0, i - 1)
            end = min(len(lines), i + 2)
            context_lines = lines[start:end]
            errors.extend(context_lines)
            errors.append("---")  # Separator
    
    if not errors:
        return "No errors found in build log."
    
    # Remove duplicate separators and clean up
    filtered_errors = []
    prev_line = ""
    for line in errors:
        if line == "---" and prev_line == "---":
            continue
        filtered_errors.append(line)
        prev_line = line
    
    return "\n".join(filtered_errors)

def compress_and_encode(text: str) -> str:
    """Compress text with gzip and encode as base64."""
    compressed = gzip.compress(text.encode('utf-8'))
    encoded = base64.b64encode(compressed).decode('ascii')
    return encoded

def main():
    """Main function to process build log and output compressed errors."""
    log_path = "build/full.log"
    
    if len(sys.argv) > 1:
        log_path = sys.argv[1]
    
    errors = extract_errors_from_log(log_path)
    
    # For very long error logs, truncate to prevent token limit issues
    if len(errors) > 10000:
        lines = errors.splitlines()
        # Keep first 100 lines and last 50 lines
        if len(lines) > 150:
            truncated_lines = lines[:100] + ["... (truncated) ..."] + lines[-50:]
            errors = "\n".join(truncated_lines)
    
    encoded_errors = compress_and_encode(errors)
    print(encoded_errors)

if __name__ == "__main__":
    main()