screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    
    # Extraire la version de la page d'historique des versions
    version=$(curl -s https://www.screamingfrog.co.uk/seo-spider/release-history/ | grep -o '<td style="border: 1px solid; padding: 10px;"><a href="/seo-spider-[0-9]*/#[0-9.]*">[0-9.]*</a></td>' | head -1 | grep -o '[0-9.]*</a>' | cut -d'<' -f1)
    
    # Construire les URLs de téléchargement
    baseURL="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-${version}"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="${baseURL}-aarch64.dmg"
    else
        downloadURL="${baseURL}-x86_64.dmg"
    fi
    
    appNewVersion="${version}"
    expectedTeamID="CAHEVC3HZC"
    
    # Vérification
    if [ -z "$version" ] || [ -z "$downloadURL" ]; then
        echo "Erreur: Impossible de déterminer la version ou l'URL de téléchargement pour Screaming Frog SEO Spider"
        exit 1
    fi
    
    # Affichage des informations pour vérification
    echo "Name: $name"
    echo "Version: $appNewVersion"
    echo "Download URL: $downloadURL"
    echo "Expected Team ID: $expectedTeamID"
;;