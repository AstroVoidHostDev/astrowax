#!/bin/bash
# =========================================================
# AstroWax Panel Installer
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
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
LIGHT_PURPLE='\033[1;35m'
MAGENTA='\033[0;95m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GREY='\033[0;37m'
BOLD='\033[1m'
DIM='\033[2m'
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
V1_DAEMON_REPO="${ASTROWAX_V1_DAEMON_REPO:-WaxDaemon}"

WORK_DIR_NAME="panel"
PANEL_DIR_NAME="astrowax-panel"
MAIN_PROCESS="astrowax-main"
DEV_PROCESS="astrowax-admin"
MAIN_CONTAINER="astrowax-main"
DEV_CONTAINER="astrowax-admin"
MAIN_PORT="6767"
DEV_PORT="3000"
SFTP_PORT="6868"

SELECTED_VERSION=""

# ═══════════════════════════════════════════════════════════
# ASCII BANNER
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

# ═══════════════════════════════════════════════════════════
# LOGS
# ═══════════════════════════════════════════════════════════
log_info()    { echo -e "${LIGHT_PURPLE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }
log_step()    { echo -e "${PURPLE}${BOLD}[→]${NC} $1"; }

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
    echo -e "    ║        ${GREY}Latest • Modern build system${NC}                        ║"
    echo -e "    ║        ${GREY}Node 22 + PM2 + Docker${NC}                             ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}AstroWax Panel V1.0 (Legacy)${NC}                      ║"
    echo -e "    ║        ${GREY}Classic build • Node 20 + SQLite${NC}                    ║"
    echo -e "    ║        ${GREY}Includes Panel + Node Daemon${NC}                       ║"
    echo -e "    ║                                                           ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [ -n "$VERSION_CHOICE" ]; then
        local vc="$VERSION_CHOICE"
    elif [ ! -t 0 ]; then
        vc="1"
    else
        read -p "    Choose version (1-2): " vc
    fi

    case "$vc" in
        1)
            SELECTED_VERSION="1.80"
            log_success "Selected: AstroWax Panel V1.80"
            ;;
        2)
            SELECTED_VERSION="1.0"
            log_success "Selected: AstroWax Panel V1.0 (Legacy)"
            ;;
        *)
            log_error "Invalid selection."
            exit 1
            ;;
    esac
    echo ""
    sleep 1
}

# ═══════════════════════════════════════════════════════════
# HELPERS
# ═══════════════════════════════════════════════════════════
run_pm2() {
    if [ -x "./node_modules/.bin/pm2" ]; then
        ./node_modules/.bin/pm2 "$@"
    elif command -v pm2 &> /dev/null; then
        pm2 "$@"
    elif [ -x "/usr/local/bin/pm2" ]; then
        /usr/local/bin/pm2 "$@"
    else
        npx --no-install pm2 "$@" 2>/dev/null || npx pm2 "$@"
    fi
}

get_docker_cmd() {
    if docker info > /dev/null 2>&1; then
        echo "docker"
    elif command -v sudo &> /dev/null && sudo docker info > /dev/null 2>&1; then
        echo "sudo docker"
    else
        echo "docker"
    fi
}

get_compose_cmd() {
    local d_cmd=$(get_docker_cmd)
    if $d_cmd compose version > /dev/null 2>&1; then
        echo "$d_cmd compose"
    elif command -v docker-compose > /dev/null 2>&1; then
        echo "docker-compose"
    else
        echo "$d_cmd compose"
    fi
}

execute_step() {
    local msg="$1"
    shift
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
            sleep 0.1
            printf "\b"
            i=$((i + 1))
        done
    fi

    local status=0
    wait $pid 2>/dev/null || status=$?

    if [ $status -eq 0 ]; then
        printf "\r  ${GREEN}✓${NC} %-48s ${GREEN}[Done]${NC}\n" "$msg"
    else
        printf "\r  ${RED}✗${NC} %-48s ${RED}[Fail]${NC}\n" "$msg"
        echo -e "\n${RED}════════════════════════════════════════════════════${NC}"
        echo -e "${RED}${BOLD}  STEP FAILED${NC}"
        echo -e "${RED}════════════════════════════════════════════════════${NC}"
        echo -e "  Step    : ${BOLD}$msg${NC}"
        echo -e "  Exit    : $status"
        echo -e ""
        echo -e "  ${YELLOW}Output / Reason:${NC}"
        if [ -s "$log_file" ]; then
            tail -n 60 "$log_file" | sed 's/^/  /'
        else
            echo "  No output was generated."
        fi
        echo -e "${RED}════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}  Stopped safely.${NC}\n"
        exit 1
    fi
    return $status
}

