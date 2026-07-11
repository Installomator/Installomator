exocharts)
    name="Exocharts"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://help.exocharts.com/api/v2/help_center/en-us/articles/5466518923281.json" | plutil -extract article.body raw -o - - | grep -o 'https://exocharts.com/downloads/Exocharts_[0-9.]*_M1_ARM\.dmg' | head -1)
    else
        printlog "Exocharts is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "Exocharts requires Apple Silicon" ERROR
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/Exocharts_([0-9.]+)_M1_ARM\.dmg|\1|')
    versionKey="CFBundleVersion"
    expectedTeamID="7HSW4JKZM2"
    ;;
