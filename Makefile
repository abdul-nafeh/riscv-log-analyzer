SHELL := /bin/bash
SCRIPT := scripts/analyze.sh
LOG_DIR := test_logs

.PHONY: all test clean help

all: test

test:
	@echo "Running log analysis tests..."
	./$(SCRIPT) $(LOG_DIR)/*.log

clean:
	@echo "Cleaning up output files..."
	rm -rf output/
	rm -f *.txt

help:
	@echo "Usage:"
	@echo "  make all   - Run all tests"
	@echo "  make clean - Remove temporary files"
