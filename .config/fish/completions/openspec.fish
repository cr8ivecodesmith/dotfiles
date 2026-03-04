# Fish completion script for OpenSpec CLI
# Auto-generated - do not edit manually

# Helper function to check if a subcommand is present
function __fish_openspec_using_subcommand
    set -l cmd (commandline -opc)
    set -e cmd[1]
    for i in $argv
        if contains -- $i $cmd
            return 0
        end
    end
    return 1
end

function __fish_openspec_no_subcommand
    set -l cmd (commandline -opc)
    test (count $cmd) -eq 1
end
# Dynamic completion helpers

function __fish_openspec_changes
    openspec __complete changes 2>/dev/null | while read -l id desc
        printf '%s\t%s\n' "$id" "$desc"
    end
end

function __fish_openspec_specs
    openspec __complete specs 2>/dev/null | while read -l id desc
        printf '%s\t%s\n' "$id" "$desc"
    end
end

function __fish_openspec_items
    __fish_openspec_changes
    __fish_openspec_specs
end
# init command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'init' -d 'Initialize OpenSpec in your project'
# update command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'update' -d 'Update OpenSpec instruction files'
# list command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'list' -d 'List items (changes by default, or specs with --specs)'
# view command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'view' -d 'Display an interactive dashboard of specs and changes'
# validate command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'validate' -d 'Validate changes and specs'
# show command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'show' -d 'Show a change or spec'
# archive command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'archive' -d 'Archive a completed change and update main specs'
# feedback command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'feedback' -d 'Submit feedback about OpenSpec'
# change command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'change' -d 'Manage OpenSpec change proposals (deprecated)'
# spec command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'spec' -d 'Manage OpenSpec specifications'
# completion command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'completion' -d 'Manage shell completions for OpenSpec CLI'
# config command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'config' -d 'View and modify global OpenSpec configuration'
# schema command
complete -c openspec -n '__fish_openspec_no_subcommand' -a 'schema' -d 'Manage workflow schemas'

# init flags
complete -c openspec -n '__fish_openspec_using_subcommand init' -l tools -r -d 'Configure AI tools non-interactively (e.g., "all", "none", or comma-separated tool IDs)'

# update flags

# list flags
complete -c openspec -n '__fish_openspec_using_subcommand list' -l specs -d 'List specs instead of changes'
complete -c openspec -n '__fish_openspec_using_subcommand list' -l changes -d 'List changes explicitly (default)'

# view flags

# validate flags
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l all -d 'Validate all changes and specs'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l changes -d 'Validate all changes'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l specs -d 'Validate all specs'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l type -a 'change' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l type -a 'spec' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l strict -d 'Enable strict validation mode'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l json -d 'Output validation results as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l concurrency -r -d 'Max concurrent validations (defaults to env OPENSPEC_CONCURRENCY or 6)'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -l no-interactive -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_subcommand validate' -a '(__fish_openspec_items)' -f

# show flags
complete -c openspec -n '__fish_openspec_using_subcommand show' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l type -a 'change' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l type -a 'spec' -d 'Specify item type when ambiguous'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l no-interactive -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l deltas-only -d 'Show only deltas (JSON only, change-specific)'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l requirements-only -d 'Alias for --deltas-only (deprecated, change-specific)'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l requirements -d 'Show only requirements, exclude scenarios (JSON only, spec-specific)'
complete -c openspec -n '__fish_openspec_using_subcommand show' -l no-scenarios -d 'Exclude scenario content (JSON only, spec-specific)'
complete -c openspec -n '__fish_openspec_using_subcommand show' -s r -l requirement -r -d 'Show specific requirement by ID (JSON only, spec-specific)'
complete -c openspec -n '__fish_openspec_using_subcommand show' -a '(__fish_openspec_items)' -f

# archive flags
complete -c openspec -n '__fish_openspec_using_subcommand archive' -s y -l yes -d 'Skip confirmation prompts'
complete -c openspec -n '__fish_openspec_using_subcommand archive' -l skip-specs -d 'Skip spec update operations'
complete -c openspec -n '__fish_openspec_using_subcommand archive' -l no-validate -d 'Skip validation (not recommended)'
complete -c openspec -n '__fish_openspec_using_subcommand archive' -a '(__fish_openspec_changes)' -f

# feedback flags
complete -c openspec -n '__fish_openspec_using_subcommand feedback' -l body -r -d 'Detailed description for the feedback'

complete -c openspec -n '__fish_openspec_using_subcommand change; and not __fish_openspec_using_subcommand show' -a 'show' -d 'Show a change proposal'
complete -c openspec -n '__fish_openspec_using_subcommand change; and not __fish_openspec_using_subcommand list' -a 'list' -d 'List all active changes (deprecated)'
complete -c openspec -n '__fish_openspec_using_subcommand change; and not __fish_openspec_using_subcommand validate' -a 'validate' -d 'Validate a change proposal'

# change show flags
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand show' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand show' -l deltas-only -d 'Show only deltas (JSON only)'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand show' -l requirements-only -d 'Alias for --deltas-only (deprecated)'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand show' -l no-interactive -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand show' -a '(__fish_openspec_changes)' -f
# change list flags
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand list' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand list' -l long -d 'Show id and title with counts'
# change validate flags
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand validate' -l strict -d 'Enable strict validation mode'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand validate' -l json -d 'Output validation results as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand validate' -l no-interactive -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_subcommand change; and __fish_openspec_using_subcommand validate' -a '(__fish_openspec_changes)' -f

