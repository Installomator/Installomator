littlekeebo)
    name="Little Keebo"
    type="zip"
    downloadURL="$(curl -fsL https://downloads.littlekeebo.app/feeds/appcast.xml | xmllint --xpath 'string(//item[1]/enclosure/@url)' -)"
    appNewVersion="$(curl -fsL https://downloads.littlekeebo.app/feeds/appcast.xml | xmllint --xpath 'string(//*[local-name()="item"][1]/*[local-name()="shortVersionString"])' -)"
    expectedTeamID="LT297PXA82"
    ;;
