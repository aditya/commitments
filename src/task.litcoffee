Dealing with task workflow, the two interesting cases are done and undone, in
both case this is about notifying.

    module.exports = (options) ->
        if options.done
            shell "cat #{options.taskfilename}
            | commitments --directory '#{options.directory}' make task_done
            | $SHELL"
        if options.undone
            shell "cat #{options.taskfilename}
            | commitments --directory '#{options.directory}' make task_undone
            | $SHELL"


