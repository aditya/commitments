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
    console.log cli.options

Full on help

    if options['--help']
        console.log cli.help

