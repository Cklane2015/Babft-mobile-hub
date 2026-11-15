-- Notification helper for your own Roblox experience.
local StarterGui = game:GetService("StarterGui")

local function notify(title, message, duration)
    local ok, err = pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Notice",
            Text = message or "",
            Duration = duration or 3,
        })
    end)
    if not ok then
        warn("Could not show notification:", err)
    end
end

notify("Utility Hub", "Notification helper loaded.", 3)
