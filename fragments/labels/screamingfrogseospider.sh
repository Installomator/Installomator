screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    json_url="https://formulae.brew.sh/api/cask/screaming-frog-seo-spider.json"

    # Télécharger les données JSON
    json_data=$(curl -s "$json_url")

    # Extraire la version
    version=$(echo "$json_data" | awk -F '"' '/"version":/ {print $4}')

    # Déterminer l'architecture et sélectionner le bon URL de téléchargement
    if [[ $(arch) == i386 || $(arch) == "x86_64" ]]; then
        platform="x86_64"
    elif [[ $(arch) == "arm64" ]]; then
        platform="aarch64"
    fi

    # Construire l'URL de téléchargement
    downloadURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-${version}-${platform}.dmg"

    # Vérifier la version récupérée
    appNewVersion=${version}

    # Team ID attendu pour l'authentification
    expectedTeamID="CAHEVC3HZC"

    # Affichage des informations pour vérification
    echo "Name: $name"
    echo "Version: $appNewVersion"
    echo "Download URL: $downloadURL"
    echo "Expected Team ID: $expectedTeamID"
    ;;