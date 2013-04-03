Shared bits of update and delete, this is the 'workflow' step.

    yaml = require 'js-yaml'
    fs = require 'fs'
    path = require 'path'
    md5 = require 'MD5'
    _ = require 'lodash'

    module.exports.workflow = (task, options) ->


* Make sure the owner exists, self shelling to get the user directory

        owner_directory = path.join process.env['COMMITMENTS_ROOT'],
            $("commitments add user '#{task.who}'")
        file_name = "#{task.id}.yaml"
        full_file_name = path.resolve path.join(owner_directory, file_name)

* Get the logical diff, relying on git, this will tell us data actions, and pipe
it to generate the workflow.

        current_version = task
        prior_version = (yaml.safeLoad $("cd #{owner_directory}; git show HEAD:#{file_name}") or '') or {}
        diff =
            file_name: path.relative process.env['COMMITMENTS_ROOT'], full_file_name
            task_done: (current_version.done and (not prior_version.done)) or false
            task_undone: (prior_version.done and (not current_version.done)) or false
            added_links: _.difference _.keys(current_version.links) or [],
                _.keys(prior_version.links) or []
            removed_links: _.difference _.keys(prior_version.links) or [],
                _.keys(current_version.links) or []
            current_version: current_version
            prior_version: prior_version

* Looking at comments, find any comment that has a hash not in the prior version
this will catch content changes as well as adds.

        prior_comments = {}
        for comment in (prior_version?.discussion?.comments or [])
            prior_comments[comment.hash] = comment
        diff.updated_comments = []
        for comment in (current_version?.discussion?.comments or [])
            if not prior_comments[comment.hash]
                diff.updated_comments.push comment

* Write out the diff generated script, and then shell it

        todo = render 'workflow', diff
        console.log todo.info
        todo_file = "/tmp/#{md5(todo)}"
        fs.writeFileSync todo_file, todo
        shell "cat '#{todo_file}'
        | $SHELL", true
        fs.unlinkSync todo_file

* Commit the task to git, this lets us see prior versions, and we will on get
here if there were no errors causing an abort above

        #running these without a subshell
        $ "git", "--git-dir", "#{owner_directory}/.git",
            "--work-tree", owner_directory,
            "add", full_file_name
        console.log "#{file_name} added".info
        $ "git", "--git-dir", "#{owner_directory}/.git",
            "--work-tree", owner_directory,
            "commit", "--allow-empty-message", "--message", "''"

