googledrive|\
googledrivefilestream)
    name="Google Drive"
    type="pkgInDmg"
    appNewVersion=$(curl -fsL "https://community.chocolatey.org/api/v2/Packages()?%24filter=Id%20eq%20%27googledrive%27%20and%20IsLatestVersion" | xmllint --xpath 'string(//*[local-name()="Version"])' - 2>/dev/null)
    downloadURL="https://dl.google.com/drive-file-stream/GoogleDrive.dmg"
    blockingProcesses=( "Google Docs" "Google Drive" "Google Sheets" "Google Slides" )
    versionKey="CFBundleVersion"
    expectedTeamID="EQHXZ8M8AV"
    ;;
