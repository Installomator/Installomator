cricutdesignspace)
    name="Cricut Design Space"
    type="dmg"
    appNewVersion=$(curl -fsL https://s3-us-west-2.amazonaws.com/staticcontent.cricut.com/a/software/osx-native/latest.json | sed -n 's/^.*"rolloutVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*$/\1/p')
    downloadURL=https://staticcontent.cricut.com/a/software/osx-native/CricutDesignSpace-Install-v${appNewVersion}.dmg
    expectedTeamID="25627ZFVT7"
    ;;
