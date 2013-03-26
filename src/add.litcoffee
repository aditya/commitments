All about adding all kinds of things.

    path = require 'path'
    fs = require 'fs'

Here are the things we know how to add, just functions in scope.

    user = (options) ->
        user_directory = path.join options.directory, options['<username>']
        if not fs.existsSync user_directory
            fs.mkdirSync user_directory
        console.log $(git 'init', user_directory).info

And here is the actual add, just looking for the sub command as needed.

    module.exports = (options) ->
        options.user and user options
