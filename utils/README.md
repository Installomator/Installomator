# How to assemble Installomator.sh

Since the Installomator.sh script has grown to over 3000 lines, its management on git has become very unwieldy. The single file with all the logic and the data required to download and install the applications creates constant merge conflicts which add to the workflow on the repo admins.

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
```

Once you are certain that your new custom label works, you can use the code from your _custom_ Installomator.sh script in `build/Installomator.sh`, or even build an installation pkg using the `--pkg` or `--notarize` options.

## How do I contribute new or modified labels back to the Installomator project?

### When you are familiar with git and GitHub

- Create a branch in your local Installomator fork repo.
- Copy the new or modified label file to `fragments/labels`. (replacing the original, when necessary)
- Create a pull request against the main Installomator dev branch.

If you have multiple labels you want to contribute, please create a separate local branch and a separate pull request for each label.

Once your Pull Request is merged into the main repo, you can pull the change to your fork and delete the branch.

### When you are not familiar with git and GitHub

Create an Issue in the Installomator repo and include the contents of your custom label file.

If you have multiple labels, please create a separate issue for each label.

## Fragments

These are the fragments in the order they are assembled. All files are in the `fragments` directory

- header.sh
- version.sh
- functions.sh
- arguments.sh
- (optional) labels from locations given with the ``--labels` argument
- labels/*.sh
- main.txt

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
