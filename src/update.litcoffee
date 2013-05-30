Update's main thing is updating tasks, which ends up being a compound action.
Here is the outline of the workflow:

    yaml = require 'js-yaml'
    fs = require 'fs'
    path = require 'path'
    md5 = require 'MD5'
    _ = require 'lodash'
    shared = require './shared'
    add = require './add'

All about updating tasks.

    module.exports = (options) ->

Not very exciting, but get the task from stdin.

        buffers = []
        process.stdin.on 'data', (chunk) ->
            buffers.push chunk
        process.stdin.on 'end', ->
            task_content = Buffer.concat(buffers).toString()
            task = yaml.safeLoad(task_content)
            task.id = task.id or md5(task_content)

Make sure the owner exists, self shelling to get the user directory

            options.username = task.who
            owner_directory = add options, true
            file_name = "#{task.id}.yaml"
            full_file_name = path.resolve path.join(owner_directory, file_name)

Comments get synthetic keys based on their content. You never update them by
key, which is to say, once a comment is edited, it is no longer the same.

            for comment in (task?.discussion?.comments or [])
                comment.hash = md5(comment.what or '')

Write out the task in the owner's repository, classic tmp then rename to make
sure any concurrent reads of the directory for yaml files don't get partials

            fs.writeFileSync full_file_name + ".tmp", yaml.safeDump(task)
            fs.renameSync full_file_name + ".tmp", full_file_name

Run the workflow

            shared.workflow task, options

Write back the fully updated task, as it may have an .id defaulted as well
as comment hashes

            console.log yaml.safeDump task

Kick it all off...

        process.stdin.resume()
