openjdk8ujdk)
    name="OpenJDK8U"
    type="pkg"
    packageID="net.temurin.8.jdk"
    if [[ $(arch) == "arm64" ]]; then
        # Note: no arm64 version available for v8. Use x64/i386 instead:
        downloadURL="https://api.adoptium.net/v3/installer/latest/8/ga/mac/x64/jdk/hotspot/normal/eclipse?project=jdk"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://api.adoptium.net/v3/installer/latest/8/ga/mac/x64/jdk/hotspot/normal/eclipse?project=jdk"
    fi
    appNewVersion="$(curl -fsIL "${downloadURL}" | sed -nE 's/.*filename=OpenJDK.*_(8u.*).pkg/\1/p')"
    expectedTeamID="JCDTMS22B4"
    ;;
