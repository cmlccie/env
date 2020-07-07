#!/bin/sh

#  storeMD5.sh source.file [hash.text.file]
#
#
#  Created by Chris M. Lunsford on 8/7/13.
#

# Calculates MD5 hash of a source file and compares the result with the MD5 hash specified as an argument or stored in a specified or default text file.


# Parse the command line arguments, and retrieve the spefied or stored MD5 hash.
if [ "$1" = "-s" ] ; then
    STORE_HASH="Yes"
    CHECK_FILE="$2"
    HASH_SOURCE="$3"
    STORE_FILE="$4"

    if (echo "$HASH_SOURCE" | egrep -o "[0-9A-Fa-f]{32}" > /dev/null) ; then
        # HASH_SOURCE argument is a specified MD5 hash value.  This should always be the case when the -s option is used.
        STORED_MD5_HASH=$HASH_SOURCE
        HASH_SOURCE="Specified MD5 Hash"
    else
        echo "You must specify a valid MD5 hash for comparison when using the -s option."
        exit
    fi

    if [ "$STORE_FILE" = "" ] ; then
        STORE_FILE="$CHECK_FILE.md5.txt"
    fi
else
    CHECK_FILE="$1"
    HASH_SOURCE="$2"
    if (echo "$HASH_SOURCE" | egrep -o "[0-9A-Fa-f]{32}" > /dev/null) ; then
        # HASH_SOURCE argument is a specified MD5 hash value.
        STORED_MD5_HASH=$HASH_SOURCE
        HASH_SOURCE="Specified MD5 Hash"
    elif [ "$HASH_SOURCE" = "" ] ; then
        # A hash text file name wasn't specified, defaulting to the source filename with a '.md5.txt' suffix.  Check for existance of the file and, and if found, extract the stored MD5 hash.
        HASH_SOURCE="$CHECK_FILE.md5.txt"
        STORED_MD5_HASH=$(egrep -o "[0-9A-Fa-f]{32}" "$HASH_SOURCE")
        if [ "$STORED_MD5_HASH" = "" ] ; then
            echo "Unable to find MD5 hash in \"$HASH_SOURCE\"."
            exit
        fi
    elif [ -e "$HASH_SOURCE" ] ; then
        # Hash file specified and exists.  Extract the stored MD5 hash.
        STORED_MD5_HASH=$(egrep -o "[0-9A-Fa-f]{32}" "$HASH_SOURCE")
        if [ "$STORED_MD5_HASH" = "" ] ; then
            echo "Unable to find MD5 hash in \"$HASH_SOURCE\"."
            exit
        fi
    else
        echo "\"$HASH_SOURCE\" is an invalid MD5 hash or the specified file does not exist."
        exit
    fi
fi


# Calculate the MD5_HASH of the CHECK_FILE
if [ "$STORE_HASH" = "Yes" ] ; then
    echo "Calculating and storing the MD5 hash."
    storeMD5.sh "$CHECK_FILE" "$STORE_FILE"
    echo ""
    if [ -e "$STORE_FILE" ] ; then
        # Hash file specified and exists.  Extract the stored MD5 hash.
        MD5_HASH=$(egrep -o "[0-9A-Fa-f]{32}" "$STORE_FILE")
        if [ "$MD5_HASH" = "" ] ; then
            echo "Unable to store or retrieve the MD5 hash from the store file\"$STORE_FILE\"."
        exit
        fi
    fi
else
    # Calculate the MD5 hash of the source file and compare it to the stored hash.
    MD5_HASH=$(md5 "$CHECK_FILE" | egrep -o "[0-9A-Fa-f]{32}")
fi


# Script Output
echo "$MD5_HASH <- $CHECK_FILE"
echo "$STORED_MD5_HASH <- $HASH_SOURCE"
echo ""

if [ "$MD5_HASH" = "$STORED_MD5_HASH" ] ; then
    echo "Verified.  The MD5 hashes match."
else
    echo "Verification FAILED.  The MD5 hashes DO NOT match."
fi
