local fw = require('fw')
Timer = vim.loop.new_timer()

vim.api.nvim_create_user_command("Focuswatch", function(opts)
    fw.start(opts.args, Timer)
end, {
    nargs = 1
})
