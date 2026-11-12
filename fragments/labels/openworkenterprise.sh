openworkenterprise)
    name="OpenWork Enterprise"
    type="dmg"
    appNewVersion="$(versionFromGit different-ai openwork)"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="openwork-enterprise-mac-arm64-${appNewVersion}.dmg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="openwork-enterprise-mac-x64-${appNewVersion}.dmg"
    fi
    downloadURL="$(downloadURLFromGit different-ai openwork)"
    expectedTeamID="F5DJWB4CCV"
    ;;
