--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗██╗  ██╗         ║
    ║   ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚██╗██╔╝         ║
    ║   █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║ ╚███╔╝          ║
    ║   ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║ ██╔██╗          ║
    ║   ██║     ╚██████╔╝██████╔╝██║ ╚████║██║██╔╝ ██╗          ║
    ║   ╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝          ║
    ║                                                           ║
    ║              SIMPLE SCRIPT HUB v1.0                       ║
    ║         Clean | Works 100% | No Errors | Fast             ║
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local TPS = game:GetService("TeleportService")
local LS = game:GetService("Lighting")

-- ============================================================================
-- SIMPLE UTILITIES
-- ============================================================================
local function MakeRounded(frame, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = frame
end

local function MakeStroke(frame, t, c)
    local s = Instance.new("UIStroke")
    s.Thickness = t or 1
    s.Color = c or Color3.fromRGB(100, 100, 255)
    s.Parent = frame
end

local function Tween(obj, props, time)
    local t = TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================
local NotifyContainer = nil

local function CreateNotifyContainer()
    if NotifyContainer then return end
    NotifyContainer = Instance.new("Frame")
    NotifyContainer.Name = "NotifContainer"
    NotifyContainer.Size = UDim2.new(0, 320, 1, -20)
    NotifyContainer.Position = UDim2.new(1, -340, 0, 10)
    NotifyContainer.BackgroundTransparency = 1
    NotifyContainer.Parent = CG
end

local function Notify(title, msg, typ, duration)
    CreateNotifyContainer()
    typ = typ or "info"
    duration = duration or 3
    
    local colors = {
        info = Color3.fromRGB(80, 180, 255),
        success = Color3.fromRGB(80, 255, 120),
        warn = Color3.fromRGB(255, 200, 80),
        error = Color3.fromRGB(255, 80, 100)
    }
    
    local icons = {info = "ℹ️", success = "✅", warn = "⚠️", error = "❌"}
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.1
    frame.AutomaticSize = Enum.AutomaticSize.Y
    MakeRounded(frame, 12)
    MakeStroke(frame, 1, colors[typ])
    frame.Parent = NotifyContainer
    
    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0, 30, 0, 30)
    iconL.Position = UDim2.new(0, 12, 0, 12)
    iconL.Text = icons[typ]
    iconL.TextSize = 18
    iconL.BackgroundTransparency = 1
    iconL.Parent = frame
    
    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -55, 0, 25)
    titleL.Position = UDim2.new(0, 48, 0, 8)
    titleL.Text = title
    titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleL.TextSize = 14
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.BackgroundTransparency = 1
    titleL.Parent = frame
    
    local msgL = Instance.new("TextLabel")
    msgL.Size = UDim2.new(1, -55, 0, 0)
    msgL.Position = UDim2.new(0, 48, 0, 33)
    msgL.Text = msg
    msgL.TextColor3 = Color3.fromRGB(180, 180, 210)
    msgL.TextSize = 12
    msgL.Font = Enum.Font.Gotham
    msgL.TextXAlignment = Enum.TextXAlignment.Left
    msgL.TextWrapped = true
    msgL.BackgroundTransparency = 1
    msgL.AutomaticSize = Enum.AutomaticSize.Y
    msgL.Parent = frame
    
    local h = msgL.AbsoluteSize.Y + 55
    Tween(frame, {Size = UDim2.new(1, -10, 0, h)}, 0.3)
    
    task.spawn(function()
        task.wait(duration)
        if frame then
            Tween(frame, {Size = UDim2.new(1, -10, 0, 0), BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            frame:Destroy()
        end
    end)
end

-- ============================================================================
-- SIMPLE GUI CREATOR
-- ============================================================================
local Hub = {
    windows = {},
    currentWindow = nil
}

function Hub:CreateWindow(name, width, height)
    width = width or 400
    height = height or 550
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptHub_" .. tostring(os.time())
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CG
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    MakeRounded(main, 12)
    MakeStroke(main, 1.5, Color3.fromRGB(100, 100, 255))
    main.Parent = screenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = main
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = name
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = 16
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = titleBar
    
    -- Tabs container (sidebar)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0, 120, 1, -45)
    tabsFrame.Position = UDim2.new(0, 0, 0, 45)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    tabsFrame.BackgroundTransparency = 0.5
    tabsFrame.Parent = main
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = tabsFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabList
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -135, 1, -55)
    contentFrame.Position = UDim2.new(0, 130, 0, 50)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    contentFrame.BackgroundTransparency = 0.3
    MakeRounded(contentFrame, 8)
    contentFrame.Parent = main
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local window = {
        screenGui = screenGui,
        main = main,
        contentFrame = contentFrame,
        tabList = tabList,
        tabLayout = tabLayout,
        tabs = {},
        currentTab = nil
    }
    
    function window:AddTab(name, icon)
        icon = icon or ""
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.Text = icon ~= "" and (icon .. "  " .. name) or name
        btn.TextColor3 = Color3.fromRGB(180, 180, 210)
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundTransparency = 1
        MakeRounded(btn, 6)
        btn.Parent = self.tabList
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = self.contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        btn.MouseButton1Click:Connect(function()
            for _, t in pairs(self.tabs) do
                t.content.Visible = false
                Tween(t.button, {BackgroundColor3 = Color3.fromRGB(0, 0, 0), TextColor3 = Color3.fromRGB(180, 180, 210)}, 0.1)
                t.button.BackgroundTransparency = 1
            end
            tabContent.Visible = true
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
            btn.BackgroundTransparency = 0.1
        end)
        
        local tab = {
            button = btn,
            content = tabContent,
            layout = contentLayout,
            elements = {}
        }
        
        function tab:AddSection(title)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabContent
            
            local header = Instance.new("TextLabel")
            header.Size = UDim2.new(1, 0, 0, 30)
            header.Text = title
            header.TextColor3 = Color3.fromRGB(100, 100, 255)
            header.TextSize = 14
            header.Font = Enum.Font.GothamBold
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.BackgroundTransparency = 1
            header.Parent = sectionFrame
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 28)
            line.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            line.BackgroundTransparency = 0.5
            line.Parent = sectionFrame
            
            local elementsFrame = Instance.new("Frame")
            elementsFrame.Size = UDim2.new(1, 0, 0, 0)
            elementsFrame.Position = UDim2.new(0, 0, 0, 35)
            elementsFrame.BackgroundTransparency = 1
            elementsFrame.AutomaticSize = Enum.AutomaticSize.Y
            elementsFrame.Parent = sectionFrame
            
            local elementsLayout = Instance.new("UIListLayout")
            elementsLayout.Padding = UDim.new(0, 8)
            elementsLayout.Parent = elementsFrame
            
            local section = {
                frame = sectionFrame,
                elementsFrame = elementsFrame,
                elements = {}
            }
            
            function section:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextSize = 13
                btn.Font = Enum.Font.GothamSemibold
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(btn, 8)
                MakeStroke(btn, 1, Color3.fromRGB(80, 80, 120))
                btn.Parent = elementsFrame
                
                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(55, 55, 85)}, 0.1)
                end)
                
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}, 0.1)
                end)
                
                btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                    Notify(text, "Executed!", "success", 1.5)
                end)
                
                table.insert(section.elements, btn)
                return btn
            end
            
            function section:AddToggle(text, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 40)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 120))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 13
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 26)
                toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
                toggleBtn.Text = ""
                toggleBtn.BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)
                MakeRounded(toggleBtn, 13)
                toggleBtn.Parent = frame
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 22, 0, 22)
                knob.Position = UDim2.new(0, default and 26 or 2, 0.5, -11)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                MakeRounded(knob, 11)
                knob.Parent = toggleBtn
                
                local state = default
                
                toggleBtn.MouseButton1Click:Connect(function()
                    state = not state
                    Tween(toggleBtn, {BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)}, 0.2)
                    Tween(knob, {Position = UDim2.new(0, state and 26 or 2, 0.5, -11)}, 0.2)
                    if callback then callback(state) end
                    Notify(text, state and "Enabled" or "Disabled", state and "success" or "info", 1)
                end)
                
                table.insert(section.elements, {frame = frame, toggle = toggleBtn, state = state})
                return {setValue = function(v) 
                    state = v
                    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)
                    knob.Position = UDim2.new(0, state and 26 or 2, 0.5, -11)
                    if callback then callback(state) end
                end}
            end
            
            function section:AddSlider(text, min, max, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 70)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 120))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -80, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 5)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = 13
                label.Font = Enum.Font.GothamSemibold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 60, 0, 25)
                valueLabel.Position = UDim2.new(1, -72, 0, 5)
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
                valueLabel.TextSize = 12
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.BackgroundTransparency = 1
                valueLabel.Parent = frame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -24, 0, 4)
                sliderBg.Position = UDim2.new(0, 12, 0, 45)
                sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                MakeRounded(sliderBg, 2)
                sliderBg.Parent = frame
                
                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                MakeRounded(fill, 2)
                fill.Parent = sliderBg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 16, 0, 16)
                knob.Position = UDim2.new(percent, -8, 0.5, -8)
                knob.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                MakeRounded(knob, 8)
                knob.Parent = sliderBg
                
                local dragging = false
                local value = default
                
                local function update(pos)
                    local relative = math.clamp((pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (relative * (max - min))
                    value = math.floor(newVal + 0.5)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    knob.Position = UDim2.new(relative, -8, 0.5, -8)
                    if callback then callback(value) end
                end
                
                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                UIS.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
                
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        update(input)
                        dragging = true
                    end
                end)
                
                table.insert(section.elements, frame)
                return {setValue = function(v) 
                    value = math.clamp(v, min, max)
                    local p = (value - min) / (max - min)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -8, 0.5, -8)
                    if callback then callback(value) end
                end}
            end
            
            function section:AddLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(180, 180, 210)
                label.TextSize = 11
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = elementsFrame
                table.insert(section.elements, label)
                return label
            end
            
            table.insert(tab.elements, section)
            return section
        end
        
        table.insert(self.tabs, tab)
        
        -- Select first tab
        if #self.tabs == 1 then
            tabContent.Visible = true
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
            btn.BackgroundTransparency = 0.1
        end
        
        return tab
    end
    
    function window:Notify(title, msg, typ, duration)
        Notify(title, msg, typ, duration)
    end
    
    table.insert(Hub.windows, window)
    Hub.currentWindow = window
    
    return window
