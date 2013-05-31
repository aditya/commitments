Shared bits of update and delete, this is the 'workflow' step.

    yaml = require 'js-yaml'
    fs = require 'fs'
    path = require 'path'
    md5 = require 'MD5'
    _ = require 'lodash'
    add = require './add'

The primary workflow:

    module.exports.workflow = (task, options) ->

* Make sure the owner exists, self shelling to get the user directory

        options.username = task.who
        owner_directory = add options, true
        file_name = "#{task.id}.yaml"
        full_file_name = path.resolve path.join(owner_directory, file_name)

* Get the logical diff, relying on git, this will tell us data actions, and pipe
it to generate the workflow.

        current_version = task
        prior_version = (yaml.safeLoad $("cd #{owner_directory}; git show HEAD:#{file_name}") or '') or {}
        diff =
            owner: task.who
            owner_directory: owner_directory
            file_name: path.relative options.directory, full_file_name
            task_done: (current_version.done and (not prior_version.done)) or false
            task_undone: (prior_version.done and (not current_version.done)) or false
            added_links: _.difference _.keys(current_version.links) or [],
                _.keys(prior_version.links) or []
            removed_links: _.difference _.keys(prior_version.links) or [],
                _.keys(current_version.links) or []
            new_accept: _.difference _.keys(current_version.accept) or [],
                _.keys(prior_version.accept) or []
            new_reject: _.difference _.keys(current_version.reject) or [],
                _.keys(prior_version.reject) or []
            everyone: _.filter _.union([current_version.who], [prior_version.who], _.keys(prior_version.links), _.keys(current_version.links)), (x) -> x and x.length
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

The archive workflow:

    module.exports.archive = (task, options) ->

        options.username = task.who
        task.owner_directory = owner_directory = add options, true
        task.file_name = file_name = "#{task.id}.yaml"
        task.full_file_name = path.resolve path.join(options.userDirectory, file_name)
        task.archive_file_name = path.resolve path.join(options.archiveDirectory, file_name)

* Write out the diff generated script, and then shell it

        todo = render 'archive', task
        console.log todo.info
        todo_file = "/tmp/#{md5(todo)}"
        fs.writeFileSync todo_file, todo
        shell "cat '#{todo_file}'
        | $SHELL", true
        fs.unlinkSync todo_file
