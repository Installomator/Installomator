zulujdk17)
    name="Zulu JDK 17"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.17"
    curlOptions=( -H "Referer: https://www.azul.com/downloads/" )
    if [[ "$arch" == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://api.azul.com/metadata/v1/zulu/packages/?java_version=17&os=macos&arch=arm&java_package_type=jdk&archive_type=dmg&javafx_bundled=false&release_status=ga&availability_types=CA&latest=true" | grep -oE '"download_url":"[^"]*"' | head -1 | sed 's/"download_url":"//' | tr -d '"')
    else
        downloadURL=$(curl -fsL "https://api.azul.com/metadata/v1/zulu/packages/?java_version=17&os=macos&arch=x64&java_package_type=jdk&archive_type=dmg&javafx_bundled=false&release_status=ga&availability_types=CA&latest=true" | grep -oE '"download_url":"[^"]*"' | head -1 | sed 's/"download_url":"//' | tr -d '"')
    fi
    appNewVersion=$(echo "$downloadURL" | grep -oE 'jdk17\.[0-9]+\.[0-9]+' | sed 's/jdk//')
    appCustomVersion() { [ -f "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Info.plist" ] && /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; }
    expectedTeamID="TDTHCUPYFR"
    ;;
