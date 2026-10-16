solstice|mersivesolstice)
    name="Mersive Solstice"
    type="dmg"
    pageContent=$(curl -fsL "https://www.mersive.com/downloads")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(echo "$pageContent" | sed -nE 's#.*href="(https://mersive\.com/downloads/SolsticeClient-[0-9]+(\.[0-9]+)+\.dmg)"[^>]*>Mac Apple.*#\1#p')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(echo "$pageContent" | sed -nE 's#.*href="(https://mersive\.com/downloads/SolsticeClient-[0-9]+(\.[0-9]+)+\.dmg)"[^>]*>Mac Intel.*#\1#p')
    fi
    expectedTeamID="63B5A5WDNG"
    ;;
