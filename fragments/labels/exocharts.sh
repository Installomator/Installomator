exocharts)
    name="Exocharts"
    type="dmg"
    appNewVersion=$(curl -fs "https://help.exocharts.com/hc/en-us/articles/5466518923281-Exocharts-downloads" | grep -o "Exocharts_[0-9.]*_M1_ARM.dmg" | head -1 | sed -E 's/Exocharts_([0-9.]+)_M1_ARM.dmg/\1/')
    downloadURL="https://exocharts.com/downloads/Exocharts_${appNewVersion}_M1_ARM.dmg"
    expectedTeamID="7HSW4JKZM2"
    ;;
