Unsharing just takes links away.

    path = require 'path'
    fs = require 'fs'
    yaml = require 'js-yaml'

    module.exports = (options) ->

Not a whole lot to do, just make sure the user exists, and unlink. Seems a bit
silly to make sure the user exists, but it is a nice way to get the user
directory

        task = yaml.safeLoad(fs.readFileSync(options.taskfilename, 'utf8'))
        share_to = path.join process.env['COMMITMENTS_ROOT'],
            $("commitments add user '#{options.username}'")
        share_task_file = path.join(share_to, path.basename options.taskfilename)
        shell "rm '#{share_task_file}'"
        shell "notify --to '#{options.username}' --tags 'unshare' --link '#{task.id}' --context '#{options.taskfilename}'"
