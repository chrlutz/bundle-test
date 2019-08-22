test:
	@echo "Hello World! Your Test was successfull!"

_ensure_clean_git:
	@s="`git status --untracked-files=no --porcelain`" && [ -z "$$s" ] || { echo; echo "please checkin everything before"; echo; false; }

_gpg_update:
	gpg --import .apt-repos/gpg/*.gpg

git_update: _ensure_clean_git
	git pull -r
	git submodule update

update_bundle_compose_status:
	./bundle-compose update-bundles --no-trac
	git add bundle-compose.status
	git commit -m "bundle-compose update-bundles"

repo_update: repo_update_bundles repo_update_target

repo_update_bundles: git_update _gpg_update
	tools/repo_update_bundles.sh

repo_update_target: git_update _gpg_update
	bundle-compose apply
	reprepro -b repo/target --noskipold update
	@echo "Finished repo_update_target"

list_commands:
	@echo "Available Commands:"
	@make -pRrq : 2>/dev/null | perl -ne 'print "$$1\n" if $$_=~/^([a-zA-Z][a-zA-Z0-9_\-]+):/' | grep -v "Makefile" | sort

