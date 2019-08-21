test:
	@echo "Hello World! Your Test was successfull!"

_ensure_clean_git:
	@s="`git status --untracked-files=no --porcelain`" && [ -z "$$s" ] || { echo; echo "please checkin everything before"; echo; false; }

_gpg_update:
	gpg2 --import .apt-repos/gpg/*.gpg

git_update: _ensure_clean_git
	git pull -r
	git submodule update

bundle_apply_all:
	for i in $$(ls repo/bundle/mybionic/); do b=mybionic/$$i; echo $$b; bundle apply $$b; done

repo_update_bundles: git_update _gpg_update
	tools/repo_update_bundles.sh
