foxitpdfreader)
    name="Foxit PDF Reader"
    type="pkg"
    foxitReaderJSON=$(curl -fsL "https://www.foxit.com/portal/download/getdownloadform.html?formId=download-reader&retJson=1&platform=Mac-OS-X")
    downloadURL="https://cdn01.foxitsoftware.com$(getJSONValue "$foxitReaderJSON" "package_info.down")"
    appNewVersion=$(sed -E 's#.*/([0-9]{4}\.[0-9]+\.[0-9]+)/.*#\1#' <<< "$downloadURL")
    appCustomVersion(){ /usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "/Applications/Foxit PDF Reader.app/Contents/Info.plist" 2>/dev/null | cut -d "." -f1-3; }
    expectedTeamID="8GN47HTP75"
    ;;
