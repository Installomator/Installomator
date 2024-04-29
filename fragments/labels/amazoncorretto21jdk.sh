amazoncorretto21jdk)
    name="Amazon Corretto 21 JDK"
    type="pkg"
    case $(arch) in
        "arm64") cpu_arch="aarch64" ;;
        "i386") cpu_arch="x64" ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-21-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(curl -fsIL $downloadURL | sed -nE 's/^[lL]ocation.*\/([0-9]+\.[0-9.]*[0-9]).*/\1/p')"
    appCustomVersion(){ java -version 2>&1 | sed -nE 's/.*Runtime.*Corretto-([0-9]+\.[0-9.]*[0-9]).*/\1/p' }
    expectedTeamID="94KV3E626L"
    ;;
