local fw = require('fw')

vim.api.nvim_create_user_command("Focuswatch", function(opts)
    fw.start(opts.args)
    -- fw.open_prompt()
end, {
    nargs = 1
})