# ═══════════════════════════════════════════════════════════
# SYSTEM DEPS
# ═══════════════════════════════════════════════════════════
check_system_deps() {
    local MISSING_DEPS=""
    for cmd in curl git tar unzip; do
        if ! command -v "$cmd" > /dev/null 2>&1; then
            MISSING_DEPS="$MISSING_DEPS $cmd"
        fi
    done

    if [ -n "$MISSING_DEPS" ]; then
        if command -v apt-get > /dev/null 2>&1; then
            sudo apt-get update -y -q > /dev/null 2>&1 || true
            sudo apt-get install -y $MISSING_DEPS build-essential ca-certificates -q > /dev/null 2>&1 || true
        elif command -v yum > /dev/null 2>&1; then
            sudo yum update -y -q > /dev/null 2>&1 || true
            sudo yum install -y $MISSING_DEPS make gcc-c++ ca-certificates unzip -q > /dev/null 2>&1 || true
        elif command -v dnf > /dev/null 2>&1; then
            sudo dnf install -y $MISSING_DEPS make gcc-c++ ca-certificates unzip -q > /dev/null 2>&1 || true
        elif command -v apk > /dev/null 2>&1; then
            apk add --no-cache $MISSING_DEPS build-base ca-certificates unzip > /dev/null 2>&1 || true
        fi
    fi

    local total_mem=$(free -m 2>/dev/null | awk '/^Mem:/{print $2}' || echo "2048")
    local total_swap=$(free -m 2>/dev/null | awk '/^Swap:/{print $2}' || echo "0")
    if [ -n "$total_mem" ] && [ "$total_mem" -lt 2000 ] && [ "$total_swap" -lt 512 ]; then
        if command -v swapon &> /dev/null && command -v sudo &> /dev/null; then
            if [ ! -f "/swapfile" ]; then
                if command -v fallocate &> /dev/null; then
                    sudo fallocate -l 2G /swapfile > /dev/null 2>&1 || sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 > /dev/null 2>&1 || true
                else
                    sudo dd if=/dev/zero of=/swapfile bs=1M count=2048 > /dev/null 2>&1 || true
                fi
                sudo chmod 600 /swapfile > /dev/null 2>&1 || true
                sudo mkswap /swapfile > /dev/null 2>&1 || true
                sudo swapon /swapfile > /dev/null 2>&1 || true
            else
                sudo swapon /swapfile > /dev/null 2>&1 || true
            fi
        fi
    fi

    for cmd in curl git tar unzip; do
        if ! command -v "$cmd" &> /dev/null; then
            echo "Missing: $cmd"
            return 1
        fi
    done
    return 0
}

