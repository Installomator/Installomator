zulujdk15)
    name="Zulu JDK 15"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.15"
    if [[ $(arch) == i386 ]]; then
        downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu15.*ca-jdk15.*x64.dmg" | sed 's/\\//g')
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=$(curl -fs "https://www.azul.com/downloads/zulu-community/" | xmllint --html --format - 2>/dev/null | tr , '\n' | grep -o "https:.*/zulu15.*ca-jdk15.*aarch64.dmg" | sed 's/\\//g')
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//") # Cannot be compared to anything
    ;;
