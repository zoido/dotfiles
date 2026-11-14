# System setup

These scripts set up system files outside the home directory. Chezmoi does not run them, because chezmoi ignores source paths that start with `.`. You run them yourself.

Each script asks for `sudo` if you do not run it as root. You can run each script more than once.

## Run all scripts

```sh
~/.local/share/chezmoi/.etc/setup.sh
```

The `setup.sh` script runs the numbered scripts in order.

## Scripts

1. `10-timesync.sh` turns on time sync over NTP (network time protocol).
2. `20-cachyos-repo.sh` adds the CachyOS package repositories to `/etc/pacman.conf`. It uses the upstream [`cachyos-repo-add-script`](https://github.com/CachyOS/cachyos-repo-add-script). If the repositories are already there, it does nothing.
3. `30-mirrors.sh` installs `cachyos-rate-mirrors` and sets CZ as the entry country for mirror ranking. It turns off `reflector.timer`, turns on `cachyos-rate-mirrors.timer`, and ranks the mirrors once. This script needs the CachyOS repositories from step 2.
4. `40-1password-browsers.sh` adds Waterfox to `/etc/1password/custom_allowed_browsers`. After this step, the 1Password browser extension can connect to the desktop app. Restart 1Password after you run it.
5. `50-swayosd.sh` installs `swayosd` and turns on `swayosd-libinput-backend.service`. This system service reads the keyboard input and tells the swayosd server when you press Caps Lock or Num Lock. The server then shows the lock key state on the screen.

## Mirror ranking

The `cachyos-rate-mirrors` tool ranks the Arch mirrors in `/etc/pacman.d/mirrorlist` and the CachyOS mirrors in `/etc/pacman.d/cachyos-*mirrorlist`. Reflector also writes `/etc/pacman.d/mirrorlist`, so the two tools overwrite each other. For this reason, `30-mirrors.sh` turns off `reflector.timer`.
