Return metadata about a user, tack on properties useful to a client application.

    fs = require 'fs'
    path = require 'path'
    add = require './add'

    module.exports = (options) ->
        about =
            username: options.username
            directory: add options, true
        console.log JSON.stringify(about)
