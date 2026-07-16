kiro)
    name="Kiro"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://kiro.dev/downloads" | grep -Eo 'https://prod\.download\.desktop\.kiro\.dev/releases/stable/darwin-arm64/signed/[0-9]+\.[0-9]+\.[0-9]+/kiro-ide-[0-9]+\.[0-9]+\.[0-9]+-stable-darwin-arm64\.dmg' | head -1)
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL "https://kiro.dev/downloads" | grep -Eo 'https://prod\.download\.desktop\.kiro\.dev/releases/stable/darwin-x64/signed/[0-9]+\.[0-9]+\.[0-9]+/kiro-ide-[0-9]+\.[0-9]+\.[0-9]+-stable-darwin-x64\.dmg' | head -1)
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/signed/([0-9]+\.[0-9]+\.[0-9]+)/.*|\1|')
    expectedTeamID="94KV3E626L"
    ;;
