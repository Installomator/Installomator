lgcalibrationstudio)
    name="LG Calibration Studio"
    type="pkgInZip"
    packageID="LGSI.TrueColorPro"
    releaseURL="https://www.lg.com/us/support/product/lg-34WK95U-W.AUS"
    appNewVersion=$(curl -sf $releaseURL | grep -m 1 "Mac_LCS_" | sed -E 's/.*LCS_([0-9.]*).zip.*/\1/g')
    downloadURL=$(curl -sf $releaseURL | grep -m 1 "Mac_LCS_" | sed "s|.*href=\"\(.*\)\" role.*|\\1|")
    expectedTeamID="5SKT5H4CPQ"
    ;;
