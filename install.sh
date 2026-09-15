#!/bin/bash
# ===================================================================
#  ASTROWAX PANEL - Professional Installer v3.0
#  Clean Edition | Smart | Minimal | Production Ready
#  AWP = ASTROWAX PANEL
#  Crafted by Itzytansh
# ===================================================================

set -o pipefail

# ───────────────────────────────────────────────────────────────────
#  Colors - Professional
# ───────────────────────────────────────────────────────────────────
if [[ $(tput colors 2>/dev/null) -ge 256 ]]; then
    C_RESET='\033[0m'
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_RED='\033[38;5;203m'
    C_GREEN='\033[38;5;42m'
    C_YELLOW='\033[38;5;221m'
    C_BLUE='\033[38;5;75m'
    C_CYAN='\033[38;5;80m'
    C_PURPLE='\033[38;5;141m'
    C_WHITE='\033[38;5;231m'
    C_GRAY='\033[38;5;244m'
    C_GRAY_L='\033[38;5;250m'
else
    C_RESET='\033[0m'
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_RED='\033[0;31m'
    C_GREEN='\033[0;32m'
    C_YELLOW='\033[0;33m'
    C_BLUE='\033[0;34m'
    C_CYAN='\033[0;36m'
    C_PURPLE='\033[0;35m'
    C_WHITE='\033[1;37m'
    C_GRAY='\033[0;90m'
    C_GRAY_L='\033[0;37m'
fi

# ───────────────────────────────────────────────────────────────────
#  Logging - Clean
# ───────────────────────────────────────────────────────────────────
log_info()    { echo -e "  ${C_GRAY}•${C_RESET} $1"; }
log_ok()      { echo -e "  ${C_GREEN}✓${C_RESET} ${C_WHITE}$1${C_RESET}"; }
log_warn()    { echo -e "  ${C_YELLOW}!${C_RESET} ${C_YELLOW}$1${C_RESET}"; }
log_err()     { echo -e "  ${C_RED}x${C_RESET} ${C_RED}$1${C_RESET}"; }
log_step()    { echo -e "  ${C_BLUE}>${C_RESET} ${C_BOLD}$1${C_RESET}"; }

# ───────────────────────────────────────────────────────────────────
#  Banner - Big Bold AWP
# ───────────────────────────────────────────────────────────────────
print_banner() {
    clear 2>/dev/null || true
    echo -e "${C_CYAN}${C_BOLD}"
    cat << 'EOF'
      █████╗ ██╗    ██╗██████╗ 
     ██╔══██╗██║    ██║██╔══██╗
     ███████║██║ █╗ ██║██████╔╝
     ██╔══██║██║███╗██║██╔═══╝ 
     ██║  ██║╚███╔███╔╝██║     
     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝     
EOF
    echo -e "${C_RESET}"
    echo -e "  ${C_WHITE}${C_BOLD}ASTROWAX PANEL${C_RESET}  ${C_GRAY}—  AWP = ASTROWAX PANEL${C_RESET}"
    echo -e "  ${C_GRAY}Professional Control  |  v1.80  |  by Itzytansh${C_RESET}"
    echo -e "  ${C_DIM}──────────────────────────────────────────────────────${C_RESET}"
    echo ""
}

print_header() {
    local title="$1"
    local sub="$2"
    echo -e "${C_WHITE}${C_BOLD}${title}${C_RESET}"
    [[ -n "$sub" ]] && echo -e "${C_GRAY}${sub}${C_RESET}"
    echo -e "${C_GRAY}──────────────────────────────────────────────────────${C_RESET}"
    echo ""
}

# ───────────────────────────────────────────────────────────────────
#  Helpers
# ───────────────────────────────────────────────────────────────────
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
    if [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
        echo "$(pwd)/$WORK_DIR_NAME/$PANEL_DIR_NAME"; return 0
    fi
    local found=$(find . -maxdepth 4 -name "package.json" -not -path "*/node_modules/*" -not -path "*/dist/*" 2>/dev/null | while read f; do
        grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null && echo "$f" && break
    done | head -1)
    if [ -n "$found" ]; then echo "$(cd "$(dirname "$found")" && pwd)"; return 0; fi
    echo ""; return 1
}

