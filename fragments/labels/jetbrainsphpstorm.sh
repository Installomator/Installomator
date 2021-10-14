jetbrainsphpstorm)
    name="PHPStorm"
    type="dmg"
    jetbrainscode="PS"
    if [[ $(arch) == i386 ]]; then
        jetbrainsdistribution="mac"
    elif [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*\/[a-zA-Z-]*-([0-9.]*).*[-.].*dmg/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    ;;
