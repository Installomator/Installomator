arturiasoftwarecenter)
    name="Arturia Software Center"
    type="pkg"
    packageID="com.Arturia.ArturiaSoftwareCenter.resources"
    versionKey="CFBundleVersion"
 	onlineVersion=$(getJSONValue "$(curl -fsL 'https://www.arturia.com/api/resources?slugs=asc&types=soft')" '[0].version')
	downloadVersion=$(echo "${onlineVersion}" | tr '.' '_')
 	appNewVersion=$(echo "${onlineVersion}" | cut -d. -f1-3)
	downloadURL="https://dl.arturia.net/products/asc/soft/Arturia_Software_Center__${downloadVersion}.pkg"
    expectedTeamID="T53ZHSF36C"
    ;;