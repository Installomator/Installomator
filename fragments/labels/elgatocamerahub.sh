elgatocamerahub)
       name="Elgato Camera Hub"
       type="pkg"
       elgatoJSON=$(curl -fsSL "https://gc-updates.elgato.com/mac/echm-update/final/app-version-check.json")
       appNewVersion=$(echo "$elgatoJSON" | grep -o '"Version":"[^"]*"' | head -1 | cut -d'"' -f4)
       downloadURL=$(echo "$elgatoJSON" | grep -o '"fileURL":"[^"]*"' | head -1 | cut -d'"' -f4)
       appCustomVersion() {
           local infoPath="$1"
           local version=$(defaults read "$infoPath" CFBundleShortVersionString 2>/dev/null)
           local build=$(defaults read "$infoPath" CFBundleVersion 2>/dev/null)
           echo "${version}.${build}"
       }
       expectedTeamID="Y93VXCB8Q5"
       blockingProcesses=( "Camera Hub" )
       ;;
