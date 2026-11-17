amazoncorretto27jdk)
    name="Amazon Corretto 27 JDK"
    type="pkg"
    packageID="com.amazon.corretto.27"
    if [[ "$(arch)" == "arm64" ]]; then
        downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-27-aarch64-macos-jdk.pkg"
    else
        downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-27-x64-macos-jdk.pkg"
    fi
    appNewVersion="$(curl -Ls https://raw.githubusercontent.com/corretto/corretto-27/develop/CHANGELOG.md | grep "## Corretto version" | head -n 1 | awk '{ print $NF}')"
    expectedTeamID="94KV3E626L"
    ;;
