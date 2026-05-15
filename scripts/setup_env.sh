#!/bin/bash

set -euo pipefail

echo "🔧 Setting up environment..."

# =========================
# Check required tools
# =========================
for cmd in bash grep awk sed; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: $cmd is not installed"
        exit 1
    else
        echo "$cmd found"
    fi
done

# =========================
# Create output directory
# =========================
mkdir -p output

echo "✔ Environment setup complete"