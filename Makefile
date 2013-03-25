DIFF ?= git --no-pager diff --ignore-all-space --color-words --no-index

.PHONY: test

test: _init

_init:
	-rm -rf ./___
	./bin/commitments --directory ./___ init > /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@
