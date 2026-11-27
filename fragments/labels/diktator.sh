diktator)
    name="Diktator"
    type="dmg"
    expectedTeamID="8ZPG86M6M4"
    versionKey="CFBundleVersion"
    if [[ $(sysctl -in hw.optional.arm64) != 1 ]]; then
        cleanupAndExit 95 "Diktator requires Apple silicon." ERROR
    fi
    if ! is-at-least 26.0 "$installedOSversion"; then
        cleanupAndExit 15 "Diktator requires macOS 26 or later." ERROR
    fi
    diktatorApp="${targetDir:-/Applications}/Diktator.app"
    if [[ -e "$diktatorApp" && $(plutil -extract CFBundleIdentifier raw -o - "$diktatorApp/Contents/Info.plist" 2>/dev/null) != "com.mgair.Diktator.direct" ]]; then
        cleanupAndExit 23 "The Diktator.app at the destination is not the Direct edition; leaving it unchanged." ERROR
    fi
    diktatorRelease=$(curl -fsL "https://diktator.app/updates/appcast.xml" | xmllint --nonet --xpath 'concat(/rss/channel/item[1]/*[local-name()="shortVersionString"], "-", /rss/channel/item[1]/*[local-name()="version"])' - 2>/dev/null)
    if [[ ! $diktatorRelease =~ '^[0-9]+([.][0-9]+)+-[0-9]+$' ]]; then
        cleanupAndExit 14 "Could not read a valid Direct release from the Diktator update feed." ERROR
    fi
    appNewVersion="${diktatorRelease##*-}"
    downloadURL="https://diktator.app/downloads/Diktator-${diktatorRelease}.dmg"
    if [[ -d "$diktatorApp" ]]; then
        diktatorBuild=$(plutil -extract CFBundleVersion raw -o - "$diktatorApp/Contents/Info.plist" 2>/dev/null)
        if [[ $diktatorBuild == <-> && $diktatorBuild -gt $appNewVersion ]]; then
            cleanupAndExit 0 "A newer Diktator Direct build ($diktatorBuild) is already installed." INFO
        fi
    fi
    ;;
