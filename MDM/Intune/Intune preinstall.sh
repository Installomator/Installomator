#!/bin/zsh
#set -x

# ==================================================
# Intune preinstall.sh
# Installs Swift Dialog (if absent), shows a progress dialog,
# then downloads and runs Installomator with the specified label.
# Intended to run as an Intune PKG preinstall script. The
# companion postinstall.sh closes the dialog window after
# Intune's dummy-package phase completes.
# ==================================================

# --- Configuration -----------------------------------------------------------

# Set these to match your desired installation
installomatorDisplay="Mozilla Firefox"
installomatorLabel="firefoxpkg"

appMessage="Installing ${installomatorDisplay}…"
# Set these to match your desired installation

# Dialog Icon and Overlay Icon
appIcon="/Applications/Company Portal.app/Contents/Resources/AppIcon.icns"
overlayIcon="/System/Library/CoreServices/Installer.app/Contents/Resources/package.icns"

# Installomator script to download
installomatorURL="https://raw.githubusercontent.com/Installomator/Installomator/main/Installomator.sh"
installomatorPath="/usr/local/Installomator/Installomator.sh"

dialogPath="/usr/local/bin/dialog"
dialogApp="/Library/Application Support/Dialog/Dialog.app"
dialogCommandFile="/var/tmp/dialog.log"

# Note: Using quotes inside the string would break the variable assignment.
installomatorOptions="DEBUG=0 BLOCKING_PROCESS_ACTION=prompt_user_then_kill REOPEN=yes NOTIFY_DIALOG=1 DIALOG_CMD_FILE=${dialogCommandFile}"

logDir="/Library/Logs/Microsoft/IntuneScripts/${installomatorLabel}"
log="${logDir}/${installomatorLabel}.log"

# Check if the log directory has been created
if [ -d "$logDir" ]; then
    # Already created
    echo "$(date) | Log directory already exists - $logDir"
else
    # Creating Log Directory
    echo "$(date) | creating log directory - $logDir"
    mkdir -p "$logDir"
fi

# Start logging
exec &> >(tee -a "$log")


# --- Reusable Functions ------------------------------------------------------

dialogUpdate() {
    # $1: dialog command string (e.g. "progress: 50", "quit:")
    local dcommand="$1"

    if [[ -n $dialogCommandFile ]]; then
        echo "$dcommand" >> "$dialogCommandFile"
        echo "Dialog: $dcommand"
    fi
}

closeDialog() {
    # Gracefully close Swift Dialog and clean up the command file.
    # $1: optional progress text shown before closing (default: "Done")
    # Called by the error path in this script when Installomator fails —
    # in that case the preinstall exits non-zero and Intune never runs
    # postinstall.sh, so we must close the dialog here instead.
    local progressText="${1:-Done}"
    echo "$(date +%F\ %T) : Ending SwiftDialog"
    dialogUpdate "progress: complete"
    dialogUpdate "progresstext: $progressText"
    sleep 1.0
    dialogUpdate "quit:"
    sleep 0.5
    killall "Dialog" 2>/dev/null || true
    rm -f "$dialogCommandFile"
    echo "$(date +%F\ %T) : SwiftDialog closed."
}


# --- Download Swift Dialog ---------------------------------------------------

name="Dialog"
gitusername="swiftDialog"
gitreponame="swiftDialog"
filetype="pkg"
expectedTeamID="PWA5E9TQ59"

