onyx)
    name="OnyX"
    type="dmg"
    osVersion=$( sw_vers -productVersion | cut -f1 -d'.' )
    webContent=$(curl -fs https://www.titanium-software.fr/en/onyx.html)
    downloadURL="https://www.titanium-software.fr/download/$osVersion/OnyX.dmg"
    appNewVersion=$(echo "$webContent" | grep -Eo "OnyX [0-9]+\.[0-9]+\.[0-9]+ for macOS [A-Za-z ]+ ${osVersion}[^0-9]" | grep -v "beta" | head -1 | awk '{print $2}')
    versionKey="CFBundleShortVersionString"
    expectedTeamID="T49MRBL8UL"
    ;;
