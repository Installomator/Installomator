netnewswire)
    name="NetNewsWire"
    type="zip"
    downloadURL="$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml | xmllint --xpath 'string(//item[1]/enclosure/@url)' -)"
    appNewVersion="$(curl -fs https://ranchero.com/downloads/netnewswire-release.xml | xmllint --xpath 'string(//*[local-name()="item"][1]/*[local-name()="enclosure"]/@*[local-name()="shortVersionString"])' -)"
    expectedTeamID="M8L2WTLA8W"
    ;;
