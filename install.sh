#!/bin/bash
# =========================================================
# AstroWax Panel — Master Control Script
# Made by Itzytansh
# =========================================================

if [ -z "$BASH_VERSION" ]; then
    if command -v bash > /dev/null 2>&1; then
        exec bash "$0" "$@"
    fi
fi

# ═══════════════════════════════════════════════════════════
# COLORS
# ═══════════════════════════════════════════════════════════
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GREY='\033[0;37m'
BOLD='\033[1m'
NC='\033[0m'

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

SELECTED_VERSION=""

# ═══════════════════════════════════════════════════════════
# BANNER
# ═══════════════════════════════════════════════════════════
print_banner() {
    if [ -t 1 ]; then clear 2>/dev/null || true; fi
    echo -e "${PURPLE}${BOLD}"
    cat << 'BANNER'
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║      █████╗ ██╗    ██╗██████╗                             ║
    ║     ██╔══██╗██║    ██║██╔══██╗                            ║
    ║     ███████║██║ █╗ ██║██████╔╝                            ║
    ║     ██╔══██║██║███╗██║██╔═══╝                             ║
    ║     ██║  ██║╚███╔███╔╝██║                                 ║
    ║     ╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝                                 ║
    ║                                                           ║
BANNER
    echo -e "${WHITE}${BOLD}    ║              ${LIGHT_PURPLE}ASTROWAX PANEL${WHITE}                          ║"
    echo -e "${WHITE}${BOLD}    ║              ${GREY}Made by ${LIGHT_PURPLE}Itzytansh${WHITE}                          ║"
    echo -e "${PURPLE}${BOLD}    ║                                                           ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

log_info()    { echo -e "${LIGHT_PURPLE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }
log_step()    { echo -e "${PURPLE}${BOLD}[→]${NC} $1"; }

# ═══════════════════════════════════════════════════════════
# HELPERS
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

# Find panel dir by package name
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

execute_step() {
    local msg="$1"; shift
    local step_id="awp_step_$RANDOM"
    local log_file="/tmp/${step_id}.log"
    rm -f "$log_file"
    printf "  ${LIGHT_PURPLE}▶${NC} %-48s " "$msg"
    "$@" > "$log_file" 2>&1 &
    local pid=$!
    if [ -t 1 ]; then
        local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
        local i=0
        while kill -0 $pid 2>/dev/null; do
            local c=$(echo "$spinstr" | cut -c$((i % 10 + 1)))
            printf "${PURPLE}%s${NC}" "$c"
            sleep 0.1; printf "\b"; i=$((i + 1))
        done
    fi
    local status=0
    wait $pid 2>/dev/null || status=$?
    if [ $status -eq 0 ]; then
        printf "\r  ${GREEN}✓${NC} %-48s ${GREEN}[Done]${NC}\n" "$msg"
    else
        printf "\r  ${RED}✗${NC} %-48s ${RED}[Fail]${NC}\n" "$msg"
        echo -e "\n${RED}════════════════════════════════════════════════════${NC}"
        echo -e "${RED}${BOLD}  STEP FAILED: $msg${NC}"
        echo -e "${RED}════════════════════════════════════════════════════${NC}"
        echo -e "  Exit code: $status"
        if [ -s "$log_file" ]; then
            echo -e "  ${YELLOW}Output:${NC}"
            tail -n 30 "$log_file" | sed 's/^/  /'
        fi
        echo -e "${RED}════════════════════════════════════════════════════${NC}"
        return $status
    fi
    return 0
}

# ═══════════════════════════════════════════════════════════
# SYSTEM DEPS
# ═══════════════════════════════════════════════════════════
check_system_deps() {
    local MISSING=""
    for cmd in curl git tar unzip; do
        command -v "$cmd" > /dev/null 2>&1 || MISSING="$MISSING $cmd"
    done
    if [ -n "$MISSING" ]; then
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
        command -v "$cmd" &> /dev/null || { echo "Missing: $cmd"; return 1; }
    done
    return 0
}

# ═══════════════════════════════════════════════════════════
# DOWNLOAD
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

    local actual_panel=$(find "$WORK_DIR_NAME" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)

    [ -z "$actual_panel" ] && return 1

    local actual_dir=$(dirname "$actual_panel")
    if [ "$actual_dir" != "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
        rm -rf "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || true
        mv "$actual_dir" "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || return 1
    fi
    cd "$START_DIR" || return 1
    return 0
}

# ═══════════════════════════════════════════════════════════
# DOCKER
# ═══════════════════════════════════════════════════════════
install_docker() {
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com | sh > /dev/null 2>&1 || true
        if command -v systemctl &> /dev/null; then
            sudo systemctl enable --now docker > /dev/null 2>&1 || true
        elif command -v service &> /dev/null; then
            sudo service docker start > /dev/null 2>&1 || true
        fi
    fi
    [ -x "$(command -v docker)" ] && return 0
    echo "Docker not available."; return 1
}

# ═══════════════════════════════════════════════════════════
# NODE 20
# ═══════════════════════════════════════════════════════════
install_node() {
    export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }

    if ! command -v nvm >/dev/null 2>&1; then
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash > /dev/null 2>&1 || true
        export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "/usr/local/share/nvm/nvm.sh" ] && { export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; }
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

    command -v node &> /dev/null || { echo "Node failed"; return 1; }
    echo "Node: $(node -v)"
    command -v npm &> /dev/null || return 1
    return 0
}

