Update's main thing is updating tasks, which ends up being a compound action.
Here is the outline of the workflow:

    yaml = require 'js-yaml'
    fs = require 'fs'
    path = require 'path'
    md5 = require 'MD5'
    _ = require 'lodash'

All about updating tasks.

    module.exports = (options) ->

* Not very exciting, but get the task from stdin.

        task_content = fs.readFileSync('/dev/stdin', 'utf8')
        task = yaml.safeLoad(task_content)
        task.id = task.id or md5(task_content)

* Comments get synthetic keys based on their content. You never update them by
key, which is to say, once a comment is edited, it is no longer the same.

        contentKey = (object) ->
            md5(_.values(object).join(''))
        for comment in (task?.discussion?.comments or [])
            comment.hash = contentKey comment

* Make sure the owner exists, self shelling to get the user directory

        owner_directory = path.join process.env['COMMITMENTS_ROOT'],
            $("commitments add user '#{task.who}'")

* Write out the task in the owner's repository

        file_name = "#{task.id}.yaml"
        full_file_name = path.resolve path.join(owner_directory, file_name)
        fs.writeFileSync full_file_name, yaml.safeDump(task)

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
        current_comments = _.pluck current_version?.discussion?.comments, 'hash'
        hash_comments = {}
        for comment in (current_version?.discussion?.comments or [])
            hash_comments[comment.hash] = comment
        prior_comments = _.pluck prior_version?.discussion?.comments, 'hash'
        diff.updated_comments = _.map(
            _.difference(current_comments, prior_comments),
            (x) -> hash_comments[x])

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

* Write back the fully updated task, as it may have an .id defaulted as well
as comment hashes

        console.log yaml.safeDump task
