snapgene|snapgeneviewer)
    name="SnapGene"
    type="dmg"
    downloadURL="https://www.snapgene.com/local/targets/download.php?os=mac&majorRelease=latest&minorRelease=latest"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | tr '/' '\n' | grep -i "dmg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_mac\.dmg/\1/g' )
    expectedTeamID="WVCV9Q8Y78"
    ;;
