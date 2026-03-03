# Server Settings & Memory Architecture

This document explains how the Discord Webhook Bot stores and remembers settings, preferences, and state for each individual server (guild) it is in.

## Overview

Instead of requiring a heavy external database (like PostgreSQL or MongoDB), this bot uses a lightweight, file-based JSON storage system. This allows the bot to be easily deployed and moved while retaining all server-specific configurations.

All memory is loaded into RAM when the bot starts (via `_load_persistent_data()`) and is saved back to the disk whenever a setting is changed (via `_save_persistent_data()`).

## Memory Files

The bot's memory is divided into several specific JSON files, each handling a different aspect of the bot's functionality:

### 1. `guild_settings.json`
**Purpose:** Stores general configuration and feature toggles for each server.
**Structure:** Keyed by Guild ID (as a string).
**Stores:**
- `auto_train_enabled`: Whether the AI style auto-training is active.
- `auto_train_target_rating`: The target "human" rating (1-10).
- `auto_train_save_every`: How often to save training data.
- `auto_train_strategy`: The preferred text transformation strategy (e.g., `identity`, `casualize`).

### 2. `autodelete_settings.json`
**Purpose:** Remembers which channels have the auto-delete (message limit) feature enabled and what their specific limits are.
**Structure:** Keyed by Channel ID (as a string).
**Stores:**
- `enabled`: Boolean indicating if the feature is active for the channel.
- `limit`: The maximum number of messages to keep in that channel (e.g., 30).

### 3. `pin_settings.json`
**Purpose:** Remembers the destination channel for pinned messages.
**Structure:** Keyed by Guild ID (as a string).
**Stores:**
- The Channel ID (as a string) where pinned messages should be automatically resent.

### 4. `censor_settings.json`
**Purpose:** Tracks whether the word filter/censor feature is enabled for a specific server.
**Structure:** Keyed by Guild ID (as a string).
**Stores:**
- Boolean (`true`/`false`) indicating if the censor is active.

### 5. `previous_roles.json`
**Purpose:** Crucial for the punishment (`/lq` and `/ulq`) system. When a user is punished, their current roles are stripped and saved here so they can be perfectly restored later.
**Structure:** Keyed by User ID (as a string).
**Stores:**
- A list of Role IDs that the user had before being punished.

### 6. `resent_pins.json`
**Purpose:** Prevents the bot from infinitely resending the same pinned message if the bot restarts or if a message is unpinned and repinned.
**Structure:** Keyed by Guild ID (as a string).
**Stores:**
- A list/set of Message IDs that have already been processed and resent.

### 7. `style_reward_model.json`
**Purpose:** The "brain" of the AI style impersonation. It remembers the weights, biases, and learning rates used to score and adjust how "AI-like" or "Human-like" a message sounds.
**Stores:**
- `weights`: Values for features like `formality`, `slang`, `emoji_ratio`, etc.
- `strategy_stats`: Success rates of different text modification strategies.
- `running_score`: The historical average score of generated messages.

## Deployment Considerations (Zeabur / Cloud)

⚠️ **Important Note for Cloud Deployments:**
Because this bot uses local `.json` files for memory, deploying to ephemeral (serverless) environments like Zeabur requires a **Persistent Volume**. 

If you deploy this without a persistent volume, every time the bot restarts or redeploys, the container's filesystem will be wiped, and **all server settings, punishment roles, and AI training data will be lost.**

**To fix this in Zeabur:**
1. Go to your service settings in Zeabur.
2. Add a **Volume Binding**.
3. Mount a volume path to the directory where the bot runs (e.g., `/app` or `/opt/webhook-bot`).
4. This ensures the `.json` files survive restarts and redeployments.