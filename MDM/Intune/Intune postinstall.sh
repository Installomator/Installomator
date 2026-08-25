#!/bin/zsh
#set -x

# ==================================================
# Intune postinstall.sh
# Closes the Swift Dialog window after the Intune dummy-package
# phase completes. Runs as the Intune PKG postinstall script.
# ==================================================

# --- Configuration -----------------------------------------------------------

dialogCommandFile="/var/tmp/dialog.log"

dialogPath="/usr/local/bin/dialog"


# --- Reusable Functions ------------------------------------------------------

dialogUpdate() {
    # $1: dialog command
    local dcommand="$1"

    if [[ -n $dialogCommandFile ]]; then
        echo "$dcommand" >> "$dialogCommandFile"
        echo "Dialog: $dcommand"
    fi
}


# --- Close Swift Dialog ------------------------------------------------------

echo "$(date +%F\ %T) : Ending SwiftDialog"

dialogUpdate "progress: complete"
dialogUpdate "progresstext: Done"

sleep 0.5

dialogUpdate "quit:"

# let everything catch up
sleep 0.5

# just to be safe
killall "Dialog" 2>/dev/null || true

rm -f "$dialogCommandFile"

echo "$(date +%F\ %T) : SwiftDialog closed."
exit 0
