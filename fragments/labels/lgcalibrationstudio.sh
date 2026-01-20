lgcalibrationstudio)
    name="LG Calibration Studio"
    type="pkgInZip"
    packageID="LGSI.TrueColorPro"
    releaseURL="https://www.lg.com/us/support/product/lg-34WK95U-W.AUS"
    appNewVersion=$(curl -sf "$releaseURL" | grep -m 1 "\[Mac\] LG Calibration Studio - version " | sed -E 's/.*\[Mac\] LG Calibration Studio - version ([^<]+)<\/p>.*/\1/')
    fileID=$(curl -sf "$releaseURL" | grep "Mac_LCS_" | sed -n '2p' | grep -o '"originalFileName":"Mac_LCS_[^"]*\.zip","fileName":"[^"]*"' | head -n1 | sed -E 's/.*"fileName":"([^"]*)".*/\1/')
    downloadURL="https://gscs-b2c.lge.com/downloadFile?fileId=$fileID"
    expectedTeamID="5SKT5H4CPQ"
    ;;
