microsoftwindowsappbeta)
    name="Windows App Beta"
    type="zip"
    appCenterURL=$(curl -fs -o /dev/null -w '%{redirect_url}' "https://aka.ms/rdmacbeta" | sed -nE 's#^https://install\.appcenter\.ms/orgs/([^/]+)/apps/([^/]+)/distribution_groups/([^/?]+).*#https://install.appcenter.ms/api/v0.1/apps/\1/\2/distribution_groups/\3#p')
    appCenterRelease=$(curl -fsL "${appCenterURL}/releases/$(curl -fsL "${appCenterURL}/public_releases" | plutil -extract 0.id raw -o - - 2>/dev/null)")
    downloadURL=$(plutil -extract download_url raw -o - - <<< "$appCenterRelease" 2>/dev/null)
    appNewVersion=$(plutil -extract version raw -o - - <<< "$appCenterRelease" 2>/dev/null)
    versionKey="CFBundleVersion"
    expectedTeamID="UBF8T346G9"
    ;;
