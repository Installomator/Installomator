arturiasoftwarecenter)
    name="Arturia Software Center"
    type="pkg"
    pkgName=$(curl -fsL "https://www.arturia.com/support/downloads-manuals/product/asc" | grep -oE 'Arturia_Software_Center__[0-9_]+\.pkg' | sort -u -t_ -k5,5n -k6,6n -k7,7n -k8,8n | tail -1)
    downloadURL="https://www.arturia.com/api/download/products/asc/soft/${pkgName}"
    appNewVersion=$(echo "$pkgName" | sed -E 's/.*__([0-9_]+)\.pkg/\1/; s/_/./g')
    versionKey="CFBundleVersion"
    expectedTeamID="T53ZHSF36C"
    ;;
