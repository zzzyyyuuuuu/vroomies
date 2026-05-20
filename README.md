# vroomies 🚀

> *"See you space cowboy..."* — Cowboy Bebop

hyprland + quickshell. no waybar. no bloat.

🌐 **[vroomies.vercel.app](https://vroomies.vercel.app)**

A collection of power-user setup scripts for Arch, Fedora, and Void Linux — built around Hyprland, Quickshell, and a clean anime-coded terminal life.

---

## Scripts

| Script | Distro | Package Manager |
|--------|--------|-----------------|
| `AETHER.sh` | Arch Linux / Arch-based | `yay` / `paru` / `trizen` |
| `IGNITE.sh` | Fedora | `dnf` |
| `PHANTOM.sh` | Void Linux | `xbps` |

All three scripts install the same core stack and drop the same config — only the package manager changes.

---

## What Gets Installed

- **WM:** Hyprland
- **Shell:** Fish + Starship + Zoxide
- **Bar / UI:** Quickshell
- **Wallpaper:** swww
- **Terminal:** Kitty
- **Editor:** Neovim
- **Media:** VLC, Flatpak (Discord, LocalSend, OBS)
- **Icons:** Papirus-Dark
- **Fonts:** from `vroomies/fonts/`
- **GPU:** auto-detected (NVIDIA / AMD / Intel)

---

## Screenshots

![Hero](frames/Hero.png)
![Dashboard](frames/dashboard.png)
![Wifi & Media Player](frames/wifi_and_media-player.png)

---

## Usage

Clone the repo first:

```bash
git clone https://github.com/maxchennn/vroomies.git
cd vroomies
```

Then run the script for your distro:

```bash
# Arch / Arch-based
bash setup/AETHER.sh

# Fedora
bash setup/IGNITE.sh

# Void Linux
bash setup/PHANTOM.sh
```

> Scripts will ask for a reboot at the end. Recommended to accept.

---

## Structure

```
vroomies/
├── setup/
│   ├── AETHER.sh         # Arch setup
│   ├── IGNITE.sh         # Fedora setup
│   └── PHANTOM.sh        # Void Linux setup
├── fonts/                # Custom fonts
├── frames/               # Frames
├── settings/             # Extra config files
├── visions/              # Wallpapers
├── index.html
└── style.css
```

---

## Community

Found this through Reddit? Drop by:

- [r/hyprland](https://www.reddit.com/r/hyprland)
- [r/quickshell](https://www.reddit.com/r/quickshell)

---

## License

MIT — do whatever you want with it, just don't forget to vroom. 🏎️
