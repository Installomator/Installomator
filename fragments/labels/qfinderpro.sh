qfinderpro)
    name="Qfinder Pro"
    type="pkgInDmg"
    downloadURL=$(curl -fsL https://update.qnap.com/SoftwareRelease.xml | grep -oE 'https?://download\.qnap\.com/Storage/Utility/QNAPQfinderProMac-[0-9.]+\.dmg' | sort -u -t- -k2,2V | tail -1 | sed 's|^http:|https:|')
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*QNAPQfinderProMac-([0-9.]+)\.dmg/\1/')
    expectedTeamID="JY5JM7GXQJ"
    ;;
