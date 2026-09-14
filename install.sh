#!/bin/bash
# =========================================================
# AstroWax Panel — Master Control Script
# Made by Itzytansh
# =========================================================
set -o pipefail
export LANG="${LANG:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

if [ -z "${BASH_VERSION:-}" ]; then
    if command -v bash >/dev/null 2>&1; then
        exec bash "$0" "$@"
    fi
fi

# ═══════════════════════════════════════════════════════════
# TERMINAL / COLOR ENGINE
# ═══════════════════════════════════════════════════════════
AWP_TRUECOLOR=0
AWP_COLOR=0
AWP_UNICODE=1
AWP_TTY=0
[ -t 1 ] && AWP_TTY=1

if [ "$AWP_TTY" -eq 1 ]; then
    AWP_COLOR=1
    case "${COLORTERM:-}${TERM:-}" in
        *truecolor*|*24bit*|*256color*|*-256*) AWP_TRUECOLOR=1 ;;
    esac
    case "${TERM:-}" in
        *-256color|xterm*|screen*|tmux*|alacritty*|kitty*|wezterm*) AWP_TRUECOLOR=1 ;;
    esac
fi
[ "${NO_COLOR:-}" != "" ] && AWP_COLOR=0 && AWP_TRUECOLOR=0
[ "${TERM:-}" = "dumb" ] && AWP_COLOR=0 && AWP_TRUECOLOR=0

if ! printf '✓' | grep -q '✓' 2>/dev/null; then AWP_UNICODE=0; fi

c() {
    [ "$AWP_COLOR" -eq 1 ] || return 0
    printf '\033[%sm' "$1"
}
rgb() {
    if [ "$AWP_TRUECOLOR" -eq 1 ]; then
        printf '\033[38;2;%s;%s;%sm' "$1" "$2" "$3"
    elif [ "$AWP_COLOR" -eq 1 ]; then
        printf '\033[38;5;%sm' "$4"
    fi
}
bg_rgb() {
    if [ "$AWP_TRUECOLOR" -eq 1 ]; then
        printf '\033[48;2;%s;%s;%sm' "$1" "$2" "$3"
    elif [ "$AWP_COLOR" -eq 1 ]; then
        printf '\033[48;5;%sm' "$4"
    fi
}

