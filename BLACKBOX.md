# Discord Webhook Bot (webhook_obsecure)

## Project Overview
This is a production-ready Discord bot written in Python using `discord.py`. Its primary feature is a `/msg` slash command that allows users to send messages via webhooks, perfectly impersonating the user who ran the command. 

Key features include:
- **User Impersonation:** Messages appear exactly as if sent by the user.
- **Attachment Support:** Handles images, videos, audio, and documents (up to 8MB, with fallbacks to Catbox/file.io for larger files).
- **Channel Cleanup:** Automatically maintains a maximum number of messages per channel (excluding pins).
- **Pin Resending:** Automatically resends pinned messages to a specified channel, preserving attachments.
- **Moderation Tools:** Includes commands for ban, kick, mute, timeout, and clearing messages.
- **AI Style Reward Model:** A custom system that analyzes messages and attempts to "humanize" or adjust the style of text based on various metrics (formality, slang, AI phrases, etc.).

The architecture relies on `bot.py` for the core Discord logic and `app.py` as a Flask wrapper to provide a health-check endpoint, which is particularly useful for deployments on platforms like Zeabur.

## Building and Running

### Prerequisites
- Python 3.x
- A Discord Bot Token (from the Discord Developer Portal)

### Local Development Setup
1. **Create a virtual environment and install dependencies:**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   pip install -r requirements.txt
   ```

2. **Configure Environment Variables:**
   Copy the example environment file and add your token:
   ```bash
   cp .env.example .env
   # Edit .env and set DISCORD_BOT_TOKEN=your_token_here
   ```

3. **Run the Bot:**
   ```bash
   python bot.py
   ```

### Running with Web Server (Zeabur/Production Mode)
To run the bot alongside a Flask web server (useful for health checks in cloud environments):
```bash
ZEABUR_ENVIRONMENT=production PORT=8080 python app.py
```

### Testing
The project uses the standard `unittest` framework. Tests are located in the `tests/` directory.
```bash
python -m unittest discover -s tests -q
```

## Development Conventions & Architecture

- **State Management:** The bot stores runtime state in local JSON files (e.g., `autodelete_settings.json`, `guild_settings.json`, `style_reward_model.json`, `previous_roles.json`). See `SERVER_MEMORY.md` for a detailed breakdown of how server memory works.
- **Cloud Deployment Warning:** Because memory is file-based, deploying to ephemeral environments (like Zeabur) **requires a Persistent Volume** mounted to the app directory to prevent data loss on restart.
- **Environment Variables:** Configuration is heavily driven by environment variables. Key variables include `DISCORD_BOT_TOKEN`, `DEBUG_GUILD_ID` (for faster slash command syncing during dev), and various feature flags (e.g., `AUTO_DELETE_ENABLED`).
- **Webhook Caching:** The bot uses a thread-safe `WebhookCache` with a TTL (Time To Live) to efficiently manage webhooks without hitting Discord API rate limits excessively.
- **Error Handling:** The bot includes comprehensive error handling for missing permissions, API limits, and invalid file types/sizes.
