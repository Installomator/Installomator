boxdrive_free)
    get_http_code() {
      /usr/bin/curl -sI -o /dev/null -w '%{http_code}' "$1"
    }
    find_latest_autoupdate_feed() {
      local base="https://cdn07.boxcdn.net/Autoupdate"
      local n=6          # start where "today" is
      local max=20       # safety cap so we never loop forever
      local code
      while (( n <= max )); do
        code=$(get_http_code "${base}${n}.json")
        if [[ "$code" == "200" ]]; then
          ((n++))
        else
          # first non-200 means the previous one was the last good feed
          echo $((n-1))
          return 0
        fi
      done
      # if we hit the cap, just return the cap (or you can error)
      echo "$max"
    }
    name="Box"
    type="pkg"
    latestN=$(find_latest_autoupdate_feed)
    updateURL="https://cdn07.boxcdn.net/Autoupdate${latestN}.json"
    updateFeedData=$(/usr/bin/curl -fsL  "${updateURL}")
    updateFeedVersion="free"
    updateFeedVersion=$(getJSONValue "${updateFeedData}" "mac.${updateFeedVersion}")
    appNewVersion=$(getJSONValue "${updateFeedVersion}" "version")
    downloadURL=$(getJSONValue "${updateFeedVersion}" '["download-url"]')
    expectedTeamID="M683GB7CPW"
    ;;
