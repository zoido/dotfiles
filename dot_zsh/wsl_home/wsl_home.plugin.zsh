export WIN_HOME_RAW="$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null)"
export WIN_HOME="$(wslpath $WIN_HOME_RAW)"
