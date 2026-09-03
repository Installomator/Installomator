parsec)
    name="Parsec"
    type="pkg"
    downloadURL="https://builds.parsec.app/package/parsec-macos.pkg"
    appNewVersion=$(tmpDir=$(mktemp -d); trap 'rm -rf "$tmpDir"' EXIT; curl -fsL "$downloadURL" -o "$tmpDir/parsec.pkg" && xar -xf "$tmpDir/parsec.pkg" -C "$tmpDir" PackageInfo && sed -nE 's/.*CFBundleShortVersionString="([^"]+)".*/\1/p' "$tmpDir/PackageInfo" | head -1)
    expectedTeamID="Y9MY52XZDB"
    blockingProcesses=( NONE )
    ;;
