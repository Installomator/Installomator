quarto)
    name="Quarto"
    type="pkg"
    archiveName="macos.pkg"
    downloadURL=$(downloadURLFromGit quarto-dev quarto-cli)
    appNewVersion=$(versionFromGit quarto-dev quarto-cli)
    expectedTeamID="FYF2F5GFX4"
    packageID="org.rstudio.quarto"
    blockingProcesses=( NONE )
    ;;
