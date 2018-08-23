#!/bin/sh
#
# Create a historical Linux repo
# from a list of tag, date, time, archive
#
# (Currently unused, but could be the base to build history from scratch,
# together with the changelogs from https://github.com/kernelslacker/linux-historic-scripts)
#

repo=linux-history
rm -rf $repo
mkdir $repo
cd $repo
git init

TZ=$(date +'%Z')

while read tag date time archive ; do
  url=$(echo $archive | sed 's/archive/http:\//;s/cdn\./www./')
  tar --strip-components=1 -axf ../$archive 2>/dev/null
  git add .
  GIT_COMMITTER_NAME='Linus Torvalds' \
  GIT_COMMITTER_EMAIL=torvalds@linux-foundation.org \
  GIT_COMMITTER_DATE="$date $time UTC" \
  GIT_AUTHOR_NAME='Linus Torvalds' \
  GIT_AUTHOR_EMAIL=torvalds@linux-foundation.org \
  GIT_AUTHOR_DATE="$date $time UTC" \
  git commit -m "Linux $tag

(Obtained from $url)"
  git tag $tag
done
