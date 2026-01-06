FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    gcc \
    portaudio19-dev \
    libasound2-dev \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

EXPOSE 10000

CMD ["python", "manage.py", "runserver", "0.0.0.0:10000"]
