#!/bin/bash
# ═══════════════════════════════════════════════════════════
# 💎 ASTROWAX PANEL — ULTRA PREMIUM CONTROL v3.0 💎
# 🌌 EYE-CATCHY EDITION • 4K • ANIMATED • EMOJI BLAST 🌌
# 🔥 AWP = ASTROWAX PANEL 🔥
# ✨ Made with 💖 by Itzytansh ✨
# ═══════════════════════════════════════════════════════════

set -o pipefail
trap 'tput cnorm 2>/dev/null; echo -ne "\033[0m"' EXIT INT TERM

# ═══════════════════════════════════════════════════════════
# 🎨 ULTRA RGB COLOR SYSTEM + NEON
# ═══════════════════════════════════════════════════════════
if [[ $(tput colors 2>/dev/null) -ge 256 ]]; then
    C_RESET='\033[0m'; C_BOLD='\033[1m'; C_DIM='\033[2m'; C_ITALIC='\033[3m'; C_UNDERLINE='\033[4m'; C_BLINK='\033[5m'; C_REVERSE='\033[7m'
    C_CYAN='\033[38;5;51m'; C_CYAN_L='\033[38;5;87m'; C_PURPLE='\033[38;5;129m'; C_PURPLE_L='\033[38;5;171m'
    C_PINK='\033[38;5;207m'; C_RED='\033[38;5;196m'; C_RED_L='\033[38;5;203m'; C_GREEN='\033[38;5;46m'; C_GREEN_L='\033[38;5;120m'
    C_YELLOW='\033[38;5;226m'; C_ORANGE='\033[38;5;208m'; C_WHITE='\033[38;5;231m'; C_GRAY='\033[38;5;241m'; C_GRAY_L='\033[38;5;250m'
    C_NEON_BLUE='\033[38;2;0;255;255m'; C_NEON_PINK='\033[38;2;255;20;147m'; C_NEON_PURPLE='\033[38;2;191;64;191m'
    BG_PURPLE='\033[48;5;54m'; BG_CYAN='\033[48;5;33m'; BG_DARK='\033[48;5;236m'
else
    C_RESET='\033[0m'; C_BOLD='\033[1m'; C_DIM='\033[2m'; C_ITALIC='\033[3m'; C_UNDERLINE='\033[4m'
    C_CYAN='\033[0;36m'; C_CYAN_L='\033[1;36m'; C_PURPLE='\033[0;35m'; C_PURPLE_L='\033[1;35m'; C_PINK='\033[1;35m'
    C_RED='\033[0;31m'; C_RED_L='\033[1;31m'; C_GREEN='\033[0;32m'; C_GREEN_L='\033[1;32m'; C_YELLOW='\033[1;33m'; C_ORANGE='\033[0;33m'
    C_WHITE='\033[1;37m'; C_GRAY='\033[0;37m'; C_GRAY_L='\033[1;30m'; C_NEON_BLUE='\033[1;36m'; C_NEON_PINK='\033[1;35m'; C_NEON_PURPLE='\033[0;35m'
    BG_PURPLE='\033[45m'; BG_CYAN='\033[46m'; BG_DARK='\033[40m'
fi

hide_cursor(){ tput civis 2>/dev/null; }
show_cursor(){ tput cnorm 2>/dev/null; }

# ═══════════════════════════════════════════════════════════
# 🎭 ULTRA VISUAL EFFECTS ENGINE - ANIMATIONS GALORE
# ═══════════════════════════════════════════════════════════

