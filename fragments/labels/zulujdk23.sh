zulujdk18)
    name="Zulu JDK 18"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.18"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio 'href="/zulu/bin/(zulu18[^"]*ca-jdk18[^"]*x64\.dmg)"' | sed -E 's|href="/zulu/bin/(.*)\"|\1|' | sort | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio 'href="/zulu/bin/(zulu18[^"]*ca-jdk18[^"]*aarch64\.dmg)"' | sed -E 's|href="/zulu/bin/(.*)\"|\1|' | sort | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-18.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-18.jdk/Contents/Info.plist" "CFBundleShortVersionString"; fi; }
    appNewVersion=$(echo "$downloadURL" | grep -Eo 'zulu[0-9]+\.[0-9]+\.[0-9]+' | head -1 | sed 's/zulu//')
    ;;
