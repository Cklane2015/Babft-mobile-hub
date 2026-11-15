-- Counts BaseParts in Workspace.PlayerBuilds in your own experience.
local function countBuildParts()
    local folder = workspace:FindFirstChild("PlayerBuilds")
    if not folder then
        warn("Workspace.PlayerBuilds folder was not found.")
        return 0
    end

    local count = 0
    for _, object in ipairs(folder:GetDescendants()) do
        if object:IsA("BasePart") then
            count += 1
        end
    end
    return count
end

print("Build part count:", countBuildParts())
