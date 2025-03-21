axurerp10)
    name="Axure RP 10"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -s https://www.axure.com/release-history/rp10 | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | sed 's/ *$//' | grep arm64)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -s https://www.axure.com/release-history/rp10 | grep dmg | sed -n 's/.*href="\([^"]*\)".*/\1/p' | sed 's/ *$//' | grep -v arm64)
    fi
    appNewVersion=$( curl -sL https://www.axure.com/release-history/rp10 | grep -Eo '[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}' -m 1 )
    expectedTeamID="HUMW6UU796"
    versionKey="CFBundleVersion"
    ;;
