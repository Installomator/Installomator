vscodium)
    # credit: AP Orlebeke (@apizz)
    name="VSCodium"
    type="dmg"
    downloadURL=$(curl -fs "https://api.github.com/repos/VSCodium/vscodium/releases/latest" | awk -F '"' "/browser_download_url/ && /dmg/ && ! /sig/ && ! /CLI/ && ! /sha256/ { print \$4 }")
    #downloadURL=$(downloadURLFromGit VSCodium vscodium) # Too many versions
    appNewVersion=$(versionFromGit VSCodium vscodium)
    expectedTeamID="C7S3ZQ2B8V"
    appName="VSCodium.app"
    blockingProcesses=( Electron )
    ;;
