#!/bin/bash
# Author: Nafeh
# Description: RISC-V Simulation Log Analyzer
set -euo pipefail

# Color Codes for Output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 1. Check if a log file was passed as an argument
if [ -z "${1:-}" ]; then
    echo "Error: No log file specified."
    echo "Usage: ./analyze.sh <path_to_log_file>"
    exit 1
fi

LOG_FILE=$1

# 2. Verify the log file actually exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found!"
    exit 1
fi

echo "==========================================="
echo " Processing Log: $LOG_FILE"
echo "==========================================="

# 3. Parse and count test metrics
PASS_COUNT=$(grep -c "PASSED" "$LOG_FILE" || true)
FAIL_COUNT=$(grep -c "FAILED" "$LOG_FILE" || true)

echo -e "Total Passed Tests: ${GREEN}$PASS_COUNT${NC}"
echo -e "Total Failed Tests: ${RED}$FAIL_COUNT${NC}"
echo "==========================================="

# 4. Final status check
if [ "$FAIL_COUNT" -gt 0 ]; then
    echo -e "Overall Result: ${RED}SIMULATION FAILED${NC}"
    exit 1
else
    echo -e "Overall Result: ${GREEN}SIMULATION PASSED${NC}"
    exit 0
fi
