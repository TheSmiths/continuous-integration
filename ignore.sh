#!/bin/sh

# Only do a build when there is a [patch], [major] or [minor] in the commit tag
MSG=$(git show -s --format=%B HEAD | grep -e "\[ *major *\]" -e "\[ *minor *\]" -e "\[ *patch *\]")

if [ "$MSG" = "" ]; then
    exit 0
else
    exit 1
fi
