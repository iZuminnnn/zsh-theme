# Testing zsh-theme

## Overview
This project is a zsh theme (`.zshrc`) with a message system using associative arrays (`typeset -A MESSAGES`). It loads messages from language files (`.troll_themer/lang/vi.txt` and `en.txt`) and displays them contextually (overtime warnings, hourly messages, welcome, tips).

## Environment Setup

1. **Install zsh** (if not present):
   ```bash
   sudo apt-get install -y zsh
   ```

2. **Copy language files** to the expected location:
   ```bash
   mkdir -p $HOME/.troll_themer/lang/
   cp .troll_themer/lang/*.txt $HOME/.troll_themer/lang/
   ```

3. **Language config**: The theme reads `$HOME/.troll_themer/lang/config` for the active language (default: `vi`). If this file doesn't exist, it creates one with default values.

## Testing Approach

All testing is **shell-based** (no GUI/browser needed). Write test scripts in zsh that source the `.zshrc` with guards removed.

### Sourcing .zshrc for Testing

The `.zshrc` has auto-execution code (lines that call `init_theme`, set terminal title, etc.) that should be stripped before sourcing in a test:

```bash
# Create a cleaned version for testing
sed '5,7d' /path/to/.zshrc > /tmp/test_zshrc.zsh
# Also remove the init_theme call at the end
sed -i '/^init_theme$/d' /tmp/test_zshrc.zsh
source /tmp/test_zshrc.zsh
```

**Do NOT** try to extract individual functions with `sed` patterns like `/^function_name/,/^}/p` — this breaks on nested `{` `}` inside if/while blocks and will silently truncate the function.

### Key Test Cases

1. **Duplicate key storage** (Critical): `load_messages()` uses counter suffixes for duplicate keys (`overtime`, `overtime_1`, `overtime_2`, ...). Verify the count matches the language file.
2. **Random message selection**: `get_random_message(category)` should return varied results across multiple calls.
3. **Single-key messages**: `get_message(key)` for unique keys like `welcome`, `tip_mode` should return exact values.
4. **Missing file handling**: When language file doesn't exist, should print error with "Language file not found" and suggest "update".
5. **Structure**: Font at `.troll_themer/font/`, no `font/` at root, `.gitignore` is minimal.

### Counting Keys by Category

```zsh
# Count all keys matching a prefix
local count=0
for key in "${(@k)MESSAGES}"; do
    if [[ "$key" == "overtime" || "$key" == "overtime_"* ]]; then
        ((count++))
    fi
done
```

## Known Gotchas

### Zsh Associative Array Key Quoting
When assigning to an associative array with a computed key, **do NOT** use quotes around the variable expansion inside brackets:

```zsh
# BAD - stores key with literal quotes: '"overtime_1"'
MESSAGES["${key}_${count}"]="$value"

# GOOD - use intermediate variable
local store_key="${key}_${count}"
MESSAGES[$store_key]="$value"
```

This is a zsh-specific behavior that might not manifest in bash.

### Language File Format
Lines in language files use `key:value` format. Comments start with `#`. Keys might have spaces or quotes that need stripping. The `load_messages()` function handles this with parameter expansion.

## Devin Secrets Needed
None — this project requires no external credentials for testing.

## No Recording Needed
All testing is done via shell commands. Screen recording is not useful since there are no GUI interactions to capture.
