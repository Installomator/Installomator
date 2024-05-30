beyondidentity)
    name="Beyond Identity"
    type="pkg"
    downloadURL="https://downloads.byndid.com/pkg/BeyondIdentity-latest.pkg"
    appNewVersion=$(curl -I https://downloads.byndid.com/dmg/BeyondIdentityInstaller-latest.dmg | grep -oE 'filename="[^"]+"' | sed 's/filename="//;s/"//' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
    expectedTeamID="BZA6SZ8XVQ"
    ;;
