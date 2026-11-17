checkpointsase|\
perimeter81|\
harmonysase)
    name="Checkpoint SASE"
    type="pkg"    
    downloadsPageURL="https://sc1.checkpoint.com/documents/Infinity_Portal/WebAdminGuides/EN/SASE-Admin-Guide/SASE_Security/Topics/download/introduction_to_the_downloads_page.html"
    downloadURL=$(curl -fsSL "$downloadsPageURL" | grep -oE 'https://static\.perimeter81\.com/agents/mac/[^"]*\.pkg' | head -1)
    versionFull=$(curl -fsIL "$downloadURL" | tr -d '\r' | grep -i '^x-amz-meta-version:' | sed -E 's/^[Xx]-[Aa]mz-[Mm]eta-[Vv]ersion: *//')
    appNewVersion=$(echo "$versionFull" | sed -E 's/^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+$/\1/')
    expectedTeamID="924635PD62"
    ;;
