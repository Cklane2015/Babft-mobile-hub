-- Reusable palette helper for your own GUI.
local Palette = {
    Purple = Color3.fromRGB(132, 86, 235),
    Blue = Color3.fromRGB(45, 150, 245),
    Green = Color3.fromRGB(45, 190, 125),
    Red = Color3.fromRGB(225, 75, 85),
    Gold = Color3.fromRGB(235, 180, 55),
    Pink = Color3.fromRGB(235, 105, 175),
}

local function applyTheme(guiObject, colorName)
    local color = Palette[colorName]
    if not color then
        warn("Unknown theme:", colorName)
        return false
    end
    guiObject.BackgroundColor3 = color
    return true
end

-- Example:
-- applyTheme(script.Parent, "Purple")
