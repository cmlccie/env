#!/bin/sh

#  storeMD5.sh source.file [destination.file]
#  
#
#  Created by Chris M. Lunsford on 8/7/13.
#

# Calculates MD5 hash of a source file and stores the result in a spcified or default destination text file.n


promptForOverwrite()
{
    echo "\"$DESTINATION_FILE\" already exists."
    echo ""
    printf "Do you want to overwrite \"$DESTINATION_FILE\"? (y/n) "
    read OVERWRITE_RESPONSE

    if (echo "$OVERWRITE_RESPONSE" | egrep "y|Y" > /dev/null) ; then
        return 0

    elif (echo "$OVERWRITE_RESPONSE" | egrep "n|N" > /dev/null) ; then
        exit

    else
        echo "Invalid response."
        exit

    fi
}




SOURCE_FILE="$1"
# No need to check source file.  MD5 is a read-only operation, and the 'md5' command will throw an error if it is unable to locate or read the file.



DESTINATION_FILE="$2"

# If a destination file name wasn't specified, then default to the source filename with a '.md5.txt' suffix.
if [ "$DESTINATION_FILE" = "" ] ; then

    DESTINATION_FILE="$SOURCE_FILE.md5.txt"

fi

# Since we will be writing to the DESTINATION_FILE, check to see if it exists and prompt to overwrite it if found.
if [ -e "$DESTINATION_FILE" ] ; then

    promptForOverwrite

fi



md5 $SOURCE_FILE > $DESTINATION_FILE
more $DESTINATION_FILE
