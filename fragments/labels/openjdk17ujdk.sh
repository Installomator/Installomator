openjdk17ujdk)
    name="OpenJDK17U"
    type="pkg"
    packageID="net.temurin.17.jdk"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://api.adoptium.net/v3/installer/latest/17/ga/mac/aarch64/jdk/hotspot/normal/eclipse?project=jdk"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://api.adoptium.net/v3/installer/latest/17/ga/mac/x64/jdk/hotspot/normal/eclipse?project=jdk"
    fi
    appNewVersion="$(curl -fsIL "${downloadURL}" | sed -nE 's/.*filename=OpenJDK.*_(17[0-9.]*).*/\1/p')"
    expectedTeamID="JCDTMS22B4"
    ;;
