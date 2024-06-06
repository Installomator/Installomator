editshare-flowstory)
    name="FLOW Story"
    type="dmg"
    editshareInstanceURL="" # https://editshare.example.com
    appname="FLOW Story"
    archiveName="FLOWStory-Latest.dmg"
    downloadURL=$(curl -s ${editshareInstanceURL}/software.html | grep -o 'href="[^"]*FLOWStory-Latest.dmg"' | grep -o '".*"' | sed 's/"//g')
    appNewVersion=$(curl -s ${editshareInstanceURL}/software.html | grep -o '<span class="highlight">[^<]*' | sed 's/<span class="highlight">//; s/\.[^.]*$//')
    expectedTeamID="URJUZJ3GCG"
    ;;