# Cấu hình lịch sử
HISTFILE="${HOME}/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

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
        *git\ commit*) message="Đã commit gì chưa hay để quên -m người đẹp?" color=93 ;;
        *git\ push*) message="Đã push thật chưa hay mạng lag người đẹp?" color=94 ;;
        *git\ st*|*git\ status*) message="Status check hoài, code đâu mà xem người đẹp?" color=92 ;;
        *python*) message="Đã debug Python chưa hay print mãi người đẹp?" color=95 ;;
        *npm*) message="Đã node_modules gì chưa hay đơ máy người đẹp?" color=91 ;;
        *rm*) message="Đã xóa gì chưa hay lỡ tay xóa luôn code người đẹp?" color=96 ;;
        *) return ;;
    esac
    echo "\e[${color}m${message}\e[0m"
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

# Tối ưu weather
typeset -g last_weather_update=0 cached_weather_icon="🌍 ?°C"
weather_icon() {
    local current_time=$(date +%s)
    if ((current_time - last_weather_update >= 300)); then
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
    fi
    echo -e "$cached_weather_icon"
}

# Prompt hooks
preexec() { timer=$(( $(date +%s%0N) / 1000000 )); last_cmd="$1"; }
precmd() {
    local last_exit_code=$?
    [[ $last_exit_code -eq 0 && -n $last_cmd ]] && troll_cmd "$last_cmd"
    
    PS1="$(time_icon) %F{cyan}%n@%m %F{magenta}%~%f $(venv_info) $(git_info)
%F{green}➜ %f"
    
    if [[ -n $timer ]]; then
        local now=$(( $(date +%s%0N) / 1000000 ))
        RPROMPT="%F{cyan}$((now-timer))ms%f"
        unset timer
    fi
    cpu_troll
    unset last_cmd
}

# Clear custom
my_clear() {
    command clear
	echo -e "\e[${troll_colors[RANDOM % ${#troll_colors[@]}]}m${troll_quotes[RANDOM % ${#troll_quotes[@]}]}\e[0m"
    echo "Thời tiết hôm nay: $(weather_icon)"
}

# Cấu hình cuối
autoload -U colors && colors
alias clear="my_clear"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Khởi tạo
echo -e "\e[${troll_colors[RANDOM % ${#troll_colors[@]}]}m${troll_quotes[RANDOM % ${#troll_quotes[@]}]}\e[0m"
echo "Thời tiết hôm nay: $(weather_icon)"
