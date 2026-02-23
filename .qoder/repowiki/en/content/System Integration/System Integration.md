# System Integration

<cite>
**Referenced Files in This Document**
- [.bashrc](file://.bashrc)
- [.bash_aliases](file://.bash_aliases)
- [init-symlinks.sh](file://init-symlinks.sh)
- [rollback-symlinks.sh](file://rollback-symlinks.sh)
- [paths.txt](file://paths.txt)
- [paths-termux.txt](file://paths-termux.txt)
- [.config/fish/config.fish](file://.config/fish/config.fish)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish)
- [termux-config/.config/fish/conf.d/shell_rc_content.fish](file://termux-config/.config/fish/conf.d/shell_rc_content.fish)
- [termux-config/.bashrc](file://termux-config/.bashrc)
- [.tmux.conf](file://.tmux.conf)
- [.tmuxline.sh](file://.tmuxline.sh)
- [.gitconfig](file://.gitconfig)
- [.local/share/applications/tailscale-systray.desktop](file://.local/share/applications/tailscale-systray.desktop)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils)
- [.m-utils](file://.m-utils)
- [init-system.sh](file://init-system.sh)
- [rollback-system.sh](file://rollback-system.sh)
- [system-paths.txt](file://system-paths.txt)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules)
- [system/root/.bash_aliases](file://system/root/.bash_aliases)
- [system/root/.config/nvim/init.vim](file://system/root/.config/nvim/init.vim)
</cite>

## Update Summary
**Changes Made**
- Added comprehensive m-utils system management capabilities section
- Integrated centralized system utility management for laptop lid close behavior
- Added system configuration deployment and rollback automation
- Included polkit permissions management for hibernation controls
- Enhanced system-level configuration management with backup/restore operations

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
This document explains how the dotfiles repository integrates shell environments, PATH configuration, and external tools across desktop and Termux contexts. It covers environment variable management, PATH optimization strategies, and integration with development tools, version control, and system utilities. The system now includes comprehensive m-utils system management capabilities for centralized control over system configurations, backup/restore operations, and deployment automation. Practical examples demonstrate environment customization, tool integration patterns, and troubleshooting system-level configuration issues.

## Project Structure
The repository organizes system integration artifacts by shell and platform, now enhanced with system management utilities:
- Bash-based desktop environment: .bashrc, .bash_aliases, tmux configuration, and desktop entries
- Fish-based desktop and Termux environments: .config/fish/config.fish and termux-config/.config/fish/*
- Tool and environment managers: NPM/NVM, Nix/Direnv, and cloud SDK integration
- Deployment and maintenance: init-symlinks.sh and rollback-symlinks.sh for safe dotfiles management
- **New**: m-utils system management for laptop lid close behavior and system configuration deployment
- **New**: System-level configuration management with polkit permissions and automated deployment

```mermaid
graph TB
subgraph "Desktop Shell"
BR[".bashrc"]
BA[".bash_aliases"]
TF[".tmux.conf"]
TL[".tmuxline.sh"]
GC[".gitconfig"]
end
subgraph "Fish Shell"
FC[".config/fish/config.fish"]
end
subgraph "Termux Shell"
TFC["termux-config/.config/fish/config.fish"]
TCC["termux-config/.config/fish/conf.d/shell_rc_content.fish"]
TBR["termux-config/.bashrc"]
end
subgraph "System Management"
MU["system/usr/bin/m-utils"]
MC[".m-utils"]
IS["init-system.sh"]
RS["rollback-system.sh"]
SP["system-paths.txt"]
end
subgraph "System Integrations"
DESK[".local/share/applications/tailscale-systray.desktop"]
POL["polkit rules"]
end
BR --> BA
BR --> TF
TF --> TL
BR --> GC
FC --> GC
TFC --> GC
TCC --> TFC
TBR --> TCC
BR --> DESK
FC --> DESK
TFC --> DESK
MU --> MC
IS --> SP
RS --> POL
```

**Diagram sources**
- [.bashrc](file://.bashrc#L283-L342)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [.tmux.conf](file://.tmux.conf#L1-L69)
- [.tmuxline.sh](file://.tmuxline.sh#L1-L22)
- [.gitconfig](file://.gitconfig#L1-L16)
- [.config/fish/config.fish](file://.config/fish/config.fish#L112-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L127-L183)
- [termux-config/.config/fish/conf.d/shell_rc_content.fish](file://termux-config/.config/fish/conf.d/shell_rc_content.fish#L1-L20)
- [termux-config/.bashrc](file://termux-config/.bashrc#L1-L38)
- [.local/share/applications/tailscale-systray.desktop](file://.local/share/applications/tailscale-systray.desktop#L1-L9)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L1-L392)
- [.m-utils](file://.m-utils#L1-L22)
- [init-system.sh](file://init-system.sh#L1-L326)
- [rollback-system.sh](file://rollback-system.sh#L1-L329)
- [system-paths.txt](file://system-paths.txt#L1-L7)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

**Section sources**
- [.bashrc](file://.bashrc#L1-L343)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [.tmux.conf](file://.tmux.conf#L1-L69)
- [.tmuxline.sh](file://.tmuxline.sh#L1-L22)
- [.gitconfig](file://.gitconfig#L1-L16)
- [.config/fish/config.fish](file://.config/fish/config.fish#L1-L168)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L1-L184)
- [termux-config/.config/fish/conf.d/shell_rc_content.fish](file://termux-config/.config/fish/conf.d/shell_rc_content.fish#L1-L20)
- [termux-config/.bashrc](file://termux-config/.bashrc#L1-L38)
- [.local/share/applications/tailscale-systray.desktop](file://.local/share/applications/tailscale-systray.desktop#L1-L9)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L1-L392)
- [.m-utils](file://.m-utils#L1-L22)
- [init-system.sh](file://init-system.sh#L1-L326)
- [rollback-system.sh](file://rollback-system.sh#L1-L329)
- [system-paths.txt](file://system-paths.txt#L1-L7)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

## Core Components
- Environment variable management: Desktop and Termux shells set TERM, disable virtual environment prompt interference, silence Direnv logs, and configure cloud SDK auth plugins.
- PATH configuration: Both Bash and Fish append and prepend critical directories, avoiding duplication and ensuring idempotence.
- External tool integration: NPM packages, NVM, and cloud SDK are integrated; tmux plugins and Tailscale tray are configured; Fish-specific helpers and Termux overrides are included.
- Deployment and rollback: init-symlinks.sh creates safe symlinks with backups; rollback-symlinks.sh restores previous states.
- **New**: m-utils system management: Centralized control over laptop lid close behavior with systemd integration, suspend timers, and configuration persistence.
- **New**: System configuration deployment: Automated copying of system-level files with backup/restore capabilities and polkit permission management.

**Section sources**
- [.bashrc](file://.bashrc#L283-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L112-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L127-L183)
- [init-symlinks.sh](file://init-symlinks.sh#L116-L244)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L115-L149)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L1-L392)
- [init-system.sh](file://init-system.sh#L1-L326)
- [rollback-system.sh](file://rollback-system.sh#L1-L329)

## Architecture Overview
The system integrates multiple shells and platforms around shared environment variables and PATH. Desktop and Termux environments converge on common integrations (cloud SDK, NPM/NVM, tmux plugins) while diverging on platform-specific PATH and tool availability. The new m-utils system management layer provides centralized control over system configurations with backup/restore capabilities and polkit permission management.

```mermaid
graph TB
subgraph "Environment Variables"
EV1["TERM"]
EV2["VIRTUAL_ENV_DISABLE_PROMPT"]
EV3["DIRENV_LOG_FORMAT"]
EV4["USE_GKE_GCLOUD_AUTH_PLUGIN"]
EV5["NPM_PACKAGES"]
EV6["NVM_DIR"]
end
subgraph "PATH Management"
P1["Append: /usr/sbin, /sbin"]
P2["Prepend: ~/.local/bin, ~/.cargo/bin"]
P3["Termux Prepend: ~/.codex-cli-env/bin, ~/.opt/llama.cpp/bin"]
end
subgraph "Shell Configurations"
BRC[".bashrc"]
FCFG[".config/fish/config.fish"]
TCFG["termux-config/.config/fish/config.fish"]
end
subgraph "External Tools"
NPM["NPM Packages"]
NVM["NVM"]
Tmux["tmux + plugins"]
Cloud["Cloud SDK"]
Tailscale["Tailscale Tray"]
end
subgraph "System Management"
MUtils["m-utils CLI"]
InitSys["init-system.sh"]
RollbackSys["rollback-system.sh"]
Polkit["Polkit Rules"]
end
BRC --> EV1
BRC --> EV2
BRC --> EV3
BRC --> EV4
BRC --> EV5
BRC --> EV6
FCFG --> EV1
FCFG --> EV2
FCFG --> EV3
FCFG --> EV4
TCFG --> EV1
TCFG --> EV4
BRC --> P1
BRC --> P2
FCFG --> P1
FCFG --> P2
TCFG --> P1
TCFG --> P3
BRC --> NPM
BRC --> NVM
BRC --> Tmux
BRC --> Cloud
BRC --> Tailscale
FCFG --> NPM
FCFG --> NVM
FCFG --> Tmux
FCFG --> Cloud
TCFG --> NPM
TCFG --> NVM
TCFG --> Tmux
TCFG --> Cloud
MUtils --> InitSys
MUtils --> RollbackSys
MUtils --> Polkit
```

**Diagram sources**
- [.bashrc](file://.bashrc#L283-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L112-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L127-L183)
- [.tmux.conf](file://.tmux.conf#L56-L68)
- [.local/share/applications/tailscale-systray.desktop](file://.local/share/applications/tailscale-systray.desktop#L1-L9)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L1-L392)
- [init-system.sh](file://init-system.sh#L1-L326)
- [rollback-system.sh](file://rollback-system.sh#L1-L329)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

## Detailed Component Analysis

### Environment Variable Management
- TERM: Ensures consistent terminal capabilities across shells.
- Virtual environment prompts: Disabled to prevent conflicts with custom prompts.
- Direnv logging: Suppressed for cleaner output.
- Cloud SDK auth plugin: Enables modern gcloud auth behavior.
- NPM and NVM: Environment variables and sourcing are handled conditionally.

Practical examples:
- Disable Python/Conda prompt modifications and silence Direnv logs in both Bash and Fish.
- Enable cloud SDK auth plugin for Kubernetes versions that require it.
- Configure NPM packages directory and source NVM when present.

**Section sources**
- [.bashrc](file://.bashrc#L311-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L112-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L154-L183)

### PATH Configuration Strategies
Both Bash and Fish implement idempotent PATH updates:
- Append system administrative binaries (/usr/sbin, /sbin) when missing.
- Prepend user tool directories (~/.local/bin, ~/.cargo/bin) when present.
- Termux adds specialized toolchains to the front of PATH.

Optimization patterns:
- Existence checks before appending/prepending.
- Duplicate avoidance using pattern matching or containment checks.
- Conditional logic per platform and environment.

```mermaid
flowchart TD
Start(["Load shell config"]) --> CheckAppend["Check append paths exist and are not in PATH"]
CheckAppend --> AppendPaths["Append to PATH if missing"]
AppendPaths --> CheckPrepend["Check prepend paths exist and are not in PATH"]
CheckPrepend --> PrependPaths["Prepend to PATH if missing"]
PrependPaths --> TermuxCheck{"Is Termux?"}
TermuxCheck --> |Yes| TermuxPrepend["Prepend Termux-specific paths"]
TermuxCheck --> |No| Done(["Done"])
TermuxPrepend --> Done
```

**Diagram sources**
- [.bashrc](file://.bashrc#L283-L308)
- [.config/fish/config.fish](file://.config/fish/config.fish#L123-L145)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L127-L152)

**Section sources**
- [.bashrc](file://.bashrc#L283-L308)
- [.config/fish/config.fish](file://.config/fish/config.fish#L123-L145)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L127-L152)

### External Tool Integration
- NPM and NVM: NPM packages directory is prepended to PATH; NVM is sourced conditionally.
- tmux: Plugins managed via TPM; default shell set to Fish when available; tmuxline theme loaded.
- Version control: Git defaults configured for editor, push behavior, and initial branch.
- System utilities: Tailscale systray desktop entry integrates with system tray.

Integration patterns:
- Conditional existence checks before sourcing or prepending.
- Idempotent PATH manipulation to avoid duplication.
- Shell-specific hooks (e.g., Fish's direnv integration).

**Section sources**
- [.bashrc](file://.bashrc#L323-L335)
- [.config/fish/config.fish](file://.config/fish/config.fish#L148-L156)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L173-L181)
- [.tmux.conf](file://.tmux.conf#L6-L10)
- [.gitconfig](file://.gitconfig#L1-L16)
- [.local/share/applications/tailscale-systray.desktop](file://.local/share/applications/tailscale-systray.desktop#L1-L9)

### Shell Configuration Interactions
- Bash: Loads aliases, completion, and optional SSH identity loader; sets up PATH and environment variables.
- Fish: Provides custom prompt, environment variables, PATH updates, and optional NVM defaults; integrates with tmux and tmux plugins.
- Termux: Adapts prompts and PATH for Android runtime; exposes Fish-specific helpers and environment integration.

```mermaid
sequenceDiagram
participant User as "User"
participant Bash as ".bashrc"
participant Fish as ".config/fish/config.fish"
participant Termux as "termux-config/.config/fish/config.fish"
participant Tmux as ".tmux.conf"
User->>Bash : Launch interactive shell
Bash->>Bash : Load aliases and PATH
Bash-->>User : Prompt with environment
User->>Fish : Launch fish
Fish->>Fish : Set env vars, PATH, prompt
Fish->>Tmux : Default shell to fish if available
Tmux-->>User : tmux with plugins and theme
User->>Termux : Launch fish under Termux
Termux->>Termux : Adjust PATH and env for Termux
Termux-->>User : Prompt and tools adapted for Android
```

**Diagram sources**
- [.bashrc](file://.bashrc#L213-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L54-L183)
- [.tmux.conf](file://.tmux.conf#L6-L10)

**Section sources**
- [.bashrc](file://.bashrc#L208-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L84-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L54-L183)
- [.tmux.conf](file://.tmux.conf#L6-L10)

### Dotfiles Deployment and Rollback
- init-symlinks.sh: Creates safe symlinks from a path list, handles existing targets (symlinks, directories, files), merges directories, and backs up originals.
- rollback-symlinks.sh: Scans for backups, supports dry-run, specific date, and specific target restoration, and prints a summary.

```mermaid
flowchart TD
A["Read path list"] --> B["Resolve source and target paths"]
B --> C{"Target exists?"}
C --> |No| E["Create symlink"]
C --> |Yes| D["Handle existing target<br/>Backup + Replace/Merge/Skip"]
D --> E
E --> F["Next path"]
F --> A
```

**Diagram sources**
- [init-symlinks.sh](file://init-symlinks.sh#L250-L294)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L173-L209)

**Section sources**
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L1-L316)
- [paths.txt](file://paths.txt#L1-L16)
- [paths-termux.txt](file://paths-termux.txt#L1-L12)

### **New** m-utils System Management
The m-utils system provides centralized control over laptop lid close behavior and system configurations through a comprehensive Python-based utility with systemd integration.

#### Laptop Lid Close Management
- **Battery Power Mode**: Configure lid close behavior with three options - immediate suspend (0), disabled (false), or delayed suspend (n minutes)
- **AC Power Mode**: Separate configuration for AC-powered laptops
- **Systemd Integration**: Creates suspend timers for delayed sleep actions
- **Configuration Persistence**: Stores settings in TOML format for system-wide access

#### System Configuration Deployment
- **Automated Copying**: init-system.sh copies system-level files from the dotfiles repository to their system locations
- **Backup Generation**: Automatic timestamped backups with collision handling
- **Interactive Prompts**: Safe replacement with user confirmation
- **Type Safety**: Handles files, directories, and symlinks appropriately

#### System Configuration Rollback
- **Selective Restoration**: Rollback-system.sh can restore specific targets or all backed up files
- **Date-based Recovery**: Restore to specific backup timestamps
- **Dry Run Mode**: Preview changes before execution
- **Batch Operations**: Non-interactive mode for automated deployments

#### Polkit Permission Management
- **Hibernate Controls**: Grants sudo/wheel group members permission to hibernate
- **Lid Switch Handling**: Enables lid close to trigger hibernation
- **Security Context**: Restricts permissions to local, active sessions only

```mermaid
flowchart TD
Start(["m-utils Command"]) --> Action{"Action Type"}
Action --> |lid-close| LidAction["Laptop Lid Close"]
Action --> |system| SysAction["System Management"]
Action --> |hibernate| HiberAction["Hibernate Permissions"]
LidAction --> LidMode{"Power Mode"}
LidMode --> |battery| BatConfig["Configure Battery Behavior"]
LidMode --> |ac| AcConfig["Configure AC Behavior"]
BatConfig --> BatAction{"Action"}
AcConfig --> AcAction{"Action"}
BatAction --> |sleep| BatSleep["Set Sleep Behavior"]
AcAction --> |sleep| AcSleep["Set Sleep Behavior"]
BatSleep --> BatValue{"Value Type"}
AcSleep --> AcValue{"Value Type"}
BatValue --> |false| BatDisable["Disable Sleep"]
BatValue --> |0| BatImmediate["Immediate Sleep"]
BatValue --> |delay| BatDelay["Delayed Sleep"]
AcValue --> |false| AcDisable["Disable Sleep"]
AcValue --> |0| AcImmediate["Immediate Sleep"]
AcValue --> |delay| AcDelay["Delayed Sleep"]
SysAction --> Deploy["Deploy System Config"]
SysAction --> Rollback["Rollback System Config"]
SysAction --> Status["Show Status"]
HiberAction --> Grant["Grant Hibernate Permissions"]
HiberAction --> Remove["Remove Permissions"]
```

**Diagram sources**
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L335-L392)
- [init-system.sh](file://init-system.sh#L284-L326)
- [rollback-system.sh](file://rollback-system.sh#L257-L329)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

**Section sources**
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L1-L392)
- [.m-utils](file://.m-utils#L1-L22)
- [init-system.sh](file://init-system.sh#L1-L326)
- [rollback-system.sh](file://rollback-system.sh#L1-L329)
- [system-paths.txt](file://system-paths.txt#L1-L7)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

### **New** System-Level Configuration Management
The system now includes comprehensive management of system-level configurations beyond user dotfiles:

#### Root User Configuration
- **Enhanced Aliases**: Interactive rm/cp/mv with safety measures
- **System-wide Neovim**: Root user development environment with custom keybindings and settings

#### Polkit Rule Management
- **Permission Granularity**: Fine-grained control over system actions
- **Group-based Access**: sudo and wheel groups receive elevated permissions
- **Session Validation**: Ensures permissions apply only to active, local sessions

#### System Binary Distribution
- **Centralized Utility**: Single m-utils binary accessible system-wide
- **Python Dependencies**: Requires tomli and tomli-w for TOML configuration management
- **Root Privilege Handling**: Automatic elevation with preserved environment

**Section sources**
- [system/root/.bash_aliases](file://system/root/.bash_aliases#L1-L8)
- [system/root/.config/nvim/init.vim](file://system/root/.config/nvim/init.vim#L1-L157)
- [system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L14-L21)

## Dependency Analysis
- Shell-to-tool dependencies:
  - Bash depends on system completion, optional git completion/prompt, and optional SSH identity loader.
  - Fish integrates with tmux and tmux plugins; optionally sources NVM and sets environment variables.
  - Termux adds platform-specific PATH and environment helpers.
- Cross-platform considerations:
  - PATH differences between desktop and Termux; TERM and display settings vary.
  - Optional tools (e.g., NPM packages, NVM, tmux plugins) are conditionally activated.
- **New**: m-utils dependencies:
  - Python 3.6+ with tomli and tomli-w packages for configuration management
  - systemd for lid close timer functionality
  - polkit for permission management
  - Root privileges for system-level operations

```mermaid
graph LR
Bash[".bashrc"] --> Tools1["Git, SSH, tmux"]
Fish[".config/fish/config.fish"] --> Tools2["tmux plugins, NVM"]
Termux["termux-config/.config/fish/config.fish"] --> Tools3["Termux-specific PATH and helpers"]
MUtils["system/usr/bin/m-utils"] --> Python["Python 3.6+, tomli, tomli-w"]
MUtils --> Systemd["systemd for timers"]
MUtils --> Polkit["polkit for permissions"]
InitSys["init-system.sh"] --> Root["Root privileges"]
RollbackSys["rollback-system.sh"] --> Root
```

**Diagram sources**
- [.bashrc](file://.bashrc#L213-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L148-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L173-L183)
- [.tmux.conf](file://.tmux.conf#L56-L68)
- [.gitconfig](file://.gitconfig#L1-L16)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L14-L21)
- [init-system.sh](file://init-system.sh#L65-L71)
- [rollback-system.sh](file://rollback-system.sh#L31-L37)

**Section sources**
- [.bashrc](file://.bashrc#L213-L342)
- [.config/fish/config.fish](file://.config/fish/config.fish#L148-L167)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L173-L183)
- [.tmux.conf](file://.tmux.conf#L56-L68)
- [.gitconfig](file://.gitconfig#L1-L16)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L14-L21)
- [init-system.sh](file://init-system.sh#L65-L71)
- [rollback-system.sh](file://rollback-system.sh#L31-L37)

## Performance Considerations
- PATH operations are O(n) per path with containment checks; keep the number of appended/prepended paths minimal and guarded by existence checks.
- Shell initialization benefits from conditional sourcing to avoid unnecessary overhead.
- tmux plugin loading occurs at the end of configuration to minimize startup delays.
- **New**: m-utils operations are lightweight Python scripts with minimal overhead; systemd timer creation is performed once during configuration changes.
- **New**: System deployment scripts use efficient file comparison and backup generation with collision handling.

## Troubleshooting Guide
Common issues and resolutions:
- PATH not updated:
  - Verify existence checks and idempotent logic in shell configs.
  - Confirm paths are not already present using the same duplication detection method.
- Tool not found:
  - Ensure prepend order precedes system directories and that paths exist.
  - On Termux, confirm Termux-specific prepend paths are correct.
- tmux plugin issues:
  - Confirm TPM is initialized at the end of .tmux.conf.
  - Validate plugin names and network access for plugin downloads.
- Dotfiles symlink problems:
  - Use init-symlinks.sh to safely create symlinks and back up existing targets.
  - Use rollback-symlinks.sh to restore from backups with dry-run previews.
- **New**: m-utils configuration issues:
  - Verify Python dependencies (tomli, tomli-w) are installed.
  - Check systemd service status for lid close timers.
  - Ensure polkit rules are properly loaded and syntax is valid.
- **New**: System deployment failures:
  - Confirm root privileges are available for system file operations.
  - Verify backup directories are writable and have sufficient space.
  - Check file permissions and ownership for target locations.

**Section sources**
- [.bashrc](file://.bashrc#L283-L308)
- [.config/fish/config.fish](file://.config/fish/config.fish#L123-L145)
- [termux-config/.config/fish/config.fish](file://termux-config/.config/fish/config.fish#L127-L152)
- [.tmux.conf](file://.tmux.conf#L56-L68)
- [init-symlinks.sh](file://init-symlinks.sh#L116-L244)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L115-L149)
- [system/usr/bin/m-utils](file://system/usr/bin/m-utils#L14-L21)
- [init-system.sh](file://init-system.sh#L65-L71)
- [rollback-system.sh](file://rollback-system.sh#L31-L37)

## Conclusion
The dotfiles repository provides robust, cross-platform system integration centered on environment variables, PATH management, and external tool orchestration. The addition of m-utils system management capabilities enhances the repository with centralized control over laptop lid close behavior, automated system configuration deployment, and comprehensive backup/restore operations. Shell configurations remain modular, idempotent, and conditionally activated, while the new system management layer ensures safe maintenance across desktop and Termux environments with professional-grade system administration capabilities.

## Appendices
- Example customizations:
  - Add a new tool to PATH: prepend its bin directory in the appropriate shell config.
  - Integrate a new cloud tool: export required environment variables and ensure PATH precedence.
  - Customize tmux: add plugin names to .tmux.conf and adjust .tmuxline.sh for desired appearance.
  - **New**: Configure m-utils: use `sudo m-utils laptop lid-close battery sleep 15` for delayed sleep on battery power.
  - **New**: Deploy system configurations: run `sudo ./init-system.sh` to copy system-level files with automatic backups.
- Cross-platform tips:
  - Prefer Fish for interactive sessions; set tmux default shell to Fish when available.
  - On Termux, rely on Termux-specific PATH and environment helpers; avoid assuming desktop-only paths.
  - **New**: Use m-utils for consistent system behavior across different Linux distributions.
  - **New**: Leverage polkit rules for secure privilege escalation without password prompts.