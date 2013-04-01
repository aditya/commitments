Dealing with task workflow, the two interesting cases are done and undone, in
both case this is about notifying.

    module.exports = (options) ->
        if options.done
            shell "commitments --directory '#{options.directory}' make task_done '#{options.taskfilename}'
            | $SHELL"
        if options.undone
            shell "commitments --directory '#{options.directory}' make task_undone '#{options.taskfilename}'
            | $SHELL"

