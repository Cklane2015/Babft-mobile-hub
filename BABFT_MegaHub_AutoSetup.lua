-- BABFT-STYLE MEGA HUB: ONE-FILE AUTO SETUP
-- For Roblox Studio experiences you own or are authorized to edit.
-- Install this entire file as ONE LocalScript in StarterPlayer > StarterPlayerScripts.
-- Press Play: the GUI and all local utility panels are created automatically.
-- This is not an injector and does not automate or modify the official BABFT game.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("BABFT_MegaHub")
if old then old:Destroy() end

local Theme = {
    accent = Color3.fromRGB(145, 85, 245),
    background = Color3.fromRGB(22, 22, 32),
    panel = Color3.fromRGB(39, 37, 54),
    button = Color3.fromRGB(54, 49, 73),
    text = Color3.fromRGB(245, 245, 255),
    muted = Color3.fromRGB(185, 185, 205),
}
local themes = {
    Purple = Color3.fromRGB(145, 85, 245),
    Blue = Color3.fromRGB(45, 145, 245),
    Green = Color3.fromRGB(45, 190, 125),
    Pink = Color3.fromRGB(235, 95, 175),
    Orange = Color3.fromRGB(240, 145, 55),
    Red = Color3.fromRGB(225, 75, 85),
}

local startedAt = os.clock()
local elapsed = 0
local minimized = false
local selectedTab = "Home"
local savedPosition = nil
local notificationCount = 0
local sessionNotes = {}
local crosshairEnabled = false
local crosshairGui

local gui = Instance.new("ScreenGui")
gui.Name = "BABFT_MegaHub"
gui.ResetOnSpawn = false
gui.DisplayOrder = 50
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(350, 470)
main.Position = UDim2.new(0.5, -175, 0.5, -235)
main.BackgroundColor3 = Theme.background
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

local outline = Instance.new("UIStroke")
outline.Color = Theme.accent
outline.Thickness = 2
outline.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = Theme.panel
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(12, 0)
title.Size = UDim2.new(1, -110, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "BABFT MEGA HUB"
title.TextColor3 = Theme.text
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local function styleButton(button)
    button.BackgroundColor3 = Theme.button
    button.TextColor3 = Theme.text
    button.Font = Enum.Font.GothamMedium
    button.TextSize = 14
    button.BorderSizePixel = 0
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
end

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(34, 32)
mini.Position = UDim2.new(1, -82, 0, 8)
mini.Text = "–"
mini.TextSize = 22
mini.Parent = header
styleButton(mini)

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 32)
close.Position = UDim2.new(1, -42, 0, 8)
close.Text = "×"
close.TextSize = 20
close.BackgroundColor3 = Color3.fromRGB(165, 55, 70)
close.Parent = header
styleButton(close)

local tabsFrame = Instance.new("Frame")
tabsFrame.Position = UDim2.fromOffset(9, 57)
tabsFrame.Size = UDim2.new(1, -18, 0, 38)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 5)
tabsLayout.Parent = tabsFrame

local body = Instance.new("ScrollingFrame")
body.Position = UDim2.fromOffset(10, 103)
body.Size = UDim2.new(1, -20, 1, -113)
body.BackgroundTransparency = 1
body.BorderSizePixel = 0
body.ScrollBarThickness = 4
body.AutomaticCanvasSize = Enum.AutomaticSize.Y
body.CanvasSize = UDim2.new()
body.Parent = main

local bodyLayout = Instance.new("UIListLayout")
bodyLayout.Padding = UDim.new(0, 7)
bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
bodyLayout.Parent = body

local function notify(message)
    notificationCount += 1
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "BABFT Mega Hub",
            Text = tostring(message),
            Duration = 3
        })
    end)
    print("[MegaHub] " .. tostring(message))
end

local function clearBody()
    for _, child in ipairs(body:GetChildren()) do
        if child:IsA("GuiObject") and child ~= bodyLayout then
            child:Destroy()
        end
    end
end

local function label(text, height)
    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -4, 0, height or 40)
    item.BackgroundColor3 = Theme.panel
    item.BorderSizePixel = 0
    item.Text = tostring(text)
    item.TextColor3 = Theme.text
    item.TextSize = 13
    item.Font = Enum.Font.GothamMedium
    item.TextWrapped = true
    item.Parent = body
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)
    return item
end

local function button(text, callback)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -4, 0, 42)
    item.Text = text
    item.Parent = body
    styleButton(item)
    item.Activated:Connect(callback)
    return item
end

local function formatTime(total)
    local h = math.floor(total / 3600)
    local m = math.floor(total / 60) % 60
    local s = total % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function getBuildFolder()
    return workspace:FindFirstChild("PlayerBuilds")
end

local function countParts()
    local folder = getBuildFolder()
    if not folder then return nil end
    local count = 0
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") then count += 1 end
    end
    return count
end

local function getToolList()
    local found = {}
    local backpack = player:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if obj:IsA("Tool") then table.insert(found, obj.Name) end
        end
    end
    if player.Character then
        for _, obj in ipairs(player.Character:GetChildren()) do
            if obj:IsA("Tool") then table.insert(found, obj.Name .. " (equipped)") end
        end
    end
    table.sort(found)
    return found
end

local function setTheme(name)
    local color = themes[name]
    if not color then return end
    Theme.accent = color
    outline.Color = color
    for _, tab in ipairs(tabsFrame:GetChildren()) do
        if tab:IsA("TextButton") then tab.BackgroundColor3 = color end
    end
    notify(name .. " theme applied")
end

