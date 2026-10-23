sonicpi)
    name="Sonic Pi"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://sonic-pi.net$(curl -sfL "https://sonic-pi.net/" | xmllint --html --format - 2>/dev/null | grep -o "\/files.*Sonic-Pi-for-Mac-arm64.*.dmg")"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://sonic-pi.net$(curl -sfL "https://sonic-pi.net/" | xmllint --html --format - 2>/dev/null | grep -o "\/files.*Sonic-Pi-for-Mac-x64.*.dmg")"
    fi
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(curl -sfL "https://sonic-pi.net/" | xmllint --html --format - 2>/dev/null | grep -o "\/.*Sonic-Pi-for-Mac-arm64.*.dmg" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{0,2}' | head -n1)
    elif [[ $(arch) == "i386" ]]; then
        appNewVersion=$(curl -sfL "https://sonic-pi.net/" | xmllint --html --format - 2>/dev/null | grep -o "\/.*Sonic-Pi-for-Mac-x64.*.dmg" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{0,2}' | head -n1)
    fi
    expectedTeamID="MM65S3L4NG"
    ;;
