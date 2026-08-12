
# Searches for a text (case-sensivie or case-insensitive) inside a directory recursivly
#
# Args:
#   $1 The text to search
#   $2 The path to search in
#   $3 case-sensitivity that is denoted by "true" or "false"
#
# Outputs the result to stdout
search_text() {
    if [ $# -ne 3 ] ; then
        echo "Internal process error: The 'search_text' function takes only 3 args!" >&2
        exit 1
    fi

    if [ "$3" = "true" ]; then
        # do a case sensitive search
        grep -rn --color=always "$1" "$2"
    else
        # do a case in-sensitive search
        grep -rin --color=always "$1" "$2" 
    fi
}


# Checks if a given file/dir path exists in the filesystem
#
# Args:
#   $1 A file system path
#
# Outputs "true" or "false" to stdout
check_path_exists() {
    if [ $# -ne 1 ]; then
        echo "Internal process error: The 'check_path_exists' function takes only 1 args!" >&2
        exit 1
    fi

    if [ -e "$1" ]; then
        echo "true"
    else
        echo "false"
    fi
}


# Formats a given file path by substituting the leading ~ with $HOME
#
# Args:
#   $1 A file system path
# Outputs the result to stdout
format_file_path() {
    if [ $# -ne 1 ]; then
        echo "Internal process error: The 'format_file_path' function takes only 1 args!" >&2
        exit 1
    fi

    echo "$1" | sed "s|^~|$HOME|"
}


# Lowercases a given string
#
# Args:
#   $1 A string to lowercase
#
# Outputs the result to stdout
lowercase_text() {
    if [ $# -ne 1 ]; then
        echo "Internal process error: The 'lowercase_text' function takes only 1 args!" >&2
        exit 1
    fi

    echo "$1" | tr "A-Z" "a-z"
}

