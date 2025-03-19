setopt APPEND_HISTORY
setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST
setopt EXTENDED_HISTORY
# Version for update checking
ZSHRC_VERSION="0.0.4"

# Danh sách quotes và màu sắc
troll_quotes=(
	"Đã code gì chưa hay vẫn copy-paste người đẹp?"
	"Đã debug gì chưa hay đổ lỗi cho intern người đẹp?"
	"Đã commit gì chưa hay để git blame người đẹp?"
	"Đã fix bug gì chưa hay thêm bug mới người đẹp?"
	"Đã push gì chưa hay sợ CI fail người đẹp?"
	"Đã pull request gì chưa hay chờ merge conflict người đẹp?"
	"Đã refactor gì chưa hay code như hạch người đẹp?"
	"Đã unit test gì chưa hay cầu trời chạy người đẹp?"
	"Đã deploy gì chưa hay server crash người đẹp?"
	"Đã Stack Overflow gì chưa hay tự nghĩ người đẹp?"
	"Đã comment code gì chưa hay để người ta đoán người đẹp?"
	"Đã họp team gì chưa hay ngủ gật người đẹp?"
	"Đã deadline gì chưa hay vẫn nước đến chân người đẹp?"
	"Đã clean code gì chưa hay toàn spaghetti người đẹp?"
	"Đã học framework gì chưa hay vẫn console.log người đẹp?"
	"Đã hỏi ChatGPT gì chưa hay tự code người đẹp?"
	"Đã fix lỗi 404 gì chưa hay để 500 người đẹp?"
	"Đã overtime gì chưa hay 5h về người đẹp?"
	"Đã code review gì chưa hay toàn LGTM người đẹp?"
	"Đã production gì chưa hay vẫn localhost người đẹp?"
)
troll_colors=(91 92 93 94 95 96)

# Tối ưu troll theo thời gian
troll_by_time() {
    local hour=$(date +%H)
    local random_color=${troll_colors[RANDOM % ${#troll_colors[@]}]}
    local message
    case $hour in
        0[0-5]) message="Đã code gì chưa hay mắt còn cay giờ này người đẹp?" ;;
        0[6-9]|1[0-1]) message="Đã cà phê gì chưa hay vẫn gà gật người đẹp?" ;;
        1[2-7]) message="Đã deadline gì chưa hay vẫn chill người đẹp?" ;;
        *) message="Đã ngủ gì chưa hay ôm bug khuya người đẹp?" ;;
    esac
    echo "\e[${random_color}m${message}\e[0m"
}

# Tối ưu CPU troll
cpu_troll() {
    local cpu_usage num_cores
    case "$OSTYPE" in
        darwin*)
            cpu_usage=$(ps -A -o %cpu | awk 'NR>1{s+=$1} END{print int(s)}')
            num_cores=$(sysctl -n hw.ncpu)
            ;;
        linux-gnu*)
            cpu_usage=$(ps aux | awk '{s+=$3} END{print int(s)}')
            num_cores=$(nproc 2>/dev/null || echo 1)
            ;;
        msys*|cygwin*)
            cpu_usage=$(wmic cpu get LoadPercentage | awk 'NR==2{print $1}' 2>/dev/null || powershell -command "(Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples.CookedValue" 2>/dev/null)
            num_cores=$(wmic cpu get NumberOfCores | awk 'NR==2{print $1}' 2>/dev/null || powershell -command "(Get-WmiObject Win32_ComputerSystem).NumberOfLogicalProcessors" 2>/dev/null)
            ;;
        *) return ;;
    esac
    
    [[ -z "$cpu_usage" || -z "$num_cores" ]] && cpu_usage=0
    [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" ]] && cpu_usage=$((cpu_usage / num_cores))
    
    if ((cpu_usage > 70)); then
        local troll_cpu=(
            "Máy nóng thế, code gì mà căng vậy người đẹp?"
            "CPU đỏ rồi, nghỉ tay đi người đẹp!"
            "Code kiểu gì mà máy muốn nổ vậy người đẹp?"
            "70% CPU, chắc đào coin chứ code gì nổi người đẹp?"
        )
        echo -e "\e[92m${troll_cpu[RANDOM % ${#troll_cpu[@]}]}\e[0m"
    fi
}