local function toggleCrosshair()
    crosshairEnabled = not crosshairEnabled
    if crosshairEnabled then
        crosshairGui = Instance.new("ScreenGui")
        crosshairGui.Name = "MegaHubCrosshair"
        crosshairGui.IgnoreGuiInset = true
        crosshairGui.Parent = playerGui
        local dot = Instance.new("TextLabel")
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.fromScale(0.5, 0.5)
        dot.Size = UDim2.fromOffset(24, 24)
        dot.BackgroundTransparency = 1
        dot.Text = "+"
        dot.TextColor3 = Theme.text
        dot.TextSize = 22
        dot.Font = Enum.Font.GothamBold
        dot.Parent = crosshairGui
    elseif crosshairGui then
        crosshairGui:Destroy()
        crosshairGui = nil
    end
    notify("Crosshair " .. (crosshairEnabled and "enabled" or "disabled"))
end

local function showTab(name)
    selectedTab = name
    clearBody()

    if name == "Home" then
        label("Welcome, " .. player.DisplayName .. "! This hub creates its own interface.", 48)
        label("Session: " .. formatTime(elapsed), 38)
        label("Local utilities only • for experiences you control", 38)
        button("Show quick status", function()
            local parts = countParts()
            notify("Session " .. formatTime(elapsed) ..
                " | Build parts: " .. (parts and tostring(parts) or "folder not found"))
        end)
        button("Open help", function()
            notify("Use the tabs above. Add Workspace.PlayerBuilds for build counting.")
        end)

    elseif name == "Building" then
        label("BUILD UTILITIES", 34)
        button("Count parts in PlayerBuilds", function()
            local count = countParts()
            if count == nil then
                notify("Create Workspace > PlayerBuilds in your own game first.")
            else
                label("Current build parts: " .. count, 36)
                notify("Counted " .. count .. " parts")
            end
        end)
        button("List build object names", function()
            local folder = getBuildFolder()
            if not folder then notify("PlayerBuilds folder not found"); return end
            local names = {}
            for _, obj in ipairs(folder:GetChildren()) do
                table.insert(names, obj.Name)
            end
            label("Build objects: " .. (#names > 0 and table.concat(names, ", ") or "(empty)"), 58)
        end)
        button("Save current character position", function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                savedPosition = root.CFrame
                notify("Position saved for this session")
            else
                notify("Character position unavailable")
            end
        end)
        button("Return to saved position", function()
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if root and savedPosition then
                root.CFrame = savedPosition
                notify("Returned to your saved position")
            else
                notify("Save a position first")
            end
        end)

    elseif name == "AFK" then
        label("SESSION TRACKER", 34)
        label("Elapsed: " .. formatTime(elapsed), 42)
        label("This is a timer only. It does not simulate input, keep a session alive, or award game rewards.", 75)
        button("Reset session timer", function()
            elapsed = 0
            notify("Session timer reset")
            showTab("AFK")
        end)
        button("Add session note", function()
            table.insert(sessionNotes, "Note at " .. formatTime(elapsed))
            notify("Session note added (" .. #sessionNotes .. " total)")
        end)
        button("View note count", function()
            label("Session notes saved this run: " .. #sessionNotes, 36)
        end)

    elseif name == "Inventory" then
        label("TOOLS IN YOUR BACKPACK / CHARACTER", 42)
        local tools = getToolList()
        if #tools == 0 then
            label("No Tools found right now.", 36)
        else
            for _, toolName in ipairs(tools) do label(toolName, 32) end
        end
        button("Refresh inventory", function() showTab("Inventory") end)

    elseif name == "Visuals" then
        label("VISUAL UTILITIES", 34)
        button("Toggle simple center crosshair", toggleCrosshair)
        button("Show current camera FOV", function()
            local camera = workspace.CurrentCamera
            notify(camera and ("Camera FOV: " .. math.floor(camera.FieldOfView)) or "Camera unavailable")
        end)
        button("Reset camera FOV", function()
            local camera = workspace.CurrentCamera
            if camera then camera.FieldOfView = 70; notify("Camera FOV reset to 70") end
        end)

    elseif name == "Settings" then
        label("THEMES", 34)
        for themeName in pairs(themes) do
            button(themeName .. " theme", function() setTheme(themeName) end)
        end
        button("Reset hub position", function()
            main.Position = UDim2.new(0.5, -175, 0.5, -235)
            notify("Hub position reset")
        end)
        button("Show notification test", function()
            notify("Notifications are working!")
        end)
        button("Close hub", function() gui:Destroy() end)
    end
end

local tabNames = {"Home", "Building", "AFK", "Inventory", "Visuals", "Settings"}
for _, name in ipairs(tabNames) do
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(1 / #tabNames, -5, 1, 0)
    tab.Text = name
    tab.Parent = tabsFrame
    tab.TextSize = 10
    tab.Font = Enum.Font.GothamBold
    tab.TextColor3 = Theme.text
    tab.BackgroundColor3 = Theme.accent
    tab.BorderSizePixel = 0
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 7)
    tab.Activated:Connect(function() showTab(name) end)
end

mini.Activated:Connect(function()
    minimized = not minimized
    tabsFrame.Visible = not minimized
    body.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(350, 48) or UDim2.fromOffset(350, 470)
    mini.Text = minimized and "+" or "–"
end)

close.Activated:Connect(function()
    if crosshairGui then crosshairGui:Destroy() end
    gui:Destroy()
end)

-- Drag the header with touch or mouse.
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Live session counter and lightweight client FPS estimate.
local frameCount, fps, lastFpsUpdate = 0, 0, os.clock()
RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = os.clock()
    if now - lastFpsUpdate >= 1 then
        fps = frameCount
        frameCount = 0
        lastFpsUpdate = now
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(1)
        elapsed += 1
    end
end)

showTab("Home")
notify("Mega Hub setup complete!")
print("BABFT-style Mega Hub ready. Local utilities only.")
