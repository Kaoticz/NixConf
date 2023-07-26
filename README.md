# NixConf

My personal Nix configuration files.

Currently being built in a VM running the Pantheon desktop environment.

I strongly encourage you to fork this repository and change the configuration files to your tastes and needs. The bash scripts shouldn't need any modification unless you have a system with custom directories for Nix and/or Home Manager. The scripts are compatible with **Linux** and **MacOS**, although the latter was not tested. May you find any issues with them, you're more than welcome to [file a bug report][BugReport] or even better, [create a pull request][PullRequest].

## Instructions

Execute the `first_setup.sh` script in the terminal to install [Nix] and [Home Manager][HomeManager]. You only need to do this once.

```bash
./first_setup.sh
```

Now explore the configuration files and change whatever you like. Once you're ready, execute the `update.sh` script to apply the configuration files.

```bash
./update.sh
```

That's it. Change or create configuration files, update, rinse and repeat.

[BugReport]: ../../issues/new
[PullRequest]: ../../compare
[Nix]: https://nixos.org/download.html
[HomeManager]: https://nix-community.github.io/home-manager/index.html