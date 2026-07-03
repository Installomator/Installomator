eclipsetemurin8)
    name="Temurin 8"
    type="pkg"
    # releases for JDK 8 LTS are only built for x64 architecture
    downloadURL=$(getJSONValue "$(curl -fsSL "https://api.adoptium.net/v3/assets/latest/8/hotspot?os=mac&image_type=jdk&vendor=eclipse&architecture=x64")" '[0].binary.installer.link')
    archiveName="$(basename "$downloadURL")"
    appNewVersion="$(echo "$downloadURL" | grep -oE 'jdk8u[0-9]+-b[0-9]+' | sed 's/jdk//')"
    expectedTeamID="JCDTMS22B4"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Info.plist" ]; then echo "8u$(/usr/bin/defaults read "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Info.plist" "CFBundleGetInfoString" | sed 's/Eclipse Temurin 1.8.0_//')"; fi }
    ;;