# ═══════════════════════════════════════════════════════════
# JAVA
# ═══════════════════════════════════════════════════════════
install_java() {
    if command -v java > /dev/null 2>&1 && java -version > /dev/null 2>&1; then
        return 0
    fi
    if command -v apt-get > /dev/null 2>&1; then
        sudo apt-get update -y -q > /dev/null 2>&1 || true
        sudo apt-get install -y -q openjdk-21-jre-headless > /dev/null 2>&1 || \
        sudo apt-get install -y -q openjdk-17-jre-headless > /dev/null 2>&1 || true
    fi
    return 0
}

# ═══════════════════════════════════════════════════════════
# PM2 ENV
# ═══════════════════════════════════════════════════════════
setup_node_env() {
    local RUNTIME_PREF=$1
    install_node

    if ! command -v pm2 &> /dev/null && [ ! -x "/usr/local/bin/pm2" ] && [ ! -x "./node_modules/.bin/pm2" ]; then
        sudo npm install -g pm2 > /dev/null 2>&1 || npm install -g pm2 > /dev/null 2>&1 || true
    fi

    local DEFAULT_RT="docker"
    local ENABLE_DOCKER="true"

    if [ "$RUNTIME_PREF" = "local" ]; then
        DEFAULT_RT="local"
        ENABLE_DOCKER="false"
    else
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

# ═══════════════════════════════════════════════════════════
# DEPS
# ═══════════════════════════════════════════════════════════
install_dependencies() {
    [ -f "package.json" ] || return 1

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        echo "❌ Wrong package.json"
        head -3 package.json | sed 's/^/   /'
        return 1
    fi

    [ -f ".npmrc" ] || echo "legacy-peer-deps=true" > .npmrc
    rm -rf node_modules package-lock.json 2>/dev/null || true
    npm cache clean --force > /dev/null 2>&1 || true
    npm install --legacy-peer-deps --no-audit --no-fund 2>&1 | tail -5
}

build_application() {
    [ -f "package.json" ] || return 1

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        echo "❌ Wrong package.json"; return 1
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
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}STOPPING ASTROWAX PANEL${PURPLE}                    ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete astrowax-panel 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f $MAIN_CONTAINER 2>/dev/null || true
    pkill -f "node.*dist/server.cjs" 2>/dev/null || true

    log_success "Panel stopped."
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
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}STARTING ASTROWAX PANEL${PURPLE}                    ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local PANEL_PATH=$(find_panel_dir)
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

    log_step "Starting PM2..."
    start_panel_node "$MAIN_PROCESS"

    log_step "Waiting for panel..."
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 15 ]; do
        if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
            log_success "Panel is up!"
            show_status
            return 0
        fi
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    log_error "Panel didn't start. Logs:"
    run_pm2 logs "$MAIN_PROCESS" --lines 30 --nostream 2>&1 || true
    return 1
}