# Tối ưu troll command
troll_cmd() {
    local cmd="$1" message color
    case "$cmd" in
        *git\ commit*) message="Commit xong rồi thì nhớ push người đẹp!" color=93 ;;
        *git\ push*) message="Push thành công rồi, nghỉ xíu uống miếng nước người đẹp!" color=94 ;;
        *git\ st*|*git\ status*) message="Check status hoài, nhìn thấy thành quả chưa người đẹp?" color=92 ;;
        *git\ pull*) message="Pull code về rồi, nhớ test kỹ người đẹp!" color=91 ;;
        *git\ merge*) message="Merge xong nhớ đọc log nha người đẹp!" color=95 ;;
        *git\ rebase*) message="Rebase xong nhìn lại lịch sử commit có đẹp không người đẹp?" color=96 ;;
        *git\ log*) message="Đọc log có thấy lỗi ai gây ra không người đẹp?" color=93 ;;
        *git\ diff*) message="Xem diff đi, có gì bất ngờ không người đẹp?" color=92 ;;
        *git\ reset*) message="Reset nhẹ tay thôi người đẹp, đừng để mất công sức nha!" color=91 ;;
        *git\ cherry-pick*) message="Chọn commit kỹ nha người đẹp, đừng pick nhầm drama!" color=95 ;;
        *python*) message="Python thần thánh, chạy thử coi output đẹp chưa người đẹp!" color=95 ;;
        *pip*) message="Pip install xong rồi, dependencies đủ chưa người đẹp?" color=92 ;;
        *npm\ install*) message="npm install xong rồi, nhớ chạy thử coi chạy mượt không người đẹp!" color=91 ;;
        *npm\ start*) message="Server khởi động rồi, kiểm tra UI chưa người đẹp?" color=94 ;;
        *npm\ run\ build*) message="Build xong, lên production chưa người đẹp?" color=95 ;;
        *yarn*) message="Dùng yarn à? Developer có gu nha người đẹp!" color=93 ;;
        *rm\ -rf*) message="Xóa xong nhớ kiểm tra, đừng để mất gì quan trọng nha người đẹp!" color=96 ;;
        *mv*) message="Di chuyển file cẩn thận nha người đẹp, đừng để mất dấu!" color=92 ;;
        *cp*) message="Copy xong nhớ check lại, đừng để thiếu người đẹp!" color=94 ;;
        *cd*) message="Đi đúng thư mục rồi chứ? Làm việc hiệu quả nha người đẹp!" color=93 ;;
        *ls*) message="Danh sách file đây, cần gì cứ gọi anh người đẹp!" color=92 ;;
        *cat*) message="Mở file ra rồi, đọc hiểu hết chưa người đẹp?" color=94 ;;
        *vim*) message="Vào Vim rồi, nhớ cách thoát chưa người đẹp? 😆" color=91 ;;
        *nano*) message="Dùng nano à? Gọn nhẹ dễ dùng nè người đẹp!" color=95 ;;
        *docker\ build*) message="Docker build xong rồi, giờ chạy thử nha người đẹp!" color=94 ;;
        *docker\ run*) message="Container chạy rồi, mở terminal check thử nha người đẹp!" color=95 ;;
        *docker\ ps*) message="Xem container kìa, có chạy mượt không người đẹp?" color=92 ;;
        *docker\ stop*) message="Dừng container rồi, có định bật lại không người đẹp?" color=91 ;;
        *sudo*) message="Sudo thần thánh, cẩn thận quyền lực tối cao nha người đẹp!" color=91 ;;
        *chmod*) message="Set quyền xong rồi, test lại nha người đẹp!" color=93 ;;
        *chown*) message="Chuyển quyền sở hữu rồi, có đúng chủ chưa người đẹp?" color=94 ;;
        *scp*) message="Chuyển file qua SSH nè, hy vọng nhanh gọn người đẹp!" color=92 ;;
        *rsync*) message="Đồng bộ file rồi, đừng để thiếu gì nha người đẹp!" color=95 ;;
        *kill*) message="Kill process rồi, có chắc nó không chạy lại không người đẹp?" color=91 ;;
        *ps\ aux*) message="Danh sách process đây, tìm thủ phạm ngốn CPU chưa người đẹp?" color=93 ;;
        *htop*) message="Mở htop rồi, nhìn load CPU có xanh mặt không người đẹp?" color=94 ;;
        *df\ -h*) message="Check disk xong, có cần dọn rác không người đẹp?" color=92 ;;
        *free\ -m*) message="Xem RAM còn đủ sống không người đẹp?" color=95 ;;
        *whoami*) message="Là ai? Là chính mình chứ ai nữa người đẹp!" color=96 ;;
        *date*) message="Giờ này còn code à? Nghỉ ngơi chút đi người đẹp!" color=91 ;;
        *uptime*) message="Máy chạy lâu chưa? Có cần restart không người đẹp?" color=94 ;;
        *reboot*) message="Restart máy à? Hít thở sâu rồi hãy nhấn Enter người đẹp!" color=93 ;;
        *shutdown*) message="Tắt máy thật hả? Ghi nhớ commit xong chưa người đẹp?" color=92 ;;
        *) return ;;
    esac
    echo -e "\e[${color}m${message}\e[0m"
}

