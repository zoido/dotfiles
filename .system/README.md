# System setup

The scripts in this folder set up system files outside the home directory, for example in `/etc`. Chezmoi does not run them, because chezmoi ignores source paths that start with `.`. You run them yourself.

To run all scripts in order, run `setup.sh`:

```sh
~/.local/share/chezmoi/.system/setup.sh
```

You can also run one script alone. Each script describes what it does in the comment at its top.

The scripts in `backup/` set up backups. Only some machines need them, so `setup.sh` does not run them. Run each one yourself on the machines that need it.
