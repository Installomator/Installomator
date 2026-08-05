zipEOF
)

# create script folder if missing
if [[ ! -d "$install_location" ]]; then
    echo "Creating folder: ${install_location}"
	mkdir -p "${install_location}"
	echo "$(chmod -vv a+x "${install_location}")"
fi
echo "$(ls -ld "${install_location}")"

# Create script file
echo "Create script file w DEBUG=0: ${script_file}"
echo "$zipContent" | base64 -d -i - -o - | gunzip | sed -e 's/^DEBUG=1$/DEBUG=0/g' > "$script_file"

# Set ownership and permissions
echo "Set ownership and permissions"
chown root:wheel "$script_file"
chmod 755 "$script_file"
ls -l "${script_file}"
cmdResult=$?


# MARK: Finishing

echo "Result: $cmdResult"

exit $cmdResult
