firecutforpremierepro)
    name="FireCut for Premiere Pro"
    type="pkg"
    downloadURL="$(curl -fsL https://firecut.ai/downloads | grep "FireCut_PP_Dist.*pkg" | grep -o "https://.*pkg")"
    appNewVersion=$(echo $downloadURL | grep -o "[0-9].*[0-9]")
    appCustomVersion(){ xmllint --xpath '//ExtensionList' '/Library/Application Support/Adobe/CEP/extensions/com.firecut.base/CSXS/manifest.xml' | grep -o "[0-9].*[0-9]" }
    expectedTeamID="7ASRSVAEMS"
    blockingProcesses=( "Adobe Premiere Pro 2024" "Adobe Premiere Pro 2025" "Adobe Premiere Pro 2026" "Adobe Premiere Pro 2027" )
    ;;
