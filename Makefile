DIFF?=git --no-pager diff --ignore-all-space --color-words --no-index
COMMITMENTS?=./bin/commitments --directory ./___

.PHONY: test

test:
	export PATH=$(PWD)/test/bin:$$PATH; export USER="howdy@hi.com"; $(MAKE) _init _add_user _list_user _task_create _task_id_default _task_workflow _task_archive

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
	#initial task
	cat test/samples/001.yaml | $(COMMITMENTS) update task | tee /tmp/$@
	cat test/samples/1-001.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	#and with a limit
	$(COMMITMENTS) list tasks wballard@glgroup.com --limit 1 | tee -a /tmp/$@
	#and re-rank them
	$(COMMITMENTS) rank tasks wballard@glgroup.com b a
	$(COMMITMENTS) list tasks wballard@glgroup.com --limit 1 | tee -a /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

_task_workflow: _init
	#shared results, there are tasks
	cat test/samples/001.yaml | $(COMMITMENTS) update task | tee /tmp/$@
	$(COMMITMENTS) list tasks wballard@glgroup.com | tee -a /tmp/$@
	#going through a simulated task workflow
	cat test/samples/002.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	cat test/samples/003.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	cat test/samples/004.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	#and a poke sequence
	cat test/samples/005.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	cat test/samples/006.yaml | $(COMMITMENTS) update task | tee -a /tmp/$@
	#unshared results, no more tasks
	$(COMMITMENTS) list tasks wballard@glgroup.com | tee -a /tmp/$@
	#and a delete
	cat test/samples/001.yaml | $(COMMITMENTS) delete task | tee -a /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

_task_id_default: _init
	cat test/samples/no_id.yaml | $(COMMITMENTS) update task | tee /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@

_task_archive: _init
	#initial task creates
	cat test/samples/001.yaml | $(COMMITMENTS) update task
	cat test/samples/1-001.yaml | $(COMMITMENTS) update task
	#to the archive with you!
	cat test/samples/001.yaml | $(COMMITMENTS) archive task | tee /tmp/$@
	#un-archived
	$(COMMITMENTS) list tasks kwokoek@glgroup.com | tee -a /tmp/$@
	#archived
	$(COMMITMENTS) list archived tasks kwokoek@glgroup.com | tee -a /tmp/$@
	$(DIFF) /tmp/$@ test/expected/$@
