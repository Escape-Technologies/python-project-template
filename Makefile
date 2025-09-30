.PHONY: all python-uv python-dependencies git-hooks-init

all: python-uv python-dependencies git-hooks-init
	echo "---- Your working directory is all set :) ----"

python-uv:
	@echo "---- Installing Python UV ----"
	pip install -U pip
	pip install -U uv
	uv venv
	uv config virtualenvs.in-project true
	uv config virtualenvs.path ".venv"

python-dependencies: python-uv
	@echo "---- Installing Python dependencies ----"
	uv sync

git-hooks-init:
	@echo "---- Git hooks init (using Gookme) ----"
	curl -sSL https://raw.githubusercontent.com/LMaxence/gookme/main/scripts/install.sh | bash
	gookme init --all

.PHONY: build

build:
	docker build -t app-cli .

run:
	docker run app-cli
