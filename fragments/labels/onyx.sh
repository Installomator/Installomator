onyx)
    name="OnyX"
    type="dmg"
    osVersion=$( sw_vers -productVersion | cut -f1 -d'.' )
    downloadURL="https://www.titanium-software.fr/download/$osVersion/OnyX.dmg"
    appNewVersion=$( curl -fs https://www.titanium-software.fr/en/onyx.html | grep -Eo "OnyX [0-9]+\.[0-9]+\.[0-9]+ for macOS [^ ]+ $osVersion" | awk '{print $2}' | sort -Vr | head -1 )
    versionKey="CFBundleShortVersionString"
    expectedTeamID="T49MRBL8UL"
    ;;
