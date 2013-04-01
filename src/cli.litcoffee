This is the command line interface main entry point, set up the required
modules and the command sub modules here.

    _ = require 'lodash'
    require('shellscript').globalize()
    path = require 'path'
    fs = require 'fs'
    require('colors').setTheme
        info: 'green'
        error: 'red'
        warn: 'yellow'
        debug: 'blue'
    #color!
    console.error_save = console.error
    console.error = (args...)->
        colorized = _.map args, ((x) -> x.error)
        console.error_save.apply null, colorized

    #all of our commands, like we did back in CME
    commands = {}
    for file in fs.readdirSync __dirname
        if path.extname(file) is '.litcoffee'
            commands[path.basename file, '.litcoffee'] = require("./#{file}")

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

Defaults, docopt isn't super smart about this part, so scrub some options.

    cli.options['--directory'] = cli.options['--directory'] or process.cwd()
    for name, value of cli.options
        if name.slice(0,2) is '--'
            cli.options[name.slice(2)] = value
        if name.slice(0,1) is '<' and name.slice(-1) is '>'
            cli.options[name.slice(1,-1)] = value

Debugging information helps sometimes

    if cli.options['--debug']
        console.log cli.options

Commands that actually do things are in other modules, and are called here

    for name in _.keys cli.options
        if cli.options[name] and commands[name]
            commands[name] cli.options
