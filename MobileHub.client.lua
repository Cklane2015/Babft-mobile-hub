-- Mobile utility hub for an experience you own.
-- Place in StarterPlayer > StarterPlayerScripts as a LocalScript.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("BABFTMobileHub")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "BABFTMobileHub"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local purple = Color3.fromRGB(132, 86, 235)
local dark = Color3.fromRGB(25, 25, 36)
local panel = Color3.fromRGB(43, 41, 59)
local white = Color3.fromRGB(245, 245, 255)

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(320, 390)
main.Position = UDim2.new(0.5, -160, 0.5, -195)
main.BackgroundColor3 = dark
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local outline = Instance.new("UIStroke")
outline.Color = purple
outline.Thickness = 2
outline.Parent = main

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 48)
header.BackgroundColor3 = panel
header.BorderSizePixel = 0
header.Parent = main
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "BABFT UTILITY HUB"
title.TextColor3 = white
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 32)
minimize.Position = UDim2.new(1, -43, 0, 8)
minimize.Text = "–"
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.TextColor3 = white
minimize.BackgroundColor3 = purple
minimize.Parent = header
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 8)

local tabBar = Instance.new("Frame")
tabBar.Position = UDim2.fromOffset(10, 58)
tabBar.Size = UDim2.new(1, -20, 0, 38)
tabBar.BackgroundTransparency = 1
tabBar.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabBar

local content = Instance.new("ScrollingFrame")
content.Position = UDim2.fromOffset(10, 104)
content.Size = UDim2.new(1, -20, 1, -114)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 4
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.CanvasSize = UDim2.new()
content.Parent = main

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 7)
list.Parent = content

local elapsed = 0
local minimized = false

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("GuiObject") and child ~= list then
            child:Destroy()
        end
    end
end

local function addLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -4, 0, 42)
    label.BackgroundColor3 = panel
    label.TextColor3 = white
    label.Text = text
    label.TextSize = 14
    label.Font = Enum.Font.GothamMedium
    label.Parent = content
    Instance.new("UICorner", label).CornerRadius = UDim.new(0, 8)
    return label
end

local function addButton(text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -4, 0, 42)
    button.BackgroundColor3 = panel
    button.TextColor3 = white
    button.Text = text
    button.TextSize = 14
    button.Font = Enum.Font.GothamMedium
    button.Parent = content
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    button.Activated:Connect(callback)
    return button
end

local function formatTime(total)
    local hours = math.floor(total / 3600)
    local minutes = math.floor(total / 60) % 60
    local seconds = total % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function openTab(name)
    clearContent()
    if name == "Home" then
        addLabel("Welcome! This hub is for your own Roblox experience.")
        local timerLabel = addLabel("Session: " .. formatTime(elapsed))
        task.spawn(function()
            while timerLabel.Parent == content do
                timerLabel.Text = "Session: " .. formatTime(elapsed)
                task.wait(1)
            end
        end)
        addButton("Refresh session display", function()
            timerLabel.Text = "Session: " .. formatTime(elapsed)
        end)
    elseif name == "Building" then
        addButton("Count build parts", function()
            local folder = workspace:FindFirstChild("PlayerBuilds")
            local count = folder and #folder:GetDescendants() or 0
            addLabel("Objects in PlayerBuilds: " .. count)
        end)
        addLabel("Build tools must be connected to your own game's build system.")
    elseif name == "AFK" then
        addLabel("Session timer: " .. formatTime(elapsed))
        addLabel("Timer only. It does not earn rewards or automate official BABFT.")
        addButton("Reset session timer", function()
            elapsed = 0
            openTab("AFK")
        end)
    elseif name == "Settings" then
        addButton("Purple theme", function()
            outline.Color = Color3.fromRGB(132, 86, 235)
        end)
        addButton("Blue theme", function()
            outline.Color = Color3.fromRGB(45, 150, 245)
        end)
        addButton("Green theme", function()
            outline.Color = Color3.fromRGB(45, 190, 125)
        end)
    end
end

for _, name in ipairs({"Home", "Building", "AFK", "Settings"}) do
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.25, -4, 1, 0)
    tab.BackgroundColor3 = purple
    tab.TextColor3 = white
    tab.Text = name
    tab.TextSize = 11
    tab.Font = Enum.Font.GothamBold
    tab.Parent = tabBar
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 7)
    tab.Activated:Connect(function() openTab(name) end)
end

minimize.Activated:Connect(function()
    minimized = not minimized
    tabBar.Visible = not minimized
    content.Visible = not minimized
    main.Size = minimized and UDim2.fromOffset(320, 48) or UDim2.fromOffset(320, 390)
    minimize.Text = minimized and "+" or "–"
end)

-- Drag using the header; works with mouse and touch.
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

task.spawn(function()
    while gui.Parent do
        task.wait(1)
        elapsed += 1
    end
end)

openTab("Home")
