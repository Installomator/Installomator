zulujdk25)
    name="Zulu JDK 25"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.25"
    if [[ $(arch) == i386 ]]; then
        archFilter="x64"
    elif [[ $(arch) == arm64 ]]; then
        archFilter="aarch64"
    fi
    downloadURL=$(curl -fs "https://api.azul.com/metadata/v1/zulu/packages/?java_version=25&os=macos&archive_type=dmg&latest=true&java_package_type=jdk&javafx=false&release_status=ga" | grep -Eo '"download_url":"[^"]+"' | grep "ca-jdk.*${archFilter}\.dmg" | sed -E 's/.*zulu([0-9\.]+)-.*/\1 &/' | sort -V | tail -1 | cut -d ' ' -f2 | cut -d '"' -f4)
    appNewVersion=$(echo "$downloadURL" | sed -E 's#.*/zulu([0-9.]+)-.*#\1#')
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; fi }
    ;;
