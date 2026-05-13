#!/bin/sh

# MARK: Addigy new file condition:
# If file does not exist
# "/var/db/.Installomator1stDone"

# MARK: Addigy Condition on condition file
# Install on success

conditionFile="/var/db/.Installomator1stDone"
if [ -e "$conditionFile" ]; then
    echo "$conditionFile exists. Exiting."
    exit 1
else
    echo "$conditionFile not found. Continue…"
    exit 0
fi
