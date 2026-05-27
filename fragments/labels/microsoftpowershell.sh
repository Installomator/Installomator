microsoftpowershell)
    name="PowerShell"
    type="pkg"
    if [[ $(arch) = "i386" ]]; then
        archiveName="powershell-[0-9.]*-osx-x64.pkg"
    else
        archiveName="powershell-[0-9.]*-osx-arm64.pkg"
    fi
    downloadURL=$(downloadURLFromGit PowerShell PowerShell )
    appNewVersion=$(versionFromGit PowerShell PowerShell )
    expectedTeamID="UBF8T346G9"
    ;;
