Delete simply empties out the file, and then relies on the git based workflow.

    shared = require './shared'
    fs = require 'fs'
    path = require 'path'
    add = require './add'
    yaml = require 'js-yaml'

    module.exports = (options) ->

Not very exciting, but get the task from stdin.

        buffers = []
        process.stdin.on 'data', (chunk) ->
            buffers.push chunk
        process.stdin.on 'end', ->
            task_content = Buffer.concat(buffers).toString()
            task = yaml.safeLoad(task_content)
            task.id = task.id or md5(task_content)

* Make sure the owner exists, self shelling to get the user directory

            options.username = task.who
            options.taskid = task.id
            owner_directory = add options, true

* Empty out the task file

            file_name = "#{task.id}.yaml"
            full_file_name = path.resolve path.join(owner_directory, file_name)
            shell "cd $COMMITMENTS_ROOT; cd #{owner_directory}; git rm --force #{file_name}"

* Run the shared workflow, now with an emptied out task to drive proper diff

            deleted_task =
                who: task.who
                id: task.id
            shared.workflow deleted_task, options
            console.log "#{task.id} deleted".info

* Go!

        process.stdin.resume()
