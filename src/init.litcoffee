Initialize a repository with git and configuration. A repository is a combination
of a root directory, then one git repository per user.

    yaml = require 'js-yaml'
    path = require 'path'
    fs = require 'fs'
    require 'colors'
    module.exports = (options) ->
        console.log 'initializing'.info

Be a sport and make sure the directory exists

        if not fs.existsSync options.directory
            fs.mkdirSync options.directory

I guess we need some kind of marker file, sooner or later there may be
something interesting to put in it.

        config_file = path.join options.directory, '.commitments'
        if fs.existsSync config_file
            console.log "already initialized".error
            process.exit 1
        else
            config =
                created: Date.now()
            fs.writeFileSync config_file,  yaml.safeDump config
            console.log "configuration: #{config_file}".green

