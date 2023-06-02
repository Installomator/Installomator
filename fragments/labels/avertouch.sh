avertouch)
    name="AverTouch"
    type="zip"
    appNewVersion="$(curl -s "https://www.averusa.com/education/support/avertouch" | xmllint --html --xpath 'substring-after(string(//a[@class="dl-avertouch-mac"]/@href), "AVerTouch_mac_v")' - 2> /dev/null | sed 's/\.zip$//')"
    downloadURL="https://www.averusa.com/education/downloads/AVerTouch_mac_v${appNewVersion}.zip"
    expectedTeamID="B6T3WCD59Q"
    versionKey="CFBundleVersion"
    ;;
