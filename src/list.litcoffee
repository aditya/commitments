All about big lists of things, some more interesting than others. They all
take a pattern though that does a rough cut search. And by rough cut, at
the moment I just me a regex.

    fs = require 'fs'

    users = (options) ->
        ret = []
        for name in fs.readdirSync options.directory
            if name.slice(0,1) isnt '.'
                ret.push name
        console.log JSON.stringify ret

    module.exports = (options) ->
        options.users and users options
