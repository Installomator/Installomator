texshop)
    # This is the original source of TeXShop, but it is often very slow to download.
    # A label texshop-alternative exists that is hosted on GitHub, but might not have the latest version and is not maintained by the original developers.
    # This app needs basictex or mactex for the LaTeX part.
    name="TeXShop"
    type="zip"
    downloadURL="https://pages.uoregon.edu/koch/texshop/texshop-64/texshop.zip"
    appNewVersion="$(curl -fs https://pages.uoregon.edu/koch/texshop/obtaining.html | xmllint --html --format - | grep "texshop-64/texshop.zip" | grep "Latest TeXShop" | sed -nE 's/.*Version ([0-9.]*).*/\1/p')"
    expectedTeamID="RBGCY5RJWM"
    ;;
