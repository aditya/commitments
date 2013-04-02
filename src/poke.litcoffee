Poke is a nice way to nag someone for status, in a nice passive aggressive
way where you just push a button on the screen, and the computer is the bad guy.

    fs = require 'fs'
    path = require 'path'

    module.exports = (options) ->

OK, you will only be able to poke folks about tasks actually in their list.
Given that we are doing the lookup based on who and task id.

        owner_directory = path.join process.env['COMMITMENTS_ROOT'],
            $("commitments add user '#{options.username}'")
        task_file = path.join owner_directory, "#{options.taskid}.yaml"
        if fs.existsSync task_file
            console.log "Poking #{options.username} about #{options.taskid}".info
            shell "notify set --to '#{options.username}' --tags 'poke' --link '#{options.taskid}' --context '#{task_file}'"
        else
            console.log "Poking #{options.username} about #{options.taskid} is hard since they don't have the task".error
