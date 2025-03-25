HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt APPEND_HISTORY        # Thêm vào lịch sử thay vì ghi đè
setopt SHARE_HISTORY         # Chia sẻ lịch sử giữa các terminal
setopt HIST_IGNORE_DUPS      # Không lưu lệnh trùng liên tiếp
setopt HIST_SAVE_NO_DUPS     # Không lưu lệnh trùng vào file lịch sử
setopt HIST_EXPIRE_DUPS_FIRST # Xóa lệnh trùng trước khi xóa lệnh cũ nhất
setopt HIST_VERIFY           # Yêu cầu xác nhận trước khi thực thi lệnh từ lịch sử
# Version for update checking
ZSHRC_VERSION="0.0.8"
troll_colors=(91 92 93 94 95 96) # red green yellow blue magenta cyan

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


# Tối ưu troll theo thời gian
troll_by_time() {
    local hour=$(date +%H)
    local minute=$(date +%M)
    
    # Đặt seed cho RANDOM dựa trên thời gian hiện tại (số giây từ epoch)
    RANDOM=$(date +%s)  # Dùng số giây từ epoch làm seed
    
    local random_color=${troll_colors[$((RANDOM % ${#troll_colors[@]}))]}
    local message
    local messages
    local chance=$((RANDOM % 100))
    # Check if within 17:30-18:30
    local force_show=${1:-false}
    local force_show_by_time=false
    if [[ ("$hour" == 17 && "$minute" -ge 30) || ("$hour" == 18 && "$minute" -le 30) ]]; then
        force_show_by_time=true
    fi

    # Luôn hiển thị thông điệp khi gọi hàm (bỏ logic xác suất 10% để test dễ hơn)
    if [[ "$force_show_by_time" == true ]]; then
        messages=(
            "Muộn rồi đó má! Code ít thôi, về đi kẻo người ta chờ cơm nguội bây giờ!"
            "Giờ này còn ngồi code chi nữa? Công ty có bao cổ phần đâu mà cống hiến dữ vậy!"
            "Về đi chứ! Bug thì fix hoài không hết, nhưng thanh xuân mà hết rồi là khỏi fix!"
            "Bắt đầu tắt máy đi, đừng để hôm nay lại thành một ngày OT vô nghĩa nữa!"
            "Deadline quan trọng nhưng người đợi cơm còn quan trọng hơn!"
            "Tắt máy ngay! Đi về hôn người yêu, ôm con, ăn cơm! Đừng để về nhà chỉ thấy... con mèo!"
            "Ngồi lại muộn thêm chút nữa là công ty in luôn tên lên bàn phím đấy, về đi!"
            "Còn ngồi đó hả? Về lẹ đi, đừng để ngày mai công ty phát luôn gối ôm với chăn mền cho tiện!"
            "Gõ phím hoài không chán hả? Về đi ông ơi, chứ bàn phím nó mòn thì còn thay được, chứ thanh xuân mòn là khỏi sửa!"
            "Về đi! Đừng để hôm nay thành một ngày OT vô nghĩa, mà lương thì vẫn vậy!"
            "Ngồi code thêm chút nữa là mai HR gửi luôn hợp đồng thuê công ty làm nhà ở đó!"
            "Máy tính không cần nghỉ, nhưng ông thì có đó nha! Tắt máy ngay!"
            "Bug fix hoài không hết, nhưng deadline cuộc đời thì tới nhanh lắm, về đi ông ơi!"
            "Ngồi lại chút nữa là công ty khắc tên ông lên ghế luôn đó, về đi chứ còn gì nữa!"
            "Về đi chứ? Công ty có cổ phần cho ông đâu mà cống hiến dữ vậy!"
            "Gõ phím ít thôi, còn để dành sức mà nắm tay người thương nữa chứ!"
            "Về lẹ đi! Đừng để về nhà chỉ thấy... con mèo nhìn ông với ánh mắt đầy thương hại!"
            "Ông còn gõ phím nữa là cái bàn phím nó kiện ông lên công đoàn đó!"
            "Về đi! Đừng để ngày mai đồng nghiệp tưởng ông là nhân viên bảo vệ ca đêm!"
            "OT hoài không làm ông giàu lên đâu, nhưng chắc chắn làm ông già đi!"
            "Máy tính thì có thể nâng cấp, nhưng cột sống ông mà hỏng thì chịu luôn!"
            "Code mãi không xong thì mai code tiếp, chứ mất ngủ là mai khỏi code luôn!"
            "Sếp không thấy ông OT đâu, nhưng bác sĩ thần kinh thì sắp thấy đó!"
            "Về đi chứ? Hay định debug luôn cả cuộc đời?"
            "Bug có thể chờ, nhưng người yêu ông thì không đâu!"
            "Về lẹ đi! Đừng để hôm sau đi làm với đôi mắt thâm hơn cả dark mode!"
            "Công ty không đóng cửa, nhưng quán cơm ông hay ăn thì sắp đóng rồi đó!"
            "Fix bug xong chưa? Chưa thì mai fix tiếp, chứ về trễ nữa là chỉ còn mỗi bug làm bạn!"
            "Ngồi thêm tí nữa là mai HR phát luôn huy chương 'nhân viên kiên trì' cho ông đó!"
            "Deadline dí cũng không nhanh bằng tuổi xuân trôi đâu, về lẹ còn kịp!"
        )

    elif (( chance < 10 )) || [[ "$force_show" == true ]]; then
        case $hour in
            00|01) messages=("Giờ này còn thức làm gì đấy? Định hẹn hò với bug xuyên đêm à?" "Ngủ sớm đi má, chứ code khuya dễ commit mấy dòng regret lắm!") ;;
            02|03) messages=("Ủa, thức khuya vậy? Có phải đang debug một lỗi mà Google cũng từ chối trả lời không?" "Giờ này vẫn còn code là trình cao thủ lắm nha!") ;;
            04|05) messages=("Trời sắp sáng rồi, ngủ chưa hay đang luyện công phu 'bug bám dai'?" "Gà gáy rồi mà bug vẫn chưa chịu đi ngủ hả?") ;;
            06|07) messages=("Dậy chưa? Hay là vẫn quấn chăn trong khi bug đang chờ kìa!" "Sáng rồi, mở VS Code hay mở bát trước đây?") ;;
            08|09) messages=("Cà phê sáng chưa? Hay vẫn đang nạp caffeine bằng stackoverflow?" "Bữa sáng nay có gì? Đừng nói lại là 'fix bug' nhé!") ;;
            10|11) messages=("Tầm này chắc vẫn đang họp đúng không? 'Nói ít code nhiều' nhớ!" "Công việc ổn không? Hay là tâm trạng còn hỗn loạn hơn git merge?") ;;
            12|13) messages=("Ăn trưa chưa? Hay lại định sống bằng niềm tin vào deadline?" "Bug có nghỉ trưa không? Không! Vậy nên dev cũng không!") ;;
            14|15) messages=("Tầm này dễ đơ người lắm, mà code đơ còn nhanh hơn dev!" "Trà chiều chưa? Hay còn bận fix bug mà chưa nhấp môi giọt nào?") ;;
            16|17) messages=("Chiều rồi, năng lượng vẫn còn hay đã tụt mood theo bug?" "Code chiều hay dễ dính bug, cẩn thận kẻo sáng mai fix không kịp!") ;;
            18|19) messages=("Giờ này dev đang code hay đang nhậu?" "Cẩn thận nhé, code ban tối dễ commit dòng regret lắm!") ;;
            20|21) messages=("Nay có định chơi game tí cho đỡ stress không hay lại ôm bug cả tối?" "Code xong rồi thì nghỉ ngơi tí đi! Đừng để bug cướp luôn tuổi trẻ!") ;;
            22|23) messages=("Giờ này vẫn còn cày à? Tí nữa ngủ luôn trên bàn phím cho coi!" "Làm dev kiểu này mai dậy là thành zombie nhé!") ;;
            *) messages=("Giờ giấc kỳ lạ quá! Không biết gọi là sáng, trưa, chiều hay tối nữa!") ;;
        esac
    fi
    # Chọn ngẫu nhiên một thông báo từ danh sách
    if [[ -n "$messages" ]]; then
        message=${messages[$(((RANDOM % ${#messages[@]}) + 1))]}
    fi
    if [[ -n "$message" ]]; then
        echo -e "\e[95m${message}\e[0m"
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
    fi
}

# Add alias for easier updating
alias update-zshrc="update_zshrc"
last_troll_time=0
troll_interval=$((5 * 60))  # 5 phút
# Prompt hooks

preexec() {
    timer=$(( $(date +%s%0N) / 1000000 ))
    last_cmd="$1"

    # Gọi troll_by_time chỉ sau mỗi khoảng thời gian nhất định
    current_time=$(date +%s)
    if (( current_time - last_troll_time >= troll_interval )); then
        troll_time_message=$(troll_by_time)
        [[ -n "$troll_time_message" ]] && echo "$troll_time_message"
        last_troll_time=$current_time
    fi

    # Gọi troll_cmd
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
    if check_internet; then
      echo "Thời tiết hôm nay: $(weather_icon)"
    fi
    troll_by_time true
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
    echo -e "\e[93mChúc người đẹp một ngày mới tràn đầy năng lượng nhé! Happy coding😘\e[0m"
    # Update timestamp first to prevent frequent checks
    echo "$CURRENT_DATE" > "$LAST_UPDATE_CHECK_FILE"
    # Check for updates first
    update_zshrc
  fi
} 

# Only show weather if we have internet
detect_wsl
if check_internet; then
    echo "Thời tiết hôm nay: $(weather_icon)"
fi
troll_by_time true
