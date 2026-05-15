# Author: Nafeh (2023-EE-YOUR_ID)
#!/bin/bash

# Exit on:
# -e : any command failure
# -u : undefined variables
# -o pipefail : failures inside pipelines
set -euo pipefail

# =========================
# Default Configuration
# =========================
FORMAT="text"
OUTPUT=""
VERBOSE=0
LOG_FILE=""

# =========================
# Statistics Variables
# =========================
total_tests=0
pass_count=0
fail_count=0
skip_count=0

# Timing statistics
sum_time=0
min_time=999999
max_time=0

# Arrays for storing information
declare -a failed_tests
declare -a execution_times

# =========================
# Usage Function
# =========================
usage() {
    echo "Usage: ./analyze.sh <log_file> [options]"
    echo
    echo "Options:"
    echo "  --format [text|csv]   Output format (default: text)"
    echo "  --output <path>       Save output to file"
    echo "  --verbose             Enable verbose mode"
    echo "  --help                Show this help message"
}

# =========================
# Verbose Logging Function
# =========================
log_verbose() {
    if [ "$VERBOSE" -eq 1 ]; then
        echo "[VERBOSE] $1"
    fi
}

# =========================
# Analyze Log File
# =========================
analyze_log() {

    log_verbose "Starting analysis of $LOG_FILE"

    while IFS= read -r line; do

        # =========================
        # PASS Detection
        # =========================
        if [[ "$line" == *"TEST PASS"* ]]; then
            ((pass_count+=1))
            ((total_tests+=1))

            # Extract execution time
            if echo "$line" | grep -qE '[0-9]+\.[0-9]+s'; then
                time=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+s' | tr -d 's')

                execution_times+=("$time")

                # Add to running sum
                sum_time=$(awk "BEGIN {print $sum_time + $time}")

                # Update minimum time
                if awk "BEGIN {exit !($time < $min_time)}"; then
                    min_time=$time
                fi

                # Update maximum time
                if awk "BEGIN {exit !($time > $max_time)}"; then
                    max_time=$time
                fi
            fi
        fi

        # =========================
        # FAIL Detection
        # =========================
        if [[ "$line" == *"TEST FAIL"* ]]; then
            ((fail_count+=1))
            ((total_tests+=1))

            test_name=$(echo "$line" | sed -E 's/.*TEST FAIL: ([^ ]+).*/\1/')
            failed_tests+=("$test_name")

            # Extract execution time
            if echo "$line" | grep -qE '[0-9]+\.[0-9]+s'; then
                time=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+s' | tr -d 's')

                execution_times+=("$time")

                sum_time=$(awk "BEGIN {print $sum_time + $time}")

                if awk "BEGIN {exit !($time < $min_time)}"; then
                    min_time=$time
                fi

                if awk "BEGIN {exit !($time > $max_time)}"; then
                    max_time=$time
                fi
            fi
        fi

        # =========================
        # SKIP Detection
        # =========================
        if [[ "$line" == *"TEST SKIP"* ]]; then
            ((skip_count+=1))
            ((total_tests+=1))
        fi

    done < "$LOG_FILE"
}

# =========================
# Generate Report
# =========================
generate_report() {

    # Avoid division by zero
    if [ "$total_tests" -gt 0 ]; then
        pass_rate=$(awk "BEGIN {printf \"%.2f\", ($pass_count/$total_tests)*100}")
    else
        pass_rate="0.00"
    fi

    time_count=${#execution_times[@]}

    if [ "$time_count" -gt 0 ]; then
        avg_time=$(awk "BEGIN {printf \"%.2f\", $sum_time/$time_count}")
    else
        avg_time="0.00"
        min_time="N/A"
        max_time="N/A"
    fi

    # =========================
    # TEXT FORMAT
    # =========================
    if [ "$FORMAT" == "text" ]; then

        echo "=== RISC-V Simulation Log Analysis ==="
        echo "Log file: $LOG_FILE"
        echo "Analysis date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo

        echo "--- Results Summary ---"
        echo "Total tests : $total_tests"
        echo "Passed      : $pass_count"
        echo "Failed      : $fail_count"
        echo "Skipped     : $skip_count"
        echo "Pass Rate   : ${pass_rate}%"
        echo

        echo "--- Failed Tests ---"

        if [ "${#failed_tests[@]}" -eq 0 ]; then
            echo "None"
        else
            for test in "${failed_tests[@]}"; do
                echo "- $test"
            done
        fi

        echo
        echo "--- Timing Statistics ---"
        echo "Min time : ${min_time}s"
        echo "Max time : ${max_time}s"
        echo "Avg time : ${avg_time}s"
        echo

        if [ "$fail_count" -gt 0 ]; then
            echo "--- Verdict: FAIL ---"
        else
            echo "--- Verdict: PASS ---"
        fi

    # =========================
    # CSV FORMAT
    # =========================
    elif [ "$FORMAT" == "csv" ]; then

        echo "total_tests,passed,failed,skipped,pass_rate,avg_time"
        echo "$total_tests,$pass_count,$fail_count,$skip_count,$pass_rate,$avg_time"

    else
        echo "Error: Invalid format. Use text or csv"
        exit 1
    fi
}

# =========================
# Argument Parsing
# =========================
while [[ $# -gt 0 ]]; do

    case "$1" in

        --format)
            FORMAT="$2"
            shift 2
            ;;

        --output)
            OUTPUT="$2"
            shift 2
            ;;

        --verbose)
            VERBOSE=1
            shift
            ;;

        --help)
            usage
            exit 0
            ;;

        *)
            LOG_FILE="$1"
            shift
            ;;

    esac

done

# =========================
# Validation
# =========================
if [ -z "$LOG_FILE" ]; then
    echo "Error: Missing log file"
    usage
    exit 1
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file does not exist"
    exit 1
fi

# =========================
# Run Analysis
# =========================
analyze_log

# =========================
# Output Handling
# =========================
if [ -n "$OUTPUT" ]; then
    generate_report > "$OUTPUT"
    echo "Report written to: $OUTPUT"
else
    generate_report
fi

# =========================
# Exit Code
# =========================
if [ "$fail_count" -gt 0 ]; then
    exit 1
fi

exit 0