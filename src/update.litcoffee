Update's main thing is updating tasks, which ends up being a compound action.
Here is the outline of the workflow:

    yaml = require 'js-yaml'
    fs = require 'fs'
    path = require 'path'

    module.exports = (options) ->

* Figure out who is the owner, which isn't exciting it is a property lookup

        task = yaml.safeLoad(fs.readFileSync('/dev/stdin', 'utf8'))

* Make sure the owner exists, self shelling

        shell "commitments --directory '#{options.directory}' add user '#{task.who}'"

* Write out the task in the owner's repository

        owner_directory = path.resolve path.join(options.directory, task.who.toLowerCase())
        file_name = "#{task.id}.yaml"
        full_file_name = path.resolve path.join(owner_directory, file_name)
        fs.writeFileSync full_file_name, yaml.safeDump(task)
        console.log "#{file_name} written".info

* Get the logical diff, relying on git, this will tell us data actions, and pipe
it to generate the workflow.

        shell "commitments --directory '#{options.directory}' diff '#{full_file_name}'
        | commitments --directory '#{options.directory}'  make workflow
        | tee '#{full_file_name}.actions'"

* Commit the task

        shell "commitments --directory '#{options.directory}' commit '#{full_file_name}'"
