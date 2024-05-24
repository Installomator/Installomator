quartocli)
    name="quarto-cli"
    type="pkg"
    downloadURL="$(downloadURLFromGit quarto-dev quarto-cli)"
    appNewVersion="$(versionFromGit quarto-dev quarto-cli)"
    expectedTeamID="Y9A5TA7V7H"
    blockingProcesses=( quarto deno esbuild pandoc sass typst npm )
    ;;
