#!/bin/sh
#
# Process all tar files to create a list with the following fields:
# version tag name
# date
# time
# archive file

find archive -type f |
# List of valid suffixes obtained with:
# find archive | fgrep .tar | sed 's/.*\.tar//' | sort -u
egrep '.*\.tar\.(Z|bz2|gz|xz|z)$' |
# Remove non-kernel files
grep -v -e modules -e bdflush -e modutils -e tlb-shootdown-tree -e impure |
while read f ; do
  echo -n "$f "
  # Obtain timestamp of most recent file
  tar -atvf "$f" 2>/dev/null |
  awk '{print $4, $5}' |
  sort -r |
  head -1
done |
sed '
# Move full path to the end
s/^\(.*\/\)\(.*\)\(\.tar[^ ]*\)\(.*\)/\2 \4 \1\2\3/
s/^linux-//
s/^pre-//
s/^v1\.1\.0/1.1.0/
s/2\.2\.0-pre/2.2.0pre/
s/2\.3\.99-pre/2.3.99pre/
' |
sort -k2,3 |
# Remove duplicates
awk '
$1 != prev_name || $2 != prev_date || $3 != prev_time {
  print
  prev_name = $1
  prev_date = $2
  prev_time = $3
}'