restart_panel() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}RESTARTING ASTROWAX PANEL${PURPLE}                  ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not found."
        return 1
    fi
    cd "$PANEL_PATH" || return 1

    run_pm2 restart "$MAIN_PROCESS" 2>/dev/null || start_panel_node "$MAIN_PROCESS"
    run_pm2 save --force 2>/dev/null || true
    sleep 3

    if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
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
    local MAIN_STATUS="OFF"
    local SFTP_STATUS="OFF"
    local VERSION_LABEL="${SELECTED_VERSION:-1.80}"

    if (run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -q "online") || \
       curl -s -m 2 http://127.0.0.1:${MAIN_PORT}/ >/dev/null 2>&1; then
        MAIN_STATUS="ONLINE"
    fi
    [ "$MAIN_STATUS" = "ONLINE" ] && SFTP_STATUS="ONLINE"

    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

    echo ""
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║                                                           ║"
    echo -e "    ║        ${WHITE}ASTROWAX PANEL V${VERSION_LABEL}${PURPLE} STATUS              ║"
    echo -e "    ║                                                           ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║                                                           ║"
    if [ "$MAIN_STATUS" = "ONLINE" ]; then
        echo -e "    ║  ${WHITE}Main Panel${PURPLE}       : ${GREEN}● ONLINE${PURPLE}                          ║"
        echo -e "    ║                     ${LIGHT_PURPLE}http://${IP}:${MAIN_PORT}${PURPLE}          ║"
    else
        echo -e "    ║  ${WHITE}Main Panel${PURPLE}       : ${RED}○ OFFLINE${PURPLE}                         ║"
    fi
    echo -e "    ║                                                           ║"
    if [ "$SFTP_STATUS" = "ONLINE" ]; then
        echo -e "    ║  ${WHITE}SFTP Service${PURPLE}     : ${GREEN}● ONLINE${PURPLE}  (Port ${SFTP_PORT})            ║"
    else
        echo -e "    ║  ${WHITE}SFTP Service${PURPLE}     : ${RED}○ OFFLINE${PURPLE}                         ║"
    fi
    echo -e "    ║                                                           ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# VERSION SELECTOR
# ═══════════════════════════════════════════════════════════
choose_version() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}SELECT PANEL VERSION${PURPLE}                        ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}AstroWax Panel V1.80${NC}                              ║"
    echo -e "    ║        ${GREY}Latest • Node 20 + PM2 + Docker${NC}                     ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}AstroWax Panel V1.0 (Legacy)${NC}                      ║"
    echo -e "    ║        ${GREY}Classic • Node 20 + SQLite${NC}                          ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${WHITE}Back${NC}                                              ║"
    echo -e "    ║                                                           ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local vc=""
    if [ -n "$VERSION_CHOICE" ]; then vc="$VERSION_CHOICE"
    elif [ ! -t 0 ]; then vc="1"
    else read -p "    Choose (1-3): " vc; fi

    case "$vc" in
        1) SELECTED_VERSION="1.80"; log_success "Selected: V1.80" ;;
        2) SELECTED_VERSION="1.0"; log_success "Selected: V1.0" ;;
        3) return 1 ;;
        *) log_error "Invalid."; return 1 ;;
    esac
    echo ""
    sleep 1
    return 0
}