execute_step() {
    local msg="$1"; shift
    local log_file="/tmp/awp_$$_$RANDOM.log"
    rm -f "$log_file"

    printf "  ${C_GRAY}[....]${C_RESET} %-48s" "$msg"
    "$@" >"$log_file" 2>&1 &
    local pid=$!
    local spin='|/-\'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        printf "\r  ${C_BLUE}[%c]${C_RESET} %-48s" "${spin:i++%${#spin}:1}" "$msg"
        sleep 0.1
    done
    wait $pid
    local rc=$?

    if [ $rc -eq 0 ]; then
        printf "\r  ${C_GREEN}[ OK ]${C_RESET} %-48s ${C_GRAY}[done]${C_RESET}\n" "$msg"
    else
        printf "\r  ${C_RED}[FAIL]${C_RESET} %-48s ${C_RED}[error]${C_RESET}\n" "$msg"
        echo ""
        echo -e "  ${C_RED}Error: $msg (exit $rc)${C_RESET}"
        [ -s "$log_file" ] && sed 's/^/    /' "$log_file" | tail -n 20
        echo ""
    fi
    rm -f "$log_file"
    return $rc
}

# ───────────────────────────────────────────────────────────────────
#  Config
# ───────────────────────────────────────────────────────────────────
GH_USER="${ASTROWAX_GH_USER:-AstroVoidHostDev}"
GH_REPO="${ASTROWAX_GH_REPO:-astrowax}"
GH_BRANCH="${ASTROWAX_GH_BRANCH:-main}"
GH_ARCHIVE="${ASTROWAX_GH_ARCHIVE:-panel.zip}"
WORK_DIR_NAME="panel"
PANEL_DIR_NAME="astrowax-panel"
EXPECTED_PKG_NAME="astrowax-panel"
MAIN_PROCESS="astrowax-main"
MAIN_CONTAINER="astrowax-main"
MAIN_PORT="6767"
SFTP_PORT="6868"
SELECTED_VERSION=""

# ───────────────────────────────────────────────────────────────────
#  System Deps
# ───────────────────────────────────────────────────────────────────
check_system_deps() {
    for cmd in curl git tar unzip; do
        command -v "$cmd" &> /dev/null && continue
        if command -v apt-get &> /dev/null; then
            sudo apt-get update -y -q > /dev/null 2>&1
            sudo apt-get install -y $cmd build-essential ca-certificates -q > /dev/null 2>&1
        elif command -v yum &> /dev/null; then
            sudo yum install -y $cmd -q > /dev/null 2>&1
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y $cmd -q > /dev/null 2>&1
        fi
    done
}

download_panel_v180() {
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.zip"
    local START_DIR=$(pwd)
    rm -rf "$WORK_DIR_NAME" "$GH_ARCHIVE" 2>/dev/null

    if ! curl -fsSL "$archive_url" -o "$GH_ARCHIVE" 2>/dev/null; then
        curl -fsSL "$main_archive_url" -o "/tmp/${GH_REPO}.zip" 2>/dev/null || return 1
        unzip -q -o "/tmp/${GH_REPO}.zip" -d /tmp/awp_extract 2>/dev/null || return 1
        local found=$(find /tmp/awp_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        [ -z "$found" ] && return 1
        cp "$found" "$GH_ARCHIVE"
        rm -rf /tmp/awp_extract "/tmp/${GH_REPO}.zip"
    fi

    mkdir -p "$WORK_DIR_NAME"
    unzip -q -o "$GH_ARCHIVE" -d "$WORK_DIR_NAME" 2>/dev/null || return 1
    rm -f "$GH_ARCHIVE"

    local actual_panel=$(find "$WORK_DIR_NAME" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do
        grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null && echo "$f" && break
    done | head -1)
    [ -z "$actual_panel" ] && return 1
    local actual_dir=$(dirname "$actual_panel")
    if [ "$actual_dir" != "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
        rm -rf "$WORK_DIR_NAME/$PANEL_DIR_NAME"
        mv "$actual_dir" "$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi
    cd "$START_DIR"
}

install_docker() {
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com | sh > /dev/null 2>&1 || true
        command -v systemctl &> /dev/null && sudo systemctl enable --now docker > /dev/null 2>&1 || true
    fi
    command -v docker &> /dev/null
}

install_node() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }

    if ! command -v nvm >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash > /dev/null 2>&1 || true
        export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    fi

    if command -v nvm >/dev/null 2>&1; then
        nvm install 20 > /dev/null 2>&1 || true
        nvm use 20 > /dev/null 2>&1 || true
        nvm alias default 20 > /dev/null 2>&1 || true
    fi

    if ! command -v node &> /dev/null; then
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - > /dev/null 2>&1 || true
            sudo apt-get install -y nodejs > /dev/null 2>&1 || true
        fi
    fi
    command -v node &> /dev/null
}

