orcaslicer)
    name="OrcaSlicer"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
       downloadURL="$(downloadURLFromGit SoftFever OrcaSlicer)"
       appNewVersion="$(versionFromGit SoftFever OrcaSlicer)"
       archiveName="OrcaSlicer_Mac_arm64_*.dmg"
    elif [[ $(arch) == "i386" ]]; then
      downloadURL="$(downloadURLFromGit SoftFever OrcaSlicer)"
      appNewVersion="$(versionFromGit SoftFever OrcaSlicer)"
      archiveName="OrcaSlicer_Mac_x86_64_*.dmg"
    fi
    expectedTeamID="XQK7C38HH5"
    ;;
    
