guardianbrowser)
	# A privacy-focused web browser designed to enhance security with built-in ad blocking, tracker protection, and encrypted browsing
    name="Guardian Browser"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
       downloadURL="https://production-archimedes-secure-browser-artifacts.s3.amazonaws.com/latest/mac-x64/guardian-browser-x64.dmg"
    elif [[ $(arch) == arm64 ]]; then
       downloadURL="https://production-archimedes-secure-browser-artifacts.s3.amazonaws.com/latest/mac-arm64/guardian-browser-arm64.dmg"
    fi
    expectedTeamID="7TCATJSU2Y"
    ;;