install_java() {
    command -v java &> /dev/null && return 0
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -y -q > /dev/null 2>&1 || true
        sudo apt-get install -y -q openjdk-21-jre-headless > /dev/null 2>&1 || \
        sudo apt-get install -y -q openjdk-17-jre-headless > /dev/null 2>&1 || true
    fi
}

setup_node_env() {
    local RUNTIME_PREF=$1
    install_node
    if ! command -v pm2 &> /dev/null; then
        sudo npm install -g pm2 > /dev/null 2>&1 || npm install -g pm2 > /dev/null 2>&1 || true
    fi
    local DEFAULT_RT="docker"; local ENABLE_DOCKER="true"
    if [ "$RUNTIME_PREF" = "local" ]; then DEFAULT_RT="local"; ENABLE_DOCKER="false"; else
        command -v docker &> /dev/null || install_docker 2>/dev/null || true
        [ -S "/var/run/docker.sock" ] && sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
    fi
    cat << EOF2 > ecosystem.config.cjs
module.exports = {
  apps: [{
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
  }]
};
EOF2
}

install_dependencies() {
    [ -f "package.json" ] || return 1
    [ -f ".npmrc" ] || echo "legacy-peer-deps=true" > .npmrc
    rm -rf node_modules package-lock.json 2>/dev/null || true
    npm cache clean --force > /dev/null 2>&1 || true
    npm install --legacy-peer-deps --no-audit --no-fund > /dev/null 2>&1
}

build_application() {
    [ -f "package.json" ] || return 1
    rm -rf dist 2>/dev/null || true
    NODE_OPTIONS="--max-old-space-size=2048" npm run build > /dev/null 2>&1
    [ -f "dist/server.cjs" ]
}

# ───────────────────────────────────────────────────────────────────
#  Panel Control
# ───────────────────────────────────────────────────────────────────
start_panel_node() {
    local TARGET=$1
    command -v fuser &> /dev/null && fuser -k ${MAIN_PORT}/tcp 2>/dev/null || true
    pkill -f "node.*server.cjs" 2>/dev/null || true
    run_pm2 delete "$TARGET" 2>/dev/null || true
    run_pm2 start ecosystem.config.cjs --only "$TARGET" > /dev/null 2>&1
    run_pm2 save --force 2>/dev/null || true
}

stop_panel() {
    print_banner
    print_header "Stop Panel" "Shutting down services"
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f $MAIN_CONTAINER 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true
    log_ok "Services stopped"
    echo ""; show_status
}

start_panel() {
    print_banner
    print_header "Start Panel" "Initializing services"
    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then log_err "Panel not found. Install first."; return 1; fi
    cd "$PANEL_PATH"
    [ -f "ecosystem.config.cjs" ] || setup_node_env "docker"
    [ -f "dist/server.cjs" ] || { install_dependencies; build_application; }
    start_panel_node "$MAIN_PROCESS"
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 15 ]; do
        curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && { log_ok "Panel is ONLINE"; show_status; return 0; }
        sleep 2; ATTEMPTS=$((ATTEMPTS+1))
    done
    log_err "Failed to start"; run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true; return 1
}

