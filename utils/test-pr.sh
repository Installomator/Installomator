#!/bin/zsh --no-rcs

# this will checkout and test a pr

# requires the gh tool and the cwd to be the repo base
#
# usage: utils/test-pr.sh <pr_num> <label>

pr_num=${1:?"arg 1 is the PR number"}
label=${2:?"arg 2 is label"}

# clean build folder
if [[ -d build ]]; then
    rm -rf build/*
fi

if ! gh pr checkout $pr_num -b "pr/$pr_num"; then
    exit $?
fi

if ! utils/assemble.sh $label; then
    exitcode=$?
    echo "something went wrong, stopping here"
    echo "exit code: $exitcode"
else
    echo
    echo "All good!"
    echo

    read -q query"?Merge into main? (y/n)"

    if [[ $query == 'y' ]]; then
        git checkout main
        git merge "pr/$pr_num" -m "label: $label, see #$pr_num"
        git branch -d "pr/$pr_num"
        gh pr comment $pr_num --body 'Thank you!'
    fi
fi
