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
6. `60-ly.sh` installs [Ly](https://wiki.archlinux.org/title/Ly), a display manager with a text interface. It turns off the login prompt (`getty@tty1.service`) on tty1 and turns on `ly@tty1.service` in its place. Ly starts on tty1 after the next reboot. The script does not start Ly at once, because that would stop a session that runs on tty1.
7. `70-xkb-zok.sh` copies the `zok` keyboard layout from `private_dot_config/xkb/symbols/zok` to `/etc/xkb/symbols/zok`. Espanso needs this copy. Run the script again after you change the layout.
8. `80-dns-quad9.sh` sets up [systemd-resolved](https://wiki.archlinux.org/title/Systemd-resolved) to send all DNS queries to Quad9 over TLS. It writes `/etc/systemd/resolved.conf.d/quad9.conf`, links `/etc/resolv.conf` to the resolved stub file, and restarts `systemd-resolved.service`. Then it shows the DNS servers and resolves `archlinux.org` as a test.

## Keyboard layout for espanso

Espanso has the `cap_dac_override` capability, so that it can read `/dev/input` and write `/dev/uinput`. Because of this capability, libxkbcommon ignores `$HOME` and `$XDG_CONFIG_HOME` in the espanso process. Espanso cannot read `~/.config/xkb`, so it reads the layout from `/etc/xkb`. Niri continues to use the copy in `~/.config/xkb`.

## DNS over TLS

The `DNSOverTLS=yes` line is strict mode. In strict mode, resolved does not send a DNS query as plain text. If resolved cannot open a TLS connection to a server, the lookup fails. This also applies to the DNS server that DHCP gives to the network link, for example a home router. Most routers do not support TLS, so resolved cannot use them. The `Domains=~.` line tells resolved to send all queries to the Quad9 servers first. Because of this, names on the local network that only the router knows do not resolve.

## Mirror ranking

The `cachyos-rate-mirrors` tool ranks the Arch mirrors in `/etc/pacman.d/mirrorlist` and the CachyOS mirrors in `/etc/pacman.d/cachyos-*mirrorlist`. Reflector also writes `/etc/pacman.d/mirrorlist`, so the two tools overwrite each other. For this reason, `30-mirrors.sh` turns off `reflector.timer`.
