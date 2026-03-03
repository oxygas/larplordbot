# Agent Instructions (webhook_obsecure)

## Repo Quick Facts

- Main bot entrypoint: `bot.py` (async Discord bot)
- Zeabur/health-check entrypoint: `app.py` (Flask `GET /health`, runs bot in a background thread when `ZEABUR_ENVIRONMENT` is set)
- Test suite: `tests/` (stdlib `unittest`, run inside the venv so `discord.py` is available)

## Commands (Local)

```bash
# Create venv (if needed) + install deps
python -m venv venv
./venv/bin/pip install -r requirements.txt

# Run the bot (requires DISCORD_BOT_TOKEN in .env or env)
./venv/bin/python bot.py

# Run Zeabur-style web server + bot (health checks)
ZEABUR_ENVIRONMENT=production PORT=8080 ./venv/bin/python app.py

# Run tests
./venv/bin/python -m unittest discover -s tests -q
```

Notes:
- `start_bot.sh` exists, but it references `setup_token.sh` which is not present in this repo. Prefer creating `.env` from `.env.example` manually.

## Environment Variables

Required:
- `DISCORD_BOT_TOKEN`

Common optional:
- `DEBUG_GUILD_ID` (sync slash commands to a single guild for faster iteration)
- `PIN_RESEND_CHANNEL_ID`
- `AUTO_DELETE_COUNT`
- `CUSTOM_PREFIX` (comma-separated prefixes supported)
- `PUNISH_ROLE_ID`

Other optional (see `bot.py` for defaults/behavior):
- `AUTO_DELETE_ENABLED`
- `AUTO_DELETE_COOLDOWN`
- `AUTO_DELETE_RATE_LIMIT_START`
- `AUTO_DELETE_RATE_LIMIT_MAX`
- `AUTO_DELETE_BULK_DELETE`
- `AUTO_DELETE_EXCLUDE_PINNED`
- `AUTO_DELETE_EXCLUDE_BOTS`
- `AUTO_DELETE_DELETE_AGE_HOURS`
- `FILTER_ENABLED`
- `FILTER_DELETE_INSTEAD`
- `FILTER_WORDS`
- `CENSOR_COVER_WORDS`
- `SCRAPE_OUTPUT_DIR`
- `ZEABUR_ENVIRONMENT` (enables Zeabur mode)
- `PORT` (used by `app.py`)

## Persistent Local State

The bot stores runtime state in repo-local JSON files (for development convenience):
- `autodelete_settings.json`
- `previous_roles.json`
- `resent_pins.json`
- `censor_settings.json`
- `pin_settings.json`
- `guild_settings.json`
- `style_reward_model.json`

Keep these files small and schema-stable. Do not commit real guild/user data.

## Change Hygiene

- Do not commit secrets: `.env` is ignored; avoid printing tokens in logs or docs.
- If you add/rename env vars, update `.env.example` and the docs (`README.md`, `ZEABUR_DEPLOYMENT.md`) in the same change.
- Prefer adding/adjusting tests in `tests/` for pure logic changes. Avoid tests that require real Discord API access.

---

<INSTRUCTIONS>
## Skills
A skill is a set of local instructions to follow that is stored in a `SKILL.md` file. Below is the list of skills that can be used. Each entry includes a name, description, and file path so you can open the source for full instructions when using a specific skill.
### Available skills
- skill-creator: Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Codex's capabilities with specialized knowledge, workflows, or tool integrations. (file: /home/sigh/.codex/skills/.system/skill-creator/SKILL.md)
- skill-installer: Install Codex skills into $CODEX_HOME/skills from a curated list or a GitHub repo path. Use when a user asks to list installable skills, install a curated skill, or install a skill from another repo (including private repos). (file: /home/sigh/.codex/skills/.system/skill-installer/SKILL.md)
### How to use skills
- Discovery: The list above is the skills available in this session (name + description + file path). Skill bodies live on disk at the listed paths.
- Trigger rules: If the user names a skill (with `$SkillName` or plain text) OR the task clearly matches a skill's description shown above, you must use that skill for that turn. Multiple mentions mean use them all. Do not carry skills across turns unless re-mentioned.
- Missing/blocked: If a named skill isn't in the list or the path can't be read, say so briefly and continue with the best fallback.
- How to use a skill (progressive disclosure):
  1) After deciding to use a skill, open its `SKILL.md`. Read only enough to follow the workflow.
  2) When `SKILL.md` references relative paths (e.g., `scripts/foo.py`), resolve them relative to the skill directory listed above first, and only consider other paths if needed.
  3) If `SKILL.md` points to extra folders such as `references/`, load only the specific files needed for the request; don't bulk-load everything.
  4) If `scripts/` exist, prefer running or patching them instead of retyping large code blocks.
  5) If `assets/` or templates exist, reuse them instead of recreating from scratch.
- Coordination and sequencing:
  - If multiple skills apply, choose the minimal set that covers the request and state the order you'll use them.
  - Announce which skill(s) you're using and why (one short line). If you skip an obvious skill, say why.
- Context hygiene:
  - Keep context small: summarize long sections instead of pasting them; only load extra files when needed.
  - Avoid deep reference-chasing: prefer opening only files directly linked from `SKILL.md` unless you're blocked.
  - When variants exist (frameworks, providers, domains), pick only the relevant reference file(s) and note that choice.
- Safety and fallback: If a skill can't be applied cleanly (missing files, unclear instructions), state the issue, pick the next-best approach, and continue.
</INSTRUCTIONS>