NC='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
ITAL='\033[3m'
UND='\033[4m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GREY='\033[0;37m'
MAGENTA='\033[38;5;177m'

P1="$(rgb 168 85 247 141)"
P2="$(rgb 192 132 252 177)"
P3="$(rgb 216 180 254 183)"
C1="$(rgb 34 211 238 51)"
C2="$(rgb 56 189 248 45)"
G1="$(rgb 52 211 153 84)"
R1="$(rgb 248 113 113 203)"
Y1="$(rgb 251 191 36 220)"
W1="$(rgb 248 250 252 255)"
M1="$(rgb 148 163 184 246)"
BG="$(rgb 15 10 28 234)"

term_cols() {
    local w
    w=$(tput cols 2>/dev/null || echo 80)
    [ "$w" -lt 60 ] && w=60
    [ "$w" -gt 120 ] && w=120
    echo "$w"
}

hide_cursor() { [ "$AWP_TTY" -eq 1 ] && printf '\033[?25l'; }
show_cursor() { [ "$AWP_TTY" -eq 1 ] && printf '\033[?25h'; }
clear_screen() { [ "$AWP_TTY" -eq 1 ] && { clear 2>/dev/null || printf '\033[2J\033[H'; }; }

cleanup_ui() {
    show_cursor
    printf '\033[0m' 2>/dev/null || true
}
trap 'cleanup_ui' EXIT
trap 'cleanup_ui; exit 130' INT
trap 'cleanup_ui; exit 143' TERM

# ═══════════════════════════════════════════════════════════
# CONFIG
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
SCRIPT_VERSION="2.0.0"

SELECTED_VERSION=""
AWP_START_TS=$(date +%s)

# ═══════════════════════════════════════════════════════════
# UI PRIMITIVES
# ═══════════════════════════════════════════════════════════
repeat_char() {
    local ch="$1" n="$2" out=""
    while [ "$n" -gt 0 ]; do out="${out}${ch}"; n=$((n - 1)); done
    printf '%s' "$out"
}

hr() {
    local w; w=$(term_cols)
    printf "    ${P1}%s${NC}\n" "$(repeat_char '─' $((w - 8)))"
}

print_banner() {
    clear_screen
    local g1 g2 g3 g4 g5 a
    g1="$(rgb 124 58 237 93)"
    g2="$(rgb 147 51 234 129)"
    g3="$(rgb 168 85 247 141)"
    g4="$(rgb 192 132 252 177)"
    g5="$(rgb 34 211 238 51)"
    a="$(rgb 226 232 240 255)"

    echo ""
    echo -e "${g1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${g2}    │                                                              │${NC}"
    echo -e "${g3}    │      ${W1}${BOLD}█████╗ ███████╗████████╗██████╗  ██████╗ ██╗    ██╗ █████╗ ██╗  ██╗${NC}${g3}  │${NC}"
    echo -e "${g3}    │      ${P2}██╔══██╗██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗██║    ██║██╔══██╗╚██╗██╔╝${NC}${g3}  │${NC}"
    echo -e "${g4}    │      ${P3}███████║███████╗   ██║   ██████╔╝██║   ██║██║ █╗ ██║███████║ ╚███╔╝${NC}${g4}   │${NC}"
    echo -e "${g4}    │      ${C1}██╔══██║╚════██║   ██║   ██╔══██╗██║   ██║██║███╗██║██╔══██║ ██╔██╗${NC}${g4}   │${NC}"
    echo -e "${g5}    │      ${C2}██║  ██║███████║   ██║   ██║  ██║╚██████╔╝╚███╔███╔╝██║  ██║██╔╝ ██╗${NC}${g5}  │${NC}"
    echo -e "${g5}    │      ${M1}╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝  ╚═╝${NC}${g5}  │${NC}"
    echo -e "${g2}    │                                                              │${NC}"
    echo -e "${g2}    │              ${W1}${BOLD}✦  ASTROWAX PANEL CONTROLLER  ✦${NC}                 ${g2}│${NC}"
    echo -e "${g1}    │           ${M1}Made by ${P2}${BOLD}Itzytansh${NC}${M1}  ·  v${SCRIPT_VERSION}  ·  Pro UI${NC}            ${g1}│${NC}"
    echo -e "${g1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""
}

box_top() {
    echo -e "${P1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
}
box_mid() {
    echo -e "${P1}    ├──────────────────────────────────────────────────────────────┤${NC}"
}
box_bot() {
    echo -e "${P1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
}
box_empty() {
    echo -e "${P1}    │                                                              │${NC}"
}
box_title() {
    local title="$1"
    echo -e "${P1}    │${NC}  ${W1}${BOLD}${title}${NC}"
}

log_info()    { echo -e "    ${P2}${BOLD}◆${NC}  ${W1}$1${NC}"; }
log_success() { echo -e "    ${G1}${BOLD}✔${NC}  ${W1}$1${NC}"; }
log_warning() { echo -e "    ${Y1}${BOLD}!${NC}  ${Y1}$1${NC}"; }
log_error()   { echo -e "    ${R1}${BOLD}✖${NC}  ${R1}$1${NC}"; }
log_step()    { echo -e "    ${C1}${BOLD}→${NC}  ${P3}$1${NC}"; }

pause_enter() {
    if [ -t 0 ]; then
        echo ""
        printf "    ${M1}Press ${W1}Enter${M1} to continue…${NC} "
        read -r _ || true
    fi
}

prompt_choice() {
    local msg="$1"
    local val=""
    if [ -t 0 ]; then
        printf "    ${P2}${BOLD}?${NC}  ${W1}%s${NC} " "$msg"
        read -r val || true
        echo "$val"
    else
        echo ""
    fi
}

# ═══════════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════════
run_pm2() {
    if [ -x "./node_modules/.bin/pm2" ]; then ./node_modules/.bin/pm2 "$@"
    elif command -v pm2 >/dev/null 2>&1; then pm2 "$@"
    elif [ -x "/usr/local/bin/pm2" ]; then /usr/local/bin/pm2 "$@"
    else npx --no-install pm2 "$@" 2>/dev/null || npx pm2 "$@"; fi
}

get_docker_cmd() {
    if docker info >/dev/null 2>&1; then echo "docker"
    elif command -v sudo >/dev/null 2>&1 && sudo docker info >/dev/null 2>&1; then echo "sudo docker"
    else echo "docker"; fi
}

public_ip() {
    curl -fsS -m 2 https://ifconfig.me 2>/dev/null \
        || curl -fsS -m 2 https://icanhazip.com 2>/dev/null \
        || hostname -I 2>/dev/null | awk '{print $1}' \
        || echo "localhost"
}

secure_docker_sock() {
    if [ ! -S "/var/run/docker.sock" ]; then return 0; fi
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then return 0; fi
    if id -nG 2>/dev/null | grep -qw docker; then return 0; fi
    if command -v sudo >/dev/null 2>&1; then
        sudo usermod -aG docker "$(whoami)" >/dev/null 2>&1 || true
        if sudo docker info >/dev/null 2>&1; then return 0; fi
        sudo chmod 660 /var/run/docker.sock >/dev/null 2>&1 || true
    fi
}

find_panel_dir() {
    if [ -f "package.json" ] && grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        pwd; return 0
    fi
    if [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ] && \
       grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" 2>/dev/null; then
        echo "$(pwd)/$WORK_DIR_NAME/$PANEL_DIR_NAME"; return 0
    fi
    local found
    found=$(find . -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" -not -path "*/dist/*" 2>/dev/null | while read -r f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)
    if [ -n "$found" ]; then
        echo "$(cd "$(dirname "$found")" && pwd)"; return 0
    fi
    echo ""; return 1
}

execute_step() {
    local msg="$1"; shift
    local step_id="awp_step_$$_$RANDOM"
    local log_file="/tmp/${step_id}.log"
    local t0 t1 elapsed
    rm -f "$log_file"
    t0=$(date +%s)

    printf "    ${P2}▶${NC}  ${W1}%-42s${NC} " "$msg"
    "$@" >"$log_file" 2>&1 &
    local pid=$!

    if [ "$AWP_TTY" -eq 1 ]; then
        local frames
        if [ "$AWP_UNICODE" -eq 1 ]; then
            frames='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        else
            frames='|/-\\'
        fi
        local i=0 flen=${#frames}
        hide_cursor
        while kill -0 "$pid" 2>/dev/null; do
            local c="${frames:$((i % flen)):1}"
            printf "${P2}%s${NC}" "$c"
            sleep 0.08
            printf '\b'
            i=$((i + 1))
        done
        show_cursor
    fi

    local status=0
    wait "$pid" 2>/dev/null || status=$?
    t1=$(date +%s)
    elapsed=$((t1 - t0))

    if [ "$status" -eq 0 ]; then
        printf "\r    ${G1}✔${NC}  ${W1}%-42s${NC} ${G1}[Done · %ss]${NC}\n" "$msg" "$elapsed"
    else
        printf "\r    ${R1}✖${NC}  ${W1}%-42s${NC} ${R1}[Fail · %ss]${NC}\n" "$msg" "$elapsed"
        echo ""
        echo -e "    ${R1}╭──────────────────────── STEP FAILED ────────────────────────╮${NC}"
        echo -e "    ${R1}│${NC}  ${W1}${BOLD}$msg${NC}"
        echo -e "    ${R1}│${NC}  ${M1}Exit code:${NC} ${Y1}$status${NC}"
        if [ -s "$log_file" ]; then
            echo -e "    ${R1}│${NC}  ${M1}Last output:${NC}"
            tail -n 24 "$log_file" | sed "s/^/    ${R1}│${NC}    /"
        fi
        echo -e "    ${R1}╰─────────────────────────────────────────────────────────────╯${NC}"
        return "$status"
    fi
    return 0
}

# ═══════════════════════════════════════════════════════════
# SYSTEM DEPS
# ═══════════════════════════════════════════════════════════
check_system_deps() {
    local MISSING=""
    local cmd
    for cmd in curl git tar unzip; do
        command -v "$cmd" >/dev/null 2>&1 || MISSING="$MISSING $cmd"
    done
    if [ -n "$MISSING" ]; then
        if command -v apt-get >/dev/null 2>&1; then
            sudo apt-get update -y -q >/dev/null 2>&1 || true
            sudo apt-get install -y $MISSING build-essential ca-certificates -q >/dev/null 2>&1 || true
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y $MISSING make gcc-c++ ca-certificates unzip -q >/dev/null 2>&1 || true
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y $MISSING make gcc-c++ ca-certificates unzip -q >/dev/null 2>&1 || true
        fi
    fi
    for cmd in curl git tar unzip; do
        command -v "$cmd" >/dev/null 2>&1 || { echo "Missing: $cmd"; return 1; }
    done
    return 0
}

# ═══════════════════════════════════════════════════════════
# DOWNLOAD
# ═══════════════════════════════════════════════════════════
download_panel_v180() {
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.zip"
    local START_DIR
    START_DIR=$(pwd)

    rm -rf "$WORK_DIR_NAME" "$GH_ARCHIVE" 2>/dev/null || true

    if ! curl -fsSL --connect-timeout 15 --retry 2 "$archive_url" -o "$GH_ARCHIVE" 2>/dev/null; then
        curl -fsSL --connect-timeout 15 --retry 2 "$main_archive_url" -o "/tmp/${GH_REPO}.zip" 2>/dev/null || return 1
        unzip -q -o "/tmp/${GH_REPO}.zip" -d /tmp/awp_extract 2>/dev/null || return 1
        local found
        found=$(find /tmp/awp_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        [ -z "$found" ] && return 1
        cp "$found" "$GH_ARCHIVE" 2>/dev/null || return 1
        rm -rf /tmp/awp_extract "/tmp/${GH_REPO}.zip" 2>/dev/null || true
    fi

    [ -f "$GH_ARCHIVE" ] || return 1

    mkdir -p "$WORK_DIR_NAME"
    unzip -q -o "$GH_ARCHIVE" -d "$WORK_DIR_NAME" 2>/dev/null || return 1
    rm -f "$GH_ARCHIVE" 2>/dev/null || true

    local actual_panel
    actual_panel=$(find "$WORK_DIR_NAME" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read -r f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)

    [ -z "$actual_panel" ] && return 1

    local actual_dir
    actual_dir=$(dirname "$actual_panel")
    if [ "$actual_dir" != "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
        rm -rf "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || true
        mv "$actual_dir" "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || return 1
    fi
    cd "$START_DIR" || return 1
    return 0
}

# ═══════════════════════════════════════════════════════════
# DOCKER / NODE / JAVA
# ═══════════════════════════════════════════════════════════
install_docker() {
    if ! command -v docker >/dev/null 2>&1; then
        curl -fsSL https://get.docker.com | sh >/dev/null 2>&1 || true
        if command -v systemctl >/dev/null 2>&1; then
            sudo systemctl enable --now docker >/dev/null 2>&1 || true
        elif command -v service >/dev/null 2>&1; then
            sudo service docker start >/dev/null 2>&1 || true
        fi
    fi
    [ -x "$(command -v docker)" ] && return 0
    echo "Docker not available."; return 1
}

install_node() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }

    if ! command -v nvm >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash >/dev/null 2>&1 || true
        export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }
    fi

    if command -v nvm >/dev/null 2>&1; then
        nvm install 20 >/dev/null 2>&1 || true
        nvm use 20 >/dev/null 2>&1 || true
        nvm alias default 20 >/dev/null 2>&1 || true
    fi

    if ! command -v node >/dev/null 2>&1; then
        if command -v apt-get >/dev/null 2>&1; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - >/dev/null 2>&1 || true
            sudo apt-get install -y nodejs >/dev/null 2>&1 || true
        fi
    fi

    command -v node >/dev/null 2>&1 || { echo "Node failed"; return 1; }
    echo "Node: $(node -v)"
    command -v npm >/dev/null 2>&1 || return 1
    return 0
}

install_java() {
    if command -v java >/dev/null 2>&1 && java -version >/dev/null 2>&1; then
        return 0
    fi
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update -y -q >/dev/null 2>&1 || true
        sudo apt-get install -y -q openjdk-21-jre-headless >/dev/null 2>&1 || \
        sudo apt-get install -y -q openjdk-17-jre-headless >/dev/null 2>&1 || true
    fi
    return 0
}

setup_node_env() {
    local RUNTIME_PREF=$1
    install_node

    if ! command -v pm2 >/dev/null 2>&1 && [ ! -x "/usr/local/bin/pm2" ] && [ ! -x "./node_modules/.bin/pm2" ]; then
        sudo npm install -g pm2 >/dev/null 2>&1 || npm install -g pm2 >/dev/null 2>&1 || true
    fi

    local DEFAULT_RT="docker"
    local ENABLE_DOCKER="true"

    if [ "$RUNTIME_PREF" = "local" ]; then
        DEFAULT_RT="local"
        ENABLE_DOCKER="false"
    else
        if ! command -v docker >/dev/null 2>&1; then
            install_docker 2>/dev/null || true
        fi
        if command -v systemctl >/dev/null 2>&1; then
            systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true
        fi
        secure_docker_sock
    fi

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
}

install_dependencies() {
    [ -f "package.json" ] || return 1

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        echo "Wrong package.json"
        head -3 package.json | sed 's/^/   /'
        return 1
    fi

    [ -f ".npmrc" ] || echo "legacy-peer-deps=true" > .npmrc
    rm -rf node_modules package-lock.json 2>/dev/null || true
    npm cache clean --force >/dev/null 2>&1 || true
    npm install --legacy-peer-deps --no-audit --no-fund 2>&1 | tail -5
}

build_application() {
    [ -f "package.json" ] || return 1

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        echo "Wrong package.json"; return 1
    fi

    rm -rf dist 2>/dev/null || true
    NODE_OPTIONS="--max-old-space-size=2048" npm run build 2>&1 | tail -15

    [ -f "dist/server.cjs" ] || { echo "No dist/server.cjs"; return 1; }
    return 0
}

# ═══════════════════════════════════════════════════════════
# STOP / START / RESTART
# ═══════════════════════════════════════════════════════════
stop_panel() {
    print_banner
    box_top
    echo -e "${P1}    │${NC}  ${W1}${BOLD}STOPPING ASTROWAX PANEL${NC}"
    box_bot
    echo ""

    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true
    local DOCKER_CLI
    DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f "$MAIN_CONTAINER" 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true

    log_success "Panel stopped cleanly."
    echo ""
    show_status
}

start_panel_node() {
    local TARGET=$1
    if command -v fuser >/dev/null 2>&1; then
        fuser -k ${MAIN_PORT}/tcp 2>/dev/null || true
    fi
    pkill -f "node.*server.cjs" 2>/dev/null || true

    run_pm2 delete "$TARGET" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true

    if command -v systemctl >/dev/null 2>&1; then
        systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true
    fi
    secure_docker_sock

    run_pm2 start ecosystem.config.cjs --only "$TARGET"
    run_pm2 save --force 2>/dev/null || true
}

start_panel() {
    print_banner
    box_top
    echo -e "${P1}    │${NC}  ${W1}${BOLD}STARTING ASTROWAX PANEL${NC}"
    box_bot
    echo ""

    local PANEL_PATH
    PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not found. Install first."
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

    log_step "Launching PM2 process…"
    start_panel_node "$MAIN_PROCESS"

    log_step "Waiting for HTTP health check…"
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 15 ]; do
        if curl -s -f -m 2 "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
            log_success "Panel is live."
            show_status
            return 0
        fi
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    log_error "Panel didn't start. Recent logs:"
    run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true
    return 1
}

restart_panel() {
    print_banner
    box_top
    echo -e "${P1}    │${NC}  ${W1}${BOLD}RESTARTING ASTROWAX PANEL${NC}"
    box_bot
    echo ""

    local PANEL_PATH
    PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not found."
        return 1
    fi
    cd "$PANEL_PATH" || return 1

    run_pm2 restart "$MAIN_PROCESS" 2>/dev/null || start_panel_node "$MAIN_PROCESS"
    run_pm2 save --force 2>/dev/null || true
    sleep 3

    if curl -s -f -m 2 "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
        log_success "Panel restarted."
        show_status
        return 0
    fi
    log_error "Restart failed."
    run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true
    return 1
}

# ═══════════════════════════════════════════════════════════
# STATUS
# ═══════════════════════════════════════════════════════════
show_status() {
    local MAIN_STATUS="OFFLINE"
    local SFTP_STATUS="OFFLINE"
    local VERSION_LABEL="${SELECTED_VERSION:-1.80}"
    local NODE_VER="—"
    local PM2_STATE="—"
    command -v node >/dev/null 2>&1 && NODE_VER="$(node -v 2>/dev/null || echo —)"

    if (run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -q "online") || \
       curl -s -m 2 http://127.0.0.1:${MAIN_PORT}/ >/dev/null 2>&1; then
        MAIN_STATUS="ONLINE"
    fi
    [ "$MAIN_STATUS" = "ONLINE" ] && SFTP_STATUS="ONLINE"

    if run_pm2 list 2>/dev/null | grep -q "$MAIN_PROCESS"; then
        PM2_STATE=$(run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | awk '{print $10}' | head -1)
        [ -z "$PM2_STATE" ] && PM2_STATE="managed"
    fi

    local IP
    IP=$(public_ip)
    IP=$(echo "$IP" | tr -d '\r\n ')

    echo ""
    echo -e "${P1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${P1}    │${NC}          ${W1}${BOLD}ASTROWAX PANEL  v${VERSION_LABEL}${NC}  ${M1}STATUS BOARD${NC}           ${P1}│${NC}"
    echo -e "${P1}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    if [ "$MAIN_STATUS" = "ONLINE" ]; then
        echo -e "${P1}    │${NC}   ${W1}Main Panel${NC}        ${G1}● ONLINE${NC}                                 ${P1}│${NC}"
        echo -e "${P1}    │${NC}                     ${C1}http://${IP}:${MAIN_PORT}${NC}"
    else
        echo -e "${P1}    │${NC}   ${W1}Main Panel${NC}        ${R1}○ OFFLINE${NC}                                ${P1}│${NC}"
    fi
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    if [ "$SFTP_STATUS" = "ONLINE" ]; then
        echo -e "${P1}    │${NC}   ${W1}SFTP Service${NC}      ${G1}● ONLINE${NC}  ${M1}port ${SFTP_PORT}${NC}                      ${P1}│${NC}"
    else
        echo -e "${P1}    │${NC}   ${W1}SFTP Service${NC}      ${R1}○ OFFLINE${NC}                                ${P1}│${NC}"
    fi
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    │${NC}   ${M1}Node${NC}  ${W1}${NODE_VER}${NC}   ${M1}PM2${NC}  ${W1}${PM2_STATE}${NC}   ${M1}Port${NC}  ${W1}${MAIN_PORT}${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# VERSION SELECTOR
# ═══════════════════════════════════════════════════════════
choose_version() {
    print_banner
    echo -e "${P1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${P1}    │${NC}  ${W1}${BOLD}SELECT PANEL VERSION${NC}                                        ${P1}│${NC}"
    echo -e "${P1}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[1]${NC}  ${W1}AstroWax Panel V1.80${NC}                                 ${P1}│${NC}"
    echo -e "${P1}    │${NC}         ${M1}Latest  ·  Node 20 + PM2 + Docker${NC}                    ${P1}│${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[2]${NC}  ${W1}AstroWax Panel V1.0${NC}  ${M1}(Legacy)${NC}                        ${P1}│${NC}"
    echo -e "${P1}    │${NC}         ${M1}Classic  ·  Node 20 + SQLite${NC}                         ${P1}│${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[3]${NC}  ${M1}Back${NC}                                                 ${P1}│${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    local vc=""
    if [ -n "${VERSION_CHOICE:-}" ]; then vc="$VERSION_CHOICE"
    elif [ ! -t 0 ]; then vc="1"
    else vc=$(prompt_choice "Choose (1-3):"); fi

    case "$vc" in
        1) SELECTED_VERSION="1.80"; log_success "Selected: V1.80" ;;
        2) SELECTED_VERSION="1.0"; log_success "Selected: V1.0" ;;
        3) return 1 ;;
        *) log_error "Invalid selection."; return 1 ;;
    esac
    echo ""
    sleep 0.4
    return 0
}

# ═══════════════════════════════════════════════════════════
# INSTALL V1.80
# ═══════════════════════════════════════════════════════════
install_panel_v180() {
    print_banner

    local PANEL_PATH
    PANEL_PATH=$(find_panel_dir)

    if [ -z "$PANEL_PATH" ]; then
        box_top
        echo -e "${P1}    │${NC}  ${W1}${BOLD}DOWNLOADING PANEL V1.80${NC}"
        box_bot
        echo ""
        execute_step "Downloading AstroWax Panel V1.80" download_panel_v180 || { log_error "Download failed."; exit 1; }
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi

    cd "$PANEL_PATH" || { log_error "Cannot enter panel directory."; exit 1; }
    log_info "Working dir: ${C1}$(pwd)${NC}"

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        log_error "Wrong package.json"; exit 1
    fi
    log_success "package.json verified"
    echo ""

    echo -e "${P1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${P1}    │${NC}  ${W1}${BOLD}SELECT INSTALLATION MODE${NC}                                    ${P1}│${NC}"
    echo -e "${P1}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[1]${NC}  ${W1}Node.js + PM2${NC}  ${G1}Recommended${NC}                           ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[2]${NC}  ${W1}Pure Local Node.js${NC}                                   ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[3]${NC}  ${M1}Back${NC}                                                 ${P1}│${NC}"
    echo -e "${P1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    local MODE_CHOICE=""
    if [ -n "${RUN_CHOICE:-}" ]; then MODE_CHOICE="$RUN_CHOICE"
    elif [ ! -t 0 ]; then MODE_CHOICE="1"
    else MODE_CHOICE=$(prompt_choice "Choose (1-3):"); fi

    [ "$MODE_CHOICE" = "3" ] && return 1
    if [ "$MODE_CHOICE" != "1" ] && [ "$MODE_CHOICE" != "2" ]; then
        log_error "Invalid."; return 1
    fi

    mkdir -p .data backups
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then
            cp .env.example .env
        else
            echo "PORT=${MAIN_PORT}" > .env
            echo "JWT_SECRET=$(head -c 32 /dev/urandom | base64 2>/dev/null || openssl rand -base64 32)" >> .env
        fi
    fi

    print_banner
    box_top
    echo -e "${P1}    │${NC}  ${W1}${BOLD}INSTALLING V1.80${NC}  ${M1}high-performance pipeline${NC}"
    box_bot
    echo ""

    execute_step "System Requirement Check" check_system_deps
    execute_step "Java Runtime Environment" install_java

    local RUNTIME_ARG="docker"
    [ "$MODE_CHOICE" = "2" ] && RUNTIME_ARG="local"

    execute_step "Node.js Configuration (v20)" setup_node_env "$RUNTIME_ARG"
    execute_step "Installing Dependencies" install_dependencies
    execute_step "Building Application" build_application
    execute_step "Starting PM2 Service" start_panel_node "$MAIN_PROCESS"

    log_step "Waiting for panel to respond…"
    local ATTEMPTS=0
    local OK=0
    while [ $ATTEMPTS -lt 30 ]; do
        if curl -s -f -m 2 "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
            OK=1
            break
        fi
        if run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -qE "errored|stopped"; then
            log_error "PM2 process crashed."
            run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true
            return 1
        fi
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    if [ "$OK" != "1" ]; then
        log_error "Panel failed to start in time."
        run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true
        return 1
    fi

    log_success "Panel is ONLINE."
    show_status

    local IP
    IP=$(public_ip)
    IP=$(echo "$IP" | tr -d '\r\n ')

    echo -e "${G1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${G1}    │${NC}  ${W1}${BOLD}INSTALLATION COMPLETE${NC}                                       ${G1}│${NC}"
    echo -e "${G1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "    ${M1}Panel URL${NC}   ${C1}http://${IP}:${MAIN_PORT}${NC}"
    echo -e "    ${M1}Register${NC}    ${C1}http://${IP}:${MAIN_PORT}/register${NC}"
    echo -e "    ${M1}Version${NC}     ${P2}AstroWax Panel V1.80${NC}"
    echo ""
    echo -e "    ${Y1}First user to register becomes OWNER automatically.${NC}"
    echo ""
    echo -e "    ${M1}Made by ${P2}${BOLD}Itzytansh${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# INSTALL V1.0
# ═══════════════════════════════════════════════════════════
install_panel_v10() {
    print_banner
    echo -e "${P1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${P1}    │${NC}  ${W1}${BOLD}INSTALLING V1.0 (Legacy)${NC}                                    ${P1}│${NC}"
    echo -e "${P1}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[1]${NC}  ${W1}Panel only${NC}                                           ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[2]${NC}  ${W1}Node Daemon only${NC}                                     ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[3]${NC}  ${W1}BOTH (Panel + Node Daemon)${NC}                           ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[4]${NC}  ${M1}Back${NC}                                                 ${P1}│${NC}"
    echo -e "${P1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""

    local V1_CHOICE=""
    if [ -n "${V1_INSTALL_CHOICE:-}" ]; then V1_CHOICE="$V1_INSTALL_CHOICE"
    elif [ ! -t 0 ]; then V1_CHOICE="3"
    else V1_CHOICE=$(prompt_choice "Choose (1-4):"); fi

    case "$V1_CHOICE" in
        1) install_v10_panel ;;
        2) install_v10_node_daemon ;;
        3) install_v10_panel; echo ""; install_v10_node_daemon ;;
        4) return 0 ;;
        *) log_error "Invalid."; return 1 ;;
    esac
}

install_v10_panel() {
    echo ""
    log_step "Installing Panel V1.0…"
    echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config libsqlite3-dev sqlite3 && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/AstroWax-Panel && git clone https://github.com/AstroVoidHostDev/AstroWax-Panel ~/AstroWax-Panel && cd ~/AstroWax-Panel && unzip -oq panel.zip && cd panel && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps && npm install connect-sqlite3 sqlite3 && npm run seed && npm run createUser'
    log_success "V1.0 Panel installed"
    echo ""
    echo -e "    ${M1}Run:${NC}  ${C1}cd ~/AstroWax-Panel/panel && node .${NC}"
    echo ""
}

install_v10_node_daemon() {
    echo ""
    log_step "Installing Node Daemon V1.0…"
    echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git zip unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/WaxDaemon && git clone https://github.com/AstroVoidHostDev/WaxDaemon ~/WaxDaemon && cd ~/WaxDaemon && unzip -oq waxdaemon.zip && cd daemon/daemon && [ -f index.js.txt ] && mv index.js.txt index.js || true && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps'
    log_success "Node Daemon installed"
    echo ""
    echo -e "    ${M1}Run:${NC}  ${C1}cd ~/WaxDaemon/daemon/daemon && node .${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# UPDATE
# ═══════════════════════════════════════════════════════════
update_panel() {
    print_banner
    box_top
    echo -e "${P1}    │${NC}  ${W1}${BOLD}UPDATING ASTROWAX PANEL${NC}"
    box_bot
    echo ""

    local PANEL_PATH
    PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not installed."; return 1
    fi
    cd "$PANEL_PATH" || return 1
    log_info "Updating: ${C1}$(pwd)${NC}"
    echo ""

    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local temp_dir="/tmp/awp_update_$$"
    local new_dir="${temp_dir}/new"
    mkdir -p "$new_dir" || return 1

    if ! curl -fsSL --connect-timeout 15 --retry 2 "$archive_url" -o "/tmp/awp_update.zip" 2>/dev/null; then
        log_error "Download failed."
        rm -rf "$temp_dir"; return 1
    fi

    unzip -q -o "/tmp/awp_update.zip" -d "$new_dir" 2>/dev/null || {
        log_error "Extract failed."; rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    }

    local found
    found=$(find "$new_dir" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read -r f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)

    if [ -z "$found" ]; then
        log_error "Panel not found in update."
        rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    fi
    local actual_new_root
    actual_new_root=$(dirname "$found")

    log_step "Stopping panel…"
    run_pm2 stop "$MAIN_PROCESS" 2>/dev/null || true

    log_step "Preserving data…"
    local PRESERVE_DIR="/tmp/awp_preserve_$$"
    mkdir -p "$PRESERVE_DIR"
    [ -f ".env" ] && cp ".env" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d ".data" ] && cp -r ".data" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d "backups" ] && cp -r "backups" "$PRESERVE_DIR/" 2>/dev/null || true

    local BACKUP_NAME="astrowax-backup-$(date +%Y%m%d_%H%M%S)"
    tar -czf "$BACKUP_NAME.tar.gz" --exclude=node_modules --exclude=.git . 2>/dev/null || true
    log_success "Backup: $BACKUP_NAME.tar.gz"

    log_step "Applying update…"
    rm -rf src server public 2>/dev/null || true
    rm -f package.json package-lock.json index.html vite.config.ts tsconfig.json server.ts ecosystem.config.cjs 2>/dev/null || true
    cp -r "$actual_new_root"/* . 2>/dev/null || true

    [ -f "$PRESERVE_DIR/.env" ] && cp "$PRESERVE_DIR/.env" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/.data" ] && cp -r "$PRESERVE_DIR/.data" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/backups" ] && cp -r "$PRESERVE_DIR/backups" . 2>/dev/null || true
    rm -rf "$PRESERVE_DIR"

    echo ""
    execute_step "Installing Dependencies" install_dependencies
    execute_step "Building Application" build_application
    execute_step "Restarting Panel" start_panel_node "$MAIN_PROCESS"

    log_step "Waiting for health check…"
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 20 ]; do
        curl -s -f -m 2 "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && break
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    rm -rf "$temp_dir" "/tmp/awp_update.zip"

    echo ""
    echo -e "${G1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${G1}    │${NC}  ${W1}${BOLD}UPDATE COMPLETE${NC}                                             ${G1}│${NC}"
    echo -e "${G1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""
    show_status
}

# ═══════════════════════════════════════════════════════════
# UNINSTALL
# ═══════════════════════════════════════════════════════════
uninstall_panel() {
    print_banner
    box_top
    echo -e "${P1}    │${NC}  ${W1}${BOLD}UNINSTALL ASTROWAX PANEL${NC}"
    box_bot
    echo ""
    echo -e "    ${R1}${BOLD}⚠  This will remove AstroWax Panel services.${NC}"
    echo ""

    if [ -t 0 ]; then
        printf "    ${Y1}Type ${W1}yes${Y1} to confirm: ${NC}"
        read -r CONFIRM
        [ "$CONFIRM" != "yes" ] && { echo -e "    ${Y1}Cancelled.${NC}"; return 0; }
    fi

    echo ""
    log_step "Stopping services…"
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete "astrowax-admin" 2>/dev/null || true
    run_pm2 delete "astrowax-panel" 2>/dev/null || true
    run_pm2 save --force 2>/dev/null || true

    local DOCKER_CLI
    DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f "astrowax-main" 2>/dev/null || true
    $DOCKER_CLI rm -f "astrowax-admin" 2>/dev/null || true

    pkill -f "node.*dist/server.cjs" 2>/dev/null || true

    log_success "Services stopped."
    echo ""

    local DELETE_DATA="n"
    if [ -t 0 ]; then
        printf "    ${W1}Also delete panel files? (y/N): ${NC}"
        read -r DELETE_DATA
    fi

    if [ "$DELETE_DATA" = "y" ] || [ "$DELETE_DATA" = "Y" ]; then
        log_step "Removing files…"
        cd "$HOME" || cd /tmp || true

        local PANEL_PATH
        PANEL_PATH=$(find_panel_dir)
        [ -n "$PANEL_PATH" ] && rm -rf "$PANEL_PATH" 2>/dev/null || true

        local path
        for path in "$HOME/$WORK_DIR_NAME" "$HOME/panel" "$HOME/astrowax-panel" "$HOME/AstroWax-Panel" "$HOME/WaxDaemon"; do
            [ -d "$path" ] && rm -rf "$path" 2>/dev/null || true
        done

        rm -rf /tmp/awp_* /tmp/astrowax* 2>/dev/null || true

        log_success "Files removed."
    else
        log_info "Files kept."
    fi

    echo ""
    echo -e "${G1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${G1}    │${NC}  ${W1}${BOLD}UNINSTALL COMPLETE${NC}                                          ${G1}│${NC}"
    echo -e "${G1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# DIRECT INVOCATION
# ═══════════════════════════════════════════════════════════
for arg in "$@"; do
    case "$arg" in
        --version=1.0|--v=1.0|-v1.0) VERSION_CHOICE="2" ;;
        --version=1.80|--v=1.80|-v1.80) VERSION_CHOICE="1" ;;
        --v1-install=panel) V1_INSTALL_CHOICE="1" ;;
        --v1-install=node) V1_INSTALL_CHOICE="2" ;;
        --v1-install=both) V1_INSTALL_CHOICE="3" ;;
    esac
done

case "${1:-}" in
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

# ═══════════════════════════════════════════════════════════
# INTERACTIVE MENU
# ═══════════════════════════════════════════════════════════
while true; do
    print_banner
    echo -e "${P1}    ╭──────────────────────────────────────────────────────────────╮${NC}"
    echo -e "${P1}    │${NC}              ${W1}${BOLD}ASTROWAX PANEL CONTROLLER${NC}                       ${P1}│${NC}"
    echo -e "${P1}    ├──────────────────────────────────────────────────────────────┤${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[1]${NC}  ${W1}Install Panel${NC}      ${M1}fresh setup${NC}                       ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P2}${BOLD}[2]${NC}  ${W1}Update Panel${NC}       ${M1}keep data, pull latest${NC}            ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${G1}${BOLD}[3]${NC}  ${G1}Start Panel${NC}        ${M1}bring services online${NC}             ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${R1}${BOLD}[4]${NC}  ${R1}Stop Panel${NC}         ${M1}graceful shutdown${NC}                 ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${Y1}${BOLD}[5]${NC}  ${Y1}Restart Panel${NC}      ${M1}hot reload process${NC}                ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${C1}${BOLD}[6]${NC}  ${W1}Show Status${NC}        ${M1}health + URLs${NC}                     ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${P3}${BOLD}[7]${NC}  ${W1}Uninstall Panel${NC}    ${M1}remove services${NC}                   ${P1}│${NC}"
    echo -e "${P1}    │${NC}    ${M1}${BOLD}[8]${NC}  ${M1}Exit${NC}                                                 ${P1}│${NC}"
    echo -e "${P1}    │${NC}                                                              ${P1}│${NC}"
    echo -e "${P1}    ╰──────────────────────────────────────────────────────────────╯${NC}"
    echo ""
    echo -e "    ${M1}AstroWax Panel  ·  Made by ${P2}${BOLD}Itzytansh${NC}  ${M1}·  controller v${SCRIPT_VERSION}${NC}"
    echo ""

    if ! printf "    ${P2}${BOLD}▸${NC}  ${W1}Choose (1-8): ${NC}"; then
        echo ""
        break
    fi
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
            pause_enter
            ;;
        2) update_panel; pause_enter ;;
        3) start_panel; pause_enter ;;
        4) stop_panel; pause_enter ;;
        5) restart_panel; pause_enter ;;
        6) show_status; pause_enter ;;
        7) uninstall_panel; pause_enter ;;
        8)
            echo ""
            echo -e "    ${P2}${BOLD}Goodbye.${NC}  ${M1}AstroWax is ready when you are.${NC}"
            echo ""
            exit 0
            ;;
        *) log_error "Invalid option."; sleep 1.1 ;;
    esac
done
