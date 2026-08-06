chatgptatlas)
    name="ChatGPT Atlas"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://persistent.oaistatic.com/atlas/public/ChatGPT_Atlas.dmg"
    else
        printlog "ChatGPT Atlas is only compatible with Apple Silicon (arm64) Macs." ERROR
        cleanupAndExit 95 "ChatGPT Atlas requires Apple Silicon" ERROR
    fi
    appNewVersion=$(curl -fs "https://persistent.oaistatic.com/atlas/public/sparkle_public_appcast.xml" | xmllint --xpath 'string((//*[local-name()="item"])[1]/*[local-name()="shortVersionString"]/text())' -)
    expectedTeamID="2DC432GLL2"
    ;;
