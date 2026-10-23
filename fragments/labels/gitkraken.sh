gitkraken)
    name="GitKraken"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://release.gitkraken.com/darwin-arm64/installGitKraken.dmg"
    else
        downloadURL="https://release.gitkraken.com/darwin/installGitKraken.dmg"
    fi
    appNewVersion=$(curl -sI "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1 | sed -E 's#.*/darwin/(arm64|x64)/([0-9.]+)/.*#\2#')
    expectedTeamID="T7QVVUTZQ8"
    ;;
