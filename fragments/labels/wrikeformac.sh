wrikeformac)
    name="Wrike for Mac"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        #downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.latest.dmg"
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp.v.4.0.6.dmg"   # pour la coherence avec silicon
    elif [[ $(arch) == arm64 ]]; then
        #downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.latest.dmg"  # ne marche pas avec latest, il faut obligatoirement un numéro de version 
        downloadURL="https://dl.wrike.com/download/WrikeDesktopApp_ARM.v4.0.6.dmg"
    fi
    appNewVersion="4.0.6"
    expectedTeamID="BD3YL53XT4"
    ;;
