#!/bin/bash
# =========================================================
# AstroWax Panel V1.80 - Automated Installer
# Made by Itzytansh
# =========================================================

# Ensure bash
if [ -z "$BASH_VERSION" ]; then
    if command -v bash > /dev/null 2>&1; then
        exec bash "$0" "$@"
    fi
fi

# ═══════════════════════════════════════════════════════════
# COLORS — Purple / White Theme
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
# CONFIG — Hidden GitHub + Paths
# ═══════════════════════════════════════════════════════════
GH_USER="${ASTROWAX_GH_USER:-AstroVoidHostDev}"
GH_REPO="${ASTROWAX_GH_REPO:-astrowax}"
GH_ARCHIVE="${ASTROWAX_GH_ARCHIVE:-panel.zip}"
WORK_DIR_NAME="panel"
PANEL_DIR_NAME="astrowax-panel"
MAIN_PROCESS="astrowax-main"
DEV_PROCESS="astrowax-admin"
MAIN_CONTAINER="astrowax-main"
DEV_CONTAINER="astrowax-admin"
MAIN_PORT="6767"
DEV_PORT="3000"
SFTP_PORT="6868"

# ═══════════════════════════════════════════════════════════
# ASCII BANNER — Big AWP
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
    echo -e "${WHITE}${BOLD}    ║              ${LIGHT_PURPLE}ASTROWAX PANEL${WHITE} V1.80                   ║"
    echo -e "${WHITE}${BOLD}    ║              ${GREY}Made by ${LIGHT_PURPLE}Itzytansh${WHITE}                          ║"
    echo -e "${PURPLE}${BOLD}    ║                                                           ║"
    echo -e "${PURPLE}${BOLD}    ╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# ═══════════════════════════════════════════════════════════
