#!/bin/bash

set -euo pipefail

INPUT_FILE="${1:-}"
OUTPUT_FILE="${2:-output/final_report.txt}"

if [ -z "$INPUT_FILE" ]; then
    echo "Usage: ./generate_report.sh <input_file> [output_file]"
    exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file not found"
    exit 1
fi

mkdir -p output

echo "📊 Generating report..."

{
echo "=================================="
echo "   RISC-V FINAL REPORT"
echo "=================================="
echo ""

cat "$INPUT_FILE"

echo ""
echo "Generated on: $(date)"
echo "=================================="
} > "$OUTPUT_FILE"

echo "✔ Report saved to $OUTPUT_FILE"