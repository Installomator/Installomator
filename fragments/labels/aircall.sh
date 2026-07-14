aircall)
    name="Aircall Workspace"
    type="pkg"
    packageID="io.aircall.workspace"
    if [[ $(arch) == "arm64" ]]; then
        cpu_arch="arm64"
    elif [[ $(arch) == "i386" ]]; then
        cpu_arch="x64"
    fi
    # The download endpoint redirects to the versioned file, so the redirect is
    # resolved here to get both the URL and the version, for example:
    # https://download-electron.aircall.io/aircall-workspace/Aircall-Workspace-1.15.20-arm64.pkg
    downloadURL=$(curl -fsL -r 0-0 -o /dev/null -w "%{url_effective}" "https://electron.aircall.io/download/osx?appType=aircall-workspace&arch=${cpu_arch}&platform=macPkg")
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*-([0-9.]*)-.*/\1/')
    expectedTeamID="3ML357Q795"
    ;;
