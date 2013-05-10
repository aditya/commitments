 is a nice way to nag someone for status, in a nice passive aggressive
way where you just push a button on the screen, and the computer is the bad guy.

    fs = require 'fs'
    path = require 'path'
    yaml = require 'js-yaml'
    add = require './add'
    _ = require 'lodash'

    module.exports = (options) ->

Not very exciting, but get the task from stdin.

        task_content = fs.readFileSync('/dev/stdin', 'utf8')
        task = yaml.safeLoad(task_content)

OK, you will only be able to  folks about tasks actually in their list.
Given that we are doing the lookup based on who and task id.

        options.username = task.who
        owner_directory = add options, true
        task_file = path.join owner_directory, "#{task.id}.yaml"
        if fs.existsSync task_file
            users = _.keys(task.links or {})
            users.push task.who
            for username in users
                console.log "Poking #{username} about #{task.id}".info
                shell "notify send '#{username}' --tags '' --link '#{task.id}' --context '#{task_file}' --from \"$USER\""
