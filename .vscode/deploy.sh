#!/bin/bash
# ./.vscode/deploy.sh (Single Login Version)

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration Variables (7 total arguments) ---
DECK_IP="$1"
DECK_PORT="$2"
DECK_USER="$3"
DECK_PASS="$4"
DECK_DIR="$5"
PLUGIN_NAME="$6"
PLUGIN_ZIP_PATH="$7" # Local path: e.g., "out/Example Plugin.zip"

# --- Remote Path Setup ---
REMOTE_PLUGINS_DIR="${DECK_DIR}/homebrew/plugins"
# The folder name needs spaces replaced with hyphens
REMOTE_PLUGIN_FOLDER_NAME="$(echo "${PLUGIN_NAME}" | sed 's/ /-/g')"
REMOTE_PLUGIN_PATH="${REMOTE_PLUGINS_DIR}/${REMOTE_PLUGIN_FOLDER_NAME}"
REMOTE_ZIP_FILE="${REMOTE_PLUGINS_DIR}/${PLUGIN_NAME}.zip"

echo "Deploying to ${DECK_IP} (One SSH login required)..."

# --- VALIDATION ---
if [ ! -e "${PLUGIN_ZIP_PATH}" ]; then
    echo "ERROR: Source ZIP file not found locally! Expected path: [${PLUGIN_ZIP_PATH}]"
    echo "Please ensure your build task ran successfully."
    exit 1
fi
# ------------------

# 1. Execute all steps in ONE single SSH connection:
#    a) Pipe the ZIP file content over the SSH connection (cat ...)
#    b) On the remote side, use 'tee' to save the stream to the final zip location.
#    c) Immediately after the transfer (in the same SSH session), execute the sudo commands.
echo "--- Transferring file and executing extraction (Enter SSH password once)..."

ssh -p "${DECK_PORT}" "${DECK_USER}@${DECK_IP}" "
    # 1. Pass the password to sudo and cache it for the entire session.
    # 2. Use 'tee' to write the incoming stream (the zip file) to its final location.
    # 3. Chain the subsequent extraction/permissions commands with the cached sudo password.
    
    echo \"${DECK_PASS}\" | sudo -S sh -c '
        # The transfer destination needs write permissions first
        echo \"Applying write permissions to ${REMOTE_PLUGINS_DIR}/...\"
        chmod ug+w \"${REMOTE_PLUGINS_DIR}\"
        
        # 'cat' on the local machine pipes the ZIP contents to this remote shell.
        # This remote shell uses 'tee' to write the contents to the zip file.
        # This MUST be the first command after sudo -S setup.
        tee \"${REMOTE_ZIP_FILE}\" > /dev/null
        
        # Now run the rest of the steps using the cached sudo privilege:
        echo \"Creating and extracting ${REMOTE_PLUGIN_PATH}...\"
        
        # Create target dir, change ownership, and extract
        mkdir -m 755 -p \"${REMOTE_PLUGIN_PATH}\" &&
        chown ${DECK_USER}:${DECK_USER} \"${REMOTE_PLUGIN_PATH}\" &&
        bsdtar -xzpf \"${REMOTE_ZIP_FILE}\" -C \"${REMOTE_PLUGIN_PATH}\" --strip-components=1 --fflags &&
        
        # OPTIONAL: Remove the temporary ZIP file
        rm \"${REMOTE_ZIP_FILE}\"
    '
" < "${PLUGIN_ZIP_PATH}" # <--- This redirects the local file into the SSH process's standard input.

echo "--- Deployment Complete! ---"
