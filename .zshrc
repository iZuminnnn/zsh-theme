# Zsh Buddy Theme - Version 1.0.1
# A dynamic, humorous Vietnamese developer-focused Zsh theme
# Repository: https://github.com/hieudnm/zsh-buddy-theme

if [[ "$PAGER" == "head -n 10000 | cat" || "$COMPOSER_NO_INTERACTION" == "1" ]]; then
  return
fi

# History configuration
HISTFILE=$HOME/.zhistory
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY        # Append to history instead of overwriting
setopt SHARE_HISTORY         # Share history between sessions
setopt HIST_EXPIRE_DUPS_FIRST # Remove duplicates first when history file is full
setopt HIST_VERIFY           # Show command with history expansion before running it
setopt HIST_REDUCE_BLANKS    # Remove unnecessary blanks
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt HIST_NO_STORE         # Don't store history commands
setopt HIST_NO_FUNCTIONS     # Don't store function definitions
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicate entries
setopt HIST_FIND_NO_DUPS     # Don't display duplicates when searching
setopt HIST_SAVE_BY_COPY     # Save history by copying instead of moving
setopt HIST_FCNTL_LOCK       # Use file locking for history file

# Aliases for manual updates
alias update-zsh="source ~/.zshrc"
alias update="update_zshrc"
alias update-history="fc -R"  # Reload history from file

# Version for update checking
ZSHRC_VERSION="1.1.0"
THEME_NAME="Zsh Buddy Theme"
troll_colors=(91 92 93 94 95 96) # red green yellow blue magenta cyan

# Detect nanosecond support (GNU date has %N, macOS BSD date does not)
_zbt_has_nanoseconds=false
if [[ "$(date +%N 2>/dev/null)" != "%N" && "$(date +%N 2>/dev/null)" != "N" ]]; then
    _zbt_has_nanoseconds=true
fi

_zbt_timer_now() {
    if [[ "$_zbt_has_nanoseconds" == true ]]; then
        echo $(( $(date +%s%0N) / 1000000 ))
    else
        echo $(( $(date +%s) * 1000 ))
    fi
}

# Language system
typeset -A MESSAGES  # Associative array to store messages

# Ensure .troll_themer directory exists
[[ ! -d "$HOME/.troll_themer" ]] && mkdir -p "$HOME/.troll_themer"
[[ ! -d "$HOME/.troll_themer/lang" ]] && mkdir -p "$HOME/.troll_themer/lang"

# Load language configuration
load_language_config() {
    local config_file="$HOME/.troll_themer/config"
    local lang="vi"  # default language
    
    # Check environment variable first
    if [[ -n "$TROLL_LANG" ]]; then
        lang="$TROLL_LANG"
    # Then check config file
    elif [[ -f "$config_file" ]]; then
        lang=$(grep "^TROLL_LANG=" "$config_file" | cut -d'"' -f2)
        [[ -z "$lang" ]] && lang="vi"
    fi
    
    echo "$lang"
}

# Load messages from language file
load_messages() {
    local lang="${1:-vi}"
    local lang_file="$HOME/.troll_themer/lang/${lang}.txt"
    
    # Clear existing messages
    MESSAGES=()
    
    # Check if language file exists, fallback to Vietnamese
    if [[ ! -f "$lang_file" ]]; then
        lang_file="$HOME/.troll_themer/lang/vi.txt"
    fi
    
    if [[ ! -f "$lang_file" ]]; then
        echo -e "\e[91m⚠️  Language file not found: ${lang_file}\e[0m"
        echo -e "\e[93mRun 'update' to download language files.\e[0m"
        return
    fi

    if [[ -f "$lang_file" ]]; then
        local -A key_counts
        local store_key
        while IFS=':' read -r key value; do
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            key="${key//\"/}"
            key="${key// /}"
            value="${value# }"
            if [[ -n "${key_counts[$key]+x}" ]]; then
                key_counts[$key]=$((key_counts[$key] + 1))
                store_key="${key}_${key_counts[$key]}"
                MESSAGES[$store_key]="$value"
            else
                key_counts[$key]=0
                MESSAGES[$key]="$value"
            fi
        done < "$lang_file"
    fi
}

