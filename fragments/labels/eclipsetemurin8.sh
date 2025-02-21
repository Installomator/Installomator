eclipsetemurin8)
    name="Temurin 8"
    type="pkg"
    downloadURL="$(downloadURLFromGit adoptium temurin8-binaries)"
    appNewVersion="$(downloadURLFromGit adoptium temurin8-binaries | grep -oE 'jdk8u[0-9]+-b[0-9]+' | sed 's/jdk//')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Info.plist" ]; then echo "8u$(/usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/Eclipse Temurin 1.8.0_//')"; fi }
    ;;
