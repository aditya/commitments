Archive moves the task, and unlinks from other users.

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
            add options, true

* Run the shared workflow, this generates and runs shell script

            deleted_task =
                who: task.who
                id: task.id
            shared.archive task, options
            console.log "#{task.id} archived".info

* Go!

        process.stdin.resume()
