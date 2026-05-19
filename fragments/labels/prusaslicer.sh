prusaslicer)
    name="PrusaSlicer"
    type="dmg"
    downloadURL="$(curl -sfL "https://api.github.com/repos/prusa3d/PrusaSlicer/releases" | grep "browser_download_url" | grep -i "macos-universal.dmg" | grep -v -- "-rc\|-beta\|-alpha" | head -1 | tr -d ' "' | sed 's/browser_download_url://')"
    appNewVersion="$(echo "$downloadURL" | sed 's/.*PrusaSlicer-//;s/-macos.*//')"
    folderName="Original Prusa Drivers"
    appName="${folderName}/PrusaSlicer.app"
    expectedTeamID="DKPB65N43Z"
    ;;
