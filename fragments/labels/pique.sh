pique)
    name="Pique"
    type="pkg"
    packageID="io.macadmins.Pique"
    downloadURL=$(downloadURLFromGit macadmins pique )
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -E 's#.*\/releases\/download\/([^/]+)\/.*#\1#; s/^v//')
    expectedTeamID="T4SK8ZXCXG"
    ;;