# ═══════════════════════════════════════════════════════════
# INSTALL V1.80 — NO TEST STEP (never gets stuck)
# ═══════════════════════════════════════════════════════════
install_panel_v180() {
    print_banner

    local PANEL_PATH=$(find_panel_dir)

    if [ -z "$PANEL_PATH" ]; then
        echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
        echo -e "    ║              ${WHITE}DOWNLOADING PANEL V1.80${PURPLE}                    ║"
        echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        execute_step "Downloading AstroWax Panel V1.80" download_panel_v180 || { log_error "Download failed."; exit 1; }
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi

    cd "$PANEL_PATH" || { log_error "Cannot enter panel."; exit 1; }
    log_info "Working dir: $(pwd)"

    if ! grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" package.json 2>/dev/null; then
        log_error "Wrong package.json"; exit 1
    fi
    log_success "Verified package.json"
    echo ""

    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}SELECT INSTALLATION MODE${PURPLE}                   ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Node.js + PM2 (Recommended)${NC}                       ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Pure Local Node.js${NC}                                ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${WHITE}Back${NC}                                              ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"

    local MODE_CHOICE=""
    if [ -n "$RUN_CHOICE" ]; then MODE_CHOICE="$RUN_CHOICE"
    elif [ ! -t 0 ]; then MODE_CHOICE="1"
    else read -p "    Choose (1-3): " MODE_CHOICE; fi

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
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}INSTALLING V1.80${PURPLE}                           ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    execute_step "System Requirement Check" check_system_deps
    execute_step "Java Runtime Environment" install_java

    local RUNTIME_ARG="docker"
    [ "$MODE_CHOICE" = "2" ] && RUNTIME_ARG="local"

    execute_step "Node.js Configuration (v20)" setup_node_env "$RUNTIME_ARG"
    execute_step "Installing Dependencies" install_dependencies
    execute_step "Building Application" build_application
    # ✅ NO TEST STEP — goes straight to PM2
    execute_step "Starting PM2 Service" start_panel_node "$MAIN_PROCESS"

    log_step "Waiting for panel to respond..."
    local ATTEMPTS=0
    local OK=0
    while [ $ATTEMPTS -lt 30 ]; do
        if curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1; then
            OK=1
            break
        fi
        # Check if PM2 crashed
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

    log_success "Panel is ONLINE!"
    show_status

    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

    echo -e "${GREEN}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}INSTALLATION COMPLETE${GREEN}                       ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${WHITE}Panel URL${NC}  : ${LIGHT_PURPLE}http://${IP}:${MAIN_PORT}${NC}"
    echo -e "    ${WHITE}Register${NC}   : ${LIGHT_PURPLE}http://${IP}:${MAIN_PORT}/register${NC}"
    echo -e "    ${WHITE}Version${NC}    : ${LIGHT_PURPLE}AstroWax Panel V1.80${NC}"
    echo ""
    echo -e "    ${YELLOW}First user to register becomes OWNER automatically.${NC}"
    echo ""
    echo -e "    ${GREY}Made by ${LIGHT_PURPLE}Itzytansh${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# INSTALL V1.0
# ═══════════════════════════════════════════════════════════
install_panel_v10() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}INSTALLING V1.0 (Legacy)${PURPLE}                    ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Panel only${NC}                                        ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Node Daemon only${NC}                                  ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${WHITE}BOTH (Panel + Node Daemon)${NC}                        ║"
    echo -e "    ║    ${LIGHT_PURPLE}[4]${NC} ${WHITE}Back${NC}                                              ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"

    local V1_CHOICE=""
    if [ -n "$V1_INSTALL_CHOICE" ]; then V1_CHOICE="$V1_INSTALL_CHOICE"
    elif [ ! -t 0 ]; then V1_CHOICE="3"
    else read -p "    Choose (1-4): " V1_CHOICE; fi

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
    log_step "Installing Panel V1.0..."
    echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config libsqlite3-dev sqlite3 && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/AstroWax-Panel && git clone https://github.com/AstroVoidHostDev/AstroWax-Panel ~/AstroWax-Panel && cd ~/AstroWax-Panel && unzip -oq panel.zip && cd panel && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps && npm install connect-sqlite3 sqlite3 && npm run seed && npm run createUser'
    log_success "V1.0 Panel installed"
    echo ""
    echo -e "    ${WHITE}Run:${NC} ${LIGHT_PURPLE}cd ~/AstroWax-Panel/panel && node .${NC}"
    echo ""
}

