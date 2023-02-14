relatel)
    name="Relatel"
    type="dmg"
    downloadURL="https://cdn.rela.tel/www/public/junotron/Relatel.dmg"
    appNewVersion="$(curl -fs "https://cdn.firmafon.dk/www/public/junotron/latest-mac.yml" | grep -i "version" | cut -w -f2)"
    expectedTeamID="B9358QF55B"
    ;;
