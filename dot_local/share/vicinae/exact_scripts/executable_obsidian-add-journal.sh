#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Obsidian: Add Journal Entry
# @vicinae.description Add a journal entry to the Journal section of today's Obsidian daily note.
# @vicinae.mode silent
# @vicinae.icon 📔
# @vicinae.keywords ["obsidian", "daily", "journal"]
# @vicinae.argument1 { "type": "text", "placeholder": "Journal entry" }

exec "$HOME/.sh/obsidian-daily-add" "j" "Journal" "$1"
