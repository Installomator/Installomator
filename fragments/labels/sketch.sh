sketch)
     name="Sketch"
     type="zip"
     downloadURL=$(curl -sf https://www.sketch.com/downloads/mac/ | grep 'href="https://download.sketch.com' | sed -E 's/.*href=\"(.*)\".?/\1/g')
     appNewVersion=$(curl -fs https://www.sketch.com/updates/ | grep "Sketch Version" | head -1 | sed -E 's/.*Version ([0-9.]*)<.*/\1/g') # version from update page
     expectedTeamID="WUGMZZ5K46"
     ;;
skype)
    name="Skype"
    type="dmg"
    downloadURL="https://get.skype.com/go/getskype-skypeformac"
    appNewVersion=$(curl -is "https://get.skype.com/go/getskype-skypeformac" | grep ocation: | grep -o "Skype-.*dmg" | cut -d "-" -f 2 | cut -d "." -f1-2)
    expectedTeamID="AL798K98FX"
    Company="Microsoft"
    PatchSkip="YES"
    ;;
