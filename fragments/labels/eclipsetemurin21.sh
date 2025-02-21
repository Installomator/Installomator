eclipsetemurin21)
    name="Temurin 21"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="OpenJDK21U-jdk_aarch64_mac_hotspot_[0-9._]+\.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="OpenJDK21U-jdk_x64_mac_hotspot_[0-9._]+\.pkg"
    fi
    downloadURL="$(downloadURLFromGit adoptium temurin21-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin21-binaries | grep -oE 'jdk-21(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //; s/-LTS//'; fi }
    ;;

