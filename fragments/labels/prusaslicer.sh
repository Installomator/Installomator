prusaslicer)
    name="PrusaSlicer"
    type="dmg"
    downloadURL=$(downloadURLFromGit prusa3d PrusaSlicer)
    appNewVersion="PrusaSlicer-$(versionFromGit prusa3d PrusaSlicer)"
    folderName="Original Prusa Drivers"
    appName="${folderName}/PrusaSlicer.app"
    versionKey="CFBundleVersion"
    expectedTeamID="DKPB65N43Z"
    ;;
