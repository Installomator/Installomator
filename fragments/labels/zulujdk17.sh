zulujdk17)
    name="Zulu JDK 17"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.17"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://api.azul.com/metadata/v1/zulu/packages/?java_version=17&os=macos&arch=arm&archive_type=dmg&java_package_type=jdk&javafx_bundled=false&release_status=ga&availability_type=CA&page_size=1" | plutil -extract 0.download_url raw -)
    else
        downloadURL=$(curl -fsL "https://api.azul.com/metadata/v1/zulu/packages/?java_version=17&os=macos&arch=x86&archive_type=dmg&java_package_type=jdk&javafx_bundled=false&release_status=ga&availability_type=CA&page_size=1" | plutil -extract 0.download_url raw -)
    fi
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/zulu([0-9]+\.[0-9]+)\.([0-9]+)-ca-jdk17.*|\1+\2|')
    expectedTeamID="TDTHCUPYFR"
    blockingProcesses=( NONE )
    ;;
