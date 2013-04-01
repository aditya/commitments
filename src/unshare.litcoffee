Unsharing just takes links away.

    path = require 'path'

    module.exports = (options) ->

Not a whole lot to do, just make sure the user exists, and unlink. Seems a bit
silly to make sure the user exists, but it is a nice way to get the user
directory

        share_to = $ "commitments --directory '#{options.directory}' add user '#{options.username}'"
        share_task_file = path.join(share_to, path.basename options.taskfilename)
        shell "rm '#{share_task_file}'"
