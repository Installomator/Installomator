zulujdkfx27)
    name="Zulu JDK 27"
    type="pkgInDmg"
    packageID="com.azulsystems.zulufx.27"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu27.*ca-fx-jdk27.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sort | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu27.*ca-fx-jdk27.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sort | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//")
    ;;
