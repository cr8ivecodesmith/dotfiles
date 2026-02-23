# M-Utils System Management

<cite>
**Referenced Files in This Document**
- [README.md](file://README.md)
- [init-system.sh](file://init-system.sh)
- [init-symlinks.sh](file://init-symlinks.sh)
- [rollback-system.sh](file://rollback-system.sh)
- [rollback-symlinks.sh](file://rollback-symlinks.sh)
- [system-paths.txt](file://system-paths.txt)
- [paths.txt](file://paths.txt)
- [paths-termux.txt](file://paths-termux.txt)
- [m-utils](file://system/usr/bin/m-utils)
- [.m-utils](file://.m-utils)
- [49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules)
- [root.bash_aliases](file://system/root/.bash_aliases)
- [nvim.init.vim](file://.config/nvim/init.vim)
- [fish.config.fish](file://.config/fish/config.fish)
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

## Introduction
M-Utils System Management is a comprehensive dotfiles and system configuration management toolkit designed to streamline the setup and maintenance of development environments across Linux systems. The project provides automated tools for managing symbolic links, copying system files, rolling back changes, and configuring laptop power management behaviors.

The system centers around a Python-based utility called `m-utils` that manages systemd integration, Polkit permissions, and delayed suspend functionality for laptops. It works alongside Bash scripts that handle dotfiles deployment and system-wide file management, creating a cohesive ecosystem for maintaining consistent development environments.

## Project Structure
The repository follows a modular structure optimized for system management and dotfiles deployment:

```mermaid
graph TB
subgraph "Root Directory"
A[Repository Root]
B[README.md]
C[Setup Scripts]
D[Configuration Files]
end
subgraph "System Management"
E[init-system.sh]
F[rollback-system.sh]
G[m-utils executable]
H[system-paths.txt]
end
subgraph "Dotfiles Management"
I[init-symlinks.sh]
J[rollback-symlinks.sh]
K[paths.txt]
L[paths-termux.txt]
end
subgraph "System Configuration"
M[/system/ directory]
N[Polkit Rules]
O[Logind Config]
P[Systemd Timers]
end
subgraph "Editor Configuration"
Q[Neovim Config]
R[Fish Shell Config]
S[Plugin Management]
end
A --> C
A --> D
C --> E
C --> F
C --> G
D --> H
D --> M
M --> N
M --> O
M --> P
A --> I
A --> J
A --> K
A --> L
A --> Q
A --> R
Q --> S
```

**Diagram sources**
- [init-system.sh](file://init-system.sh#L1-L326)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)
- [system-paths.txt](file://system-paths.txt#L1-L7)
- [paths.txt](file://paths.txt#L1-L18)

**Section sources**
- [README.md](file://README.md#L1-L35)
- [init-system.sh](file://init-system.sh#L1-L326)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)

## Core Components

### System File Management Scripts
The system provides two primary scripts for managing system-level files:

**init-system.sh**: Copies files from the dotfiles repository to their system destinations with intelligent conflict resolution and backup generation. It supports both interactive and batch modes, handles type mismatches, and preserves file attributes during copying.

**rollback-system.sh**: Reverses system file changes by restoring from timestamped backups. It supports selective restoration, date-based targeting, and dry-run previews for safe rollback operations.

### Dotfiles Management Scripts
The dotfiles management system focuses on symbolic link creation and maintenance:

**init-symlinks.sh**: Creates symbolic links from the dotfiles repository to user home directories, with sophisticated handling for existing files, directories, and broken symlinks. It includes merge capabilities for directory contents and comprehensive backup generation.

**rollback-symlinks.sh**: Restores dotfiles from timestamped backups, supporting individual file restoration, bulk operations, and selective targeting with date filters.

### Laptop Power Management Utility
The `m-utils` Python script provides advanced laptop configuration capabilities:

- **Delayed Suspend**: Configures systemd timers for delayed laptop lid closure
- **Power Mode Management**: Handles both battery and AC power configurations
- **Systemd Integration**: Manages logind.conf.d drop-in files and systemd timer units
- **Polkit Permissions**: Works with PolicyKit rules for hibernation controls

**Section sources**
- [init-system.sh](file://init-system.sh#L1-L326)
- [rollback-system.sh](file://rollback-system.sh#L1-L329)
- [init-symlinks.sh](file://init-symlinks.sh#L1-L347)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L1-L316)
- [m-utils](file://system/usr/bin/m-utils#L1-L392)

## Architecture Overview

```mermaid
graph TB
subgraph "User Interface Layer"
A[Command Line Interface]
B[Configuration Files]
end
subgraph "Management Scripts"
C[init-system.sh]
D[rollback-system.sh]
E[init-symlinks.sh]
F[rollback-symlinks.sh]
end
subgraph "Utility Layer"
G[m-utils Python Script]
H[Polkit Rules]
I[Systemd Integration]
end
subgraph "System Services"
J[systemd-logind]
K[PolicyKit Daemon]
L[Systemd Timers]
end
subgraph "Storage Layer"
M[Backup System]
N[Dotfiles Repository]
O[System Paths File]
end
A --> C
A --> E
A --> G
B --> G
C --> M
E --> M
G --> H
G --> I
H --> K
I --> J
I --> L
M --> N
M --> O
```

**Diagram sources**
- [m-utils](file://system/usr/bin/m-utils#L1-L392)
- [49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)
- [root.bash_aliases](file://system/root/.bash_aliases#L1-L8)

The architecture implements a layered approach where user commands trigger scripts that manage system resources through appropriate privilege escalation mechanisms. The system maintains comprehensive backup capabilities and provides both interactive and automated operation modes.

**Section sources**
- [m-utils](file://system/usr/bin/m-utils#L1-L392)
- [49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

## Detailed Component Analysis

### m-utils Laptop Power Management System

The `m-utils` utility implements a sophisticated laptop power management system with the following key components:

```mermaid
classDiagram
class MUtilsCLI {
+laptop lid-close status
+laptop lid-close remove
+laptop lid-close battery sleep [value]
+laptop lid-close ac sleep [value]
}
class ConfigManager {
+load_config() Dict
+save_config(config) void
+CONFIG_FILE Path
}
class LogindManager {
+set_logind_setting(key, value) void
+restart_logind() void
+LOGIND_CONF Path
+LOGIND_CONF_D Path
}
class TimerManager {
+create_suspend_timer(mode, delay) void
+remove_suspend_timer(mode) void
+remove_all_lid_configs() void
+TIMER_DIR Path
}
class SystemChecker {
+check_system_config_active() Dict
+system_status Dict
}
MUtilsCLI --> ConfigManager : "manages"
MUtilsCLI --> LogindManager : "configures"
MUtilsCLI --> TimerManager : "controls"
MUtilsCLI --> SystemChecker : "queries"
LogindManager --> TimerManager : "coordinates"
```

**Diagram sources**
- [m-utils](file://system/usr/bin/m-utils#L29-L215)

The system provides three operational modes for lid closure:

1. **Immediate Suspend (value = 0)**: Uses systemd-logind's built-in suspend action
2. **Disabled (value = false)**: Sets HandleLidSwitch to ignore for complete inactivity
3. **Delayed Suspend (value = N minutes)**: Creates systemd timers for delayed action

**Section sources**
- [m-utils](file://system/usr/bin/m-utils#L234-L282)
- [.m-utils](file://.m-utils#L1-L22)

### System File Deployment Pipeline

The system file management follows a structured deployment process:

```mermaid
sequenceDiagram
participant User as User
participant Script as init-system.sh
participant FS as File System
participant Backup as Backup System
User->>Script : Execute with path file
Script->>Script : Parse arguments
Script->>Script : Validate root privileges
Script->>Script : Read path file
Script->>FS : Process each path entry
loop For each path
Script->>FS : Resolve source/target paths
Script->>FS : Check if target exists
alt Target doesn't exist
Script->>FS : Create parent directories
Script->>FS : Copy file/directory
else Target exists
Script->>Script : Compare files
alt Files identical
Script->>User : Skip (already up-to-date)
else Files differ
Script->>User : Prompt for replacement
User->>Script : Confirm
Script->>Backup : Create timestamped backup
Script->>FS : Replace with new file
end
end
end
Script->>User : Report completion status
```

**Diagram sources**
- [init-system.sh](file://init-system.sh#L222-L258)

**Section sources**
- [init-system.sh](file://init-system.sh#L260-L322)
- [system-paths.txt](file://system-paths.txt#L1-L7)

### Dotfiles Symbolic Link Management

The dotfiles management system implements intelligent symlink handling:

```mermaid
flowchart TD
Start([Process Path Entry]) --> ValidatePath["Validate Path Entry"]
ValidatePath --> CheckSource{"Source Exists?"}
CheckSource --> |No| SkipEntry["Skip Entry<br/>Log Warning"]
CheckSource --> |Yes| ResolvePaths["Resolve Source/Target Paths"]
ResolvePaths --> CheckTarget{"Target Exists?"}
CheckTarget --> |No| CreateParent["Create Parent Directory"]
CreateParent --> CreateSymlink["Create Symlink"]
CreateSymlink --> End([Complete])
CheckTarget --> |Yes| CheckType{"Target Type"}
CheckType --> |Symlink| CheckLink{"Points to Correct Location?"}
CheckLink --> |Yes| SkipEntry
CheckLink --> |No||Broken| BackupSymlink["Backup Current Symlink"]
CheckLink --> |Wrong Location| BackupSymlink
BackupSymlink --> CreateSymlink
CheckType --> |Directory| CheckDirContent{"Directory Empty?"}
CheckDirContent --> |Yes| BackupDir["Backup Directory"]
CheckDirContent --> |No| MergeContent["Merge Existing Content"]
MergeContent --> BackupDir
BackupDir --> CreateSymlink
CheckType --> |Regular File| BackupFile["Backup File"]
BackupFile --> CreateSymlink
SkipEntry --> End
```

**Diagram sources**
- [init-symlinks.sh](file://init-symlinks.sh#L192-L223)

**Section sources**
- [init-symlinks.sh](file://init-symlinks.sh#L250-L286)
- [paths.txt](file://paths.txt#L1-L18)

### Configuration Management System

The system employs a hierarchical configuration approach:

```mermaid
graph LR
subgraph "Configuration Sources"
A[.m-utils File]
B[Logind Drop-in Files]
C[Systemd Timer Units]
D[Polkit Rules]
end
subgraph "Runtime State"
E[Active Configuration]
F[System Status]
G[Backup Records]
end
subgraph "Management Commands"
H[Status Check]
I[Apply Changes]
J[Remove Configurations]
end
A --> E
B --> E
C --> E
D --> E
E --> F
F --> G
H --> F
I --> A
I --> B
I --> C
J --> A
J --> B
J --> C
```

**Diagram sources**
- [m-utils](file://system/usr/bin/m-utils#L217-L232)
- [.m-utils](file://.m-utils#L1-L22)

**Section sources**
- [m-utils](file://system/usr/bin/m-utils#L284-L334)
- [49-allow-hibernate-sudoers.rules](file://system/etc/polkit-1/rules.d/49-allow-hibernate-sudoers.rules#L1-L17)

## Dependency Analysis

The system exhibits well-structured dependencies with clear separation of concerns:

```mermaid
graph TB
subgraph "Python Dependencies"
A[tomli] --> B[m-utils]
C[tomli_w] --> B
end
subgraph "System Dependencies"
D[systemd] --> E[systemd-logind]
D --> F[Systemd Timers]
G[PolicyKit] --> H[Polkit Daemon]
I[Bash] --> J[Shell Scripts]
end
subgraph "Configuration Dependencies"
K[logind.conf.d] --> E
L[systemd/system] --> F
M[polkit-1/rules.d] --> H
end
subgraph "File Dependencies"
N[Backup Files] --> O[Date Timestamped]
P[Dotfiles Repository] --> Q[Symbolic Links]
R[System Paths] --> S[File Copying]
end
B --> D
B --> G
J --> D
J --> G
J --> I
```

**Diagram sources**
- [m-utils](file://system/usr/bin/m-utils#L14-L21)
- [init-system.sh](file://init-system.sh#L65-L71)

The dependency graph reveals a clean architecture where:
- Python scripts depend on external libraries for configuration parsing
- Shell scripts rely on system services for file management
- Configuration files serve as the bridge between user preferences and system services
- Backup systems provide safety mechanisms for all operations

**Section sources**
- [m-utils](file://system/usr/bin/m-utils#L14-L21)
- [init-system.sh](file://init-system.sh#L65-L71)

## Performance Considerations

The system is designed with several performance optimizations:

### Efficient File Operations
- Binary-safe file comparison using `cmp` for identical file detection
- Batch processing of path entries reduces I/O overhead
- Intelligent skipping of unchanged files prevents unnecessary operations

### Memory Management
- Stream-based file processing prevents memory exhaustion with large files
- Temporary arrays for backup discovery minimize memory footprint
- Lazy evaluation of system status checks optimizes runtime performance

### Parallel Processing Opportunities
The current implementation processes files sequentially, but could benefit from:
- Concurrent file copying for independent paths
- Asynchronous backup generation
- Parallel symlink creation for multiple targets

### Storage Optimization
- Timestamped backup naming prevents filesystem pollution
- Selective restoration reduces disk usage during rollback operations
- Compressed backup storage for large configuration sets

## Troubleshooting Guide

### Common Issues and Solutions

**Permission Denied Errors**
- Ensure scripts are executed with appropriate privileges
- Verify sudo access for system file operations
- Check Polkit configuration for hibernation permissions

**Backup Restoration Failures**
- Verify backup files exist with correct timestamp format
- Check filesystem permissions for target locations
- Validate that backup timestamps fall within acceptable date ranges

**Laptop Configuration Not Applied**
- Confirm systemd-logind service is running
- Verify Polkit rules are properly loaded
- Check systemd daemon status after configuration changes

**Symbolic Link Creation Problems**
- Ensure target directories exist or can be created
- Verify source files are readable and accessible
- Check for existing files that might block symlink creation

**Section sources**
- [rollback-system.sh](file://rollback-system.sh#L31-L37)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L12-L28)
- [m-utils](file://system/usr/bin/m-utils#L49-L54)

### Debugging Procedures

1. **Enable Verbose Logging**: Use `--no-verify` flag for batch operations to see all operations
2. **Check System Status**: Use `m-utils laptop lid-close status` to verify current configuration
3. **Validate Dependencies**: Ensure required Python packages are installed (`tomli`, `tomli_w`)
4. **Review Backup Files**: Examine timestamped backups for restoration verification

### Recovery Procedures

For complete system recovery:
1. Use `rollback-system.sh --dry-run` to preview changes
2. Execute `rollback-system.sh` with confirmation for actual restoration
3. Restart affected services (systemd-logind, Polkit daemon)
4. Verify configuration integrity with status commands

**Section sources**
- [rollback-system.sh](file://rollback-system.sh#L257-L325)
- [rollback-symlinks.sh](file://rollback-symlinks.sh#L246-L312)

## Conclusion

M-Utils System Management provides a comprehensive solution for maintaining consistent development environments across Linux systems. The toolkit successfully balances automation with safety through its robust backup systems, intelligent conflict resolution, and privilege-aware operations.

Key strengths of the system include:
- **Modular Design**: Clear separation between system management and dotfiles handling
- **Safety First**: Comprehensive backup systems prevent irreversible changes
- **Flexible Operation**: Support for both interactive and automated workflows
- **System Integration**: Deep integration with systemd, Polkit, and common Linux services

The architecture demonstrates excellent engineering practices with proper error handling, configuration management, and extensibility for future enhancements. The combination of Python-based utilities and Bash scripting creates an efficient and maintainable system that scales across different deployment scenarios.

Future enhancements could include parallel processing capabilities, enhanced monitoring features, and expanded platform support for broader compatibility across Linux distributions.