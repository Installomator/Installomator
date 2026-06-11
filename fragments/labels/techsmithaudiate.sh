techsmithaudiate)
	name="TechSmith Audiate"
	type="dmg"
	baseURL="https://cdn-audiate.cloud.techsmith.com/audiate"
	feedURL="$(curl -fsL "$baseURL/latest-mac.yml")"
	appNewVersion="$(echo "$feedURL" | awk -F': ' '/^version: /{print $2}')"
	downloadURL="${baseURL}/$(echo "$feedURL" | awk '/universal.*\.dmg/{print $3}')"
	appName="Audiate.app"
	expectedTeamID="7TQL462TU8"
	;;
