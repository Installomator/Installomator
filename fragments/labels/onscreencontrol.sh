onscreencontrol)
    name="OnScreen Control"
    type="pkgInZip"
    packageID="com.LGSI.OnScreen-Control"
    releaseURL="https://www.lg.com/de/support/software-select-category-result?csSalesCode=34WK95U-W.AEU"
    appNewVersion=$(curl -sf $releaseURL | grep -m 1 "Mac_OSC_" | sed -E 's/.*OSC_([0-9.]*).zip.*/\1/g')
    downloadURL=$(curl -sf $releaseURL | grep -m 1 "Mac_OSC_" | sed "s|.*href=\"\(.*\)\" title.*|\\1|")
    expectedTeamID="5SKT5H4CPQ"
    ;;
