Delete simply empties out the file, and then relies on the git based workflow.

    shared = require './shared'
    fs = require 'fs'
    path = require 'path'
    add = require './add'

    module.exports = (options) ->
        task =
            id: options.taskid
            who: options.username

* Make sure the owner exists, self shelling to get the user directory

        owner_directory = add options

* Empty out the task file

        file_name = "#{task.id}.yaml"
        full_file_name = path.resolve path.join(owner_directory, file_name)
        shell "cd $COMMITMENTS_ROOT; cd #{owner_directory}; git rm --force #{file_name}"

* Run the shared workflow

        shared.workflow task, options
        console.log "#{task.id} deleted by #{task.who}".info
