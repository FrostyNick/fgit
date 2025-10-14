
# fgit

Git cloning to the next level! A small tool aimed at saving time, being beginner friendly, minimal, and powerful with concise syntax.

This tool automatically clones repositories minimally with (optionally) sparse clone support, moves it to your projects folder, and navigates your current directory inside.

> [!WARNING]
> This always runs `git` with `--depth=1`, unless removed from the code at the moment.

# Installation

- Compatible with: Linux and Windows (Git Bash).
- MacOS compatability is unknown. Create an issue if you're willing to test this on your device.

## 1. Dependencies

> [!NOTE]
> You probably have these installed and can skip this section.

- `bash`
- `git` - for git cloning to work. If you use partial cloning, you'll need git >= 2.19.0.

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

## 2. Git

```sh
# Move below to a good location. you can put it in your projects folder too for easier management.
git clone https://github.com/frostynick/fgit
chmod +x fgit/fgit.sh
```

## 3. Path

Run it from everywhere.

One of the below:
```sh
sudo ln -s $(pwd)/fgit/fgit.sh /usr/bin/fgit # Linux / Git Bash
ln -s $(pwd)/fgit/fgit.sh $PATH/usr/bin/fgit # Usually works on Termux (will work if there's just one value in $PATH)
ln -s $(pwd)/fgit/fgit.sh /data/data/com.termux/files/usr/bin/fgit # For sure works on Termux but longer
sudo ln -s $(pwd)/fgit/fgit.sh /usr/local/bin/fgit # MacOS / BSD-based system (Experimental). If it works on MacOS / BSD-based system, this is probably where it goes. You're welcome to create an issue on how this went! (I cannot test on MacOS at the moment, and I haven't tried BSD-based systems yet.)
# above uses a soft link, which means IF you move the git cloned folder, you will need to `rm` the old link and link it again.
```

```sh
echo "alias fgit=\". fgit\"" >> ~/.bashrc
# ~/.bashrc can be ~/.bash_aliases if you have that setup
```

<!--
On MacOS (in theory) you'll need to change `/usr/bin` to `/usr/local/bin` as far as I know.
https://support.apple.com/en-us/102149
-->

# Getting Started

If the installation worked, you can run `fgit` for quick setup. After that, you can always run `fgit` for help, examples, and checking your config.

## Troubleshooting

- If you are in `/tmp/tmp.xxx/`, you can type `cd -` to go back. /tmp folder should delete everything after restart. And if nothing went wrong it's deleted after repo is pulled.

# Roadmap

- [x] Make typing `https://github.com/` optional while not breaking other websites that use git. It can be changed to other websites too.
- [ ] Option for regular git clone (the git clone in fgit doesn't use git history at the moment unless `--depth=1` is removed from the code.
- [ ] Add flags that make sense.
- [ ] Other things I forgot to write here. Open to suggestions.
<!--
- [ ] Add shorthand "h" (GitHub), "l" (GitLab), "b" (codeberg) and several other websites. Syntax not yet determined.
-->
