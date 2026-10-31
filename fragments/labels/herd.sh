herd)
    name="Herd"
    type="dmg"
    appNewVersion=$(curl -fsL "https://herd.laravel.com/api/versions" | xpath 'string((//item)[1]/*[local-name()="shortVersionString"])' 2>/dev/null)
    downloadURL="https://download.herdphp.com/app_versions/Herd_${appNewVersion}.dmg"
    expectedTeamID="8Z259RPWAC"
    ;;
