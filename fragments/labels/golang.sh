golang)
    name="GoLang"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "darwin-arm" | tr '"' '\n' | grep "pkg")"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://go.dev$(curl -fs "https://go.dev/dl/" | grep -i "downloadBox" | grep "darwin-amd" | tr '"' '\n' | grep "pkg")"
    fi
    appCustomVersion(){ /usr/local/go/bin/go version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+' }
    appNewVersion="$( echo "${downloadURL}" | sed -E 's/.*\/(go[0-9.]*)\..*/\1/g' | sed -E 's/go//g' )"
    expectedTeamID="EQHXZ8M8AV"
    blockingProcesses=( NONE )
    ;;
