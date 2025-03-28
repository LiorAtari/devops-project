FROM python:3.10-slim

WORKDIR /app

# Because im using Python-slim - these packages are required
RUN apt-get update && apt-get install -y \
    pkg-config \
    gcc \
    libmariadb-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app

USER appuser

CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8080", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
