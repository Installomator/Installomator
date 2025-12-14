radiosilence)
    name="Radio Silence"
    type="pkg"
    packageID="com.radiosilenceapp.client"
	downloadURL=$(curl -fsSL -A "Mozilla/5.0" "https://radiosilenceapp.com/download" | grep -m1 'class="download-button"' | sed -nE 's#.*href="([^"]+)".*#https://radiosilenceapp.com\1#p')
	appNewVersion=$(curl -fsSL -A "Mozilla/5.0" "https://radiosilenceapp.com/download" | sed -nE 's/.*<p class="guarantee">Version ([0-9.]+),.*/\1/p' | head -n1)
	expectedTeamID="6JQLCT6DRB"
    ;;
