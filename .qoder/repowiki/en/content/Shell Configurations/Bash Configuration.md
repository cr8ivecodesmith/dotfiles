# Bash Configuration

<cite>
**Referenced Files in This Document**
- [.bashrc](file://.bashrc)
- [.bash_aliases](file://.bash_aliases)
- [.shell_rc_content](file://termux-config/.shell_rc_content)
- [.bashrc (Termux)](file://termux-config/.bashrc)
- [init-symlinks.sh](file://init-symlinks.sh)
- [README.md](file://README.md)
</cite>

## Update Summary
**Changes Made**
- Enhanced prompt system with modular git branch detection functions
- Added unified prompt extras system for virtual environment and git repository information
- Improved code organization by consolidating prompt components into dedicated functions
- Simplified PS1 construction through modular function architecture
- Enhanced maintainability and extensibility of the prompt system

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
This document explains the Bash configuration tailored for desktop Linux environments, focusing on a robust and extensible .bashrc setup. It covers:
- Two-line custom prompt with distro icons, virtual environment detection, and modular Git branch/status integration
- Terminal capability-aware color handling and PS1 composition through unified prompt extras system
- Environment variable management, PATH optimization with prepend/append logic
- External tool integration for Google Cloud SDK, NPM packages, and NVM
- Practical aliases, completion setup, SSH identity loading, and security considerations
- Performance optimizations, compatibility checks, and troubleshooting

## Project Structure
The Bash configuration is organized around a primary .bashrc and a companion .bash_aliases file. A Termux-specific variant exists under termux-config for mobile/desktop parity. A symlink management script automates installation of dotfiles across platforms.

```mermaid
graph TB
A[".bashrc"] --> B[".bash_aliases"]
A --> C["PATH prepends/appends"]
A --> D["External tool integrations<br/>GCloud, NPM, NVM, direnv"]
A --> E["Enhanced Prompt System<br/>distro_icon, venv_name, __git_branch, __prompt_extras, __prompt_pwd"]
A --> F["Unified PS1 Construction<br/>Modular prompt extras"]
G[".shell_rc_content (Termux)"] --> H["Termux PS1 and helpers"]
I["init-symlinks.sh"] --> J["Install dotfiles across platforms"]
```

**Diagram sources**
- [.bashrc](file://.bashrc#L1-L367)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [.shell_rc_content](file://termux-config/.shell_rc_content#L1-L135)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L373)

**Section sources**
- [.bashrc](file://.bashrc#L1-L367)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [.shell_rc_content](file://termux-config/.shell_rc_content#L1-L135)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L373)
- [README.md](file://README.md#L1-L35)

## Core Components
- Interactivity guard and history tuning
- Color prompt detection and terminal title integration
- Modular prompt functions for distro icon, virtualenv name, git branch detection, and unified prompt extras
- Two-line prompt assembly with modular component system
- Completion subsystem initialization
- Environment variable management and PATH optimization
- External tool integrations (GCloud, NPM packages, NVM, direnv)
- Aliases and convenience functions for navigation, system info, and developer workflows

**Section sources**
- [.bashrc](file://.bashrc#L5-L367)

## Architecture Overview
The Bash runtime initializes by sourcing .bashrc for non-login shells. It performs capability checks, sets up modular prompt functions, composes a two-line prompt through the unified prompt extras system, and then configures environment and tool integrations. Aliases and functions augment productivity and safety.

```mermaid
sequenceDiagram
participant Shell as "Bash Shell"
participant RC as ".bashrc"
participant Func as "Modular Prompt Functions"
participant Extras as "__prompt_extras"
participant Comp as "Completion"
participant Env as "Environment"
Shell->>RC : Source .bashrc
RC->>RC : Interactivity guard and history settings
RC->>RC : Terminal capability checks and color prompt
RC->>Func : Define __distro_icon(), __venv_name(), __git_branch(), __prompt_pwd()
RC->>Extras : Build unified prompt extras with venv and git info
RC->>RC : Compose PS1 (two-line) using modular prompt extras
RC->>Comp : Load bash-completion and git-completion/git-prompt
RC->>Env : Optimize PATH, export tool vars, load external tools
RC-->>Shell : Render prompt and enable completions
```

**Diagram sources**
- [.bashrc](file://.bashrc#L5-L367)

## Detailed Component Analysis

### Enhanced Prompt System and Modular Architecture
**Updated** The prompt system has been significantly enhanced with modular architecture that consolidates virtual environment and git repository information into a unified display system.

- Interactivity guard ensures non-interactive shells skip expensive setup.
- Color prompt detection validates terminal capabilities and sets a color-enabled PS1.
- Modular prompt functions:
  - `__distro_icon()`: Reads os-release and maps to Unicode icons for common distributions
  - `__venv_name()`: Supports Conda and standard virtualenv with intelligent naming
  - `__git_branch()`: New modular function for git branch detection with fallback logic
  - `__prompt_extras()`: Unified function that combines venv and git information with proper spacing
  - `__prompt_pwd()`: Fish-inspired path abbreviation function
- Two-line prompt assembly using the modular system:
  - Line 1: [distro_icon] (abbreviated path) [prompt_extras containing venv and git info]
  - Line 2: Continuation marker with appropriate color
- Terminal title integration updates the xterm/RXVT titlebar to include user, host, and working directory.
- Optional Git integration uses the new modular approach for cleaner PS1 construction.

```mermaid
flowchart TD
Start(["Enhanced Prompt Init"]) --> CheckInteractive["Check interactive shell"]
CheckInteractive --> |Non-interactive| ExitEarly["Return early"]
CheckInteractive --> |Interactive| TermCap["Detect terminal color capability"]
TermCap --> ColorPrompt{"Color prompt enabled?"}
ColorPrompt --> |Yes| BuildPS1["Build two-line PS1 using modular system:<br/>Line 1: [icon pwd] + __prompt_extras()<br/>Line 2: continuation marker"]
ColorPrompt --> |No| FallbackPS1["Set fallback PS1"]
BuildPS1 --> Extras["Call __prompt_extras()"]
Extras --> VenvCheck{"Virtual environment detected?"}
VenvCheck --> |Yes| AddVenv["Add venv info with leading space"]
VenvCheck --> |No| SkipVenv["Skip venv info"]
AddVenv --> GitCheck{"Git repository detected?"}
SkipVenv --> GitCheck
GitCheck --> |Yes| AddGit["Add git branch info with leading space"]
GitCheck --> |No| SkipGit["Skip git info"]
AddGit --> Done(["Render PS1"])
SkipGit --> Done
FallbackPS1 --> Done
ExitEarly --> End(["Exit"])
Done --> End
```

**Diagram sources**
- [.bashrc](file://.bashrc#L129-L220)

**Section sources**
- [.bashrc](file://.bashrc#L129-L220)

### Modular Prompt Functions
**Updated** The prompt system now features enhanced modular functions that improve code organization and maintainability.

- `__git_branch()` function: New modular git branch detection with comprehensive fallback logic
  - Checks for git availability before proceeding
  - Validates git repository presence using `git rev-parse --git-dir`
  - Implements fallback chain: symbolic-ref → describe → short SHA
  - Returns formatted branch information with proper icon
- `__prompt_extras()` function: Unified function that consolidates virtual environment and git information
  - Calls `__venv_name()` and `__git_branch()` internally
  - Adds proper leading spaces for clean formatting
  - Returns combined string suitable for PS1 insertion
- `__venv_name()` function: Enhanced virtual environment detection with improved naming logic
  - Supports Conda and standard virtualenv environments
  - Intelligent naming: respects explicit prompt, uses project folder for generic names, falls back to CWD
  - Returns formatted virtual environment information with proper icon
- `__prompt_pwd()` function: Fish-inspired path abbreviation mirroring fish's prompt_pwd behavior
  - Abbreviates intermediate directories while preserving first and last segments
  - Handles home directory special case
  - Uses first-letter abbreviation for middle path components

```mermaid
flowchart TD
A["__git_branch()"] --> B["Check git availability"]
B --> C{"Git available?"}
C --> |No| D["Return (no git info)"]
C --> |Yes| E["Check git repository"]
E --> F{"In git repo?"}
F --> |No| D
F --> |Yes| G["Get branch with fallback:<br/>symbolic-ref → describe → short SHA"]
G --> H["Return formatted branch info"]
I["__prompt_extras()"] --> J["Get venv info (__venv_name)"]
J --> K{"Venv exists?"}
K --> |Yes| L["Add leading space + venv info"]
K --> |No| M["Empty venv string"]
L --> N["Get git info (__git_branch)"]
M --> N
N --> O{"Git exists?"}
O --> |Yes| P["Add leading space + git info"]
O --> |No| Q["Empty git string"]
P --> R["Concatenate venv + git"]
Q --> R
R --> S["Return combined prompt extras"]
T["__venv_name()"] --> U{"CONDA_DEFAULT_ENV?"}
U --> |Yes| V["Return conda env name"]
U --> |No| W{"VIRTUAL_ENV?"}
W --> |Yes| X["Resolve display name<br/>respect explicit prompt or infer from parent"]
X --> Y["Return formatted venv info"]
W --> |No| Z["Return failure"]
```

**Diagram sources**
- [.bashrc](file://.bashrc#L129-L198)

**Section sources**
- [.bashrc](file://.bashrc#L129-L198)

### Completion and Tooling
- Programmable completion is enabled by sourcing bash-completion if available.
- Git completion and prompt scripts are conditionally sourced if present.
- SSH identities are loaded via a helper script if present.
- GCloud auth plugin is enabled for Kubernetes contexts.
- direnv integration is enabled when available.

```mermaid
sequenceDiagram
participant RC as ".bashrc"
participant BC as "bash-completion"
participant GC as "git-completion"
participant GP as "git-prompt"
participant SSH as "load_ssh_identities"
participant DIR as "direnv"
RC->>BC : Source if available
RC->>GC : Source if present
RC->>GP : Source if present
RC->>SSH : Source if present
RC->>DIR : Hook if available
```

**Diagram sources**
- [.bashrc](file://.bashrc#L242-L261)

**Section sources**
- [.bashrc](file://.bashrc#L242-L261)

### Environment Variables and PATH Management
- PATH optimization:
  - Appends system administrative binaries (e.g., /usr/sbin, /sbin) if missing
  - Prepends user-local and tool-specific directories (e.g., ~/.local/bin, ~/.cargo/bin)
- NPM packages directory is added to PATH if present
- NVM is initialized if present, enabling Node.js version management
- GCloud-specific environment variables are exported for modern kube auth behavior
- Python virtualenv prompt is disabled to avoid duplication with the custom prompt

```mermaid
flowchart TD
Start(["PATH Setup"]) --> AppendPaths["Define paths to append"]
AppendPaths --> ForEachAppend{"For each path"}
ForEachAppend --> CheckAppend{"Path present?"}
CheckAppend --> |No| DoAppend["Export PATH=$PATH:$path"]
CheckAppend --> |Yes| NextAppend["Next path"]
DoAppend --> NextAppend
NextAppend --> PrependPaths["Define paths to prepend"]
PrependPaths --> ForEachPrepend{"For each path"}
ForEachPrepend --> CheckPrepend{"Path present?"}
CheckPrepend --> |No| DoPrepend["Export PATH=$path:$PATH"]
CheckPrepend --> |Yes| NextPrepend["Next path"]
DoPrepend --> NextPrepend
NextPrepend --> NPM["Add NPM packages bin if present"]
NPM --> NVM["Initialize NVM if present"]
NVM --> GCloud["Enable GCloud auth plugin"]
GCloud --> PyVenv["Disable Python venv prompt"]
PyVenv --> End(["Done"])
```

**Diagram sources**
- [.bashrc](file://.bashrc#L307-L367)

**Section sources**
- [.bashrc](file://.bashrc#L307-L367)

### Aliases and Functions
- System safety and ergonomics: interactive rm/cp/mv, mkdir with parent creation, convenient navigation shortcuts
- Developer-centric aliases: Git shortcuts, fzf-powered file selection and editor launching
- File listing and search: dircolors-aware ls with eza fallback, bat/batcat integration, grep colorization
- Productivity functions: copy+go, move+go, mkdir+go, archive extraction with progress, text search across files, interactive process killer with fzf

```mermaid
classDiagram
class BashAliases {
+SystemAliases
+NavigationAliases
+DeveloperAliases
+ListAndSearch
+ProductivityFunctions
}
class Functions {
+cpg()
+mvg()
+mkdirg()
+extract()
+ftext()
+fkill()
}
BashAliases --> Functions : "defines"
```

**Diagram sources**
- [.bash_aliases](file://.bash_aliases#L1-L196)

**Section sources**
- [.bash_aliases](file://.bash_aliases#L1-L196)

### Termux Variant
- Lightweight PS1 with distro icon and current working directory
- FZF color overrides and convenience aliases
- Apt wrapper that prefers nala with fallback to apt

**Section sources**
- [.shell_rc_content](file://termux-config/.shell_rc_content#L1-L135)
- [.bashrc (Termux)](file://termux-config/.bashrc#L1-L38)

## Dependency Analysis
- .bashrc depends on:
  - Terminal capability detection for color prompt
  - Presence of git for optional Git integration through modular functions
  - Availability of bash-completion and optional git-completion/git-prompt
  - Optional presence of NPM packages, NVM, and direnv
  - Optional presence of SSH identity loader script
- .bash_aliases augments .bashrc with productivity-focused aliases and functions
- init-symlinks.sh coordinates installation of dotfiles across platforms, ensuring correct symlink targets

```mermaid
graph TB
RC[".bashrc"] --> Term["Terminal capability checks"]
RC --> Git["Optional Git integration (__git_branch)"]
RC --> Comp["bash-completion + git-completion/git-prompt"]
RC --> Tools["NPM/NVM/GCloud/direnv"]
RC --> Aliases[".bash_aliases"]
RC --> SSH["SSH identities loader"]
RC --> Extras["Unified prompt extras (__prompt_extras)"]
Script["init-symlinks.sh"] --> RC
Script --> Aliases
```

**Diagram sources**
- [.bashrc](file://.bashrc#L1-L367)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L373)

**Section sources**
- [.bashrc](file://.bashrc#L1-L367)
- [.bash_aliases](file://.bash_aliases#L1-L196)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L373)

## Performance Considerations
- Conditional checks: Git integration is gated behind availability checks to avoid overhead in non-Git directories.
- Modular prompt functions keep logic minimal and avoid heavy subprocess calls; path abbreviation avoids unnecessary expansions.
- Unified prompt extras system reduces repeated function calls and improves maintainability.
- History tuning reduces duplicates and controls history size to keep shell responsive.
- PATH optimization avoids redundant prepends/appends and only exports when necessary.
- Completion is loaded once and only when available.

## Troubleshooting Guide
Common issues and resolutions:
- Prompt not colored or garbled:
  - Verify TERM type and color capability checks; ensure the terminal supports 256-color or xterm-color.
  - Confirm escape sequences are preserved in PS1 by using proper bracketing for non-printing sequences.
- Virtual environment not indicated:
  - Ensure VIRTUAL_ENV or CONDA_DEFAULT_ENV is set and exported in the environment.
  - Disable Python's built-in virtualenv prompt to prevent duplication.
- Git branch/status not shown:
  - Confirm git is installed and available on PATH.
  - Ensure git-completion and/or git-prompt are sourced if desired.
  - Verify the new `__git_branch()` function is working correctly.
- Modular prompt extras not displaying:
  - Check that `__prompt_extras()` function is properly concatenating venv and git information.
  - Verify proper spacing is maintained between components.
- PATH changes not taking effect:
  - Confirm prepend/append logic runs and exports PATH.
  - Check for conflicting environment modifications in other startup files.
- SSH identities not loaded:
  - Verify the identity loader script exists and is executable.
- External tools not available:
  - Confirm NPM packages directory, NVM, or GCloud are installed and initialized as configured.

**Section sources**
- [.bashrc](file://.bashrc#L40-L53)
- [.bashrc](file://.bashrc#L129-L156)
- [.bashrc](file://.bashrc#L307-L367)
- [.bashrc](file://.bashrc#L242-L261)

## Conclusion
This Bash configuration delivers a modern, efficient, and extensible shell experience for desktop Linux. The enhanced prompt system provides a two-line prompt with distro awareness, virtual environment visibility, and modular Git integration through unified prompt extras. The refactored architecture improves maintainability while keeping robust PATH management and external tool integrations. The included aliases and functions improve daily workflows, and the setup remains portable across platforms with the provided symlink management script.

## Appendices

### Installation and Setup
- Use the symlink manager to install dotfiles across platforms, backing up existing files and handling conflicts.
- Ensure required tools are installed as outlined in the project README.

**Section sources**
- [init-symlinks.sh](file://init-symlinks.sh#L1-L373)
- [README.md](file://README.md#L7-L35)