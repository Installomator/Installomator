foxitpdfreader)
    name="Foxit PDF Reader"
    type="pkg"
    #the packageID versioning seems to be in line with Foxit PDF Editor and does not reflect the installed versionNumber
    #packageID="com.foxit.pkg.pdfreader"
    downloadURL="https://www.foxit.com/downloads/latest.html?product=Foxit-Reader&platform=Mac-OS-X"
    appNewVersion=$(curl -fsSL "https://www.foxit.com/pdf-editor/version-history.html" | awk '/<div class="tab-product hide" id="tab-editor-suite-mac">/,/<\/div>/' | sed -n 's/.*<h3>Version \([0-9.]*\)<\/h3>.*/\1/p' | head -n 1)
    expectedTeamID="8GN47HTP75"
    ;;
