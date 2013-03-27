All about adding all kinds of things.

    path = require 'path'
    fs = require 'fs'

Adding a user is about creating a git repository. We'll be nice and make sure
the user name is lower case, but otherwise is expected to be an email and won't
get any additional escaping.

    user = (options) ->
        user_directory = path.join options.directory, options['<username>'].toLowerCase()
        if not fs.existsSync user_directory
            fs.mkdirSync user_directory
        console.log $("git init '#{user_directory}'").info

And here is the actual add, just looking for the sub command as needed.

    module.exports = (options) ->
        options.user and user options
