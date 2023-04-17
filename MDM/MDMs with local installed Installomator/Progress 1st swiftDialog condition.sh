#!/bin/sh

# Mark: Addigy Condition on condition file
# Install on success

conditionFile="/var/db/.Progress1stDone"
if [ -e "$conditionFile" ]; then
    echo "$conditionFile exists. Exiting."
    exit 1
else
    echo "$conditionFile not found. Continue…"
    exit 0
fi
