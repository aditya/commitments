    _ = require 'underscore'
    require('colors').setTheme
        info: 'green'
        error: 'red'
    #all our commands
    commands =
        init: require './init'
        add: require './add'

Making a little patch to require in order to get options, probably should
for docopt and add this feature.

    docopt = require 'docopt'
    fs = require 'fs'
    require.extensions['.docopt'] = (module, filename) ->
        doc = fs.readFileSync filename, 'utf8'
        module.exports =
            options: docopt.docopt doc, version: require('../package.json').version
            help: doc

The actual command line processing.

    cli = require './cli.docopt'

Full on help

    if cli.options['--help']
        console.log cli.help

Defaults, docopt isn't super smart about this part

    cli.options['--directory'] = cli.options['--directory'] or process.cwd
    for name, value of cli.options
        if name.slice(0,2) is '--'
            cli.options[name.slice(2)] = value

Commands that actually do things are in other modules

    for name in _.keys cli.options
        if cli.options[name] and commands[name]
            commands[name] cli.options
