-- Kumi Hub
-- Interface base para um jogo Roblox próprio/modificado.
-- Coloque este LocalScript em StarterGui.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "KumiHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

local RED = Color3.fromRGB(190, 25, 45)
local DARK = Color3.fromRGB(14, 14, 17)
local PANEL = Color3.fromRGB(22, 22, 27)
local TEXT = Color3.fromRGB(245, 245, 248)
local MUTED = Color3.fromRGB(160, 160, 170)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Transparency = transparency or 0
    s.Thickness = 1
    s.Parent = obj
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(620, 390)
main.Position = UDim2.new(0.5, -310, 0.5, -195)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui
corner(main, 14)
stroke(main, RED, 0.55)

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 58)
top.BackgroundColor3 = PANEL
top.BorderSizePixel = 0
top.Parent = main
corner(top, 14)

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.fromOffset(20, 7)
title.Size = UDim2.new(1, -90, 0, 28)
title.Font = Enum.Font.GothamBold
title.Text = "KUMI HUB"
title.TextColor3 = TEXT
title.TextSize = 21
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(21, 33)
subtitle.Size = UDim2.new(1, -100, 0, 18)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Custom hub • " .. player.Name
subtitle.TextColor3 = MUTED
subtitle.TextSize = 11
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34, 34)
close.Position = UDim2.new(1, -45, 0, 12)
close.BackgroundColor3 = RED
close.Text = "×"
close.TextColor3 = TEXT
close.Font = Enum.Font.GothamBold
close.TextSize = 22
close.AutoButtonColor = false
close.Parent = top
corner(close, 9)

local side = Instance.new("Frame")
side.Position = UDim2.fromOffset(10, 68)
side.Size = UDim2.fromOffset(145, 312)
side.BackgroundColor3 = PANEL
side.BorderSizePixel = 0
side.Parent = main
corner(side, 11)

local content = Instance.new("Frame")
content.Position = UDim2.fromOffset(165, 68)
content.Size = UDim2.new(1, -175, 1, -78)
content.BackgroundTransparency = 1
content.Parent = main

local pages = {}
local buttons = {}

local function makePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = RED
    page.CanvasSize = UDim2.new()
    page.Visible = false
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 8)
    end)

    pages[name] = page
    return page
end

local function makeTab(name, icon, order)
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = UDim2.new(1, -16, 0, 38)
    b.Position = UDim2.fromOffset(8, 8 + (order - 1) * 44)
    b.BackgroundColor3 = DARK
    b.Text = icon .. "  " .. name
    b.TextColor3 = MUTED
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.Parent = side
    corner(b, 8)
    buttons[name] = b
    return b
end

local function showPage(name)
    for n, page in pairs(pages) do
        page.Visible = (n == name)
    end
    for n, b in pairs(buttons) do
        b.BackgroundColor3 = (n == name) and RED or DARK
        b.TextColor3 = (n == name) and TEXT or MUTED
    end
end

local function addSection(page, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -5, 0, 28)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = TEXT
    label.Font = Enum.Font.GothamBold
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = page
end

local function addButton(page, text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -5, 0, 42)
    b.BackgroundColor3 = PANEL
    b.Text = text
    b.TextColor3 = TEXT
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.AutoButtonColor = false
    b.Parent = page
    corner(b, 9)
    stroke(b, Color3.fromRGB(55, 55, 65), 0.35)

    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(35, 35, 42)}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = PANEL}):Play()
    end)
    b.Activated:Connect(function()
        if callback then callback() end
    end)
    return b
end

local function addToggle(page, text, default, callback)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, -5, 0, 42)
    row.BackgroundColor3 = PANEL
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = page
    corner(row, 9)
    stroke(row, Color3.fromRGB(55, 55, 65), 0.35)

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(13, 0)
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Text = text
    label.TextColor3 = TEXT
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.fromOffset(44, 24)
    pill.Position = UDim2.new(1, -56, 0.5, -12)
    pill.BackgroundColor3 = Color3.fromRGB(55, 55, 62)
    pill.Parent = row
    corner(pill, 12)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = UDim2.fromOffset(3, 3)
    knob.BackgroundColor3 = TEXT
    knob.Parent = pill
    corner(knob, 9)

    local state = default == true
    local function render()
        pill.BackgroundColor3 = state and RED or Color3.fromRGB(55, 55, 62)
        knob.Position = state and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3)
    end
    render()

    row.Activated:Connect(function()
        state = not state
        render()
        if callback then callback(state) end
    end)

    return row
end

local home = makePage("Home")
addSection(home, "Welcome")
addButton(home, "Player: " .. player.Name)
addButton(home, "Kumi Hub loaded", function() end)

local combat = makePage("Combat")
addSection(combat, "Combat")
addToggle(combat, "Training Mode", false, function(enabled)
    print("Training Mode:", enabled)
end)
addToggle(combat, "Auto Skill Test", false, function(enabled)
    print("Auto Skill Test:", enabled)
end)

local npc = makePage("NPC")
addSection(npc, "NPC / Farm")
addToggle(npc, "NPC Training", false, function(enabled)
    print("NPC Training:", enabled)
end)
addButton(npc, "Select NPC", function()
    print("Connect this button to your NPC selector.")
end)

local teleport = makePage("Teleport")
addSection(teleport, "Locations")
for _, place in ipairs({"Starter Island", "Forest", "Desert", "Snow Island"}) do
    addButton(teleport, "Teleport: " .. place, function()
        print("Connect teleport to:", place)
    end)
end

local fruits = makePage("Fruits")
addSection(fruits, "Fruits")
addButton(fruits, "Fruit Selector", function()
    print("Connect this to your game's fruit system.")
end)
addToggle(fruits, "Show Fruit Alerts", true, function(enabled)
    print("Fruit Alerts:", enabled)
end)

local quests = makePage("Quests")
addSection(quests, "Quests")
addToggle(quests, "Quest Helper", false, function(enabled)
    print("Quest Helper:", enabled)
end)

local playersPage = makePage("Players")
addSection(playersPage, "Players")
addButton(playersPage, "Refresh Player List", function()
    print("Players refreshed.")
end)

local settings = makePage("Settings")
addSection(settings, "Interface")
addToggle(settings, "UI Animations", true, function(enabled)
    print("UI Animations:", enabled)
end)
addButton(settings, "Hide Kumi Hub", function()
    main.Visible = false
end)

local tabs = {
    {"Home", "⌂"}, {"Combat", "⚔"}, {"NPC", "◆"}, {"Teleport", "➤"},
    {"Fruits", "●"}, {"Quests", "★"}, {"Players", "◎"}, {"Settings", "⚙"}
}

for i, item in ipairs(tabs) do
    local name, icon = item[1], item[2]
    local button = makeTab(name, icon, i)
    button.Activated:Connect(function()
        showPage(name)
    end)
end

showPage("Home")

-- Arrastar a janela
local dragging = false
local dragStart
local startPos

top.InputBegan:Connect(function(input)
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
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

close.Activated:Connect(function()
    gui:Destroy()
end)