end

-- ============================================================================
-- CREATE THE SCRIPT HUB
-- ============================================================================
local HubWindow = Hub:CreateWindow("Script Hub Pro", 400, 600)

-- ========== TAB 1: PLAYER ==========
local PlayerTab = HubWindow:AddTab("Player", "👤")

local Movement = PlayerTab:AddSection("Movement")
Movement:AddSlider("Walk Speed", 16, 250, 16, function(v)
    local hrp = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hrp then hrp.WalkSpeed = v end
end)

Movement:AddSlider("Jump Power", 50, 250, 50, function(v)
    local hrp = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hrp then hrp.JumpPower = v end
end)

Movement:AddButton("Super Jump (100)", function()
    local hrp = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hrp then hrp.JumpPower = 100 end
end)

Movement:AddButton("Reset Jump (50)", function()
    local hrp = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hrp then hrp.JumpPower = 50 end
end)

local Visuals = PlayerTab:AddSection("Visuals")

local noclipState = false
local noclipToggle = Visuals:AddToggle("Noclip", false, function(s)
    noclipState = s
end)

-- Noclip loop
task.spawn(function()
    while task.wait(0.1) do
        if noclipState and LP.Character then
            for _, part in pairs(LP.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

local fullbrightState = false
Visuals:AddToggle("Fullbright", false, function(s)
    fullbrightState = s
    if s then
        LS.Brightness = 2
        LS.GlobalShadows = false
        LS.ClockTime = 12
    else
        LS.Brightness = 0.5
        LS.GlobalShadows = true
    end
end)

-- ========== TAB 2: COMBAT ==========
local CombatTab = HubWindow:AddTab("Combat", "⚔️")

local Scripts = CombatTab:AddSection("Scripts")
Scripts:AddButton("Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

Scripts:AddButton("Cmd-X", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source', true))()
end)

Scripts:AddButton("Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/DexV2.lua"))()
end)

local Combat = CombatTab:AddSection("Combat")
Combat:AddButton("Kill All (Visual)", function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Humanoid") then
            p.Character.Humanoid.Health = 0
        end
    end
end)

-- ========== TAB 3: UTILITY ==========
local UtilityTab = HubWindow:AddTab("Utility", "🔧")

local Teleport = UtilityTab:AddSection("Teleport")
Teleport:AddButton("Rejoin Game", function()
    TPS:Teleport(game.PlaceId, LP)
end)

Teleport:AddButton("Server Hop", function()
    TPS:Teleport(game.PlaceId)
end)

local Misc = UtilityTab:AddSection("Misc")
Misc:AddButton("Heal Full", function()
    local hrp = LP.Character and LP.Character:FindFirstChild("Humanoid")
    if hrp then hrp.Health = hrp.MaxHealth end
end)

Misc:AddButton("Copy Game ID", function()
    if setclipboard then
        setclipboard(game.PlaceId)
        HubWindow:Notify("Copied", "Game ID copied!", "success", 1.5)
    end
end)

-- ========== TAB 4: SETTINGS ==========
local SettingsTab = HubWindow:AddTab("Settings", "⚙️")

local Display = SettingsTab:AddSection("Display")
Display:AddButton("Small Mode (350x500)", function()
    HubWindow.main.Size = UDim2.new(0, 350, 0, 500)
    HubWindow.main.Position = UDim2.new(0.5, -175, 0.5, -250)
end)

Display:AddButton("Default Mode (400x600)", function()
    HubWindow.main.Size = UDim2.new(0, 400, 0, 600)
    HubWindow.main.Position = UDim2.new(0.5, -200, 0.5, -300)
end)

Display:AddButton("Large Mode (500x700)", function()
    HubWindow.main.Size = UDim2.new(0, 500, 0, 700)
    HubWindow.main.Position = UDim2.new(0.5, -250, 0.5, -350)
end)

local Info = SettingsTab:AddSection("Info")
Info:AddLabel("Username: " .. LP.Name)
Info:AddLabel("Display: " .. (LP.DisplayName or LP.Name))
Info:AddLabel("User ID: " .. LP.UserId)
Info:AddLabel("Game: " .. game.Name)

-- Welcome notification
HubWindow:Notify("Welcome!", "Script Hub Pro Loaded Successfully!", "success", 3)

print("Script Hub Pro Loaded!")
