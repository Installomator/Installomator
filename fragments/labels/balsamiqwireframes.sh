balsamiqwireframes)
    # credit: Gabe Marchan (gabemarchan.com - @darklink87)
    name="Balsamiq Wireframes"
    type="dmg"
    downloadURL=https://builds.balsamiq.com/bwd/$(curl -fs "https://builds.balsamiq.com" | awk -F "<Key>bwd/" "/dmg/ {print \$3}" | awk -F "</Key>" "{print \$1}" | sed "s/ /%20/g")
    expectedTeamID="3DPKD72KQ7"
    ;;
