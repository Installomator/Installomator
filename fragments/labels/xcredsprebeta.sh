xcredsprebeta)
    name="XCreds"
    type="pkg"
    xcredsPrebetaVersion="${xcredsPrebetaVersion:-}"
    if [[ -n "$xcredsPrebetaVersion" && ! "$xcredsPrebetaVersion" =~ ^[0-9]+([.][0-9]+)*$ ]]; then
        cleanupAndExit 14 "xcredsPrebetaVersion must be numeric, for example 5.10" ERROR
    fi
    prebetaReleaseJSON="$(curl -fsSL --retry 3 --retry-delay 2 --retry-all-errors --connect-timeout 15 -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' -H 'User-Agent: Installomator' 'https://api.github.com/repos/twocanoes/xcreds/releases/tags/prebeta')" || cleanupAndExit 14 "Could not retrieve XCreds prebeta release metadata" ERROR
    prebetaAssetsURL="$(getJSONValue "$prebetaReleaseJSON" "assets_url")"
    prebetaHighestBuild=0
    prebetaPage=1
    while :; do
        prebetaAssetsJSON="$(curl -fsL --retry 3 --retry-delay 2 --retry-all-errors --connect-timeout 15 -H 'Accept: application/vnd.github+json' -H 'X-GitHub-Api-Version: 2022-11-28' -H 'User-Agent: Installomator' "${prebetaAssetsURL}?per_page=100&page=${prebetaPage}")" || cleanupAndExit 14 "Could not retrieve XCreds prebeta assets" ERROR
        prebetaAssetCount="$(getJSONValue "$prebetaAssetsJSON" "length")"
        [[ "$prebetaAssetCount" == "0" ]] && break
        [[ "$prebetaAssetCount" == <-> ]] || cleanupAndExit 14 "Invalid XCreds prebeta asset response" ERROR
        prebetaCandidate="$(getJSONValue "$prebetaAssetsJSON" "filter(asset => /^PreBeta-XCreds_Build-[0-9]+_Version-[0-9.]+[.]pkg$/.test(asset.name) && (\"$xcredsPrebetaVersion\" === \"\" || asset.name.endsWith(\"_Version-$xcredsPrebetaVersion.pkg\"))).sort((a, b) => Number(a.name.match(/Build-([0-9]+)/)[1]) - Number(b.name.match(/Build-([0-9]+)/)[1])).pop()")"
        if [[ -n "$prebetaCandidate" && "$prebetaCandidate" != "undefined" ]]; then
            prebetaName="$(getJSONValue "$prebetaCandidate" "name")"
            prebetaBuild="${prebetaName#PreBeta-XCreds_Build-}"
            prebetaBuild="${prebetaBuild%%_*}"
            if [[ "$prebetaBuild" == <-> && "$prebetaBuild" -gt "$prebetaHighestBuild" ]]; then
                prebetaHighestBuild="$prebetaBuild"
                downloadURL="$(getJSONValue "$prebetaCandidate" "browser_download_url")"
                appNewVersion="${prebetaName##*_Version-}"
                appNewVersion="${appNewVersion%.pkg}"
            fi
        fi
        ((prebetaPage++))
    done
    [[ -n "$downloadURL" && -n "$appNewVersion" ]] || cleanupAndExit 14 "Could not identify an XCreds prebeta package" ERROR
    expectedTeamID="UXP6YEHSPW"
    blockingProcesses=( NONE )
    ;;
