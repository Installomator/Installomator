parsec)
    name="Parsec"
    type="pkg"
    downloadURL="https://builds.parsec.app/package/parsec-macos.pkg"
    appNewVersion=$(parsecTmpDir=$(mktemp -d); trap 'rm -rf "$parsecTmpDir"' EXIT; curl -fsL "$downloadURL" -o "$parsecTmpDir/parsec.pkg" && xar -xf "$parsecTmpDir/parsec.pkg" -C "$parsecTmpDir" PackageInfo && sed -nE 's/.*CFBundleShortVersionString="([^"]+)".*/\1/p' "$parsecTmpDir/PackageInfo" | head -1)
    expectedTeamID="Y9MY52XZDB"
    blockingProcesses=( NONE )
    ;;
