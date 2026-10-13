labchartreader8)
    name="LabChart Reader"
    appName="LabChart 8 Reader/LabChart Reader.app"
    type="pkg"
    curlOptions=(-A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15")
    downloadURL=$(curl -fsL "${curlOptions[@]}" "https://www.adinstruments.com/support/downloads/mac/labchart-reader" | grep -Eo "https://go\.adinstruments\.com/Installers/mac/LabChartReader_[0-9]+(\.[0-9]+)+\.pkg" | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -nE 's#.*LabChartReader_([0-9]+(\.[0-9]+)+)\.pkg#\1#p')
    expectedTeamID="M74NZ7VL2C"
    ;;
