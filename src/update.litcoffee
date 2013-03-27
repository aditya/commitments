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

* Add in the task to git, this is our workflow tracking mechanism, but in the
correct directory.

        shell "cd '#{owner_directory}'; git add #{file_name}"

* Get the logical diff, relying on git, this will tell us data actions

        logical_diff = yaml.safeLoad $("commitments --directory '#{options.directory}' diff '#{full_file_name}'")

* Generate follow on actions from the diff

        console.log yaml.safeDump(logical_diff).info

* Execute followon actions, this is a generation step that will make a throw
away shell script, and is the real 'hard part' where activity takes place

* Commit the task
