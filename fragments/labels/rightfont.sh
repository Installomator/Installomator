rightfont)
    name="RightFont"
    type="zip"
    downloadURL="https://rightfontapp.com/update/rightfont.zip"
    appNewVersion=$(curl -fsSL "https://rightfontapp.com/updates/app" | grep -oE 'id="[0-9]+(\.[0-9]+)+" class="anchor"' | head -n 1 | cut -d '"' -f 2)
    expectedTeamID="VABUY2Z595"
    ;;
