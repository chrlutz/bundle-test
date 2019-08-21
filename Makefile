test:
	@echo "Hello World! Your Test was successfull!"

bundle_apply_all:
	for i in $$(ls repo/bundle/mybionic/); do b=mybionic/$$i; echo $$b; bundle apply $$b; done

repo_update_bundles:
	tools/repo_update_bundles.sh
