lexarrecoverytool)
    name="Lexar Recovery Tool"
    type="dmg"
    lexarFeed=$(curl -fsL "https://oss-account.lexar.com/user/macos-us/latest-mac.yml")
    downloadURL="https://oss-account.lexar.com/user/macos-us/$(echo "$lexarFeed" | sed -n 's/^[[:space:]]*-[[:space:]]*url:[[:space:]]*//p' | tr -d "\"'\r" | grep -i '\.dmg$' | head -1)"
    appNewVersion=$(echo "$lexarFeed" | sed -n 's/^version:[[:space:]]*//p' | tr -d "\"'\r" | head -1)
    expectedTeamID="Y8HM6WR2DV"
    ;;
