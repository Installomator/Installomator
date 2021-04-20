jetbrainspycharm)
    # credit: Adrian Bühler (@midni9ht)
    # This is the Pro version of PyCharm.
    # Do not confuse with PyCharm CE.
    name="PyCharm"
    type="dmg"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PCP&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCP&latest&distribution=mac"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCP&latest&distribution=macM1"
    fi
    expectedTeamID="2ZEFAR8TH3"
    ;;