# ═══════════════════════════════════════════════════════════
# DOWNLOAD V1.80 — FIXED (no double nesting)
# ═══════════════════════════════════════════════════════════
download_panel_v180() {
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.zip"

    # Clean any old state
    rm -rf "$WORK_DIR_NAME" "$GH_ARCHIVE" 2>/dev/null || true

    # Download panel.zip
    if curl -fsSL "$archive_url" -o "$GH_ARCHIVE" 2>/dev/null; then
        :
    else
        curl -fsSL "$main_archive_url" -o "/tmp/${GH_REPO}.zip" 2>/dev/null || return 1
        unzip -q -o "/tmp/${GH_REPO}.zip" -d /tmp/awp_extract 2>/dev/null || return 1
        local found=$(find /tmp/awp_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        if [ -z "$found" ]; then return 1; fi
        cp "$found" "$GH_ARCHIVE" 2>/dev/null || return 1
        rm -rf /tmp/awp_extract "/tmp/${GH_REPO}.zip" 2>/dev/null || true
    fi

    if [ ! -f "$GH_ARCHIVE" ]; then return 1; fi

    # ✅ Extract WITHOUT -d — the zip contains panel/astrowax-panel/ internally
    unzip -q -o "$GH_ARCHIVE" 2>/dev/null || return 1
    rm -f "$GH_ARCHIVE" 2>/dev/null || true

    # The result should now be: ./panel/astrowax-panel/
    # Fallback: if structure differs, auto-detect and flatten
    if [ ! -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
        local found_pkg=$(find "$WORK_DIR_NAME" -maxdepth 4 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | head -1)
        if [ -n "$found_pkg" ]; then
            local src_dir=$(dirname "$found_pkg")
            if [ "$src_dir" != "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
                rm -rf "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || true
                mv "$src_dir" "$WORK_DIR_NAME/$PANEL_DIR_NAME" 2>/dev/null || true
            fi
        fi
    fi

    if [ ! -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
        echo "Extraction structure unexpected."
        echo "Contents of $WORK_DIR_NAME:"
        ls -la "$WORK_DIR_NAME" 2>/dev/null || true
        find "$WORK_DIR_NAME" -maxdepth 3 -type d 2>/dev/null
        return 1
    fi
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

    if ! command -v docker &> /dev/null; then
        echo "Docker install failed."; return 1
    fi

    if ! docker info > /dev/null 2>&1; then
        if command -v systemctl &> /dev/null; then
            sudo systemctl start docker > /dev/null 2>&1 || true
        elif command -v service &> /dev/null; then
            sudo service docker start > /dev/null 2>&1 || true
        fi
        if ! docker info > /dev/null 2>&1; then
            if command -v sudo &> /dev/null && sudo docker info > /dev/null 2>&1; then
                sudo usermod -aG docker "$USER" 2>/dev/null || true
            else
                echo "Docker daemon not accessible."; return 1
            fi
        fi
    fi

    local d_cmd=$(get_docker_cmd)
    if ! $d_cmd compose version &> /dev/null && ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null 2>&1 || true
        sudo chmod +x /usr/local/bin/docker-compose > /dev/null 2>&1 || true
    fi

    local c_cmd=$(get_compose_cmd)
    if ! $c_cmd version &> /dev/null; then
        echo "Docker Compose not available."; return 1
    fi
    return 0
}

# ═══════════════════════════════════════════════════════════
# NODE
# ═══════════════════════════════════════════════════════════
install_node() {
    local NEED_NODE=0
    if ! command -v node &> /dev/null; then
        NEED_NODE=1
    else
        local NODE_MAJOR=$(node -v 2>/dev/null | tr -d 'v' | cut -d'.' -f1)
        if [ -z "$NODE_MAJOR" ] || [ "$NODE_MAJOR" -lt 20 ]; then
            NEED_NODE=1
        fi
    fi

    if [ "$NEED_NODE" -eq 1 ]; then
        if command -v apt-get &> /dev/null; then
            curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - > /dev/null 2>&1 || true
            sudo apt-get install -y nodejs > /dev/null 2>&1 || true
        fi

        local CURRENT_MAJOR=0
        if command -v node &> /dev/null; then
            CURRENT_MAJOR=$(node -v 2>/dev/null | tr -d 'v' | cut -d'.' -f1)
        fi

        if [ "$CURRENT_MAJOR" -lt 20 ]; then
            local ARCH=$(uname -m)
            local NODE_ARCH="x64"
            case "$ARCH" in
                x86_64) NODE_ARCH="x64" ;;
                aarch64|arm64) NODE_ARCH="arm64" ;;
                armv7l) NODE_ARCH="armv7l" ;;
            esac
            local NODE_DIST="node-v22.13.1-linux-${NODE_ARCH}"
            curl -fsSL "https://nodejs.org/dist/v22.13.1/${NODE_DIST}.tar.xz" -o /tmp/node22.tar.xz > /dev/null 2>&1 || true
            if [ -f "/tmp/node22.tar.xz" ]; then
                sudo tar -xJf /tmp/node22.tar.xz -C /usr/local --strip-components=1 > /dev/null 2>&1 || true
                rm -f /tmp/node22.tar.xz
            fi
        fi
    fi

    if ! command -v node &> /dev/null; then
        echo "Node.js install failed."; return 1
    fi

    local VER=$(node -v 2>/dev/null | tr -d 'v' | cut -d'.' -f1)
    if [ "$VER" -lt 20 ]; then
        echo "Node.js >= 20 required. Current: $(node -v)"; return 1
    fi

    if ! command -v npm &> /dev/null; then
        echo "npm missing."; return 1
    fi
    return 0
}

# ═══════════════════════════════════════════════════════════
# JAVA
# ═══════════════════════════════════════════════════════════
install_java() {
    if command -v java > /dev/null 2>&1 && java -version > /dev/null 2>&1; then
        return 0
    fi
    echo "Installing Java (OpenJDK) for Minecraft runtime..."
    if command -v apt-get > /dev/null 2>&1; then
        sudo apt-get update -y -q > /dev/null 2>&1 || true
        sudo apt-get install -y -q openjdk-21-jre-headless > /dev/null 2>&1 || \
        sudo apt-get install -y -q openjdk-17-jre-headless > /dev/null 2>&1 || true
    elif command -v dnf > /dev/null 2>&1; then
        sudo dnf install -y java-21-openjdk-headless > /dev/null 2>&1 || true
    elif command -v yum > /dev/null 2>&1; then
        sudo yum install -y java-21-openjdk-headless > /dev/null 2>&1 || true
    elif command -v apk > /dev/null 2>&1; then
        apk add --no-cache openjdk21-jre-headless > /dev/null 2>&1 || true
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
        sudo npm install -g pm2 > /dev/null 2>&1 || npm install -g pm2 > /dev/null 2>&1 || npm install --save-dev pm2 > /dev/null 2>&1 || true
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
    },
    {
      name: "${DEV_PROCESS}",
      script: "npm",
      args: "run dev",
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: "2G",
      env: {
        NODE_ENV: "development",
        PORT: ${DEV_PORT},
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
# DEPS / BUILD / OWNER
# ═══════════════════════════════════════════════════════════
install_dependencies() {
    if [ ! -f "package.json" ]; then
        echo "package.json not found in $(pwd)."; return 1
    fi
    if [ -d "node_modules" ] && [ -x "node_modules/.bin/vite" ] && [ -x "node_modules/.bin/esbuild" ] && [ -x "node_modules/.bin/tsx" ]; then
        return 0
    fi
    npm install --no-audit --no-fund --legacy-peer-deps 2>&1 || npm install --no-audit --no-fund 2>&1
}

setup_owner() {
    npm run createuser
}

build_application() {
    npm run build
    if [ ! -f "dist/server.cjs" ] || [ ! -f "dist/index.html" ]; then
        echo "Build failed: dist/server.cjs or dist/index.html missing."
        return 1
    fi
}

# ═══════════════════════════════════════════════════════════
# START / STOP
# ═══════════════════════════════════════════════════════════
stop_panel() {
    log_step "Stopping running panels..."
    run_pm2 delete "$MAIN_PROCESS" 2>/dev/null || true
    run_pm2 delete "$DEV_PROCESS" 2>/dev/null || true
    local DOCKER_CLI=$(get_docker_cmd)
    $DOCKER_CLI rm -f $MAIN_CONTAINER $DEV_CONTAINER 2>/dev/null || true
    log_success "Stopped."
}

start_panel_node() {
    local TARGET=$1
    if [ "$TARGET" = "$MAIN_PROCESS" ]; then
        run_pm2 delete astrowax-panel 2>/dev/null || true
        local DOCKER_CLI=$(get_docker_cmd)
        $DOCKER_CLI rm -f $MAIN_CONTAINER astrowax-panel 2>/dev/null || true
    fi
    if command -v systemctl &> /dev/null; then
        systemctl enable --now docker 2>/dev/null || sudo systemctl enable --now docker 2>/dev/null || true
    fi
    if [ -S "/var/run/docker.sock" ]; then
        chmod 666 /var/run/docker.sock 2>/dev/null || sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
    fi
    run_pm2 delete "$TARGET" 2>/dev/null || true
    run_pm2 start ecosystem.config.cjs --only "$TARGET"
    run_pm2 save --force 2>/dev/null || true
}

# ═══════════════════════════════════════════════════════════
# HEALTH CHECK
# ═══════════════════════════════════════════════════════════
health_check() {
    local PORT=$1
    local RUNTIME_TYPE=$2
    local TARGET=$3
    local ATTEMPTS=0
    local MAX_ATTEMPTS=30

    while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
        if curl -s -f "http://127.0.0.1:${PORT}/api/health" >/dev/null 2>&1 || curl -s -f "http://127.0.0.1:${PORT}/" >/dev/null 2>&1; then
            return 0
        fi

        if [ "$RUNTIME_TYPE" = "docker" ]; then
            local DOCKER_CLI=$(get_docker_cmd)
            local cstatus=$($DOCKER_CLI inspect --format '{{.State.Status}}' "$TARGET" 2>/dev/null || echo "not_found")
            if [ "$cstatus" = "exited" ] || [ "$cstatus" = "dead" ] || [ "$cstatus" = "not_found" ]; then
                echo "Container $TARGET not running ($cstatus)."
                $DOCKER_CLI logs "$TARGET" --tail 50 2>&1 || true
                return 1
            fi
        else
            if run_pm2 list 2>/dev/null | grep "$TARGET" | grep -qE "errored|stopped"; then
                echo "PM2 process $TARGET crashed."
                run_pm2 logs "$TARGET" --lines 40 --nostream 2>&1 || true
                return 1
            fi
        fi

        sleep 2
        ATTEMPTS=$((ATTEMPTS + 1))
    done

    echo "Health check timed out."
    run_pm2 list || true
    run_pm2 logs "$TARGET" --lines 50 --nostream 2>&1 || true
    return 1
}

# ═══════════════════════════════════════════════════════════
# STATUS
# ═══════════════════════════════════════════════════════════
show_status() {
    local MAIN_STATUS="OFF"
    local DEV_STATUS="OFF"
    local SFTP_STATUS="OFF"
    local VERSION_LABEL="${SELECTED_VERSION:-1.80}"

    if (run_pm2 list 2>/dev/null | grep "$MAIN_PROCESS" | grep -q "online") || \
       curl -s -m 2 http://127.0.0.1:${MAIN_PORT}/api/health 2>/dev/null | grep -qi "astrowax"; then
        MAIN_STATUS="ONLINE"
    fi

    if (run_pm2 list 2>/dev/null | grep "$DEV_PROCESS" | grep -q "online") || \
       curl -s -m 2 http://127.0.0.1:${DEV_PORT}/api/health 2>/dev/null | grep -qi "astrowax"; then
        DEV_STATUS="ONLINE"
    fi

    if [ "$MAIN_STATUS" = "ONLINE" ] || [ "$DEV_STATUS" = "ONLINE" ]; then
        SFTP_STATUS="ONLINE"
    fi

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
    if [ "$DEV_STATUS" = "ONLINE" ]; then
        echo -e "    ║  ${WHITE}Developer Panel${PURPLE}  : ${GREEN}● ONLINE${PURPLE}                          ║"
        echo -e "    ║                     ${LIGHT_PURPLE}http://${IP}:${DEV_PORT}${PURPLE}           ║"
    else
        echo -e "    ║  ${WHITE}Developer Panel${PURPLE}  : ${YELLOW}○ OFFLINE${PURPLE}                         ║"
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
# INSTALL — V1.80
# ═══════════════════════════════════════════════════════════
install_panel_v180() {
    local TARGET=$1

    print_banner

    local PANEL_PATH=""
    if [ -f "package.json" ] && [ -d "src" ]; then
        PANEL_PATH="."
    elif [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi

    if [ -z "$PANEL_PATH" ]; then
        echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
        echo -e "    ║              ${WHITE}DOWNLOADING PANEL V1.80${PURPLE}                    ║"
        echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        execute_step "Downloading AstroWax Panel V1.80" download_panel_v180
        if [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
            PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
        else
            log_error "Panel not found after download."
            log_info "Checking for extracted files..."
            find . -maxdepth 4 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null
            exit 1
        fi
    fi

    cd "$PANEL_PATH" || { log_error "Cannot enter panel dir."; exit 1; }
    log_info "Working directory: $(pwd)"
    echo ""

    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}SELECT INSTALLATION MODE${PURPLE}                   ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Node.js + PM2 (Recommended)${NC}                       ║"
    echo -e "    ║        ${GREY}Docker used for Minecraft servers${NC}                  ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Pure Local Node.js${NC}                                ║"
    echo -e "    ║        ${GREY}Node.js/Local for Minecraft servers${NC}                ║"
    echo -e "    ║                                                           ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"

    local MODE_CHOICE=""
    if [ -n "$RUN_CHOICE" ]; then
        MODE_CHOICE="$RUN_CHOICE"
    elif [ ! -t 0 ]; then
        MODE_CHOICE="1"
    else
        read -p "    Choose (1-2): " MODE_CHOICE
    fi

    if [ "$MODE_CHOICE" != "1" ] && [ "$MODE_CHOICE" != "2" ]; then
        log_error "Invalid selection."; exit 1
    fi

    if [ "$TARGET" = "main" ]; then
        print_banner
        echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
        echo -e "    ║              ${WHITE}CREATE OWNER ACCOUNT${PURPLE}                       ║"
        echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""

        local OWNER_USER=""
        local OWNER_PASS=""
        local OWNER_PASS2=""

        if [ -n "$ASTROWAX_OWNER_USER" ] && [ -n "$ASTROWAX_OWNER_PASS" ]; then
            OWNER_USER="$ASTROWAX_OWNER_USER"
            OWNER_PASS="$ASTROWAX_OWNER_PASS"
        elif [ ! -t 0 ]; then
            OWNER_USER="owner"
            OWNER_PASS="owner12345"
        else
            while true; do
                read -p "    Username: " OWNER_USER
                if [ ${#OWNER_USER} -ge 3 ]; then break; fi
                echo "    Username must be at least 3 characters."
            done
            while true; do
                read -s -p "    Password: " OWNER_PASS
                echo ""
                read -s -p "    Confirm Password: " OWNER_PASS2
                echo ""
                if [ ${#OWNER_PASS} -lt 6 ]; then
                    echo "    Password must be at least 6 characters."
                elif [ "$OWNER_PASS" = "$OWNER_PASS2" ] && [ -n "$OWNER_PASS" ]; then
                    break
                else
                    echo "    Passwords do not match."
                fi
            done
        fi

        export ASTROWAX_OWNER_USER="$OWNER_USER"
        export ASTROWAX_OWNER_PASS="$OWNER_PASS"
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
    if [ "$MODE_CHOICE" = "2" ]; then
        RUNTIME_ARG="local"
    fi

    execute_step "Node.js Configuration" setup_node_env "$RUNTIME_ARG"
    execute_step "NPM Dependencies" install_dependencies

    if [ "$TARGET" = "main" ]; then
        execute_step "Owner Account Setup" setup_owner
        execute_step "Building Application" build_application
        execute_step "Starting PM2 Service" start_panel_node "$MAIN_PROCESS"
        execute_step "Health Check" health_check $MAIN_PORT pm2 "$MAIN_PROCESS"
    else
        execute_step "Building Application" build_application
        execute_step "Starting PM2 Service" start_panel_node "$DEV_PROCESS"
        execute_step "Health Check" health_check $DEV_PORT pm2 "$DEV_PROCESS"
    fi

    show_status

    local IP=$(curl -s -m 2 ifconfig.me 2>/dev/null || curl -s -m 2 icanhazip.com 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "localhost")

    echo -e "${GREEN}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}INSTALLATION COMPLETE${GREEN}                       ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    if [ "$TARGET" = "main" ]; then
        echo -e "    ${WHITE}Panel URL${NC}  : ${LIGHT_PURPLE}http://${IP}:${MAIN_PORT}${NC}"
        echo -e "    ${WHITE}Username${NC}   : ${LIGHT_PURPLE}${OWNER_USER}${NC}"
        echo -e "    ${WHITE}Version${NC}    : ${LIGHT_PURPLE}AstroWax Panel V1.80${NC}"
        echo ""
        echo -e "    ${GREY}Made by ${LIGHT_PURPLE}Itzytansh${NC}"
    else
        echo -e "    ${WHITE}Dev URL${NC}    : ${LIGHT_PURPLE}http://${IP}:${DEV_PORT}${NC}"
        echo -e "    ${WHITE}Version${NC}    : ${LIGHT_PURPLE}AstroWax Panel V1.80${NC}"
    fi
    echo ""
}

# ═══════════════════════════════════════════════════════════
# INSTALL — V1.0 (Panel + Node Daemon)
# ═══════════════════════════════════════════════════════════
install_panel_v10() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}INSTALLING ASTROWAX PANEL V1.0${PURPLE}              ║"
    echo -e "    ║              ${GREY}Legacy • Node 20 + SQLite${PURPLE}                     ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # ─── Ask what to install ───
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}V1.0 INSTALL OPTIONS${PURPLE}                       ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Install Panel only${NC}                                ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Install Node Daemon only${NC}                          ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${WHITE}Install BOTH (Panel + Node Daemon)${NC}                ║"
    echo -e "    ║        ${GREY}Recommended for full setup${NC}                          ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[4]${NC} ${WHITE}Back${NC}                                              ║"
    echo -e "    ║                                                           ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"

    local V1_CHOICE=""
    if [ -n "$V1_INSTALL_CHOICE" ]; then
        V1_CHOICE="$V1_INSTALL_CHOICE"
    elif [ ! -t 0 ]; then
        V1_CHOICE="3"
    else
        read -p "    Choose (1-4): " V1_CHOICE
    fi

    case "$V1_CHOICE" in
        1)
            install_v10_panel
            ;;
        2)
            install_v10_node_daemon
            ;;
        3)
            install_v10_panel
            echo ""
            install_v10_node_daemon
            ;;
        4)
            return
            ;;
        *)
            log_error "Invalid selection."
            return
            ;;
    esac
}

# ─── V1.0 PANEL ───
install_v10_panel() {
    echo ""
    log_step "Installing AstroWax Panel V1.0..."
    echo ""

    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config libsqlite3-dev sqlite3 && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/AstroWax-Panel && git clone https://github.com/AstroVoidHostDev/AstroWax-Panel ~/AstroWax-Panel && cd ~/AstroWax-Panel && unzip -oq panel.zip && cd panel && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps && npm install connect-sqlite3 sqlite3 && npm run seed && npm run createUser'

    echo ""
    log_success "AstroWax Panel V1.0 installed to ~/AstroWax-Panel"
    echo ""
    echo -e "    ${WHITE}Start it with:${NC}"
    echo -e "    ${LIGHT_PURPLE}cd ~/AstroWax-Panel/panel && node .${NC}"
    echo ""
}

# ─── V1.0 NODE DAEMON ───
install_v10_node_daemon() {
    echo ""
    log_step "Installing AstroWax Node Daemon (V1.0)..."
    echo ""

    bash -c 'set -e; export DEBIAN_FRONTEND=noninteractive; sudo apt-get update -y && sudo apt-get install -y curl git zip unzip build-essential python3 python3-pip python3-setuptools python-is-python3 make gcc g++ pkg-config && (command -v nvm >/dev/null 2>&1 || curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash) && export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"; [ -s /usr/local/share/nvm/nvm.sh ] && export NVM_DIR=/usr/local/share/nvm; . "$NVM_DIR/nvm.sh"; nvm install 20 && nvm use 20 && rm -rf ~/WaxDaemon && git clone https://github.com/AstroVoidHostDev/WaxDaemon ~/WaxDaemon && cd ~/WaxDaemon && unzip -oq waxdaemon.zip && cd daemon/daemon && [ -f index.js.txt ] && mv index.js.txt index.js || true && rm -rf node_modules package-lock.json && npm cache clean --force && npm install --legacy-peer-deps'

    echo ""
    log_success "AstroWax Node Daemon installed to ~/WaxDaemon/daemon/daemon"
    echo ""
    echo -e "${YELLOW}${BOLD}    ═══════════════════════════════════════════════════════${NC}"
    echo -e "${WHITE}${BOLD}    Paste your daemon config now.${NC}"
    echo -e "${WHITE}${BOLD}    After saving the config, run:${NC}"
    echo -e "${LIGHT_PURPLE}    cd ~/WaxDaemon/daemon/daemon && node .${NC}"
    echo -e "${YELLOW}${BOLD}    ═══════════════════════════════════════════════════════${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# UPDATE PANEL
# ═══════════════════════════════════════════════════════════
update_panel() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}UPDATING ASTROWAX PANEL${PURPLE}                    ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    local PANEL_PATH=""
    if [ -f "package.json" ] && [ -d "src" ]; then
        PANEL_PATH="."
    elif [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    else
        log_error "Panel not installed. Please run install first."
        return 1
    fi

    cd "$PANEL_PATH" || { log_error "Cannot enter panel dir."; return 1; }
    log_info "Updating from: $(pwd)"
    echo ""

    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/${GH_BRANCH}/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/${GH_BRANCH}.zip"
    local temp_dir="/tmp/awp_update_$$"
    local new_dir="${temp_dir}/new"
    local old_dir="${temp_dir}/old"

    mkdir -p "$new_dir" "$old_dir" || return 1

    local downloaded=0
    if curl -fsSL "$archive_url" -o "/tmp/awp_update.zip" 2>/dev/null; then
        downloaded=1
    else
        curl -fsSL "$main_archive_url" -o "/tmp/${GH_REPO}_update.zip" 2>/dev/null || {
            log_error "Failed to download update."
            rm -rf "$temp_dir"; return 1
        }
        unzip -q -o "/tmp/${GH_REPO}_update.zip" -d "/tmp/awp_update_extract" 2>/dev/null || {
            log_error "Failed to extract."
            rm -rf "$temp_dir" "/tmp/${GH_REPO}_update.zip" "/tmp/awp_update_extract"; return 1
        }
        local found=$(find /tmp/awp_update_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        if [ -z "$found" ]; then
            log_error "panel.zip not found in repo."
            rm -rf "$temp_dir" "/tmp/${GH_REPO}_update.zip" "/tmp/awp_update_extract"; return 1
        fi
        cp "$found" "/tmp/awp_update.zip" 2>/dev/null
        rm -rf "/tmp/${GH_REPO}_update.zip" "/tmp/awp_update_extract"
        downloaded=1
    fi

    if [ "$downloaded" -ne 1 ] || [ ! -f "/tmp/awp_update.zip" ]; then
        log_error "Download failed."
        rm -rf "$temp_dir"; return 1
    fi

    # Extract new
    unzip -q -o "/tmp/awp_update.zip" -d "$new_dir" 2>/dev/null || {
        log_error "Failed to extract new panel.zip"
        rm -rf "$temp_dir" "/tmp/awp_update.zip"; return 1
    }

    # Auto-detect new root
    local actual_new_root="$new_dir"
    if [ -d "$new_dir/$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
        actual_new_root="$new_dir/$WORK_DIR_NAME/$PANEL_DIR_NAME"
    elif [ -d "$new_dir/$PANEL_DIR_NAME" ]; then
        actual_new_root="$new_dir/$PANEL_DIR_NAME"
    else
        local found_pkg=$(find "$new_dir" -maxdepth 4 -name "package.json" -not -path "*/node_modules/*" 2>/dev/null | head -1)
        if [ -n "$found_pkg" ]; then
            actual_new_root=$(dirname "$found_pkg")
        fi
    fi

    # Copy current for comparison
    cp -r "$(pwd)" "$old_dir/" 2>/dev/null
    local actual_old_root="$old_dir/$(basename "$(pwd)")"

    log_step "Comparing files..."
    local changed_files=""
    local new_files=""
    local identical=1

    while IFS= read -r newfile; do
        local relpath="${newfile#$actual_new_root/}"
        local oldfile="$actual_old_root/$relpath"

        case "$relpath" in
            node_modules/*|dist/*|.git/*|.data/*|backups/*|*.log) continue ;;
        esac

        if [ ! -f "$oldfile" ]; then
            new_files="$new_files$relpath\n"
            identical=0
        elif ! cmp -s "$newfile" "$oldfile"; then
            changed_files="$changed_files$relpath\n"
            identical=0
        fi
    done < <(find "$actual_new_root" -type f 2>/dev/null)

    echo ""
    if [ "$identical" -eq 1 ]; then
        echo -e "${GREEN}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
        echo -e "    ║                                                           ║"
        echo -e "    ║          ${WHITE}✓ ALREADY ON LATEST VERSION${GREEN}                    ║"
        echo -e "    ║                                                           ║"
        echo -e "    ║          ${GREY}No changes detected — you're up to date!${GREEN}         ║"
        echo -e "    ║                                                           ║"
        echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        rm -rf "$temp_dir" "/tmp/awp_update.zip"
        return 0
    fi

    if [ -n "$changed_files" ]; then
        echo -e "${YELLOW}${BOLD}    Changed files:${NC}"
        echo -e "$changed_files" | while read -r f; do
            [ -n "$f" ] && echo -e "    ${LIGHT_PURPLE}~${NC} $f"
        done
        echo ""
    fi
    if [ -n "$new_files" ]; then
        echo -e "${GREEN}${BOLD}    New files:${NC}"
        echo -e "$new_files" | while read -r f; do
            [ -n "$f" ] && echo -e "    ${GREEN}+${NC} $f"
        done
        echo ""
    fi

    if [ -t 0 ]; then
        read -p "    ${WHITE}Apply update? (y/N):${NC} " CONFIRM
        if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
            echo -e "    ${YELLOW}Update cancelled.${NC}"
            rm -rf "$temp_dir" "/tmp/awp_update.zip"
            return 0
        fi
    fi

    echo ""
    stop_panel
    echo ""

    log_step "Preserving user data..."
    local PRESERVE_DIR="/tmp/awp_preserve_$$"
    mkdir -p "$PRESERVE_DIR"
    [ -f ".env" ] && cp ".env" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d ".data" ] && cp -r ".data" "$PRESERVE_DIR/" 2>/dev/null || true
    [ -d "backups" ] && cp -r "backups" "$PRESERVE_DIR/" 2>/dev/null || true

    local BACKUP_NAME="astrowax-backup-$(date +%Y%m%d_%H%M%S)"
    log_step "Creating backup: $BACKUP_NAME.tar.gz"
    tar -czf "$BACKUP_NAME.tar.gz" --exclude=node_modules --exclude=.git . 2>/dev/null || true

    log_step "Applying new files..."
    cd "$PANEL_PATH" || return 1
    rm -rf src server public 2>/dev/null || true
    rm -f package.json package-lock.json index.html vite.config.ts tsconfig.json server.ts ecosystem.config.cjs 2>/dev/null || true
    cp -r "$actual_new_root"/* . 2>/dev/null || true

    log_step "Restoring user data..."
    [ -f "$PRESERVE_DIR/.env" ] && cp "$PRESERVE_DIR/.env" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/.data" ] && cp -r "$PRESERVE_DIR/.data" . 2>/dev/null || true
    [ -d "$PRESERVE_DIR/backups" ] && cp -r "$PRESERVE_DIR/backups" . 2>/dev/null || true
    rm -rf "$PRESERVE_DIR"

    echo ""
    execute_step "Installing Dependencies" install_dependencies
    execute_step "Rebuilding Application" build_application
    execute_step "Restarting Panel" start_panel_node "$MAIN_PROCESS"
    execute_step "Health Check" health_check $MAIN_PORT pm2 "$MAIN_PROCESS"

    rm -rf "$temp_dir" "/tmp/awp_update.zip"

    echo ""
    echo -e "${GREEN}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║                                                           ║"
    echo -e "    ║          ${WHITE}✓ UPDATE COMPLETE${GREEN}                              ║"
    echo -e "    ║                                                           ║"
    echo -e "    ║          ${GREY}Backup: ${WHITE}$BACKUP_NAME.tar.gz${NC}${GREEN}                  ║"
    echo -e "    ║                                                           ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""

    show_status
}

# ═══════════════════════════════════════════════════════════
# CREATE OWNER
# ═══════════════════════════════════════════════════════════
create_owner_user() {
    print_banner
    echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}CREATE OWNER ACCOUNT${PURPLE}                       ║"
    echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"

    local OWNER_USER=""
    local OWNER_PASS=""
    local OWNER_PASS2=""

    while true; do
        read -p "    Username: " OWNER_USER
        if [ ${#OWNER_USER} -ge 3 ]; then break; fi
        echo "    Username must be at least 3 characters."
    done
    while true; do
        read -s -p "    Password: " OWNER_PASS
        echo ""
        read -s -p "    Confirm Password: " OWNER_PASS2
        echo ""
        if [ ${#OWNER_PASS} -lt 6 ]; then
            echo "    Password must be at least 6 characters."
        elif [ "$OWNER_PASS" = "$OWNER_PASS2" ] && [ -n "$OWNER_PASS" ]; then
            break
        else
            echo "    Passwords do not match."
        fi
    done

    export ASTROWAX_OWNER_USER="$OWNER_USER"
    export ASTROWAX_OWNER_PASS="$OWNER_PASS"
    execute_step "Setting up Owner Account" setup_owner
    log_success "Owner user created!"
}

uninstall_panel() {
    if [ ! -f "uninstall.sh" ]; then
        log_error "uninstall.sh not found."
        return
    fi
    bash uninstall.sh
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

if [ "$1" = "main" ]; then
    choose_version
    if [ "$SELECTED_VERSION" = "1.0" ]; then
        install_panel_v10
    else
        install_panel_v180 "main"
    fi
    exit 0
elif [ "$1" = "dev" ]; then
    choose_version
    if [ "$SELECTED_VERSION" = "1.0" ]; then
        install_panel_v10
    else
        install_panel_v180 "dev"
    fi
    exit 0
elif [ "$1" = "update" ]; then
    update_panel
    exit 0
fi

# ═══════════════════════════════════════════════════════════
# INTERACTIVE MENU
# ═══════════════════════════════════════════════════════════
while true; do
    print_banner
    echo -e "    ${PURPLE}${BOLD}╔═══════════════════════════════════════════════════════════╗"
    echo -e "    ║              ${WHITE}SELECT AN OPTION${PURPLE}                            ║"
    echo -e "    ╠═══════════════════════════════════════════════════════════╣${NC}"
    echo -e "    ║                                                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Install Panel${NC}                                     ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Update Panel${NC}                                      ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${WHITE}Create Owner Account${NC}                              ║"
    echo -e "    ║    ${LIGHT_PURPLE}[4]${NC} ${WHITE}Uninstall Panel${NC}                                   ║"
    echo -e "    ║    ${LIGHT_PURPLE}[5]${NC} ${WHITE}Exit${NC}                                              ║"
    echo -e "    ║                                                           ║"
    echo -e "    ${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${GREY}AstroWax Panel  •  Made by ${LIGHT_PURPLE}Itzytansh${NC}"
    echo ""

    if ! read -p "    Choose (1-5): " CHOICE; then
        echo ""
        break
    fi

    case "$CHOICE" in
        1)
            choose_version
            if [ "$SELECTED_VERSION" = "1.0" ]; then
                install_panel_v10
            else
                install_panel_v180 "main"
            fi
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        2)
            update_panel
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        3)
            create_owner_user
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        4)
            uninstall_panel
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        5)
            echo ""
            echo -e "    ${LIGHT_PURPLE}Goodbye! 👋${NC}"
            echo ""
            exit 0
            ;;
        *)
            log_error "Invalid option!"
            sleep 1.5
            ;;
    esac
done
