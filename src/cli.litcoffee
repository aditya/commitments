This is the command line interface main entry point, set up the required
modules and the command sub modules here.

    _ = require 'underscore'
    require('shellscript').globalize()
    path = require 'path'
    require('colors').setTheme
        info: 'green'
        error: 'red'
        warn: 'yellow'
    #all our commands, there has to be a way to do this
    #without being so pedantic
    commands =
        init: require './init'
        add: require './add'
        list: require './list'
        update: require './update'
        diff: require './diff'
        make: require './make'
        commit: require './commit'

This is going last on purpose, hooks into global, thus looking to only interfere
after everyone else has had a normal experience.


Update the system path to allow self shelling.

    process.env['PATH'] = "#{path.join(__dirname, '../bin')}:#{process.env['PATH']}"

Making a little patch to require in order to get options, probably should
fork docopt and add this feature.

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

    cli.options['--directory'] = cli.options['--directory'] or process.cwd()
    for name, value of cli.options
        if name.slice(0,2) is '--'
            cli.options[name.slice(2)] = value

Commands that actually do things are in other modules, and are called here

    for name in _.keys cli.options
        if cli.options[name] and commands[name]
            commands[name] cli.options
