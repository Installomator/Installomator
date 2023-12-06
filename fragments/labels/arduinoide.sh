arduinoide)
    name="Arduino IDE"
    type="dmg"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL=$( curl -fsL "https://www.arduino.cc/en/software" | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*_macOS_arm64.dmg" )
    else
        downloadURL=$( curl -fsL "https://www.arduino.cc/en/software" | xmllint --html --format - 2>/dev/null | grep -m 1 -o "https://.*_macOS_64bit.dmg" )
    fi
    appNewVersion=$( echo "${downloadURL}" | cut -d '_' -f 2 )
    expectedTeamID="7KT7ZWMCJT"
    ;;
