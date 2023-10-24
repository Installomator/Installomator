powershell)
    name="powershell"
    type="pkg"
    packageID="com.microsoft.powershell"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName="powershell-[0-9.]*-osx-arm64.pkg"
        downloadURL="$(downloadURLFromGit PowerShell PowerShell)"
    else
        archiveName="powershell-[0-9.]*-osx-x64.pkg"
        downloadURL="$(downloadURLFromGit PowerShell PowerShell)"
    fi
    appNewVersion="$(versionFromGit PowerShell PowerShell)"
    expectedTeamID="UBF8T346G9"
    ;;
