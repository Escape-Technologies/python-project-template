# Build stage
FROM python:3.11-slim AS builder

# Install poetry
RUN pip install poetry

WORKDIR /app

# Copy the entire project
COPY . .

# Configure poetry to create the virtualenv inside the project directory
RUN poetry config virtualenvs.in-project true

# Install dependencies without installing the project itself
RUN poetry install --no-root --no-interaction --no-ansi

# Runtime stage
FROM python:3.11-slim

WORKDIR /app

# Copy only the necessary files from builder
COPY --from=builder /app/.venv .venv
COPY --from=builder /app/app ./app

# Set PATH to use the virtualenv
ENV PATH="/app/.venv/bin:$PATH"

# Set the entrypoint to run the CLI
ENTRYPOINT ["python", "-m", "app"] 