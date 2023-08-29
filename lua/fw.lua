local fw = {}

function fw.start(arg)
    local res = validate_and_process_args(arg)
    P(res)
end

---validates whether the arguments have the needed information
---@param args string the user passed arguments to the command
---@return table has minutes and seconds keys
function validate_and_process_args(args)
    -- index of minutes start (not 0 indexed)
    local minute_pos = string.find(args, "min") or string.find(args, "m")
    local minute_amt

    local offset

    if minute_pos == nil then
        offset = 0
    else
        minute_amt = string.sub(args, 0, minute_pos - 1) or "0"
        offset = string.len(minute_pos) + string.len(minute_amt) + 1
    end


    local sec_pos = string.find(args, "secs") or string.find(args, "sec") or string.find(args, "s")
    local sec_amt = string.sub(args, offset, sec_pos - 1) or 0

    return {
        minutes = tonumber(minute_amt),
        seconds = tonumber(sec_amt)
    }
end

function fw.open_prompt()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")

    local win_height = math.ceil(height * .05)
    local win_width = math.ceil(width * .2)

    local settings = {
        focusable = true,
        border = "rounded",
        width = win_width,
        height = win_height,
        title = "hey",
        -- relative = "editor",
        external = true,
        row = 50,
        col = 5
    }

    local buffer = vim.api.nvim_create_buf(false, true)
    local window = vim.api.nvim_open_win(buffer, true, settings)
end

return fw
