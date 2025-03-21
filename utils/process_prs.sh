#!/bin/zsh

# get a list of PR's with no labels

# Variables
LIVE_RUN=0 # set to 1 to apply changes to PR's
TEST_PR=0 # set to 1 to test the PR instead of validating it
MAX_PR_COUNT=5 # max number of PR's to process
MAX_DL_SIZE=50 # in MB
IGNORE_MISSING_DOWNLOAD_SIZE=0
#SORT_ORDER="created-desc" # newest PR's first
SORT_ORDER="created-asc" # oldest PR's first
SEARCH_STRING="no:label sort:${SORT_ORDER}"
FROM_PR_NUM=0
PR_NUM=0

printUsage() {
    echo "Usage: process_prs.sh"
    echo "Options:"
    echo "  --live-run                    - will apply changes to PR's."
    echo "  -t, --test-pr                 - perform a full test of PR's instead of validating it. default is to validate only"
    echo "                                  testing will imply a search for PR's with the label 'application' and 'validated'"
    echo "                                  if testing is successful, the option to merge the PR will be presented"
    echo "  -d, --max-download-size <num> - max download size in MB when in TEST_PR mode. default is 50"
    echo "  -i, --ignore-missing-download-size - ignore missing download size in TEST_PR mode"
    echo "  -p, --max-pr-count <num>      - max number of PR's to process. default is 5"
    echo "  -s, --search-string <string>  - search string to use for PR's. default is 'no:label sort:created-asc'"
    echo "                                  if test-pr is set, this will be overridden to:"
    echo "                                    'is:pr is:open label:application label:validated -label:\"waiting for response\""
    echo "                                     -label:invalid -label:attention-required -label:incomplete sort:${SORT_ORDER}'"
    echo "                                  uses github search syntax"
    echo "  -o, --sort-order <order>      - sort order for PR's. default is 'created-asc' (oldest first)"
    echo "                                  options are 'created-asc' or 'created-desc'"
    echo "  -f, --from-pr-num <num>       - start processing PR's from this number. default is 0"
    echo "  -n, --pr-num <num>            - process a single PR number"
    echo "  -h, --help                    - display this help"
    exit 0
}

# Loop through named arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --help|-h) printUsage; exit 0;;
        --live-run) LIVE_RUN=1;;
        --test-pr|-t) TEST_PR=1;;
        --max-download-size|-d) MAX_DL_SIZE="$2"; shift ;;
        --ignore-missing-download-size|-i) IGNORE_MISSING_DOWNLOAD_SIZE=1 ;;
        --max-pr-count|-p) MAX_PR_COUNT="$2"; shift ;;
        --search-string|-s) SEARCH_STRING="$2"; shift ;;
        --sort-order|-o) SORT_ORDER="$2"; shift ;;
        --from-pr-num|-f) FROM_PR_NUM="$2"; shift ;;
        --pr-num|-n) PR_NUM="$2"; shift ;;
        *) echo "Unknown argument: $1"; printUsage; exit 1 ;;
    esac
    shift
done

# unlabelled PR's
# SEARCH_STRING="no:label sort:${SORT_ORDER}"
# unprocessed application PR's with no comments
# SEARCH_STRING="is:open is:pr label:application -label:incomplete -label:validated -label:\"waiting for response\" -label:invalid comments:0"
# unprocessed application PR's with comments
# SEARCH_STRING="is:pr is:open in:comments \"Error fetching label info\"" 
if [[ $TEST_PR -eq 1 ]]; then
    SEARCH_STRING="is:pr is:open label:application label:validated -label:\"waiting for response\" -label:invalid -label:attention-required -label:incomplete sort:${SORT_ORDER}"
fi


# check requirements
# we need gh and probably also jq
for cmd in gh jq; do
    if ! which $cmd >/dev/null; then
        echo "$cmd not installed - exiting"
        exit 1
    fi
done

if [[ $LIVE_RUN -eq 0 ]]; then
    echo ""
    echo "** Performing a dry run - no changes will be made **"
    echo ""
fi

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

