#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "${BLUE}==================== $1 ====================${NC}"
}

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error occurred: $1${NC}"
        exit 1
    fi
}

# Detect the operating system (macOS or Linux)
detect_os() {
    print_header "Detecting Operating System"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        echo -e "${GREEN}Detected Linux OS${NC}"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        echo -e "${GREEN}Detected macOS${NC}"
    else
        echo -e "${RED}Unsupported OS: $OSTYPE${NC}"
        exit 1
    fi
}

# Install missing package based on OS
install_package() {
    echo -e "${YELLOW}Installing $1...${NC}"
    if [ "$OS" == "linux" ]; then
        sudo apt update
        sudo apt install -y $1
        check_error "Failed to install $1"
    elif [ "$OS" == "macos" ]; then
        if ! command -v brew &> /dev/null; then
            echo -e "${YELLOW}Homebrew not found. Installing Homebrew...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            check_error "Failed to install Homebrew"
        fi
        brew install $1
        check_error "Failed to install $1"
    fi
    echo -e "${GREEN}$1 installed successfully${NC}"
}

# Function to check if a command exists
check_command() {
    echo -e "${YELLOW}Checking for $1...${NC}"
    command -v $1 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e "${RED}$1 is not installed.${NC} Installing it..."
        install_package $2
    else
        echo -e "${GREEN}$1 is already installed.${NC}"
    fi
}

# Detect the OS
detect_os

# Ensure required commands are installed
check_command git git
check_command curl curl
check_command make make

# For Linux, ensure build-essential is installed
if [ "$OS" == "linux" ]; then
    check_command g++ build-essential
    check_command gcc build-essential
elif [ "$OS" == "macos" ]; then
    if ! command -v gcc &> /dev/null || ! command -v g++ &> /dev/null; then
        echo -e "${YELLOW}gcc and g++ not found. Installing Xcode Command Line Tools...${NC}"
        xcode-select --install
        check_error "Failed to install Xcode Command Line Tools"
    else
        echo -e "${GREEN}gcc and g++ are already installed.${NC}"
    fi
fi

# Function to check if the repository is already cloned
is_repo_cloned() {
    if [ -d "llama.cpp" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check if llama-server is already built
is_llama_installed() {
    if [ -x "./llama-server" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check if model is already downloaded
is_model_downloaded(){
    if [ -f "./models/openchat_3.5.Q4_K_M.gguf" ]; then
        return 0
    else
        return 1
    fi
}

# Clone llamacpp repository only if not already cloned
if is_repo_cloned; then
    echo -e "${GREEN}llamacpp repository is already cloned.${NC}"
    cd llama.cpp
else
    print_header "Cloning llamacpp Repository"
    git clone https://github.com/ggerganov/llama.cpp.git
    check_error "Failed to clone llamacpp repository."
    cd llama.cpp
fi

# Build llamacpp only if not installed
if is_llama_installed; then
    echo -e "${GREEN}llamacpp is already installed.${NC}"
else
    print_header "Building llamacpp"
    make llama-server
    check_error "Failed to build llamacpp."
fi

# Download openchat model only if not downloaded yet
if is_model_downloaded; then 
    echo -e "${GREEN}openchat_3.5.Q4_K_M.gguf model is already downloaded.${NC}"
else
    print_header "Downloading openchat_3.5.Q4_K_M.gguf Model"
    curl -L -o models/openchat_3.5.Q4_K_M.gguf https://huggingface.co/TheBloke/openchat_3.5-GGUF/resolve/main/openchat_3.5.Q4_K_M.gguf
    check_error "Failed to download openchat_3.5.Q4_K_M.gguf model."
fi

# Start llama.cpp server
print_header "Starting llama.cpp Server"
./llama-server -m models/openchat_3.5.Q4_K_M.gguf --port 8080
check_error "Failed to start llama.cpp server"

echo -e "${GREEN}llamacpp server is running on port 8080.${NC}"
