acorn)
    name="Acorn"
    type="zip"
    downloadURL="https://flyingmeat.com/download/Acorn.zip"
    appNewVersion="$(curl -sL https://flyingmeat.com/acorn/releasenotes.html | grep -i 'class="releaseTitleT"' | head -n1 | sed -n 's:.*<div\(.*\)>\(.*\)</div>.*:\2:p' | awk '{print $NF}')"
    expectedTeamID="WZCN9HJ4VP"
    ;;
