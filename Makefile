DIFF ?= git --no-pager diff --ignore-all-space --color-words --no-index
COMMITMENTS ?= ./bin/commitments --directory ./___

.PHONY: test

test: _init _add_user _list_user _task_create

test_pass:
	DIFF=cp $(MAKE) test

_init:
	-rm -rf ./___
	$(COMMITMENTS) init | tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

_add_user: _init
	$(COMMITMENTS) add user bob | tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@
	$(COMMITMENTS) add user jim | tee /tmp/$@

_list_user: _add_user
	$(COMMITMENTS) list users | tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

_task_create: _init
	$(COMMITMENTS) add user kwokoek@glgroup.com | tee /tmp/$@
	#initial task
	time cat test/samples/001.yaml | $(COMMITMENTS) update task | tee /tmp/$@
	#shared results, there are tasks
	time cat test/samples/001.yaml | $(COMMITMENTS) list tasks wballard@glgroup.com | tee -a /tmp/$@
	#no update
	time cat test/samples/001.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	#going through a simulated task workflow
	time cat test/samples/002.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	time cat test/samples/003.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	time cat test/samples/004.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	#unshared results, no more tasks
	time cat test/samples/001.yaml | $(COMMITMENTS) list tasks wballard@glgroup.com | tee -a /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@
