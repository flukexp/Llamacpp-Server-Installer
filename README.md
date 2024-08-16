
---
# LlamaCpp Server Installation Script

This shell script automates the installation, setup, and running of the LlamaCpp server along with the OpenChat 3.5-GGUF model. The script checks if LlamaCpp is already installed and if the required model is downloaded, then proceeds accordingly.

## Requirements

- A Unix-based operating system (Linux, macOS, or WSL on Windows)
- Git
- Curl
- Make

## Script Overview

### Functions

- **`check_error()`**: Checks for errors after each command and exits if an error occurs.
- **`is_llama_installed()`**: Checks if the `llama-server` binary is already built.
- **`is_model_dowloaded()`**: Checks if the OpenChat 3.5-GGUF model is already downloaded.

### Main Operations

1. **Clone and Build LlamaCpp**: 
   - Clones the LlamaCpp repository from GitHub if it is not already installed.
   - Builds the `llama-server` binary using `make`.

2. **Download the OpenChat Model**: 
   - Downloads the OpenChat 3.5-GGUF model from Hugging Face if it is not already present in the models directory.

3. **Start the LlamaCpp Server**: 
   - Runs the LlamaCpp server with the specified model on port `8080`.

## Usage

1. **Clone the Repository**: 
   Ensure you have the script saved in the desired directory.

2. **Allowed permission**
   ```bash
   chmod +x ./llamacpp.sh
   ```
4. **Run the Script**:
   ```bash
   ./llamacpp.sh
   ```

5. **Script Execution**:
   - The script will first check if `llama-server` is already installed.
   - If not, it will clone the `llama.cpp` repository and build the server.
   - Then, it checks if the OpenChat 3.5-GGUF model is already downloaded. If not, it will download the model.
   - Finally, it starts the `llama-server` using the downloaded model.

6. **Access the Server**:
   The server will be accessible at `http://localhost:8080/`.

## Notes

- Ensure that all dependencies (Git, Curl, Make) are installed before running the script.
- The script assumes the presence of a Unix-like environment. Adjustments might be needed for other environments.

---
