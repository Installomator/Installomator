patchomator)
    name="patchomator"
    type="pkg"
    packageID="com.option8.patchomator"
    downloadURL=$(downloadURLFromGit Mac-Nerd patchomator)
    appNewVersion=$(sed -nE 's#.*/patchomator-([0-9]+(\.[0-9]+)*)\.pkg$#\1#p' <<< "$downloadURL")
    expectedTeamID="4VAAB6AM7X"
    blockingProcesses=( NONE )
    ;;
