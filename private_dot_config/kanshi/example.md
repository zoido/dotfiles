# Kanshi laptop example

Chezmoi creates an empty `~/.config/kanshi/config` if it does not exist. Kanshi leaves displays unchanged until you add a matching profile.

For a laptop with an external display, copy this example into `~/.config/kanshi/config`. Replace the output names with those from `niri msg outputs` and adjust the modes and scales for your displays.

```text
output "Laptop Manufacturer Laptop Display Unknown" {
    mode 1920x1200@60.001Hz
    scale 1
    alias $internal
}

output "Monitor Manufacturer Monitor Model Serial" {
    mode 3840x2160@59.996Hz
    position 0,0
    scale 1.25
    alias $external
}

profile docked {
    output $internal disable
    output $external enable
}

profile undocked {
    output $internal enable
}
```

After editing the configuration, restart kanshi with `systemctl --user restart kanshi.service`.
