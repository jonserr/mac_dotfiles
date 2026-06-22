SHELL := /bin/bash

.PHONY: install
install:
	@bash scripts/bootstrap.sh

.PHONY: check
check:
	@bash -n scripts/bootstrap.sh
	@echo "bootstrap.sh syntax OK"

.PHONY: edit
edit:
	@code zshrc oh-my-posh/jon-microverse-power.omp.json scripts/bootstrap.sh Makefile README.md

.PHONY: push
push:
	@git add .
	@git commit -m "Update macOS dotfiles"
	@git push
