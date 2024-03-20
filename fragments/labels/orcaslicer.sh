orcaslicer)
    name="OrcaSlicer"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
       archiveName="OrcaSlicer_Mac_arm64_*.dmg"
       downloadURL="$(downloadURLFromGit SoftFever OrcaSlicer)"
       appNewVersion="$(versionFromGit SoftFever OrcaSlicer)"
    elif [[ $(arch) == "i386" ]]; then
      archiveName="OrcaSlicer_Mac_x86_64_*.dmg"
      downloadURL="$(downloadURLFromGit SoftFever OrcaSlicer)"
      appNewVersion="$(versionFromGit SoftFever OrcaSlicer)"
    fi
    expectedTeamID="XQK7C38HH5"
    ;;
    
