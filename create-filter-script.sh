#!/usr/bin/env bash

export LC_ALL=C

cat <<\EOF
#!/bin/sh
# Automatically generated file

git --git-dir=history-tofix.git filter-branch --env-filter '
case $GIT_COMMIT in
EOF

# For matched tag dates obtain date from version list
join <(sort tag-dates) <(sort version-list) |
awk '{
  print "  " $5 ")"
  print "    date=\"" $6, $7 " UTC\""
  print "    ;;"
}'

# Unmatched tag dates
join -v 1 <(sort tag-dates) <(sort version-list) |
awk '{
  print "  " $5 ")"
  print "    date=$(cat /tmp/prev-commit-date)"
  print "    ;;"
}'

cat <<\EOF
esac

if [ -n "$date" ] ; then
  export GIT_AUTHOR_DATE="$date"
  export GIT_COMMITTER_DATE="$date"
  echo "$date" >/tmp/prev-commit-date
fi

test -n "$GIT_COMMITTER_NAME" || export  GIT_COMMITTER_NAME="Linus Torvalds"
test -n "$GIT_COMMITTER_EMAIL" || export  GIT_COMMITTER_EMAIL="torvalds@linux-foundation.org"
test -n "$GIT_AUTHOR_NAME" || export  GIT_AUTHOR_NAME="Linus Torvalds"
test -n "$GIT_AUTHOR_EMAIL" || export  GIT_AUTHOR_EMAIL="torvalds@linux-foundation.org"

' --tag-name-filter cat -- --branches --tags
EOF
