FROM python:3.11-slim

# Install system dependencies (needed for PyAudio)
RUN apt-get update && apt-get install -y \
    gcc \
    portaudio19-dev \
    libasound2-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy requirements first (better Docker caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Run Django migrations
RUN python manage.py migrate

# Expose port (Render uses $PORT internally)
EXPOSE 8000

# Start Django with Gunicorn
CMD gunicorn chatbot_project.wsgi:application --bind 0.0.0.0:$PORT
