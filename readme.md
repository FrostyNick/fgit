
# fgit

Git cloning to the next level! A small tool aimed at saving time, being beginner friendly, minimal, and powerful with concise syntax.

This tool automatically clones repositories minimally with (optionally) sparse clone support, moves it to your projects folder, and navigates your current directory inside.

> [!WARNING]  
> This project is in *very* early stages. If you encounter bugs from main (stable) branch, let me know in Issues tab or comment on similar issues. Thanks!

# Installation

- Should work on vast majority of Linux systems.
- Not on MacOS at the moment. Create an issue if you're up for the task!
- On Windows, it's not supported at the moment, but you might be able to run this program in Git Bash. Keep in mind the home directory might not be where you might expect it. WSL or Cygwin may also work.

## Dependencies

> [!NOTE]  
> You probably have these installed and can skip this section.

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
# ~/.bashrc can be ~/.bash_aliases if you have that setup
```

<!--
On MacOS (in theory) you'll need to change `/usr/bin` to `/usr/local/bin` as far as I know.
https://support.apple.com/en-us/102149
-->

# Getting Started

If the installation worked, you can run `fgit` for help and examples.

Consider leaving a star if you found this tool useful.

## Troubleshooting

- If you are in `/tmp/tmp.xxx/`, you can type `cd -` to go back. /tmp folder should delete everything after restart. And if nothing went wrong it's deleted after repo is pulled.

# Roadmap

- [ ] Make typing `https://github.com/` optional while not breaking other websites that use git.
- [ ] Option for regular git clone (the git clone in fgit doesn't use git history at the moment.)
- [ ] Other things I forgot to write here. Open to suggestions.

