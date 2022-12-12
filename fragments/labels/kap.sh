kap)
    # credit: Lance Stephens (@pythoninthegrass on MacAdmins Slack)
    name="Kap"
    type="dmg"
    if [[ $(arch) = "i386" ]]; then
        archiveName="${name}-[0-9.]*-x64.${type}"
        downloadURL=$(downloadURLFromGit wulkano kap | grep -i x64)
    else
        archiveName="${name}-[0-9.]*-arm64.${type}"
        downloadURL=$(downloadURLFromGit wulkano kap | grep -i arm64)
    fi
    appNewVersion=$(versionFromGit wulkano Kap)
    expectedTeamID="2KEEHXF6R6"
    ;;
