openjdk11ujdk)
    name="OpenJDK11U"
    type="pkg"
    packageID="net.temurin.11.jdk"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://api.adoptium.net/v3/installer/latest/11/ga/mac/aarch64/jdk/hotspot/normal/eclipse?project=jdk"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://api.adoptium.net/v3/installer/latest/11/ga/mac/x64/jdk/hotspot/normal/eclipse?project=jdk"
    fi
    appNewVersion="$(curl -fsIL "${downloadURL}" | sed -nE 's/.*filename=OpenJDK.*_(11[0-9.]*).*/\1/p')"
    expectedTeamID="JCDTMS22B4"
    ;;
