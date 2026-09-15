#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════════
# 🚀🔥💎 ASTROWAX PANEL — MASTER CONTROL SCRIPT v2.0 💎🔥🚀
# 🎨 Premium Ultra Edition • 4K Visuals • Cyberpunk UX • MAX EMOJI
# ✨ Crafted with 💜 by Itzytansh
# ═══════════════════════════════════════════════════════════════════════════════

set -o pipefail

# ═══════════════════════════════════════════════════════════════════════════════
# 🌈 ULTRA RGB COLOR SYSTEM (True Color / 256 Color / Basic Fallback)
# ═══════════════════════════════════════════════════════════════════════════════
if [[ $(tput colors 2>/dev/null) -ge 256 ]]; then
    C_RESET='\033[0m'
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_ITALIC='\033[3m'
    C_UNDERLINE='\033[4m'
    C_BLINK='\033[5m'
    C_REVERSE='\033[7m'

    # Cyberpunk Neon Palette 🌈
    C_CYAN='\033[38;5;51m'
    C_CYAN_L='\033[38;5;87m'
    C_CYAN_X='\033[38;5;123m'
    C_PURPLE='\033[38;5;129m'
    C_PURPLE_L='\033[38;5;171m'
    C_PURPLE_X='\033[38;5;201m'
    C_PINK='\033[38;5;207m'
    C_PINK_L='\033[38;5;213m'
    C_RED='\033[38;5;196m'
    C_RED_L='\033[38;5;203m'
    C_RED_X='\033[38;5;160m'
    C_GREEN='\033[38;5;46m'
    C_GREEN_L='\033[38;5;120m'
    C_GREEN_X='\033[38;5;82m'
    C_YELLOW='\033[38;5;226m'
    C_YELLOW_L='\033[38;5;228m'
    C_ORANGE='\033[38;5;208m'
    C_ORANGE_L='\033[38;5;214m'
    C_WHITE='\033[38;5;231m'
    C_GRAY='\033[38;5;241m'
    C_GRAY_L='\033[38;5;250m'
    C_GOLD='\033[38;5;220m'
    C_MAGENTA='\033[38;5;200m'
    C_LIME='\033[38;5;154m'
    C_AQUA='\033[38;5;86m'
    C_FIRE='\033[38;5;202m'

    # Backgrounds 🎨
    BG_PURPLE='\033[48;5;54m'
    BG_CYAN='\033[48;5;33m'
    BG_DARK='\033[48;5;236m'
    BG_RED='\033[48;5;52m'
    BG_GREEN='\033[48;5;22m'
    BG_GOLD='\033[48;5;58m'
else
    C_RESET='\033[0m'
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_ITALIC='\033[3m'
    C_UNDERLINE='\033[4m'
    C_BLINK='\033[5m'
    C_REVERSE='\033[7m'
    C_CYAN='\033[0;36m'
    C_CYAN_L='\033[1;36m'
    C_CYAN_X='\033[1;36m'
    C_PURPLE='\033[0;35m'
    C_PURPLE_L='\033[1;35m'
    C_PURPLE_X='\033[1;35m'
    C_PINK='\033[1;35m'
    C_PINK_L='\033[1;35m'
    C_RED='\033[0;31m'
    C_RED_L='\033[1;31m'
    C_RED_X='\033[1;31m'
    C_GREEN='\033[0;32m'
    C_GREEN_L='\033[1;32m'
    C_GREEN_X='\033[1;32m'
    C_YELLOW='\033[1;33m'
    C_YELLOW_L='\033[1;33m'
    C_ORANGE='\033[0;33m'
    C_ORANGE_L='\033[1;33m'
    C_WHITE='\033[1;37m'
    C_GRAY='\033[0;37m'
    C_GRAY_L='\033[1;30m'
    C_GOLD='\033[1;33m'
    C_MAGENTA='\033[1;35m'
    C_LIME='\033[1;32m'
    C_AQUA='\033[1;36m'
    C_FIRE='\033[0;31m'
    BG_PURPLE='\033[45m'
    BG_CYAN='\033[46m'
    BG_DARK='\033[40m'
    BG_RED='\033[41m'
    BG_GREEN='\033[42m'
    BG_GOLD='\033[43m'
fi

# ═══════════════════════════════════════════════════════════════════════════════
# 🎭 ULTRA VISUAL EFFECTS ENGINE
# ═══════════════════════════════════════════════════════════════════════════════

