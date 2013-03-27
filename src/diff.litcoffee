This is a logical diff, not a textual one. The idea is using a prior version
of a task item from git, you figure out which parts have changed, added, or
removed and then generate a yaml structure to be used as a rendering context
to then generate an actions script.

    path = require 'path'
    yaml = require 'js-yaml'
    fs = require 'fs'
    _ = require 'lodash'
    md5 = require 'MD5'

    module.exports = (options) ->
        file_name = options['<taskfilename>']

* Need the current version

        current_version = yaml.safeLoad fs.readFileSync(file_name, 'utf8')

* Look a prior version if any

        prior_version = yaml.safeLoad $("cd #{path.dirname file_name}; git show HEAD~1:#{path.basename file_name}")
        if prior_version.fatal
            prior_version = {}


* Whip through the workflow affecting components, who, links, comments, and
todo state, comparing the prior and current, subtracting in either
direction to figure what changed.

        diff =
            current: current_version
            added_links: _.difference _.keys(current_version.links) or [],
                _.keys(prior_version.links) or []
            removed_links: _.difference _.keys(prior_version.links) or [],
                _.keys(current_version.links) or []
            added_tags: _.difference _.keys(current_version.tags) or [],
                _.keys(prior_version.tags) or []
            removed_tags: _.difference _.keys(prior_version.tags) or [],
                _.keys(current_version.tags) or []

* Figuring changed comments is a tad more work, make a synthetic content key
to figure the changed ones. Don't worry about removed ones, there isn't
a workflow for that case since comments are just about notification.

        current_comments = { md5(_.values(comment).join('')): comment
            for comment in (current_comments?.discussion?.comments or {})}

* Write out yaml that is the full current task, along with an array of changes

        console.log yaml.safeDump(diff)
