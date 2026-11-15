-- Session timer only. Does not generate rewards or keep a session alive.
local startedAt = os.time()

local function getSession()
    local seconds = os.time() - startedAt
    return {
        seconds = seconds,
        minutes = math.floor(seconds / 60),
        hours = math.floor(seconds / 3600),
    }
end

while true do
    task.wait(10)
    local stats = getSession()
    print(string.format("Session: %02d:%02d:%02d",
        stats.hours, stats.minutes % 60, stats.seconds % 60))
end
