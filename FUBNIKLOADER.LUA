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
    ║         FUBNIK v7.0 - ADVANCED AUTO SCALING               ║
    ║    Tap-Friendly | Anti-Overlap | File System Ready        ║
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- FILE SYSTEM MODULE (Create folders and save/load configs)
-- ============================================================================
local FileSystem = {}

-- Check if we can use file system
local function canUseFileSystem()
    local success, result = pcall(function()
        return isfolder and writefile and readfile and makefolder and delfolder and listfiles
    end)
    return success and result
end

-- Create all necessary folders
function FileSystem:Initialize()
    if not canUseFileSystem() then
        warn("[FUBNIK] File system not available (executor doesn't support it)")
        return false
    end
    
    local folders = {
        "FUBNIK",
        "FUBNIK/Configs",
        "FUBNIK/Scripts",
        "FUBNIK/Data"
    }
    
    for _, folder in pairs(folders) do
        pcall(function()
            if not isfolder(folder) then
                makefolder(folder)
            end
        end)
    end
    
    print("[FUBNIK] File system initialized!")
    return true
end

-- Save config to file
function FileSystem:SaveConfig(name, data)
    if not canUseFileSystem() then return false end
    
    local success, result = pcall(function()
        local jsonData = game:GetService("HttpService"):JSONEncode(data)
        writefile("FUBNIK/Configs/" .. name .. ".json", jsonData)
    end)
    
    return success
end

-- Load config from file
function FileSystem:LoadConfig(name)
    if not canUseFileSystem() then return nil end
    
    local success, result = pcall(function()
        local data = readfile("FUBNIK/Configs/" .. name .. ".json")
        return game:GetService("HttpService"):JSONDecode(data)
    end)
    
    if success then
        return result
    end
    return nil
end