restart_panel() {
    print_banner
    print_header "Restart Panel" "Refreshing services"
    local PANEL_PATH=$(find_panel_dir)
    [ -z "$PANEL_PATH" ] && { log_err "Panel not found."; return 1; }
    cd "$PANEL_PATH"
    run_pm2 restart "$MAIN_PROCESS" 2>/dev/null || start_panel_node "$MAIN_PROCESS"
    sleep 3
    curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && { log_ok "Restarted successfully"; show_status; return 0; }
    log_err "Restart failed"; return 1
}

show_status() {
    local MAIN_STATUS="OFFLINE" COLOR="$C_RED"
    if (run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -q "online") || curl -s -m 2 http://127.0.0.1:${MAIN_PORT}/ >/dev/null 2>&1; then
        MAIN_STATUS="ONLINE"; COLOR="$C_GREEN"
    fi
    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")
    echo ""
    echo -e "  ${C_GRAY}──────────────────────────────────────────────────────${C_RESET}"
    echo -e "  ${C_WHITE}${C_BOLD}STATUS DASHBOARD${C_RESET}"
    echo -e "  ${C_GRAY}──────────────────────────────────────────────────────${C_RESET}"
    echo -e "  ${C_GRAY}Version      :${C_RESET} ${C_WHITE}v${SELECTED_VERSION:-1.80}${C_RESET}"
    echo -e "  ${C_GRAY}Main Panel   :${C_RESET} ${COLOR}${C_BOLD}${MAIN_STATUS}${C_RESET}"
    if [ "$MAIN_STATUS" = "ONLINE" ]; then
        echo -e "  ${C_GRAY}URL          :${C_RESET} ${C_CYAN}http://${IP}:${MAIN_PORT}${C_RESET}"
        echo -e "  ${C_GRAY}Register     :${C_RESET} ${C_CYAN}http://${IP}:${MAIN_PORT}/register${C_RESET}"
    else
        echo -e "  ${C_GRAY}URL          :${C_RESET} ${C_GRAY}Not running${C_RESET}"
    fi
    echo -e "  ${C_GRAY}SFTP Port    :${C_RESET} ${C_WHITE}${SFTP_PORT}${C_RESET}"
    echo -e "  ${C_GRAY}Panel Port   :${C_RESET} ${C_WHITE}${MAIN_PORT}${C_RESET}"
    echo -e "  ${C_GRAY}──────────────────────────────────────────────────────${C_RESET}"
    echo ""
}

# ───────────────────────────────────────────────────────────────────
#  Version Selector - Clean
# ───────────────────────────────────────────────────────────────────
choose_version() {
    print_banner
    print_header "Select Version" "Choose deployment target"
    echo -e "  ${C_WHITE}${C_BOLD}1.${C_RESET} AstroWax Panel v1.80 ${C_GREEN}[Latest]${C_RESET}"
    echo -e "     ${C_GRAY}Node 20 + PM2 + Docker - Production Ready${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}${C_BOLD}2.${C_RESET} AstroWax Panel v1.0 ${C_GRAY}[Legacy]${C_RESET}"
    echo -e "     ${C_GRAY}Classic SQLite - Lightweight${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}${C_BOLD}3.${C_RESET} ${C_GRAY}Back to Menu${C_RESET}"
    echo ""
    local vc=""
    if [ -n "$VERSION_CHOICE" ]; then vc="$VERSION_CHOICE"
    elif [ ! -t 0 ]; then vc="1"
    else echo -ne "  ${C_CYAN}Select [1-3]: ${C_RESET}"; read -r vc; fi
    case "$vc" in
        1) SELECTED_VERSION="1.80" ;;
        2) SELECTED_VERSION="1.0" ;;
        3) return 1 ;;
        *) log_err "Invalid selection"; return 1 ;;
    esac
    return 0
}

