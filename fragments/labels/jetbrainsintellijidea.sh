jetbrainsintellijidea)
    # credit: Gabe Marchan (www.gabemarchan.com)
    name="IntelliJ IDEA"
    type="dmg"
    downloadURL="https://download.jetbrains.com/product?code=II&latest&distribution=mac"
    appNewVersion=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=II&latest=true&type=release" | grep -o 'version*.*,' | cut -d '"' -f3)
    expectedTeamID="2ZEFAR8TH3"
    ;;
