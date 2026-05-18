# Variables
SHELL := /bin/bash
SCRIPT := scripts/analyze.sh
SUCCESS_LOG := test_logs/simulation_success.log
FAIL_LOG := test_logs/simulation_fail.log

.PHONY: all setup test test-fail clean help

all: setup test

setup:
	@chmod +x $(SCRIPT)

test: setup
	@echo "Running verification on passing log..."
	./$(SCRIPT) $(SUCCESS_LOG)

test-fail: setup
	@echo "Running verification on failing log..."
	@./$(SCRIPT) $(FAIL_LOG) || true

clean:
	@echo "Cleaning up generated outputs..."
	@rm -rf build/

help:
	@echo "RISC-V Log Analyzer Automation Platform"
	@echo "Available commands:"
	@echo "  make setup     - Grant execution permissions to scripts"
	@echo "  make test      - Run analyzer against passing simulation logs"
	@echo "  make test-fail - Run analyzer against failing simulation logs"
	@echo "  make clean     - Clear out temporary build structures"
