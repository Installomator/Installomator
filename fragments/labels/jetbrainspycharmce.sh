jetbrainspycharmce|\
pycharmce)
    name="PyCharm CE"
    type="dmg"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    if [[ $(arch) == i386 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCC&latest&distribution=mac"
    elif [[ $(arch) == arm64 ]]; then
      downloadURL="https://download.jetbrains.com/product?code=PCC&latest&distribution=macM1"
    fi
    expectedTeamID="2ZEFAR8TH3"
    ;;
