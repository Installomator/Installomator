abetterfinderrename12)
    name="A Better Finder Rename 12"
    type="dmg"
    downloadURL="https://www.publicspace.net/download/ABFRX12.dmg"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -s https://www.publicspace.net/ABetterFinderRename/download.html | grep -Eo 'Download A Better Finder Rename [0-9.]+' | awk '{print $NF}' | sort -V | tail -n1)
    expectedTeamID="7Y9KW4ND8W"
    ;;

