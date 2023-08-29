local fw = {}

---starts the timer based on user input
---@param arg string user input in format `#{mins, min, m}#{secs, sec, s}`
function fw.start(arg)
    local times = validate_and_process_args(arg)
    start_timers(times)
end

---validates whether the arguments have the needed information
---@param args string the user passed arguments to the command
---@return table result minutes and seconds keys
function validate_and_process_args(args)
    -- index of minutes start (not 0 indexed)
    local minute_pos = string.find(args, "m")
    local minute_amt

    if minute_pos ~= nil then
        minute_amt = string.sub(args, 0, minute_pos - 1) or "0"
    end

    args = string.sub(args, minute_pos + 1, string.len(args))

    local sec_pos = string.find(args, "s")

    local sec_amt
    if sec_pos ~= nil then
        sec_amt = string.sub(args, 0, sec_pos - 1)
    else
        sec_amt = "0"
    end

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

function start_timers(times)
end

return fw