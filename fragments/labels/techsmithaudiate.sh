techsmithaudiate)
	name="TechSmith Audiate"
	type="zip"
	feedURL="https://cdn-audiate.cloud.techsmith.com/audiate/latest-mac.yml"
	baseURL="https://cdn-audiate.cloud.techsmith.com/audiate/"
	appNewVersion="$(curl -fsL "$feedURL" | awk -F': ' '/^version: /{print $2}')"
	downloadURL="${baseURL}$(curl -fsL "$feedURL" | awk -F': ' '/^path: /{print $2}')"
	appName="Audiate.app"
	expectedTeamID="7TQL462TU8"
	;;
