# Use a lightweight Python image
FROM python:3.11-slim

# Install system dependencies for PyAudio (if needed)
RUN apt-get update && apt-get install -y \
    gcc \
    portaudio19-dev \
    libasound2-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files (including db.sqlite3 if it exists)
COPY . .

# Collect static files (important for Render)
RUN python manage.py collectstatic --noinput

# Run migrations
RUN python manage.py migrate

# Expose port (Render uses $PORT)
EXPOSE 8000

# Start Django with Gunicorn
CMD gunicorn chatbot_project.wsgi:application --bind 0.0.0.0:$PORT
