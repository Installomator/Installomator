thoriumreader)
    name="Thorium"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit edrlab thorium-reader arm64.dmg)
    else
        downloadURL=$(downloadURLFromGit edrlab thorium-reader .dmg | grep -v arm64)
    fi
    appNewVersion=$(versionFromGit edrlab thorium-reader)
    expectedTeamID="327YA3JNGT"
    ;;
