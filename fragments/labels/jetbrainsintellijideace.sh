jetbrainsintellijideace|\
intellijideace)
    name="IntelliJ IDEA CE"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=IIC&latest&distribution=mac"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=IIC&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    expectedTeamID="2ZEFAR8TH3"
    ;;
