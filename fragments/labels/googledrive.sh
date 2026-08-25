googledrive|\
googledrivefilestream)
    name="Google Drive File Stream"
    type="pkgInDmg"
    appNewVersion=$(curl -s "https://community.chocolatey.org/packages/googledrive" | xmllint --html --xpath 'substring-after(string(//h1[@class="mb-0 text-center"]), "Google Drive")' - 2> /dev/null | tr -d '[:space:]')
    downloadURL="https://dl.google.com/drive-file-stream/GoogleDriveFileStream.dmg"
    blockingProcesses=( "Google Docs" "Google Drive" "Google Sheets" "Google Slides" )
    appName="Google Drive.app"
    expectedTeamID="EQHXZ8M8AV"
    ;;