-- List all saved configs
function FileSystem:ListConfigs()
    if not canUseFileSystem() then return {} end
    
    local success, result = pcall(function()
        local files = listfiles("FUBNIK/Configs")
        local configs = {}
        for _, file in pairs(files) do
            local name = file:match("([^/]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
        return configs
    end)
    
    if success then
        return result
    end
    return {}
end

-- Delete config
function FileSystem:DeleteConfig(name)
    if not canUseFileSystem() then return false end
    
    local success, result = pcall(function()
        delfile("FUBNIK/Configs/" .. name .. ".json")
    end)
    
    return success
end

-- Save script to file
function FileSystem:SaveScript(name, code)
    if not canUseFileSystem() then return false end
    
    local success, result = pcall(function()
        writefile("FUBNIK/Scripts/" .. name .. ".lua", code)
    end)
    
    return success
end

-- Load script from file
function FileSystem:LoadScript(name)
    if not canUseFileSystem() then return nil end
    
    local success, result = pcall(function()
        return readfile("FUBNIK/Scripts/" .. name .. ".lua")
    end)
    
    if success then
        return result
    end
    return nil
end

-- ============================================================================
-- AUTO DEVICE DETECTION & SCALING
-- ============================================================================
local Device = {
    Type = "Unknown",
    ScreenWidth = 0,
    ScreenHeight = 0,
    Scale = 1,
    RecommendedWidth = 0,
    RecommendedHeight = 0,
    ButtonHeight = 0,
    FontSize = 0,
    SidebarWidth = 0,
    Padding = 0,
    Spacing = 0,
    IsMobile = false
}

-- Auto detect device and calculate perfect sizes
function Device:Detect()
    local camera = workspace.CurrentCamera
    self.ScreenWidth = camera.ViewportSize.X
    self.ScreenHeight = camera.ViewportSize.Y
    self.IsMobile = game:GetService("UserInputService").TouchEnabled
    local aspectRatio = self.ScreenWidth / self.ScreenHeight
    
    -- Detect device type
    if self.IsMobile then
        self.Type = "Mobile"
        self.RecommendedWidth = math.min(380, self.ScreenWidth - 20)
        self.RecommendedHeight = math.min(620, self.ScreenHeight - 60)
        self.ButtonHeight = 50
        self.FontSize = 16
        self.SidebarWidth = 110
        self.Padding = 12
        self.Spacing = 12
        self.Scale = 0.9
    elseif aspectRatio > 1.6 then
        self.Type = "Desktop Wide"
        self.RecommendedWidth = math.min(480, self.ScreenWidth * 0.35)
        self.RecommendedHeight = math.min(680, self.ScreenHeight - 100)
        self.ButtonHeight = 42
        self.FontSize = 14
        self.SidebarWidth = 140
        self.Padding = 15
        self.Spacing = 10
        self.Scale = 1
    elseif aspectRatio > 1.3 then
        self.Type = "Desktop"
        self.RecommendedWidth = math.min(450, self.ScreenWidth * 0.4)
        self.RecommendedHeight = math.min(650, self.ScreenHeight - 100)
        self.ButtonHeight = 40
        self.FontSize = 13
        self.SidebarWidth = 135
        self.Padding = 12
        self.Spacing = 8
        self.Scale = 1
    else
        self.Type = "Tablet"
        self.RecommendedWidth = math.min(520, self.ScreenWidth - 40)
        self.RecommendedHeight = math.min(720, self.ScreenHeight - 80)
        self.ButtonHeight = 52
        self.FontSize = 16
        self.SidebarWidth = 145
        self.Padding = 15
        self.Spacing = 12
        self.Scale = 1.1
    end
    
    print(string.format("[FUBNIK] Device Detected: %s | Size: %dx%d | Mobile: %s", 
        self.Type, self.RecommendedWidth, self.RecommendedHeight, tostring(self.IsMobile)))
    
    return self
end

function Device:GetWindowSize()
    return self.RecommendedWidth, self.RecommendedHeight
end

function Device:GetButtonHeight()
    return self.ButtonHeight
end

Device:Detect()

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
local HS = game:GetService("HttpService")

-- ============================================================================
-- UTILITIES
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
    local t = TS:Create(obj, TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- Tap detection helper (works for both mouse and touch)
local function BindButtonClick(button, callback)
    -- Mouse click
    button.MouseButton1Click:Connect(callback)
    -- Touch tap (mobile)
    button.TouchTap:Connect(callback)
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================
local NotifyContainer = nil

local function CreateNotifyContainer()
    if NotifyContainer and NotifyContainer.Parent then return end
    NotifyContainer = Instance.new("Frame")
    NotifyContainer.Name = "NotifContainer"
    NotifyContainer.Size = UDim2.new(0, 340, 1, -20)
    NotifyContainer.Position = UDim2.new(1, -350, 0, 10)
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
    iconL.Size = UDim2.new(0, 32, 0, 32)
    iconL.Position = UDim2.new(0, 10, 0, 10)
    iconL.Text = icons[typ]
    iconL.TextSize = 18
    iconL.BackgroundTransparency = 1
    iconL.Parent = frame
    
    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -55, 0, 28)
    titleL.Position = UDim2.new(0, 48, 0, 8)
    titleL.Text = title
    titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleL.TextSize = 15
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.BackgroundTransparency = 1
    titleL.Parent = frame
    
    local msgL = Instance.new("TextLabel")
    msgL.Size = UDim2.new(1, -55, 0, 0)
    msgL.Position = UDim2.new(0, 48, 0, 36)
    msgL.Text = msg
    msgL.TextColor3 = Color3.fromRGB(180, 180, 210)
    msgL.TextSize = 12
    msgL.Font = Enum.Font.Gotham
    msgL.TextXAlignment = Enum.TextXAlignment.Left
    msgL.TextWrapped = true
    msgL.BackgroundTransparency = 1
    msgL.AutomaticSize = Enum.AutomaticSize.Y
    msgL.Parent = frame
    
    local h = msgL.AbsoluteSize.Y + 60
    Tween(frame, {Size = UDim2.new(1, -10, 0, h)}, 0.2)
    
    task.spawn(function()
        task.wait(duration)
        if frame and frame.Parent then
            Tween(frame, {Size = UDim2.new(1, -10, 0, 0), BackgroundTransparency = 1}, 0.15)
            task.wait(0.15)
            frame:Destroy()
        end
    end)
end

-- ============================================================================
-- LOADING SCREEN
-- ============================================================================
local function ShowLoading(message, duration)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CG
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.6
    overlay.Parent = screenGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 130)
    frame.Position = UDim2.new(0.5, -130, 0.5, -65)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    MakeRounded(frame, 12)
    MakeStroke(frame, 1.5, Color3.fromRGB(100, 100, 255))
    frame.Parent = overlay
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 0, 45)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.Text = message or "Loading..."
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.BackgroundTransparency = 1
    text.Parent = frame
    
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0, 35, 0, 35)
    spinner.Position = UDim2.new(0.5, -17.5, 0, 70)
    spinner.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    MakeRounded(spinner, 17.5)
    spinner.Parent = frame
    
    local spin = 0
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        spin = spin + 12
        spinner.Rotation = spin
    end)
    
    if duration then
        task.spawn(function()
            task.wait(duration)
            if conn then conn:Disconnect() end
            screenGui:Destroy()
        end)
    end
    
    return {
        Hide = function()
            if conn then conn:Disconnect() end
            screenGui:Destroy()
        end
    }
