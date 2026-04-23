mixxx)
    name="Mixxx"
    type="dmg"
    packageID="org.mixxx.mixxx"
    appNewVersion=$(versionFromGit mixxxdj mixxx)
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://downloads.mixxx.org/releases/$appNewVersion/mixxx-$appNewVersion-macosarm.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://downloads.mixxx.org/releases/$appNewVersion/mixxx-$appNewVersion-macosintel.dmg"
    fi
    versionKey="CFBundleShortVersionString"
    expectedTeamID="JBLRSP95FC"
    ;;
