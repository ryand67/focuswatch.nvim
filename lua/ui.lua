local M = {}

function M.window_center(input_width)
    return {
        relative = "win",
        row = vim.api.nvim_win_get_height(0) / 2 - 1,
        col = vim.api.nvim_win_get_width(0) / 2 - input_width / 2
    }
end

M.namespace_id = vim.api.nvim_create_namespace('focuswatch')

---Launches input prompt
---@param on_confirm function function to run on confirm of input
function M.input(on_confirm)
    local prompt = "Timer: #m#s"
    local default_entry = ""

    local prompt_width = vim.str_utfindex(prompt) + 10

    local win_config = M.win_config(prompt_width, prompt)

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

---win_config for nvim ui
---@param prompt_width number width of prompt for use in calcultaing middle
---@param prompt string prompt to have in the input box
---@return table table of config options
function M.win_config(prompt_width, prompt)
    if prompt_width < 1 then
        prompt_width = 1
    end

    local win_config = {
        focusable = true,
        style     = "minimal",
        border    = "rounded",
        width     = prompt_width,
        height    = 1,
        title     = prompt
    }

    win_config = vim.tbl_deep_extend("force", win_config, M.window_center(prompt_width))

    return win_config
end

M.notify_levels = {
    INFO = "Notification",
    ERROR = "Error"
}

---Notifies user with a given message
---@param message string message to notify
---@param level string level to notify
function M.notify(message, level)
    local win_config = M.win_config(vim.str_utfindex(message), "Focuswatch " .. level)

    local buffer = vim.api.nvim_create_buf(false, true)
    local window = vim.api.nvim_open_win(buffer, true, win_config)
    vim.api.nvim_buf_set_text(buffer, 0, 0, 0, 0, { message })
    vim.api.nvim_buf_set_option(buffer, 'readonly', true)


    local close_win = function()
        vim.api.nvim_win_close(window, true)
    end

    -- Enter, Esc, or q to close
    vim.keymap.set({ 'n', 'i', 'v' }, '<cr>', close_win, { buffer = buffer })
    vim.keymap.set("n", "<esc>", close_win, { buffer = buffer })
    vim.keymap.set("n", "q", close_win, { buffer = buffer })
end

function calc_line_num()
    local win_width = vim.api.nvim_win_get_width(0)
    local cur = vim.api.nvim_win_get_cursor(0)[1]

    return cur - 1
end

---displays seconds left with virtual text
---@param seconds string formatted string of time left in timer
---@param ext_mark_id number | nil ext_mark id
function M.display_seconds(seconds, ext_mark_id)
    local buf = vim.api.nvim_get_current_buf()

    if ext_mark_id ~= nil then
        return vim.api.nvim_buf_set_extmark(buf, M.namespace_id, calc_line_num(), 0, {
            virt_text_pos = "right_align",
            id = ext_mark_id,
            virt_text = { { seconds, '' } }
        })
    else
        return vim.api.nvim_buf_set_extmark(buf, M.namespace_id, calc_line_num(), 0, {
            virt_text_pos = "right_align",
            virt_text = { { seconds, '' } }
        })
    end
end

function M.remove_seconds(ext_mark_id)
    vim.api.nvim_buf_del_extmark(vim.api.nvim_get_current_buf(), M.namespace_id, ext_mark_id)
end

return M
