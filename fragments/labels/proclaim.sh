proclaim)
    name="Proclaim"
    type="dmg"
    appNewVersion=$(/usr/bin/curl -fsSL "https://clientservices.logos.com/update/v1/feed/proclaim-mac/stable.xml" | /usr/bin/xmllint --xpath 'string((//*[local-name()="entry"])[1]/*[local-name()="version"])' -)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://downloads.logoscdn.com/Proclaim/Installer/${appNewVersion}/Proclaim-arm.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://downloads.logoscdn.com/Proclaim/Installer/${appNewVersion}/Proclaim.dmg"
    fi
    expectedTeamID="G2ET27DGDP"
    ;;

