chemdoodle3d)
    name="ChemDoodle3D"
    type="dmg"
    [[ $(arch) == "arm64" ]] && cpu_arch="aarch64" || cpu_arch="x64"
    downloadURL="https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | grep -oE '[^"]*Doodle3D-[^"]*'$cpu_arch'[^"]*\.dmg' | head -1)"
    expectedTeamID="9XP397UW95"
    folderName="ChemDoodle3D"
    appName="${folderName}/ChemDoodle3D.app"
    appNewVersion=$(sed -E 's/.*-(.*).dmg/\1/g' <<< $downloadURL )
    versionKey="CFBundleVersion"
    ;;
