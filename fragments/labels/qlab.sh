qlab)
    name="QLab"
    type="dmg"
    downloadURL="https://qlab.app/downloads/QLab.dmg"
    appNewVersion=curl -fs "https://qlab.app/download/" | xmllint --html --xpath "substring-after(string(//h1),' ')" - 2> /dev/null
    expectedTeamID="7672N4CCJM"
    ;;
