jdk17)
    name="Java SE Development Kit 17"
    type="pkgInDmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -sf https://www.oracle.com/java/technologies/javase/jdk17-archive-downloads.html | grep -m 1 "Java SE Development Kit" | sed "s|.*Kit \(.*\)\<.*|\\1|")
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.oracle.com/java/17/archive/jdk-"$appNewVersion"_macos-aarch64_bin.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.oracle.com/java/17/archive/jdk-"$appNewVersion"_macos-x64_bin.dmg"
    fi
    appCustomVersion(){ java --version | grep java | awk '{print $2}' }
    expectedTeamID="VB5E2TV963"
    ;;
