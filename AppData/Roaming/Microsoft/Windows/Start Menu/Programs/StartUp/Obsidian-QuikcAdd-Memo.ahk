SendMode Input
SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx

#+m::
    WinActivate, i) Obsidian

    Run "obsidian://advanced-uri?vault=Default&commandname=QuickAdd: 🪵 Rapid Log..."
Return