#!/bin/sh

# Only if needed
if ./ignore.sh; then exit 0; fi

# Bump version of the tiapp.xml
# If no version num is explicitly specified, it will count
# commits semantics message and compute a version number from that


# Usage:
#   bump_version <sdk|app> [<version-number>]
#
# Exemple:
#   bump_version sdk 3.5.1.GA
#   bump_version app

if [ $# -lt 1 ]; then
    echo "Missing first parameter 'sdk'|'app'"
    exit 1
elif [ $1 = "sdk" ] && [ $# -ne 2 ]; then
    echo "Missing sdk version number"
    exit 1
elif [ $1 = "sdk" ]; then
    VERSION=$2
    KEY="sdk-version"
elif [ $1 = "app" ]; then
    PATCH=$(git log --oneline | grep -c "\[ *patch *\]")
    MINOR=$(git log --oneline | grep -c "\[ *minor *\]")
    MAJOR=$(git log --oneline | grep -c "\[ *major *\]")
    VERSION="$MAJOR.$MINOR.$PATCH"
    KEY="version"
else
    echo "Unreckonized parameter $1"
    exit 1
fi

sed -i "" "/<$KEY>.*<\/$KEY>/s/>.*</>$VERSION</g" tiapp.xml
