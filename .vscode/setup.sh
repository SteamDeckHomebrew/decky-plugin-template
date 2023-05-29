#!/usr/bin/env bash
PNPM_INSTALLED="$(which pnpm)"
DOCKER_INSTALLED="$(which docker)"
CLI_INSTALLED="$(test -f $(pwd)/cli/decky | echo "$?")"

# echo "$PNPM_INSTALLED"
# echo "$DOCKER_INSTALLED"
# echo "$CLI_INSTALLED"

echo "If you are using alpine linux, do not expect any support."
if [[ "$PNPM_INSTALLED" =~ "which" ]]; then
    echo "pnpm is not currently installed, you can install it via your distro's package managment system or via a script that will attempt to do a manual install based on your system. If you wish to proceed with installing via the script then answer "no" (capitals do not matter) and proceed with the rest of the script. Otherwise, just hit enter to proceed and use the script."
    read run_pnpm_script
    if [[ "$run_pnpm_script" =~ "n" ]]; then
        echo "You have chose to install pnpm via npm or your distros package manager. Please make sure to do so before attempting to build your plugin."
    else
        CURL_INSTALLED="$(which curl)"
        WGET_INSTALLED="$(which wget)"
        if [[ "$CURL_INSTALLED" =~ "which" ]]; then
            printf "curl not found, attempting with wget.\n"
            if [[ "$WGET_INSTALLED" =~ "which" ]]; then
                printf "wget not found, please install wget or curl.\n"
                printf "Could not install pnpm as curl and wget were not found.\n"
            else
                wget -qO- https://get.pnpm.io/install.sh | sh -
            fi
        else
            curl -fsSL https://get.pnpm.io/install.sh | sh -
        fi
    fi
fi

if [[ "$DOCKER_INSTALLED" =~ "which" ]]; then
    echo "Docker is not currently installed, in order build plugins with a backend you will need to have Docker installed. Please install Docker via the preferred method for your distribution."
fi

if [[ "$CLI_INSTALLED" > "0" ]] || [[ "$CLI_INSTALLED" < "0" ]]; then
    echo "The Decky CLI tool (binary file is just called "decky") is used to build your plugin as a zip file which you can then install on your Steam Deck to perform testing. We highly recommend you install it. Hitting enter now will run the script to install Decky CLI and extract it to a folder called cli in the current plugin directory. You can also type 'no' and hit enter to skip this but keep in mind you will not have a usable plugin without building it."
    read run_cli_script
    if [[ "$run_cli_script" =~ "n" ]]; then
        echo "You have chosen to not install the Decky CLI tool to build your plugins. Please install this tool to build and test your plugin before submitting it to the Plugin Database."
    else
        mkdir $(pwd)/cli
        curl -L -o $(pwd)/cli/decky "https://github.com/SteamDeckHomebrew/cli/releases/download/0.0.1-alpha.11/decky"
        chmod +x $(pwd)/cli/decky
        echo "Decky CLI tool is now installed and you can build plugins into easy zip files using the "Build Zip" Task in vscodium."
    fi
fi