# ───────────────────────────────────────────────────────────────────
#  Install v1.80 - Clean
# ───────────────────────────────────────────────────────────────────
install_panel_v180() {
    print_banner
    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        print_header "Download Panel v1.80" "Fetching from GitHub"
        execute_step "Downloading AstroWax Panel" download_panel_v180 || { log_err "Download failed"; exit 1; }
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi
    cd "$PANEL_PATH" || exit 1
    log_info "Working dir: $(pwd)"
    echo ""

    print_header "Installation Mode" "Select runtime"
    echo -e "  ${C_WHITE}${C_BOLD}1.${C_RESET} Node.js + PM2 + Docker ${C_GRAY}(Recommended)${C_RESET}"
    echo -e "  ${C_WHITE}${C_BOLD}2.${C_RESET} Pure Local Node.js"
    echo -e "  ${C_WHITE}${C_BOLD}3.${C_RESET} Back"
    echo ""
    local MODE_CHOICE=""
    if [ -n "$RUN_CHOICE" ]; then MODE_CHOICE="$RUN_CHOICE"
    elif [ ! -t 0 ]; then MODE_CHOICE="1"
    else echo -ne "  ${C_CYAN}Select [1-3]: ${C_RESET}"; read -r MODE_CHOICE; fi
    [ "$MODE_CHOICE" = "3" ] && return 1

    mkdir -p .data backups
    if [ ! -f ".env" ]; then
        if [ -f ".env.example" ]; then cp .env.example .env
        else
            echo "PORT=${MAIN_PORT}" > .env
            echo "JWT_SECRET=$(head -c 32 /dev/urandom | base64 2>/dev/null || openssl rand -base64 32)" >> .env
        fi
    fi

    echo ""
    print_header "Installing v1.80" "This may take a few minutes"
    execute_step "Checking system dependencies" check_system_deps
    execute_step "Installing Java runtime" install_java
    local RUNTIME_ARG="docker"; [ "$MODE_CHOICE" = "2" ] && RUNTIME_ARG="local"
    execute_step "Configuring Node.js v20" setup_node_env "$RUNTIME_ARG"
    execute_step "Installing dependencies" install_dependencies
    execute_step "Building application" build_application
    execute_step "Starting service" start_panel_node "$MAIN_PROCESS"

    local ATTEMPTS=0 OK=0
    while [ $ATTEMPTS -lt 30 ]; do
        curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && { OK=1; break; }
        sleep 2; ATTEMPTS=$((ATTEMPTS+1))
    done

    if [ "$OK" != "1" ]; then log_err "Panel failed to start"; run_pm2 logs "$MAIN_PROCESS" --lines 40 --nostream 2>&1 || true; return 1; fi

    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")
    echo ""
    echo -e "  ${C_GREEN}${C_BOLD}Installation Complete${C_RESET}"
    echo -e "  ${C_GRAY}──────────────────────────────────────────────────────${C_RESET}"
    echo -e "  ${C_GRAY}Panel URL :${C_RESET} ${C_CYAN}http://${IP}:${MAIN_PORT}${C_RESET}"
    echo -e "  ${C_GRAY}Register  :${C_RESET} ${C_CYAN}http://${IP}:${MAIN_PORT}/register${C_RESET}"
    echo -e "  ${C_GRAY}Version   :${C_RESET} ${C_WHITE}AstroWax Panel v1.80${C_RESET}"
    echo -e "  ${C_GRAY}Note      :${C_RESET} ${C_YELLOW}First registered user becomes OWNER${C_RESET}"
    echo -e "  ${C_GRAY}──────────────────────────────────────────────────────${C_RESET}"
    echo ""
    show_status
}

