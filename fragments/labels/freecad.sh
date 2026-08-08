freecad)
    name="FreeCAD"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        archiveName="FreeCAD.*x86_64.*\.dmg"
    elif [[ $(arch) == arm64 ]]; then
        archiveName="FreeCAD.*arm64.*\.dmg"
    fi
    appCustomVersion(){ if [ -f "/Applications/FreeCAD.app/Contents/Info.plist" ]; then /usr/bin/defaults read "/Applications/FreeCAD.app/Contents/Info.plist" "CFBundleVersion" | awk -F'-' '{print $1}'; fi }
    downloadURL="$(downloadURLFromGit FreeCAD FreeCAD)"
    appNewVersion="$(versionFromGit FreeCAD FreeCAD)"
    expectedTeamID="289DJRF23X"
    ;;
