Sharing is about placing tasks in multiple user's directories, using links.

    path = require 'path'

    module.exports = (options) ->

Not a whole lot to do, just make sure the user exists, and then link across
to em.

        share_to = $ "commitments --directory '#{options.directory}' add user '#{options.username}'"
        share_task_file = path.join(share_to, path.basename options.taskfilename)
        shell "ln  -s '#{options.taskfilename}' '#{share_task_file}'"
