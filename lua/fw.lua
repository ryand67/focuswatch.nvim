local M = {}

local ui = require('ui')

---starts the timer based on user input
---@param arg string user input
---@param timer Timer global timer instance
function M.start(arg, timer)
    timer:stop()
    local end_notify = "Press <CR>, q, or <Esc> to exit notification"
    if arg == "sw_start" then
        ui.notify('Stopwatch started. ' .. end_notify, ui.notify_levels.INFO)
        use_stopwatch(timer)
    elseif arg == "timer_stop" then
        ui.notify('Timer has stopped. ' .. end_notify, ui.notify_levels.INFO)
    elseif arg == "sw_stop" then
        ui.notify('Stopwatch has stopped. ' .. end_notify, ui.notify_levels.INFO)
    elseif arg == "timer_start" then
        ui.input(function(line)
            use_timer(timer, line)
        end)
    end
end

function use_timer(timer, arg)
    local times = validate_and_process_args(arg)
    if times == nil then
        ui.notify("Please follow the required format: #m#s", ui.notify_levels.ERROR)
        return
    end
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

    sec_amt = tonumber(sec_amt) or -1
    minute_amt = tonumber(minute_amt) or -1

    if minute_amt < 0 or minute_amt == nil then
        minute_amt = 0
    end

    if sec_amt < 0 then
        sec_amt = 0
    end

    if minute_amt == 0 and sec_amt == 0 then
        return nil
    end

    return {
        minutes = minute_amt,
        seconds = sec_amt
    }
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
            ui.notify("Focuswatch timer has finished" .. end_notify, ui.notify_levels.INFO)
            timer:stop()
        end
    end)
end

function format_seconds(seconds)
    local minutes = tostring(math.floor(seconds / 60)) .. "m"
    local seconds = tostring(seconds % 60) .. "s"
    return minutes .. seconds
end

---Starts a stopwatch
---@param timer any Global timer object
function use_stopwatch(timer)
    local seconds = 0
    timer:start(1000, 1000, function()
        seconds = seconds + 1
        print(format_seconds(seconds))
    end)
end

return M
