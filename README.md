# Ultima [ˈultima] — Minimalist Theme for Z Shell

### Delivers comfortable terminal experience with essential settings

![GitHub Release](https://img.shields.io/github/v/release/egorlem/ultima.zsh-theme?style=for-the-badge&color=7CD996&labelColor=212121)
![Static Badge](https://img.shields.io/badge/License-WTFPL-blue?style=for-the-badge&labelColor=212121&color=59D9D0&link=https%3A%2F%2Fgithub.com%2Fegorlem%2Fultima.zsh-theme%2Fblob%2Ff8a01d549ee38e720a597f9632ccf7960c7b9c8e%2FLICENSE)

---

![item zsh prompt](https://github.com/egorlem/021011/blob/main/demos/zsh-theme-demo-min.png?raw=true) 

---

## Features

- **Multi-Line Prompt:** The prompt is divided into three lines for better readability. The first line separates the previous command's output from the prompt, the second line provides detailed path information, and the third line is for input.
- **Multiple Prompt Levels:** Configurations for secondary and tertiary prompt levels (`PS2` and `PS3`) are included.
- **SSH Status Indicator:** Displays an indicator when an SSH connection is established.
- **VCS (Version Control System) Integration:** Supports **Git**, **SVN**, and **Mercurial** for showing branch and repository status directly in the prompt.
    - **Git Integration:** Shows branch name, staged and unstaged changes, and untracked files.
    - **SVN and Mercurial Integration:** Shows branch name and repository status.
- **Completion Enhancements:** Advanced completion settings, including menu completion, caching, and various completion styles and formats.
- **LS_COLORS Configuration:** Configures `LS_COLORS` for both **BSD** and **GNU** systems to enhance directory listings.
- **LESS and MAN Configuration:** Customizes the behavior and appearance of `less` and `man` pages.

These features make `ultima.zsh-theme` a powerful and versatile theme for Z shell users, enhancing both functionality and aesthetics.

---

## Installation

_Requires [git](https://git-scm.com/)_

### Manual

1. Clone the repository:

    ```shell
    git clone https://github.com/egorlem/ultima.zsh-theme ~/ultima-shell
    ```
2. Update your `.zshrc` file:

    ```shell
    echo 'source ~/ultima-shell/ultima.zsh-theme' >> ~/.zshrc
    ```

### [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)

1. Clone the repository:

    ```shell
    git clone https://github.com/egorlem/ultima.zsh-theme ~/ultima-shell
    ```

2. Move the file to the Oh My Zsh theme folder:

    ```shell
    mv ~/ultima-shell/ultima.zsh-theme $ZSH/themes/ultima.zsh-theme
    ```

3. Edit your `~/.zshrc` file and set `ZSH_THEME="ultima"`

### [Zim](https://github.com/zimfw/zimfw)

1. Update your `.zimrc` file:

    ```shell
    echo 'zmodule egorlem/ultima.zsh-theme -n ultima' >> ~/.zimrc
    ```

### [zcomet](https://github.com/agkozak/zcomet)

1. Add the following to your `~/.zshrc` file:

    ```shell
    zcomet load egorlem/ultima.zsh-theme
    ```

    _Make sure you have `zcomet compinit` somewhere after it._

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

---

## Contribution Guide

We welcome contributions to improve `ultima.zsh-theme`! Here’s how you can help:

### How to Contribute

1. **Fork the Repository:** Click the "Fork" button at the top right of this repository to create a copy under your GitHub account.
2. **Clone Your Fork:** Clone your forked repository to your local machine:

    ```bash
    git clone https://github.com/<your-username>/ultima.zsh-theme.git
    ```
    Replace `<your-username>` with your GitHub username.

3. **Create a Branch:** Create a new branch for your changes:

    ```bash
    git checkout -b feature/your-feature-name
    ```
    Replace `your-feature-name` with a descriptive name for your feature or fix.

4. **Make Changes:** Make your changes to the codebase. Ensure your code follows the project's coding standards and conventions.
5. **Commit Changes:** Commit your changes with a descriptive commit message:

    ```bash
    git add .
    git commit -m "Add feature: your feature description"
    ```

6. **Push Changes:** Push your changes to your forked repository:

    ```bash
    git push origin feature/your-feature-name
    ```

7. **Open a Pull Request:** Go to the original repository and click the "New Pull Request" button. Select your branch from the dropdown and create the pull request. Provide a clear and detailed description of your changes.

### Reporting Issues

If you find any bugs or have feature requests, please open an issue on the GitHub repository. Provide as much detail as possible to help us understand and resolve the issue.

### Getting Help

If you need any help, feel free to reach out by opening an issue or starting a discussion in the repository.

---

## Acknowledgments

Special thanks to the ZSH community for their support and contributions. Ultima's minimalistic approach has inspired derivative works, including:

- **[Suprima ASRA](https://github.com/mohdismailmatasin/suprima-asra)** — expands on Ultima's minimalism with practical status indicators: battery level, active Python venv, Node.js version, Docker status, and more.

Contributions, ideas, and derivative works are welcome.

---

## License

This project is licensed under the __Do What The F*ck You Want To Public License__. See the [LICENSE](https://github.com/egorlem/ultima.zsh-theme/blob/f8a01d549ee38e720a597f9632ccf7960c7b9c8e/LICENSE) file for details.

---

Maintained by [Egor Lem](https://egorlem.com/)
