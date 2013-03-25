
    path = require 'path'
    fs = require 'fs'
    require 'colors'
    require 'shellscript'

Here are the things we know how to add, just functions in scope.

    user = (options) ->
        user_directory = path.join options.directory, options['<name>']

        if not fs.existsSync user_directory
            fs.mkdirSync user_directory

        console.log $(git 'init', user_directory).info

All about adding all kinds of things.

    module.exports = (options) ->
        options.user and user options
