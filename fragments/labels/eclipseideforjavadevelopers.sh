eclipseideforjavadevelopers)
    name="Eclipse"
    type="dmg"
    alphaChar=$(curl -fs "https://www.eclipse.org/downloads/packages/" | grep -o 'eclipse-java-[0-9]\{4\}-[0-9]\{2\}-[A-Za-z0-9]\+-macosx-cocoa-x86_64\.dmg' | awk -F'-' '{print $5}')
    yearMonth=$(curl -fs "https://www.eclipse.org/downloads/packages/" | grep -o "eclipse-java-[0-9]\{4\}-[0-9]\{2\}-$alphaChar-macosx-cocoa-x86_64.dmg" | sed -E 's/.*eclipse-java-([0-9]{4}-[0-9]{2})-R.*/\1/')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://download.eclipse.org/technology/epp/downloads/release/$yearMonth/$alphaChar/eclipse-java-$yearMonth-$alphaChar-macosx-cocoa-aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://download.eclipse.org/technology/epp/downloads/release/$yearMonth/$alphaChar/eclipse-java-$yearMonth-$alphaChar-macosx-cocoa-x86_64.dmg"
    fi
    expectedTeamID="JCDTMS22B4"
    ;;
