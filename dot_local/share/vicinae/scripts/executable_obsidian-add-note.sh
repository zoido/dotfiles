#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Obsidian: Add Note
# @vicinae.description Add a note to the Notes section of today's Obsidian daily note.
# @vicinae.mode silent
# @vicinae.icon 📝
# @vicinae.keywords ["obsidian", "daily", "note"]
# @vicinae.argument1 { "type": "text", "placeholder": "Note" }

exec "$HOME/.sh/obsidian-daily-add" "n" "Notes" "$1"
