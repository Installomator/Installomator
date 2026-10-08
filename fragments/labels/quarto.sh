quarto)
    name="Quarto"
    appNewVersion="$(versionFromGit quarto-dev quarto-cli)"
    type="pkg"
    downloadURL="$(downloadURLFromGit quarto-dev quarto-cli)"
    expectedTeamID="FYF2F5GFX4"
    packageID="org.rstudio.quarto"
    appCustomVersion(){ cat /Applications/quarto/share/version }
    ;;
