golang)
    name="GoLang"
    type="pkg"
    packageID="org.golang.go"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "darwin-arm" | tr '"' '\n' | grep "pkg")"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "darwin-amd" | tr '"' '\n' | grep "pkg")"
    fi
    appNewVersion="$( echo "${downloadURL}" | sed -E 's/.*\/(go[0-9.]*)\..*/\1/g' )" # Version includes letters "go" in the beginning
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( NONE )
    ;;
