microsoftoffice365)
    name="MicrosoftOffice365"
    type="pkg"
    packageID="com.microsoft.pkg.licensing"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=525133"
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "/Microsoft_.*pkg" | cut -d "_" -f 5)
    expectedTeamID="UBF8T346G9"
    blockingProcesses=( "Microsoft AutoUpdate" "Microsoft Word" "Microsoft PowerPoint" "Microsoft Excel" "Microsoft OneNote" "Microsoft Outlook" "OneDrive" )
    ;;
