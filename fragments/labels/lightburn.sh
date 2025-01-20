lightburn)
    name="LightBurn"
    type="dmg"
    appNewVersion=$(curl -s https://release.lightburnsoftware.com/LightBurn/Release/ | grep -o 'LightBurn-v[0-9]\+\.[0-9]\+\.[0-9]\+' | sed 's/LightBurn-v//g' | sort -V | tail -1)
   	downloadURL="https://files.release.lightburnsoftware.com/LightBurn/Release/LightBurn-v$appNewVersion/LightBurn.V$appNewVersion.dmg"
 	expectedTeamID="UWZQ3LL82C"
    versionKey="CFBundleShortVersionString"
    ;;
