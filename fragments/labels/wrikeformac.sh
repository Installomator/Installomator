wrikeformac)
#Il faut chercher une solution pour DL la version ARM
    name="Wrike for Mac"
    type="dmg"
    appNewVersion="4.0.6"
    if [[ $(arch) == i386 ]]; then
        #downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.latest.dmg"      # valide pour arch i386
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.v${appNewVersion}.dmg"      # pour la coherence avec silicon, on hardcode le numéro de vesrion
    elif [[ $(arch) == arm64 ]]; then
        #downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.latest.dmg"  # ne marche pas avec latest, il faut obligatoirement un numéro de version précis
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.v${appNewVersion}.dmg"
    fi
    expectedTeamID="BD3YL53XT4"
    ;;
