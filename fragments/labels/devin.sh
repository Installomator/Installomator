devin|\
windsurf)
    name="Devin"
    type="dmg"
    myARCH="$(/usr/bin/arch)"
    if [ "$myARCH" != "arm64" ]; then
        myARCH=x64
    fi
    downloadURL="$( curl -s https://docs.devin.ai/desktop/releases | tr '"\\' "\n" | grep -m1 "darwin-$myARCH.*\.dmg" )"
    appNewVersion="$( echo "$downloadURL" | awk -F '-' '{ print $NF }' | cut -d '.' -f 1-3 )"
    expectedTeamID="83Z2LHX6XW"
    ;;
