devin|\
windsurf)
    name="Devin"
    type="dmg"
    [[ $arch == "arm64" ]] && cpu_arch="arm64" || cpu_arch="x64"
    downloadURL="$( curl -s https://docs.devin.ai/desktop/releases | tr '"\\' "\n" | grep -m1 "darwin-${cpu_arch}.*\.dmg" )"
    appNewVersion="$( echo "$downloadURL" | awk -F '-' '{ print $NF }' | cut -d '.' -f 1-3 )"
    expectedTeamID="83Z2LHX6XW"
    ;;
