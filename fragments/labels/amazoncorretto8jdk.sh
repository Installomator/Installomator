amazoncorretto8jdk)
name="Amazon Corretto 8 JDK"
type="pkg"
	downloadURL="https://corretto.aws/downloads/latest/amazon-corretto-8-x64-macos-jdk.pkg"
	appNewVersion=$(curl -s https://raw.githubusercontent.com/corretto/corretto-8/develop/CHANGELOG.md | grep "## Corretto version" | head -n 1 | awk '{ print $4; exit}')
expectedTeamID="94KV3E626L"
;;
