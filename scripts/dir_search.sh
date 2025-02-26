#!/bin/bash

#
# This script automates the use of Gobuster to perform brute force of files and directories.
#
# I created this script so I don’t have to manually write the full Gobuster command every time I need to use it.
# I only included the parameters that are most relevant to me in my daily workflow.
# Feel free to use and adapt the code to your needs!
#
# There are three required parameters:
# - Target URL
# - Target wordlist
# - Name of the output file to save results 
# Optionally, the user can also provide file extensions, session cookies, and a proxy.  
#
# After execution, the obtained results are saved in "./gobuster_<TARGET_NAME>/<OUTPUT_FILENAME>"
#
# author: @davimoreno
#

############# PARAMETERS ########################
TARGET="http://businesscorp.com.br"             # Target URL (e.g. "http://test.com")
WORDLIST="/usr/share/dirb/wordlists/small.txt"  # Path to wordlist
OUTPUT_FILENAME="SEARCH_DIR.gobuster"           # Output filename
EXTENSIONS=""                                   # Entensions separated by comma (e.g. "php,js,txt,cgi,json,html") 
COOKIES=""                                      # HTTP Cookies (e.g. "session=123456; token=abcdef")
PROXY=""                                        # Used Proxy (e.g. "http://127.0.0.1:8080")
#################################################

# Extract domain name from given URL
HOST=$(echo "$TARGET" | sed -E 's|https?://([^/:]+).*|\1|')

# Create output directory if it doesn't exist already
DIR="gobuster_$HOST"
mkdir -p "$DIR"

# Get current date and time in UTC format
DATETIME=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

# Append timestamp to output filename to make it unique
TIMESTAMP=$(echo $DATETIME | sed 's/[-: a-zA-Z]//g')
OUTPUT_FILE="${TIMESTAMP}_${OUTPUT_FILENAME}"

# Construct gobuster args string based on optional parameters
# By default I'm always using the following args:
#   --random-agent : random User-Agent
#   -t 100         : 100 threads
#   -r             : following redirects
#   -k             : No TLS validation
OPTIONAL_ARGS="--random-agent -t 100 -r -k"
if [[ "$EXTENSIONS" != "" ]]; then
    OPTIONAL_ARGS+=" -x $EXTENSIONS"
fi
if [[ "$PROXY" != "" ]]; then
    OPTIONAL_ARGS+=" --proxy $PROXY"
fi
if [[ "$COOKIES" != "" ]] then
    OPTIONAL_ARGS+=" -H 'Cookie: $COOKIES'"
fi

# Use gobuster to find hidden directories and files in the target
set -- $OPTIONAL_ARGS
gobuster dir -u "$TARGET" -w "$WORDLIST" -o "$DIR/$OUTPUT_FILE" "$@"

# Create names for temporary files that will be used bellow
TEMP_HEADER_FILE=$(mktemp)
TEMP_OUTPUT_FILE=$(mktemp)

# The trap cmd ensures the temporary files are removed when the program exits
trap "rm -f $TEMP_HEADER_FILE $TEMP_OUTPUT_FILE" EXIT

# Create header of output file with information about current run
echo -e "===============================================================" > $TEMP_HEADER_FILE
echo -e "Datetime   : $DATETIME" >> $TEMP_HEADER_FILE
echo -e "Target     : $TARGET" >> $TEMP_HEADER_FILE
echo -e "Wordlist   : $WORDLIST" >> $TEMP_HEADER_FILE
echo -e "Extensions : $EXTENSIONS" >> $TEMP_HEADER_FILE
echo -e "Cookies    : $COOKIES" >> $TEMP_HEADER_FILE
echo -e "Proxy      : $PROXY" >> $TEMP_HEADER_FILE
echo -e "===============================================================\n" >> $TEMP_HEADER_FILE

# Append header to output file
cat $TEMP_HEADER_FILE "$DIR/$OUTPUT_FILE" > $TEMP_OUTPUT_FILE
mv $TEMP_OUTPUT_FILE "$DIR/$OUTPUT_FILE"
