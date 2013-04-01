All about adding all kinds of things.

    path = require 'path'
    fs = require 'fs'

Adding a user is about creating a git repository. We'll be nice and make sure
the user name is lower case, but otherwise is expected to be an email and won't
get any additional escaping.

    user = (options) ->
        username = options['<username>'].toLowerCase()
        user_directory = path.join options.directory, username
        if not fs.existsSync user_directory
            fs.mkdirSync user_directory
        #just to discard the output here
        $ "git", "--git-dir", "#{user_directory}/.git",
            "--work-tree", user_directory,
            "init", "--shared"

Just print the created directory, this way we can use this command in scripts.

        process.stdout.write "#{user_directory}"

And here is the actual add, just looking for the sub command as needed.

    module.exports = (options) ->
        options.user and user options
