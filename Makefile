DIFF ?= git --no-pager diff --ignore-all-space --color-words --no-index
COMMITMENTS ?= ./bin/commitments --directory ./___

.PHONY: test

test: _init _add_user

_init:
	-rm -rf ./___
	$(COMMITMENTS) init | tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

_add_user: _init
	$(COMMITMENTS) add user bob | tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@