remove_gh_label() {
    local PR_NUMBER=$1
    local LABEL_NAME=$2
    # remove the label from the PR
    if [[ $LIVE_RUN -eq 1 ]]; then
        gh pr edit $PR_NUMBER --remove-label $LABEL_NAME
    fi
    echo "Removed label \"$LABEL_NAME\" from PR $PR_NUMBER"
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
    if ! gh pr checkout $PR_NUMBER > /dev/null; then
        echo "Failed to checkout PR $PR_NUMBER"
        return 1
    fi
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
    # also split on | in case multiple labels are defined on the same line
    LABEL_NAME=$(echo $RAW_CONTENT | head -n 1 | awk -F "|" '{print $1}' | sed 's/[\|\\)]//g')
    echo $LABEL_NAME
}

jsonValue() {
    local value=$1
    local json=$2
    jq -j 'select(.'$value' != null) | .'$value'' <<< $json
}

perform_pr_test() {
    local pr_num=$1
    local label=$2

    # clean build folder
    if [[ -d build ]]; then
        rm -rf build/*
    fi

    if ! gh pr checkout $pr_num -b "pr/$pr_num"; then
        echo "Failed to checkout PR $pr_num"
        return 1
    fi

    if ! utils/assemble.sh $label; then
        exitcode=$?
        echo "something went wrong, stopping here"
        echo "exit code: $exitcode"
        return 1
    else
        echo
        echo "All good!"
        echo

        if [[ $LIVE_RUN -eq 0 ]]; then
            echo "ℹ️  DEBUG: This is a dry run - no changes will be made"
            return 0
        fi

        read -q query"?Merge into main? (y/n)"

        if [[ $query == 'y' ]]; then
            git checkout main
            if git merge "pr/$pr_num" -m "label: $label, see #$pr_num"; then
                assign_gh_label $pr_num "validated"
                remove_gh_label $pr_num "incomplete"
                git branch -d "pr/$pr_num"
                gh pr comment $pr_num --body 'Thank you!'
            else
                echo "Failed to merge PR $pr_num - aborting"
                git merge --abort
                git checkout main
                return 1
            fi
        fi
    fi
    return 0
}

# print list of all functions  
# print -l ${(ok)functions}

echo "Processing up to $MAX_PR_COUNT PR's with search string: $SEARCH_STRING"
echo ""

if [[ $PR_NUM -gt 0 ]]; then
    echo "Processing PR $PR_NUM"
    open_prs=( $PR_NUM )
else
    open_prs=( $(gh pr list --search "${SEARCH_STRING}" -L $MAX_PR_COUNT | awk '{print $1}') )
fi

if [[ ${#open_prs[@]} -eq 0 ]]; then
    echo "No PR's match the search criteria. Nothing to do 🎉"
    exit 0
fi

skip_count=0
processed_count=0

for pr_num in $open_prs; do
    ((processed_count++))
    echo "***** Processing PR $processed_count of $MAX_PR_COUNT *****"
    echo ""
    echo "***** Start PR $pr_num *****"
    if [[ $pr_num -lt $FROM_PR_NUM ]]; then
        echo "Skipping PR $pr_num"
        ((skip_count++))
        continue
    fi
    git checkout main 2>&1 > /dev/null
    pr_comment=""
    has_app_component=0
    has_non_app_component=0
    changed_files=( $(gh pr diff $pr_num --name-only) )
    echo "Files changed: ${#changed_files[@]}"
    echo "Files: \n ${changed_files[@]}"
    # check if there is only one file changed
    if [[ ${#changed_files[@]} -gt 5 ]]; then
        echo "⚠️ PR $pr_num has more than 5 files changed - skipping"
        ((skip_count++))
        continue
    fi
    for filename in $changed_files; do
        # changed file should be in the format "fragments/labels/<somename>.sh"
        if [[ $filename =~ "fragments/labels/" ]]; then
            assign_gh_label $pr_num "application"
            has_app_component=1
            pr_comment+="🤖 Validation robot 🤖"$'\n'
            pr_comment+=$(echo "File $filename")$'\n'
            checks_passed=0
            checks_failed=0
            content=$(pr_raw_content "$pr_num" "$filename")

            if [[ $content == "NO FILE" ]] || [[ $content =~ "Failed to checkout PR" ]]; then
                echo "Failed to get content for $filename"
                assign_gh_label $pr_num "incomplete"
                checks_failed=$((checks_failed+1))
                ((skip_count++))
                continue
            fi

            label=$(label_name_for_content "$content")
            echo "** PR Info:"
            echo "├ Label name: $label"
            echo "├ PR: $pr_num"
            echo "└ File: $filename"

            # Process the fragment in a case block which should match the label
            # write content to a temp file
            tmpfile=$(mktemp /tmp/labelcontent.XXXXXX)
            #echo "Processing label $label ..."
            caseStatement=$(cat <<EOF
            #source "${functionsPath}"
            #declare -fx xpath 
            case $label in
                $content
                *)
                echo "$label didn't match anything in the case block - weird."
                ;;
            esac
EOF
            )
            echo "$caseStatement" > $tmpfile
            # source the temp file (using this instead of eval)
            source $tmpfile
            cat $tmpfile
            # rempve temp file
            rm $tmpfile
            #echo "finished processing label $label"

            pr_comment+=$(echo "** Label info:")$'\n'

            # check if the file ends with an LF control character
            last_char=$(tail -c 1 "$filename" | od -An -t uC | tr -d '[:space:]')
            if [ "$last_char" != "10" ]; then
                pr_comment+="├ ❌ The file '$filename' does not end with an LF control character. We recommend installing/using an EditorConfig plugin for your editor."$'\n'
                checks_failed=$((checks_failed+1))
            else
                pr_comment+="├ ✅ correct line ending"$'\n'
                checks_passed=$((checks_passed+1))
            fi

            # process label info
            if [[ -n $name ]]; then
                pr_comment+=$(echo "├ ✅ Name: $name")$'\n'; ((checks_passed++))
                pr_comment+="├ "; [[ -z $type ]] && { pr_comment+="❌ "; ((checks_failed++)); } || { pr_comment+="✅ "; ((checks_passed++)); }; pr_comment+="Type: ${type:-Missing}"$'\n' 
                pr_comment+="├ "; [[ -z $expectedTeamID ]] && { pr_comment+="❌ "; ((checks_failed++)); } || { pr_comment+="✅ "; ((checks_passed++)); }; pr_comment+="Expected Team: ${expectedTeamID:-Missing}"$'\n' 
                pr_comment+="├ "; [[ -z $appNewVersion ]] && { pr_comment+="⚠️  "; } || { pr_comment+="✅ "; ((checks_passed++)); }; pr_comment+="App New Version: ${appNewVersion:-Missing}"$'\n' 
                    
                if [[ -n $downloadURL ]]; then
                    pr_comment+=$(echo "└ Download URL: $downloadURL")$'\n'
                    # check to see if the url is reachable
                    jsonData=$(curl -sIL -w '%{header_json}\n%{json}' -o /dev/null "$downloadURL")
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
                    elif [[ $http_code -eq 403 ]]; then
                        pr_comment+="  ├ ⛔️ URL requires authentication"$'\n'
                        checks_failed=$((checks_failed+1))
                    elif [[ $http_code -eq 405 ]]; then
                        pr_comment+="  ├ ⚠️  URL appears to be reachable but does not support HEAD requests"$'\n'
                        pr_comment+="  └ ⚠️  Download Size: could not determine download size"$'\n'
                    elif [[ $http_code -eq 418 ]]; then
                        pr_comment+="  ├ 🫖 Remote server is a teapot"$'\n'
                    else
                        pr_comment+=$(echo "  └ ❓ URL is not reachable - error $http_code")$'\n'
                        pr_comment+=$(echo "   ├ This could be becaue the server has blocked header requests or some other issue. Human validation is required")$'\n'
                        pr_comment+=$(echo "   ├ Check [RFC status codes](https://www.rfc-editor.org/rfc/rfc9110.html#name-status-codes) for more details")$'\n'
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
                # if we are testing the PR, we don't want to apply the label
                pr_comment+=$(echo "✅ All checks passed")$'\n'
                assign_gh_label $pr_num "validated"
                remove_gh_label $pr_num "incomplete"
            else
                pr_comment+=$(echo "** WARNING: Some checks failed")$'\n'
                pr_comment+=$(echo "😃 $checks_passed checks passed")$'\n'
                pr_comment+=$(echo "🙁 $checks_failed checks failed")$'\n'
                pr_comment+=$(echo "⚠️ Please review [Contributing to Installomator](https://github.com/Installomator/Installomator/wiki/Contributing-to-Installomator) and update your pull request.")$'\n'
                pr_comment+=$(echo "**This is an automated check and response and does not cover all edge cases.**")$'\n'
                pr_comment+=$(echo "Failed checks just mean that some automations could not complete to validation. This PR may still be validated after manual review by the installomator team")$'\n'
                assign_gh_label $pr_num "attention-required"
                remove_gh_label $pr_num "validated"
            fi
            pr_comment+=$(echo "****")$'\n'
        else
            echo "⚠️ File $filename in PR $pr_num does not look like a label - skipping"
            has_non_app_component=1
            # assign_gh_label $pr_num "not a label"
        fi
    done

    echo "switching back to main branch"
    git checkout main 2>&1 > /dev/null

    if [[ $has_app_component -eq 1 ]]; then
        # dummy run - explain what else we would do
        if [[ $LIVE_RUN -eq 0 ]]; then
            echo "ℹ️  DEBUG: The following steps will take place if this was not a dummy run"
            echo "ℹ️  Set the label on the PR $pr_num to 'application'"
            echo "ℹ️  add comment to PR $pr_num with processing information"
        fi
        if [[ $has_non_app_component -eq 1 ]]; then
            echo "⚠️ PR $pr_num has non-label components"
            pr_comment+=$(echo "⚠️ PR has a new/updated label but also includes non-label components - These will need to be verified and cleaned up before PR can be merged")$'\n'
        fi
        if [[ $TEST_PR -eq 1 ]]; then
            echo "ℹ️  Testing PR $pr_num"
            echo "${pr_comment}"
            if [[ $PR_NUM -gt 0 ]] && [[ $downloadSize -gt $MAX_DL_SIZE ]]; then
                echo "⚠️ Download size of $downloadSize MB is greater than max size $MAX_DL_SIZE MB"
                read -q override"?Override? (y/n)"
                if [[ $override == 'y' ]]; then
                    echo "✅ Override"
                    MAX_DL_SIZE=$((downloadSize+1))
                fi
            fi
            if [[ $IGNORE_MISSING_DOWNLOAD_SIZE -eq 0  ]] && { [[ ! $downloadSize -gt 0 ]] || [[ $downloadSize -gt $MAX_DL_SIZE ]] }; then
                echo "⚠️ Download size is not available or greater than $MAX_DL_SIZE MB - skipping"
                ((skip_count++))
            elif [[ $checks_failed -gt 0 ]]; then
                echo "⚠️ PR $pr_num has failed checks - skipping"
                ((skip_count++))
            else
                echo "✅ PR $pr_num has passed checks - performing test before merge"
                if perform_pr_test $pr_num $label; then
                    echo "✅ PR $pr_num has been tested"
                else
                    echo "❌ PR $pr_num test failed for some reason 🙁"
                    # add attention-required label
                    assign_gh_label $pr_num "attention-required"
                    # add a comment to the PR that the test failed
                    add_gh_comment $pr_num "🤖 Testing Robot Says - ⚠️ PR test failed for some reason 🙁. Manual intervention by the Installomator team is required for this one"
                    ((skip_count++))
                fi
            fi
        else
            add_gh_comment $pr_num "${pr_comment}"
        fi
    fi

    echo "***** End PR $pr_num *****"
    echo ""
done

if [[ $skip_count -gt 0 ]]; then
    echo "Skipped $skip_count PR's out of $MAX_PR_COUNT requested"
fi

if [[ $TEST_PR -eq 1 ]] && [[ $LIVE_RUN -eq 1 ]]; then
    echo "Testing complete where dwnloads are less than $MAX_DL_SIZE MB"
    echo "Do you want to push the changes to the remote repository?"
    read -q query"?Push changes? (y/n)"
    if [[ $query == 'y' ]]; then
        git push
    else
        echo "Changes not pushed"
        echo "PR merges will not apply to the remote repository until changes are pushed"
    fi
fi

echo "Done"
exit 0