# Các hàm thông tin
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

# Function to check internet connection
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

# Tối ưu weather
typeset -g last_weather_update=0 cached_weather_icon="🌍 ?°C"
weather_icon() {
    local current_time=$(date +%s)
    # Only update if it's been more than 5 minutes and we have internet
    if ((current_time - last_weather_update >= 300)) && check_internet; then
		local weather_data=$(curl -s "wttr.in?format=%C+%t&location=hanoi&lang=en" 2>/dev/null || echo "unknown+?°C")
		local weather=$(echo "$weather_data" | cut -d' ' -f1)
		local temp=$(echo "$weather_data" | cut -d'+' -f2)
        cached_weather_icon=$(
            case "$weather" in
				"Sunny") echo "\e[93m☀️ Nắng đẹp, ra ngoài hít drama đi! ${temp}\e[0m" ;;
				"Clear") echo "\e[33m🌞 Trời trong, tâm hồn cũng nên thế! ${temp}\e[0m" ;;
				"Partly cloudy") echo "\e[37m⛅ Trời nửa nắng nửa mơ màng! ${temp}\e[0m" ;;
				"Cloudy") echo "\e[90m☁️ Trời âm u như deadline gần kề! ${temp}\e[0m" ;;
				"Overcast") echo "\e[90m🌥️ U ám quá, pha trà ngồi chill đi! ${temp}\e[0m" ;;
				"Mist"|"Fog") echo "\e[37m🌫️ Sương mù, cẩn thận lạc lối! ${temp}\e[0m" ;;
				"Light rain"|"Drizzle") echo "\e[94m🌦️ Mưa lất phất, lãng mạn ghê! ${temp}\e[0m" ;;
				"Rain"|"Shower"|"Moderate rain") echo "\e[94m🌧️ Mưa rồi, ở nhà code thôi! ${temp}\e[0m" ;;
				"Heavy rain"|"Heavy shower") echo "\e[34m⛈️ Mưa to, trùm chăn ngủ tiếp! ${temp}\e[0m" ;;
				"Thunderstorm"|"Thundery") echo "\e[34m🌩️ Sấm chớp, đừng ra ngoài nhé! ${temp}\e[0m" ;;
				"Snow") echo "\e[97m❄️ Tuyết rơi, mơ về Đà Lạt à? ${temp}\e[0m" ;;
				"Light snow"|"Snow shower") echo "\e[97m🌨️ Tuyết nhẹ, lạnh mà vui! ${temp}\e[0m" ;;
				"Hail") echo "\e[96m🌧️❄️ Mưa đá, trốn trong nhà thôi! ${temp}\e[0m" ;;
				"Sleet") echo "\e[96m🌧️🌨️ Mưa tuyết, thời tiết kỳ lạ thật! ${temp}\e[0m" ;;
				*) echo "\e[32m🌍 Trời gì mà lạ thế không biết! ${temp}\e[0m" ;;
            esac
        )
        last_weather_update=$current_time
    elif ! check_internet && ((current_time - last_weather_update >= 1800)); then
        # If no internet for 30 minutes, show offline message
        cached_weather_icon="\e[90m📵 Không có kết nối mạng để cập nhật thời tiết\e[0m"
        last_weather_update=$current_time
    fi
    echo -e "$cached_weather_icon"
}

