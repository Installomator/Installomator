vivi)
    name="Vivi"
    type="pkg"
    packageID="au.com.viviaustralia.mac"
    appNewVersion=$(curl -fsIL https://api.vivi.io/mac | grep -i "^location" | awk "{print $2}" | sed -E "s/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g")
    downloadURL=$(curl -sf https://api.vivi.io/mac | grep -o '<a .*href=.*>' | sed -e 's/<a /\n<a /g' | sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d')
    pkgName=$(echo Vivi-"$appNewVersion".pkg)
    expectedTeamID="3NRCUJ8TJC"
    ;;
