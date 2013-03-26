This is a logical diff, not a textual one. The idea is using a prior version
of a task item from git, you figure out which parts have changed, added, or
removed and then generate a yaml structure to be used as a rendering context
to then generate an actions script.

* Look a prior version if any

* Whip through the workflow affecting components, who, links, comments, and
todo state, comparing the prior and current as hash sets, subtracting in either
direction to figure what changed.

* Write out yaml that is the full current task, along with an array of changes
