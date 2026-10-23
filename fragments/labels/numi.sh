numi)
    name="Numi"
    type="dmg"
    downloadURL="https://s1.numi.app/download"
    appNewVersion="$(curl -fs https://github.com/nikolaeu/numi/tags | grep -Eo 'mac-[0-9]+(\.[0-9]+)*' | sort -V | tail -n 1 | sed 's/^mac-//')"
    expectedTeamID="4BT8G3UCSZ"
    ;;
