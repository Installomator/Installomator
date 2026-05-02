labchartreader)
    name="LabChartReader"
    type="pkg"
    appNewVersion=$(curl -A 'Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0' https://www.adinstruments.com/support/downloads/mac/labchart-reader | grep ".pkg" | cut -d "_" -f2 | sed 's/\.pkg" title="LabChart Reader">//')
    packageID="com.adinstruments.labchartreader_$appNewVersion"
    downloadURL="https://go.adinstruments.com/Installers/mac/LabChartReader_$appNewVersion.pkg"
    expectedTeamID="M74NZ7VL2C"
    ;;
