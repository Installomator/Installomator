#!/bin/sh

# Mark: Addigy Condition
# Install on success

gitusername="swiftDialog"
gitreponame="swiftDialog"
appNewVersion=$(curl -sLI "https://github.com/$gitusername/$gitreponame/releases/latest" | grep -i "^location" | tr "/" "\n" | tail -1 | sed 's/[^0-9\.]//g')

destFile="/Library/Application Support/Dialog/Dialog.app"
versionKey="CFBundleShortVersionString" #CFBundleVersion

currentInstalledVersion="$(defaults read "${destFile}/Contents/Info.plist" $versionKey || true)"
if [[ ! -e "${destFile}" || "$currentInstalledVersion" != "$appNewVersion" ]]; then
	#echo "Let's install…"
    exit 0
else
	#echo "No need!"
    exit 1
fi
