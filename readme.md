
# fgit

Git cloning to the next level! A small tool aimed at being beginner friendly, minimal, and powerful with concise syntax.

This tool automatically clones repositories (optionally partial clones), moves them to your `$HOME/p` projects folder, and navigates you inside. Save time on routine tasks and focus on coding.

> [!WARNING]  
> This project is in *very* early stages. If you encounter bugs from main (stable) branch, let me know in Issues tab or comment on similar issues. Thanks!

# Installation

- Should work on vast majority of Linux systems.
- Not on MacOS at the moment. Create an issue if you're up for the task!
- On Windows, it's not supported at the moment, but you might be able to run this program in Git Bash. Keep in mind the home directory might not be where you might expect it. WSL or Cygwin may also work.

## Dependencies

> [!NOTE]  
> You probably have these installed.

- `bash`
- `git` - for git cloning to work, you'll need git >= 2.19.0 for the partial cloning part of this program to work.

**Debian-based (Ubuntu, Linux Mint, Pop OS):**

```sh
sudo apt install git
```

**Fedora, CentOS:**

```sh
sudo dnf install git
```

**Arch-based:**

```sh
sudo pacman -S git
```

## Git Clone

```sh
# Move below to a good location. you can put it in your projects folder too for easier management.
git clone https://github.com/frostynick/fgit
chmod +x fgit/fgit.sh
sudo ln -s $(pwd)/fgit/fgit.sh /usr/bin/fgit
# above uses a soft link, which means IF you move the git cloned folder, you will need to `rm` the old link and link it again.
echo "alias fgit=\". fgit\"" >> ~/.bashrc
# above recommended but optional; ~/.bashrc can be ~/.bash_aliases if you have that setup
```

<!--
On MacOS (in theory) you'll need to change `/usr/bin` to `/usr/local/bin` as far as I know.
https://support.apple.com/en-us/102149
-->

# Getting Started

> [!IMPORTANT]
> This is a *very* early project. As a result, I haven't added a prompt for where your project folder should be. You should change the `projects_path` value in [fgit.sh](fgit.sh) to be where you place your projects. Create the folder of your choice if it doesn't exist. By default `~/p` is used.

If it worked, you can run `fgit` for help and examples.

`git pull` to update. There might be a merge conflict if you changed the projects_path. That's on the roadmap to fix.

## Troubleshooting

- If you are in `/tmp/tmp.xxx/`, you can do `cd -` to go back. /tmp folder should delete everything after restart. And if nothing went wrong it's deleted after repo is pulled.

# Roadmap

- [ ] Projects path prompt and config file, so updating doesn't create a git conflict.
- [ ] Make typing "https://github.com/" optional while not breaking other websites that use git.
- [ ] Other things I forgot to write here. Open to suggestions.

