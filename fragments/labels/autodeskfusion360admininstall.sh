autodeskfusion360admininstall)
    name="Autodesk Fusion 360 Admin Install"
    type="pkg"
    packageID="com.autodesk.edu.fusion360"
    downloadURL="https://dl.appstreaming.autodesk.com/production/installers/Autodesk%20Fusion%20Admin%20Install.pkg"
    appNewVersion=$(curl -fs "https://dl.appstreaming.autodesk.com/production/97e6dd95735340d6ad6e222a520454db/73e72ada57b7480280f7a6f4a289729f/full.json" | sed -nE 's/.*"build-version": "([^"]+)".*/\1/p')
    expectedTeamID="XXKJ396S2Y"
    appName="Autodesk Fusion 360.app"
    blockingProcesses=( "Autodesk Fusion 360" "Fusion 360" )
    ;;
