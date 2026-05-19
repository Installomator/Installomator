geneiousprime)
    name="Geneious Prime"
    type="dmg"
    webSite="https://www.geneious.com"
    downloadURL="https:$( curl -s "$webSite$( curl -s "$webSite/updates" | tr '<>{},:[]' "\n" | grep -E -m1 "^\"\/updates\/.*" | tr -d '"' )" | tr '<>{},:[]"' "\n" | grep -E -m1 ".*release.*dmg" )"
    appNewVersion="$( echo "$downloadURL" | tr '_' '.' | cut -d '.' -f 6-8 )"
    expectedTeamID="3BTDDQD3L6"
    ;;
