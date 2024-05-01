eclipsetemurin17)
    name="Temurin 17"
    type="pkg"
    packageID="net.temurin.17.jdk"
    downloadURL="$(downloadURLFromGit adoptium temurin17-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin17-binaries | grep -oE 'jdk-17(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //'; fi }
    ;;
