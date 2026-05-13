rstudio)
    name="RStudio"
    type="dmg"
    downloadURL="https://rstudio.org/download/latest/stable/desktop/mac/RStudio-latest.dmg"
    appNewVersion=$(curl -sfI "$downloadURL" | grep -i "^location" | grep -oE '[0-9]{4}\.[0-9]{2}\.[0-9]{1,2}\-[0-9]+' | sed 's/-/+/')
    expectedTeamID="FYF2F5GFX4"
    ;;
