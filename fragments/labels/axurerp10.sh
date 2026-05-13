axurerp10)
    name="Axure RP 10"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -s https://www.axure.com/release-history/rp10 | grep -oE 'https://[^ ]+.dmg' | grep arm64 | head -n 1)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -s https://www.axure.com/release-history/rp10 | grep -oE 'https://[^ ]+.dmg' | grep -v arm64 | head -n 1)
    fi
    appNewVersion=$(curl -sL https://www.axure.com/release-history/rp10 | grep -oE '[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}\.[0-9]{1,4}' | head -n 1)
    expectedTeamID="HUMW6UU796"
    versionKey="CFBundleVersion"
    ;;
