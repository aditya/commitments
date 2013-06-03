Establish a stack rank. This is per user, and just stashes a file
with the rank ordering. This works in conjuction with list to get tasks
in sorted order.

    fs = require 'fs'
    path = require 'path'
    yaml = require 'js-yaml'
    add = require './add'

    tasks = (options) ->
        add options, true
        rank_file = path.join options.userDirectory, '.tasks.rank'
        fs.writeFileSync rank_file, yaml.safeDump(options.taskid)

    module.exports = (options) ->
        options.tasks and tasks options