complete -c openspec -n '__fish_openspec_using_subcommand spec; and not __fish_openspec_using_subcommand show' -a 'show' -d 'Show a specification'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and not __fish_openspec_using_subcommand list' -a 'list' -d 'List all specifications'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and not __fish_openspec_using_subcommand validate' -a 'validate' -d 'Validate a specification'

# spec show flags
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand show' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand show' -l requirements -d 'Show only requirements, exclude scenarios (JSON only)'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand show' -l no-scenarios -d 'Exclude scenario content (JSON only)'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand show' -s r -l requirement -r -d 'Show specific requirement by ID (JSON only)'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand show' -l no-interactive -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand show' -a '(__fish_openspec_specs)' -f
# spec list flags
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand list' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand list' -l long -d 'Show id and title with counts'
# spec validate flags
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand validate' -l strict -d 'Enable strict validation mode'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand validate' -l json -d 'Output validation results as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand validate' -l no-interactive -d 'Disable interactive prompts'
complete -c openspec -n '__fish_openspec_using_subcommand spec; and __fish_openspec_using_subcommand validate' -a '(__fish_openspec_specs)' -f

complete -c openspec -n '__fish_openspec_using_subcommand completion; and not __fish_openspec_using_subcommand generate' -a 'generate' -d 'Generate completion script for a shell (outputs to stdout)'
complete -c openspec -n '__fish_openspec_using_subcommand completion; and not __fish_openspec_using_subcommand install' -a 'install' -d 'Install completion script for a shell'
complete -c openspec -n '__fish_openspec_using_subcommand completion; and not __fish_openspec_using_subcommand uninstall' -a 'uninstall' -d 'Uninstall completion script for a shell'

# completion generate flags
complete -c openspec -n '__fish_openspec_using_subcommand completion; and __fish_openspec_using_subcommand generate' -a 'zsh bash fish powershell' -f
# completion install flags
complete -c openspec -n '__fish_openspec_using_subcommand completion; and __fish_openspec_using_subcommand install' -l verbose -d 'Show detailed installation output'
complete -c openspec -n '__fish_openspec_using_subcommand completion; and __fish_openspec_using_subcommand install' -a 'zsh bash fish powershell' -f
# completion uninstall flags
complete -c openspec -n '__fish_openspec_using_subcommand completion; and __fish_openspec_using_subcommand uninstall' -s y -l yes -d 'Skip confirmation prompts'
complete -c openspec -n '__fish_openspec_using_subcommand completion; and __fish_openspec_using_subcommand uninstall' -a 'zsh bash fish powershell' -f

complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand path' -a 'path' -d 'Show config file location'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand list' -a 'list' -d 'Show all current settings'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand get' -a 'get' -d 'Get a specific value (raw, scriptable)'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand set' -a 'set' -d 'Set a value (auto-coerce types)'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand unset' -a 'unset' -d 'Remove a key (revert to default)'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand reset' -a 'reset' -d 'Reset configuration to defaults'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand edit' -a 'edit' -d 'Open config in \$EDITOR'
complete -c openspec -n '__fish_openspec_using_subcommand config; and not __fish_openspec_using_subcommand profile' -a 'profile' -d 'Configure workflow profile (interactive picker or preset shortcut)'

complete -c openspec -n '__fish_openspec_using_subcommand config' -l scope -a 'global' -d 'Config scope (only "global" supported currently)'
# config path flags
# config list flags
complete -c openspec -n '__fish_openspec_using_subcommand config; and __fish_openspec_using_subcommand list' -l json -d 'Output as JSON'
# config get flags
# config set flags
complete -c openspec -n '__fish_openspec_using_subcommand config; and __fish_openspec_using_subcommand set' -l string -d 'Force value to be stored as string'
complete -c openspec -n '__fish_openspec_using_subcommand config; and __fish_openspec_using_subcommand set' -l allow-unknown -d 'Allow setting unknown keys'
# config unset flags
# config reset flags
complete -c openspec -n '__fish_openspec_using_subcommand config; and __fish_openspec_using_subcommand reset' -l all -d 'Reset all configuration (required)'
complete -c openspec -n '__fish_openspec_using_subcommand config; and __fish_openspec_using_subcommand reset' -s y -l yes -d 'Skip confirmation prompts'
# config edit flags
# config profile flags

complete -c openspec -n '__fish_openspec_using_subcommand schema; and not __fish_openspec_using_subcommand which' -a 'which' -d 'Show where a schema resolves from'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and not __fish_openspec_using_subcommand validate' -a 'validate' -d 'Validate a schema structure and templates'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and not __fish_openspec_using_subcommand fork' -a 'fork' -d 'Copy an existing schema to project for customization'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and not __fish_openspec_using_subcommand init' -a 'init' -d 'Create a new project-local schema'

# schema which flags
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand which' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand which' -l all -d 'List all schemas with their resolution sources'
# schema validate flags
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand validate' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand validate' -l verbose -d 'Show detailed validation steps'
# schema fork flags
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand fork' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand fork' -l force -d 'Overwrite existing destination'
# schema init flags
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand init' -l json -d 'Output as JSON'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand init' -l description -r -d 'Schema description'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand init' -l artifacts -r -d 'Comma-separated artifact IDs'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand init' -l default -d 'Set as project default schema'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand init' -l no-default -d 'Do not prompt to set as default'
complete -c openspec -n '__fish_openspec_using_subcommand schema; and __fish_openspec_using_subcommand init' -l force -d 'Overwrite existing schema'
