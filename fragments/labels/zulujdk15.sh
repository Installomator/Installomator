zulujdk15)
    name="Zulu JDK 15"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.15"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com$( curl -fs "https://cdn.azul.com/zulu/bin/" | sed -ne 's/^.*<a href="\(.*zulu15.*ca-jdk15.*x64.dmg\)">.*$/\1/p' | sort -n | tail -1 )
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com$( curl -fs "https://cdn.azul.com/zulu/bin/" | sed -ne 's/^.*<a href="\(.*zulu15.*ca-jdk15.*aarch64.dmg\)">.*$/\1/p' | sort -n | tail -1 )
    fi
    expectedTeamID="TDTHCUPYFR"
    appNewVersion=$(echo "$downloadURL" | sed -ne 's/.*bin\/zulu\([0-9.]*\)\.\([0-9]*\)*-ca-.*/\1+\2/p')
    ;;
