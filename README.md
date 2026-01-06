# Ultima [ˈultima] — Minimalist Zsh theme

### Clean, clear, and visually structured.

![GitHub Release](https://img.shields.io/github/v/release/egorlem/ultima.zsh-theme?style=for-the-badge&color=7CD996&labelColor=212121)
![Static Badge](https://img.shields.io/badge/License-WTFPL-blue?style=for-the-badge&labelColor=212121&color=59D9D0&link=https%3A%2F%2Fgithub.com%2Fegorlem%2Fultima.zsh-theme%2Fblob%2Ff8a01d549ee38e720a597f9632ccf7960c7b9c8e%2FLICENSE)

---

![item zsh prompt](https://github.com/egorlem/021011/blob/main/demos/zsh-theme-demo-min.png?raw=true) 

---

## Features And Prompt

### Prompt Structure

* **Three-level prompt** — top line separates previous output, middle shows key information (working directory, SSH, VCS), bottom is for command input.
* **Unified sigil (`›`)** — used consistently across all input lines (`PS1`, `PS2`, `PS3`). The sigil marks the beginning of the input line and indicates the prompt is ready for a new command.

### Key Features

* **Working directory** — shows the current path.
* **VCS status** — displayed only inside a repository: current action (e.g., `rebase` or `merge`), short commit hash, file changes (`A` — added, `M` — modified, `U` — untracked), and branch.
* **SSH indicator** — shown only during remote sessions.
* **Exit status indicator (RPROMPT)** — displayed on the right side of the prompt:
  * green `•` — last command exited successfully (`0`)
  * red `• <code>` — last command failed, showing its exit status code

---

## Installation

Ultima Zsh theme can be installed in three ways: with **full module management via Veil**, manually for a **lightweight setup**, or through popular **Zsh frameworks and plugin managers**.

---

### Recommended: Veil

> Features like `less`, `ls`, completion, and other shell behavior are now part of **Veil**. Installing Veil automatically includes Ultima.

```shell
# Clone Veil repository
git clone https://github.com/egorlem/veil.zsh ~/.veil

# Source Veil in your .zshrc (includes Ultima theme)
echo 'source ~/.veil/veil.zsh' >> ~/.zshrc
```

> For advanced module configuration, see [Veil Documentation](https://github.com/egorlem/veil.zsh).

---

### Manual Installation

> Include Ultima without Veil if you prefer minimal changes.

```shell
# Clone Ultima repository
git clone https://github.com/egorlem/ultima.zsh-theme ~/.ultima

# Source Ultima in your .zshrc
echo 'source ~/.ultima/ultima.zsh-theme' >> ~/.zshrc
```

---

### Integration with Zsh Frameworks and Plugin Managers

#### Zim

```shell
# Add Ultima to your .zimrc
echo 'zmodule egorlem/ultima.zsh-theme -n ultima' >> ~/.zimrc
```

#### zcomet

```shell
# Load Ultima via zcomet
zcomet load egorlem/ultima.zsh-theme

# Ensure `zcomet compinit` is called after loading
```

#### Oh My Zsh

```shell
# Clone repository
git clone https://github.com/egorlem/ultima.zsh-theme ~/ultima-shell

# Move theme to Oh My Zsh theme folder
mv ~/ultima-shell/ultima.zsh-theme $ZSH/themes/ultima.zsh-theme

# Set theme in your .zshrc
ZSH_THEME="ultima"
```

---

## Recommended Settings and Compatibility

### Terminal and Color Scheme

For the best experience, use the **Ghostty** terminal together with the **Guezwhoz** color scheme.

**Guezwhoz** is a balanced dark color scheme designed with a focus on visual comfort and readability.  
The theme meets the WCAG 2.1 AA accessibility standard and is based on the principles of analogous color harmony, providing a pleasant, cohesive color experience during long terminal sessions.

**For [Ghostty](https://github.com/ghostty-org/ghostty) and [Wezterm](https://github.com/wezterm/wezterm) users:**  
Set the color scheme to `guezwhoz` in your terminal configuration. **Guezwhoz** is bundled by default with **Ghostty** and **Wezterm**—no additional installation required.

**For other terminals:**  
You can install the **Guezwhoz** theme from the [@mbadolato/iTerm2-Color-Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes) repository.

These recommendations ensure optimal appearance and compatibility for this project. Using other terminals or color schemes may result in a different visual experience.

### Fonts

Not all fonts include the U+203A Unicode character (Single Right-Pointing Angle Quotation Mark). Unless your system font supports this character, install one of the standard fonts, such as **Arial**, **Consolas**, or **Impact**.

For comfortable work, I recommend [JetBrains Mono](https://www.jetbrains.com/lp/mono/).  
This font already includes all the characters used in the theme and is ideal for full compatibility.

> This theme is developed and tested using Ghostty, JetBrains Mono, Veil, the Guezwhoz color scheme, and the standard zsh-users plugin set.

---

## License

**Do What The F*ck You Want To Public License, Version 2**
See [LICENSE](https://github.com/egorlem/ultima.zsh-theme/blob/f8a01d549ee38e720a597f9632ccf7960c7b9c8e/LICENSE) for details.

Maintained by [Egor Lem](https://egorlem.com/)