# Get message by key (returns first match for exact key)
get_message() {
    local key="$1"
    local default_msg="${2:-}"
    echo "${MESSAGES[$key]:-$default_msg}"
}

# Get random message from category (collects all entries with same prefix)
get_random_message() {
    local category="$1"
    local messages=()
    local key

    for key in "${(@k)MESSAGES}"; do
        if [[ "$key" == "$category" || "$key" == "${category}_"* ]]; then
            messages+=("${MESSAGES[$key]}")
        fi
    done

    if (( ${#messages[@]} > 0 )); then
        echo "${messages[$((RANDOM % ${#messages[@]} + 1))]}"
    fi
}

# Initialize language system
CURRENT_LANG=$(load_language_config)
load_messages "$CURRENT_LANG"

# Function to detect WSL
detect_wsl() {
    if [[ -n "$MSYSTEM" ]]; then
        echo -e "\e[91m🖥️  Windows (Git Bash)\e[0m"
    elif [[ -f /proc/version ]]; then
        if grep -qi microsoft /proc/version; then
            echo -e "\e[93m🐧 WSL\e[0m"
        else
            echo -e "\e[92m🐧 Linux\e[0m"
        fi
    else
        case "$OSTYPE" in
            darwin*) echo -e "\e[94m🍎 macOS\e[0m" ;;
            msys*|cygwin*) echo -e "\e[91m🪟 Windows\e[0m" ;;
            *) echo -e "\e[90m❓ Unknown\e[0m" ;;
        esac
    fi
}


# Time-based troll optimization
troll_by_time() {
    local hour=$(date +%H)
    local minute=$(date +%M)
    
    # Set seed for RANDOM based on current time (seconds from epoch)
    RANDOM=$(date +%s)  # Use seconds from epoch as seed
    
    local random_color=${troll_colors[$((RANDOM % ${#troll_colors[@]}))]}
    local message
    local chance=$((RANDOM % 100))
    # Check if within 17:30-18:30
    local force_show=${1:-false}
    local force_show_by_time=false
    if [[ ("$hour" == 17 && "$minute" -ge 30) || ("$hour" == 18 && "$minute" -le 30) ]]; then
        force_show_by_time=true
    fi

    # Always show message when calling function (removed 10% probability logic for easier testing)
    if [[ "$force_show_by_time" == true ]]; then
        message=$(get_random_message "overtime")
    elif (( chance < 10 )) || [[ "$force_show" == true ]]; then
        case $hour in
            00|01) message=$(get_random_message "hour_00") ;;
            02|03) message=$(get_random_message "hour_02") ;;
            04|05) message=$(get_random_message "hour_04") ;;
            06|07) message=$(get_random_message "hour_06") ;;
            08|09) message=$(get_random_message "hour_08") ;;
            10|11) message=$(get_random_message "hour_10") ;;
            12|13) message=$(get_random_message "hour_12") ;;
            14|15) message=$(get_random_message "hour_14") ;;
            16|17) message=$(get_random_message "hour_16") ;;
            18|19) message=$(get_random_message "hour_18") ;;
            20|21) message=$(get_random_message "hour_20") ;;
            22|23) message=$(get_random_message "hour_22") ;;
            *) message=$(get_message "hour_other") ;;
        esac
    fi
    
    if [[ -n "$message" ]]; then
        echo -e "\e[95m${message}\e[0m"
    fi
}


