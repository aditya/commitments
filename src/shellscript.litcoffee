Make coffeescript a lot more like shell script with these handy global functions.

    shelljs = require 'shelljs'
    child_process = require 'child_process'


First off, make a subshell like function that will take any string pipeline, run
it, and then return stdout as a string, while piping stderr. Much like `` or $()
in plain old bash.

    global.$ = (shell_commands) ->
        shelljs.config.silent = true
        results = shelljs.exec shell_commands
        global['$?'] = results.code
        if Array.isArray results.output
            return results.output.join ''
        else
            return results.output

And a just plain run function that pipes output, returning the exit code.

    global.shell = (shell_commands) ->
        shelljs.config.silent = false
        shelljs.exec(shell_commands).code

