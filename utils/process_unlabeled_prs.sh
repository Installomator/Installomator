#!/bin/zsh

# get a list of PR's with no labels

# Variables
LIVE_RUN=0 # set to 1 to apply changes to PR's
max_prs=5 # max number of PR's to process
max_dl_size=10 # in MB (unused but could be used to download and check team ID)

# check requirements
# we need gh and probably also jq
for cmd in gh jq; do
    if ! which $cmd >/dev/null; then
        echo "$cmd not installed - exiting"
        exit 1
    fi
done

# load functions from Installomator
functionsPath="fragments/functions.sh"
source "${functionsPath}"

assign_gh_label() {
    local PR_NUMBER=$1
    local LABEL_NAME=$2
    # assign the label to the PR
    if [[ $LIVE_RUN -eq 1 ]]; then
        if ! gh label list | grep -q $LABEL_NAME; then
            # create the label if it doesn't exist
            gh label create $LABEL_NAME -d "Label for $LABEL_NAME"
         fi
        gh pr edit $PR_NUMBER --add-label $LABEL_NAME
    fi
    echo "Added label \"$LABEL_NAME\" to PR $PR_NUMBER"
}

add_gh_comment() {
    local PR_NUMBER=$1
    local COMMENT=$2
    # add a comment to the PR
    if [[ $LIVE_RUN -eq 1 ]]; then
        gh pr comment $PR_NUMBER -b "$COMMENT"
    fi
    echo "Added comment to PR $PR_NUMBER"
    echo "$COMMENT"
}

pr_raw_content() {
    local PR_NUMBER=$1
    local FILE_PATH=$2
    # Get the PR branch name
    gh pr checkout $PR_NUMBER > /dev/null
    if [[ -e $FILE_PATH ]]; then
        RAW_CONTENT=$(cat $FILE_PATH)
    else
        RAW_CONTENT="NO FILE"
    fi
    echo $RAW_CONTENT
}

label_name_for_content() {
    RAW_CONTENT="$1"
    # get the first line of the file and strip trailing characters. this will be the label name
    LABEL_NAME=$(echo $RAW_CONTENT | head -n 1 | head -n 1 | sed 's/[\|\\)]//g')
    echo $LABEL_NAME
}

jsonValue() {
    local value=$1
    local json=$2
    jq -j 'select(.'$value' != null) | .'$value'' <<< $json
}   

echo "Processing $max_prs PR's with no labels"
echo ""

open_prs=( $(gh pr list --search "no:label" -L $max_prs | awk '{print $1}') )

