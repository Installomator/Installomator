zulujdk25)
    name="Zulu JDK 25"
    type="pkgInDmg"
    packageID="com.azulsystems.zulu.25"
    if [[ $(arch) == i386 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu25.*ca-jdk25.*x64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=https://cdn.azul.com/zulu/bin/$(curl -fs "https://cdn.azul.com/zulu/bin/" | grep -Eio '">zulu25.*ca-jdk25.*aarch64.dmg(.*)' | cut -c3- | sed 's/<\/a><\/td>//' | sed -E 's/([0-9.]*)M//' | awk '{print $2 $1}' | sort -V | tail -1)
    fi
    expectedTeamID="TDTHCUPYFR"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Info.plist" ]; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/zulu-25.jdk/Contents/Info.plist" "CFBundleName" | sed 's/Zulu //'; fi }
    appNewVersion=$(echo "$downloadURL" | cut -d "-" -f 1 | sed -e "s/.*zulu//" | sed 's/jdk//')
    ;;
