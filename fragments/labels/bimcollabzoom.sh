bimcollabzoom)
    name="BIMcollab Zoom"
    type="pkgInDmg"
    downloadURL="https://bimcollab.com/download/ZOOM/MAC"
    appNewVersion=$(curl -fs "https://helpcenter.bimcollab.com/portal/de/kb/articles/downloads-de" | grep -o '<div>Build[^<]*</div>' | awk -F 'Build' '{print $2}' | awk -F '<' '{print $1}' | sed 's/&nbsp;&nbsp;//' | xargs)
    expectedTeamID="Y6ZY6GR8Y3" 
    ;;
