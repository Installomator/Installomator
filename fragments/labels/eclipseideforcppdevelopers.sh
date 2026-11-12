eclipseideforcppdevelopers)
    name="Eclipse"
    type="dmg"
    eclipseRelease=$(curl -fsL "https://download.eclipse.org/technology/epp/downloads/release/release.xml" | xpath 'string(/packages/present)' 2>/dev/null)
    eclipseReleaseMonth="${eclipseRelease%%/*}"
    eclipseReleaseMetadata=$(curl -fsL "https://projects.eclipse.org/api/projects/technology.packaging/releases?pagesize=10&order_by=DESC")
    for eclipseReleaseIndex in {0..9}; do
        eclipseReleaseDate=$(getJSONValue "$eclipseReleaseMetadata" "releases[$eclipseReleaseIndex].date")
        if [[ "${eclipseReleaseDate%-*}" == "$eclipseReleaseMonth" ]]; then
            appNewVersion=$(getJSONValue "$eclipseReleaseMetadata" "releases[$eclipseReleaseIndex].name")
            break
        fi
    done
    if [[ $(arch) == "arm64" ]]; then
        eclipseArchitecture="aarch64"
    elif [[ $(arch) == "i386" ]]; then
        eclipseArchitecture="x86_64"
    fi
    downloadURL="https://download.eclipse.org/technology/epp/downloads/release/${eclipseRelease}/eclipse-cpp-${eclipseRelease/\//-}-macosx-cocoa-${eclipseArchitecture}.dmg"
    appCustomVersion() { if [[ $(defaults read "$targetDir/$appName/Contents/Info.plist" CFBundleIdentifier 2>/dev/null) == "epp.package.cpp" ]]; then defaults read "$targetDir/$appName/Contents/Info.plist" CFBundleShortVersionString; fi }
    expectedTeamID="JCDTMS22B4"
    blockingProcesses=( eclipse )
    ;;
