windsurf)
    name="Windsurf"
    type="zip"
    myARCH="$(/usr/bin/arch)"
    if [ "$myARCH" != "arm64" ]; then
        myARCH=x64
    fi
    downloadURL="$( curl -s https://windsurf.com/editor/releases | tr '"\' "\n" | grep -m1 "darwin-$myARCH" )"
    appNewVersion="$( echo "$downloadURL" | awk -F '-' '{ print $NF }' | cut -d '.' -f 1-3 )"
    expectedTeamID="83Z2LHX6XW"
    ;;
