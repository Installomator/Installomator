polylens)
    name="Poly Lens"
    type="dmg"
    polyDetails="$(curl -fs 'https://api.silica-prod01.io.lens.poly.com/graphql' -X POST -H 'Content-Type: application/json' --data-raw '{"operationName":"LensSoftwareUpdateAvailable","variables":{"productId":"lens-desktop-mac","releaseChannel":null},"query":"query LensSoftwareUpdateAvailable($productId: ID!, $releaseChannel: String) {availableProductSoftwareByPid(pid: $productId, releaseChannel: $releaseChannel) {version productBuild {build archiveUrl __typename} __typename}}"}')"
    appNewVersion=$(getJSONValue "$polyDetails" "data.availableProductSoftwareByPid.version")
    downloadURL=$(getJSONValue "$polyDetails" "data.availableProductSoftwareByPid.productBuild.archiveUrl")
    expectedTeamID="SKWK2Q7JJV"
    ;;
