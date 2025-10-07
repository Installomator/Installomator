camtasia2023)
    name="Camtasia 2023"
    type="dmg"
    apiResult="$(curl -fsL "https://www.techsmith.com/api/v/1/products/getversioninfo/2080")"
    downloadURL="https://download.techsmith.com$(getJSONValue "$apiResult" "PrimaryDownloadInformation.RelativePath")$(getJSONValue "$apiResult" "PrimaryDownloadInformation.Name")"
    appNewVersion="20$(getJSONValue "$apiResult" "PrimaryDownloadInformation.Major").$(getJSONValue "$apiResult" "PrimaryDownloadInformation.Minor").$(getJSONValue "$apiResult" "PrimaryDownloadInformation.Maintenance")"
    expectedTeamID="7TQL462TU8"
    ;;
