escrowbuddy)
    name="Escrow Buddy"
    type="pkg"
    archiveName="Escrow.Buddy-[0-9.]*.pkg"
    appNewVersion=$(versionFromGit macadmins escrow-buddy )
    downloadURL=$(downloadURLFromGit macadmins escrow-buddy )
    expectedTeamID="T4SK8ZXCXG"
    if [ -e "/Library/Security/SecurityAgentPlugins/Escrow Buddy.bundle" ]; then
        appCustomVersion() { defaults read "/Library/Security/SecurityAgentPlugins/Escrow Buddy.bundle/Contents/Info.plist" "CFBundleShortVersionString" }
    fi
    ;;
