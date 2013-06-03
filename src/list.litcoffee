List things, returning as JSON, this is used to fuel the user interface.

    fs = require 'fs'
    path = require 'path'
    yaml = require 'js-yaml'
    add = require './add'
    _ = require 'lodash'

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
        add options, true
        rank_file = path.join options.userDirectory, '.tasks.rank'
        if fs.existsSync rank_file
            rank = yaml.safeLoad(fs.readFileSync rank_file, 'utf8')
        else
            rank = []
        rank_order = {}
        _.forEach rank, (id, idx) ->
            rank_order[id] = idx + 1
        if options.archived
            dir = options.archiveDirectory
        else
            dir = options.userDirectory
        ret = []
        for name in fs.readdirSync dir
            if name.slice(-4) is 'yaml'
                try
                    content = fs.readFileSync(path.join(dir, name), 'utf8')
                    ret.push yaml.safeLoad(content)
                catch ex
                    console.error ex

Ordering is by explicit rank, and failing that defaults to when the item
was created.

        sorter = (item) ->
            rank_order[item.id] or item.when or Date.now()
        ret = _.sortBy ret, sorter

And emit items with a limit, this has a default value.

        limit = Number(options['--limit'] or 1024)
        ret = ret.slice 0, limit
        console.log JSON.stringify ret

    module.exports = (options) ->
        options.users and users options
        options.tasks and tasks options
