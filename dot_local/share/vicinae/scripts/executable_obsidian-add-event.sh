#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Obsidian: Add Event
# @vicinae.description Add an event to the Events section of today's Obsidian daily note.
# @vicinae.mode silent
# @vicinae.icon 📅
# @vicinae.keywords ["obsidian", "daily", "event"]
# @vicinae.argument1 { "type": "text", "placeholder": "Event" }

exec "$HOME/.sh/obsidian-daily-add" "o" "Events" "$1"
