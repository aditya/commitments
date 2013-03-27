This is a logical diff, not a textual one. The idea is using a prior version
of a task item from git, you figure out which parts have changed, added, or
removed and then generate a yaml structure to be used as a rendering context
to then generate an actions script.

    path = require 'path'
    yaml = require 'js-yaml'
    fs = require 'fs'

    module.exports = (options) ->
        file_name = options['<taskfilename>']

* Need the current version

        current_version = yaml.safeLoad fs.readFileSync(file_name, 'utf8')

* Look a prior version if any

        prior_version = yaml.safeLoad $("cd #{path.dirname file_name}; git show HEAD~1:#{path.basename file_name}")
        if prior_version.fatal
            prior_version = {}


* Whip through the workflow affecting components, who, links, comments, and
todo state, comparing the prior and current as hash sets, subtracting in either
direction to figure what changed.

        diff =
            current: current_version

* Write out yaml that is the full current task, along with an array of changes

        console.log yaml.safeDump(diff)
