This is the command line interface main entry point, set up the required
modules and the command sub modules here.

    commands =
        add: require './add'
        list: require './list'
        update: require './update'
        init: require './init'
        poke: require './poke'
        delete: require './delete'
    _ = require 'lodash'
    docopt = require 'docopt'
    handlebars = require 'handlebars'
    path = require 'path'
    fs = require 'fs'
    require('colors').setTheme
        info: 'green'
        error: 'red'
        warn: 'yellow'
        debug: 'blue'
    require('shellscript').globalize()

Color!

    console.error_save = console.error
    console.error = (args...)->
        colorized = _.map args, ((x) -> x.error)
        console.error_save.apply null, colorized

Update the system path to allow self shelling.

    process.env['PATH'] = "#{path.join(__dirname, '../bin')}:#{process.env['PATH']}"

Making a little patch to require in order to get options, probably should
fork docopt and add this feature.

    require.extensions['.docopt'] = (module, filename) ->
        doc = fs.readFileSync filename, 'utf8'
        module.exports =
            options: docopt.docopt doc, version: require('../package.json').version
            help: doc

The actual command line processing.

    cli = require './cli.docopt'

Code generation support.

    handlebars.registerHelper 'eachProperty', (context, options) ->
        ret = ""
        for key, value of context
            ret += options.fn
                key: key
                value: value
        ret
    global.render = (template, context) ->
        context = _.extend {}, cli.options, context
        template_source = fs.readFileSync(
            path.join(__dirname, 'templates', "#{template}.handlebars"),
            'utf8')
        template = handlebars.compile template_source
        template(context).replace /\n+/g, "\n"

Full on help

    if cli.options['--help']
        console.log cli.help

Commitements root directory needs to be in the environment

    if not process.env['COMMITMENTS_ROOT']
        process.env['COMMITMENTS_ROOT'] =
            path.resolve cli.options['--directory'] or process.env['COMMITMENTS_ROOT'] or process.cwd()

Defaults, docopt isn't super smart about this part, so scrub some options.

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
