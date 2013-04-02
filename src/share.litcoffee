Sharing is about placing tasks in multiple user's directories, using links.

    path = require 'path'
    fs = require 'fs'
    yaml = require 'js-yaml'

    module.exports = (options) ->

Not a whole lot to do, just make sure the user exists, and then link across
to em.

        task = yaml.safeLoad(fs.readFileSync(options.taskfilename, 'utf8'))
        share_to = path.join process.env['COMMITMENTS_ROOT'],
            $("commitments add user '#{options.username}'")
        share_task_file = path.join(share_to, path.basename options.taskfilename)
        shell "ln  -s '#{options.taskfilename}' '#{share_task_file}'"
        shell "notify --to '#{options.username}' --tags 'share' --link '#{task.id}' --context '#{options.taskfilename}'"