if [[ ${#open_prs[@]} -eq 0 ]]; then
    echo "No PR's with no labels"
    exit 0
fi

for pr_num in $open_prs; do
    echo "***** Start PR $pr_num *****"
    git checkout main 2>&1 > /dev/null

    changed_files=( $(gh pr diff $pr_num --name-only) )
    echo "Files changed: ${#changed_files[@]}"
    echo "Files: \n ${changed_files[@]}"
    # check if there is only one file changed
    #if [[ ${#changed_files[@]} -eq 1 ]]; then
    for filename in $changed_files; do
        # changed file should be in the format "fragments/labels/<somename>.sh"
        if [[ $filename =~ "fragments/labels/" ]]; then
            pr_comment=""
            checks_passed=0
            checks_failed=0
            content=$(pr_raw_content "$pr_num" "$filename")
            if [[ $content == "NO FILE" ]]; then
                echo "Failed to get content for $filename"
                assign_gh_label $pr_num "invalid"
                continue
            fi
            #echo "Content: \n $content"
            #exit 0
            label=$(label_name_for_content "$content")
            echo "** PR Info:"
            echo "├ Label name: $label"
            echo "├ PR: $pr_num"
            echo "└ File: $filename"

            # Process the fragment in a case block which should match the label
            #echo "Processing label $label ..."
            caseStatement="
            case $label in
                $content
                *)
                    echo \"$label didn't match anything in the case block - weird.\"
                ;;
            esac
            "
            eval $caseStatement
            #echo "finished processing label $label"

            pr_comment+=$(echo "** Label info:")$'\n'
            # process label info
            if [[ -n $name ]]; then
                pr_comment+=$(echo "├ Name: ✅ $name")$'\n'
                pr_comment+="├ Type: "; [[ -z $type ]] && { pr_comment+=" ❌ no type"$'\n'; ((checks_failed++)); } || { pr_comment+=" ✅ $type"$'\n'; ((checks_passed++)); }
                pr_comment+="├ Expected Team: "; [[ -z $expectedTeamID ]] && { pr_comment+=" ❌ no team ID"$'\n'; ((checks_failed++)); } || { pr_comment+=" ✅ $expectedTeamID"$'\n'; ((checks_passed++)); }
                pr_comment+="├ App New Version: "; [[ -z $appNewVersion ]] && { pr_comment+=" ❌ no version info"$'\n'; ((checks_failed++)); } || { pr_comment+=" ✅ $appNewVersion"$'\n'; ((checks_passed++)); }
                
                if [[ -n $downloadURL ]]; then
                    pr_comment+=$(echo "└ Download URL: $downloadURL")$'\n'
                    # check to see if the url is reachable
                    jsonData=$(curl -sI -w '%{header_json}\n%{json}' -o /dev/null $downloadURL)
                    http_code=$(jsonValue "http_code" "$jsonData")
                    if [[ $http_code -eq 200 ]]; then
                        pr_comment+=$(echo "  ├ ✅ URL is reachable")$'\n'
                        # get download size in megabytes
                        downloadSize=$(jsonValue '"content-length"[0]' "$jsonData" | awk '{printf "%.1f", $1 / (1024 * 1024)}')
                        if [[ $downloadSize -gt 0 ]]; then
                            pr_comment+=$(echo "  └ ✅ Download Size: ${downloadSize} MB")$'\n'
                        else
                            pr_comment+=$(echo "  └ ⚠️  Download Size: could not determine download size")$'\n'
                        fi
                    else
                        pr_comment+=$(echo "  └ ❌ URL is not reachable - error $http_code")$'\n'
                        checks_failed=$((checks_failed+1))
                    fi
                else
                    pr_comment+=$(echo "└ Download URL: ❌ no download URL")$'\n'
                    checks_failed=$((checks_failed+1))
                fi
            else
                pr_comment+=$(echo "❌ Error fetching label info")$'\n'
                checks_failed=$((checks_failed+1))
            fi
            # unset variables so they are not carried over to the next iteration
            unset appNewVersion
            unset name
            unset downloadURL
            unset type
            unset expectedTeamID

            if [[ $checks_failed -eq 0 ]]; then
                pr_comment+=$(echo "✅ All checks passed")$'\n'
            else
                pr_comment+=$(echo "** WARNING: Some checks failed")$'\n'
                pr_comment+=$(echo "✅ $checks_passed checks passed")$'\n'
                pr_comment+=$(echo "❌ $checks_failed checks failed")$'\n'
                pr_comment+=$(echo "❌ Please review the PR and make necessary changes")$'\n'
                assign_gh_label $pr_num "checks_failed"
            fi

            echo "switching back to main branch"
            git checkout main 2>&1 > /dev/null

            # dummy run - explain what else we would do
            if [[ $LIVE_RUN -eq 0 ]]; then
                echo "ℹ️  DEBUG: The following steps will take place if this was not a dummy run"
                echo "ℹ️  Set the label on the PR $pr_num to 'application'"
                echo "ℹ️  add comment to PR $pr_num with processing information"
            fi
            assign_gh_label $pr_num "application"
            add_gh_comment $pr_num "🤖 Processing robot:\n${pr_comment}"
        else
            echo "⚠️ File $filename in PR $pr_num does not look like a label - skipping"
            assign_gh_label $pr_num "improvement"
        fi
    done

    echo "***** End PR $pr_num *****"
    echo ""
done

echo "Done"
exit 0
