redcinexpro)
    name="REDCINE-X PRO"
    versionKey="CFBundleVersion"
    type="pkg"
    downloadURL=$(curl -fsL -A "Mozilla/5.0" "https://www.red.com/RedSuiteCentric/SCA-Kilimanjaro/services/Download.Service.ss?downloadIdentifier=redcine-x-pro-mac" | grep -oE '"versionUrl":"[^"]+REDCINE-X_PRO_Build_[0-9.]+\.pkg"' | head -1 | cut -d'"' -f4)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*_Build_([0-9.]+)\.pkg/\1/')
    expectedTeamID="4ER5V66EKT"
    blockingProcesses=( "REDCINE-X PRO" "RED PLAYER" )
    ;;
