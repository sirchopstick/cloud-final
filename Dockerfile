FROM python:3.11-slim AS builder

WORKDIR /app

COPY requirements.txt .

RUN python -m venv /venv \
    && /venv/bin/pip install --no-cache-dir --upgrade pip \
    && /venv/bin/pip install --no-cache-dir -r requirements.txt

FROM python:3.11-slim AS final

WORKDIR /app

COPY --from=builder /venv /venv
COPY . .

# run as non-root
RUN useradd -m appuser
USER appuser

ENV PATH="/venv/bin:$PATH"

EXPOSE 8000

CMD ["uvicorn", "test_s3:app", "--host", "0.0.0.0", "--port", "8000"]