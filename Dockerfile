FROM python:3.11-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# 1. Copy the requirement files first
COPY pyproject.toml uv.lock README.md ./

# 2. Install dependencies (standard way, no fancy cache mounts)
RUN uv sync --frozen --no-install-project

# 3. Copy the rest of the source code
COPY src/ ./src/
COPY .github/core/ ./.github/core/

# 4. Run the final sync
RUN uv sync --frozen

ENV PATH="/app/.venv/bin:$PATH"

# 5. The cloud deployment command on port 8000
CMD ["alpaca-mcp-server", "serve", "--transport", "streamable-http", "--host", "0.0.0.0", "--port", "8000"]
