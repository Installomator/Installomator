techsmithaudiate)
	name="TechSmith Audiate"
	type="dmg"
	feedURL="https://cdn-audiate.cloud.techsmith.com/audiate/latest-mac.yml"
	baseURL="https://cdn-audiate.cloud.techsmith.com/audiate/"
	appNewVersion="$(curl -fsL "$feedURL" | awk -F': ' '/^version: /{print $2}')"
	downloadURL="${baseURL}$(curl -fsL "$feedURL" | awk '/universal.*\.dmg/{print $3}')"
	appName="Audiate.app"
	expectedTeamID="7TQL462TU8"
	;;
