Commit a task once the workflow is complete.

    path = require 'path'

    module.exports = (options) ->
        full_file_name = path.resolve options['<taskfilename>']
        owner_repository = path.dirname full_file_name
        relative_task_file = path.basename full_file_name

* Add in the task to git, this is our workflow tracking mechanism, but in the
correct directory.

        #running these without a subshell
        $ "git", "--git-dir", "#{owner_repository}/.git",
            "--work-tree", owner_repository,
            "add", full_file_name
        console.log "#{relative_task_file} added".info

        $ "git", "--git-dir", "#{owner_repository}/.git",
            "--work-tree", owner_repository,
            "commit", "--allow-empty-message", "--message", "''"