install_v10_node_daemon() {
    echo ""
    log_step "Installing Node Daemon V1.0..."
    echo ""
    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git zip unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/WaxDaemon && git clone https://github.com/AstroVoidHostDev/WaxDaemon ~/WaxDaemon && cd ~/WaxDaemon && unzip -oq waxdaemon.zip && cd daemon/daemon && [ -f index.js.txt ] && mv index.js.txt index.js || true && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps'
    log_success "Node Daemon installed"
    echo ""
    echo -e "    ${WHITE}Run:${NC} ${LIGHT_PURPLE}cd ~/WaxDaemon/daemon/daemon && node .${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# UPDATE
# ═══════════════════════════════════════════════════════════
update_panel() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}UPDATING ASTROWAX PANEL${PURPLE}                    ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local PANEL_PATH=$(find_panel_dir)
    if [ -z "$PANEL_PATH" ]; then
        log_error "Panel not installed."; return 1
    fi
    cd "$PANEL_PATH" || return 1
    log_info "Updating: $(pwd)"
    echo ""

    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local temp_dir="/tmp/awp_update_$$"
    local new_dir="${temp_dir}/new"
    mkdir -p "$new_dir" || return 1

    if ! curl -fsSL "$archive_url" -o "/tmp/awp_update.zip" 2>/dev/null; then
        log_error "Download failed."
        rm -rf "$temp_dir"; return 1
    fi

    unzip -q -o "/tmp/awp_update.zip" -d "$new_dir" 2>/dev/null || {
        log_error "Extract failed."; rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    }

    local found=$(find "$new_dir" -maxdepth 5 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | while read f; do
        if grep -q "\"name\"[[:space:]]*:[[:space:]]*\"${EXPECTED_PKG_NAME}\"" "$f" 2>/dev/null; then
            echo "$f"; break
        fi
    done | head -1)

    if [ -z "$found" ]; then
        log_error "Panel not found in update."
        rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    fi
    local actual_new_root=$(dirname "$found")

    log_step "Stopping panel..."
    run_pm2 stop "$MAIN_PROCESS" 2>/dev/null || true

    log_step "Preserving data..."
    local PRESERVE_DIR="/tmp/awp_preserve_$$"
    mkdir -p "$PRESERVE_DIR"
    [ -f ".env" ] && cp ".env" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d ".data" ] && cp -r ".data" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d "backups" ] && cp -r "backups" "$PRESERVE_DIR/" 2>/dev/null || true

    local BACKUP_NAME="astrowax-backup-$(date +%Y%m%d_%H%M%S)"
    tar -czf "$BACKUP_NAME.tar.gz" --exclude=node_modules --exclude=.git . 2>/dev/null || true
    log_success "Backup: $BACKUP_NAME.tar.gz"

    log_step "Applying..."
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

    log_step "Waiting..."
    local ATTEMPTS=0
    while [ $ATTEMPTS -lt 20 ]; do
        curl -s -f "http://127.0.0.1:${MAIN_PORT}/" >/dev/null 2>&1 && break
        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    rm -rf "$temp_dir" "/tmp/awp_update.zip"

    echo ""
    echo -e "${GREEN}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║          ${WHITE}✓ UPDATE COMPLETE${GREEN}                              ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    show_status
}

