editshare-connect)
    name="EditShare Connect"
    type="pkg"
    packageID="com.editshare.connect
com.editshare.permsui"
    editshareInstanceURL="" # https://editshare.example.com
    appname="EditShare Connect"
    archiveName="Install EditShare Connect vLatest.pkg"
    downloadURL=$(curl -s ${editshareInstanceURL}/software.html | grep -o 'href="[^"]*Install EditShare Connect.*\.pkg"' | grep -o '".*"' | sed 's/"//g; s/ /%20/g')
    appNewVersion=$(curl -s ${editshareInstanceURL}/software.html | grep -o '<span class="highlight">[^<]*' | sed 's/<span class="highlight">//')
    expectedTeamID="URJUZJ3GCG"
    ;;