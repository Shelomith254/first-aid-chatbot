# Use Python 3.11
FROM python:3.11-slim

# Install system dependencies for PyAudio
RUN apt-get update && apt-get install -y \
    build-essential \
    portaudio19-dev \
    libasound2-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose port
EXPOSE 10000

# Run Django migrations and start Gunicorn server
CMD python manage.py migrate && gunicorn chatbot_project.wsgi:application --bind 0.0.0.0:10000
