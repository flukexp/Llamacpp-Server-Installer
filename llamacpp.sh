#!/bin/bash

# Function to check for errors
check_error() {
    if [ $? -ne 0 ]; then
        echo "Error occurred: $1"
        exit 1
    fi
}

# Function to check if llama-server is already built
is_llama_installed() {
    if [ -x "./llama.cpp/llama-server" ]; then
        return 0
    else
        return 1
    fi
}

# Function to check if model is already downloaded
is_model_dowloaded(){
    if [ -x "./llama.cpp/models/openchat_3.5.Q5_K_M.gguf" ]; then
        return 0
    else
        return 1
    fi
}

# Clone and build llamacpp only if not installed
if is_llama_installed; then
    echo "llamacpp is already installed."
    cd llama.cpp
else
    # Clone the llamacpp repository
    echo "Cloning llamacpp repository..."
    git clone https://github.com/ggerganov/llama.cpp.git
    check_error "Failed to clone llamacpp repository."

    # Build llamacpp
    echo "Building llamacpp..."
    cd llama.cpp
    make llama-server
    check_error "Failed to build llamacpp."
fi

# Download openchat model only if not downloaded yet
if is_model_dowloaded; then 
    echo "openchat_3.5-GGUF models already downloaded"
else
    # Install open-ai
    echo "Installing openchat_3.5-GGUF..."
    curl -L -o models/openchat_3.5.Q5_K_M.gguf https://huggingface.co/TheBloke/openchat_3.5-GGUF/resolve/main/openchat_3.5.Q5_K_M.gguf
    check_error "Failed to install openchat_3.5-GGUF"
fi

# Start llama.cpp server
echo "Starting llama.cpp server..."
./llama-server -m models/openchat_3.5.Q5_K_M.gguf --port 8080
check_error "Failed to start llama.cpp server"

echo "llamacpp server is starting..."
