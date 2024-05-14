    iterm2)
    name="iTerm"
    type="zip"
    if [[ `defaults read /Applications/iTerm.app/Contents/Info.plist CFBundleShortVersionString` == *beta* ]] ; then
    downloadURL=$(curl -fsL 'https://iterm2.com/downloads.html' | grep -oE 'https:[^"]*beta[^"]*zip'| head -1)
    appNewVersion=$(sed -E 's/.*iTerm2-(.*)\.zip/\1/g; s/_/\./g' <<<"$downloadURL")
    else
    downloadURL="https://iterm2.com/downloads/stable/latest"
    appNewVersion=$(curl -is https://iterm2.com/downloads/stable/latest | grep location: | grep -o "iTerm2.*zip" | cut -d "-" -f 2 | cut -d '.' -f1 | sed 's/_/./g')
    fi
    expectedTeamID="H7V7XYVQ7D"
    blockingProcesses=( iTerm2 )
    ;;
    
