bitwigstudio)
    name="Bitwig Studio"
    type="dmg"
    bitwigDetails=$(curl -sfL "https://www.bitwig.com/previous_releases/" | grep -o 'href="https://www\.bitwig\.com/dl/Bitwig%20Studio/[^/]*/installer_mac/"' | head -1 )
    appNewVersion=$(echo $bitwigDetails | grep -o 'Studio/[^/]*/installer' | awk -F'/' '{print $2}')
    downloadURL=$(echo $bitwigDetails | grep -o 'https://[^"]*')
    expectedTeamID="2B6K987585"
    ;;
