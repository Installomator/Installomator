foxitpdfeditor)
    name="Foxit PDF Editor"
    type="pkg"
    #packageID="com.foxit.pkg.pdfeditor"
    downloadURL="https://www.foxit.com/downloads/latest.html?product=Foxit-PDF-Editor-Suite-Pro-Teams-Mac"
    appNewVersion=$(curl -fsL "https://www.foxit.com/pdf-editor/version-history.html" \
        | grep -oE 'Subscription Release\s+[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
        | head -n1 \
        | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
    expectedTeamID="8GN47HTP75"
    blockingProcesses=( "Foxit PDF Editor" )
    ;;
