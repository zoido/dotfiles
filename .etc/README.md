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
2. `30-mirrors.sh` installs [reflector](https://wiki.archlinux.org/title/Reflector) and writes `/etc/xdg/reflector/reflector.conf`. Reflector takes the 10 most recently synced HTTPS mirrors from Czechia, Germany and Poland. It measures the download speed of each one and writes them to `/etc/pacman.d/mirrorlist`, fastest first. The script turns on `reflector.timer`, which updates the list once a week. Then it runs reflector once and shows the top of the list.
3. `40-1password-browsers.sh` adds Waterfox to `/etc/1password/custom_allowed_browsers`. After this step, the 1Password browser extension can connect to the desktop app. Restart 1Password after you run it.
4. `50-swayosd.sh` installs `swayosd` and turns on `swayosd-libinput-backend.service`. This system service reads the keyboard input and tells the swayosd server when you press Caps Lock or Num Lock. The server then shows the lock key state on the screen.
5. `60-ly.sh` installs [Ly](https://wiki.archlinux.org/title/Ly), a display manager with a text interface. It turns off the login prompt (`getty@tty1.service`) on tty1 and turns on `ly@tty1.service` in its place. Ly starts on tty1 after the next reboot. The script does not start Ly at once, because that would stop a session that runs on tty1.
6. `70-xkb-zok.sh` copies the `zok` keyboard layout from `private_dot_config/xkb/symbols/zok` to `/etc/xkb/symbols/zok`. Espanso needs this copy. Run the script again after you change the layout.
7. `80-dns-quad9.sh` sets up [systemd-resolved](https://wiki.archlinux.org/title/Systemd-resolved) to send all DNS queries to Quad9 over TLS. It writes `/etc/systemd/resolved.conf.d/quad9.conf`, links `/etc/resolv.conf` to the resolved stub file, and restarts `systemd-resolved.service`. Then it shows the DNS servers and resolves `archlinux.org` as a test.
8. `90-ssh.sh` installs OpenSSH and writes `/etc/ssh/sshd_config.d/10-hardening.conf`. With this file, only the user `zoid` can log in, and only with a public key. Root cannot log in. The script tests the configuration with `sshd -t`, turns on `sshd.service`, and reloads it. If `~zoid/.ssh/authorized_keys` is missing or empty, the script shows a warning.

## Keyboard layout for espanso

Espanso has the `cap_dac_override` capability, so that it can read `/dev/input` and write `/dev/uinput`. Because of this capability, libxkbcommon ignores `$HOME` and `$XDG_CONFIG_HOME` in the espanso process. Espanso cannot read `~/.config/xkb`, so it reads the layout from `/etc/xkb`. Niri continues to use the copy in `~/.config/xkb`.

## DNS over TLS

The `DNSOverTLS=yes` line is strict mode. In strict mode, resolved does not send a DNS query as plain text. If resolved cannot open a TLS connection to a server, the lookup fails. This also applies to the DNS server that DHCP gives to the network link, for example a home router. Most routers do not support TLS, so resolved cannot use them. The `Domains=~.` line tells resolved to send all queries to the Quad9 servers first. Because of this, names on the local network that only the router knows do not resolve.

## SSH drop-in order

The main `/etc/ssh/sshd_config` file reads the files in `/etc/ssh/sshd_config.d/` in name order. For most settings, sshd uses the first value that it finds. The file name starts with `10-`, so its values come before the values in the Arch file `99-archlinux.conf`.

## Remove the CachyOS repositories

An earlier version of these scripts added the CachyOS package repositories and ranked the mirrors with `cachyos-rate-mirrors`. The `remove-cachyos.sh` script undoes this. The `setup.sh` script does not run it, because its name has no number. Run it once, then run `30-mirrors.sh`:

```sh
~/.local/share/chezmoi/.etc/remove-cachyos.sh
~/.local/share/chezmoi/.etc/30-mirrors.sh
```

The `remove-cachyos.sh` script does these steps:

1. It turns off `cachyos-rate-mirrors.timer`, removes the `cachyos-rate-mirrors` and `rate-mirrors` packages, and deletes `/etc/conf.d/cachyos-rate-mirrors.env`.
2. It runs `cachyos-repo.sh --remove` from the upstream [`cachyos-repo-add-script`](https://github.com/CachyOS/cachyos-repo-add-script). The upstream script removes the CachyOS sections from `/etc/pacman.conf` and keeps the old file as `/etc/pacman.conf.bak`. It installs the Arch `pacman` again and installs all packages again from the Arch repositories. Then it removes the CachyOS keyring and mirror list packages and deletes the CachyOS signing key. Pacman asks you to confirm these steps.
3. It deletes the files that are left in `/etc/pacman.d/cachyos-*`.

If the CachyOS repositories are not in `/etc/pacman.conf`, the script skips step 2.

Some packages, for example `waterfox-bin` and `yay`, come only from the CachyOS repositories. Pacman does not remove them, and `yay` updates them from the AUR (Arch User Repository) after this.
