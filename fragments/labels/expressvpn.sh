expressvpn)
    name="ExpressVPN"
    type="pkg"
    downloadURL="https://www.expressvpn.com/clients/latest/mac"
    appNewVersion="$(curl -fsIL "https://www.expressvpn.com/clients/latest/mac" | grep -i "^location:" | sed 's/.*expressvpn_mac_//i; s/_release\.pkg.*//; s/\.[0-9]*$//')"
    expectedTeamID="TC292Y5427"
    ;;