# Only install if Dialog.app is absent. No version check needed — presence is
# sufficient since Installomator will surface its own UI if Dialog is outdated.
if [[ ! -d "${dialogApp}" ]]; then
    echo "$name not found. Fetching latest release info..."

    downloadURL=$(curl -sfL "https://api.github.com/repos/$gitusername/$gitreponame/releases/latest" | awk -F '"' "/browser_download_url/ && /$filetype\"/ { print \$4; exit }")
    if [[ "$(echo $downloadURL | grep -ioE "https.*.$filetype")" == "" ]]; then
        echo "WARN  : GitHub API failed, trying failover."
        downloadURL="https://github.com$(curl -sfL "$(curl -sfL "https://github.com/$gitusername/$gitreponame/releases/latest" | tr '"' "\n" | grep -i "expanded_assets" | head -1)" | tr '"' "\n" | grep -i "^/.*\/releases\/download\/.*\.$filetype" | head -1)"
    fi

    appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')
    echo "Installing $name version ${appNewVersion}…"

    tmpDir="$(mktemp -d || true)"
    echo "Created working directory '$tmpDir'"

    installationCount=0
    exitCode=9
    while [[ $installationCount -lt 3 && $exitCode -gt 0 ]]; do
        # Capture output for logging; check exit code directly (no || true masking)
        curlDownload=$(curl -Ls "$downloadURL" -o "$tmpDir/$name.pkg" 2>&1)
        curlDownloadStatus=$?
        if [[ $curlDownloadStatus -ne 0 ]]; then
            echo "ERROR : Download failed (status $curlDownloadStatus): $downloadURL"
            echo "${curlDownload}"
            exitCode=1
        else
            echo "Download $name success."

            # Verify the developer Team ID before installing
            teamID=$(spctl -a -vv -t install "$tmpDir/$name.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()' || true)
            echo "Team ID for downloaded package: $teamID"

            if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
                echo "$name package verified. Installing '$tmpDir/$name.pkg'."
                pkgInstall=$(installer -verbose -dumplog -pkg "$tmpDir/$name.pkg" -target "/" 2>&1)
                pkgInstallStatus=$?
                if [[ $pkgInstallStatus -ne 0 ]]; then
                    echo "ERROR : $name package installation failed."
                    echo "${pkgInstall}"
                    exitCode=2
                else
                    echo "$name package installed successfully."
                    exitCode=0
                fi
            else
                echo "ERROR : Team ID mismatch for $name — expected '$expectedTeamID', got '$teamID'. Aborting install."
                exitCode=3
            fi
        fi

        ((installationCount++))
        echo "Attempt $installationCount complete, exitCode $exitCode"

        if [[ $installationCount -lt 3 && $exitCode -gt 0 ]]; then
            echo "Sleeping before retry (attempt $installationCount)."
            rm -fv "$tmpDir/$name.pkg" || true
            sleep 2
        fi
    done

    echo "Removing working directory '$tmpDir'."
    rm -Rfv "${tmpDir}" || true

    if [[ $exitCode != 0 ]]; then
        echo "ERROR : Installation of $name failed after $installationCount attempt(s). Aborting."
        exit $exitCode
    else
        echo "$name version $appNewVersion installed successfully."
    fi
else
    echo "$name already installed at '${dialogApp}'. Skipping download."
fi


# --- Display Dialog ----------------------------------------------------------

# Build the dialog command as an array so arguments with spaces are handled safely.
dialogCMD=("$dialogPath"
           --title none
           --icon "$appIcon"
           --overlayicon "$overlayIcon"
           --message "$appMessage"
           --mini
           --progress 100
           --position bottomright
           --moveable
           --commandfile "$dialogCommandFile"
           --ontop
)

# Double-fork: the intermediate subshell exits immediately after spawning Dialog,
# causing the OS to reparent Dialog to launchd (PID 1). This keeps Dialog outside
# Intune's process group so it does not block the preinstall script from exiting.
( "${dialogCMD[@]}" >/dev/null 2>&1 & )
sleep 0.1


# --- Download Installomator --------------------------------------------------

echo "Downloading Installomator from main branch..."

/bin/mkdir -p "$(/usr/bin/dirname "$installomatorPath")"

/usr/bin/curl --fail --silent --show-error --location \
    --output "$installomatorPath" \
    "$installomatorURL"

if [[ $? -ne 0 ]]; then
    echo "ERROR: Failed to download Installomator." >&2
    exit 1
fi

echo "Download complete: $installomatorPath"
/bin/chmod +x "$installomatorPath"


# --- Run Installomator -------------------------------------------------------

echo "Running Installomator with label: $installomatorLabel"
echo "Options: $installomatorOptions"

# installomatorOptions is intentionally unquoted here so the shell splits it
# into individual key=value arguments as Installomator expects.
"$installomatorPath" "$installomatorLabel" $installomatorOptions

installResult=$?

if [[ $installResult -ne 0 ]]; then
    echo "ERROR: Installomator exited with code $installResult." >&2
    # postinstall.sh will not run when preinstall exits non-zero,
    # so close the dialog here before handing the error back to Intune.
    closeDialog "Installation failed"
    exit $installResult
fi

echo "Installomator completed successfully."
exit 0
