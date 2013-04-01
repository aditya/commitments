Make isn't makefile, but I could not think of a better name for the script
that reads data from input, and well, makes things...

    _ = require 'lodash'

    module.exports = (options) ->

        yaml = require 'js-yaml'
        fs = require 'fs'
        path = require 'path'
        handlebars = require 'handlebars'
        context = yaml.safeLoad fs.readFileSync('/dev/stdin', 'utf8')

Make all the command line options visisble, let's hope they don't stomp :_

        _.extend context, options

A render, the convention is to look for things in the templates directory.

        handlebars.registerHelper 'eachProperty', (context, options) ->
            ret = ""
            for key, value of context
                ret += options.fn
                    key: key
                    value: value
            ret

        template_source = fs.readFileSync(
            path.join(__dirname, 'templates', "#{options['<template>']}.handlebars"),
            'utf8')
        template = handlebars.compile template_source
        process.stdout.write template(context).replace /\n+/g, "\n"
        process.stderr.write template(context).replace(/\n+/g, "\n").debug
