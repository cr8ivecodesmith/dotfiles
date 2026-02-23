# Advanced Features

<cite>
**Referenced Files in This Document**
- [init-symlinks.sh](file://init-symlinks.sh)
- [.bashrc](file://.bashrc)
- [.config/fish/config.fish](file://.config/fish/config.fish)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish)
- [.bash_aliases](file://.bash_aliases)
- [.tmux.conf](file://.tmux.conf)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh)
- [termux .aliases](file://termux-config/.aliases)
- [termux aliases.fish](file://termux-config/.config/fish/conf.d/aliases.fish)
</cite>

## Table of Contents
1. [Introduction](#introduction)
2. [Project Structure](#project-structure)
3. [Core Components](#core-components)
4. [Architecture Overview](#architecture-overview)
5. [Detailed Component Analysis](#detailed-component-analysis)
6. [Dependency Analysis](#dependency-analysis)
7. [Performance Considerations](#performance-considerations)
8. [Troubleshooting Guide](#troubleshooting-guide)
9. [Conclusion](#conclusion)
10. [Appendices](#appendices)

## Introduction
This document focuses on advanced features centered around:
- Custom prompt system implementation across Bash and Fish shells
- Interactive process management utilities for quick process selection and termination
- Specialized workflow automation using tmux-resurrect for environment persistence and restoration
- Advanced shell scripting techniques for robust symlink management and archive extraction with progress feedback

The goal is to explain how these systems are implemented, how they integrate, and how to extend them for power-user productivity.

## Project Structure
The advanced features span shell configuration, interactive utilities, and tmux automation:
- Shell prompt customization and environment integration
- Cross-shell archive extraction with progress indicators
- Interactive process killer leveraging fzf
- tmux environment saving/restoration with pane content capture
- Robust symlink initialization and maintenance

```mermaid
graph TB
subgraph "Shell Config"
A[".bashrc"]
B[".config/fish/config.fish"]
C[".config/fish/conf.d/aliases.fish"]
D[".bash_aliases"]
end
subgraph "Interactive Utilities"
E["Archive Extraction<br/>Progress Tracking"]
F["Interactive Process Killer<br/>(fzf + kill)"]
end
subgraph "tmux Automation"
G[".tmux.conf"]
H["tmux-resurrect save.sh"]
I["tmux-resurrect restore.sh"]
end
subgraph "System Scripts"
J["init-symlinks.sh"]
end
A --> E
B --> E
C --> E
D --> F
G --> H
G --> I
J --> A
J --> B
```

**Diagram sources**
- [.bashrc](file://.bashrc#L1-L343)
- [.config/fish/config.fish](file://.config/fish/config.fish#L1-L168)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L1-L148)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [.tmux.conf](file://.tmux.conf#L1-L69)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L1-L279)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L1-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)

**Section sources**
- [.bashrc](file://.bashrc#L1-L343)
- [.config/fish/config.fish](file://.config/fish/config.fish#L1-L168)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L1-L148)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [.tmux.conf](file://.tmux.conf#L1-L69)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L1-L279)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L1-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)

## Core Components
- Custom prompt system:
  - Bash two-line prompt with distro icon, working directory, virtual environment, and Git branch
  - Fish prompt with similar metadata and color theming
- Interactive archive extraction:
  - Cross-shell functions to extract archives with progress using pv and format-specific handlers
- Interactive process management:
  - fzf-powered process picker with preview and multi-select, followed by graceful termination
- tmux environment automation:
  - Save and restore sessions, windows, panes, pane contents, zoom state, and grouped sessions
- Advanced symlink management:
  - Safe symlink creation with conflict resolution, backup generation, and batch mode

**Section sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L109)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L101)
- [.bash_aliases](file://.bash_aliases#L108-L154)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L180-L260)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L264-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L116-L244)

## Architecture Overview
The advanced features form a cohesive ecosystem:
- Shell prompts depend on environment variables and optional tools (e.g., Git, virtual environments)
- Archive extraction utilities rely on external tools (pv, tar, bunzip2, gunzip, 7z, unrar, unzip)
- Process killer integrates with fzf for selection and uses signal-based termination
- tmux-resurrect orchestrates saving and restoring pane layouts, commands, and content
- init-symlinks manages dotfiles deployment with safety checks and backups

```mermaid
graph TB
subgraph "Prompt Layer"
P1[".bashrc PS1"]
P2[".config/fish/config.fish fish_prompt"]
end
subgraph "Extraction Layer"
X1[".config/fish/conf.d/aliases.fish extract"]
X2[".bash_aliases extract"]
X3["termux-config .aliases extract"]
end
subgraph "Process Layer"
K1[".bash_aliases fkill"]
K2[".config/fish/conf.d/aliases.fish fkill"]
K3["termux-config aliases.fish fkill"]
end
subgraph "tmux Automation"
T1[".tmux.conf"]
T2["save.sh"]
T3["restore.sh"]
end
subgraph "Symlink Management"
S1["init-symlinks.sh"]
end
P1 --> X1
P2 --> X1
X1 --> X2
X1 --> X3
K1 --> K2
K1 --> K3
T1 --> T2
T1 --> T3
S1 --> P1
S1 --> P2
```

**Diagram sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L109)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L141)
- [.bash_aliases](file://.bash_aliases#L108-L195)
- [termux-config .aliases](file://termux-config/.aliases#L119-L434)
- [termux-config aliases.fish](file://termux-config/.config/fish/conf.d/aliases.fish#L1-L106)
- [.tmux.conf](file://.tmux.conf#L1-L69)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L238-L279)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L366-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L250-L294)

## Detailed Component Analysis

### Custom Prompt System
- Bash prompt:
  - Two-line prompt with distro icon, shortened working directory, virtual environment indicator, and Git branch
  - Uses color sequences and conditional rendering based on terminal capabilities
- Fish prompt:
  - Similar metadata with color theming and emoji icons
  - Integrates virtual environment detection and Git status via Fish functions
- Environment integration:
  - Disables external virtual environment prompt overrides
  - Prepends and appends key directories to PATH
  - Loads optional tools like direnv and NVM/NPM configurations

```mermaid
flowchart TD
Start(["Shell startup"]) --> CheckEnv["Load environment variables<br/>and PATH adjustments"]
CheckEnv --> DetectTools["Detect tools: Git, virtualenv, direnv"]
DetectTools --> BuildPS1["Build Bash PS1 with distro icon,<br/>cwd, venv, git branch"]
DetectTools --> BuildFish["Build Fish prompt with colors,<br/>venv, git status"]
BuildPS1 --> Render["Render prompt"]
BuildFish --> Render
Render --> End(["Ready"])
```

**Diagram sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L134)

**Section sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L134)

### Interactive Archive Extraction with Progress Tracking
- Cross-shell functions provide unified extraction with progress:
  - Detects archive type and pipes through pv with total size for progress
  - Supports tar.gz, tar.xz, tar.bz2, tar, bz2, gz, 7z, rar, zip, Z
  - Provides user feedback and handles unsupported formats
- Termux-specific extraction:
  - Comprehensive switch statement covering additional formats and post-extraction listing of newly added files
  - Uses temporary files to compare pre/post extraction file lists and prints discovered items

```mermaid
sequenceDiagram
participant U as "User"
participant SH as "Shell Function"
participant PV as "pv"
participant TAR as "tar/unzip/7z/rar"
participant FS as "Filesystem"
U->>SH : "extract <archive>"
SH->>SH : "Resolve archive type and size"
SH->>PV : "Pipe archive to pv with -s <size>"
PV-->>TAR : "Stream compressed data"
TAR-->>FS : "Write extracted files"
SH-->>U : "Report success and optionally list new files"
```

**Diagram sources**
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L101)
- [.bash_aliases](file://.bash_aliases#L108-L154)
- [termux-config .aliases](file://termux-config/.aliases#L119-L325)

**Section sources**
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L101)
- [.bash_aliases](file://.bash_aliases#L108-L154)
- [termux-config .aliases](file://termux-config/.aliases#L119-L325)

### Interactive Process Management
- fzf-based process selection:
  - Lists processes sorted by memory usage with user, pid, and command
  - Multi-select with preview of process details and sorting toggle
- Termination strategy:
  - Sends SIGTERM first; falls back to SIGKILL if needed
  - Cleans up temporary selections and reports outcomes

```mermaid
flowchart TD
A["Invoke fkill"] --> B["List processes with ps"]
B --> C["Filter header and pipe to fzf"]
C --> D{"Selection made?"}
D -- "No" --> E["Exit with message"]
D -- "Yes" --> F["Iterate selected PIDs"]
F --> G["Send SIGTERM"]
G --> H{"Success?"}
H -- "Yes" --> I["Report SIGTERM sent"]
H -- "No" --> J["Send SIGKILL"]
J --> K{"Success?"}
K -- "Yes" --> L["Report SIGKILL sent"]
K -- "No" --> M["Report failure"]
I --> N["Cleanup temp file"]
L --> N
M --> N
E --> O["End"]
N --> O
```

**Diagram sources**
- [.bash_aliases](file://.bash_aliases#L161-L195)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L110-L141)
- [termux-config aliases.fish](file://termux-config/.config/fish/conf.d/aliases.fish#L66-L80)

**Section sources**
- [.bash_aliases](file://.bash_aliases#L161-L195)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L110-L141)
- [termux-config aliases.fish](file://termux-config/.config/fish/conf.d/aliases.fish#L66-L80)

### tmux Workflow Automation
- Save environment:
  - Captures grouped sessions, panes, windows, and client state
  - Optionally captures pane contents and creates an archive
  - Removes old backups based on retention policy
- Restore environment:
  - Detects whether restoring from scratch and whether pane contents are captured
  - Recreates sessions, windows, and panes; sets titles, layouts, and zoom state
  - Restores active windows, grouped session relationships, and client sessions
  - Cleans up temporary pane content files after restoration

```mermaid
sequenceDiagram
participant U as "User"
participant TM as "tmux"
participant S as "save.sh"
participant R as "restore.sh"
participant FS as "Resurrect Files"
U->>TM : "Save environment"
TM->>S : "Trigger save"
S->>TM : "Dump sessions, panes, windows, state"
S->>FS : "Write snapshot"
S->>S : "Capture pane contents (optional)"
S-->>U : "Saved"
U->>TM : "Restore environment"
TM->>R : "Trigger restore"
R->>FS : "Read snapshot"
R->>TM : "Recreate sessions, windows, panes"
R->>TM : "Set titles, layouts, zoom"
R-->>U : "Restored"
```

**Diagram sources**
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L238-L279)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L366-L388)

**Section sources**
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L180-L260)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L264-L388)

### Advanced Shell Scripting: Symlink Management
- Safety-first symlink creation:
  - Resolves absolute source paths and normalizes targets
  - Handles existing symlinks (correct link, broken link, wrong target)
  - Handles existing directories and files with user prompts or batch mode
  - Generates timestamped backups and merges directory contents when appropriate
- Robust path handling:
  - Supports special handling for termux-config paths
  - Creates parent directories as needed
  - Reports success or failure for each operation

```mermaid
flowchart TD
A["Start init-symlinks.sh"] --> B["Parse args and validate file"]
B --> C["Read path entries"]
C --> D["Resolve source and target paths"]
D --> E{"Source exists?"}
E -- "No" --> F["Skip with warning"]
E -- "Yes" --> G["Check target state"]
G --> H{"Symlink?"}
H -- "Yes" --> I["Handle correct/broken/wrong target"]
H -- "No" --> J{"Directory or file?"}
J -- "Directory" --> K["Merge contents if requested"]
K --> L["Replace with symlink"]
J -- "File" --> M["Replace with symlink"]
I --> N["Create symlink"]
L --> N
M --> N
N --> O["Next entry"]
F --> O
O --> P{"More entries?"}
P -- "Yes" --> C
P -- "No" --> Q["Complete"]
```

**Diagram sources**
- [init-symlinks.sh](file://init-symlinks.sh#L250-L294)

**Section sources**
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)

## Dependency Analysis
- Shell prompt dependencies:
  - Bash depends on Git and virtual environment detection; Fish relies on Fish functions and optional tools
- Extraction utilities depend on external tools (pv, tar, bunzip2, gunzip, 7z, unrar, unzip)
- Process killer depends on fzf and ps; output is piped to less for viewing
- tmux-resurrect depends on tmux and optional pane content capture; integrates with tmux plugins
- init-symlinks depends on standard POSIX tools and user input in interactive mode

```mermaid
graph LR
Bash[".bashrc"] --> Git["Git"]
Bash --> Venv["Virtual Env"]
Fish[".config/fish/config.fish"] --> FishFuncs["Fish functions"]
Fish --> Venv
Extract[".config/fish/conf.d/aliases.fish extract"] --> Tools["pv, tar, bunzip2, gunzip, 7z, unrar, unzip"]
Kill[".bash_aliases fkill"] --> FZF["fzf"]
Kill --> PS["ps"]
TmuxConf[".tmux.conf"] --> ResSave["save.sh"]
TmuxConf --> ResRestore["restore.sh"]
Init["init-symlinks.sh"] --> POSIX["POSIX tools"]
```

**Diagram sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L134)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L101)
- [.bash_aliases](file://.bash_aliases#L161-L195)
- [.tmux.conf](file://.tmux.conf#L56-L68)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L1-L279)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L1-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)

**Section sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L134)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L101)
- [.bash_aliases](file://.bash_aliases#L161-L195)
- [.tmux.conf](file://.tmux.conf#L56-L68)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L1-L279)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L1-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)

## Performance Considerations
- Prompt rendering:
  - Minimize external calls; cache Git branch and virtual environment detection results when possible
  - Use efficient string operations and avoid heavy subprocesses in Fish prompt
- Archive extraction:
  - Prefer streaming extraction with pv to provide accurate progress; avoid decompressing to temporary files unnecessarily
  - Limit post-extraction file listing to newly added files to reduce overhead
- Process killer:
  - Use fzf’s preview efficiently; avoid excessive system calls in preview command
  - Terminate with SIGTERM first to allow graceful shutdown; limit retries for SIGKILL
- tmux automation:
  - Capture pane contents only when needed; disable content capture for faster saves/restores
  - Remove old backups periodically to prevent filesystem bloat
- Symlink management:
  - Batch mode reduces I/O from interactive prompts; ensure backups are timestamped to avoid collisions

[No sources needed since this section provides general guidance]

## Troubleshooting Guide
- Prompt not displaying correctly:
  - Verify terminal color support and ensure PS1/terminal overrides are set appropriately
  - Confirm Git and virtual environment detection scripts are executable and return expected output
- Archive extraction fails:
  - Ensure pv and format-specific tools are installed; check permissions on archive and destination
  - For termux extraction, confirm temporary file handling and pre/post comparison logic
- Process killer does nothing:
  - Verify fzf is installed and accessible; check that ps output is readable
  - Confirm signal availability and permissions for terminating selected processes
- tmux restore issues:
  - Ensure tmux version compatibility and that required hooks are configured
  - Check pane contents capture settings and that archive extraction/cleanup completes
- Symlink creation errors:
  - Review backup generation and replacement logic; ensure sufficient permissions for target directories
  - Use batch mode to bypass interactive prompts when automating deployments

**Section sources**
- [.bashrc](file://.bashrc#L55-L196)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L134)
- [.config/fish/conf.d/aliases.fish](file://.config/fish/conf.d/aliases.fish#L68-L101)
- [.bash_aliases](file://.bash_aliases#L161-L195)
- [termux-config .aliases](file://termux-config/.aliases#L119-L325)
- [tmux-resurrect save.sh](file://.tmux/plugins/tmux-resurrect/scripts/save.sh#L229-L260)
- [tmux-resurrect restore.sh](file://.tmux/plugins/tmux-resurrect/scripts/restore.sh#L358-L388)
- [init-symlinks.sh](file://init-symlinks.sh#L116-L244)

## Conclusion
The advanced features demonstrate a cohesive approach to shell customization, interactive productivity, and environment automation. By combining cross-shell prompts, robust extraction utilities, fzf-driven process management, tmux-resurrect workflows, and safe symlink management, users can achieve a highly efficient and reliable development environment. Extending these systems involves careful integration of external tools, thoughtful error handling, and performance-conscious design choices.

[No sources needed since this section summarizes without analyzing specific files]

## Appendices
- Practical usage scenarios:
  - Prompt customization: Tailor Bash and Fish prompts to include project-specific metadata and theme preferences
  - Archive extraction: Use cross-shell extract functions for consistent progress feedback across environments
  - Process management: Employ fzf-based selection for safe and efficient process termination
  - tmux automation: Save and restore complex tmux setups with pane content capture for reproducible sessions
  - Symlink management: Automate dotfiles deployment with conflict resolution and backup strategies

[No sources needed since this section provides general guidance]