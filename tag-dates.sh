#!/bin/sh
git --git-dir="$1" tag -l |
grep -v -e '^v2\.[56]' -e '^lia64' |
while read tag ; do
  echo -n "$tag "
  git --git-dir="$1" log --date=iso -n 1 --format='%ad %H' $tag
done |
sort
