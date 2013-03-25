All about big lists of things, some more interesting than others. They all
take a pattern though that does a rough cut search. And by rough cut, at
the moment I just me a regex.

    fs = require 'fs'

    users = (options) ->
        if options['<query>']
            query = new RegExp(options['<query>'])
            match = (x) -> query.test x
        else
            match = (x) -> true
        for name in fs.readdirSync options.directory
            if name.slice(0,1) isnt '.' and match(name)
                console.log name

    module.exports = (options) ->
        options.users and users options
