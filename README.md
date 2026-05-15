# Project by: Nafeh
# RISC-V Log Analyzer

## Project Title
RISC-V Simulation Log Analyzer (Bash Automation Tool)

---

## 📖 Description

The RISC-V Log Analyzer is a Bash-based tool designed to parse and analyze simulation log files generated from RISC-V CPU test environments.

It extracts key information such as:
- Total number of tests
- PASS / FAIL / SKIP counts
- Execution time statistics
- Failed test cases
- Performance summary

It supports both **text and CSV output formats**, along with verbose debugging mode and full automation via Makefile.

---

## ⚙️ Installation

Clone the repository:

```bash
git clone <your-repo-url>
cd riscv-log-analyzer

## make scripts executable
chmod +x scripts/*.sh