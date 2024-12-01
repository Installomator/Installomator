codemeter)
    name="CodeMeter"
    type="pkgInDmg"
    archiveName="CmInstall.pkg"
    appCustomVersion(){ defaults read "/Applications/Codemeter.app/Contents/Info.plist" CFBundleVersion | cut -d '.' -f 1-2 }
    html_page_source="https://www.wibu.com/de/support/anwendersoftware/anwendersoftware.html"
    macos_value=$(curl -fs $html_page_source | xmllint --html --format - 2>/dev/null | grep -Eo -m1 ' 12"> <option value=".*?"' | cut -d '"' -f3)
    downloadHTML="https://www.wibu.com/de/support/anwendersoftware/anwendersoftware/file/download/$macos_value.html"
    downloadURL="https://www.wibu.com"$(curl -fs $downloadHTML | xmllint --html --format - 2>/dev/null | grep -Eo 'rel="nofollow" href=".*?"' | cut -d '"' -f4)
    appNewVersion=$(curl -fs $html_page_source | xmllint --html --format - 2>/dev/null | grep -Eo "option value=\"$macos_value\" style=\"\">Version .*?\"" | sed -E 's/.*Version (.*) \| 2.*/\1/g')
    expectedTeamID="2SE7W37452"
    ;;
