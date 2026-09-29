cleanshotx)
    name="CleanShot X"
    type="dmg"
    pageContent=$(curl -fsL "https://cleanshot.com/changelog")
    appNewVersion=$(echo "$pageContent" | perl -0ne 'print $1 if /class="number"[^>]*>(\d+(?:\.\d+)+)</i' | head -n 1)
    downloadURL="https://updates.getcleanshot.com/v3/CleanShot-X-${appNewVersion}.dmg"
    expectedTeamID="AFJU4P8ZV4"
    ;;
