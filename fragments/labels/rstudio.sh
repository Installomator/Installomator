rstudio)
    name="RStudio"
    type="dmg"
    downloadURL="https://rstudio.org/download/latest/stable/desktop/mac/RStudio-latest.dmg"
    finalURL=$(curl -fsLI -o /dev/null -w "%{url_effective}" "$downloadURL")
    appNewVersion=$(echo "$finalURL" | grep -oE '[0-9]{4}\.[0-9]{2}\.[0-9]{1,2}\-[0-9]+' | sed 's/-/+/')
    expectedTeamID="FYF2F5GFX4"
    ;;
