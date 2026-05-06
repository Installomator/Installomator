jumper)
    name="Jumper"
    type="dmg"
    appcastXML="$(curl -fsL https://download.getjumper.io/appcast.xml)"
    appNewVersion="$(echo "$appcastXML" | xmllint --xpath 'string(//*[local-name()="item"][1]/*[local-name()="shortVersionString"]/text())' -)"
    buildVersion="$(echo "$appcastXML" | xmllint --xpath 'string(//*[local-name()="item"][1]/*[local-name()="version"]/text())' -)"
    archiveName="jumper-${appNewVersion}-build-${buildVersion}.dmg"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://download.getjumper.io/jumper-${appNewVersion}-build-${buildVersion}.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	downloadURL="https://download.getjumper.io/intel/jumper-${appNewVersion}-build-${buildVersion}-intel.dmg"
    fi
    versionKey="CFBundleShortVersionString"
    expectedTeamID="PP557RNS84"
    ;;
