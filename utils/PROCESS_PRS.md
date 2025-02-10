## Processing PR's

The process_prs.sh script is used for triage and bulk processing of pull requests. It is intended to be run by a human, not as part of a CI/CD pipeline. The script is designed to be run from the root of the repository, e.g. `./utils/process_prs.sh`.

### Requirements

- [jq](https://stedolan.github.io/jq/)
- [gh](https://cli.github.com/)

### Modes of Operation

This has two modes of operation:

 1. Triage and Validate: Unlabelled PR's are sorted into labels and non-labels. Labels are then validated and a report is generated. When running in live mode, labels are applied to the PR's.
 2. Test PR's: PR's are checked out and the test-pr process is run against them. If the test succeeds you can perge the pr into main.

### Usage

Given no prompts or arguments, the script will do the following:

 - Run in mode 1 (Triage and Validate)
 - Get a list of the oldest 5 PR's that have no labels and are not closed.
 - For each PR, determine if it is an Installomator label or something else.
 - If it's a label, it will checkout the changes, and evaluate to determine whether basic checks pass.
  - The label has the correct line ending (LF)
  - Name is present
  - Type is present
  - Expected Team ID is present
  - App New Version is present (warning only)
  - Download URL is present
  - Download URL is reachable
  - Download size (warning only)
 - Generate a report
  - Type and Download Size will only generate a warning and not a failure.

### Options

As-is, the script will not make any changes or apply labels or comments. The following arguments can be used to change this behavior:

 - `LIVE_RUN=1` - This will apply labels and comments to the PR's
 - `MAX_PR_COUNT=<number>` - This will change the number of PR's to process. Default is `5`.
 - `SORT_ORDER=<string>` - This will change the sort order of the PR's. Default is `created-asc` to get the oldest PR's first.
 - `SEARCH_STRING="<string>"` - This will change the search string used to find PR's. Default is `no:label sort:${SORT_ORDER}`.
 - `FROM_PR_NUM=<number>` - This will change the starting PR number. Default is `0`. Any PR's fetched that are lower than this number will be skipped.
 - `PR_NUM=<number>` - Process a single PR number. If this is populated, no search is done and only this PR is processed.

When running in live mode, if a PR is successfully validated, the `application` and `validated` labels are applied. If the PR fails validation, the `invalid` label is applied. The report is then added to the PR as a comment.

An example report will look like:

```markdown
🤖 Validation robot 🤖
File fragments/labels/aftermath.sh
** Label info:
├ ✅ correct line ending
├ ✅ Name: Aftermath
├  ✅ Type: pkg
├  ✅ Expected Team: C793NB2B2B
├  ✅ App New Version: 2.2.1
└ Download URL: https://github.com
  ├ ✅ URL is reachable
  └ ⚠️  Download Size: could not determine download size
✅ All checks passed
****
```

 ### Testing PR's

 To run in the second mode, you can use the following arguments in addition to the above:

  - `TEST_PR=1` - This will run the test-pr process on the PR's. This will check out the PR and run the test-pr process on it.
  - `MAX_DL_SIZE=<number>` - This will change the maximum download size allowed. Default is `50` (50MB).
   - This is used to determine if the download size is reasonable. If the download size is larger than this, it will generate a warning and skip the test process.

When mode 2 is running the default search is changed to the following:

`SEARCH_STRING="is:pr is:open label:application label:validated -label:\"waiting for response\" -label:invalid -label:attention-required -label:incomplete sort:${SORT_ORDER}"`

This will search for PR's that are open, have the application and validated labels, but do not have any of the labels that may indicate we are waiting on a response or requires some manual intervention.

If the PR passes the test process, you are prompted if you want to merge the PR into main. If you choose to merge, the PR is merged into main and the PR is closed.

If the test fails, the PR is left open and the report is added as a comment. The label `attention-required` is applied to the PR.

## Examples

### Triage dry run on the oldest 5 PR's with no labels

```bash
./utils/process_prs.sh
```

### Triage full run on the oldest 5 PR's with no labels

```bash
./utils/process_prs.sh LIVE_RUN=1
```

### Run in live test mode on the oldest 20 PR's with a max download size of 300MB

```bash
./utils/process_prs.sh LIVE_RUN=1 TEST_PR=1 MAX_DL_SIZE=300 MAX_PR_COUNT=20
```

### Re-processing a previously failed PR

A suggested workflow for re-processing a PR that failed a previous validation and the author has since updated is to run a re-validation in non-live mode. If the PR passes, then run the PR in test mode. If the test passes, the PR can be merged.

```bash
# re-validate PR non-live mode. Visually validate the results
./utils/process_prs.sh LIVE_RUN=0 PR_NUM=123
# re-test PR non-live mode. Visually validate the results
./utils/process_prs.sh LIVE_RUN=0 TEST_PR=1 PR_NUM=123
# re-test PR live mode. If the test passes, the PR can be merged
./utils/process_prs.sh LIVE_RUN=1 TEST_PR=1 PR_NUM=123

```

You could also process previous PR's in bulk. For example use the SEARCH_STRING to find all PR's that have the `application` and `invalid` label updated in the last two days and re-process them.

```bash
./utils/process_prs.sh TEST_PR=0 LIVE_RUN=0 SEARCH_STRING="is:open is:pr label:application label:incomplete updated:$(date -v-2d "+%Y-%m-%d")"
```