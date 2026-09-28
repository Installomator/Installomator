perimeter81|checkpointsase|harmonysase)
    name="Checkpoint SASE"
    type="pkg"    
    releaseNotesURL="https://sc1.checkpoint.com/documents/Infinity_Portal/WebAdminGuides/EN/SASE-Admin-Guide/SASE_Security/Topics/macos/macos_agent_release_notes.html"
    versionFull=$(curl -fsSL "$releaseNotesURL" | sed -nE 's/.*<h2><a name="([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' | head -1)
    appNewVersion=$(echo "$versionFull" | sed -E 's/^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+$/\1/')    
    downloadURL="https://static.perimeter81.com/agents/mac/Checkpoint_SASE_${versionFull}.pkg"
    expectedTeamID="924635PD62"
    ;;