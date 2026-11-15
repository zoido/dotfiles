#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Obsidian: Add Task
# @vicinae.description Add a task to the Tasks section of today's Obsidian daily note.
# @vicinae.mode silent
# @vicinae.icon ☑️
# @vicinae.keywords ["obsidian", "daily", "task"]
# @vicinae.argument1 { "type": "text", "placeholder": "Task" }

exec "$HOME/.sh/obsidian-daily-add" " " "Tasks" "$1"
