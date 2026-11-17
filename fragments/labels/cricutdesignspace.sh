cricutdesignspace)
    name="Cricut Design Space"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        cricutVersionJSON=$(curl -fsL "https://software.cricut.com/prod/osx-arm64/latest.json")
    elif [[ $(arch) == "i386" ]]; then
        cricutVersionJSON=$(curl -fsL "https://software.cricut.com/prod/osx-x64/latest.json")
    fi
    appNewVersion=$(getJSONValue "$cricutVersionJSON" "rolloutVersion")
    cricutDownloadFilename=$(getJSONValue "$cricutVersionJSON" "rolloutInstallFile")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://software.cricut.com/prod/osx-arm64/$cricutDownloadFilename"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://software.cricut.com/prod/osx-x64/$cricutDownloadFilename"
    fi
    expectedTeamID="25627ZFVT7"
    ;;
