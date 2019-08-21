#!/bin/bash
LOOKBACK="10 minutes"

for bundle in $(find repo/bundle/*/* -depth -maxdepth 0 -type d)
do 
  echo
  test -z "$(git ls-tree HEAD "${bundle}")" && {
    echo "Skipping bundle '${bundle}' as it not longer exists in git. Use --cleanup to remove it completely."
    test "$1" == "--cleanup" && (
        set -x
        rm -Rf "${bundle}"
    )
    continue;
  }
  test -z "$(git log --exit-code --since="${LOOKBACK} ago" -- "${bundle}/conf/sources_control.list" "${bundle}/conf/FilterList-blacklisted-binary-packages")" && {
    echo "Skipping bundle '${bundle}' as it was not modified within the last ${LOOKBACK}"
    continue;
  }
  (
    set -x
    bundle apply --clean-commit ${bundle}
  ) 
done

