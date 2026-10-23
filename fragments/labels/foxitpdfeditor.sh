foxitpdfeditor)
    name="Foxit PDF Editor"
    type="pkg"
    downloadURL="https://www.foxit.com/downloads/latest.html?product=Foxit-PDF-Editor-Suite-Pro-Teams-Mac"
    appNewVersion=$(curl -fsL "https://www.foxit.com/pdf-editor/version-history.html" | grep -Eo 'Version_[0-9]{4}\.[0-9]+\.[0-9]+\.7[0-9]+' | head -1 | sed 's/Version_//')
    expectedTeamID="8GN47HTP75"
    blockingProcesses=( "Foxit PDF Editor" )
    ;;
