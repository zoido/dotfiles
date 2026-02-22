if status is-interactive
    # Commands to run in interactive sessions can go here
    if command -q starship
        starship init fish | source
    end

    if command -q atuin
        atuin init fish --disable-up-arrow | source
    end

    if command -q zoxide
        zoxide init fish | source
    end
    if command -q lf
        bind \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
    end

    bind ctrl-alt-left 'prevd' repaint
    bind ctrl-alt-right 'nextd' repaint


end