# 🌀 Rainbow Gradient Text
rainbow_text() {
    local text="$1"
    local colors=("$C_RED" "$C_ORANGE" "$C_YELLOW" "$C_GREEN" "$C_CYAN" "$C_PURPLE" "$C_PINK")
    local result=""
    for ((i=0; i<${#text}; i++)); do
        local char="${text:$i:1}"
        result+="${colors[$((i % ${#colors[@]}))]}${char}"
    done
    echo -e "${result}${C_RESET}"
}

# 🌊 Gradient Text (2-color)
gradient_text() {
    local text="$1" start_color="$2" end_color="$3"
    local len=${#text} result=""
    for ((i=0; i<len; i++)); do
        local char="${text:$i:1}"
        if (( i * 100 / len < 50 )); then result+="${start_color}${char}"; else result+="${end_color}${char}"; fi
    done
    echo -e "${result}${C_RESET}"
}

# ⚡ Glitch Effect
glitch_text() {
    local text="$1"
    local colors=("$C_CYAN" "$C_PURPLE" "$C_PINK" "$C_RED" "$C_GREEN" "$C_YELLOW")
    local result=""
    for ((i=0; i<${#text}; i++)); do
        result+="${colors[$((RANDOM % ${#colors[@]}))]}${text:$i:1}"
    done
    echo -e "${result}${C_RESET}"
}

# 🔥 Typewriter Effect
typewriter() {
    local text="$1" color="${2:-$C_CYAN_L}" speed="${3:-0.02}"
    echo -ne "  ${color}"
    for ((i=0; i<${#text}; i++)); do
        printf "%s" "${text:$i:1}"
        sleep "$speed"
    done
    echo -e "${C_RESET}"
}

# 💫 Pulse Text Effect
pulse_text() {
    local text="$1"
    echo -ne "\r  ${C_DIM}${text}${C_RESET}"; sleep 0.15
    echo -ne "\r  ${C_CYAN}${text}${C_RESET}"; sleep 0.15
    echo -ne "\r  ${C_CYAN_L}${text}${C_RESET}"; sleep 0.15
    echo -ne "\r  ${C_WHITE}${C_BOLD}${text}${C_RESET}"; sleep 0.15
    echo -e  "\r  ${C_CYAN_L}${C_BOLD}${text}${C_RESET}"
}

# 📊 Animated Progress Bar
progress_bar() {
    local current=$1 total=$2 width=40
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    printf "\r${C_DIM}["
    printf "${C_CYAN_L}"
    for ((i=0; i<filled; i++)); do printf "█"; done
    printf "${C_PURPLE}"
    for ((i=0; i<empty; i++)); do printf "░"; done
    printf "${C_DIM}]${C_RESET} ${C_BOLD}%3d%%${C_RESET}" "$percentage"
}

# 🌀 Fancy Spinner
spinner() {
    local pid=$1 msg="$2"
    local spinners=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    local colors=("$C_CYAN" "$C_CYAN_L" "$C_PURPLE" "$C_PURPLE_L" "$C_PINK" "$C_PINK_L")
    local i=0

    printf "  ${C_CYAN}🌀${C_RESET} ${msg} "
    while kill -0 $pid 2>/dev/null; do
        printf "\b${colors[$((i % ${#colors[@]}))]}${spinners[$((i % ${#spinners[@]}))]}"
        i=$((i + 1))
        sleep 0.08
    done
    printf "\b${C_GREEN}${C_BOLD}✓${C_RESET}"
}

# 🎆 Burst Animation
burst_animation() {
    local text="$1"
    local frames=("·" "•" "●" "◉" "⭐" "💫" "✨")
    for frame in "${frames[@]}"; do
        printf "\r    ${C_GOLD}${frame} ${C_BOLD}%s${C_RESET} ${frame}   " "$text"
        sleep 0.12
    done
    printf "\r    ${C_GREEN}${C_BOLD}✨ %s ✨${C_RESET}              \n" "$text"
}

# 🔥 Fire Loader
fire_loader() {
    local msg="${1:-Processing}"
    local frames=("🔥" "🔥🔥" "🔥🔥🔥" "🔥🔥🔥🔥" "🔥🔥🔥🔥🔥" "🔥🔥🔥🔥" "🔥🔥🔥" "🔥🔥" "🔥")
    printf "  ${C_FIRE}${C_BOLD}${msg} ${C_RESET}"
    for i in {0..2}; do
        for frame in "${frames[@]}"; do
            printf "\r  ${C_FIRE}${C_BOLD}${msg} ${C_RESET}${C_YELLOW}${frame}   "
            sleep 0.08
        done
    done
    printf "\r  ${C_GREEN}${C_BOLD}✨${C_RESET} ${msg} ${C_GREEN}${C_BOLD}DONE! ✨${C_RESET}               \n"
}

# 💎 Diamond Loader
diamond_loader() {
    local msg="${1:-Loading}"
    local frames=("◇" "◆" "💎" "◆" "◇")
    printf "  ${C_CYAN}${msg} "
    for i in {0..3}; do
        for frame in "${frames[@]}"; do
            printf "\r  ${C_CYAN_L}${C_BOLD}${msg} ${C_PURPLE}${frame} "
            sleep 0.06
        done
    done
    printf "\r  ${C_CYAN_L}${C_BOLD}${msg} ${C_GREEN}${C_BOLD}✅${C_RESET}               \n"
}

# ⚡ Lightning Strike Effect
lightning_strike() {
    local text="$1"
    echo -ne "\r  ${C_WHITE}${C_BOLD}⚡${text}⚡${C_RESET}"; sleep 0.08
    echo -ne "\r  ${C_YELLOW}${C_BOLD}⚡${text}⚡${C_RESET}"; sleep 0.08
    echo -ne "\r  ${C_CYAN_L}${C_BOLD}⚡${text}⚡${C_RESET}"; sleep 0.08
    echo -e  "\r  ${C_GREEN}${C_BOLD}⚡${text}⚡${C_RESET}       "
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎨 MEGA BANNER SYSTEM — AWP (ASTROWAX PANEL)
# ═══════════════════════════════════════════════════════════════════════════════

print_banner() {
    clear 2>/dev/null || true

    echo ""
    echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # 🔥🔥🔥 MASSIVE AWP ASCII ART 🔥🔥🔥
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_X}${C_BOLD}            █████╗ ██╗    ██╗██████╗                         ${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_X}${C_BOLD}           ██╔══██╗██║    ██║██╔══██╗                        ${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}           ███████║██║ █╗ ██║██████╔╝                        ${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN}${C_BOLD}           ██╔══██║██║███╗██║██╔═══╝                         ${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN}${C_BOLD}           ██║  ██║╚███╔███╔╝██║                             ${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN}${C_BOLD}           ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝                             ${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # Subtitle line with sparkle
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}   "
    echo -ne "  ${C_PINK_L}✦${C_RESET} ${C_YELLOW}${C_BOLD}A${C_RESET} ${C_ORANGE}${C_BOLD}S${C_RESET} ${C_RED}${C_BOLD}T${C_RESET} ${C_PINK}${C_BOLD}R${C_RESET} ${C_PURPLE_L}${C_BOLD}O${C_RESET} ${C_PURPLE}${C_BOLD}W${C_RESET} ${C_BLUE}${C_BOLD}A${C_RESET} ${C_CYAN_L}${C_BOLD}X${C_RESET}"
    echo -e "   ${C_PINK_L}✦${C_RESET}                           ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}     ${C_PURPLE_L}${C_BOLD}╔═╗╔╦╗╦ ╦╔╦╗  ╦╔═╗╔═╗╔═╗  ╦═╗╔═╗╔╗ ╔═╗╔╦╗${C_RESET}              ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}     ${C_PURPLE}${C_BOLD}╠═╣ ║║║ ║ ║║  ║╠═╝║ ║║ ║  ╠╦╝║ ║╠╩╗║ ║ ║${C_RESET}               ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}     ${C_PURPLE}${C_BOLD}╩ ╩═╩╝╚═╝═╩╝  ╩╩  ╚═╝╚═╝  ╩╚═╚═╝╚═╝╚═╝ ╩${C_RESET}               ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # Version & credits
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}     "
    echo -ne "${C_CYAN_L}${C_BOLD}🚀 ASTROWAX PANEL"
    echo -ne "  ${C_PURPLE_L}•"
    echo -ne "  ${C_PINK}v1.80 Ultra"
    echo -ne "  ${C_PURPLE_L}•"
    echo -ne "  ${C_GOLD}Premium Edition"
    echo -e "     ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}           "
    echo -ne "${C_DIM}⚡ Next-Gen Hosting Control Panel ⚡"
    echo -e "              ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}           "
    echo -ne "${C_DIM}💎 Crafted with"
    echo -ne " ${C_RED}❤️ "
    echo -ne "${C_DIM} by "
    echo -ne "${C_YELLOW}${C_BOLD}Itzytansh"
    echo -e "${C_RESET}${C_DIM} 💎${C_RESET}                ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"

    # Animated decorative line
    echo -ne "    ${C_DIM}"
    for i in {1..71}; do
        case $((i % 7)) in
            0) printf "${C_CYAN}═" ;;
            1) printf "${C_PURPLE}═" ;;
            2) printf "${C_PINK}═" ;;
            3) printf "${C_PURPLE_L}═" ;;
            4) printf "${C_CYAN_L}═" ;;
            5) printf "${C_PURPLE}═" ;;
            6) printf "${C_CYAN}═" ;;
        esac
    done
    echo -e "${C_RESET}"
    echo ""
}

# 🎯 Section Header
print_header() {
    local title="$1"
    local subtitle="$2"
    local icon="${3:-🎯}"

    echo ""
    echo -ne "    ${C_PURPLE_L}${C_BOLD}╔"
    printf '═%.0s' {1..67}; echo -e "╗${C_RESET}"
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${icon} ${C_CYAN_L}${C_BOLD}"
    printf '%-63s' "$title"
    echo -e "${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_GRAY_L}"
    printf '%-63s' "$subtitle"
    echo -e "${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -ne "    ${C_PURPLE_L}${C_BOLD}╚"
    printf '═%.0s' {1..67}; echo -e "╝${C_RESET}"
    echo ""
}

# 🎆 Mega Success Banner
print_success_banner() {
    local title="$1"
    local icon="${2:-🎉}"

    echo ""
    echo -e "    ${C_GREEN_X}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -ne "    ${C_GREEN_X}${C_BOLD}║${C_RESET}           "
    echo -ne "${icon} ${C_WHITE}${C_BOLD}${title}"
    echo -e " ${icon}                 ${C_GREEN_X}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_GREEN_X}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

# ⚠️ Warning Banner
print_warning_banner() {
    local title="$1"
    echo ""
    echo -e "    ${C_ORANGE}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_ORANGE}${C_BOLD}║${C_RESET}       ⚠️  ${C_YELLOW}${C_BOLD}${title}${C_RESET}  ⚠️               ${C_ORANGE}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_ORANGE}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

# ❌ Error Banner
print_error_banner() {
    local title="$1"
    echo ""
    echo -e "    ${C_RED_X}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_RED_X}${C_BOLD}║${C_RESET}        ❌ ${C_RED_L}${C_BOLD}${title}${C_RESET} ❌                  ${C_RED_X}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_RED_X}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📡 LOGGING SYSTEM (Premium Emoji Edition)
# ═══════════════════════════════════════════════════════════════════════════════

log_info()    { echo -e "  ${C_CYAN}ℹ️ ${C_RESET}  ${C_CYAN_L}$1${C_RESET}"; }
log_success() { echo -e "  ${C_GREEN}✅${C_RESET}  ${C_GREEN_L}${C_BOLD}$1${C_RESET}"; }
log_warning() { echo -e "  ${C_YELLOW}⚠️ ${C_RESET}  ${C_ORANGE}${C_BOLD}$1${C_RESET}"; }
log_error()   { echo -e "  ${C_RED}❌${C_RESET}  ${C_RED_L}${C_BOLD}$1${C_RESET}"; }
log_step()    { echo -e "  ${C_PURPLE_L}🔮${C_RESET}  ${C_BOLD}$1${C_RESET}"; }
log_debug()   { echo -e "  ${C_GRAY}🔍${C_RESET}  $1"; }
log_fire()    { echo -e "  ${C_FIRE}🔥${C_RESET}  ${C_GOLD}${C_BOLD}$1${C_RESET}"; }
log_rocket()  { echo -e "  ${C_CYAN}🚀${C_RESET}  ${C_CYAN_L}${C_BOLD}$1${C_RESET}"; }
log_star()    { echo -e "  ${C_YELLOW}⭐${C_RESET}  ${C_YELLOW_L}${C_BOLD}$1${C_RESET}"; }
log_gem()     { echo -e "  ${C_PURPLE_L}💎${C_RESET}  ${C_PURPLE_L}${C_BOLD}$1${C_RESET}"; }
log_lock()    { echo -e "  ${C_RED}🔒${C_RESET}  ${C_RED_L}$1${C_RESET}"; }
log_globe()   { echo -e "  ${C_CYAN}🌐${C_RESET}  ${C_CYAN_L}$1${C_RESET}"; }
log_package() { echo -e "  ${C_ORANGE}📦${C_RESET}  ${C_ORANGE_L}$1${C_RESET}"; }
log_wrench()  { echo -e "  ${C_GRAY_L}🔧${C_RESET}  ${C_GRAY_L}$1${C_RESET}"; }

# ═══════════════════════════════════════════════════════════════════════════════
# ⚙️ CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════════

GH_USER="${ASTROWAX_GH_USER:-AstroVoidHostDev}"
GH_REPO="${ASTROWAX_GH_REPO:-astrowax}"
GH_BRANCH="${ASTROWAX_GH_BRANCH:-main}"
GH_ARCHIVE="${ASTROWAX_GH_ARCHIVE:-panel.zip}"

V1_GH_USER="${ASTROWAX_V1_GH_USER:-AstroVoidHostDev}"
V1_GH_REPO="${ASTROWAX_V1_GH_REPO:-AstroWax-Panel}"

WORK_DIR_NAME="panel"
PANEL_DIR_NAME="astrowax-panel"
EXPECTED_PKG_NAME="astrowax-panel"

MAIN_PROCESS="astrowax-main"
MAIN_CONTAINER="astrowax-main"
MAIN_PORT="6767"
SFTP_PORT="6868"

SELECTED_VERSION=""

# ═══════════════════════════════════════════════════════════════════════════════
# 🔧 HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════

run_pm2() {
    if [ -x "./node_modules/.bin/pm2" ]; then ./node_modules/.bin/pm2 "$@"
    elif command -v pm2 &> /dev/null; then pm2 "$@"
    elif [ -x "/usr/local/bin/pm2" ]; then /usr/local/bin/pm2 "$@"
    else npx --no-install pm2 "$@" 2>/dev/null || npx pm2 "$@"; fi
}

get_docker_cmd() {
    if docker info > /dev/null 2>&1; then echo "docker"
    elif command -v sudo &> /dev/null && sudo docker info > /dev/null 2>&1; then echo "sudo docker"
    else echo "docker"; fi
}

find_panel_dir() {
    if [ -f "package.json" ] && grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        pwd; return 0
    fi
    if [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ] && \
       grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" 2>/dev/null; then
        echo "$(pwd)/$WORK_DIR_NAME/$PANEL_DIR_NAME"; return 0
    fi
    local found=$(find . -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" -not -path "*/dist/*" 2>/dev/null | while read f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)
    if [ -n "$found" ]; then
        echo "$(cd "$(dirname "$found")" && pwd)"; return 0
    fi
    echo ""; return 1
}

# 🎬 Execute Step with MEGA Animation
execute_step() {
    local msg="$1"; shift
    local step_id="awp_step_$RANDOM"
    local log_file="/tmp/${step_id}.log"
    rm -f "$log_file"

    # Animated step entry
    printf "  ${C_PURPLE_L}${C_BOLD}▸${C_RESET} ${C_BOLD}%-50s${C_RESET} " "$msg"

    "$@" > "$log_file" 2>&1 &
    local pid=$!

    # Animated dots while running
    local dots=""
    local spin_chars=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local spin_colors=("$C_CYAN" "$C_CYAN_L" "$C_PURPLE" "$C_PURPLE_L" "$C_PINK")
    local i=0
    while kill -0 $pid 2>/dev/null && [ $i -lt 200 ]; do
        printf "\r  ${spin_colors[$((i % ${#spin_colors[@]}))]}${C_BOLD}%s${C_RESET} ${C_BOLD}%-50s${C_RESET} ${C_DIM}[%ds]${C_RESET}" "${spin_chars[$((i % ${#spin_chars[@]}))]}" "$msg" "$((i/2))"
        sleep 0.5
        i=$((i + 1))
    done

    local status=0
    wait $pid 2>/dev/null || status=$?

    printf "\r  "
    if [ $status -eq 0 ]; then
        echo -e "${C_GREEN}${C_BOLD}✅${C_RESET}  ${C_GREEN_L}${C_BOLD}%-50s${C_RESET}  ${C_GREEN}[${C_BOLD}✓ DONE${C_RESET}${C_GREEN}]${C_RESET}" "$msg"
    else
        echo -e "${C_RED}${C_BOLD}❌${C_RESET}  ${C_RED_L}${C_BOLD}%-50s${C_RESET}  ${C_RED}[${C_BOLD}✗ FAIL${C_RESET}${C_RED}]${C_RESET}" "$msg"
        echo ""
        echo -e "    ${C_RED}${C_BOLD}╔═══════════════════════════════════════════════════════════╗${C_RESET}"
        echo -e "    ${C_RED}${C_BOLD}║${C_RESET}  ${C_RED_L}${C_BOLD}💥 ERROR LOG: $msg${C_RESET}"
        echo -e "    ${C_RED}${C_BOLD}╠═══════════════════════════════════════════════════════════╣${C_RESET}"
        echo -e "    ${C_RED}${C_BOLD}║${C_RESET}  ${C_YELLOW}Exit Code: ${C_BOLD}$status${C_RESET}"
        if [ -s "$log_file" ]; then
            echo -e "    ${C_RED}${C_BOLD}║${C_RESET}  ${C_GRAY_L}📋 Output:${C_RESET}"
            tail -n 15 "$log_file" | sed 's/^/    ${C_RED}${C_BOLD}║${C_RESET}    /'
        fi
        echo -e "    ${C_RED}${C_BOLD}╚═══════════════════════════════════════════════════════════╝${C_RESET}"
        echo ""
        return $status
    fi
    return 0
}

# 🎨 Decorative Separator
print_separator() {
    echo -ne "    ${C_DIM}"
    for i in {1..67}; do
        case $((i % 3)) in
            0) printf "${C_PURPLE}─" ;;
            1) printf "${C_CYAN}─" ;;
            2) printf "${C_PINK}─" ;;
        esac
    done
    echo -e "${C_RESET}"
}

# 🌟 Decorative Dot Line
print_dotline() {
    echo -ne "    ${C_DIM}"
    for i in {1..67}; do
        case $((i % 4)) in
            0) printf "${C_CYAN}·" ;;
            1) printf "${C_PURPLE}·" ;;
            2) printf "${C_PINK}·" ;;
            3) printf "${C_PURPLE_L}·" ;;
        esac
    done
    echo -e "${C_RESET}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📦 SYSTEM DEPENDENCIES
# ═══════════════════════════════════════════════════════════════════════════════

check_system_deps() {
    log_wrench "Scanning system for required dependencies..."
    local MISSING=""
    for cmd in curl git tar unzip; do
        if command -v "$cmd" > /dev/null 2>&1; then
            log_success "$cmd found"
        else
            log_warning "$cmd missing — will install"
            MISSING="$MISSING $cmd"
        fi
    done
    if [ -n "$MISSING" ]; then
        log_rocket "Installing missing packages:${C_BOLD}$MISSING"
        if command -v apt-get > /dev/null 2>&1; then
            sudo apt-get update -y -q > /dev/null 2>&1 || true
            sudo apt-get install -y $MISSING build-essential ca-certificates -q > /dev/null 2>&1 || true
        elif command -v yum > /dev/null 2>&1; then
            sudo yum install -y $MISSING make gcc-c++ ca-certificates unzip -q > /dev/null 2>&1 || true
        elif command -v dnf > /dev/null 2>&1; then
            sudo dnf install -y $MISSING make gcc-c++ ca-certificates unzip -q > /dev/null 2>&1 || true
        fi
    fi
    for cmd in curl git tar unzip; do
        command -v "$cmd" &> /dev/null || { log_error "$cmd still missing!"; return 1; }
    done
    log_success "All system dependencies satisfied! 🎯"
    return 0
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📥 DOWNLOAD ENGINE
# ═══════════════════════════════════════════════════════════════════════════════

download_panel_v180() {
    log_rocket "Connecting to GitHub repository..."
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.zip"
    local START_DIR=$(pwd)

    rm -rf "$WORK_DIR_NAME" "$GH_ARCHIVE" 2>/dev/null || true

    log_info "📦 Attempting direct archive download..."
    if ! curl -fsSL "$archive_url" -o "$GH_ARCHIVE" 2>/dev/null; then
        log_warning "Direct download failed, trying repository zip..."
        curl -fsSL "$main_archive_url" -o "/tmp/${GH_REPO}.zip" 2>/dev/null || return 1
        unzip -q -o "/tmp/${GH_REPO}.zip" -d /tmp/awp_extract 2>/dev/null || return 1
        local found=$(find /tmp/awp_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        [ -z "$found" ] && return 1
        cp "$found" "$GH_ARCHIVE" 2>/dev/null || return 1
        rm -rf /tmp/awp_extract "/tmp/${GH_REPO}.zip" 2>/dev/null || true
    fi

    [ -f "$GH_ARCHIVE" ] || { log_error "Archive not found!"; return 1; }
    log_success "Archive downloaded successfully! 📦"

    log_info "📂 Extracting files..."
    mkdir -p "$WORK_DIR_NAME"
    unzip -q -o "$GH_ARCHIVE" -d "$WORK_DIR_NAME" 2>/dev/null || return 1
    rm -f "$GH_ARCHIVE" 2>/dev/null || true

    log_info "🔍 Verifying panel package..."
    local actual_panel=$(find "$WORK_DIR_NAME" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)

    [ -z "$actual_panel" ] && { log_error "Panel package not found in archive!"; return 1; }

    local actual_dir=$(dirname "$actual_panel")
    if [ "$actual_dir" != "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
        rm -rf "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || true
        mv "$actual_dir" "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || return 1
    fi
    cd "$START_DIR" || return 1
    log_success "Panel files extracted and verified! ✅"
    return 0
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🐳 DOCKER & RUNTIME
# ═══════════════════════════════════════════════════════════════════════════════

install_docker() {
    if ! command -v docker &> /dev/null; then
        log_rocket "🐳 Installing Docker Engine..."
        curl -fsSL https://get.docker.com | sh > /dev/null 2>&1 || true
        if command -v systemctl &> /dev/null; then
            sudo systemctl enable --now docker > /dev/null 2>&1 || true
        elif command -v service &> /dev/null; then
            sudo service docker start > /dev/null 2>&1 || true
        fi
    fi
    [ -x "$(command -v docker)" ] && { log_success "Docker installed! 🐳"; return 0; }
    log_warning "Docker installation had issues"
    return 1
}

install_node() {
    log_rocket "📦 Setting up Node.js environment..."
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }

    if ! command -v nvm >/dev/null 2>&1; then
        log_info "📥 Installing NVM..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash > /dev/null 2>&1 || true
        export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }
    fi

    if command -v nvm >/dev/null 2>&1; then
        log_info "📥 Installing Node.js v20 via NVM..."
        nvm install 20 > /dev/null 2>&1 || true
        nvm use 20 > /dev/null 2>&1 || true
        nvm alias default 20 > /dev/null 2>&1 || true
    fi

    if ! command -v node &> /dev/null; then
        log_info "📥 Trying NodeSource setup..."
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1 || true
            sudo apt-get install -y nodejs > /dev/null 2>&1 || true
        fi
    fi

    command -v node &> /dev/null || { log_error "Node.js installation failed! 💔"; return 1; }
    log_success "Node.js $(node -v) ready! ⚡"
    command -v npm &> /dev/null || { log_error "npm not found!"; return 1; }
    return 0
}

install_java() {
    log_wrench "☕ Checking Java Runtime..."
    if command -v java > /dev/null 2>&1 && java -version > /dev/null 2>&1; then
        log_success "Java already installed! ☕"
        return 0
    fi
    log_info "📥 Installing Java JRE..."
    if command -v apt-get > /dev/null 2>&1; then
        sudo apt-get update -y -q > /dev/null 2>&1 || true
        sudo apt-get install -y -q openjdk-21-jre-headless > /dev/null 2>&1 || \
        sudo apt-get install -y -q openjdk-17-jre-headless > /dev/null 2>&1 || true
    fi
    log_success "Java Runtime installed! ☕"
    return 0
}

# ═══════════════════════════════════════════════════════════════════════════════
# ⚡ NODE ENVIRONMENT SETUP
# ═══════════════════════════════════════════════════════════════════════════════

setup_node_env() {
    local RUNTIME_PREF=$1
    install_node

    log_info "📦 Installing PM2 process manager..."
    if ! command -v pm2 &> /dev/null && [ ! -x "/usr/local/bin/pm2" ] && [ ! -x "./node_modules/.bin/pm2" ]; then
        sudo npm install -g pm2 > /dev/null 2>&1 || npm install -g pm2 > /dev/null 2>&1 || true
    fi
    log_success "PM2 installed! 🚀"

    local DEFAULT_RT="docker"
    local ENABLE_DOCKER="true"

    if [ "$RUNTIME_PREF" = "local" ]; then
        DEFAULT_RT="local"
        ENABLE_DOCKER="false"
        log_info "🏠 Local runtime mode selected"
    else
        log_info "🐳 Docker runtime mode selected"
        if ! command -v docker &> /dev/null; then
            install_docker 2>/dev/null || true
        fi
        if command -v systemctl &> /dev/null; then
            systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true
        fi
        if [ -S "/var/run/docker.sock" ]; then
            chmod 666 /var/run/docker.sock 2>/dev/null || sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
        fi
    fi

    log_wrench "📝 Generating PM2 ecosystem config..."
    cat << EOF2 > ecosystem.config.cjs
module.exports = {
  apps: [
    {
      name: "${MAIN_PROCESS}",
      script: "npm",
      args: "start",
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "production",
        PORT: ${MAIN_PORT},
        DEFAULT_RUNTIME: "${DEFAULT_RT}",
        ENABLE_DOCKER: "${ENABLE_DOCKER}",
        DOCKER_SOCKET_PATH: "/var/run/docker.sock"
      }
    }
  ]
};
EOF2
    log_success "Environment configured! ⚙️"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📦 DEPENDENCIES & BUILD
# ═══════════════════════════════════════════════════════════════════════════════

install_dependencies() {
    [ -f "package.json" ] || { log_error "package.json not found!"; return 1; }

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        log_error "Invalid package.json — wrong project detected!"
        head -3 package.json | sed 's/^/   /'
        return 1
    fi

    log_rocket "📥 Installing npm dependencies..."
    [ -f ".npmrc" ] || echo "legacy-peer-deps=true" > .npmrc
    rm -rf node_modules package-lock.json 2>/dev/null || true
    npm cache clean --force > /dev/null 2>&1 || true
    npm install --legacy-peer-deps --no-audit --no-fund 2>&1 | tail -5
    log_success "Dependencies installed! 📦"
}

build_application() {
    [ -f "package.json" ] || { log_error "package.json not found!"; return 1; }

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        log_error "Invalid package.json!"; return 1
    fi

    log_fire "🔨 Building application for production..."
    rm -rf dist 2>/dev/null || true
    NODE_OPTIONS="--max-old-space-size=2048" npm run build 2>&1 | tail -15

    [ -f "dist/server.cjs" ] || { log_error "Build failed — dist/server.cjs not found!"; return 1; }
    log_success "Build complete! 🏗️"
    return 0
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎮 PANEL CONTROL
# ═══════════════════════════════════════════════════════════════════════════════

stop_panel() {
    print_banner
    print_header "STOPPING ASTROWAX PANEL" "Gracefully shutting down all services..." "🛑"

    log_step "Terminating PM2 processes..."
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f $MAIN_CONTAINER 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true

    burst_animation "All services stopped"
    echo ""
    show_status
}

start_panel_node() {
    local TARGET=$1
    if command -v fuser &> /dev/null; then
        fuser -k ${MAIN_PORT}/tcp 2>/dev/null || true
    fi
    pkill -f "node.*server.cjs" 2>/dev/null || true

    run_pm2 delete "$TARGET" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true

    if command -v systemctl &> /dev/null; then
        systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true
    fi
    if [ -S "/var/run/docker.sock" ]; then
        chmod 666 /var/run/docker.sock 2>/dev/null || sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
    fi

    run_pm2 start ecosystem.config.cjs --only "$TARGET"
    run_pm2 save --force 2>/dev/null || true
}

start_panel() {
    print_banner
    print_header "STARTING ASTROWAX PANEL" "Powering up all services..." "🚀"

    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not found! Please install first. 📦"
        return 1
    fi
    cd "$PANEL_PATH" || return 1

    if [ ! -f "ecosystem.config.cjs" ]; then
        setup_node_env "docker"
    fi
    if [ ! -f "dist/server.cjs" ]; then
        install_dependencies
        build_application
    fi

    log_rocket "Starting PM2 process manager..."
    start_panel_node "$MAIN_PROCESS"

    log_step "⏳ Waiting for panel to become responsive..."
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 15 ]; do
        if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
            lightning_strike "PANEL IS ONLINE"
            echo ""
            show_status
            return 0
        fi
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    print_error_banner "Panel failed to start! 💔"
    run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true
    return 1
}

restart_panel() {
    print_banner
    print_header "RESTARTING ASTROWAX PANEL" "Refreshing all services..." "🔄"

    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not found! 📦"
        return 1
    fi
    cd "$PANEL_PATH" || return 1

    log_step "Restarting PM2 processes..."
    run_pm2 restart "$MAIN_PROCESS" 2>/dev/null || start_panel_node "$MAIN_PROCESS"
    run_pm2 save --force 2>/dev/null || true
    sleep 3

    if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
        lightning_strike "PANEL RESTARTED SUCCESSFULLY"
        echo ""
        show_status
        return 0
    fi
    print_error_banner "Restart failed! 💔"
    run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true
    return 1
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📊 STATUS DASHBOARD (Premium Edition)
# ═══════════════════════════════════════════════════════════════════════════════

show_status() {
    local MAIN_STATUS="OFFLINE"
    local SFTP_STATUS="OFFLINE"
    local VERSION_LABEL="${SELECTED_VERSION:-1.80}"
    local STATUS_COLOR="$C_RED"
    local STATUS_EMOJI="🔴"
    local MAIN_EMOJI="💀"

    if (run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -q "online") || \
       curl -s -m 2 http://127.0.0.1:${MAIN_PORT}/ >/dev/null 2>&1; then
        MAIN_STATUS="ONLINE"
        STATUS_COLOR="$C_GREEN_L"
        STATUS_EMOJI="🟢"
        MAIN_EMOJI="⚡"
    fi
    [ "$MAIN_STATUS" = "ONLINE" ] && SFTP_STATUS="ONLINE"

    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

    echo ""
    echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}              📊 ${C_CYAN_L}${C_BOLD}ASTROWAX PANEL STATUS DASHBOARD${C_RESET} 📊              ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╠═════════════════════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # Version & Author
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_DIM}🏷️  Version:${C_RESET}  ${C_WHITE}${C_BOLD}v${VERSION_LABEL} Ultra${C_RESET}"
    echo -e "                                                        ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_DIM}👤 Author:${C_RESET}   ${C_YELLOW}${C_BOLD}Itzytansh${C_RESET} ✨"
    echo -e "                                                      ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_DIM}🕐 Time:${C_RESET}     ${C_CYAN}$(date '+%Y-%m-%d %H:%M:%S %Z')${C_RESET}"
    echo -e "                                       ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    print_separator_inside
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # Main Panel Status
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${MAIN_EMOJI} ${C_BOLD}Main Panel:${C_RESET}  [${STATUS_COLOR}${C_BOLD}${MAIN_STATUS}${C_RESET}]"
    if [ "$MAIN_STATUS" = "ONLINE" ]; then
        echo -e "   ${C_CYAN_L}🔗 http://${IP}:${MAIN_PORT}${C_RESET}                    ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
        echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}               ${C_DIM}📋 Register: ${C_CYAN}http://${IP}:${MAIN_PORT}/register${C_RESET}"
        echo -e "           ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    else
        echo -e "   ${C_GRAY}💤 Not Running${C_RESET}                                        ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    fi

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # SFTP Status
    if [ "$SFTP_STATUS" = "ONLINE" ]; then
        echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  🔐 ${C_BOLD}SFTP Service:${C_RESET} [${C_GREEN_L}${C_BOLD}ONLINE${C_RESET}]  📡 Port ${SFTP_PORT}"
        echo -e "                                    ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    else
        echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  🔐 ${C_BOLD}SFTP Service:${C_RESET} [${C_RED}${C_BOLD}OFFLINE${C_RESET}]  ${C_DIM}💤${C_RESET}"
        echo -e "                                           ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    fi

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # Docker Status
    local DOCKER_STATUS="N/A"
    local DOCKER_EMOJI="🐳"
    if command -v docker &> /dev/null && docker info > /dev/null 2>&1; then
        DOCKER_STATUS="${C_GREEN_L}${C_BOLD}RUNNING${C_RESET}"
    elif command -v docker &> /dev/null; then
        DOCKER_STATUS="${C_YELLOW}${C_BOLD}INSTALLED${C_RESET}"
    else
        DOCKER_STATUS="${C_RED}${C_BOLD}NOT FOUND${C_RESET}"
    fi
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${DOCKER_EMOJI} ${C_BOLD}Docker:${C_RESET}  ${DOCKER_STATUS}"
    echo -e "                                                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # PM2 Status
    local PM2_COUNT=$(run_pm2 list 2>/dev/null | grep -c "online" || echo "0")
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  🚀 ${C_BOLD}PM2 Processes:${C_RESET}  ${C_CYAN_L}${PM2_COUNT} online${C_RESET}"
    echo -e "                                                     ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

# Helper: separator inside dashboard
print_separator_inside() {
    echo -ne "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_DIM}"
    for i in {1..65}; do
        case $((i % 3)) in
            0) printf "─" ;;
            1) printf "─" ;;
            2) printf "─" ;;
        esac
    done
    echo -e "${C_RESET}${C_PURPLE_L}${C_BOLD}║${C_RESET}"
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎯 VERSION SELECTOR
# ═══════════════════════════════════════════════════════════════════════════════

choose_version() {
    print_banner
    print_header "SELECT PANEL VERSION" "Choose your deployment target 🎯" "📋"

    echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} 🚀 ${C_BOLD}AstroWax Panel V1.80${C_RESET} ${C_GREEN_L}(Latest)${C_RESET}                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}⚡ Node 20 + PM2 + Docker${C_RESET}                                ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🔒 Production Ready • Secure${C_RESET}                               ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}💎 Full containerization${C_RESET}                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} 📦 ${C_BOLD}AstroWax Panel V1.0${C_RESET} ${C_DIM}(Legacy)${C_RESET}                           ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🗄️  Classic SQLite${C_RESET}                                         ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🪶 Lightweight deployment${C_RESET}                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_RED_L}${C_BOLD}[3]${C_RESET} 🔙 ${C_DIM}Back to Menu${C_RESET}                                           ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""

    local vc=""
    if [ -n "$VERSION_CHOICE" ]; then vc="$VERSION_CHOICE"
    elif [ ! -t 0 ]; then vc="1"
    else
        echo -ne "    ${C_CYAN}${C_BOLD}➜${C_RESET} ${C_BOLD}Enter choice [1-3]:${C_RESET} "
        read -r vc
    fi

    case "$vc" in
        1) SELECTED_VERSION="1.80"; burst_animation "Selected: V1.80 (Latest) 🚀" ;;
        2) SELECTED_VERSION="1.0"; burst_animation "Selected: V1.0 (Legacy) 📦" ;;
        3) return 1 ;;
        *) log_error "Invalid selection! ❌"; return 1 ;;
    esac
    echo ""
    sleep 0.3
    return 0
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🚀 INSTALLATION ENGINE V1.80
# ═══════════════════════════════════════════════════════════════════════════════

install_panel_v180() {
    print_banner

    local PANEL_PATH=$(find_panel_dir)

    if [ -z "$PANEL_PATH" ]; then
        print_header "DOWNLOADING PANEL V1.80" "Fetching latest release from GitHub... 📥" "⬇️"
        execute_step "📥 Downloading AstroWax Panel V1.80" download_panel_v180 || {
            print_error_banner "Download failed! Check your internet connection 💔"
            exit 1
        }
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi

    cd "$PANEL_PATH" || { log_error "Cannot enter panel directory! 📂"; exit 1; }
    log_gem "Working directory: ${C_CYAN_L}$(pwd)"

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        print_error_banner "Invalid package.json detected! 🚫"
        exit 1
    fi
    log_success "Package verified successfully! ✅"
    echo ""

    print_header "SELECT INSTALLATION MODE" "Choose your runtime environment ⚙️" "🔧"

    echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} 🐳 ${C_BOLD}Node.js + PM2 + Docker${C_RESET} ${C_GREEN_L}(Recommended)${C_RESET}                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🔒 Full containerization support${C_RESET}                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}⚡ Production optimized${C_RESET}                                     ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🛡️  Maximum security${C_RESET}                                        ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} 🏠 ${C_BOLD}Pure Local Node.js${C_RESET}                                       ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🪶 Lightweight deployment${C_RESET}                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}      ${C_GRAY_L}🚫 No Docker required${C_RESET}                                      ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_RED_L}${C_BOLD}[3]${C_RESET} 🔙 ${C_DIM}Back${C_RESET}                                                      ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"

    local MODE_CHOICE=""
    if [ -n "$RUN_CHOICE" ]; then MODE_CHOICE="$RUN_CHOICE"
    elif [ ! -t 0 ]; then MODE_CHOICE="1"
    else
        echo ""
        echo -ne "    ${C_CYAN}${C_BOLD}➜${C_RESET} ${C_BOLD}Enter choice [1-3]:${C_RESET} "
        read -r MODE_CHOICE
    fi

    [ "$MODE_CHOICE" = "3" ] && return 1
    if [ "$MODE_CHOICE" != "1" ] && [ "$MODE_CHOICE" != "2" ]; then
        log_error "Invalid selection! ❌"
        return 1
    fi

    mkdir -p .data backups
    if [ ! -f ".env" ]; then
        log_wrench "📝 Generating environment configuration..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
        else
            echo "PORT=${MAIN_PORT}" > .env
            echo "JWT_SECRET=$(head -c 32 /dev/urandom | base64 2>/dev/null || openssl rand -base64 32)" >> .env
        fi
        log_success "Environment configured! 🔐"
    fi

    print_header "INSTALLING V1.80" "Setting up production environment... 🏗️" "⚙️"

    execute_step "🔍 System Requirements Check" check_system_deps
    execute_step "☕ Java Runtime Environment" install_java

    local RUNTIME_ARG="docker"
    [ "$MODE_CHOICE" = "2" ] && RUNTIME_ARG="local"

    execute_step "⚡ Node.js v20 + PM2 Configuration" setup_node_env "$RUNTIME_ARG"
    execute_step "📦 Installing npm Dependencies" install_dependencies
    execute_step "🔨 Building Application" build_application
    execute_step "🚀 Starting PM2 Service" start_panel_node "$MAIN_PROCESS"

    log_step "⏳ Waiting for panel initialization..."
    local ATTEMPTS=0
    local OK=0
    while [ $ATTEMPTS -lt 30 ]; do
        if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
            OK=1; break
        fi
        if run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -qE "errored|stopped"; then
            print_error_banner "PM2 process crashed during startup! 💥"
            run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true
            return 1
        fi
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    if [ "$OK" != "1" ]; then
        print_error_banner "Panel failed to start within timeout! ⏰"
        run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true
        return 1
    fi

    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

    echo ""
    # 🎆🎉 ULTIMATE SUCCESS CELEBRATION 🎉🎆
    echo ""
    echo -e "    ${C_GREEN_X}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_GREEN_X}${C_BOLD}║${C_RESET}                                                                   ${C_GREEN_X}${C_BOLD}║${C_RESET}"
    echo -ne "    ${C_GREEN_X}${C_BOLD}║${C_RESET}      "
    echo -ne "🎉🎉🎉  ${C_WHITE}${C_BOLD}INSTALLATION COMPLETE${C_RESET}  🎉🎉🎉"
    echo -e "        ${C_GREEN_X}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_GREEN_X}${C_BOLD}║${C_RESET}                                                                   ${C_GREEN_X}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_GREEN_X}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""

    print_separator
    echo ""
    echo -e "    🌐 ${C_WHITE}${C_BOLD}Panel URL${C_RESET}      : ${C_CYAN_L}${C_UNDERLINE}http://${IP}:${MAIN_PORT}${C_RESET}"
    echo -e "    📝 ${C_WHITE}${C_BOLD}Register${C_RESET}       : ${C_CYAN_L}${C_UNDERLINE}http://${IP}:${MAIN_PORT}/register${C_RESET}"
    echo -e "    🏷️  ${C_WHITE}${C_BOLD}Version${C_RESET}        : ${C_PURPLE_L}${C_BOLD}AstroWax Panel V1.80 Ultra${C_RESET}"
    echo -e "    🐳 ${C_WHITE}${C_BOLD}Runtime${C_RESET}        : ${C_CYAN_L}$([ "$MODE_CHOICE" = "1" ] && echo "Docker + PM2" || echo "Local Node.js")${C_RESET}"
    echo -e "    🔐 ${C_WHITE}${C_BOLD}SFTP Port${C_RESET}      : ${C_CYAN_L}${SFTP_PORT}${C_RESET}"
    echo -e "    📡 ${C_WHITE}${C_BOLD}Panel Port${C_RESET}     : ${C_CYAN_L}${MAIN_PORT}${C_RESET}"
    echo ""
    print_separator
    echo ""
    echo -e "    ${C_YELLOW}${C_BOLD}⚡ PRO TIP: First user to register becomes OWNER automatically! ⚡${C_RESET}"
    echo ""
    echo -e "    ${C_DIM}💎 Made with ${C_RED}❤️ ${C_DIM}by ${C_YELLOW}${C_BOLD}Itzytansh${C_RESET} ${C_DIM}• Thank you for choosing AstroWax! 💎${C_RESET}"
    echo ""
    print_dotline
    echo ""

    show_status
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📦 LEGACY V1.0 INSTALLER
# ═══════════════════════════════════════════════════════════════════════════════

install_panel_v10() {
    print_banner
    print_header "INSTALLING V1.0 (LEGACY)" "Classic deployment mode 📦" "🗄️"

    echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} 🖥️  ${C_BOLD}Panel Only${C_RESET}                                                ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} 🔌 ${C_BOLD}Node Daemon Only${C_RESET}                                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[3]${C_RESET} 🔗 ${C_BOLD}BOTH (Panel + Daemon)${C_RESET}                                     ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_RED_L}${C_BOLD}[4]${C_RESET} 🔙 ${C_DIM}Back${C_RESET}                                                      ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"

    local V1_CHOICE=""
    if [ -n "$V1_INSTALL_CHOICE" ]; then V1_CHOICE="$V1_INSTALL_CHOICE"
    elif [ ! -t 0 ]; then V1_CHOICE="3"
    else
        echo ""
        echo -ne "    ${C_CYAN}${C_BOLD}➜${C_RESET} ${C_BOLD}Enter choice [1-4]:${C_RESET} "
        read -r V1_CHOICE
    fi

    case "$V1_CHOICE" in
        1) install_v10_panel ;;
        2) install_v10_node_daemon ;;
        3) install_v10_panel; echo ""; install_v10_node_daemon ;;
        4) return 0 ;;
        *) log_error "Invalid selection! ❌"; return 1 ;;
    esac
}

install_v10_panel() {
    echo ""
    log_rocket "Installing Panel V1.0..."
    echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config libsqlite3-dev sqlite3 && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/AstroWax-Panel && git clone https://github.com/AstroVoidHostDev/AstroWax-Panel ~/AstroWax-Panel && cd ~/AstroWax-Panel && unzip -oq panel.zip && cd panel && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps && npm install connect-sqlite3 sqlite3 && npm run seed && npm run createUser'
    echo ""
    print_success_banner "V1.0 Panel installed successfully!" "🎉"
    echo -e "    ▶️  ${C_WHITE}${C_BOLD}Run:${C_RESET} ${C_CYAN_L}${C_BOLD}cd ~/AstroWax-Panel/panel && node .${C_RESET}"
    echo ""
}

install_v10_node_daemon() {
    echo ""
    log_rocket "Installing Node Daemon V1.0..."
    echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git zip unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/WaxDaemon && git clone https://github.com/AstroVoidHostDev/WaxDaemon ~/WaxDaemon && cd ~/WaxDaemon && unzip -oq waxdaemon.zip && cd daemon/daemon && [ -f index.js.txt ] && mv index.js.txt index.js || true && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps'
    echo ""
    print_success_banner "Node Daemon installed successfully!" "🎉"
    echo -e "    ▶️  ${C_WHITE}${C_BOLD}Run:${C_RESET} ${C_CYAN_L}${C_BOLD}cd ~/WaxDaemon/daemon/daemon && node .${C_RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🔄 UPDATE ENGINE
# ═══════════════════════════════════════════════════════════════════════════════

update_panel() {
    print_banner
    print_header "UPDATING ASTROWAX PANEL" "Fetching latest version from GitHub... 📥" "🔄"

    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not installed! Please install first. 📦"
        return 1
    fi
    cd "$PANEL_PATH" || return 1
    log_gem "Updating installation at: ${C_CYAN_L}$(pwd)"
    echo ""

    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local temp_dir="/tmp/awp_update_$$"
    local new_dir="${temp_dir}/new"
    mkdir -p "$new_dir" || return 1

    execute_step "📥 Downloading latest version" bash -c "curl -fsSL '$archive_url' -o '/tmp/awp_update.zip'" || {
        print_error_banner "Download failed! Check internet connection 💔"
        rm -rf "$temp_dir"; return 1
    }

    log_info "📂 Extracting update package..."
    unzip -q -o "/tmp/awp_update.zip" -d "$new_dir" 2>/dev/null || {
        log_error "Extraction failed! 💔"
        rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    }

    local found=$(find "$new_dir" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)

    if [ -z "$found" ]; then
        log_error "Panel not found in update package! 🔍"
        rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    fi
    local actual_new_root=$(dirname "$found")

    log_step "🛑 Stopping current panel..."
    run_pm2 stop "$MAIN_PROCESS" 2>/dev/null || true

    log_lock "🔒 Preserving user data..."
    local PRESERVE_DIR="/tmp/awp_preserve_$$"
    mkdir -p "$PRESERVE_DIR"
    [ -f ".env" ] && cp ".env" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d ".data" ] && cp -r ".data" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d "backups" ] && cp -r "backups" "$PRESERVE_DIR/" 2>/dev/null || true

    local BACKUP_NAME="astrowax-backup-$(date +%Y%m%d_%H%M%S)"
    tar -czf "$BACKUP_NAME.tar.gz" --exclude=node_modules --exclude=.git . 2>/dev/null || true
    log_success "Backup created: ${C_CYAN_L}📦 ${BACKUP_NAME}.tar.gz"

    log_step "⬆️  Applying updates..."
    rm -rf src server public 2>/dev/null || true
    rm -f package.json package-lock.json index.html vite.config.ts tsconfig.json server.ts ecosystem.config.cjs 2>/dev/null || true
    cp -r "$actual_new_root"/* . 2>/dev/null || true

    [ -f "$PRESERVE_DIR/.env" ] && cp "$PRESERVE_DIR/.env" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/.data" ] && cp -r "$PRESERVE_DIR/.data" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/backups" ] && cp -r "$PRESERVE_DIR/backups" . 2>/dev/null || true
    rm -rf "$PRESERVE_DIR"

    echo ""
    execute_step "📦 Reinstalling Dependencies" install_dependencies
    execute_step "🔨 Rebuilding Application" build_application
    execute_step "🚀 Restarting Panel" start_panel_node "$MAIN_PROCESS"

    log_step "⏳ Waiting for services to stabilize..."
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 20 ]; do
        curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && break
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    rm -rf "$temp_dir" "/tmp/awp_update.zip"

    print_success_banner "UPDATE COMPLETE!" "✅"
    show_status
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🗑️ UNINSTALLER
# ═══════════════════════════════════════════════════════════════════════════════

uninstall_panel() {
    print_banner
    print_header "UNINSTALL ASTROWAX PANEL" "Removing all components permanently..." "🗑️"

    print_warning_banner "THIS WILL PERMANENTLY REMOVE ASTROWAX PANEL!"
    echo -e "    ${C_RED}${C_BOLD}⚠️  All data, configurations, and services will be deleted ⚠️${C_RESET}"
    echo -e "    ${C_RED}${C_BOLD}⚠️  This action cannot be undone! ⚠️${C_RESET}"
    echo ""

    if [ -t 0 ]; then
        echo -ne "    ${C_RED}${C_BOLD}➜${C_RESET} ${C_BOLD}Type ${C_WHITE}'yes'${C_RESET} ${C_BOLD}to confirm destruction:${C_RESET} "
        read -r CONFIRM
        [ "$CONFIRM" != "yes" ] && { echo -e "    ${C_YELLOW}🛡️  Operation cancelled — your data is safe!${C_RESET}"; return 0; }
    fi

    echo ""
    log_step "🛑 Stopping all services..."
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete "astrowax-admin" 2>/dev/null || true
    run_pm2 delete "astrowax-panel" 2>/dev/null || true
    run_pm2 save --force 2>/dev/null || true

    local DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f "astrowax-main" 2>/dev/null || true
    $DOCKER_CLI rm -f "astrowax-admin" 2>/dev/null || true

    pkill -f "node.*dist/server.cjs" 2>/dev/null || true
    pkill -f "astrowax" 2>/dev/null || true

    burst_animation "Services terminated"
    echo ""

    local DELETE_DATA="n"
    if [ -t 0 ]; then
        echo -ne "    ${C_YELLOW}${C_BOLD}➜${C_RESET} ${C_BOLD}Also delete panel files? (y/N):${C_RESET} "
        read -r DELETE_DATA
    fi

    if [ "$DELETE_DATA" = "y" ] || [ "$DELETE_DATA" = "Y" ]; then
        log_step "🗑️  Removing all files..."
        cd "$HOME" || cd /tmp || true

        local PANEL_PATH=$(find_panel_dir)
        [ -n "$PANEL_PATH" ] && rm -rf "$PANEL_PATH" 2>/dev/null || true

        for path in "$HOME/$WORK_DIR_NAME" "$HOME/panel" "$HOME/astrowax-panel" "$HOME/AstroWax-Panel" "$HOME/WaxDaemon"; do
            [ -d "$path" ] && rm -rf "$path" 2>/dev/null || true
        done

        rm -rf /tmp/awp_* /tmp/astrowax* 2>/dev/null || true

        log_success "All files removed! 🗑️"
    else
        log_info "📁 Files preserved for future use"
    fi

    echo ""
    print_success_banner "UNINSTALL COMPLETE!" "✅"
    echo -e "    ${C_DIM}👋 Thank you for using AstroWax Panel!${C_RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🎮 COMMAND LINE PARSER
# ═══════════════════════════════════════════════════════════════════════════════

for arg in "$@"; do
    case "$arg" in
        --version=1.0|--v=1.0|-v1.0) VERSION_CHOICE="2" ;;
        --version=1.80|--v=1.80|-v1.80) VERSION_CHOICE="1" ;;
        --v1-install=panel) V1_INSTALL_CHOICE="1" ;;
        --v1-install=node) V1_INSTALL_CHOICE="2" ;;
        --v1-install=both) V1_INSTALL_CHOICE="3" ;;
    esac
done

case "$1" in
    install|main)
        if choose_version; then
            if [ "$SELECTED_VERSION" = "1.0" ]; then install_panel_v10
            else install_panel_v180; fi
        fi
        exit 0
        ;;
    update)    update_panel; exit 0 ;;
    uninstall) uninstall_panel; exit 0 ;;
    start)     start_panel; exit 0 ;;
    stop)      stop_panel; exit 0 ;;
    restart)   restart_panel; exit 0 ;;
    status)    show_status; exit 0 ;;
esac

# ═══════════════════════════════════════════════════════════════════════════════
# 🎨 INTERACTIVE MEGA MENU
# ═══════════════════════════════════════════════════════════════════════════════

while true; do
    print_banner

    echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}          🎮 ${C_CYAN_L}${C_BOLD}ASTROWAX PANEL CONTROLLER${C_RESET} 🎮                       ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                  ${C_DIM}Your Command Center${C_RESET} 🚀                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╠═════════════════════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} 📥 ${C_BOLD}Install Panel${C_RESET}     ${C_DIM}— Deploy a fresh installation${C_RESET}             ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} 🔄 ${C_BOLD}Update Panel${C_RESET}      ${C_DIM}— Upgrade to latest version${C_RESET}              ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_GREEN_L}${C_BOLD}[3]${C_RESET} 🚀 ${C_BOLD}Start Panel${C_RESET}       ${C_DIM}— Power up your panel${C_RESET}                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_RED_L}${C_BOLD}[4]${C_RESET} 🛑 ${C_BOLD}Stop Panel${C_RESET}        ${C_DIM}— Gracefully shutdown${C_RESET}                    ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_YELLOW}${C_BOLD}[5]${C_RESET} 🔄 ${C_BOLD}Restart Panel${C_RESET}     ${C_DIM}— Refresh all services${C_RESET}                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[6]${C_RESET} 📊 ${C_BOLD}Show Status${C_RESET}       ${C_DIM}— View system dashboard${C_RESET}                  ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_ORANGE}${C_BOLD}[7]${C_RESET} 🗑️  ${C_BOLD}Uninstall Panel${C_RESET}   ${C_DIM}— Remove everything${C_RESET}                     ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_GRAY_L}${C_BOLD}[8]${C_RESET} 👋 ${C_DIM}Exit${C_RESET}              ${C_DIM}— Leave the control center${C_RESET}                ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"

    echo ""
    echo -e "    ${C_DIM}🏷️  AstroWax Panel v1.80 Ultra • Crafted with ${C_RED}❤️${C_RESET} ${C_DIM}by ${C_YELLOW}${C_BOLD}Itzytansh${C_RESET} ${C_DIM}• 💎 Premium${C_RESET}"
    echo ""

    echo -ne "    ${C_CYAN}${C_BOLD}➜${C_RESET} ${C_BOLD}Enter choice [1-8]:${C_RESET} "
    if ! read -r CHOICE; then
        echo ""
        break
    fi

    case "$CHOICE" in
        1)
            if choose_version; then
                if [ "$SELECTED_VERSION" = "1.0" ]; then install_panel_v10
                else install_panel_v180; fi
            fi
            if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi
            ;;
        2) update_panel; if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi ;;
        3) start_panel; if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi ;;
        4) stop_panel; if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi ;;
        5) restart_panel; if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi ;;
        6) show_status; if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi ;;
        7) uninstall_panel; if [ -t 0 ]; then echo ""; echo -ne "    ${C_GRAY_L}⏎  Press Enter to continue...${C_RESET}"; read -r || true; fi ;;
        8)
            echo ""
            echo -e "    ${C_PURPLE_L}${C_BOLD}╔═════════════════════════════════════════════════════════════════════╗${C_RESET}"
            echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
            echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}         👋 ${C_CYAN_L}${C_BOLD}Goodbye! Thank you for using AstroWax Panel!${C_RESET} 👋       ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
            echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                   ${C_DIM}Made with ${C_RED}❤️${C_RESET}${C_DIM} by ${C_YELLOW}${C_BOLD}Itzytansh${C_RESET} 💎                       ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
            echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                                   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
            echo -e "    ${C_PURPLE_L}${C_BOLD}╚═════════════════════════════════════════════════════════════════════╝${C_RESET}"
            echo ""
            exit 0
            ;;
        *)
            log_error "Invalid option! Please choose 1-8 ❌"
            sleep 1.5
            ;;
    esac
done
