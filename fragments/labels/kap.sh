kap)
    # credit: Lance Stephens (@pythoninthegrass on MacAdmins Slack)
    name="Kap"
    type="dmg"
    archiveName=
    if [[ $(arch) = "i386" ]]; then
        archiveName="${name}-[0-9.]*-x64.${type}"
        downloadURL=$(downloadURLFromGit wulkano kap | grep -i x64)
    else
        archiveName="${name}-[0-9.]*-arm64.${type}"
        downloadURL=$(downloadURLFromGit wulkano kap)
    fi
    appNewVersion=$(versionFromGit wulkano Kap)
    expectedTeamID="2KEEHXF6R6"
    ;;
