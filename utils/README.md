# How to assemble Installomator.sh

Since the Installomator.sh script has grown to over 5000 lines, its management on git has become very unwieldy. The single file with all the logic and the data required to download and install the applications creates constant merge conflicts which add to the workload of the repo admins, especially when part of the team is working on the logic of the script while we still get PRs to add labels.

Because of that we have split the main script into multiple files which are easier to manage. Having multiple files results in less merge conflicts.

## What changes when I _use_ the script?

Nothing. When you just use the Installomator.sh, you still copy its contents from the Installomator.sh script at the root of the repository into your management service (don't forget to change the `DEBUG` value). Or you install the script to the clients using the installer pkg from the [Releases](https://github.com/Installomator/Installomator/releases).

The changes will only affect you when you want to build your own application labels, modify existing labels or other wise modify the script.

## How do I build my own labels now?

To simplify git merges, the script is broken into several files or 'fragments.' The individual fragments on their own are not functional or executable. When you are modifying labels or script code, you assemble and run Installomator using the `utils/assemble.sh` tool. For convenience, there is a symbolic link in the root of the repository.

If you want to build your own labels or modify existing ones, follow these steps (I will be using desktoppr as an example, even though the label already exists.)

First, create a directory somewhere for your labels. For example: `~/Documents/InstallomatorLabels`.

Inside this folder, create a new file named `desktoppr.sh`. The name is not really relevant, but should match the label name to make it easier to locate.

The contents for the label file should be the case statement block, like this:

```
desktoppr)
    name="desktoppr"
    type="pkg"
    packageID="com.scriptingosx.desktoppr"
    downloadURL=$(downloadURLFromGit "scriptingosx" "desktoppr")
    appNewVersion=$(versionFromGit "scriptingosx" "desktoppr")
    expectedTeamID="JME5BW3F3R"
    blockingProcesses=( NONE )
    ;;
```

If you want to modify an existing label, copy the label from `fragements/labels` in the Installomator repository to your directory.

When you are building or modifying labels, you will need to run the assembled script. The `assemble.sh` tool will do this for you. To test our new label, assemble and run the Installomator script like this: (make sure your working directory is the Installomator repository root)

```
> ./assemble.sh -l ~/Documents/InstallomatorLabels desktoppr
```

This will put together all the fragments, including your labels in your label folder. and run the script with the `desktoppr` argument. Since custom label locations are merged into the script _before_ the default location, custom label files will override existing labels. You can add more arguments to test the label further:

```
> sudo ./assemble.sh -l ~/Documents/InstallomatorLabels desktoppr NOTIFY=silent DEBUG=0
# NOTE: this _installs_ desktoppr
```

Once you are certain that your new custom label works, you can use the code from your _custom_ Installomator.sh script in `build/Installomator.sh`, or even build an installation pkg using the `--pkg` or `--notarize` options.

The `Installomator.sh` script at the root of the repo does not really get involved in your building and testing. Similarly, if you want to apply, test, and contribute changes to the script's logic, you should modify the fragment file in question and test using the assemble script.

Pull requests against the `Installomator.sh` script in the root of the repo will be rejected.

## How do I contribute new or modified labels back to the Installomator project?

### When you are familiar with git and GitHub

- If you haven't already, create a fork of the Installomator repo. Clone the fork to your local Mac.
- Create a new branch in your local Installomator (fork) repo.
- Copy the new or modified label file to `fragments/labels`. (replacing the original, when necessary)
- Test (push the change to your fork on GitHub. You can check that out on testing devices or vms.)
- Create a pull request against the Installomator `main` branch.
- Don't use this branch for _any_ other modifications, unless you need to update this particular PR. (Pull Requests are against a _branch_, not a particular commit.)

If you have multiple labels (or other changes) you want to contribute, please create a _separate_ local branch and a _separate_ pull request for each label. This allows us to accept, modify, or reject each label separately and simplifies the process. 

Once your Pull Request is merged into the main repo, you can pull the change to your local repo, push it to your fork, and delete the branch, because it should be fully merged.

When you have multiple labels or changes, please create a separate issue for each label or change, unless they are closely related


### When you are not familiar with git and GitHub

We have a tutorial on [How to create Pull Requests in GitHub](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue).


## Fragments

These are the fragments in the order they are assembled. All files are in the `fragments` directory

- header.sh
- version.sh
- functions.sh
- arguments.sh
- (optional) labels from locations given with the `--labels` argument
- labels/*.sh
- main.txt

Even though the fragment files are not functional shell scripts, we decided to use the `.sh` file extension, so that Finder opens the files in the proper application and text editors recognize their file type for code display.

`header.sh` contains all the 'front matter' of the script. This means all the variables that users can change together with all the comment lines explaining them.

The `version.sh` file is special in that is only contains the version string _and nothing else_. The assemble script will use this version to create two line of code that look like this:

```
VERSION="0.7.0b1"
VERSIONDATE="2021-08-17"
```

where the version is from the file and the date is generated dynamically from the current date.

The `functions.sh` fragment contains all the functions used in the script.

The `arguments.sh` fragment contains the argument parsing logic and some other logic that needs to happen before the label is evaluated. This includes the start of the large case statement that evaluates the label and the three 'built-in' labels `version`, `longversion`, and `valuesfromarguments`.

All the contents of the label files in `labels` (and any custom label locations you provide with the `-l`/`--label` option) will be inserted here.

Finally, the `main.sh` fragment contains most of the main logic.

The assemble script does not check _any_ of the files for syntax or completeness. You are responsible that everything fits together properly. (Pay special attention to remember the closing semi-colons `;;` and a final line break in the label files.)

## assemble.sh Usage

```
assemble.sh
```

This will put together the fragments and labels from the default location (`fragments` and `fragments/labels`) and write it to `build/Installomator.sh` and execute it. (When you run the script without any arguments, it will print all the labels.)

```
assemble.sh <label>
assemnle.sh <label> <VAR=value>...
```

This will put together the fragments and labels from the default location, create the script in `build/Installomator.sh` and immediately run it with the given arguments. 

Note: the assembled script will run in debug mode, unless you specifically override this with `DEBUG=0`.

### Adding custom labels

```
assemble.sh --labels path/to/labels_dir
```

Text files from this directory will be added _in addition to_ the default labels directory `fragments/labels`. The custom labels will be inserted in the script _before_ the default labels, so custom labels will override default labels. You can add multiple `--labels` arguments:

```
assemble.sh --labels ../my_labels/test --labels ../my_labels/production
```

In this case the labels from `../my_labels/test` will be inserted first, then the labels from `../my_labels/production`  and then the labels from `fragments/labels`

### Building for Release

```
assemble.sh --script
```

This will build the full script and place it in the root of the repo.

```
assemble.sh --pkg
```

Build the full script, disable Debug mode and build a _signed_ installer pkg.

```
assemble.sh --notarize 
```

Build the full script, disable Debug mode, build a signed pkg, and send it to notarization.

There are variables at the beginning of the `assemble.sh` script which you need to modify to use your certificates and Developer ID instead of mine.
