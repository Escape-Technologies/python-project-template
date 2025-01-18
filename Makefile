.PHONY: all python-poetry python-dependencies git-hooks-init

all: python-poetry python-dependencies git-hooks-init
	echo "---- Your working directory is all set :) ----"

python-poetry:
	@echo "---- Installing Python Poetry ----"
	pip install -U pip
	pip install -U poetry
	poetry config virtualenvs.in-project true
	poetry config virtualenvs.path ".venv"

python-dependencies: python-poetry
	@echo "---- Installing Python dependencies ----"
	poetry install
	poetry self add poetry-plugin-sembump

git-hooks-init:
	@echo "---- Git hooks init (using Gookme) ----"
	curl -sSL https://raw.githubusercontent.com/LMaxence/gookme/main/scripts/install.sh | bash
	gookme init --all

.PHONY: build

build:
	docker build -t app-cli .

run:
	docker run app-cli