install_panel_v10() {
    print_banner
    print_header "Install v1.0 Legacy" "Classic mode"
    echo -e "  ${C_WHITE}1.${C_RESET} Panel Only"
    echo -e "  ${C_WHITE}2.${C_RESET} Node Daemon Only"
    echo -e "  ${C_WHITE}3.${C_RESET} Both"
    echo -e "  ${C_WHITE}4.${C_RESET} Back"
    echo ""
    local V1_CHOICE=""; echo -ne "  ${C_CYAN}Select [1-4]: ${C_RESET}"; read -r V1_CHOICE
    case "$V1_CHOICE" in
        1) bash -c 'set -e; sudo apt-get update -y && sudo apt-get install -y curl git unzip build-essential && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash; export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm install 20; rm -rf ~/AstroWax-Panel; git clone https://github.com/AstroVoidHostDev/AstroWax-Panel ~/AstroWax-Panel; cd ~/AstroWax-Panel; unzip -oq panel.zip; cd panel; npm install --legacy-peer-deps; npm run seed; npm run createUser' ;;
        2) bash -c 'set -e; sudo apt-get update -y && sudo apt-get install -y curl git zip unzip build-essential; curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash; export NVM_DIR="$HOME/.nvm"; . "$NVM_DIR/nvm.sh"; nvm install 20; rm -rf ~/WaxDaemon; git clone https://github.com/AstroVoidHostDev/WaxDaemon ~/WaxDaemon; cd ~/WaxDaemon; unzip -oq waxdaemon.zip; cd daemon/daemon; npm install --legacy-peer-deps' ;;
        3) install_panel_v10 ;;
        4) return 0 ;;
    esac
}