# Optimized troll command
troll_cmd() {
    local cmd="$1" message color
    case "$cmd" in
        *git\ commit*) message=$(get_message "cmd_git_commit") color=93 ;;
        *git\ push*) message=$(get_message "cmd_git_push") color=94 ;;
        *git\ st*|*git\ status*) message=$(get_message "cmd_git_status") color=92 ;;
        *git\ pull*) message=$(get_message "cmd_git_pull") color=91 ;;
        *git\ merge*) message=$(get_message "cmd_git_merge") color=95 ;;
        *git\ rebase*) message=$(get_message "cmd_git_rebase") color=96 ;;
        *git\ log*) message=$(get_message "cmd_git_log") color=93 ;;
        *git\ diff*) message=$(get_message "cmd_git_diff") color=92 ;;
        *git\ reset*) message=$(get_message "cmd_git_reset") color=91 ;;
        *git\ cherry-pick*) message=$(get_message "cmd_git_cherry_pick") color=95 ;;
        *python*) message=$(get_message "cmd_python") color=95 ;;
        *pip*) message=$(get_message "cmd_pip") color=92 ;;
        *npm\ install*) message=$(get_message "cmd_npm_install") color=91 ;;
        *npm\ start*) message=$(get_message "cmd_npm_start") color=94 ;;
        *npm\ run\ build*) message=$(get_message "cmd_npm_build") color=95 ;;
        *yarn*) message=$(get_message "cmd_yarn") color=93 ;;
        *rm\ -rf*) message=$(get_message "cmd_rm") color=96 ;;
        *mv*) message=$(get_message "cmd_mv") color=92 ;;
        *cp*) message=$(get_message "cmd_cp") color=94 ;;
        *cd*) message=$(get_message "cmd_cd") color=93 ;;
        *ls*) message=$(get_message "cmd_ls") color=92 ;;
        *cat*) message=$(get_message "cmd_cat") color=94 ;;
        *vim*) message=$(get_message "cmd_vim") color=91 ;;
        *nano*) message=$(get_message "cmd_nano") color=95 ;;
        *docker\ build*) message=$(get_message "cmd_docker_build") color=94 ;;
        *docker\ run*) message=$(get_message "cmd_docker_run") color=95 ;;
        *docker\ ps*) message=$(get_message "cmd_docker_ps") color=92 ;;
        *docker\ stop*) message=$(get_message "cmd_docker_stop") color=91 ;;
        *sudo*) message=$(get_message "cmd_sudo") color=91 ;;
        *chmod*) message=$(get_message "cmd_chmod") color=93 ;;
        *chown*) message=$(get_message "cmd_chown") color=94 ;;
        *scp*) message=$(get_message "cmd_scp") color=92 ;;
        *rsync*) message=$(get_message "cmd_rsync") color=95 ;;
        *kill*) message=$(get_message "cmd_kill") color=91 ;;
        *ps\ aux*) message=$(get_message "cmd_ps") color=93 ;;
        *htop*) message=$(get_message "cmd_htop") color=94 ;;
        *df\ -h*) message=$(get_message "cmd_df") color=92 ;;
        *free\ -m*) message=$(get_message "cmd_free") color=95 ;;
        *whoami*) message=$(get_message "cmd_whoami") color=96 ;;
        *date*) message=$(get_message "cmd_date") color=91 ;;
        *uptime*) message=$(get_message "cmd_uptime") color=94 ;;
        *reboot*) message=$(get_message "cmd_reboot") color=93 ;;
        *shutdown*) message=$(get_message "cmd_shutdown") color=92 ;;
        *) return ;;
    esac
    [[ -n "$message" ]] && echo -e "\e[${color}m${message}\e[0m"
}

# Information functions
venv_info() { [[ -n $VIRTUAL_ENV ]] && echo "\e[93m🐍 ($(basename $VIRTUAL_ENV))\e[0m"; }
git_info() {
    git rev-parse --is-inside-work-tree &>/dev/null || return
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git describe --tags --always)
    [[ -n $(git status --porcelain 2>/dev/null) ]] && echo "\e[91m🌟(${branch}*)\e[0m" || echo "\e[92m🌿(${branch})\e[0m"
}
time_icon() {
    case $(date +%H) in
        0[0-5]) echo "🌌" ;; 0[6-9]|1[0-1]) echo "🌞" ;;
        1[2-7]) echo "🌤️" ;; *) echo "🌙" ;;
    esac
}


