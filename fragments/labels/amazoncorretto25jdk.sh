amazoncorretto25jdk)
    name="Amazon Corretto 25 JDK"
    type="pkg"
    packageID="com.amazon.corretto.25"
    if [[ "$arch" == "arm64" ]]; then
        downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-25-aarch64-macos-jdk.pkg"
    else
        downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-25-x64-macos-jdk.pkg"
    fi
    appNewVersion="$(curl -Ls https://raw.githubusercontent.com/corretto/corretto-25/develop/CHANGELOG.md | grep "## Corretto version" | head -n 1 | awk '{ print $NF}')"
    expectedTeamID="94KV3E626L"
    ;;
