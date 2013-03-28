Make isn't makefile, but I could not think of a better name for the script
that reads data from input, and well, makes things...

    module.exports = (options) ->

        yaml = require 'js-yaml'
        fs = require 'fs'
        path = require 'path'
        mustache = require 'mu2'
        context = yaml.safeLoad(fs.readFileSync('/dev/stdin', 'utf8'))
        stream = mustache.compileAndRender(
            path.join(__dirname, 'templates', "#{options['<template>']}.mustache"),
            context)
        stream.pipe process.stdout