update_panel() {
    print_banner
    print_header "Update Panel" "Fetching latest version"
    local PANEL_PATH=$(find_panel_dir)
    [ -z "$PANEL_PATH" ] && { log_err "Panel not installed"; return 1; }
    cd "$PANEL_PATH"
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    curl -fsSL "$archive_url" -o "/tmp/awp_update.zip" || { log_err "Download failed"; return 1; }
    local temp_dir="/tmp/awp_update_$$"; mkdir -p "$temp_dir/new"
    unzip -q -o "/tmp/awp_update.zip" -d "$temp_dir/new"
    local found=$(find "$temp_dir/new" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null && echo "$f" && break; done | head -1)
    [ -z "$found" ] && { log_err "Update package invalid"; rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1; }
    local new_root=$(dirname "$found")
    run_pm2 stop "$MAIN_PROCESS" 2>/dev/null || true
    local PRESERVE="/tmp/awp_preserve_$$"; mkdir -p "$PRESERVE"
    [ -f ".env" ] && cp ".env" "$PRESERVE/" 2>/dev/null; [ -d ".data" ] && cp -r ".data" "$PRESERVE/" 2>/dev/null
    tar -czf "astrowax-backup-$(date +%Y%m%d_%H%M%S).tar.gz" --exclude=node_modules --exclude=.git . 2>/dev/null || true
    rm -rf src server public 2>/dev/null; rm -f package.json package-lock.json index.html vite.config.ts tsconfig.json server.ts ecosystem.config.cjs 2>/dev/null
    cp -r "$new_root"/* . 2>/dev/null || true
    [ -f "$PRESERVE/.env" ] && cp "$PRESERVE/.env" . 2>/dev/null; [ -d "$PRESERVE/.data" ] && cp -r "$PRESERVE/.data" . 2>/dev/null; rm -rf "$PRESERVE"
    execute_step "Installing dependencies" install_dependencies
    execute_step "Building application" build_application
    execute_step "Restarting panel" start_panel_node "$MAIN_PROCESS"
    rm -rf "$temp_dir" "/tmp/awp_update.zip"
    log_ok "Update complete"; show_status
}

uninstall_panel() {
    print_banner
    print_header "Uninstall Panel" "This will remove AstroWax Panel"
    echo -e "  ${C_RED}${C_BOLD}Warning: This action is permanent.${C_RESET}"
    echo ""
    echo -ne "  Type ${C_WHITE}yes${C_RESET} to confirm: "; read -r CONFIRM
    [ "$CONFIRM" != "yes" ] && { log_info "Cancelled"; return 0; }
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd); $DOCKER_CLI rm -f "astrowax-main" 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true
    echo -ne "  Delete files? (y/N): "; read -r DELETE_DATA
    if [[ "$DELETE_DATA" =~ ^[Yy]$ ]]; then
        cd "$HOME" || cd /tmp
        local PANEL_PATH=$(find_panel_dir); [ -n "$PANEL_PATH" ] && rm -rf "$PANEL_PATH"
        rm -rf "$HOME/$WORK_DIR_NAME" "$HOME/panel" "$HOME/astrowax-panel" 2>/dev/null
        log_ok "Files removed"
    fi
    log_ok "Uninstall complete"
}

# ───────────────────────────────────────────────────────────────────
#  CLI Args
# ───────────────────────────────────────────────────────────────────
for arg in "$@"; do
    case "$arg" in
        --version=1.0|--v=1.0|-v1.0) VERSION_CHOICE="2" ;;
        --version=1.80|--v=1.80|-v1.80) VERSION_CHOICE="1" ;;
    esac
done

case "$1" in
    install|main) choose_version && { [ "$SELECTED_VERSION" = "1.0" ] && install_panel_v10 || install_panel_v180; }; exit 0 ;;
    update) update_panel; exit 0 ;;
    uninstall) uninstall_panel; exit 0 ;;
    start) start_panel; exit 0 ;;
    stop) stop_panel; exit 0 ;;
    restart) restart_panel; exit 0 ;;
    status) show_status; exit 0 ;;
esac

# ───────────────────────────────────────────────────────────────────
#  Interactive Menu - Professional
# ───────────────────────────────────────────────────────────────────
while true; do
    print_banner
    echo -e "  ${C_WHITE}${C_BOLD}MAIN MENU${C_RESET}"
    echo ""
    echo -e "  ${C_WHITE}1.${C_RESET} Install Panel       ${C_GRAY}- Deploy fresh installation${C_RESET}"
    echo -e "  ${C_WHITE}2.${C_RESET} Update Panel        ${C_GRAY}- Upgrade to latest${C_RESET}"
    echo -e "  ${C_WHITE}3.${C_RESET} Start Panel         ${C_GRAY}- Power on services${C_RESET}"
    echo -e "  ${C_WHITE}4.${C_RESET} Stop Panel          ${C_GRAY}- Graceful shutdown${C_RESET}"
    echo -e "  ${C_WHITE}5.${C_RESET} Restart Panel       ${C_GRAY}- Refresh services${C_RESET}"
    echo -e "  ${C_WHITE}6.${C_RESET} Show Status         ${C_GRAY}- View dashboard${C_RESET}"
    echo -e "  ${C_WHITE}7.${C_RESET} Uninstall Panel     ${C_GRAY}- Remove installation${C_RESET}"
    echo -e "  ${C_WHITE}8.${C_RESET} Exit"
    echo ""
    echo -e "  ${C_GRAY}AstroWax Panel v1.80 | AWP = ASTROWAX PANEL | Itzytansh${C_RESET}"
    echo ""
    echo -ne "  ${C_CYAN}Select [1-8]: ${C_RESET}"
    read -r CHOICE || break
    case "$CHOICE" in
        1) choose_version && { [ "$SELECTED_VERSION" = "1.0" ] && install_panel_v10 || install_panel_v180; }; echo ""; read -p "  Press Enter to continue..." ;;
        2) update_panel; echo ""; read -p "  Press Enter to continue..." ;;
        3) start_panel; echo ""; read -p "  Press Enter to continue..." ;;
        4) stop_panel; echo ""; read -p "  Press Enter to continue..." ;;
        5) restart_panel; echo ""; read -p "  Press Enter to continue..." ;;
        6) show_status; echo ""; read -p "  Press Enter to continue..." ;;
        7) uninstall_panel; echo ""; read -p "  Press Enter to continue..." ;;
        8) echo ""; echo -e "  ${C_GRAY}Goodbye. Thanks for using AstroWax Panel.${C_RESET}"; echo ""; exit 0 ;;
        *) log_err "Invalid option"; sleep 1 ;;
    esac
done
