# Installomator Repository Instructions

These instructions are for coding agents working in the public `Installomator/Installomator` repository. Follow the repository's `README.md`, `CONTRIBUTING.md`, `utils/README.md`, and relevant workflow definitions when they provide more specific or newer guidance.

## Repository structure and source of truth

- Make source changes in `fragments/`. The root `Installomator.sh` and `Labels.txt` are generated artifacts; do not hand-edit them.
- Labels live in `fragments/labels/<label>.sh`. Shared runtime code is split among `header.sh`, `version.sh`, `functions.sh`, `arguments.sh`, and `main.sh`; edit the narrowest relevant fragment.
- Label fragments are case arms inserted into the assembled script. They are not standalone shell programs. Preserve the surrounding syntax, including the closing `;;` and final newline.
- Read nearby labels and the helper implementations in the current checkout before changing label syntax or behavior. Do not assume a helper or runtime behavior from another Installomator release is available here.
- Do not write comments in labels.
- Keep changes focused. A label-only change should not alter shared runtime behavior; a shared runtime change should describe its broader impact.

## Label changes

- Keep one label or one closely related fix per pull request where practical.
- For new labels, follow the current label conventions and document how `appNewVersion` is obtained. Include an Installomator run log in the pull request description as requested by `CONTRIBUTING.md`.
- Verify that the selected vendor release, download, installed application or package, and expected signing identity refer to the intended product and channel. Do not guess version values, URLs, bundle or package identifiers, or Team IDs.
- Preserve existing signing checks and normal runtime behavior. Do not weaken verification or add new runtime dependencies without a demonstrated need and compatibility review.
- Treat vendor metadata and downloaded content as untrusted input. Do not use `eval`, source vendor responses, or construct executable shell from them.

## Building and validation

- Inspect `utils/assemble.sh` and `utils/README.md` before invoking the assembler. It assembles the fragments and labels, and its default behavior runs the generated script with the arguments supplied to it. A label run can download and install software or otherwise affect the machine.
- Do not run an installation, updater, or other action that changes a system unless the user has explicitly requested it and an appropriate disposable test Mac or VM is available. Use the target revision's documented test procedure and state what was actually exercised.
- `./utils/assemble.sh --script` builds the script and copies generated `Installomator.sh` and `Labels.txt` into the repository root. It changes those generated files; do not run it just for a syntax check. Review and report generated diffs when regeneration is part of the requested change.
- The assembler does not validate fragment syntax or completeness. Use static review and appropriate syntax checks; a successful assembly alone is not proof that a label works. Fragments require their assembled context for meaningful parsing.
- Check the applicable GitHub Actions workflows for the current automated checks. The pull-request line-feed workflow requires changed files to end with LF. Do not claim a CI check or installation test passed unless it was actually run and observed.

## Contributions and branches

- Follow `CONTRIBUTING.md`: branch from `main` for pull requests, and target `main` unless current project guidance says otherwise. The `release` branch represents the latest released version; `main` contains current work, while `dev` is used for work with greater behavior-change risk.
- Keep pull requests and branches focused so maintainers can review, accept, or reject changes independently. Link a related issue when applicable and include relevant logs and the Installomator version.
- Direct support questions to the `#installomator` channel in MacAdmins.org Slack rather than opening an issue solely to ask a question. Use issues or pull requests for bugs and incorrect behavior.

## Reporting work

- Summarize the behavior changed, the evidence used, and the checks performed. Distinguish static review, assembly, network checks, and installation validation; do not imply one establishes another.
- Mention generated files or repository state changes caused by build commands. If a check could not be run, state that plainly.
