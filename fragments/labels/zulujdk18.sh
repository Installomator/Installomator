zulujdk18)
    name="Zulu JDK 18"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.18"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://cdn.azul.com/zulu/bin/$(curl -fsL 'https://cdn.azul.com/zulu/bin/' | grep -Eo 'zulu18[^"<]*ca-jdk18[^"<]*aarch64[.]dmg' | sort -Vu | tail -n 1)"
    else
        downloadURL="https://cdn.azul.com/zulu/bin/$(curl -fsL 'https://cdn.azul.com/zulu/bin/' | grep -Eo 'zulu18[^"<]*ca-jdk18[^"<]*x64[.]dmg' | sort -Vu | tail -n 1)"
    fi
    appCustomVersion(){ java -version 2>&1 | grep Runtime | awk '{print $4}' | sed -e "s/.*Zulu//" | cut -d '-' -f 1 | sed -e "s/+/\./" }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//")
    expectedTeamID="TDTHCUPYFR"
    ;;
