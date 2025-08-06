# Zsh Troll Themer - Version 1.0.0
# A dynamic, humorous Vietnamese developer-focused Zsh theme
# Repository: https://github.com/iZuminnnn/troll-theme

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
ZSHRC_VERSION="1.0.0"
THEME_NAME="Zsh Troll Themer"
troll_colors=(91 92 93 94 95 96) # red green yellow blue magenta cyan

# Language system
typeset -A MESSAGES  # Associative array to store messages

# Ensure .troll_themer directory exists
[[ ! -d "$HOME/.troll_themer" ]] && mkdir -p "$HOME/.troll_themer"
[[ ! -d "$HOME/.troll_themer/lang" ]] && mkdir -p "$HOME/.troll_themer/lang"

# Load language configuration
load_language_config() {
    local config_file="$HOME/.troll_themer/config"
    local lang="vi"  # default language
    
    # Create default config file if it doesn't exist
    if [[ ! -f "$config_file" ]]; then
        cat > "$config_file" << 'EOF'
# Configuration file for Zsh Troll Themer
# Set your preferred language here

# Available languages: vi (Vietnamese), en (English)
# Default language if not set or file not found: vi
TROLL_LANG="vi"

# You can also set this via environment variable:
# export TROLL_LANG="en"
EOF
    fi
    
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
    
    # Create default Vietnamese language file if it doesn't exist
    if [[ ! -f "$lang_file" ]]; then
        cat > "$lang_file" << 'EOF'
# Vietnamese Language Pack for Zsh Troll Themer
# Format: category:message

welcome:🎉 Welcome to $THEME_NAME! Chúc người đẹp một ngày mới tràn đầy năng lượng nhé! Happy coding😘
update_disabled:Tính năng cập nhật sẽ được kích hoạt sau khi repository được đổi tên.
update_repo:Repository mới: https://github.com/iZuminnnn/troll-theme

overtime:Muộn rồi đó má! Code ít thôi, về đi kẻo người ta chờ cơm nguội bây giờ!
overtime:Giờ này còn ngồi code chi nữa? Công ty có bao cổ phần đâu mà cống hiến dữ vậy!
overtime:Về đi chứ! Bug thì fix hoài không hết, nhưng thanh xuân mà hết rồi là khỏi fix!

hour_00:Giờ này còn thức làm gì đấy? Định hẹn hò với bug xuyên đêm à?
hour_08:Cà phê sáng chưa? Hay vẫn đang nạp caffeine bằng stackoverflow?
hour_12:Ăn trưa chưa? Hay lại định sống bằng niềm tin vào deadline?
hour_18:Giờ này dev đang code hay đang nhậu?
hour_22:Giờ này vẫn còn cày à? Tí nữa ngủ luôn trên bàn phím cho coi!
hour_other:Giờ giấc kỳ lạ quá! Không biết gọi là sáng, trưa, chiều hay tối nữa!

cmd_git_commit:Commit xong rồi thì nhớ push người đẹp!
cmd_git_push:Push thành công rồi, nghỉ xíu uống miếng nước người đẹp!
cmd_python:Python thần thánh, chạy thử coi output đẹp chưa người đẹp!
cmd_ls:Danh sách file đây, cần gì cứ gọi anh người đẹp!
EOF
    fi
    
    if [[ -f "$lang_file" ]]; then
        while IFS=':' read -r key value; do
            # Skip comments and empty lines
            [[ "$key" =~ ^#.*$ || -z "$key" ]] && continue
            # Remove quotes from key and trim whitespace
            key="${key//\"/}"
            key="${key// /}"
            value="${value# }"
            MESSAGES[$key]="$value"
        done < "$lang_file"
    fi
}

# Get message by key
get_message() {
    local key="$1"
    local default_msg="${2:-}"
    echo "${MESSAGES[$key]:-$default_msg}"
}

# Get random message from category
get_random_message() {
    local category="$1"
    local messages=()
    local key
    
    # Collect all messages from the category
    for key in "${(@k)MESSAGES}"; do
        if [[ "$key" == "$category" ]]; then
            messages+=("${MESSAGES[$key]}")
        fi
    done
    
    # Return random message
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
    local ping_cmd
    case "$OSTYPE" in
        darwin*|linux-gnu*)
            # macOS or Linux
            ping -c 1 github.com >/dev/null 2>&1
            ;;
        msys*|cygwin*)
            # Windows
            ping -n 1 github.com >/dev/null 2>&1
            ;;
        *)
            # For other systems, try curl
            curl --connect-timeout 2 -s https://github.com >/dev/null 2>&1
            ;;
    esac
    return $?
}


# Function to check for and download zshrc updates
update_zshrc() {
    if ! check_internet; then
        echo -e "\e[91m Can't connect to the network. Please try again later.\e[0m"
        return 1
    fi
    
    # Get remote version
    local remote_version=$(curl -s https://raw.githubusercontent.com/iZuminnnn/zsh-theme/main/version.txt 2>/dev/null)
    if [[ -z "$remote_version" ]]; then
        echo -e "\e[91mUnable to download version information.\e[0m"
        return 1
    fi
    
    # Compare versions (simple string comparison)
    if [[ "$remote_version" != "$ZSHRC_VERSION" ]]; then
        echo -e "\e[92mNew version has been discovered: $remote_version (Present: $ZSHRC_VERSION)\e[0m"
        echo -e "Download update ..."
        
        # Backup current file
        cp ~/.zshrc ~/.zshrc.backup
        
        # Download new version
        if curl -s -o ~/.zshrc https://raw.githubusercontent.com/iZuminnnn/zsh-theme/main/.zshrc; then
            echo -e "\e[92mSuccess update! Backed the old version at ~/.zshrc.backup\e[0m"
            echo -e "Restart Shell to apply changes, or run: source ~/.zshrc"
        else
            echo -e "\e[91mUpdate failure. Please try again later.\e[0m"
            # Restore backup
            cp ~/.zshrc.backup ~/.zshrc
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
    timer=$(( $(date +%s%0N) / 1000000 ))
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
    PS1="%F{green}╭─$(time_icon) %F{cyan}%n@%m %F{magenta}%~%f $(venv_info) $(git_info) %F{red}~ %D{%H:%M:%S}%f
%F{green}╰─➜  %f"
    
    if [[ -n $timer ]]; then
        local now=$(( $(date +%s%0N) / 1000000 ))
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
    # Only show troll message if not in serious mode
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
  
  # Display welcome message directly without using get_message to avoid circular dependency
  echo -e "\e[93m🎉 Welcome to $THEME_NAME! Happy coding! 😘\e[0m"
  # Get last update check time
  LAST_UPDATE_CHECK_FILE="$HOME/.troll_themer/update"
  LAST_CHECK=0
  [[ -f "$LAST_UPDATE_CHECK_FILE" ]] && LAST_CHECK=$(cat "$LAST_UPDATE_CHECK_FILE")
  
  CURRENT_DATE=$(date +%Y-%m-%d)
  # Check if the date has changed
  if [[ "$CURRENT_DATE" != "$LAST_CHECK" ]]; then
    # remove .zsh_update_check file
    rm -f .zsh_update_check
    # Display welcome message
    echo -e "\e[93m$(get_message welcome)\e[0m"
    # Update timestamp first to prevent frequent checks
    echo "$CURRENT_DATE" > "$LAST_UPDATE_CHECK_FILE"
    # Check for updates first
    update_zshrc
  fi
  
  # Display WSL info and troll message
  detect_wsl
  troll_by_time true
} 

# Call initialization only if this is an interactive shell
[[ $- == *i* ]] && init_theme
