--[[
    ╔═══════════════════════════════════════════════════════════════════════════════════════════════════╗
    ║                    SCRIPT HUB - BUILT WITH UI FRAMEWORK LOADER                                    ║
    ║                         Using Framework's Native UI Tools Only                                    ║
    ╚═══════════════════════════════════════════════════════════════════════════════════════════════════╝
--]]

-- Load the UI Framework
local UIFramework = loadstring(game:HttpGet("https://raw.githubusercontent.com/defnot67kid-beep/FUBINK/refs/heads/main/FUBNIKLOADER.LUA"))()

-- Wait for framework
task.wait(1)

-- ============================================
-- SCRIPT DATABASE
-- ============================================
local ScriptsDB = {
    -- Movement Scripts
    {name = "Speed Boost", category = "Movement", description = "Run super fast!", 
     script = 'game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 150\nprint("Speed boosted!")'},
    
    {name = "Super Jump", category = "Movement", description = "Jump really high!",
     script = 'game.Players.LocalPlayer.Character.Humanoid.JumpPower = 200\nprint("Jump power increased!")'},
    
    {name = "Fly Mode", category = "Movement", description = "Fly anywhere!",
     script = [[
local p = game.Players.LocalPlayer
local c = p.Character or p.CharacterAdded:Wait()
local h = c:WaitForChild("Humanoid")
local f = false
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1,1,1)*10^5

game:GetService("UserInputService").JumpRequested:Connect(function()
    f = not f
    if f then
        bv.Parent = c.HumanoidRootPart
        bv.Velocity = Vector3.new(0,50,0)
    else
        bv:Destroy()
    end
end)
print("Press space to toggle fly!")
]]},
    
    -- Combat Scripts
    {name = "Auto Click", category = "Combat", description = "Auto click fast!",
     script = [[
local mouse = game.Players.LocalPlayer:GetMouse()
while true do
    mouse1click()
    task.wait(0.05)
end
]]},
    
    {name = "Aimbot", category = "Combat", description = "Auto aim at players!",
     script = [[
local plrs = game:GetService("Players")
local ls = plrs.LocalPlayer
local mouse = ls:GetMouse()

while true do
    local closest = nil
    local dist = math.huge
    for _,v in pairs(plrs:GetPlayers()) do
        if v ~= ls and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (v.Character.HumanoidRootPart.Position - ls.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = v
            end
        end
    end
    if closest then
        mouse.Target = closest.Character.HumanoidRootPart
    end
    task.wait()
end
]]},
    
    -- Visual Scripts
    {name = "ESP", category = "Visual", description = "See players through walls!",
     script = [[
for _,v in pairs(game:GetService("Players"):GetPlayers()) do
    if v ~= game.Players.LocalPlayer and v.Character then
        local b = Instance.new("BoxHandleAdornment")
        b.Adornee = v.Character
        b.Size = Vector3.new(4,5,2)
        b.Color3 = Color3.fromRGB(255,0,0)
        b.AlwaysOnTop = true
        b.ZIndex = 10
        b.Parent = v.Character
    end
end
]]},
    
    {name = "Full Bright", category = "Visual", description = "No more darkness!",
     script = 'game:GetService("Lighting").Brightness = 2\ngame:GetService("Lighting").GlobalShadows = false\nprint("Full bright activated!")'},
    
    {name = "XRay Vision", category = "Visual", description = "See through everything!",
     script = [[
for _,v in pairs(game:GetService("Workspace"):GetDescendants()) do
    if v:IsA("BasePart") then
        v.LocalTransparencyModifier = 0.5
    end
end
print("XRay activated!")]]},
    
    -- Utility Scripts
    {name = "Anti AFK", category = "Utility", description = "Never get kicked for AFK",
     script = [[
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)
print("Anti AFK activated!")]]},
    
    {name = "Infinite Yield", category = "Utility", description = "Best admin command script",
     script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()'},
    
    {name = "Auto Farm", category = "Utility", description = "Auto collect items!",
     script = [[
local plr = game.Players.LocalPlayer
while true do
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("Tool") or v:IsA("Part") and v.Name:find("Chest") then
            plr.Character.HumanoidRootPart.CFrame = v.CFrame
            task.wait(0.5)
        end
    end
    task.wait()
end
]]},
    
    -- Fun Scripts
    {name = "Infinite Jump", category = "Fun", description = "Jump infinitely!",
     script = [[
local uis = game:GetService("UserInputService")
local plr = game.Players.LocalPlayer
uis.JumpRequested:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid:ChangeState("Jumping")
    end
end)
print("Infinite jump activated!")]]},
    
    {name = "Size Changer", category = "Fun", description = "Change your size!",
     script = [[
local plr = game.Players.LocalPlayer
local size = 5
plr.Character.HumanoidRootPart.Size = Vector3.new(size,size,size)
plr.Character.HumanoidRootPart.Transparency = 0.5
print("Size changed!")]]},
}

