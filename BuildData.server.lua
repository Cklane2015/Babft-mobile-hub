-- Example server-side DataStore pattern for a game you own.
-- Place in ServerScriptService. Create/validate your own build schema before saving.
-- This example saves a small text payload, not arbitrary Instances.
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local store = DataStoreService:GetDataStore("PlayerBuildData_v1")

local function saveBuildText(player, buildText)
    if typeof(buildText) ~= "string" or #buildText > 20000 then
        return false, "Invalid build data"
    end

    local key = "player_" .. player.UserId
    local ok, err = pcall(function()
        store:SetAsync(key, buildText)
    end)
    if not ok then
        warn("Build save failed:", err)
        return false, "Save failed"
    end
    return true
end

local function loadBuildText(player)
    local key = "player_" .. player.UserId
    local ok, result = pcall(function()
        return store:GetAsync(key)
    end)
    if not ok then
        warn("Build load failed:", result)
        return nil
    end
    return result
end

-- Hook these functions into server-validated RemoteFunctions/RemoteEvents
-- in your own game. Never trust client-provided build data without validation.
Players.PlayerRemoving:Connect(function(player)
    -- Save only data your server has validated and tracked.
end)

print("BuildData server example loaded.")
