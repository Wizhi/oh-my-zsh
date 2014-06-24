# --------------------------------------------
# Extracts archived files / mounts disk images
# 
#     extract <file>
#
# @author http://nparikh.org/notes/zshrc.txt
# @note	  .dmg/hdiutil is Mac OS X-specific.
# --------------------------------------------
extract () {
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2) tar -jxvf $1 ;;
			*.tar.gz) tar -zxvf $1 ;;
			*.bz2) bunzip2 $1 ;;
			*.dmg) hdiutil mount $1 ;;
			*.gz) gunzip $1 ;;
			*.tar) tar -xvf $1 ;;
			*.tbz2) tar -jxvf $1 ;;
			*.tgz) tar -zxvf $1 ;;
			*.zip) unzip $1 ;;
			*.ZIP) unzip $1 ;;
			*.pax) cat $1 | pax -r ;;
			*.pax.Z) uncompress $1 --stdout | pax -r ;;
			*.Z) uncompress $1 ;;
			*) echo "'$1' cannot be extracted/mounted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

# --------------------------------------
# Syntax-highlight JSON strings or files
#
#     json {"foo": "bar"}
#     json data.json
# --------------------------------------
function json() {
	if [ -p /dev/stdin ]; then
		# piping, e.g. `echo '{"foo":42}' | json`
		python -mjson.tool | pygmentize -l javascript
	else
		# e.g. `json '{"foo":42}'`
		python -mjson.tool <<< "$*" | pygmentize -l javascript
	fi
}

# ------------------------
# Get gzipped size of file
#
#     gz file.ext
# ------------------------
function gz() {
	echo "orig size (bytes): "
	cat "$1" | wc -c
	echo "gzipped size (bytes): "
	gzip -c "$1" | wc -c
}

# -----------------------------------------------------
# Determine size of a file or total size of a directory
#
#     fs data.txt
#     fs foo/bar/
#     fs data.txt foo/bar/
# -----------------------------------------------------
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh
	else
		local arg=-sh
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@"
	else
		du $arg .[^.]* *
	fi
}

# ----------------------------------------------------
# A shortcut function that simplifies usage of xclip.
#
#     cb "Hello world"
#     cat file.ext | cb
# ----------------------------------------------------
cb() {
	local _scs_col="\e[0;32m"; local _wrn_col='\e[1;31m'; local _trn_col='\e[0;33m'

	# Check that xclip is installed.
	if ! type xclip > /dev/null 2>&1; then
		echo -e "$_wrn_col""You must have the 'xclip' program installed.\e[0m"
	elif [[ "$USER" == "root" ]]; then # Check user is not root (root doesn't have access to user xorg server)
		echo -e "$_wrn_col""Must be regular user (not root) to copy a file to the clipboard.\e[0m"
	else
		# If no tty, data should be available on stdin
		if ! [[ "$( tty )" == /dev/* ]]; then
			input="$(< /dev/stdin)"
		else # Else, fetch input from params
			input="$*"
		fi

		if [ -z "$input" ]; then # If no input, print usage message.
			echo "Copies a string to the clipboard."
			echo "Usage: cb <string>"
			echo "    echo <string> | cb"
		else
			# Copy input to clipboard
			echo -n "$input" | xclip -selection c

			# Truncate text for status
			if [ ${#input} -gt 80 ]; then 
				input="$(echo $input | cut -c1-80)$_trn_col...\e[0m"
			fi

			# Print status.
			echo -e "$_scs_col""Copied to clipboard:\e[0m $input"
		fi
	fi
}

# ----------------------
# Copy file to clipboard
# 
#     cbf file.ext
# ----------------------
function cbf() {
	cat "$1" | cb
}