-- ============================================
-- CREATE MAIN HUB WINDOW USING FRAMEWORK
-- ============================================

-- Create main window
local MainHub = UIFramework.Tools.WindowManager.CreateWindow(
    "🌟 SCRIPT HUB v3.0 | " .. ScriptHub.Name,
    UDim2.new(0, 1000, 0, 700),
    UDim2.new(0.5, -500, 0.5, -350),
    true
)

-- Create tabs for categories
local Categories = {}
for _, script in pairs(ScriptsDB) do
    if not Categories[script.category] then
        Categories[script.category] = {}
    end
    table.insert(Categories[script.category], script)
end

-- Build tab names
local tabNames = {}
for catName, _ in pairs(Categories) do
    table.insert(tabNames, {name = catName .. " (" .. #Categories[catName] .. ")", content = nil})
end

-- Create the tab system
local tabSystem = UIFramework.Tools.TabSystem.CreateTabs(MainHub.Content, tabNames, nil, UDim2.new(1, 0, 1, 0))

-- Function to create script buttons in a category
local function PopulateCategory(container, categoryName)
    local scripts = Categories[categoryName]
    local yOffset = 20
    
    -- Category header
    local header = UIFramework.Tools.ButtonCreator.CreateButton(
        container,
        "📁 " .. categoryName .. " Scripts",
        UDim2.new(0, 20, 0, yOffset),
        UDim2.new(0, 960, 0, 40),
        nil,
        {color = Color3.fromRGB(50, 50, 70), cornerRadius = 8}
    )
    header.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    header.TextSize = 18
    yOffset = yOffset + 55
    
    -- Create each script button
    for i, scriptData in ipairs(scripts) do
        -- Script button
        local scriptBtn = UIFramework.Tools.ButtonCreator.CreateButton(
            container,
            "▶ " .. scriptData.name,
            UDim2.new(0, 40, 0, yOffset),
            UDim2.new(0, 300, 0, 50),
            function()
                -- Execute the script
                local success, err = loadstring(scriptData.script)()
                if success then
                    UIFramework.Tools.NotificationSystem.ShowNotification(
                        "✅ Script Executed",
                        scriptData.name .. " has been loaded!",
                        2,
                        "success"
                    )
                else
                    UIFramework.Tools.NotificationSystem.ShowNotification(
                        "❌ Script Failed",
                        "Error: " .. tostring(err),
                        3,
                        "error"
                    )
                end
            end,
            {color = Color3.fromRGB(0, 120, 255), cornerRadius = 8}
        )
        
        -- Description label
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(0, 600, 0, 50)
        descLabel.Position = UDim2.new(0, 360, 0, yOffset)
        descLabel.Text = "📝 " .. scriptData.description
        descLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        descLabel.BackgroundTransparency = 1
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 14
        descLabel.Parent = container
        
        yOffset = yOffset + 65
    end
    
    -- Update canvas size
    if container:IsA("ScrollingFrame") then
        container.CanvasSize = UDim2.new(0, 0, 0, yOffset + 50)
    end
end

-- Populate each tab
for i, tabData in ipairs(tabNames) do
    local categoryName = tabData.name:match("(.-) %(")
    local container = tabSystem:GetContent(i)
    PopulateCategory(container, categoryName)
end

-- ============================================
-- ADD EXTRA FEATURES TO THE HUB
-- ============================================

-- Add a toolbar at the top
local toolbar = Instance.new("Frame")
toolbar.Size = UDim2.new(1, 0, 0, 60)
toolbar.Position = UDim2.new(0, 0, 0, 50)
toolbar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
toolbar.BackgroundTransparency = 0
toolbar.Parent = MainHub.Frame

-- Search bar
local searchBox = UIFramework.Tools.InputCreator.CreateTextBox(
    toolbar,
    "🔍 Search scripts...",
    UDim2.new(0, 20, 0, 12),
    UDim2.new(0, 250, 0, 36),
    function(text)
        -- Search functionality
        UIFramework.Tools.NotificationSystem.ShowNotification(
            "Search",
            "Searching for: " .. text,
            1.5
        )
    end
)

-- Settings button
local settingsBtn = UIFramework.Tools.ButtonCreator.CreateButton(
    toolbar,
    "⚙ Settings",
    UDim2.new(1, -220, 0, 12),
    UDim2.new(0, 100, 0, 36),
    function()
        -- Create settings window
        local settingsWin = UIFramework.Tools.WindowManager.CreateWindow(
            "⚙ Settings",
            UDim2.new(0, 400, 0, 300),
            UDim2.new(0.5, -200, 0.5, -150),
            true
        )
        
        -- Auto execute toggle
        local autoExecToggle = UIFramework.Tools.ToggleCreator.CreateToggle(
            settingsWin.Content,
            "Auto Execute Scripts",
            false,
            UDim2.new(0, 20, 0, 20),
            UDim2.new(0, 360, 0, 40),
            function(value)
                ScriptHub.Settings.AutoExecute = value
            end
        )
        
        -- Notifications toggle
        local notifToggle = UIFramework.Tools.ToggleCreator.CreateToggle(
            settingsWin.Content,
            "Show Notifications",
            true,
            UDim2.new(0, 20, 0, 70),
            UDim2.new(0, 360, 0, 40),
            function(value)
                ScriptHub.Settings.NotificationEnabled = value
            end
        )
        
        -- Clear history button
        local clearBtn = UIFramework.Tools.ButtonCreator.CreateButton(
            settingsWin.Content,
            "Clear Script History",
            UDim2.new(0, 20, 0, 130),
            UDim2.new(0, 360, 0, 40),
            function()
                ScriptHub.LoadedScripts = {}
                UIFramework.Tools.NotificationSystem.ShowNotification(
                    "History Cleared",
                    "Script history has been cleared!",
                    2,
                    "success"
                )
            end
        )
    end,
    {color = Color3.fromRGB(80, 80, 100), cornerRadius = 8}
)

-- Credits button
local creditsBtn = UIFramework.Tools.ButtonCreator.CreateButton(
    toolbar,
    "ℹ Info",
    UDim2.new(1, -110, 0, 12),
    UDim2.new(0, 100, 0, 36),
    function()
        UIFramework.Tools.NotificationSystem.ShowNotification(
            "📢 Script Hub Info",
            "Version: 3.0.0\nTotal Scripts: " .. #ScriptsDB .. "\nMade with UI Framework",
            4,
            "info"
        )
    end,
    {color = Color3.fromRGB(80, 80, 100), cornerRadius = 8}
)

-- ============================================
-- ADD STATS DISPLAY
-- ============================================
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 200, 0, 60)
statsFrame.Position = UDim2.new(1, -210, 1, -70)
statsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
statsFrame.BackgroundTransparency = 0.8
statsFrame.Parent = MainHub.Frame

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 8)
statsCorner.Parent = statsFrame

