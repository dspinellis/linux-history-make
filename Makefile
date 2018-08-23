export LC_ALL=C

versions=Historic v1.0 v1.1 v1.2 v1.3 v2.0 v2.1 v2.2 v2.3

linux-history-repo.git: filter-script.sh history-tofix.git
	rm -rf .git-rewrite /tmp/prev-commit-date
	./filter-script.sh
	rm -rf linux-history-repo.git
	mv history-tofix.git linux-history-repo.git
	touch history-tofix.git linux-history-repo.git

filter-script.sh: create-filter-script.sh tag-dates version-list
	./create-filter-script.sh >$@
	chmod +x $@

history-tofix.git: history.git
	rm -rf $@
	cp -r history.git $@

version-list: archive-dates.sh archive
	./archive-dates.sh >$@

tag-dates: tag-dates.sh history-tofix.git
	./tag-dates.sh history-tofix.git >$@

history.git:
	git clone git://git.kernel.org/pub/scm/linux/kernel/git/history/history.git

archive:
	mkdir archive
	cd archive && for i in $(versions) ; do wget -r --no-parent http://cdn.kernel.org/pub/linux/kernel/$i/ ; done
