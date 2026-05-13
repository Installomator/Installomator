abetterfinderattributes7)
    name="A Better Finder Attributes 7"
    type="dmg"
    downloadURL="https://www.publicspace.net/download/ABFAX.dmg"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -s https://www.publicspace.net/ABetterFinderAttributes/download.html | grep -Eo 'Download A Better Finder Attributes [0-9.]+' | awk '{print $NF}' | sort -V | tail -n1)
    expectedTeamID="7Y9KW4ND8W"
    ;;