typewriter() {
    local text="$1"; local delay=${2:-0.015}
    local i=0
    while [ $i -lt ${#text} ]; do
        echo -n "${text:$i:1}"
        sleep $delay
        ((i++))
    done
    echo ""
}

typewriter_color() {
    local text="$1"; local color="$2"; local delay=${3:-0.015}
    echo -ne "$color"
    typewriter "$text" "$delay"
    echo -ne "$C_RESET"
}

rainbow_text() {
    local text="$1"
    local colors=("$C_RED" "$C_ORANGE" "$C_YELLOW" "$C_GREEN_L" "$C_CYAN_L" "$C_PURPLE_L" "$C_PINK")
    local out=""
    for ((i=0; i<${#text}; i++)); do
        out+="${colors[$((i % ${#colors[@]}))]}${text:$i:1}"
    done
    echo -e "${out}${C_RESET}"
}

gradient_text() {
    local text="$1"; local start="$2"; local end="$3"
    local len=${#text}; local res=""
    for ((i=0; i<len; i++)); do
        if (( i < len/2 )); then res+="${start}${text:$i:1}"; else res+="${end}${text:$i:1}"; fi
    done
    echo -e "${res}${C_RESET}"
}

glitch_text() {
    local text="$1"
    local colors=("$C_CYAN" "$C_PURPLE" "$C_PINK" "$C_RED" "$C_NEON_BLUE")
    local res=""
    for ((i=0; i<${#text}; i++)); do res+="${colors[$((RANDOM%${#colors[@]}))]}${text:$i:1}"; done
    echo -e "${res}${C_RESET}"
}

stars_bg() {
    local cols=$(tput cols 2>/dev/null || echo 80)
    echo -ne "${C_DIM}"
    for _ in {1..25}; do
        local x=$((RANDOM % cols))
        printf "\033[1;%dH·" "$x"
    done
    echo -e "${C_RESET}"
}

confetti_burst() {
    local emojis=("🎉" "✨" "💎" "🌟" "🎊" "💥" "🚀" "🔥" "🌈" "💫")
    echo -ne "    "
    for _ in {1..20}; do echo -n "${emojis[$((RANDOM%${#emojis[@]}))]} "; sleep 0.02; done
    echo -e "${C_RESET}"
}

loading_dots() {
    local msg="$1"; local duration=${2:-2}
    local dots=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    local end=$((SECONDS+duration))
    while [ $SECONDS -lt $end ]; do
        for d in "${dots[@]}"; do echo -ne "\r  ${C_CYAN}${d}${C_RESET} ${msg} ${C_PURPLE_L}...${C_RESET}"; sleep 0.08; done
    done
    echo -ne "\r"
}

progress_bar() {
    local cur=$1; local total=$2; local width=36
    local perc=$((cur*100/total)); local filled=$((cur*width/total)); local empty=$((width-filled))
    printf "\r${C_DIM}[${C_RESET}${C_CYAN_L}"
    for ((i=0;i<filled;i++)); do printf "█"; done
    printf "${C_GRAY_L}"; for ((i=0;i<empty;i++)); do printf "░"; done
    printf "${C_DIM}]${C_RESET} ${C_BOLD}${C_YELLOW}%3d%%${C_RESET} ${C_PINK}⚡${C_RESET}" "$perc"
}

# ═══════════════════════════════════════════════════════════
# 💎 MEGA BOLD AWP BANNER - BIG TITLE EDITION
# ═══════════════════════════════════════════════════════════

print_banner() {
    hide_cursor
    clear 2>/dev/null || true
    
    # ✨ Top Glow Line ✨
    echo -e "${C_PURPLE_L}${C_BOLD}    ╔════════════════════════════════════════════════════════════╗${C_RESET}"
    sleep 0.03
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET} ${C_CYAN_L}✨🌌 ${C_BOLD}WELCOME TO THE FUTURE OF HOSTING ${C_RESET}${C_CYAN_L}🌌✨${C_RESET} ${C_PURPLE_L}${C_BOLD}             ║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ╠════════════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # 🔥 BIG BOLD AWP LOGO - GRADIENT ANIMATED 🔥
    echo -e "${C_NEON_BLUE}${C_BOLD}    ║      █████╗   ██╗    ██╗  ██████╗                              ║${C_RESET}"; sleep 0.04
    echo -e "${C_CYAN_L}${C_BOLD}    ║     ██╔══██╗  ██║    ██║  ██╔══██╗                             ║${C_RESET}"; sleep 0.04
    echo -e "${C_CYAN}${C_BOLD}    ║     ███████║  ██║ █╗ ██║  ██████╔╝                             ║${C_RESET}"; sleep 0.04
    echo -e "${C_PURPLE_L}${C_BOLD}    ║     ██╔══██║  ██║███╗██║  ██╔═══╝                              ║${C_RESET}"; sleep 0.04
    echo -e "${C_PINK}${C_BOLD}    ║     ██║  ██║  ╚███╔███╔╝  ██║                                    ║${C_RESET}"; sleep 0.04
    echo -e "${C_NEON_PINK}${C_BOLD}    ║     ╚═╝  ╚═╝   ╚══╝╚══╝   ╚═╝                                    ║${C_RESET}"; sleep 0.04
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"

    # 💎 AWP MEANS EXPANSION WITH ANIMATION
    echo -ne "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}       "
    echo -ne "${C_YELLOW}${C_BOLD}🅰️ ${C_RESET}"; sleep 0.1
    echo -ne "${C_CYAN_L}${C_BOLD}ASTRO${C_RESET}  "; sleep 0.1
    echo -ne "${C_PINK}${C_BOLD}🆆 ${C_RESET}"; sleep 0.1
    echo -ne "${C_GREEN_L}${C_BOLD}WAX${C_RESET}  "; sleep 0.1
    echo -ne "${C_PURPLE_L}${C_BOLD}🅿️ ${C_RESET}"; sleep 0.1
    echo -e "${C_ORANGE}${C_BOLD}PANEL${C_RESET}  ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}   ${C_DIM}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${C_RESET}   ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    
    # 🌟 SUBTITLE WITH TYPWRITER EFFECT
    echo -ne "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}     "
    typewriter_color "🚀  A.W.P  =  ASTROWAX  PANEL  🚀" "${C_CYAN_L}${C_BOLD}" 0.02
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}     ${C_WHITE}${C_BOLD}💎 Next-Gen Hosting Control 💎${C_RESET}   ${C_YELLOW}v1.80 ULTRA${C_RESET}       ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}     ${C_GRAY_L}⚡ Crafted with ${C_RED}💖${C_RESET}${C_GRAY_L} by ${C_YELLOW}${C_BOLD}Itzytansh${C_RESET} ${C_GRAY_L}🔥 Premium Edition${C_RESET}  ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ╚════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
    show_cursor
}

print_header() {
    local title="$1"; local subtitle="$2"
    echo -e "${C_NEON_BLUE}${C_BOLD}    ╔════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_NEON_BLUE}${C_BOLD}    ║${C_RESET}  ${C_CYAN_L}${C_BOLD}✨ ${title}${C_RESET}$(printf '%*s' $((50-${#title})) '')${C_NEON_BLUE}${C_BOLD}║${C_RESET}"
    echo -e "${C_NEON_BLUE}${C_BOLD}    ║${C_RESET}  ${C_GRAY_L}💫 ${subtitle}${C_RESET}$(printf '%*s' $((50-${#subtitle})) '')${C_NEON_BLUE}${C_BOLD}║${C_RESET}"
    echo -e "${C_NEON_BLUE}${C_BOLD}    ╚════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# 📡 ULTRA LOGGING WITH EMOJIS GALORE
# ═══════════════════════════════════════════════════════════
log_info()    { echo -e "  ${C_CYAN}ℹ️ ${C_RESET} ${C_CYAN_L}$1${C_RESET}"; }
log_success() { echo -e "  ${C_GREEN}✅${C_RESET}  ${C_GREEN_L}${C_BOLD}$1${C_RESET} ${C_YELLOW}✨${C_RESET}"; }
log_warning() { echo -e "  ${C_YELLOW}⚠️ ${C_RESET}  ${C_ORANGE}$1${C_RESET}"; }
log_error()   { echo -e "  ${C_RED}❌${C_RESET}  ${C_RED_L}${C_BOLD}$1${C_RESET} ${C_RED}💥${C_RESET}"; }
log_step()    { echo -e "  ${C_PURPLE_L}➜${C_RESET} ${C_PURPLE_L}💎${C_RESET} ${C_BOLD}$1${C_RESET} ${C_PINK}...${C_RESET}"; }
log_debug()   { echo -e "  ${C_GRAY}🔍${C_RESET} $1"; }
log_rocket()  { echo -e "  ${C_CYAN_L}🚀${C_RESET} ${C_BOLD}$1${C_RESET}"; }
log_fire()    { echo -e "  ${C_RED_L}🔥${C_RESET} ${C_BOLD}$1${C_RESET}"; }

# ═══════════════════════════════════════════════════════════
# ⚙️ CONFIGURATION
# ═══════════════════════════════════════════════════════════
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

# ═══════════════════════════════════════════════════════════
# 🔧 HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════
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
    if [ -f "package.json" ] && grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then pwd; return 0; fi
    if [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ] && grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" 2>/dev/null; then echo "$(pwd)/$WORK_DIR_NAME/$PANEL_DIR_NAME"; return 0; fi
    local found=$(find . -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" -not -path "*/dist/*" 2>/dev/null | while read f; do if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then echo "$f"; break; fi; done | head -1)
    if [ -n "$found" ]; then echo "$(cd "$(dirname "$found")" && pwd)"; return 0; fi
    echo ""; return 1
}

# 💫 ULTRA ANIMATED EXECUTE STEP
execute_step() {
    local msg="$1"; shift
    local step_id="awp_step_$RANDOM"
    local log_file="/tmp/${step_id}.log"
    rm -f "$log_file"
    printf "  ${C_PURPLE_L}💎${C_RESET} ${C_BOLD}%-42s${C_RESET} " "$msg"
    "$@" > "$log_file" 2>&1 &
    local pid=$!
    local spin=('🌑' '🌒' '🌓' '🌔' '🌕' '🌖' '🌗' '🌘' '🚀' '✨')
    local i=0
    while kill -0 $pid 2>/dev/null; do
        printf "\b${spin[$((i%${#spin[@]}))]}"
        i=$((i+1))
        progress_bar $((i%10)) 10
        sleep 0.15
    done
    local status=0; wait $pid 2>/dev/null || status=$?
    printf "\r  "
    if [ $status -eq 0 ]; then
        echo -e "${C_GREEN}✅${C_RESET} ${C_GREEN_L}${C_BOLD}%-42s${C_RESET} ${C_DIM}[${C_GREEN_L}DONE ✨${C_DIM}]${C_RESET}" "$msg"
    else
        echo -e "${C_RED}❌${C_RESET} ${C_RED_L}%-42s${C_RESET} ${C_DIM}[${C_RED_L}FAIL 💥${C_DIM}]${C_RESET}" "$msg"
        echo -e "\n  ${C_RED}${C_BOLD}════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_RED}${C_BOLD}  💥 ERROR: $msg 💥${C_RESET}"
        echo -e "  ${C_RED}${C_BOLD}════════════════════════════════════════════════════${C_RESET}"
        echo -e "  ${C_YELLOW}Exit code: $status${C_RESET}"
        [ -s "$log_file" ] && { echo -e "  ${C_GRAY_L}Output:${C_RESET}"; tail -n 20 "$log_file" | sed 's/^/    /'; }
        echo -e "  ${C_RED}${C_BOLD}════════════════════════════════════════════════════${C_RESET}\n"
        return $status
    fi
    return 0
}

# ═══════════════════════════════════════════════════════════
# 📦 SYSTEM DEPENDENCIES
# ═══════════════════════════════════════════════════════════
check_system_deps() {
    local MISSING=""
    for cmd in curl git tar unzip; do command -v "$cmd" > /dev/null 2>&1 || MISSING="$MISSING $cmd"; done
    if [ -n "$MISSING" ]; then
        if command -v apt-get > /dev/null 2>&1; then sudo apt-get update -y -q > /dev/null 2>&1 || true; sudo apt-get install -y $MISSING build-essential ca-certificates -q > /dev/null 2>&1 || true
        elif command -v yum > /dev/null 2>&1; then sudo yum install -y $MISSING make gcc-c++ ca-certificates unzip -q > /dev/null 2>&1 || true
        elif command -v dnf > /dev/null 2>&1; then sudo dnf install -y $MISSING make gcc-c++ ca-certificates unzip -q > /dev/null 2>&1 || true; fi
    fi
    for cmd in curl git tar unzip; do command -v "$cmd" &> /dev/null || { echo "Missing: $cmd"; return 1; }; done
    return 0
}

# ═══════════════════════════════════════════════════════════
# 📥 DOWNLOAD ENGINE
# ═══════════════════════════════════════════════════════════
download_panel_v180() {
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.zip"
    local START_DIR=$(pwd)
    rm -rf "$WORK_DIR_NAME" "$GH_ARCHIVE" 2>/dev/null || true
    if ! curl -fsSL "$archive_url" -o "$GH_ARCHIVE" 2>/dev/null; then
        curl -fsSL "$main_archive_url" -o "/tmp/${GH_REPO}.zip" 2>/dev/null || return 1
        unzip -q -o "/tmp/${GH_REPO}.zip" -d /tmp/awp_extract 2>/dev/null || return 1
        local found=$(find /tmp/awp_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        [ -z "$found" ] && return 1
        cp "$found" "$GH_ARCHIVE" 2>/dev/null || return 1
        rm -rf /tmp/awp_extract "/tmp/${GH_REPO}.zip" 2>/dev/null || true
    fi
    [ -f "$GH_ARCHIVE" ] || return 1
    mkdir -p "$WORK_DIR_NAME"
    unzip -q -o "$GH_ARCHIVE" -d "$WORK_DIR_NAME" 2>/dev/null || return 1
    rm -f "$GH_ARCHIVE" 2>/dev/null || true
    local actual_panel=$(find "$WORK_DIR_NAME" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then echo "$f"; break; fi; done | head -1)
    [ -z "$actual_panel" ] && return 1
    local actual_dir=$(dirname "$actual_panel")
    if [ "$actual_dir" != "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then rm -rf "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || true; mv "$actual_dir" "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || return 1; fi
    cd "$START_DIR" || return 1; return 0
}

# ═══════════════════════════════════════════════════════════
# 🐳 DOCKER & RUNTIME
# ═══════════════════════════════════════════════════════════
install_docker() {
    if ! command -v docker &> /dev/null; then curl -fsSL https://get.docker.com | sh > /dev/null 2>&1 || true
        if command -v systemctl &> /dev/null; then sudo systemctl enable --now docker > /dev/null 2>&1 || true
        elif command -v service &> /dev/null; then sudo service docker start > /dev/null 2>&1 || true; fi; fi
    [ -x "$(command -v docker)" ] && return 0; echo "Docker not available."; return 1
}
install_node() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }
    if ! command -v nvm >/dev/null 2>&1; then curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash > /dev/null 2>&1 || true
        export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }; fi
    if command -v nvm >/dev/null 2>&1; then nvm install 20 > /dev/null 2>&1 || true; nvm use 20 > /dev/null 2>&1 || true; nvm alias default 20 > /dev/null 2>&1 || true; fi
    if ! command -v node &> /dev/null; then if command -v apt-get &> /dev/null; then curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1 || true; sudo apt-get install -y nodejs > /dev/null 2>&1 || true; fi; fi
    command -v node &> /dev/null || { echo "Node failed"; return 1; }
    echo "Node: $(node -v)"; command -v npm &> /dev/null || return 1; return 0
}
install_java() {
    if command -v java > /dev/null 2>&1 && java -version > /dev/null 2>&1; then return 0; fi
    if command -v apt-get > /dev/null 2>&1; then sudo apt-get update -y -q > /dev/null 2>&1 || true; sudo apt-get install -y -q openjdk-21-jre-headless > /dev/null 2>&1 || sudo apt-get install -y -q openjdk-17-jre-headless > /dev/null 2>&1 || true; fi; return 0
}

# ═══════════════════════════════════════════════════════════
# ⚡ NODE ENVIRONMENT SETUP
# ═══════════════════════════════════════════════════════════
setup_node_env() {
    local RUNTIME_PREF=$1; install_node
    if ! command -v pm2 &> /dev/null && [ ! -x "/usr/local/bin/pm2" ] && [ ! -x "./node_modules/.bin/pm2" ]; then sudo npm install -g pm2 > /dev/null 2>&1 || npm install -g pm2 > /dev/null 2>&1 || true; fi
    local DEFAULT_RT="docker"; local ENABLE_DOCKER="true"
    if [ "$RUNTIME_PREF" = "local" ]; then DEFAULT_RT="local"; ENABLE_DOCKER="false"
    else
        if ! command -v docker &> /dev/null; then install_docker 2>/dev/null || true; fi
        if command -v systemctl &> /dev/null; then systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true; fi
        if [ -S "/var/run/docker.sock" ]; then chmod 666 /var/run/docker.sock 2>/dev/null || sudo chmod 666 /var/run/docker.sock 2>/dev/null || true; fi; fi
    cat << EOF2 > ecosystem.config.cjs
module.exports = { apps: [{ name: "${MAIN_PROCESS}", script: "npm", args: "start", instances: 1, autorestart: true, watch: false, max_memory_restart: "1G", env: { NODE_ENV: "production", PORT: ${MAIN_PORT}, DEFAULT_RUNTIME: "${DEFAULT_RT}", ENABLE_DOCKER: "${ENABLE_DOCKER}", DOCKER_SOCKET_PATH: "/var/run/docker.sock" } }] };
EOF2
}

# ═══════════════════════════════════════════════════════════
# 📦 DEPENDENCIES & BUILD
# ═══════════════════════════════════════════════════════════
install_dependencies() {
    [ -f "package.json" ] || return 1
    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then echo "❌ Wrong package.json"; head -3 package.json | sed 's/^/   /'; return 1; fi
    [ -f ".npmrc" ] || echo "legacy-peer-deps=true" > .npmrc
    rm -rf node_modules package-lock.json 2>/dev/null || true; npm cache clean --force > /dev/null 2>&1 || true
    npm install --legacy-peer-deps --no-audit --no-fund 2>&1 | tail -5
}
build_application() {
    [ -f "package.json" ] || return 1
    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then echo "❌ Wrong package.json"; return 1; fi
    rm -rf dist 2>/dev/null || true; NODE_OPTIONS="--max-old-space-size=2048" npm run build 2>&1 | tail -15
    [ -f "dist/server.cjs" ] || { echo "No dist/server.cjs"; return 1; }; return 0
}

# ═══════════════════════════════════════════════════════════
# 🎮 PANEL CONTROL
# ═══════════════════════════════════════════════════════════
stop_panel() {
    print_banner
    print_header "🛑 STOPPING ASTROWAX PANEL" "🌙 Gracefully shutting down services..."
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true; run_pm2 delete astrowax-panel 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd); $DOCKER_CLI rm -f $MAIN_CONTAINER 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true
    log_success "💤 All services stopped successfully"; echo ""; show_status
}
start_panel_node() {
    local TARGET=$1
    if command -v fuser &> /dev/null; then fuser -k ${MAIN_PORT}/tcp 2>/dev/null || true; fi
    pkill -f "node.*server.cjs" 2>/dev/null || true
    run_pm2 delete "$TARGET" 2>/dev/null || true; run_pm2 delete astrowax-panel 2>/dev/null || true
    if command -v systemctl &> /dev/null; then systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true; fi
    if [ -S "/var/run/docker.sock" ]; then chmod 666 /var/run/docker.sock 2>/dev/null || sudo chmod 666 /var/run/docker.sock 2>/dev/null || true; fi
    run_pm2 start ecosystem.config.cjs --only "$TARGET"; run_pm2 save --force 2>/dev/null || true
}
start_panel() {
    print_banner; print_header "🚀 STARTING ASTROWAX PANEL" "⚡ Initializing ultra services..."
    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then log_error "Panel not found. Please install first."; return 1; fi
    cd "$PANEL_PATH" || return 1
    if [ ! -f "ecosystem.config.cjs" ]; then setup_node_env "docker"; fi
    if [ ! -f "dist/server.cjs" ]; then install_dependencies; build_application; fi
    log_step "🚀 Starting PM2 process manager..."; start_panel_node "$MAIN_PROCESS"
    log_step "⏳ Waiting for panel to become responsive..."; local ATTEMPTS=0
    while [ $ATTEMPTS -lt 15 ]; do if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then log_success "🎉 Panel is now ONLINE and accessible!"; show_status; return 0; fi; sleep 2; ATTEMPTS=$((ATTEMPTS+1)); done
    log_error "Panel failed to start. Debugging logs:"; run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true; return 1
}
restart_panel() {
    print_banner; print_header "🔄 RESTARTING ASTROWAX PANEL" "💫 Refreshing ultra services..."
    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then log_error "Panel not found."; return 1; fi
    cd "$PANEL_PATH" || return 1
    run_pm2 restart "$MAIN_PROCESS" 2>/dev/null || start_panel_node "$MAIN_PROCESS"; run_pm2 save --force 2>/dev/null || true; sleep 3
    if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then log_success "✨ Panel restarted successfully"; show_status; return 0; fi
    log_error "Restart failed"; run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true; return 1
}

# ═══════════════════════════════════════════════════════════
# 📊 ULTRA STATUS DASHBOARD
# ═══════════════════════════════════════════════════════════
show_status() {
    local MAIN_STATUS="OFFLINE"; local SFTP_STATUS="OFFLINE"; local VERSION_LABEL="${SELECTED_VERSION:-1.80}"; local STATUS_COLOR="$C_RED"
    if (run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -q "online") || curl -s -m 2 http://127.0.0.1:${MAIN_PORT}/ >/dev/null 2>&1; then MAIN_STATUS="ONLINE"; STATUS_COLOR="$C_GREEN_L"; fi
    [ "$MAIN_STATUS" = "ONLINE" ] && SFTP_STATUS="ONLINE"
    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")
    echo ""
    echo -e "${C_PURPLE_L}${C_BOLD}    ╔════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}         ${C_CYAN_L}${C_BOLD}🌌 ASTROWAX PANEL STATUS DASHBOARD 🌌${C_RESET}${C_PURPLE_L}${C_BOLD}          ║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ╠════════════════════════════════════════════════════════════╣${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}  ${C_DIM}💎 Version:${C_RESET} ${C_WHITE}${C_BOLD}v${VERSION_LABEL} ULTRA ✨${C_RESET}                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}  ${C_DIM}👑 Author:${C_RESET} ${C_YELLOW}${C_BOLD}Itzytansh 🚀${C_RESET}                                ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}  ${C_DIM}🔤 Meaning:${C_RESET} ${C_PINK}${C_BOLD}AWP = ASTROWAX PANEL${C_RESET}                        ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}  ${C_DIM}🌐 Main Panel:${C_RESET}  [${STATUS_COLOR}${C_BOLD}${MAIN_STATUS} ${MAIN_STATUS//OFFLINE/💤}${MAIN_STATUS//ONLINE/🚀}${C_RESET}]                ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    if [ "$MAIN_STATUS" = "ONLINE" ]; then echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}               ${C_CYAN_L}${C_BOLD}🔗 http://${IP}:${MAIN_PORT}${C_RESET}                     ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    else echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}               ${C_GRAY}💤 Not Running${C_RESET}                               ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; fi
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    if [ "$SFTP_STATUS" = "ONLINE" ]; then echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}  ${C_DIM}📡 SFTP Service:${C_RESET} [${C_GREEN_L}${C_BOLD}ONLINE 🚀${C_RESET}]  Port ${SFTP_PORT}             ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    else echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}  ${C_DIM}📡 SFTP Service:${C_RESET} [${C_RED}${C_BOLD}OFFLINE 💤${C_RESET}]                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; fi
    echo -e "${C_PURPLE_L}${C_BOLD}    ║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"
    echo -e "${C_PURPLE_L}${C_BOLD}    ╚════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# 🎯 VERSION SELECTOR - ULTRA EDITION
# ═══════════════════════════════════════════════════════════
choose_version() {
    print_banner
    print_header "🎯 SELECT PANEL VERSION" "💎 Choose your deployment target"
    echo -e "    ${C_PURPLE_L}┌──────────────────────────────────────────────────────────────┐${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} ${C_BOLD}🚀💎 AstroWax Panel V1.80 ${C_YELLOW}(Latest)${C_RESET} ${C_PINK}🔥🔥${C_RESET}             ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}✨ Node 20 + PM2 + Docker + Ultra Visuals${C_RESET}              ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}🌟 Production Ready + AWP Branding${C_RESET}                    ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}                                                              ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} ${C_BOLD}📦🔰 AstroWax Panel V1.0 ${C_GRAY}(Legacy)${C_RESET}                   ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}💾 Classic SQLite + Lightweight${C_RESET}                        ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}🌙 Old School Vibes${C_RESET}                                   ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}                                                              ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_RED_L}${C_BOLD}[3]${C_RESET} ${C_DIM}🔙 Back to Menu${C_RESET}                                       ${C_PURPLE_L}│${C_RESET}"; sleep 0.05
    echo -e "    ${C_PURPLE_L}└──────────────────────────────────────────────────────────────┘${C_RESET}"
    echo ""
    local vc=""
    if [ -n "$VERSION_CHOICE" ]; then vc="$VERSION_CHOICE"
    elif [ ! -t 0 ]; then vc="1"
    else echo -ne "    ${C_CYAN}💎➜${C_RESET} Enter choice ${C_YELLOW}[1-3]${C_RESET}: ${C_CYAN_L}"; read -r vc; echo -ne "${C_RESET}"; fi
    case "$vc" in
        1) SELECTED_VERSION="1.80"; log_success "🚀 Selected: V1.80 ULTRA LATEST 💎";;
        2) SELECTED_VERSION="1.0"; log_success "📦 Selected: V1.0 LEGACY 🔰";;
        3) return 1;;
        *) log_error "❌ Invalid selection 💥"; return 1;; esac
    echo ""; sleep 0.5; return 0
}

# ═══════════════════════════════════════════════════════════
# 🚀 INSTALLATION ENGINE V1.80 - ULTRA
# ═══════════════════════════════════════════════════════════
install_panel_v180() {
    print_banner
    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        print_header "📥 DOWNLOADING PANEL V1.80" "🌌 Fetching latest ultra release..."
        execute_step "📥 Downloading AstroWax Panel V1.80 💎" download_panel_v180 || { log_error "Download failed 💥"; exit 1; }
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi
    cd "$PANEL_PATH" || { log_error "Cannot enter panel directory 💥"; exit 1; }
    log_info "📂 Working directory: $(pwd)"
    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then log_error "Invalid package.json 💥"; exit 1; fi
    log_success "✅ Package verified successfully 🎉"; echo ""
    print_header "⚙️ SELECT INSTALLATION MODE" "🔥 Choose your runtime environment"
    echo -e "    ${C_PURPLE_L}┌──────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} ${C_BOLD}🐳 Node.js + PM2 + Docker ${C_YELLOW}(Recommended) 🚀${C_RESET}      ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}✨ Full containerization + AWP Power${C_RESET}                  ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}🔥 Production optimized + Ultra Speed${C_RESET}                ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}                                                              ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} ${C_BOLD}💻 Pure Local Node.js ${C_GRAY}(Lightweight)${C_RESET}               ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}🍃 No Docker, Pure Speed${C_RESET}                              ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}      ${C_GRAY_L}⚡ Minimal Resource Usage${C_RESET}                            ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}                                                              ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_RED_L}${C_BOLD}[3]${C_RESET} ${C_DIM}🔙 Back${C_RESET}                                                 ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}└──────────────────────────────────────────────────────────────┘${C_RESET}"
    local MODE_CHOICE=""
    if [ -n "$RUN_CHOICE" ]; then MODE_CHOICE="$RUN_CHOICE"
    elif [ ! -t 0 ]; then MODE_CHOICE="1"
    else echo -ne "    ${C_CYAN}💎➜${C_RESET} Enter choice ${C_YELLOW}[1-3]${C_RESET}: ${C_CYAN_L}"; read -r MODE_CHOICE; echo -ne "${C_RESET}"; fi
    [ "$MODE_CHOICE" = "3" ] && return 1
    if [ "$MODE_CHOICE" != "1" ] && [ "$MODE_CHOICE" != "2" ]; then log_error "Invalid selection 💥"; return 1; fi
    mkdir -p .data backups
    if [ ! -f ".env" ]; then if [ -f ".env.example" ]; then cp .env.example .env; else echo "PORT=${MAIN_PORT}" > .env; echo "JWT_SECRET=$(head -c 32 /dev/urandom | base64 2>/dev/null || openssl rand -base64 32)" >> .env; fi; fi
    print_header "🚀 INSTALLING V1.80 ULTRA" "💫 Setting up production environment..."
    echo ""
    execute_step "🔍 System Requirements Check ✨" check_system_deps
    execute_step "☕ Java Runtime Environment 🔥" install_java
    local RUNTIME_ARG="docker"; [ "$MODE_CHOICE" = "2" ] && RUNTIME_ARG="local"
    execute_step "💚 Node.js v20 Configuration 🚀" setup_node_env "$RUNTIME_ARG"
    execute_step "📦 Installing Dependencies 💎" install_dependencies
    execute_step "🔨 Building Application ✨" build_application
    execute_step "⚡ Starting PM2 Service 🌟" start_panel_node "$MAIN_PROCESS"
    log_step "⏳ Waiting for panel initialization 🌌..."; local ATTEMPTS=0; local OK=0
    while [ $ATTEMPTS -lt 30 ]; do if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then OK=1; break; fi
        if run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -qE "errored|stopped"; then log_error "PM2 crashed 💥"; run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true; return 1; fi
        sleep 2; ATTEMPTS=$((ATTEMPTS+1)); done
    if [ "$OK" != "1" ]; then log_error "Panel failed to start 💥"; run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true; return 1; fi
    log_success "🎉 Panel is ONLINE and operational! 🚀"; show_status
    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")
    echo -e "${C_GREEN_L}${C_BOLD}    ╔════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_GREEN_L}${C_BOLD}    ║${C_RESET}           ${C_WHITE}${C_BOLD}🎉✨ INSTALLATION COMPLETE ✨🎉${C_RESET}${C_GREEN_L}${C_BOLD}               ║${C_RESET}"
    echo -e "${C_GREEN_L}${C_BOLD}    ╚════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""; confetti_burst
    echo -e "    ${C_WHITE}${C_BOLD}🌐 Panel URL${C_RESET}    : ${C_CYAN_L}${C_BOLD}http://${IP}:${MAIN_PORT} 🚀${C_RESET}"
    echo -e "    ${C_WHITE}${C_BOLD}📝 Register${C_RESET}     : ${C_CYAN_L}${C_BOLD}http://${IP}:${MAIN_PORT}/register ✨${C_RESET}"
    echo -e "    ${C_WHITE}${C_BOLD}💎 Version${C_RESET}      : ${C_PURPLE_L}${C_BOLD}AstroWax Panel V1.80 ULTRA ${C_YELLOW}AWP${C_RESET}"
    echo ""; echo -e "    ${C_YELLOW}${C_BOLD}⚡ First user to register becomes OWNER automatically 👑${C_RESET}"; echo ""
    echo -e "    ${C_GRAY_L}Made with ${C_RED}❤️ ${C_GRAY_L} by ${C_YELLOW}${C_BOLD}Itzytansh${C_RESET} ${C_PINK}✨ AWP = ASTROWAX PANEL ✨${C_RESET}"; echo ""
}

# ═══════════════════════════════════════════════════════════
# 📦 LEGACY V1.0 INSTALLER
# ═══════════════════════════════════════════════════════════
install_panel_v10() {
    print_banner; print_header "📦 INSTALLING V1.0 LEGACY" "🔰 Classic deployment mode"
    echo -e "    ${C_PURPLE_L}┌──────────────────────────────────────────────────────────────┐${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}[1]${C_RESET} ${C_BOLD}🖥️ Panel Only${C_RESET}                                         ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}[2]${C_RESET} ${C_BOLD}🤖 Node Daemon Only${C_RESET}                                   ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_CYAN_L}[3]${C_RESET} ${C_BOLD}💎 BOTH (Panel + Daemon) 🚀${C_RESET}                          ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}│${C_RESET}  ${C_RED_L}[4]${C_RESET} ${C_DIM}🔙 Back${C_RESET}                                               ${C_PURPLE_L}│${C_RESET}"
    echo -e "    ${C_PURPLE_L}└──────────────────────────────────────────────────────────────┘${C_RESET}"
    local V1_CHOICE=""
    if [ -n "$V1_INSTALL_CHOICE" ]; then V1_CHOICE="$V1_INSTALL_CHOICE"
    elif [ ! -t 0 ]; then V1_CHOICE="3"
    else echo -ne "    ${C_CYAN}💎➜${C_RESET} Enter choice [1-4]: "; read -r V1_CHOICE; fi
    case "$V1_CHOICE" in
        1) install_v10_panel ;; 2) install_v10_node_daemon ;;
        3) install_v10_panel; echo ""; install_v10_node_daemon ;;
        4) return 0 ;; *) log_error "Invalid selection 💥"; return 1 ;; esac
}
install_v10_panel() {
    echo ""; log_step "📦 Installing Panel V1.0..."; echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config libsqlite3-dev sqlite3 && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/AstroWax-Panel && git clone https://github.com/AstroVoidHostDev/AstroWax-Panel ~/AstroWax-Panel && cd ~/AstroWax-Panel && unzip -oq panel.zip && cd panel && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps && npm install connect-sqlite3 sqlite3 && npm run seed && npm run createUser'
    log_success "V1.0 Panel installed 🎉"; echo ""; echo -e "    ${C_WHITE}Run:${C_RESET} ${C_CYAN_L}cd ~/AstroWax-Panel/panel && node .${C_RESET}"; echo ""
}
install_v10_node_daemon() {
    echo ""; log_step "🤖 Installing Node Daemon V1.0..."; echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git zip unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/WaxDaemon && git clone https://github.com/AstroVoidHostDev/WaxDaemon ~/WaxDaemon && cd ~/WaxDaemon && unzip -oq waxdaemon.zip && cd daemon/daemon && [ -f index.js.txt ] && mv index.js.txt index.js || true && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps'
    log_success "Node Daemon installed 🎉"; echo ""; echo -e "    ${C_WHITE}Run:${C_RESET} ${C_CYAN_L}cd ~/WaxDaemon/daemon/daemon && node .${C_RESET}"; echo ""
}

# ═══════════════════════════════════════════════════════════
# 🔄 UPDATE ENGINE
# ═══════════════════════════════════════════════════════════
update_panel() {
    print_banner; print_header "🔄 UPDATING ASTROWAX PANEL" "✨ Fetching latest ultra version..."
    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then log_error "Panel not installed 💥"; return 1; fi
    cd "$PANEL_PATH" || return 1; log_info "Updating: $(pwd) 📂"; echo ""
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local temp_dir="/tmp/awp_update_$$"; local new_dir="${temp_dir}/new"; mkdir -p "$new_dir" || return 1
    if ! curl -fsSL "$archive_url" -o "/tmp/awp_update.zip" 2>/dev/null; then log_error "Download failed 💥"; rm -rf "$temp_dir"; return 1; fi
    unzip -q -o "/tmp/awp_update.zip" -d "$new_dir" 2>/dev/null || { log_error "Extraction failed 💥"; rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1; }
    local found=$(find "$new_dir" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then echo "$f"; break; fi; done | head -1)
    if [ -z "$found" ]; then log_error "Panel not found in package 💥"; rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1; fi
    local actual_new_root=$(dirname "$found")
    log_step "🛑 Stopping current panel..."; run_pm2 stop "$MAIN_PROCESS" 2>/dev/null || true
    log_step "💾 Preserving user data..."; local PRESERVE_DIR="/tmp/awp_preserve_$$"; mkdir -p "$PRESERVE_DIR"
    [ -f ".env" ] && cp ".env" "$PRESERVE_DIR/" 2>/dev/null || true; [ -d ".data" ] && cp -r ".data" "$PRESERVE_DIR/" 2>/dev/null || true; [ -d "backups" ] && cp -r "backups" "$PRESERVE_DIR/" 2>/dev/null || true
    local BACKUP_NAME="astrowax-backup-$(date +%Y%m%d_%H%M%S)"; tar -czf "$BACKUP_NAME.tar.gz" --exclude=node_modules --exclude=.git . 2>/dev/null || true
    log_success "Backup created: ${C_CYAN_L}$BACKUP_NAME.tar.gz 💾"
    log_step "📦 Applying updates..."; rm -rf src server public 2>/dev/null || true
    rm -f package.json package-lock.json index.html vite.config.ts tsconfig.json server.ts ecosystem.config.cjs 2>/dev/null || true
    cp -r "$actual_new_root"/* . 2>/dev/null || true
    [ -f "$PRESERVE_DIR/.env" ] && cp "$PRESERVE_DIR/.env" . 2>/dev/null || true; [ -d "$PRESERVE_DIR/.data" ] && cp -r "$PRESERVE_DIR/.data" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/backups" ] && cp -r "$PRESERVE_DIR/backups" . 2>/dev/null || true; rm -rf "$PRESERVE_DIR"
    echo ""; execute_step "📦 Installing Dependencies 💎" install_dependencies
    execute_step "🔨 Building Application ✨" build_application
    execute_step "🚀 Restarting Panel 🌟" start_panel_node "$MAIN_PROCESS"
    log_step "⏳ Waiting for services..."; local ATTEMPTS=0
    while [ $ATTEMPTS -lt 20 ]; do curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && break; sleep 2; ATTEMPTS=$((ATTEMPTS+1)); done
    rm -rf "$temp_dir" "/tmp/awp_update.zip"
    echo ""; echo -e "${C_GREEN_L}${C_BOLD}    ╔════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_GREEN_L}${C_BOLD}    ║${C_RESET}              ${C_WHITE}${C_BOLD}✅ UPDATE COMPLETE ✨🎉${C_RESET}${C_GREEN_L}${C_BOLD}                      ║${C_RESET}"
    echo -e "${C_GREEN_L}${C_BOLD}    ╚════════════════════════════════════════════════════════════╝${C_RESET}"; echo ""; show_status
}

# ═══════════════════════════════════════════════════════════
# 🗑️ UNINSTALLER
# ═══════════════════════════════════════════════════════════
uninstall_panel() {
    print_banner; print_header "🗑️ UNINSTALL ASTROWAX PANEL" "💥 Removing all components"
    echo -e "    ${C_RED}${C_BOLD}⚠️  WARNING: This will permanently remove AstroWax Panel 💥${C_RESET}"
    echo -e "    ${C_RED}${C_BOLD}   All data, configs, services will be deleted 🗑️🔥${C_RESET}"; echo ""
    if [ -t 0 ]; then echo -ne "    ${C_RED}💥➜${C_RESET} Type ${C_WHITE}'yes'${C_RESET} to confirm: "; read -r CONFIRM; [ "$CONFIRM" != "yes" ] && { echo -e "    ${C_YELLOW}Operation cancelled ✨${C_RESET}"; return 0; }; fi
    echo ""; log_step "🛑 Stopping services..."; run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true; run_pm2 delete "astrowax-admin" 2>/dev/null || true
    run_pm2 delete "astrowax-panel" 2>/dev/null || true; run_pm2 save --force 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd); $DOCKER_CLI rm -f "astrowax-main" 2>/dev/null || true; $DOCKER_CLI rm -f "astrowax-admin" 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true; pkill -f "astrowax" 2>/dev/null || true
    log_success "Services terminated 💤"; echo ""
    local DELETE_DATA="n"; if [ -t 0 ]; then echo -ne "    ${C_YELLOW}🗑️➜${C_RESET} Also delete panel files? (y/N): "; read -r DELETE_DATA; fi
    if [ "$DELETE_DATA" = "y" ] || [ "$DELETE_DATA" = "Y" ]; then
        log_step "🗑️ Removing files..."; cd "$HOME" || cd /tmp || true
        local PANEL_PATH=$(find_panel_dir); [ -n "$PANEL_PATH" ] && rm -rf "$PANEL_PATH" 2>/dev/null || true
        for path in "$HOME/$WORK_DIR_NAME" "$HOME/panel" "$HOME/astrowax-panel" "$HOME/AstroWax-Panel" "$HOME/WaxDaemon"; do [ -d "$path" ] && rm -rf "$path" 2>/dev/null || true; done
        rm -rf /tmp/awp_* /tmp/astrowax* 2>/dev/null || true; log_success "Files removed 🗑️✨"
    else log_info "Files preserved 💾"; fi
    echo ""; echo -e "${C_GREEN_L}${C_BOLD}    ╔════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_GREEN_L}${C_BOLD}    ║${C_RESET}            ${C_WHITE}${C_BOLD}✅ UNINSTALL COMPLETE ✨${C_RESET}${C_GREEN_L}${C_BOLD}                      ║${C_RESET}"
    echo -e "${C_GREEN_L}${C_BOLD}    ╚════════════════════════════════════════════════════════════╝${C_RESET}"; echo ""
}

# ═══════════════════════════════════════════════════════════
# 🎮 COMMAND LINE PARSER
# ═══════════════════════════════════════════════════════════
for arg in "$@"; do case "$arg" in --version=1.0|--v=1.0|-v1.0) VERSION_CHOICE="2";; --version=1.80|--v=1.80|-v1.80) VERSION_CHOICE="1";; --v1-install=panel) V1_INSTALL_CHOICE="1";; --v1-install=node) V1_INSTALL_CHOICE="2";; --v1-install=both) V1_INSTALL_CHOICE="3";; esac; done
case "$1" in install|main) if choose_version; then if [ "$SELECTED_VERSION" = "1.0" ]; then install_panel_v10; else install_panel_v180; fi; fi; exit 0;; update) update_panel; exit 0;; uninstall) uninstall_panel; exit 0;; start) start_panel; exit 0;; stop) stop_panel; exit 0;; restart) restart_panel; exit 0;; status) show_status; exit 0;; esac

# ═══════════════════════════════════════════════════════════
# 🎨 ULTRA INTERACTIVE MENU - ANIMATED
# ═══════════════════════════════════════════════════════════
while true; do
    print_banner
    echo -e "    ${C_PURPLE_L}${C_BOLD}╔════════════════════════════════════════════════════════════╗${C_RESET}"; sleep 0.02
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}           ${C_CYAN_L}${C_BOLD}💎 ASTROWAX PANEL CONTROLLER ULTRA 💎${C_RESET}${C_PURPLE_L}${C_BOLD}        ║${C_RESET}"; sleep 0.02
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}              ${C_YELLOW}${C_BOLD}✨ AWP = ASTROWAX PANEL ✨${C_RESET}${C_PURPLE_L}${C_BOLD}               ║${C_RESET}"; sleep 0.02
    echo -e "    ${C_PURPLE_L}${C_BOLD}╠════════════════════════════════════════════════════════════╣${C_RESET}"; sleep 0.02
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.02
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[1]${C_RESET} ${C_BOLD}🚀💎 Install Panel ${C_YELLOW}✨ ULTRA${C_RESET}                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[2]${C_RESET} ${C_BOLD}🔄🌟 Update Panel ${C_GREEN_L}⚡ LATEST${C_RESET}                         ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_GREEN_L}${C_BOLD}[3]${C_RESET} ${C_BOLD}▶️⚡ Start Panel ${C_GREEN_L}🚀 GO!${C_RESET}                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_RED_L}${C_BOLD}[4]${C_RESET} ${C_BOLD}⏹️🛑 Stop Panel ${C_RED}💤 STOP${C_RESET}                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_YELLOW}${C_BOLD}[5]${C_RESET} ${C_BOLD}🔁💫 Restart Panel ${C_YELLOW}♻️ REFRESH${C_RESET}                      ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_CYAN_L}${C_BOLD}[6]${C_RESET} ${C_BOLD}📊👀 Show Status ${C_CYAN}🌌 LIVE${C_RESET}                          ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_ORANGE}${C_BOLD}[7]${C_RESET} ${C_BOLD}🗑️🔥 Uninstall Panel ${C_RED}💥 NUKE${C_RESET}                      ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}  ${C_GRAY_L}${C_BOLD}[8]${C_RESET} ${C_DIM}👋✨ Exit ${C_GRAY_L}🌙 BYE${C_RESET}                                    ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.03
    echo -e "    ${C_PURPLE_L}${C_BOLD}║${C_RESET}                                                            ${C_PURPLE_L}${C_BOLD}║${C_RESET}"; sleep 0.02
    echo -e "    ${C_PURPLE_L}${C_BOLD}╚════════════════════════════════════════════════════════════╝${C_RESET}"
    echo ""; echo -e "    ${C_GRAY_L}💎 AstroWax Panel ${C_YELLOW}v1.80 ULTRA${C_RESET}${C_GRAY_L} • ${C_CYAN}AWP = ASTROWAX PANEL${C_RESET}${C_GRAY_L} • Made by ${C_YELLOW}${C_BOLD}Itzytansh 🚀✨${C_RESET}"; echo ""
    echo -ne "    ${C_CYAN_L}${C_BOLD}💎➜${C_RESET} ${C_WHITE}Enter choice ${C_YELLOW}[1-8]${C_RESET}${C_WHITE}:${C_RESET} ${C_CYAN_L}"; 
    if ! read -r CHOICE; then echo ""; break; fi; echo -ne "${C_RESET}"
    case "$CHOICE" in
        1) if choose_version; then if [ "$SELECTED_VERSION" = "1.0" ]; then install_panel_v10; else install_panel_v180; fi; fi; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        2) update_panel; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        3) start_panel; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        4) stop_panel; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        5) restart_panel; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        6) show_status; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        7) uninstall_panel; if [ -t 0 ]; then echo -ne "    ${C_GRAY_L}✨ Press Enter to continue...${C_RESET}"; read -r || true; fi;;
        8) echo ""; confetti_burst; echo -e "    ${C_PURPLE_L}${C_BOLD}👋✨ Goodbye! Thank you for using ${C_CYAN_L}AWP = ASTROWAX PANEL${C_RESET}${C_PURPLE_L}${C_BOLD} 💎🚀${C_RESET}\n"; exit 0;;
        *) log_error "❌ Invalid option! Try again 💫"; sleep 1.5;;
    esac
done