local scriptCountLabel = Instance.new("TextLabel")
scriptCountLabel.Size = UDim2.new(1, 0, 0, 30)
scriptCountLabel.Text = "📚 Scripts: " .. #ScriptsDB
scriptCountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
scriptCountLabel.BackgroundTransparency = 1
scriptCountLabel.Font = Enum.Font.Gotham
scriptCountLabel.TextSize = 14
scriptCountLabel.Parent = statsFrame

local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(1, 0, 0, 30)
versionLabel.Position = UDim2.new(0, 0, 0, 30)
versionLabel.Text = "📌 Version: " .. ScriptHub.Version
versionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
versionLabel.BackgroundTransparency = 1
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 12
versionLabel.Parent = statsFrame

-- ============================================
-- WELCOME MESSAGE
-- ============================================
task.wait(0.5)

UIFramework.Tools.NotificationSystem.ShowNotification(
    "🎉 Script Hub Loaded!",
    "Welcome to " .. ScriptHub.Name .. " v" .. ScriptHub.Version .. "\n" .. #ScriptsDB .. " scripts available!",
    3,
    "success"
)

print("")
print("╔══════════════════════════════════════════════════════════════════╗")
print("║                    SCRIPT HUB LOADED SUCCESSFULLY               ║")
print("║                                                                  ║")
print("║  📊 Total Scripts: " .. #ScriptsDB .. "                                            ║")
print("║  📁 Categories: " .. #tabNames .. "                                                ║")
print("║  🚀 Ready to use - Click any script button to execute!          ║")
print("║                                                                  ║")
print("║  💡 Tip: Use the search bar to find specific scripts            ║")
print("╚══════════════════════════════════════════════════════════════════╝")
print("")

-- Return hub for external use
return ScriptHub
