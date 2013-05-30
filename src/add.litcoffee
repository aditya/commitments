All about adding all kinds of things.

    path = require 'path'
    fs = require 'fs'
    add = require './add'

Adding a user is about creating a git repository. We'll be nice and make sure
the user name is lower case, but otherwise is expected to be an email and won't
get any additional escaping.

    module.exports = (options, silent) ->
        username = options.username.toLowerCase()
        options.userDirectory = user_directory = path.join options.directory, username
        options.archiveDirectory = archive_directory = path.join user_directory, '.archive'
        if not fs.existsSync user_directory
            fs.mkdirSync user_directory
        if not fs.existsSync archive_directory
            fs.mkdirSync archive_directory
        #just to discard the output here
        $ "git", "--git-dir", "#{user_directory}/.git",
            "--work-tree", user_directory,
            "init", "--shared"

Just print the created directory, this way we can use this command in scripts.

        if not silent
            process.stdout.write path.relative options.directory, "#{user_directory}"
            process.stdout.write '\n'

And always come back with the user directory so that this can be chained without
needed to fork, as this is used commonly.

        user_directory
