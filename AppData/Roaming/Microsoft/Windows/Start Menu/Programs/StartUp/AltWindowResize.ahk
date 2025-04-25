LWin & RButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY, EWD_OriginalW, EWD_OriginalH, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%

if EWD_WinState = 1
    WinRestore ahk_id %EWD_MouseWin%
    WinMove, ahk_id %EWD_MouseWin%,, EWD_OriginalPosX
                                   , EWD_OriginalPosY
                                   , EWD_OriginalW
                                   , EWD_OriginalH

SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.

If (EWD_MouseStartX < EWD_OriginalPosX + (EWD_OriginalW / 2))
    EWD_HorizontalDirection := 1
Else
    EWD_HorizontalDirection := -1
If (EWD_MouseStartY < EWD_OriginalPosY + (EWD_OriginalH / 2))
    EWD_VerticalDirection := 1
Else
    EWD_VerticalDirection := -1

return

EWD_WatchMouse:
GetKeyState, EWD_RButtonState, RButton, P
if EWD_RButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,EWD_WinW,EWD_WinH, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.

WinActivate, ahk_id %EWD_MouseWin%

XOffset := EWD_MouseX - EWD_MouseStartX
YOffset := EWD_MouseY - EWD_MouseStartY

WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + ((EWD_HorizontalDirection + 1) * XOffset / 2)
                               , EWD_WinY + ((EWD_VerticalDirection + 1) * YOffset / 2)
                               , EWD_WinW - (EWD_HorizontalDirection * XOffset)
                               , EWD_WinH - (EWD_VerticalDirection * YOffset)


EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return
