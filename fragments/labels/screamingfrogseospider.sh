screamingfrogseospider)
    name="Screaming Frog SEO Spider"
    type="dmg"
    
    # Extraire les URLs de téléchargement
    apple_silicon_url=$(curl -s https://www.screamingfrog.co.uk/seo-spider/release-history/ | grep -o 'href="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-[0-9.]*-aarch64.dmg"' | cut -d'"' -f2)
    intel_url=$(curl -s https://www.screamingfrog.co.uk/seo-spider/release-history/ | grep -o 'href="https://download.screamingfrog.co.uk/products/seo-spider/ScreamingFrogSEOSpider-[0-9.]*-x86_64.dmg"' | cut -d'"' -f2)
    
    # Extraire la version du nom de fichier
    version=$(echo "$apple_silicon_url" | grep -o '[0-9.]*-aarch64' | cut -d'-' -f1)
    
    # Déterminer l'architecture et sélectionner l'URL appropriée
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="$apple_silicon_url"
    else
        downloadURL="$intel_url"
    fi
    
    appNewVersion="$version"
    expectedTeamID="CAHEVC3HZC"
    
    # Vérification du téléchargement
    if [ -z "$downloadURL" ]; then
        echo "Erreur: Impossible de trouver l'URL de téléchargement pour Screaming Frog SEO Spider"
        exit 1
    fi
    
    # Affichage des informations pour vérification
    echo "Name: $name"
    echo "Version: $appNewVersion"
    echo "Download URL: $downloadURL"
    echo "Expected Team ID: $expectedTeamID"
;;