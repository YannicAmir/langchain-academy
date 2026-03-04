# LangChain Academy — one-command setup and run
# Use: make setup && make studio MODULE=2

PYTHON ?= python3
VENV := .venv
BIN := $(VENV)/bin

.PHONY: setup setup-uv studio help

# Default module for studio (1-5)
MODULE ?= 2

help:
	@echo "Targets:"
	@echo "  make setup      Create .venv and install dependencies (pip)."
	@echo "  make setup-uv   Create .venv and install deps with uv (faster, lockfile)."
	@echo "  make studio     Run LangGraph Studio for a module (MODULE=1..5, default 2)."
	@echo "  make studio MODULE=3"
	@echo ""
	@echo "After 'make setup', open: https://smith.langchain.com/studio/?baseUrl=http://127.0.0.1:2024"

setup:
	$(PYTHON) -m venv $(VENV)
	$(BIN)/pip install --upgrade pip
	$(BIN)/pip install -r requirements.txt
	@echo "Done. Activate with: source $(BIN)/activate"
	@echo "Then run: make studio MODULE=$(MODULE)"

# Optional: use uv for fast, reproducible installs (pip install uv)
setup-uv:
	@command -v uv >/dev/null 2>&1 || { echo "Install uv: pip install uv"; exit 1; }
	uv venv
	uv pip install -r requirements.txt
	@echo "Done. Activate with: source $(BIN)/activate"

# Run LangGraph Studio for module 1-5 (ensure you ran 'make setup' first)
studio:
	@test -d $(VENV) || { echo "Run 'make setup' first."; exit 1; }
	@test -d module-$(MODULE)/studio || { echo "No module-$(MODULE)/studio. Use MODULE=1..5."; exit 1; }
	cd module-$(MODULE)/studio && ../../$(VENV)/bin/langgraph dev
