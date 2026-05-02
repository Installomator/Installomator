eclipsetemurin11)
    name="Temurin 11"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        cpu_arch="aarch64"
    elif [[ $(arch) == "i386" ]]; then
        cpu_arch="x64"
    fi
    downloadURL=$(getJSONValue "$(curl -fsSL "https://api.adoptium.net/v3/assets/latest/11/hotspot?os=mac&image_type=jdk&vendor=eclipse&architecture=${cpu_arch}")" '[0].binary.installer.link')
    archiveName="$(basename "$downloadURL")"
    appNewVersion="$(echo "$downloadURL" | grep -oE 'jdk-11(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //'; fi }
    ;;
