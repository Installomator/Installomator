rstudio)
    name="RStudio"
    type="dmg"
    downloadURL=$(curl -s -L "https://rstudio.com/products/rstudio/download/" | grep -m 1 -Eio 'href="https://download1.rstudio.org/desktop/macos/RStudio-(.*).dmg"' | cut -c7- | sed -e 's/"$//')
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' )
    expectedTeamID="FYF2F5GFX4"
    ;;
