local fw = {}

---starts the timer based on user input
---@param arg string user input
---@param timer Timer global timer instance
function fw.start(arg, timer)
    timer:stop()
    if arg == "sw_start" then
        use_stopwatch(timer)
    elseif arg == "timer_stop" then
        print('Focuswatch timer has stopped')
    elseif arg == "sw_stop" then
        print('Focuswatch stopwatch has stopped')
    else
        use_timer(timer, arg)
    end
end

function use_timer(timer, arg)
    local times = validate_and_process_args(arg)
    start_timer(timer, get_seconds(times))
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
    else
        minute_amt = "0"
        minute_pos = -1
    end

    args = string.sub(args, minute_pos + 1, string.len(args))

    local sec_pos = string.find(args, "s")

    local sec_amt
    if sec_pos ~= nil then
        sec_amt = string.sub(args, 0, sec_pos - 1)
    else
        sec_amt = "0"
    end

    sec_amt = tonumber(sec_amt)
    minute_amt = tonumber(minute_amt)

    if minute_amt < 0 then
        minute_amt = 0
    end

    if sec_amt < 0 then
        sec_amt = 0
    end

    return {
        minutes = minute_amt,
        seconds = sec_amt
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

---get the amount of seconds off of the time object
---@param times table
---@return number amount of seconds based on the times object
function get_seconds(times)
    return (times.minutes * 60) + times.seconds
end

function start_timer(timer, seconds)
    if seconds < 1 then
        print("Must have at least 1 second(s)")
        return
    end

    timer:start(1000, 1000, function()
        seconds = seconds - 1
        print(format_seconds(seconds))
        if seconds == 0 then
            print("Focuswatch timer has finished")
            timer:stop()
        end
    end)
end

function format_seconds(seconds)
    local minutes = tostring(math.floor(seconds / 60)) .. "m"
    local seconds = tostring(seconds % 60) .. "s"
    return minutes .. seconds
end

function use_stopwatch(timer)
    local seconds = 0
    timer:start(1000, 1000, function()
        seconds = seconds + 1
        print(format_seconds(seconds))
    end)
end

return fw