# LOG HELPERS
# ═══════════════════════════════════════════════════════════
log_info()    { echo -e "${LIGHT_PURPLE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[✓]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
log_error()   { echo -e "${RED}[✗]${NC} $1"; }
log_step()    { echo -e "${PURPLE}${BOLD}[→]${NC} $1"; }

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
    elif command -v sudo &> /dev/null && sudo docker-compose version > /dev/null 2>&1; then
        echo "sudo docker-compose"
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
        echo -e "${RED}${BOLD}  INSTALLATION STEP FAILED${NC}"
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
        echo -e "${YELLOW}  Installation stopped safely.${NC}\n"
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

    # Swap if low memory
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
# DOWNLOAD FROM GITHUB (archive method — hides exact path)
# ═══════════════════════════════════════════════════════════
download_panel() {
    local archive_url="https://github.com/${GH_USER}/${GH_REPO}/raw/main/${GH_ARCHIVE}"
    local main_archive_url="https://github.com/${GH_USER}/${GH_REPO}/archive/refs/heads/main.zip"

    # Try direct raw file first
    if curl -fsSL "$archive_url" -o "$GH_ARCHIVE" 2>/dev/null; then
        : # success
    else
        # Fallback: download whole repo zip and extract panel.zip
        curl -fsSL "$main_archive_url" -o "/tmp/${GH_REPO}.zip" 2>/dev/null || return 1
        unzip -q -o "/tmp/${GH_REPO}.zip" -d /tmp/awp_extract 2>/dev/null || return 1
        local found=$(find /tmp/awp_extract -name "$GH_ARCHIVE" -type f 2>/dev/null | head -1)
        if [ -z "$found" ]; then
            return 1
        fi
        cp "$found" "$GH_ARCHIVE" 2>/dev/null || return 1
        rm -rf /tmp/awp_extract "/tmp/${GH_REPO}.zip" 2>/dev/null || true
    fi

    if [ ! -f "$GH_ARCHIVE" ]; then
        return 1
    fi

    unzip -q -o "$GH_ARCHIVE" -d "$WORK_DIR_NAME" 2>/dev/null || return 1
    rm -f "$GH_ARCHIVE" 2>/dev/null || true
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
        echo "Docker install failed."
        return 1
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
                echo "Docker daemon not accessible."
                return 1
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
        echo "Docker Compose not available."
        return 1
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
        echo "Node.js install failed."
        return 1
    fi

    local VER=$(node -v 2>/dev/null | tr -d 'v' | cut -d'.' -f1)
    if [ "$VER" -lt 20 ]; then
        echo "Node.js >= 20 required. Current: $(node -v)"
        return 1
    fi

    if ! command -v npm &> /dev/null; then
        echo "npm missing."
        return 1
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
# NPM INSTALL / BUILD / OWNER
# ═══════════════════════════════════════════════════════════
install_dependencies() {
    if [ ! -f "package.json" ]; then
        echo "package.json not found in $(pwd)."
        return 1
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
# START PANEL
# ═══════════════════════════════════════════════════════════
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
    local DOCKER_CLI=$(get_docker_cmd)

    while [ $ATTEMPTS -lt $MAX_ATTEMPTS ]; do
        if curl -s -f "http://127.0.0.1:${PORT}/api/health" >/dev/null 2>&1 || curl -s -f "http://127.0.0.1:${PORT}/" >/dev/null 2>&1; then
            return 0
        fi

        if [ "$RUNTIME_TYPE" = "docker" ]; then
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
    echo -e "    ║              ${WHITE}ASTROWAX PANEL${PURPLE} STATUS                     ║"
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
# MAIN INSTALLER
# ═══════════════════════════════════════════════════════════
install_panel() {
    local TARGET=$1

    print_banner

    # Determine if panel already exists
    local PANEL_PATH=""
    if [ -f "package.json" ] && [ -d "src" ]; then
        PANEL_PATH="."
    elif [ -d "$WORK_DIR_NAME/$PANEL_DIR_NAME" ] && [ -f "$WORK_DIR_NAME/$PANEL_DIR_NAME/package.json" ]; then
        PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
    fi

    # If not present, download from GitHub
    if [ -z "$PANEL_PATH" ]; then
        echo -e "${PURPLE}${BOLD}    ╔═══════════════════════════════════════════════════════════╗"
        echo -e "    ║              ${WHITE}DOWNLOADING PANEL SOURCE${PURPLE}                   ║"
        echo -e "    ╚═══════════════════════════════════════════════════════════╝${NC}"
        echo ""
        execute_step "Downloading AstroWax Panel" download_panel
        if [ -d "$WORK_DIR_NAME/$PANEL_DIR_NAME" ]; then
            PANEL_PATH="$WORK_DIR_NAME/$PANEL_DIR_NAME"
        else
            log_error "Panel not found after download."
            exit 1
        fi
    fi

    cd "$PANEL_PATH" || { log_error "Cannot enter panel dir."; exit 1; }

    log_info "Working directory: $(pwd)"
    echo ""

    # Mode selection
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
        log_error "Invalid selection."
        exit 1
    fi

    # Owner account prompt (main only)
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
    echo -e "    ║              ${WHITE}INSTALLATION PROGRESS${PURPLE}                       ║"
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
# SHORTCUTS
# ═══════════════════════════════════════════════════════════
update_panel() {
    if [ ! -f "update.sh" ]; then
        log_error "update.sh not found."
        return
    fi
    bash update.sh
}

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
if [ "$1" = "main" ]; then
    install_panel "main"
    exit 0
elif [ "$1" = "dev" ]; then
    install_panel "dev"
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
    echo -e "    ║    ${LIGHT_PURPLE}[1]${NC} ${WHITE}Install Main Panel${NC}                                ║"
    echo -e "    ║    ${LIGHT_PURPLE}[2]${NC} ${WHITE}Install Developer Panel${NC}                           ║"
    echo -e "    ║    ${LIGHT_PURPLE}[3]${NC} ${WHITE}Update Panel${NC}                                      ║"
    echo -e "    ║    ${LIGHT_PURPLE}[4]${NC} ${WHITE}Create Owner Account${NC}                              ║"
    echo -e "    ║    ${LIGHT_PURPLE}[5]${NC} ${WHITE}Uninstall Panel${NC}                                   ║"
    echo -e "    ║    ${LIGHT_PURPLE}[6]${NC} ${WHITE}Exit${NC}                                              ║"
    echo -e "    ║                                                           ║"
    echo -e "    ${PURPLE}${BOLD}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "    ${GREY}AstroWax Panel V1.80  •  Made by ${LIGHT_PURPLE}Itzytansh${NC}"
    echo ""

    if ! read -p "    Choose (1-6): " CHOICE; then
        echo ""
        break
    fi

    case "$CHOICE" in
        1)
            install_panel "main"
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        2)
            install_panel "dev"
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        3)
            update_panel
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        4)
            create_owner_user
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        5)
            uninstall_panel
            if [ -t 0 ]; then read -p "    Press Enter to return to menu..." || true; fi
            ;;
        6)
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
