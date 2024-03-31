eclipsetemurin21)
    name="Temurin 21"
    type="pkg"
    packageID="net.temurin.21.jdk"
    downloadURL="$(downloadURLFromGit adoptium temurin21-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin21-binaries | grep -oE 'jdk-21(\.0\.)?([0-9]+)?(\.[0-9]+)?%2B[0-9]+(\.[0-9]+)?' | sed 's/jdk-//; s/%2B/+/g')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/OpenJDK //; s/-LTS//'; fi }
    ;;