check_internet() {
    curl --connect-timeout 3 -sf https://raw.githubusercontent.com >/dev/null 2>&1
}

# Compare semver versions. Returns 0 if $1 > $2
version_gt() {
    local v1=(${(s:.:)1})
    local v2=(${(s:.:)2})
    local i
    for i in 1 2 3; do
        if (( ${v1[$i]:-0} > ${v2[$i]:-0} )); then
            return 0
        elif (( ${v1[$i]:-0} < ${v2[$i]:-0} )); then
            return 1
        fi
    done
    return 1
}

# Function to check for and download zshrc updates
update_zshrc() {
    if ! check_internet; then
        echo -e "\e[91m Can't connect to the network. Please try again later.\e[0m"
        return 1
    fi
    
    # Get remote version
    local remote_version=$(curl -sf --connect-timeout 5 https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/version.txt 2>/dev/null)
    if [[ -z "$remote_version" ]]; then
        echo -e "\e[91mUnable to download version information.\e[0m"
        return 1
    fi

    # Validate version format (e.g. 1.0.0, 2.1.3)
    if [[ ! "$remote_version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo -e "\e[91mInvalid version format received: $remote_version\e[0m"
        return 1
    fi
    
    # Compare versions using semver (only update if remote > local)
    if version_gt "$remote_version" "$ZSHRC_VERSION"; then
        echo -e "\e[92mNew version available: $remote_version (Current: $ZSHRC_VERSION)\e[0m"
        echo -e "Downloading update..."
        
        # Backup current files
        cp ~/.zshrc ~/.zshrc.backup
        echo -e "\e[93m📦 Backed up .zshrc to ~/.zshrc.backup\e[0m"
        
        if [[ -d "$HOME/.troll_themer" ]]; then
            cp -r "$HOME/.troll_themer" "$HOME/.troll_themer.backup"
            echo -e "\e[93m📦 Backed up .troll_themer to ~/.troll_themer.backup\e[0m"
        else
            echo -e "\e[94m📁 .troll_themer folder not found - will create new one\e[0m"
        fi
        
        # Extract user's custom config (everything after ZSH_BUDDY_THEME_END marker)
        local user_config=""
        if grep -q "ZSH_BUDDY_THEME_END" ~/.zshrc; then
            user_config=$(sed -n '/^# === ZSH_BUDDY_THEME_END ===/,$ p' ~/.zshrc | tail -n +2 | sed '/^# Everything below this line/d; /^# Add your custom PATH/d')
        fi

        # Preserve user's language setting
        local user_lang=""
        if [[ -f "$HOME/.troll_themer/config" ]]; then
            user_lang=$(grep '^TROLL_LANG=' "$HOME/.troll_themer/config" | tail -1 | cut -d'"' -f2)
        fi

        # Download ALL files to temp dir first (atomic)
        local tmp_dir=$(mktemp -d)
        local download_ok=true
        
        echo -e "\e[96m📥 Downloading update files...\e[0m"
        
        curl -sf -o "$tmp_dir/zshrc" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.zshrc || download_ok=false
        curl -sf -o "$tmp_dir/config" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.troll_themer/config || download_ok=false
        curl -sf -o "$tmp_dir/vi.txt" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.troll_themer/lang/vi.txt || download_ok=false
        curl -sf -o "$tmp_dir/en.txt" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.troll_themer/lang/en.txt || download_ok=false

        if [[ "$download_ok" == false ]]; then
            rm -rf "$tmp_dir"
            echo -e "\e[91m❌ Failed to download update files. Rolling back...\e[0m"
            cp ~/.zshrc.backup ~/.zshrc
            echo -e "\e[93m🔄 Restored .zshrc from backup\e[0m"
            if [[ -d "$HOME/.troll_themer.backup" ]]; then
                rm -rf "$HOME/.troll_themer"
                mv "$HOME/.troll_themer.backup" "$HOME/.troll_themer"
                echo -e "\e[93m🔄 Restored .troll_themer from backup\e[0m"
            fi
            echo -e "\e[91m❌ Update failed. All files have been restored to previous state.\e[0m"
            return 1
        fi

        # All files downloaded — apply update
        cp "$tmp_dir/zshrc" ~/.zshrc

        # Append user's custom config if it existed
        if [[ -n "$user_config" ]]; then
            printf '%s\n' "$user_config" >> ~/.zshrc
            echo -e "\e[92m✅ .zshrc updated! Your custom config has been preserved.\e[0m"
        else
            echo -e "\e[92m✅ .zshrc updated successfully!\e[0m"
        fi

        # Apply .troll_themer files
        mkdir -p "$HOME/.troll_themer/lang"
        cp "$tmp_dir/config" "$HOME/.troll_themer/config"
        cp "$tmp_dir/vi.txt" "$HOME/.troll_themer/lang/vi.txt"
        cp "$tmp_dir/en.txt" "$HOME/.troll_themer/lang/en.txt"

        # Restore user's language setting if it was customized
        if [[ -n "$user_lang" ]]; then
            local tmp_cfg=$(mktemp)
            sed "s/^TROLL_LANG=\".*\"/TROLL_LANG=\"$user_lang\"/" "$HOME/.troll_themer/config" > "$tmp_cfg" && mv "$tmp_cfg" "$HOME/.troll_themer/config"
        fi

        # Cleanup temp dir
        rm -rf "$tmp_dir"
        
        echo -e "\e[92m🎉 Update completed successfully!\e[0m"
        echo -e "\e[93m📦 Backups saved at ~/.zshrc.backup$([[ -d "$HOME/.troll_themer.backup" ]] && echo " and ~/.troll_themer.backup")\e[0m"
        echo -e "Restart Shell to apply changes, or run: source ~/.zshrc"
    else
        echo -e "\e[92m✅ You are already using the latest version ($ZSHRC_VERSION)\e[0m"
        
        # Check if .troll_themer folder exists and offer to repair if missing
        if [[ ! -d "$HOME/.troll_themer" ]]; then
            echo -e "\e[93m⚠️  .troll_themer folder is missing. Would you like to download it? (y/N)\e[0m"
            read -r response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                echo -e "\e[96m📥 Downloading .troll_themer configuration...\e[0m"
                mkdir -p "$HOME/.troll_themer/lang"
                curl -sf -o "$HOME/.troll_themer/config" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.troll_themer/config
                curl -sf -o "$HOME/.troll_themer/lang/vi.txt" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.troll_themer/lang/vi.txt
                curl -sf -o "$HOME/.troll_themer/lang/en.txt" https://raw.githubusercontent.com/hieudnm/zsh-buddy-theme/main/.troll_themer/lang/en.txt
                echo -e "\e[92m✅ .troll_themer folder downloaded successfully!\e[0m"
                echo -e "Run: source ~/.zshrc to reload configuration"
            fi
        fi
    fi
}

# Add alias for easier updating
alias update-zshrc="update_zshrc"
last_troll_time=0
troll_interval=$((5 * 60))  # 5 minutes

# Mode management - Serious mode to disable trolling temporarily
check_serious_mode() {
    [[ "$TROLL_MODE" == "serious" || "$MODE" == "serious" ]]
}

# Aliases for mode switching
alias serious="export TROLL_MODE=serious && echo -e '\e[93m🔇 Serious mode activated. Trolling disabled.\e[0m'"
alias troll="unset TROLL_MODE && echo -e '\e[95m🎭 Troll mode activated. Let the fun begin!\e[0m'"
alias mode-status="[[ -n \$TROLL_MODE ]] && echo -e '\e[93mCurrent mode: \$TROLL_MODE\e[0m' || echo -e '\e[95mCurrent mode: troll (default)\e[0m'"

# Prompt hooks

preexec() {
    timer=$(_zbt_timer_now)
    last_cmd="$1"

    # Skip trolling if in serious mode
    if check_serious_mode; then
        return
    fi

    # Call troll_by_time only after a certain time interval
    current_time=$(date +%s)
    if (( current_time - last_troll_time >= troll_interval )); then
        troll_time_message=$(troll_by_time)
        [[ -n "$troll_time_message" ]] && echo "$troll_time_message"
        last_troll_time=$current_time
    fi

    # Call troll_cmd
    troll_message=$(troll_cmd "$last_cmd")
    [[ -n "$troll_message" ]] && echo "$troll_message"
}

precmd() {
    PS1="%F{green}╭─$(time_icon)%f %F{red}%D{%H:%M:%S}%f %F{green}─%f %F{cyan}%n@%m %F{magenta}%~%f $(venv_info) $(git_info)
%F{green}╰─➜  %f"
    
    if [[ -n $timer ]]; then
        local now=$(_zbt_timer_now)
        RPROMPT="%F{cyan}[$((now-timer))ms]%f"
        unset timer
    fi
    
    # Remove cpu_troll because it's time-consuming to process
    unset last_cmd
}

# Custom clear function
my_clear() {
    command clear
    detect_wsl
    echo -e "\e[93m$(get_message welcome)\e[0m"
    echo -e "\e[95m$(get_message tip_mode)\e[0m"
    if ! check_serious_mode; then
        troll_by_time true
    fi
}

# Final configuration
autoload -U colors && colors

alias clear="my_clear"
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[5~' history-search-backward
bindkey '^[[6~' history-search-forward
bindkey '^[[A' up-line-or-search
bindkey '\C-h' backward-kill-word
# Quick delete entire line (before and after cursor)
bindkey '^U' backward-kill-line  # Ctrl + U: Delete from cursor to beginning of line  
bindkey '^K' kill-line           # Ctrl + K: Delete from cursor to end of line 
# Move to beginning/end of line  
bindkey '^[a' beginning-of-line   # Alt + A: Jump to beginning of line  
bindkey '^[e' end-of-line         # Alt + E: Jump to end of line  

# Loading zsh-autosuggestions
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Initialization - check update first, then display quotes
init_theme() {
  # Skip welcome messages if in serious mode
  if check_serious_mode; then
    return
  fi
  
  # Get last update check time
  LAST_UPDATE_CHECK_FILE="$HOME/.troll_themer/update"
  LAST_CHECK=0
  [[ -f "$LAST_UPDATE_CHECK_FILE" ]] && LAST_CHECK=$(cat "$LAST_UPDATE_CHECK_FILE")
  
  CURRENT_DATE=$(date +%Y-%m-%d)
  # Check if the date has changed
  if [[ "$CURRENT_DATE" != "$LAST_CHECK" ]]; then
    # remove .zsh_update_check file from home directory
    rm -f "$HOME/.zsh_update_check"
    
    # check and create .troll_themer directory structure if needed
    if [[ ! -d "$HOME/.troll_themer/lang" ]]; then
      mkdir -p "$HOME/.troll_themer/lang"
    fi
    
    # check if required language files exist, create empty files if missing
    if [[ ! -f "$HOME/.troll_themer/lang/vi.txt" ]]; then
      touch "$HOME/.troll_themer/lang/vi.txt"
    fi
    if [[ ! -f "$HOME/.troll_themer/lang/en.txt" ]]; then
      touch "$HOME/.troll_themer/lang/en.txt"
    fi
    
    # Display welcome message
    echo -e "\e[93m$(get_message welcome)\e[0m"
    # Update timestamp first to prevent frequent checks
    echo "$CURRENT_DATE" > "$LAST_UPDATE_CHECK_FILE"
    # Check for updates first
    update_zshrc
  else
    echo -e "\e[93m$(get_message welcome)\e[0m"
    echo -e "\e[95m$(get_message tip_mode)\e[0m"
  fi
  
  # Display WSL info and troll message
  detect_wsl
  troll_by_time true
} 

# Call initialization only if this is an interactive shell
[[ $- == *i* ]] && init_theme

# === ZSH_BUDDY_THEME_END ===
# Everything below this line is preserved during theme updates.
# Add your custom PATH, aliases, exports, and other config here.