# Function to check for and download zshrc updates
update_zshrc() {
    echo "Kiểm tra bản cập nhật cho .zshrc..."
    if ! check_internet; then
        echo -e "\e[91mKhông thể kết nối mạng. Vui lòng thử lại sau.\e[0m"
        return 1
    fi
    
    # Get remote version
    local remote_version=$(curl -s https://raw.githubusercontent.com/iZuminnnn/zsh-theme/main/version.txt 2>/dev/null)
    if [[ -z "$remote_version" ]]; then
        echo -e "\e[91mKhông thể tải thông tin phiên bản.\e[0m"
        return 1
    fi
    
    # Compare versions (simple string comparison)
    if [[ "$remote_version" != "$ZSHRC_VERSION" ]]; then
        echo -e "\e[92mĐã phát hiện phiên bản mới: $remote_version (hiện tại: $ZSHRC_VERSION)\e[0m"
        echo -e "Đang tải xuống bản cập nhật..."
        
        # Backup current file
        cp ~/.zshrc ~/.zshrc.backup
        
        # Download new version
        if curl -s -o ~/.zshrc https://raw.githubusercontent.com/iZuminnnn/zsh-theme/main/.zshrc; then
            echo -e "\e[92mCập nhật thành công! Đã sao lưu phiên bản cũ tại ~/.zshrc.backup\e[0m"
            echo -e "Khởi động lại shell để áp dụng thay đổi, hoặc chạy: source ~/.zshrc"
        else
            echo -e "\e[91mCập nhật thất bại. Vui lòng thử lại sau.\e[0m"
            # Restore backup
            cp ~/.zshrc.backup ~/.zshrc
        fi
    else
        echo -e "\e[92mBạn đang sử dụng phiên bản mới nhất ($ZSHRC_VERSION)\e[0m"
    fi
}

# Add alias for easier updating
alias update-zshrc="update_zshrc"

# Prompt hooks
preexec() { 
    timer=$(( $(date +%s%0N) / 1000000 )); 
    last_cmd="$1";
    # Thêm gọi troll_cmd khi thực thi lệnh
    troll_message=$(troll_cmd "$last_cmd")
    [[ -n "$troll_message" ]] && echo "$troll_message"
}

precmd() {
    PS1="$(time_icon) %F{cyan}%n@%m %F{magenta}%~%f $(venv_info) $(git_info)
%F{green}➜ %f"
    
    if [[ -n $timer ]]; then
        local now=$(( $(date +%s%0N) / 1000000 ))
        RPROMPT="%F{cyan}$((now-timer))ms%f"
        unset timer
    fi
    
    # Loại bỏ cpu_troll vì tốn thời gian xử lý
    unset last_cmd
}

# Clear custom
my_clear() {
    command clear
    # Sử dụng biến đã tính toán sẵn thay vì tính toán mỗi lần
    local quote_index=$((RANDOM % ${#troll_quotes[@]}))
    local color_index=$((RANDOM % ${#troll_colors[@]}))
    echo -e "\e[${troll_colors[$color_index]}m${troll_quotes[$quote_index]}\e[0m"
    # Không gọi weather_icon trong clear để tăng tốc
}

# Cấu hình cuối
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
# Xóa nhanh toàn bộ dòng (trước và sau con trỏ)
bindkey '^U' backward-kill-line  # Ctrl + U: Xóa từ con trỏ về đầu dòng  
bindkey '^K' kill-line           # Ctrl + K: Xóa từ con trỏ về cuối dòng 
# Di chuyển đầu/cuối dòng  
bindkey '^[a' beginning-of-line   # Alt + A: Nhảy về đầu dòng  
bindkey '^[e' end-of-line         # Alt + E: Nhảy về cuối dòng  

# Loading zsh-autosuggestions
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Khởi tạo - check update đầu tiên, sau đó mới hiển thị quotes và thời tiết
{
  # Get last update check time
  LAST_UPDATE_CHECK_FILE="${HOME}/.zsh_update_check"
  LAST_CHECK=0
  [[ -f "$LAST_UPDATE_CHECK_FILE" ]] && LAST_CHECK=$(cat "$LAST_UPDATE_CHECK_FILE")
  
  CURRENT_DATE=$(date +%Y-%m-%d)
  # Check if the date has changed
  if [[ "$CURRENT_DATE" != "$LAST_CHECK" ]]; then
    # Update timestamp first to prevent frequent checks
    echo "$CURRENT_DATE" > "$LAST_UPDATE_CHECK_FILE"
    # Check for updates first
    update_zshrc
  fi
} 

# Hiển thị quotes ngẫu nhiên
typeset -g startup_quote_index=$((RANDOM % ${#troll_quotes[@]}))
typeset -g startup_color_index=$((RANDOM % ${#troll_colors[@]}))
echo -e "\e[${troll_colors[$startup_color_index]}m${troll_quotes[$startup_quote_index]}\e[0m"

# Only show weather if we have internet
if check_internet; then
    echo "Thời tiết hôm nay: $(weather_icon)"
fi

# Check for updates once a day (but don't block startup)
{
  # Get last update check time
  LAST_UPDATE_CHECK_FILE="${HOME}/.zsh_update_check"
  LAST_CHECK=0
  [[ -f "$LAST_UPDATE_CHECK_FILE" ]] && LAST_CHECK=$(cat "$LAST_UPDATE_CHECK_FILE")
  
  CURRENT_DATE=$(date +%Y-%m-%d)
  # Check if the date has changed
  if [[ "$CURRENT_DATE" != "$LAST_CHECK" ]]; then
    # Update timestamp first to prevent frequent checks
    echo "$CURRENT_DATE" > "$LAST_UPDATE_CHECK_FILE"
    # Quietly check for updates in the background
    (update_zshrc > /dev/null 2>&1 &)
  fi
} &>/dev/null
