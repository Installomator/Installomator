jetbrainsgoland)
    name="GoLand"
    type="dmg"
    jetbrainscode="GO"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
