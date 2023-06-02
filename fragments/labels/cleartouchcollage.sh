cleartouchcollage)
    name="Collage"
    type="pkgInZip"
    packageID="com.cvte.cleartouch.mac"
    downloadURL=$(curl -fs https://www.getcleartouch.com/download/collage-for-mac/ | xmllint --html --xpath 'string(//*[@id="wpdm-filelist-412"]/tbody/tr[1]/td[2]/a/@href)' - 2> /dev/null | sed 's/ /%20/g')
    expectedTeamID="P76M9BE8DQ"
    ;;
