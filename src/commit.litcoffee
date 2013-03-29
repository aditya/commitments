Commit a task once the workflow is complete.

    path = require 'path'

    module.exports = (options) ->
        full_file_name = options['<taskfilename>']
        owner_repository = path.dirname full_file_name
        relative_task_file = path.basename full_file_name

* Add in the task to git, this is our workflow tracking mechanism, but in the
correct directory.

        $("cd '#{owner_repository}'; git add #{relative_task_file}")

* Commit the task to git, now we are all done

        $("cd '#{owner_repository}'; git commit --file #{full_file_name}.actions")
        $("rm '#{full_file_name}.actions'")

