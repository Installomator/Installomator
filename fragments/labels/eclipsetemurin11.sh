eclipsetemurin11)
    name="Temurin 11"
    type="pkg"
    packageID="net.temurin.11.jdk"
    downloadURL="$(downloadURLFromGit adoptium temurin11-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin11-binaries | grep -oE 'jdk-11(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //'; fi }
    ;;
