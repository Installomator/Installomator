fathom)
   name="Fathom"
   type="dmg"
   downloadPageData=$(curl -s https://fathom.video/download/macos | grep -o 'appDownloadUrls.*dmg_arm64' | head -1)
   versionNumber=$(echo "$downloadPageData" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
   if [[ $(arch) == i386 ]]; then
      downloadURL="https://storage.googleapis.com/electron_releases/v${versionNumber}/Fathom-darwin-x64-${versionNumber}.dmg"
   elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://storage.googleapis.com/electron_releases/v${versionNumber}/Fathom-darwin-arm64-${versionNumber}.dmg"
   fi
   expectedTeamID="JH7GAYKCUH"
   blockingProcesses=( NONE )
   ;;
