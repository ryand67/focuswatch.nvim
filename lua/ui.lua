local M = {}

function M.window_center(input_width)
    return {
        relative = "win",
        row = vim.api.nvim_win_get_height(0) / 2 - 1,
        col = vim.api.nvim_win_get_width(0) / 2 - input_width / 2
    }
end

---Launches input prompt
---@param on_confirm function function to run on confirm of input
function M.input(on_confirm)
    local prompt = "Timer: #m#s"
    local default_entry = ""

    local prompt_width = vim.str_utfindex(prompt) + 10

    local win_config = {
        focusable = true,
        style     = "minimal",
        border    = "rounded",
        width     = prompt_width,
        height    = 1,
        title     = prompt
    }

    win_config = vim.tbl_deep_extend("force", win_config, M.window_center(prompt_width))

    local buffer = vim.api.nvim_create_buf(false, true)
    local window = vim.api.nvim_open_win(buffer, true, win_config)
    vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { default_entry })

    -- Put cursor at the end of the default value
    vim.cmd('startinsert')
    vim.api.nvim_win_set_cursor(window, { 1, vim.str_utfindex(default_entry) + 1 })

    -- Enter to confirm
    vim.keymap.set({ 'n', 'i', 'v' }, '<cr>', function()
        local lines = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)
        if lines[1] ~= default_entry and on_confirm then
            on_confirm(lines[1])
        end
        vim.api.nvim_win_close(window, true)
        vim.cmd('stopinsert')
    end, { buffer = buffer })

    -- Esc or q to close
    vim.keymap.set("n", "<esc>", function() vim.api.nvim_win_close(window, true) end, { buffer = buffer })
    vim.keymap.set("n", "q", function() vim.api.nvim_win_close(window, true) end, { buffer = buffer })
end

return M
