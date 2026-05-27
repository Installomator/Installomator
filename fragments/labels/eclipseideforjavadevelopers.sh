eclipseideforjavadevelopers)
    name="Eclipse"
    type="dmg"
    appNewVersion=$(curl -fs "https://www.eclipse.org/downloads/packages/" | grep -o 'Eclipse IDE [0-9]\{4\}-[0-9]\{2\} [A-Z0-9]*' | head -1 | awk '{print $3"-"$4}')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.eclipse.org/technology/epp/downloads/release/${appNewVersion%-*}/${appNewVersion##*-}/eclipse-java-$appNewVersion-macosx-cocoa-aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.eclipse.org/technology/epp/downloads/release/${appNewVersion%-*}/${appNewVersion##*-}/eclipse-java-$appNewVersion-macosx-cocoa-x86_64.dmg"
    fi
    expectedTeamID="JCDTMS22B4"
    ;;
