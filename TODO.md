# Autodelete Fix TODO

## Bugs Fixed
- [x] Plan created and approved

## Implementation Steps

- [x] Step 1: Add `_is_autodelete_enabled_for_channel()` and `_get_autodelete_limit_for_channel()` helper methods
- [x] Step 2: Fix `autodelete_background_task` — remove `auto_delete_enabled_global` gate, add per-server guild iteration
- [x] Step 3: Fix `on_message` — remove `global_enabled` gate, use new helper
- [x] Step 4: Fix `_cleanup_channel_messages` — use new limit helper, increase fetch window from `limit+50` to `limit+500`
- [x] Step 5: Add `/autodelete_server` slash command for guild-wide autodelete
- [x] Step 6: Fix `_prepare_pin_files` — remove broken `self._prepared_files` shared state and type confusion
- [x] Step 7: Fix `_prepare_pin_content` — remove stale `self._prepared_files` reference

## All fixes complete ✅
