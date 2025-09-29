# Ultima LESS Module

Professional LESS pager configuration with terminal-aware color support.

## Features

- **Smart Terminal Detection** - Automatically adapts to terminal capabilities
- **Color Support** - Full ANSI color support for syntax highlighting
- **Man Page Integration** - Optimized `man` page viewing
- **Performance Optimized** - Efficient scrolling and rendering

## Configuration

Uses shared `LS_COLORS` from Ultima core for consistent color scheme.

## Usage

```bash
# Basic usage
less filename.txt

# Search within file (via helper)
lessSearch "pattern" filename.txt

# Follow logs in real-time
lessTail application.log 
```

# Ultima LS Module

Cross-platform LS command with intelligent color support and aliases.

## Features

- **Auto-Detection** - Automatically detects BSD (macOS) or GNU (Linux) systems
- **Color Integration** - Uses shared Ultima color scheme via `LS_COLORS`
- **Smart Aliases** - Useful shortcuts for common operations
- **Graceful Fallback** - Works even without color support

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `l`   | `ls -CF` | Compact listing |
| `ll`  | `ls -la` | Long listing all files |
| `la`  | `ls -la` | Long listing all files |

## System Support

- ✅ macOS (BSD `ls -G`)
- ✅ Linux (GNU `ls --color=auto`)
- ✅ BSD Systems
- ✅ WSL


# Ultima Completion Module

Advanced ZSH completion system with Ultima visual styling.

## Features

- **Visual Consistency** - Uses Ultima symbols and colors
- **Performance Optimized** - Smart caching and lazy loading
- **Comprehensive** - File, command, and host completion
- **Error Handling** - Graceful degradation on failures

## Completion Types

- **Command Completion** - Smart command matching
- **File Completion** - Color-coded file types
- **Host Completion** - Auto-complete from SSH known_hosts
- **Parameter Completion** - Command option suggestions

## Configuration

Automatically uses shared `LS_COLORS` for file type colors.

## Cache

Completion results are cached in `~/.cache/zsh/.zcompcache` for performance. 



# Ultima Navigation Module

Enhanced directory navigation and directory stack management.

## Features

- **Auto CD** - Change directories without typing `cd`
- **Directory Stack** - Navigate back through directory history
- **Smart Aliases** - Quick navigation shortcuts
- **Path Shortcuts** - Fast access to common directories

## ZSH Options

- `AUTO_CD` - Directly change to directories
- `AUTO_PUSHD` - Automatic directory stacking
- `PUSHD_IGNORE_DUPS` - Clean stack management
- `PUSHD_SILENT` - Quiet operation

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `..`  | `cd ..` | Up one level |
| `...` | `cd ../..` | Up two levels |
| `d`   | `dirs -v` | Show directory stack |
| `1`   | `cd -` | Go to previous directory |

## Personalization

Edit the module to add your frequently accessed directories. 


# Ultima History Module

Intelligent command history management with deduplication and sharing.

## Features

- **Extended History** - Timestamps and metadata
- **Smart Deduplication** - Automatic duplicate removal
- **Cross-Session Sharing** - History shared between terminal sessions
- **Space-Aware** - Ignore commands starting with space

## History Settings

- **Size**: 100,000 commands in memory
- **Storage**: 100,000 commands on disk
- **File**: `~/.zsh_history`

## ZSH Options

- `EXTENDED_HISTORY` - Save timestamps and duration
- `SHARE_HISTORY` - Share history between sessions
- `HIST_IGNORE_SPACE` - Privacy for sensitive commands
- `HIST_EXPIRE_DUPS_FIRST` - Smart cleanup

## Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `h`   | `history` | Show history |
| `hg`  | `history \| grep` | Search history | 


<!-- # Personal Configuration Templates

Starter templates for personal customization.

## Available Templates

### `aliases.zsh`
Personal command aliases and shortcuts.

### `keybindings.zsh`  
Custom keyboard bindings and shortcuts.

### `env.zsh`
Environment variables and personal settings.

## Usage

1. Copy template to your config directory:
```bash
cp modules/templates/aliases.zsh ~/.config/ultima/my-aliases.zsh -->