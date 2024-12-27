# ultima.zsh-theme — Theme and Settings for Z Shell

`ultima.zsh-theme` is a Z shell (Zsh) theme designed to improve the terminal experience with a minimalist configuration and a structured three-line prompt. It enhances readability and functionality by displaying essential information such as the SSH connection status, current working directory, and version control system (VCS) status directly in the prompt. The theme also integrates with Git, SVN, and Mercurial, providing a clear and organized view of repository status, along with advanced completion settings and customized configurations for less and man.

![GitHub Release](https://img.shields.io/github/v/release/egorlem/ultima.zsh-theme?style=for-the-badge&color=7CD996&labelColor=212121)
![Static Badge](https://img.shields.io/badge/License-WTFPL-blue?style=for-the-badge&labelColor=212121&color=59D9D0&link=https%3A%2F%2Fgithub.com%2Fegorlem%2Fultima.zsh-theme%2Fblob%2Ff8a01d549ee38e720a597f9632ccf7960c7b9c8e%2FLICENSE)


<!-- ![GitHub Repo stars](https://img.shields.io/github/stars/egorlem/ultima.zsh-theme?style=for-the-badge&labelColor=212121&color=59D9D0) -->

---

![item zsh prompt](https://github.com/egorlem/021011/blob/main/demos/zsh-theme-demo-min.png?raw=true) 

---

## Features

- **Minimalistic Configuration**: The theme provides a minimalistic `.zshrc` configuration that includes all necessary settings for a comfortable terminal experience.
- **Multi-Line Prompt**: The prompt is divided into three lines for better readability. The first line separates the previous command's output from the prompt, the second line provides detailed path information, and the third line is for input.
- **Multiple Prompt Levels**: Provides configurations for secondary and tertiary prompt levels (`PS2` and `PS3`).
- **SSH Status Indicator**: Displays an indicator when an SSH connection is established.
- **VCS (Version Control System) Integration**: Supports Git, SVN, and Mercurial for showing branch and repository status directly in the prompt.
    - **Git Integration**: Shows branch name, staged and unstaged changes, and untracked files.
    - **SVN and Mercurial Integration**: Shows branch name and repository status.
- **Completion Enhancements**: Provides advanced completion settings, including menu completion, caching, and various completion styles and formats.
- **LS_COLORS Configuration**: Configures `LS_COLORS` for both BSD and GNU systems to enhance the display of directory listings.
- **LESS and MAN Configuration**: Customizes the behavior and appearance of `less` and `man` pages.

These features make the `ultima.zsh-theme` a powerful and versatile theme for Z shell users, enhancing both functionality and aesthetics.

---

## Multi-Line Prompt

The ulti-Line prompt is designed to enhance readability and provide useful information in a structured manner. It splits the shell prompt into three distinct lines, each serving a specific purpose. Let's break down each line:

### First Line: Separator

The first line acts as a visual separator. It helps to clearly distinguish the output of the previous command from the next prompt. This makes it easier to read the terminal output, especially when dealing with long or complex commands.


### Second Line: Information Line

The second line is divided into three segments and provides essential information about the current state of the terminal. This line typically includes details such as the SSH connection status, the current working directory, and the version control system (VCS) status.

### Third Line: Input Line

The third line is for command input, providing a clear space for entering new commands.


#### SSH Connection Segment

- **Purpose:** Indicates whether an SSH connection is currently established.
- **Display:** A badge or icon that changes based on the SSH connection status.

#### Directory Segment

- **Purpose:** Displays the current working directory.
- **Display:** The full path to the current directory, often abbreviated to show only the necessary parts.

#### VCS Status Segment

- **Purpose:** Shows the version control system status for the current directory, typically for Git repositories.
- **Display:** Information about the current branch, staged changes, and uncommitted changes.

---

## VCS Integration

The three-line prompt also includes a segment dedicated to displaying the status of the version control system (VCS). This allows users to quickly see the current state of the repository directly in the terminal. Here's a breakdown of this segment:

#### VCS Status Segment

- **Purpose**: Displays the status of the version control system for the current directory, supporting Git, SVN, and Mercurial.
- **Display**: Includes information about the current branch, staged changes, uncommitted changes, and untracked files.

- **Git Integration**:
  - **Branch Name**: Displays the current branch of the repository.
  - **Staged Changes**: Shows the count and type of changes that are staged.
  - **Uncommitted Changes**: Indicates the presence of uncommitted changes.
  - **Untracked Files**: Informs about the presence of untracked files in the current directory.

- **SVN and Mercurial Integration**:
  - **Branch Name**: Displays the current branch of the repository.
  - **Repository Status**: Shows the overall status of the repository.

---

## **Installation**

_For Installation you need git_

### **Manual**

1. Clone the repository:

```shell
git clone https://github.com/egorlem/ultima.zsh-theme ~/ultima-shell
```
2. Update your .zshrc file:

```shell
echo 'source ~/ultima-shell/ultima.zsh-theme' >> ~/.zshrc
```

### **Oh My Zsh**

1. Clone the repository:

```shell
git clone https://github.com/egorlem/ultima.zsh-theme ~/ultima-shell
```

2. Move file to oh-my-zsh's theme folder:

```shell
mv ~/ultima-shell/ultima.zsh-theme $ZSH/themes/ultima.zsh-theme
```

3. Go to your `~/.zshrc` file and set `ZSH_THEME=ultima`

---

## **Recommended settings and compatibility**


### Fonts

Not all fonts contain U+203a unicode unless your system supports **Single Right-Pointing Angle Quotation Mark** install one of the standard fonts on your system. For example **Arial**, **Consolas**, **Impact**. 

For comfortable work, I usually use [JetBrains Mono](https://www.jetbrains.com/lp/mono/). 
The font is already available characters that are used in the theme and are ideal for full compatibility.

---

## Contribution Guide

We welcome contributions to improve `ultima.zsh-theme`! Here’s how you can help:

### How to Contribute

1. **Fork the Repository**: Click the "Fork" button at the top right of this repository to create a copy of the repository on your GitHub account.

2. **Clone Your Fork**: Clone the forked repository to your local machine using the following command:
    ```bash
    git clone https://github.com/<your-username>/ultima.zsh-theme.git
    ```
    Replace `<your-username>` with your GitHub username.

3. **Create a Branch**: Create a new branch for your changes:
    ```bash
    git checkout -b feature/your-feature-name
    ```
    Replace `your-feature-name` with a descriptive name for your feature or fix.

4. **Make Changes**: Make your changes to the codebase. Ensure your code follows the project's coding standards and conventions.

5. **Commit Changes**: Commit your changes with a descriptive commit message:
    ```bash
    git add .
    git commit -m "Add feature: your feature description"
    ```

6. **Push Changes**: Push your changes to your forked repository:
    ```bash
    git push origin feature/your-feature-name
    ```

7. **Open a Pull Request**: Go to the original repository and click the "New Pull Request" button. Select your branch from the dropdown and create the pull request. Provide a clear and detailed description of your changes.

### Reporting Issues

If you find any bugs or have feature requests, please open an issue on the GitHub repository. Provide as much detail as possible to help us understand and resolve the issue.

### Code of Conduct

Please adhere to the [Code of Conduct](CODE_OF_CONDUCT.md) in all your interactions with the project.

### Getting Help

If you need any help, feel free to reach out by opening an issue or starting a discussion in the repository.

Thank you for contributing to `ultima.zsh-theme`!

---

## License

This project is licensed under the __Do What The F*ck You Want To Public License__. See the [LICENSE](https://github.com/egorlem/ultima.zsh-theme/blob/f8a01d549ee38e720a597f9632ccf7960c7b9c8e/LICENSE) file for details.

---

Maintained by [Egor Lem](https://egorlem.com/)

---