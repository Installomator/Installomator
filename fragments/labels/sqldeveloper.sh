sqldeveloper)
    name="SQLDeveloper"
    type="zip"
    downloadURL="https://download.oracle.com/otn_software/java/sqldeveloper/sqldeveloper-24.3.1.347.1826-macos-aarch64.app.zip"
    appNewVersion="$(plutil -p /Applications/SQLDeveloper.app/Contents/Info.plist | grep CFBundleShortVersionString | awk -F'"' '{print $4}')"
    expectedTeamID="VB5E2TV963"
    ;;
