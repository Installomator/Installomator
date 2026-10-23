teamviewer)
    name="TeamViewer"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    pkgName="Install TeamViewer.app/Contents/Resources/Install TeamViewer.pkg"
    teamViewerDownloadData=$(curl -fsL "https://www.teamviewer.com/en/download/macos/" | tr "<" "\n<" | grep "cmp-smartdownloadbutton__wrapper" | grep "TeamViewer full client" | sed -E 's/.*data-json="([^"]*)".*/\1/;s/&quot;/"/g;s/&amp;/\&/g')
    downloadURL=$(getJSONValue "$teamViewerDownloadData" "data[0].downloadLink")
    appNewVersion=$(getJSONValue "$teamViewerDownloadData" "data[0].versionNumber")
    expectedTeamID="H7UGFBUGV6"
    ;;
