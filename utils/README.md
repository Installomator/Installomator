# How to assemble Installomator.sh

Since the Installomator.sh script has grown to over 3000 lines, its management on git has become very unwieldy. Because of that we have split the main script into multiple text files which are easier to manage. Having multiple files results in less merge conflicts.

The full script is assembled using the `utils/assemble.sh` tool. For convenience, there is a symbolic link in the root of the repository.

## Fragments

These are the fragments in the order they are assembled:

- header.sh
- version.sh
- functions.sh
- arguments.sh
- (optiona) all labels from locations given with the ``--labels` argument
- labels/*.sh
- main.txt

## assemble.sh Usage

```
assemble.sh
```

This will put together the fragments and labels from the default location (`fragments` and `fragments/labels`) and write it to `build/Installomator.sh`

```
assemble.sh <label>
assemnle.sh <label> <VAR=value>...
```

This will put together the fragments and labels from the default location, create the script in `build/Installomator.sh` and immediately run it with the given arguments. (Note: the script will run in debug mode, unless you specifically override this with `DEBUG=0`.)

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

Build the full script, disable Debug mode and build an installer pkg.

```
assemble.sh --notarize 
```

Build the full script, disable Debug mode, sign it, build a signed pkg, and send it to notarization.


