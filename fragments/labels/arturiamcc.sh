arturiamcc)
    name="MIDI Control Center"
    type="pkg"
    pkgName=$(curl -fsL "https://www.arturia.com/support/downloads-manuals/product/mccu" | grep -oE 'MIDI_Control_Center__[0-9_]+\.pkg' | sort -u -t_ -k5,5n -k6,6n -k7,7n -k8,8n | tail -1)
    downloadURL="https://www.arturia.com/api/download/products/mccu/soft/${pkgName}"
    appNewVersion=$(echo "$pkgName" | sed -E 's/.*__([0-9_]+)\.pkg/\1/; s/_/./g')
    expectedTeamID="T53ZHSF36C"
    ;;