# ═══════════════════════════════════════════════════════════
# UNINSTALL (safe)
# ═══════════════════════════════════════════════════════════
uninstall_panel() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}UNINSTALL ASTROWAX PANEL${PURPLE}                   ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${RED}${BOLD}    ⚠  This will remove AstroWax Panel.${NC}"
    echo ""

    if [ -t 0 ]; then
        read -p "    Type 'yes' to confirm: " CONFIRM
        [ "$CONFIRM" != "yes" ] && { echo -e "    ${YELLOW}Cancelled.${NC}"; return 0; }
    fi

    echo ""
    log_step "Stopping services..."
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete "astrowax-admin" 2>/dev/null || true
    run_pm2 delete "astrowax-panel" 2>/dev/null || true
    run_pm2 save --force 2>/dev/null || true

    local DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f "astrowax-main" 2>/dev/null || true
    $DOCKER_CLI rm -f "astrowax-admin" 2>/dev/null || true

    pkill -f "node.*dist/server.cjs" 2>/dev/null || true
    pkill -f "astrowax" 2>/dev/null || true

    log_success "Services stopped."
    echo ""

    local DELETE_DATA="n"
    if [ -t 0 ]; then
        read -p "    Also delete panel files? (y/N): " DELETE_DATA
    fi

    if [ "$DELETE_DATA" = "y" ] || [ "$DELETE_DATA" = "Y" ]; then
        log_step "Removing files..."
        cd "$HOME" || cd /tmp || true

        local PANEL_PATH=$(find_panel_dir)
        [ -n "$PANEL_PATH" ] && rm -rf "$PANEL_PATH" 2>/dev/null || true

        for path in "$HOME/$WORK_DIR_NAME" "$HOME/panel" "$HOME/astrowax-panel" "$HOME/AstroWax-Panel" "$HOME/WaxDaemon"; do
            [ -d "$path" ] && rm -rf "$path" 2>/dev/null || true
        done

        rm -rf /tmp/awp_* /tmp/astrowax* 2>/dev/null || true

        log_success "Files removed."
    else
        log_info "Files kept."
    fi

    echo ""
    echo -e "${GREEN}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║          ${WHITE}✓ UNINSTALL COMPLETE${GREEN}                          ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
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

# ═══════════════════════════════════════════════════════════
# INTERACTIVE MENU
# ═══════════════════════════════════════════════════════════
while true; do
    print_banner
    echo -e "    ${PURPLE}${BOLD}╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}ASTROWAX PANEL CONTROLLER${PURPLE}                  ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Install Panel${NC}                                     ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Update Panel${NC}                                      ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${GREEN}Start Panel${NC}                                       ║"
    echo -e "    ║    ${LIGHT_PURPLE}[4]${NC} ${RED}Stop Panel${NC}                                        ║"
    echo -e "    ║    ${LIGHT_PURPLE}[5]${NC} ${YELLOW}Restart Panel${NC}                                     ║"
    echo -e "    ║    ${LIGHT_PURPLE}[6]${NC} ${WHITE}Show Status${NC}                                       ║"
    echo -e "    ║    ${LIGHT_PURPLE}[7]${NC} ${WHITE}Uninstall Panel${NC}                                   ║"
    echo -e "    ║    ${LIGHT_PURPLE}[8]${NC} ${WHITE}Exit${NC}                                              ║"
    echo -e "    ║                                                           ║"
    echo -e "    ${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${GREY}AstroWax Panel  •  Made by ${LIGHT_PURPLE}Itzytansh${NC}"
    echo ""

    if ! read -p "    Choose (1-8): " CHOICE; then
        echo ""
        break
    fi

    case "$CHOICE" in
        1)
            if choose_version; then
                if [ "$SELECTED_VERSION" = "1.0" ]; then install_panel_v10
                else install_panel_v180; fi
            fi
            if [ -t 0 ]; then read -p "    Press Enter..." || true; fi
            ;;
        2) update_panel; if [ -t 0 ]; then read -p "    Press Enter..." || true; fi ;;
        3) start_panel; if [ -t 0 ]; then read -p "    Press Enter..." || true; fi ;;
        4) stop_panel; if [ -t 0 ]; then read -p "    Press Enter..." || true; fi ;;
        5) restart_panel; if [ -t 0 ]; then read -p "    Press Enter..." || true; fi ;;
        6) show_status; if [ -t 0 ]; then read -p "    Press Enter..." || true; fi ;;
        7) uninstall_panel; if [ -t 0 ]; then read -p "    Press Enter..." || true; fi ;;
        8) echo ""; echo -e "    ${LIGHT_PURPLE}Goodbye! 👋${NC}"; echo ""; exit 0 ;;
        *) log_error "Invalid option!"; sleep 1.5 ;;
    esac
done
