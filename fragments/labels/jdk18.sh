jdk18)
    name="Java SE Development Kit 18"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.oracle.com/java/18/latest/jdk-18_macos-aarch64_bin.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.oracle.com/java/18/latest/jdk-18_macos-x64_bin.dmg"
    fi
    appCustomVersion(){ java --version | grep java | awk '{print $2}' }
    appNewVersion=$(curl -sf "https://www.oracle.com/java/technologies/downloads/#jdk18-mac" | grep -m 1 "Java SE Development Kit" | sed "s|.*Kit \(.*\) downloads.*|\\1|")
    expectedTeamID="VB5E2TV963"
    ;;
