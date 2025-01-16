foxitpdfeditor)
    name="Foxit PDF Editor"
    type="pkg"
    downloadURL="https://www.foxit.com/downloads/latest.html?product=Foxit-PDF-Editor-Suite-Pro-Teams-Mac&platform=Mac-OS-X&language=Multi%20Language"
    appNewVersion=$(curl -fsSL "https://www.foxit.com/pdf-editor/version-history.html" | awk '/<div class="tab-product hide" id="tab-editor-suite-mac">/,/<\/div>/' | sed -n 's/.*<h3>Version \([0-9.]*\)<\/h3>.*/\1/p' | head -n 1)
    expectedTeamID="8GN47HTP75"
    ;;
