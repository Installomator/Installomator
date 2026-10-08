patchomator)
    name="patchomator"
    type="pkg"
    packageID="com.option8.patchomator"
    downloadURL="$(downloadURLFromGit Mac-Nerd patchomator)"
    appNewVersion=$(sed -nE 's#.*/patchomator-([0-9][^/]*)\.pkg$#\1#p' <<< "$downloadURL")
    [[ -n "$appNewVersion" ]] || appNewVersion="$(versionFromGit Mac-Nerd patchomator)"
    expectedTeamID="4VAAB6AM7X"
    ;;
