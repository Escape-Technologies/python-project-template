# Build stage
FROM python:3.11-slim AS builder

# Install uv
RUN pip install uv

WORKDIR /app

# Copy the entire project
COPY . .

# Configure uv to create the virtualenv inside the project directory
RUN uv venv

# Install dependencies without installing the project itself
RUN uv sync

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