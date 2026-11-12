mixxx)
    name="Mixxx"
    type="dmg"
    appNewVersion=$(versionFromGit mixxxdj mixxx)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://downloads.mixxx.org/releases/$appNewVersion/mixxx-$appNewVersion-macosarm.dmg"
    else
        downloadURL="https://downloads.mixxx.org/releases/$appNewVersion/mixxx-$appNewVersion-macosintel.dmg"
    fi
    expectedTeamID="JBLRSP95FC"
    ;;
