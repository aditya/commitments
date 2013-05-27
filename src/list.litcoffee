List things, returning as JSON, this is used to fuel the user interface.

    fs = require 'fs'
    path = require 'path'
    yaml = require 'js-yaml'
    add = require './add'

List all the user name directories. In practice this is a name of email addresses
that we can then load into a client side user autocomplete index.

    users = (options) ->
        ret = []
        for name in fs.readdirSync options.directory
            if name.slice(0,1) isnt '.'
                ret.push name
        console.log JSON.stringify ret

Listing all the tasks for a user, this ends up being a nice big JSON array and
uses the shared links to just get the content of shared tasks.

    tasks = (options) ->
        owner_directory = add options, true
        ret = []
        limit = Number(options['--limit'] or 1024)
        for name in fs.readdirSync owner_directory
            if name.slice(-4) is 'yaml'
                try
                    content = fs.readFileSync(path.join(owner_directory, name), 'utf8')
                    ret.push yaml.safeLoad(content)
                    if ret.length >= limit
                        break
                catch ex
                    console.error ex
        console.log JSON.stringify ret

    module.exports = (options) ->
        options.users and users options
        options.tasks and tasks options
