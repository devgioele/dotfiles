# My dotfiles

These are the dotfiles on my machines that I intend to reuse.
Bloated files generated by bloated software are not considered dotfiles just because they are stored inside `~/.config`.
Rather, files are added to git chirurgically, like `git add <path/to/dotfile>`.
To add any changes made to files that are already being tracked, use `git add -u .`.

## Git branches

There are multiple branches, because each machine I use may have a slightly different configuration.
The name of the branch is the hostname of that particular machine.

# Setup

What comes next is a list of the basic software found on my machines.

The selection criteria is inspired by [the suckless philosophy](https://suckless.org/philosophy/):
- FOSS (obviously)
- Simplicity
- Speed
- Ease of use

The list is subject to change. I am especially looking for better alternatives
to Sway and eww. Write me for suggestions.

## Software list

- OS: [Artix Linux](https://artixlinux.org/)
- Init system: [OpenRC](https://wiki.gentoo.org/wiki/OpenRC)
- Default shell: [Zsh](https://www.zsh.org/)
- Scripting shell (/bin/sh): [Dash](http://gondor.apana.org.au/~herbert/dash/)
- Editor: [Helix](https://helix-editor.com/)
- Wifi management: [wpa_supplicant](https://wiki.archlinux.org/title/Wpa_supplicant)
- Firewall: [nftables](https://www.nftables.org/)
- Display manager (if the disk is not encrypted): [emptty](https://github.com/tvrzna/emptty)
- Display server protocol: [Wayland](https://wayland.freedesktop.org/)
- Wayland compositor: [Sway](https://swaywm.org/)
- Terminal: [Alacritty](https://alacritty.org/)
- Clipboard tool: [wl-clipboard](https://github.com/bugaevc/wl-clipboard)
- Status bar: [eww](https://github.com/elkowar/eww)
- Screen locker: [swaylock](https://github.com/swaywm/swaylock)
- App launcher: [tofi](https://github.com/philj56/tofi)
- Notification server: [dunst](https://dunst-project.org/)
- File manager: [lf](https://github.com/gokcehan/lf)
- Default applications manager: [handlr](https://github.com/chmln/handlr)
- Calculator: [bc](https://www.gnu.org/software/bc/)
- Video and audio server: [PipeWire](https://pipewire.org/)
- Media player: [mpv](https://mpv.io/)
- PDF viewer: [zathura](https://pwmt.org/projects/zathura/)
- RSS/Atom feed reader: [newsboat](https://newsboat.org/)
- IRC client: [catgirl](https://git.causal.agency/catgirl/about/)
- Bittorrent client: [transmission-cli](https://transmissionbt.com/)

### Password manager

[pass - the standard unix password maanger](https://www.passwordstore.org/)

Recommended extensions:
- For OTP support: pass-otp
- To scan the QR code currently on the screen with `qr-from-screen | pass otp append <pass-name>`: grim + zbar
- To easily update existing passwords: pass-update
- To use pass as the credential backend for https-based git repos: pass-git-helper

### Fonts

The following fonts give a sufficiently high coverage for everyday needs:
- gnu-free-fonts
- ttf-hack-nerd

## A message from your future self

See [a message from your future self](https://github.com/devgioele/dotfiles/blob/zugmaschine/message-from-future-self.md)
on how to solve common configuration problems.
