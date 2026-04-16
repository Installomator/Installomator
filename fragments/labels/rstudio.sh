rstudio)
    name="RStudio"
    type="dmg"
    downloadPage=$(curl -s "https://docs.posit.co/supported-versions/rstudio.html" | grep -E "https.*Installers" | head -n 1 | grep -oE 'https?://[^"]+')
    downloadURL=$(curl -s "$downloadPage" | grep -E "macos.*dmg" | head -1 | grep -oE 'https?://[^"]+')
    appNewVersion=$(echo "$downloadPage" | grep -oE '[0-9]{4}\.[0-9]{2}\.[0-9]{1,2}\+[0-9]+')
    expectedTeamID="FYF2F5GFX4"
    ;;
