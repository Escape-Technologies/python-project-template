.PHONY: all poetry_install dependencies git_hooks_init

all: poetry_install dependencies git_hooks_init
	echo "---- Your working directory is all set :) ----"

poetry_install:
	@echo "---- Installing Python Poetry ----"
	pip install -U pip
	pip install -U poetry
	poetry config virtualenvs.in-project true
	poetry config virtualenvs.path ".venv"

dependencies: poetry_install
	@echo "---- Installing Python dependencies ----"
	poetry install

git_hooks_init:
	@echo "---- Git hooks init (using mookme) ----"
	npm install
	npx mookme init --only-hook --skip-types-selection
