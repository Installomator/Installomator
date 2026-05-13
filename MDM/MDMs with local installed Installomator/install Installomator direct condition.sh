#!/bin/sh

# Mark: Addigy Condition
# Install on success

gitusername="Installomator"
gitreponame="Installomator"
appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')

destFile="/usr/local/Installomator/Installomator.sh"
if [[ ! -e "${destFile}" || "$(${destFile} version)" != "$appNewVersion" ]]; then
	#echo "Let's install…"
    exit 0
else
	#echo "No need!"
    exit 1
fi
