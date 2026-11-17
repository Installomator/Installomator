maxcycling74)
	# Max from Cycling '74 is a visual programming language for music and multimedia
    name="Max"
    type="dmg"
    downloadURL=$(curl -fs curl -fs https://cycling74.com/downloads | xmllint --html --format - 2>/dev/null | grep -o '<a[^>]*href="[^"]*Max[0-9.]*_.*\.dmg"[^>]*>' | sed -n 's/.*href="\([^"]*\)".*/\1/p')
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*Max([0-9]+)_.*\.dmg/\1/; s/^([0-9])([0-9]{1})([0-9]?)/\1.\2.\3/')
    expectedTeamID="GBXXCFCVW5"
    ;;
