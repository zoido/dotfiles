IF NOT DEFINED ARCH_NAME SET "ARCH_NAME=Arch"
wsl --update
wsl --install archlinux --name %ARCH_NAME%
wsl -d Arch --cd %USERPROFILE%\.wsl -- sh -c "tr -d '\r' < bootstrap_arch.sh | bash"
wsl --terminate %ARCH_NAME%
wsl -d Arch -- sh -c "$(curl -fsLS https://raw.githubusercontent.com/zoido/dotfiles/main/bootstrap.sh)"
