wsl --update
wsl --install archlinux --name Arch
wsl -d Arch --cd %USERPROFILE%/.wsl -- sh -c "tr -d '\r' < bootstrap_arch.sh | bash"
wsl --terminate Arch
wsl -d Arch -- sh -c "$(curl -fsLS https://raw.githubusercontent.com/zoido/dotfiles/main/bootstrap.sh)"
