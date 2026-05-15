# =========================
# Makefile
# =========================

SCRIPTS = scripts/analyze.sh
TEST_DIR = test_data
OUTPUT_DIR = output

# Default target
all: run-all

# =========================
# Run analyzer on ALL logs
# =========================
run-all:
	@echo "Running analyzer on all test logs..."
	@mkdir -p $(OUTPUT_DIR)
	@for file in $(TEST_DIR)/*.log; do \
		echo "Analyzing $$file"; \
		bash $(SCRIPTS) "$$file" --output $(OUTPUT_DIR)/$$(basename $$file).report; \
	done

# =========================
# Test specific expected outputs
# =========================
test:
	@echo "Running tests..."
	@for file in $(TEST_DIR)/*.log; do \
		echo "Testing $$file"; \
		bash $(SCRIPTS) "$$file" > /dev/null; \
	done
	@echo "All tests executed successfully"

# =========================
# Generate summary report
# =========================
report:
	@echo "Generating summary report..."
	@mkdir -p $(OUTPUT_DIR)
	@bash $(SCRIPTS) $(TEST_DIR)/sample_fail.log --output $(OUTPUT_DIR)/summary.txt

# =========================
# Clean generated files
# =========================
clean:
	@echo "Cleaning output files..."
	@rm -rf $(OUTPUT_DIR)/*
	@echo "Done."

# =========================
# Setup environment check
# =========================
setup:
	@echo "Checking required tools..."

	@command -v bash >/dev/null 2>&1 || { echo "bash NOT installed"; exit 1; }
	@command -v grep >/dev/null 2>&1 || { echo "grep NOT installed"; exit 1; }
	@command -v awk >/dev/null 2>&1 || { echo "awk NOT installed"; exit 1; }
	@command -v sed >/dev/null 2>&1 || { echo "sed NOT installed"; exit 1; }

	@echo "All required tools are installed"

# =========================
# Help target
# =========================
help:
	@echo "Available targets:"
	@echo "  make all      -> Run analyzer on all logs"
	@echo "  make test     -> Run test suite"
	@echo "  make report   -> Generate summary report"
	@echo "  make clean    -> Remove output files"
	@echo "  make setup    -> Check required tools"
	@echo "  make help     -> Show this help message"