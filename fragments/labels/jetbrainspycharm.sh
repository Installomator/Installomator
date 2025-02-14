jetbrainspycharm)
    # This is the Pro version of PyCharm. Do not confuse with PyCharm CE.
    name="PyCharm"
    type="dmg"
    jetbrainscode="PCP"
    jetbrainsdistribution="mac"
    if [[ $(arch) == arm64 ]]; then
        jetbrainsdistribution="macM1"
    fi
    downloadURL="https://download.jetbrains.com/product?code=${jetbrainscode}&latest&distribution=${jetbrainsdistribution}"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "location" | tail -1 | sed -E 's/.*-([0-9.]+)[-.].*/\1/g' )
    expectedTeamID="2ZEFAR8TH3"
    blockingProcesses=( pycharm )
    ;;
