# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Make start_bot.sh executable
RUN chmod +x start_bot.sh

# Expose port for web server
EXPOSE 8080

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV ZEABUR_ENVIRONMENT=production

# Run the application using Python directly instead of shell script
# This avoids permission issues with shell scripts
CMD ["python", "-c", "
import os
import sys
import threading
from dotenv import load_dotenv
from app import app
from bot import WebhookBot

# Start bot in background thread
def run_bot():
    token = os.getenv('DISCORD_BOT_TOKEN')
    if not token:
        print('Error: DISCORD_BOT_TOKEN not set')
        return
    bot = WebhookBot()
    bot.run(token)

# Only start bot if token is available
if os.getenv('DISCORD_BOT_TOKEN'):
    bot_thread = threading.Thread(target=run_bot, daemon=True)
    bot_thread.start()

# Run Flask app
app.run(host='0.0.0.0', port=int(os.getenv('PORT', 8080)))
"]

