zulujdk21)
    name="Zulu JDK 21"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.21"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu21.*ca-jdk21.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu21.*ca-jdk21.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; fi }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//" | sed 's/jdk//') 
    ;;
