#!/bin/zsh

# this will checkout and test a pr

# requires the gh tool and the cwd to be the repo base
#
# usage: utils/test-pr.sh <pr_num> <label>

pr_num=${1:?"arg 1 is the PR number"}
label=${2:?"arg 2 is label"}

gh pr checkout $pr_num -b "pr/$pr_num"

if ! utils/assemble.sh $label; then
    echo "something went wrong, stopping here"
else
    echo
    echo "All good! merging..."
    echo

    git checkout main
    git merge "pr/$pr_num" -m "new label: $label"
    git branch -d "pr/$pr_num"
    gh pr comment $pr_num --body 'Thank you!'
fi
