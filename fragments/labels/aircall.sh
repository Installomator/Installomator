aircall)
    name="Aircall Workspace"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "https://electron.aircall.io/download/osx?appType=aircall-workspace&arch=arm64&platform=macPkg")
    else
        downloadURL=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "https://electron.aircall.io/download/osx?appType=aircall-workspace&arch=x64&platform=macPkg")
    fi
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*-([0-9.]*)-.*/\1/')
    expectedTeamID="3ML357Q795"
    ;;