end

-- ============================================================================
-- SIMPLE GUI CREATOR WITH AUTO SCALING & ANTI-OVERLAP
-- ============================================================================
local Hub = {
    windows = {},
    currentWindow = nil,
    Device = Device,
    FileSystem = FileSystem
}

function Hub:CreateWindow(name, customWidth, customHeight)
    local width = customWidth or Device.RecommendedWidth
    local height = customHeight or Device.RecommendedHeight
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FUBNIK_Hub_" .. tostring(os.time())
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
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = main
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -55, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = name .. " (" .. Device.Type .. ")"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = Device.FontSize + 1
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 38, 0, 38)
    closeBtn.Position = UDim2.new(1, -45, 0, 6)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = titleBar
    
    -- Tabs container with anti-overlap
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0, Device.SidebarWidth, 1, -50)
    tabsFrame.Position = UDim2.new(0, 0, 0, 50)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    tabsFrame.BackgroundTransparency = 0.3
    tabsFrame.ClipsDescendants = true
    tabsFrame.Parent = main
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.Parent = tabsFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabList
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Content area - properly spaced
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -(Device.SidebarWidth + 20), 1, -60)
    contentFrame.Position = UDim2.new(0, Device.SidebarWidth + 12, 0, 55)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    contentFrame.BackgroundTransparency = 0.2
    MakeRounded(contentFrame, 10)
    contentFrame.Parent = main
    
    -- Draggable
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    BindButtonClick(closeBtn, function()
        screenGui:Destroy()
    end)
    
    local window = {
        screenGui = screenGui,
        main = main,
        contentFrame = contentFrame,
        tabList = tabList,
        tabs = {},
        currentTab = nil,
        device = Device,
        fileSystem = FileSystem
    }
    
    function window:AddTab(name, icon)
        icon = icon or ""
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, Device.ButtonHeight)
        btn.Text = icon ~= "" and (icon .. "  " .. name) or name
        btn.TextColor3 = Color3.fromRGB(180, 180, 210)
        btn.TextSize = Device.FontSize - 1
        btn.Font = Enum.Font.GothamSemibold
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundTransparency = 1
        MakeRounded(btn, 8)
        btn.Parent = self.tabList
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, -20, 1, -15)
        tabContent.Position = UDim2.new(0, 10, 0, 8)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = self.contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, Device.Spacing)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        local function selectTab()
            for _, t in pairs(self.tabs) do
                t.content.Visible = false
                Tween(t.button, {BackgroundColor3 = Color3.fromRGB(0, 0, 0), TextColor3 = Color3.fromRGB(180, 180, 210)}, 0.1)
                t.button.BackgroundTransparency = 1
            end
            tabContent.Visible = true
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(45, 45, 75), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
            btn.BackgroundTransparency = 0.15
        end
        
        BindButtonClick(btn, selectTab)
        
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
            header.Size = UDim2.new(1, -15, 0, 35)
            header.Position = UDim2.new(0, 8, 0, 0)
            header.Text = title
            header.TextColor3 = Color3.fromRGB(110, 110, 255)
            header.TextSize = Device.FontSize + 1
            header.Font = Enum.Font.GothamBold
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.BackgroundTransparency = 1
            header.Parent = sectionFrame
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, -16, 0, 1.5)
            line.Position = UDim2.new(0, 8, 0, 32)
            line.BackgroundColor3 = Color3.fromRGB(100, 100, 180)
            line.BackgroundTransparency = 0.4
            line.Parent = sectionFrame
            
            local elementsFrame = Instance.new("Frame")
            elementsFrame.Size = UDim2.new(1, 0, 0, 0)
            elementsFrame.Position = UDim2.new(0, 8, 0, 42)
            elementsFrame.BackgroundTransparency = 1
            elementsFrame.AutomaticSize = Enum.AutomaticSize.Y
            elementsFrame.Parent = sectionFrame
            
            local elementsLayout = Instance.new("UIListLayout")
            elementsLayout.Padding = UDim.new(0, 10)
            elementsLayout.Parent = elementsFrame
            
            local section = {
                frame = sectionFrame,
                elementsFrame = elementsFrame,
                elements = {}
            }
            
            function section:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -8, 0, Device.ButtonHeight)
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextSize = Device.FontSize
                btn.Font = Enum.Font.GothamSemibold
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                MakeRounded(btn, 10)
                MakeStroke(btn, 1, Color3.fromRGB(80, 80, 130))
                btn.Parent = elementsFrame
                
                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(60, 60, 85)}, 0.1)
                end)
                
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}, 0.1)
                end)
                
                BindButtonClick(btn, function()
                    if callback then callback() end
                end)
                
                table.insert(section.elements, btn)
                return btn
            end
            
            function section:AddToggle(text, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -8, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                MakeRounded(frame, 10)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 130))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -85, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 55, 0, 30)
                toggleBtn.Position = UDim2.new(1, -65, 0.5, -15)
                toggleBtn.Text = ""
                toggleBtn.BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(70, 70, 100)
                MakeRounded(toggleBtn, 15)
                toggleBtn.Parent = frame
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 24, 0, 24)
                knob.Position = UDim2.new(0, default and 28 or 3, 0.5, -12)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                MakeRounded(knob, 12)
                knob.Parent = toggleBtn
                
                local state = default
                
                local function toggle()
                    state = not state
                    Tween(toggleBtn, {BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(70, 70, 100)}, 0.15)
                    Tween(knob, {Position = UDim2.new(0, state and 28 or 3, 0.5, -12)}, 0.15)
                    if callback then callback(state) end
                end
                
                BindButtonClick(toggleBtn, toggle)
                
                table.insert(section.elements, {frame = frame, toggle = toggleBtn, state = state})
                return {
                    setValue = function(v)
                        state = v
                        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(70, 70, 100)
                        knob.Position = UDim2.new(0, state and 28 or 3, 0.5, -12)
                        if callback then callback(state) end
                    end,
                    getValue = function() return state end
                }
            end
            
            function section:AddSlider(text, min, max, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -8, 0, 85)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                MakeRounded(frame, 10)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 130))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -100, 0, 30)
                label.Position = UDim2.new(0, 12, 0, 8)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize
                label.Font = Enum.Font.GothamSemibold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 70, 0, 30)
                valueLabel.Position = UDim2.new(1, -82, 0, 8)
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
                valueLabel.TextSize = Device.FontSize + 1
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.BackgroundTransparency = 1
                valueLabel.Parent = frame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -24, 0, 6)
                sliderBg.Position = UDim2.new(0, 12, 0, 52)
                sliderBg.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
                MakeRounded(sliderBg, 3)
                sliderBg.Parent = frame
                
                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                MakeRounded(fill, 3)
                fill.Parent = sliderBg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 22, 0, 22)
                knob.Position = UDim2.new(percent, -11, 0.5, -11)
                knob.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                MakeRounded(knob, 11)
                knob.Parent = sliderBg
                
                local dragging = false
                local value = default
                
                local function update(pos)
                    local relative = math.clamp((pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (relative * (max - min))
                    value = math.floor(newVal + 0.5)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    knob.Position = UDim2.new(relative, -11, 0.5, -11)
                    if callback then callback(value) end
                end
                
                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                
                UIS.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
                
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        update(input)
                    end
                end)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(v)
                        value = math.clamp(v, min, max)
                        local p = (value - min) / (max - min)
                        valueLabel.Text = tostring(value)
                        fill.Size = UDim2.new(p, 0, 1, 0)
                        knob.Position = UDim2.new(p, -11, 0.5, -11)
                        if callback then callback(value) end
                    end,
                    getValue = function() return value end
                }
            end
            
            function section:AddDropdown(text, options, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -8, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                MakeRounded(frame, 10)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 130))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -120, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Size = UDim2.new(0, 110, 0, 36)
                dropdownBtn.Position = UDim2.new(1, -120, 0.5, -18)
                dropdownBtn.Text = default or options[1]
                dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdownBtn.TextSize = Device.FontSize - 1
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
                MakeRounded(dropdownBtn, 8)
                dropdownBtn.Parent = frame
                
                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0, 28, 1, 0)
                arrow.Position = UDim2.new(1, -28, 0, 0)
                arrow.Text = "▼"
                arrow.TextColor3 = Color3.fromRGB(180, 180, 210)
                arrow.TextSize = 11
                arrow.BackgroundTransparency = 1
                arrow.Parent = dropdownBtn
                
                local listVisible = false
                local list = nil
                
                BindButtonClick(dropdownBtn, function()
                    if list then list:Destroy() end
                    listVisible = true
                    
                    list = Instance.new("ScrollingFrame")
                    list.Size = UDim2.new(0, 130, 0, 0)
                    list.Position = UDim2.new(1, -140, 0, 50)
                    list.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                    MakeRounded(list, 8)
                    MakeStroke(list, 1, Color3.fromRGB(80, 80, 130))
                    list.ScrollBarThickness = 2
                    list.ClipsDescendants = true
                    list.ZIndex = 10
                    list.Parent = frame
                    
                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Padding = UDim.new(0, 2)
                    listLayout.Parent = list
                    
                    local height = 0
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, -10, 0, 36)
                        optBtn.Position = UDim2.new(0, 5, 0, height)
                        optBtn.Text = opt
                        optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                        optBtn.TextSize = Device.FontSize - 1
                        optBtn.Font = Enum.Font.Gotham
                        optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 70)
                        MakeRounded(optBtn, 6)
                        optBtn.Parent = list
                        
                        BindButtonClick(optBtn, function()
                            dropdownBtn.Text = opt
                            if callback then callback(opt) end
                            list:Destroy()
                            listVisible = false
                        end)
                        
                        height = height + 40
                    end
                    
                    list.CanvasSize = UDim2.new(0, 0, 0, height)
                    list.Size = UDim2.new(0, 130, 0, math.min(height, 180))
                end)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(val)
                        dropdownBtn.Text = val
                        if callback then callback(val) end
                    end,
                    getValue = function() return dropdownBtn.Text end
                }
            end
            
            function section:AddLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -16, 0, 28)
                label.Position = UDim2.new(0, 8, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(180, 180, 210)
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = elementsFrame
                table.insert(section.elements, label)
                return label
            end
            
            function section:AddTextInput(text, placeholder, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, -8, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                MakeRounded(frame, 10)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 130))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -120, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(0, 140, 0, 36)
                textBox.Position = UDim2.new(1, -150, 0.5, -18)
                textBox.PlaceholderText = placeholder or "Enter text..."
                textBox.Text = ""
                textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                textBox.TextSize = Device.FontSize - 1
                textBox.Font = Enum.Font.Gotham
                textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
                MakeRounded(textBox, 8)
                textBox.Parent = frame
                
                textBox.FocusLost:Connect(function(enterPressed)
                    if callback and textBox.Text ~= "" then
                        callback(textBox.Text)
                    end
                end)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(val) textBox.Text = val end,
                    getValue = function() return textBox.Text end
                }
            end
            
            return section
        end
        
        table.insert(self.tabs, tab)
        
        if #self.tabs == 1 then
            tabContent.Visible = true
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(45, 45, 75), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
            btn.BackgroundTransparency = 0.15
        end
        
        return tab
    end
    
    function window:AddUserInfo()
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, -20, 0, 0)
        container.Position = UDim2.new(0, 10, 0, 0)
        container.BackgroundTransparency = 1
        container.AutomaticSize = Enum.AutomaticSize.Y
        container.Parent = self.contentFrame
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 110)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        MakeRounded(frame, 12)
        MakeStroke(frame, 1, Color3.fromRGB(80, 80, 140))
        frame.Parent = container
        
        local avatar = Instance.new("Frame")
        avatar.Size = UDim2.new(0, 65, 0, 65)
        avatar.Position = UDim2.new(0, 15, 0, 22)
        avatar.BackgroundColor3 = Color3.fromRGB(55, 55, 90)
        MakeRounded(avatar, 32.5)
        MakeStroke(avatar, 2, Color3.fromRGB(100, 100, 255))
        avatar.Parent = frame
        
        local avatarText = Instance.new("TextLabel")
        avatarText.Size = UDim2.new(1, 0, 1, 0)
        avatarText.Text = "👤"
        avatarText.TextSize = 32
        avatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
        avatarText.BackgroundTransparency = 1
        avatarText.Parent = avatar
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -95, 0, 32)
        nameLabel.Position = UDim2.new(0, 95, 0, 15)
        nameLabel.Text = LP.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = Device.FontSize + 2
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = frame
        
        local displayLabel = Instance.new("TextLabel")
        displayLabel.Size = UDim2.new(1, -95, 0, 24)
        displayLabel.Position = UDim2.new(0, 95, 0, 47)
        displayLabel.Text = "@" .. (LP.DisplayName or LP.Name)
        displayLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
        displayLabel.TextSize = Device.FontSize - 1
        displayLabel.Font = Enum.Font.Gotham
        displayLabel.TextXAlignment = Enum.TextXAlignment.Left
        displayLabel.BackgroundTransparency = 1
        displayLabel.Parent = frame
        
        local idLabel = Instance.new("TextLabel")
        idLabel.Size = UDim2.new(1, -95, 0, 22)
        idLabel.Position = UDim2.new(0, 95, 0, 71)
        idLabel.Text = "ID: " .. LP.UserId
        idLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
        idLabel.TextSize = Device.FontSize - 2
        idLabel.Font = Enum.Font.Gotham
        idLabel.TextXAlignment = Enum.TextXAlignment.Left
        idLabel.BackgroundTransparency = 1
        idLabel.Parent = frame
        
        return container
    end
    
    function window:Notify(title, msg, typ, duration)
        Notify(title, msg, typ, duration)
    end
    
    function window:ShowLoading(message, duration)
        return ShowLoading(message, duration)
    end
    
    function window:GetDeviceInfo()
        return Device.Type, Device.RecommendedWidth, Device.RecommendedHeight
    end
    
    function window:GetFileSystem()
        return FileSystem
    end
    
    -- Save current config (example usage)
    function window:SaveConfig(name, data)
        return FileSystem:SaveConfig(name, data)
    end
    
    function window:LoadConfig(name)
        return FileSystem:LoadConfig(name)
    end
    
    function window:ListConfigs()
        return FileSystem:ListConfigs()
    end
    
    table.insert(Hub.windows, window)
    Hub.currentWindow = window
    
    return window
end

-- Initialize file system
FileSystem:Initialize()

-- Return the Hub for use
return Hub
