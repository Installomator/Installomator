# How to assemble Installomator.sh

Since the Installomator.sh script has grown to over 3000 lines, its management on git has become very unwieldy. Because of that we have split the main script into multiple text files which are easier to manage. Having multiple files results in less merge conflicts.

The full script is assembled using the `utils/assemble.sh` tool. For convenience, there is a symbolic link in the root of the repository.