amazoncorretto17jdk)
    name="Amazon Corretto 17 JDK"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="aarch64"
        ;;
        "i386")
            cpu_arch="x64"
        ;;
    esac
    downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-17-${cpu_arch}-macos-jdk.pkg"
    appNewVersion="$(
        curl -Ls https://raw.githubusercontent.com/corretto/corretto-17/develop/CHANGELOG.md \
            | grep "## Corretto version" \
            | head -n 1 \
            | awk '{ print $NF}'
    )"
    expectedTeamID="94KV3E626L"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/amazon-corretto-17.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    ;;
