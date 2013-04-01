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
        full_file_name = options['<taskfilename>']
        owner_repository = path.dirname full_file_name
        relative_task_file = path.basename full_file_name
        #handy helpers
        contentKey = (object) ->
            md5(_.values(object).join(''))
        hash_em = (comments) ->
            for comment in comments
                comment.hash = contentKey comment

* Need the current version

        current_version = yaml.safeLoad fs.readFileSync(full_file_name, 'utf8')
        hash_em current_version?.discussion?.comments or []

* Look for a prior committed version if any

        prior_version = $("cd #{owner_repository}; git show HEAD:#{relative_task_file}")
        if prior_version
            prior_version = yaml.safeLoad prior_version
        else
            prior_version = {}
        hash_em prior_version?.discussion?.comments or []


* Whip through the workflow affecting components, who, links, comments, and
todo state, comparing the prior and current, subtracting in either
direction to figure what changed.

        diff =
            file_name: full_file_name
            task_done: (current_version.done and (not prior_version.done)) or false
            task_undone: (prior_version.done and (not current_version.done)) or false
            added_links: _.difference _.keys(current_version.links) or [],
                _.keys(prior_version.links) or []
            removed_links: _.difference _.keys(prior_version.links) or [],
                _.keys(current_version.links) or []
            current_version: current_version
            prior_version: prior_version

* Figuring changed comments is a tad more work, make a synthetic content key
to figure the changed ones. Don't worry about removed ones, there isn't
a workflow for that case since comments are just about notification.

        current_comments = _.pluck current_version?.discussion?.comments, 'hash'
        hash_comments = {}
        for comment in current_version?.discussion?.comments
            hash_comments[comment.hash] = comment
        prior_comments = _.pluck prior_version?.discussion?.comments, 'hash'

        diff.updated_comments = _.map(
            _.difference(current_comments, prior_comments),
            (x) -> hash_comments[x])

* Write out yaml that is the full current task, along with an array of changes

        process.stdout.write yaml.safeDump(diff)
