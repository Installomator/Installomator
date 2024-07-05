protonpass)
  name="Proton Pass"
  type="dmg"
  downloadURL=$(getJSONValue "$(curl -fsL 'https://proton.me/download/PassDesktop/darwin/universal/version.json')" 'Releases[0].File[0].Url')
  appNewVersion=$( grep -oE '\d+\.[0-9.]*\d' <<< $downloadURL )
  expectedTeamID="2SB5Z68H26"
  ;;