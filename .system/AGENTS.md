# System setup scripts

Each script in this folder sets up one part of the system outside the home directory. `setup.sh` runs the scripts in the order of its `scripts` list.

## Add a script

1. Create `NN-name.sh`. `NN` is a two-digit number that shows the position of the script in the run order. Use a free number between the numbers of the scripts that run before and after it.
2. Make the file executable with `chmod +x`. Chezmoi does not manage this folder, so do not use the `executable_` prefix.
3. Start the script with this header:

   ```bash
   #!/bin/bash

   # One sentence that tells what the script does.

   set -eo pipefail

   [[ ${EUID} -eq 0 ]] || exec sudo -- "$0" "$@"
   ```

4. Add the file name to the `scripts` list in `setup.sh`, at its position in the run order.

## Rules for scripts

- A script must give the same result when you run it more than once. For example, use `pacman -S --needed`, and do not add a line to a file if the line is already there.
- Put the values that can change, for example a user name or a file path, in variables at the top of the script.
- If the user must do something after the script, for example restart an app or reboot, print it at the end of the script.
- To read a file from this repository, find it relative to the script folder with `script_dir`. See `70-xkb-zok.sh`.

## Files that a script installs

- Put each file that a script installs in its own file in a folder with the name of the script, without the number. For example, `95-restic.sh` installs the files in `restic/`. Use this for helper scripts, systemd units, configuration templates, and text such as a README.
- If a file is short and simple, write it in the script with a heredoc. A short configuration file in `/etc` is an example. See `30-mirrors.sh` and `80-dns-quad9.sh`.
- If a file is long, or if it needs its own comments, use a separate file.

## Documentation

- Document a script only inside the script. Do not add it to `README.md`. The README tells only what the folder is for.
- The comment at the top of the script tells what the script does. Add more sentences there only for facts that the user must know before they run it.
- Put each explanation in a comment above the code that it explains. For example, explain why a setting is necessary, or what a side effect is.
