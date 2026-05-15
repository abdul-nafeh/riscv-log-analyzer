
# RISC-V Log Analyzer - Usage Guide

This document explains how to use the RISC-V Log Analyzer tool and its available options.

---

## 🧾 Basic Syntax

```bash
./scripts/analyze.sh <log_file> [options]

## example

./scripts/analyze.sh test_data/sample_fail.log

./scripts/analyze.sh test_data/sample_fail.log --verbose

./scripts/analyze.sh test_data/sample_fail.log --output output/report.txt

make run-all