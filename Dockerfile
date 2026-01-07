FROM python:3.11-slim

# Install system dependencies needed for PyAudio and Django
RUN apt-get update && apt-get install -y \
    gcc \
    portaudio19-dev \
    libasound2-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first (better Docker caching)
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the project
COPY . .

# Run Django migrations
RUN python manage.py migrate

# Start the server
CMD gunicorn chatbot_project.wsgi:application --bind 0.0.0.0:$PORT
