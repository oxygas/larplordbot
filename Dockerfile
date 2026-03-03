# Use Python 3.11 slim image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port for web server
EXPOSE 8080

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV ZEABUR_ENVIRONMENT=production
ENV PORT=8080

# Run the application using Python directly
CMD ["python", "-c", "
import os
import sys
import threading
import time

# Import after env vars are set
from dotenv import load_dotenv

# Try to load .env but don't fail if it doesn't exist
load_dotenv()

# Now import and run the bot
from app import app
from bot import WebhookBot

token = os.getenv('DISCORD_BOT_TOKEN')

def run_bot():
    if not token:
        print('ERROR: DISCORD_BOT_TOKEN not set. Bot will not start.')
        return
    try:
        bot = WebhookBot()
        bot.run(token)
    except Exception as e:
        print(f'ERROR starting bot: {e}')

# Only start bot if token is available
if token:
    print('Starting Discord bot in background thread...')
    bot_thread = threading.Thread(target=run_bot, daemon=True)
    bot_thread.start()
    # Give bot a moment to start
    time.sleep(2)
else:
    print('WARNING: No Discord bot token - running web server only')

# Run Flask app
print('Starting Flask web server on port 8080...')
app.run(host='0.0.0.0', port=8080)
"]

