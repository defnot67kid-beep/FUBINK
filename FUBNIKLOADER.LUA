--[[
    ╔════════════════════════════════════════════════════════════════════════════╗
    ║                                                                            ║
    ║   ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗██╗  ██╗                           ║
    ║   ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚██╗██╔╝                           ║
    ║   █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║ ╚███╔╝                            ║
    ║   ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║ ██╔██╗                            ║
    ║   ██║     ╚██████╔╝██████╔╝██║ ╚████║██║██╔╝ ██╗                           ║
    ║   ╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝                           ║
    ║                                                                            ║
    ║                   FUBNIK - COMPLETE CUSTOM UI                              ║
    ║              Name ANYTHING | Position ANYTHING                             ║
    ║                    NO RESTRICTIONS WHATSOEVER                              ║
    ╚════════════════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local MPS = game:GetService("MarketplaceService")

-- ============================================================================
-- COMPLETE COLOR LIBRARY - 200+ COLORS
-- ============================================================================
local Colors = {
    -- REDS
    ["red"] = Color3.fromRGB(255, 0, 0),
    ["crimson"] = Color3.fromRGB(220, 20, 60),
    ["scarlet"] = Color3.fromRGB(255, 36, 0),
    ["ruby"] = Color3.fromRGB(224, 17, 95),
    ["cherry"] = Color3.fromRGB(222, 49, 99),
    ["brick"] = Color3.fromRGB(203, 65, 84),
    ["blood"] = Color3.fromRGB(138, 3, 3),
    ["dark red"] = Color3.fromRGB(139, 0, 0),
    ["maroon"] = Color3.fromRGB(128, 0, 0),
    ["rose"] = Color3.fromRGB(255, 0, 127),
    ["coral"] = Color3.fromRGB(255, 127, 80),
    ["salmon"] = Color3.fromRGB(250, 128, 114),
    ["tomato"] = Color3.fromRGB(255, 99, 71),
    ["rust"] = Color3.fromRGB(183, 65, 14),
    ["burgundy"] = Color3.fromRGB(128, 0, 32),
    ["wine"] = Color3.fromRGB(114, 47, 55),
    ["candy"] = Color3.fromRGB(255, 75, 75),
    ["apple"] = Color3.fromRGB(165, 42, 42),
    ["chili"] = Color3.fromRGB(199, 58, 37),
    ["amber red"] = Color3.fromRGB(204, 49, 38),
    
    -- ORANGES
    ["orange"] = Color3.fromRGB(255, 165, 0),
    ["dark orange"] = Color3.fromRGB(255, 140, 0),
    ["tangerine"] = Color3.fromRGB(242, 133, 0),
    ["pumpkin"] = Color3.fromRGB(255, 117, 24),
    ["amber"] = Color3.fromRGB(255, 191, 0),
    ["gold"] = Color3.fromRGB(255, 215, 0),
    ["peach"] = Color3.fromRGB(255, 218, 185),
    ["apricot"] = Color3.fromRGB(251, 206, 177),
    ["mango"] = Color3.fromRGB(255, 130, 67),
    ["coral orange"] = Color3.fromRGB(255, 114, 86),
    ["burnt orange"] = Color3.fromRGB(204, 85, 0),
    ["carrot"] = Color3.fromRGB(237, 145, 33),
    ["sunset"] = Color3.fromRGB(253, 94, 83),
    ["peach orange"] = Color3.fromRGB(255, 204, 153),
    
    -- YELLOWS
    ["yellow"] = Color3.fromRGB(255, 255, 0),
    ["lemon"] = Color3.fromRGB(247, 255, 0),
    ["canary"] = Color3.fromRGB(255, 255, 153),
    ["golden"] = Color3.fromRGB(255, 223, 0),
    ["mustard"] = Color3.fromRGB(255, 219, 88),
    ["honey"] = Color3.fromRGB(254, 194, 12),
    ["butter"] = Color3.fromRGB(255, 236, 139),
    ["cream"] = Color3.fromRGB(255, 253, 208),
    ["banana"] = Color3.fromRGB(255, 225, 53),
    ["flax"] = Color3.fromRGB(238, 220, 130),
    ["saffron"] = Color3.fromRGB(244, 196, 48),
    ["dandelion"] = Color3.fromRGB(240, 225, 48),
    ["sunflower"] = Color3.fromRGB(218, 165, 32),
    
    -- GREENS
    ["green"] = Color3.fromRGB(0, 255, 0),
    ["lime"] = Color3.fromRGB(50, 205, 50),
    ["forest"] = Color3.fromRGB(34, 139, 34),
    ["dark green"] = Color3.fromRGB(0, 100, 0),
    ["emerald"] = Color3.fromRGB(80, 200, 120),
    ["mint"] = Color3.fromRGB(152, 255, 152),
    ["sage"] = Color3.fromRGB(188, 196, 136),
    ["olive"] = Color3.fromRGB(128, 128, 0),
    ["chartreuse"] = Color3.fromRGB(127, 255, 0),
    ["seaweed"] = Color3.fromRGB(45, 118, 69),
    ["pine"] = Color3.fromRGB(1, 68, 33),
    ["jade"] = Color3.fromRGB(0, 168, 107),
    ["moss"] = Color3.fromRGB(138, 154, 91),
    ["spring"] = Color3.fromRGB(0, 255, 127),
    ["tea"] = Color3.fromRGB(208, 240, 192),
    ["viridian"] = Color3.fromRGB(64, 130, 109),
    ["apple green"] = Color3.fromRGB(141, 182, 0),
    ["fern"] = Color3.fromRGB(79, 121, 66),
    ["hunter"] = Color3.fromRGB(53, 94, 59),
    ["kelp"] = Color3.fromRGB(73, 101, 60),
    
    -- BLUES
    ["blue"] = Color3.fromRGB(0, 0, 255),
    ["dark blue"] = Color3.fromRGB(0, 0, 139),
    ["navy"] = Color3.fromRGB(0, 0, 128),
    ["cobalt"] = Color3.fromRGB(0, 71, 171),
    ["royal"] = Color3.fromRGB(65, 105, 225),
    ["ocean"] = Color3.fromRGB(0, 119, 190),
    ["sky"] = Color3.fromRGB(135, 206, 235),
    ["azure"] = Color3.fromRGB(0, 127, 255),
    ["cerulean"] = Color3.fromRGB(0, 123, 167),
    ["baby blue"] = Color3.fromRGB(137, 207, 240),
    ["powder"] = Color3.fromRGB(176, 224, 230),
    ["steel"] = Color3.fromRGB(70, 130, 180),
    ["cyan"] = Color3.fromRGB(0, 255, 255),
    ["teal"] = Color3.fromRGB(0, 128, 128),
    ["aqua"] = Color3.fromRGB(0, 255, 200),
    ["turquoise"] = Color3.fromRGB(64, 224, 208),
    ["midnight"] = Color3.fromRGB(25, 25, 112),
    ["denim"] = Color3.fromRGB(21, 96, 189),
    ["sapphire"] = Color3.fromRGB(15, 82, 186),
    ["indigo blue"] = Color3.fromRGB(8, 86, 198),
    
    -- PURPLES
    ["purple"] = Color3.fromRGB(128, 0, 128),
    ["violet"] = Color3.fromRGB(138, 43, 226),
    ["lavender"] = Color3.fromRGB(230, 230, 250),
    ["lilac"] = Color3.fromRGB(200, 162, 200),
    ["magenta"] = Color3.fromRGB(255, 0, 255),
    ["orchid"] = Color3.fromRGB(218, 112, 214),
    ["plum"] = Color3.fromRGB(221, 160, 221),
    ["indigo"] = Color3.fromRGB(75, 0, 130),
    ["amethyst"] = Color3.fromRGB(153, 102, 204),
    ["grape"] = Color3.fromRGB(111, 45, 168),
    ["eggplant"] = Color3.fromRGB(72, 23, 70),
    ["periwinkle"] = Color3.fromRGB(204, 204, 255),
    ["fuchsia"] = Color3.fromRGB(255, 119, 255),
    ["mauve"] = Color3.fromRGB(224, 176, 255),
    ["wisteria"] = Color3.fromRGB(201, 160, 220),
    
    -- PINKS
    ["pink"] = Color3.fromRGB(255, 192, 203),
    ["hot pink"] = Color3.fromRGB(255, 105, 180),
    ["neon pink"] = Color3.fromRGB(255, 20, 147),
    ["bubblegum"] = Color3.fromRGB(255, 121, 167),
    ["pastel pink"] = Color3.fromRGB(255, 209, 220),
    ["rose pink"] = Color3.fromRGB(255, 102, 204),
    ["carnation"] = Color3.fromRGB(255, 166, 201),
    ["salmon pink"] = Color3.fromRGB(255, 145, 164),
    ["blush"] = Color3.fromRGB(222, 93, 131),
    ["cotton candy"] = Color3.fromRGB(255, 188, 217),
    ["watermelon"] = Color3.fromRGB(252, 108, 133),
    ["flamingo"] = Color3.fromRGB(252, 142, 172),
    
    -- BROWNS
    ["brown"] = Color3.fromRGB(139, 69, 19),
    ["tan"] = Color3.fromRGB(210, 180, 140),
    ["beige"] = Color3.fromRGB(245, 245, 220),
    ["coffee"] = Color3.fromRGB(111, 78, 55),
    ["chocolate"] = Color3.fromRGB(123, 63, 0),
    ["chestnut"] = Color3.fromRGB(149, 69, 53),
    ["cocoa"] = Color3.fromRGB(105, 60, 35),
    ["saddle"] = Color3.fromRGB(139, 69, 19),
    ["wheat"] = Color3.fromRGB(245, 222, 179),
    ["khaki"] = Color3.fromRGB(195, 176, 145),
    ["mahogany"] = Color3.fromRGB(192, 64, 0),
    ["bronze"] = Color3.fromRGB(205, 127, 50),
    
    -- NEONS
    ["neon"] = Color3.fromRGB(0, 255, 200),
    ["neon red"] = Color3.fromRGB(255, 0, 80),
    ["neon green"] = Color3.fromRGB(57, 255, 20),
    ["neon blue"] = Color3.fromRGB(0, 100, 255),
    ["neon yellow"] = Color3.fromRGB(255, 255, 0),
    ["neon orange"] = Color3.fromRGB(255, 128, 0),
    ["neon purple"] = Color3.fromRGB(180, 0, 255),
    ["neon pink"] = Color3.fromRGB(255, 0, 150),
    
    -- PASTELS
    ["pastel red"] = Color3.fromRGB(255, 179, 179),
    ["pastel orange"] = Color3.fromRGB(255, 204, 153),
    ["pastel yellow"] = Color3.fromRGB(255, 242, 179),
    ["pastel green"] = Color3.fromRGB(179, 255, 179),
    ["pastel blue"] = Color3.fromRGB(179, 204, 255),
    ["pastel purple"] = Color3.fromRGB(204, 179, 255),
    ["pastel pink"] = Color3.fromRGB(255, 179, 204),
    
    -- GRAYS
    ["white"] = Color3.fromRGB(255, 255, 255),
    ["light gray"] = Color3.fromRGB(211, 211, 211),
    ["gray"] = Color3.fromRGB(128, 128, 128),
    ["dark gray"] = Color3.fromRGB(64, 64, 64),
    ["charcoal"] = Color3.fromRGB(54, 54, 54),
    ["silver"] = Color3.fromRGB(192, 192, 192),
    ["black"] = Color3.fromRGB(15, 15, 25),
    ["dark"] = Color3.fromRGB(18, 18, 28),
    ["midnight dark"] = Color3.fromRGB(10, 10, 20),
    ["slate"] = Color3.fromRGB(112, 128, 144),
    ["ash"] = Color3.fromRGB(178, 190, 181),
}

-- Parse color
local function ParseColor(input)
    if type(input) == "table" and input.R then return input end
    input = string.lower(tostring(input))
    if input:match("^#?%x%x%x%x%x%x$") then
        local hex = input:gsub("#", "")
        return Color3.fromRGB(tonumber(hex:sub(1,2), 16) or 0, tonumber(hex:sub(3,4), 16) or 0, tonumber(hex:sub(5,6), 16) or 0)
    end
    return Colors[input] or Color3.fromRGB(100, 100, 255)
end

-- ============================================================================
-- COMPLETE FLEXIBLE UI SYSTEM
-- ============================================================================

-- Get optimal sizing based on device
local function GetSizing()
    local screen = workspace.CurrentCamera.ViewportSize
    local isMobile = UIS.TouchEnabled
    return {
        WindowWidth = isMobile and math.min(380, screen.X - 30) or math.min(480, screen.X * 0.38),
        WindowHeight = isMobile and math.min(620, screen.Y - 100) or math.min(680, screen.Y - 120),
        SidebarWidth = isMobile and 130 or 150,
        ButtonHeight = isMobile and 44 or 42,
        FontSize = isMobile and 14 or 13,
        TitleHeight = 50,
        Padding = 12
    }
end

-- Utils
local function Round(frame, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r or 8) c.Parent = frame end
local function Stroke(frame, t, c) local s = Instance.new("UIStroke") s.Thickness = t or 1 s.Color = c or Color3.fromRGB(80, 80, 120) s.Parent = frame end
local function Tween(obj, props, time) return TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end

-- Notification system
local NotifyContainer = nil
local function Notify(title, msg, type, dur, actionText, actionCallback)
    if not NotifyContainer then
        NotifyContainer = Instance.new("Frame")
        NotifyContainer.Name = "FubnikNotifs"
        NotifyContainer.Size = UDim2.new(0, 340, 1, -20)
        NotifyContainer.Position = UDim2.new(1, -360, 0, 10)
        NotifyContainer.BackgroundTransparency = 1
        NotifyContainer.Parent = CG
    end
    
    type = type or "info"
    dur = dur or 3
    local typeColors = {info = Color3.fromRGB(80, 180, 255), success = Color3.fromRGB(80, 255, 120), warning = Color3.fromRGB(255, 200, 80), error = Color3.fromRGB(255, 80, 100)}
    local icons = {info = "ℹ️", success = "✅", warning = "⚠️", error = "❌"}
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.ClipsDescendants = true
    Round(frame, 12)
    Stroke(frame, 1, typeColors[type])
    frame.Parent = NotifyContainer
    
    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0, 30, 0, 30)
    iconL.Position = UDim2.new(0, 12, 0, 12)
    iconL.Text = icons[type]
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
    msgL.TextWrapped = true
    msgL.BackgroundTransparency = 1
    msgL.AutomaticSize = Enum.AutomaticSize.Y
    msgL.Parent = frame
    
    if actionText and actionCallback then
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 80, 0, 28)
        btn.Position = UDim2.new(1, -90, 1, -38)
        btn.Text = actionText
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamSemibold
        btn.BackgroundColor3 = typeColors[type]
        Round(btn, 6)
        btn.Parent = frame
        btn.MouseButton1Click:Connect(function() actionCallback() frame:Destroy() end)
    end
    
    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(1, 0, 0, 3)
    progress.Position = UDim2.new(0, 0, 1, -3)
    progress.BackgroundColor3 = typeColors[type]
    progress.BackgroundTransparency = 0.3
    progress.Parent = frame
    
    local finalH = msgL.AbsoluteSize.Y + 55 + (actionText and 40 or 0)
    frame.Size = UDim2.new(1, -10, 0, finalH)
    frame.Position = UDim2.new(0, 5, 1, 0)
    Tween(frame, {Position = UDim2.new(0, 5, 1, -finalH - 10)}, 0.3)
    TS:Create(progress, TweenInfo.new(dur, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)}):Play()
    
    task.spawn(function() task.wait(dur) if frame and frame.Parent then Tween(frame, {Position = UDim2.new(0, 5, 1, 0), BackgroundTransparency = 1}, 0.2) task.wait(0.2) frame:Destroy() end end)
    return frame
end

-- ============================================================================
-- MAIN WINDOW CREATOR - COMPLETE CUSTOMIZATION
-- ============================================================================
local function CreateWindow(options)
    options = options or {}
    local sizing = GetSizing()
    
    local width = options.Width or sizing.WindowWidth
    local height = options.Height or sizing.WindowHeight
    local title = options.Title or "Fubnik UI"
    local accentColor = ParseColor(options.AccentColor or "neon blue")
    local bgColor = ParseColor(options.BackgroundColor or "dark")
    local sidebarColor = ParseColor(options.SidebarColor or "midnight dark")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "Fubnik_" .. tostring(os.time())
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CG
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = options.Position or UDim2.new(0.5, -width/2, 0.5, -height/2)
    main.BackgroundColor3 = bgColor
    main.BackgroundTransparency = 0.05
    Round(main, options.CornerRadius or 14)
    Stroke(main, 1.5, accentColor)
    main.Parent = screenGui
    
    -- Title bar (customizable)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, options.TitleHeight or sizing.TitleHeight)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = main
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = title
    titleText.TextColor3 = ParseColor(options.TitleColor or "white")
    titleText.TextSize = options.TitleFontSize or (sizing.FontSize + 2)
    titleText.Font = Enum.Font[options.TitleFont or "GothamBold"]
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.Text = options.CloseText or "✕"
    closeBtn.TextColor3 = ParseColor(options.CloseColor or "red")
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
    
    -- Sidebar (customizable)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, options.SidebarWidth or sizing.SidebarWidth, 1, -(options.TitleHeight or sizing.TitleHeight))
    sidebar.Position = UDim2.new(0, 0, 0, options.TitleHeight or sizing.TitleHeight)
    sidebar.BackgroundColor3 = sidebarColor
    sidebar.BackgroundTransparency = 0.3
    sidebar.Parent = main
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.Parent = tabList
    
    -- Content area
    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -((options.SidebarWidth or sizing.SidebarWidth) + 15), 1, -((options.TitleHeight or sizing.TitleHeight) + 10))
    contentArea.Position = UDim2.new(0, (options.SidebarWidth or sizing.SidebarWidth) + 10, 0, (options.TitleHeight or sizing.TitleHeight) + 5)
    contentArea.BackgroundColor3 = bgColor
    contentArea.BackgroundTransparency = 0.2
    Round(contentArea, 10)
    contentArea.Parent = main
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -20, 1, -20)
    tabContainer.Position = UDim2.new(0, 10, 0, 10)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = contentArea
    
    -- Dragging (optional)
    if options.Draggable ~= false then
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
    end
    
    local window = {
        ScreenGui = screenGui,
        MainFrame = main,
        Sidebar = sidebar,
        TabList = tabList,
        TabContainer = tabContainer,
        Tabs = {},
        CurrentTab = nil,
        Options = options,
        Sizing = sizing
    }
    
    -- Add Tab method
    function window:AddTab(tabOptions)
        local tabName = tabOptions.Name or "Tab"
        local tabIcon = tabOptions.Icon or ""
        local tabColor = ParseColor(tabOptions.Color or "white")
        
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, tabOptions.ButtonHeight or self.Sizing.ButtonHeight)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.Text = tabIcon ~= "" and (tabIcon .. "  " .. tabName) or tabName
        btn.TextColor3 = tabColor
        btn.TextSize = tabOptions.FontSize or (self.Sizing.FontSize - 1)
        btn.Font = Enum.Font[tabOptions.Font or "Gotham"]
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundTransparency = 1
        Round(btn, 6)
        btn.Parent = self.TabList
        
        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.ScrollBarThickness = 3
        content.Visible = false
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.Parent = self.TabContainer
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, tabOptions.SectionSpacing or 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = content
        
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
        end)
        
        local function select()
            for _, child in pairs(self.TabContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then child.Visible = false end
            end
            for _, child in pairs(self.TabList:GetChildren()) do
                if child:IsA("TextButton") then
                    Tween(child, {BackgroundColor3 = Color3.fromRGB(0, 0, 0), TextColor3 = Color3.fromRGB(180, 180, 210)}, 0.1)
                    child.BackgroundTransparency = 1
                end
            end
            content.Visible = true
            Tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 40, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
            btn.BackgroundTransparency = 0.1
        end
        
        btn.MouseButton1Click:Connect(select)
        
        local tab = {
            Button = btn,
            Content = content,
            Layout = layout,
            Sections = {}
        }
        
        -- Add Section method
        function tab:AddSection(sectionOptions)
            local sectionName = sectionOptions.Name or "Section"
            local sectionColor = ParseColor(sectionOptions.Color or "neon blue")
            local collapsible = sectionOptions.Collapsible ~= false
            
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = content
            
            local header = Instance.new("TextButton" if collapsible else "TextLabel")
            header.Size = UDim2.new(1, 0, 0, sectionOptions.HeaderHeight or 32)
            header.Text = sectionName
            header.TextColor3 = sectionColor
            header.TextSize = sectionOptions.FontSize or self.Sizing.FontSize
            header.Font = Enum.Font[sectionOptions.Font or "GothamBold"]
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.BackgroundTransparency = 1
            header.Parent = sectionFrame
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 30)
            line.BackgroundColor3 = sectionColor
            line.BackgroundTransparency = 0.5
            line.Parent = sectionFrame
            
            local elementsFrame = Instance.new("Frame")
            elementsFrame.Size = UDim2.new(1, 0, 0, 0)
            elementsFrame.Position = UDim2.new(0, 0, 0, 38)
            elementsFrame.BackgroundTransparency = 1
            elementsFrame.AutomaticSize = Enum.AutomaticSize.Y
            elementsFrame.Parent = sectionFrame
            
            local elementsLayout = Instance.new("UIListLayout")
            elementsLayout.Padding = UDim.new(0, sectionOptions.ElementSpacing or 8)
            elementsLayout.Parent = elementsFrame
            
            local section = { Frame = sectionFrame, Elements = elementsFrame, Items = {} }
            
            -- Collapsible functionality
            if collapsible then
                local collapsed = false
                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 25, 1, 0)
                icon.Position = UDim2.new(0, 5, 0, 0)
                icon.Text = "▾"
                icon.TextColor3 = sectionColor
                icon.TextSize = 14
                icon.BackgroundTransparency = 1
                icon.Parent = header
                header.Text = "   " .. sectionName
                
                header.MouseButton1Click:Connect(function()
                    collapsed = not collapsed
                    if collapsed then
                        Tween(elementsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                        icon.Text = "▸"
                    else
                        Tween(elementsFrame, {Size = UDim2.new(1, 0, 0, elementsLayout.AbsoluteContentSize.Y)}, 0.2)
                        icon.Text = "▾"
                    end
                end)
            end
            
            -- Add Button
            function section:AddButton(btnOptions)
                local text = btnOptions.Name or "Button"
                local callback = btnOptions.Callback or function() end
                local btnColor = ParseColor(btnOptions.Color or "surface")
                local hoverColor = ParseColor(btnOptions.HoverColor or "surface hover")
                local textColor = ParseColor(btnOptions.TextColor or "white")
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, btnOptions.Height or self.Sizing.ButtonHeight)
                btn.Text = text
                btn.TextColor3 = textColor
                btn.TextSize = btnOptions.FontSize or (self.Sizing.FontSize - 1)
                btn.Font = Enum.Font[btnOptions.Font or "GothamSemibold"]
                btn.BackgroundColor3 = btnColor
                Round(btn, btnOptions.CornerRadius or 8)
                Stroke(btn, 1, ParseColor(btnOptions.StrokeColor or "gray"))
                btn.Parent = elementsFrame
                
                btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = hoverColor}, 0.1) end)
                btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = btnColor}, 0.1) end)
                btn.MouseButton1Click:Connect(callback)
                
                table.insert(section.Items, btn)
                return btn
            end
            
            -- Add Toggle
            function section:AddToggle(toggleOptions)
                local text = toggleOptions.Name or "Toggle"
                local default = toggleOptions.Default or false
                local callback = toggleOptions.Callback or function() end
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, toggleOptions.Height or self.Sizing.ButtonHeight)
                frame.BackgroundColor3 = ParseColor(toggleOptions.Color or "surface")
                Round(frame, toggleOptions.CornerRadius or 8)
                Stroke(frame, 1, ParseColor(toggleOptions.StrokeColor or "gray"))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = ParseColor(toggleOptions.TextColor or "white")
                label.TextSize = toggleOptions.FontSize or (self.Sizing.FontSize - 1)
                label.Font = Enum.Font[toggleOptions.Font or "Gotham"]
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 26)
                toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
                toggleBtn.Text = ""
                toggleBtn.BackgroundColor3 = default and ParseColor(toggleOptions.ActiveColor or "neon blue") or ParseColor(toggleOptions.InactiveColor or "gray")
                Round(toggleBtn, 13)
                toggleBtn.Parent = frame
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 22, 0, 22)
                knob.Position = UDim2.new(0, default and 26 or 2, 0.5, -11)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Round(knob, 11)
                knob.Parent = toggleBtn
                
                local state = default
                local function toggle()
                    state = not state
                    Tween(toggleBtn, {BackgroundColor3 = state and ParseColor(toggleOptions.ActiveColor or "neon blue") or ParseColor(toggleOptions.InactiveColor or "gray")}, 0.2)
                    Tween(knob, {Position = UDim2.new(0, state and 26 or 2, 0.5, -11)}, 0.2)
                    callback(state)
                end
                toggleBtn.MouseButton1Click:Connect(toggle)
                
                table.insert(section.Items, frame)
                return { setValue = function(v) state = v toggleBtn.BackgroundColor3 = state and ParseColor(toggleOptions.ActiveColor or "neon blue") or ParseColor(toggleOptions.InactiveColor or "gray") knob.Position = UDim2.new(0, state and 26 or 2, 0.5, -11) callback(state) end, getValue = function() return state end }
            end
            
            -- Add Slider
            function section:AddSlider(sliderOptions)
                local text = sliderOptions.Name or "Slider"
                local min = sliderOptions.Min or 0
                local max = sliderOptions.Max or 100
                local default = sliderOptions.Default or min
                local callback = sliderOptions.Callback or function() end
                
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, sliderOptions.Height or 80)
                frame.BackgroundColor3 = ParseColor(sliderOptions.Color or "surface")
                Round(frame, sliderOptions.CornerRadius or 8)
                Stroke(frame, 1, ParseColor(sliderOptions.StrokeColor or "gray"))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -80, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 5)
                label.Text = text
                label.TextColor3 = ParseColor(sliderOptions.TextColor or "white")
                label.TextSize = sliderOptions.FontSize or (self.Sizing.FontSize - 1)
                label.Font = Enum.Font[sliderOptions.Font or "GothamSemibold"]
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 60, 0, 25)
                valueLabel.Position = UDim2.new(1, -72, 0, 5)
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = ParseColor(sliderOptions.ValueColor or "neon blue")
                valueLabel.TextSize = sliderOptions.FontSize or (self.Sizing.FontSize - 2)
                valueLabel.Font = Enum.Font[sliderOptions.Font or "GothamBold"]
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.BackgroundTransparency = 1
                valueLabel.Parent = frame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -24, 0, 4)
                sliderBg.Position = UDim2.new(0, 12, 0, 52)
                sliderBg.BackgroundColor3 = ParseColor(sliderOptions.BgColor or "dark gray")
                Round(sliderBg, 2)
                sliderBg.Parent = frame
                
                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = ParseColor(sliderOptions.FillColor or "neon blue")
                Round(fill, 2)
                fill.Parent = sliderBg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = UDim2.new(percent, -9, 0.5, -9)
                knob.BackgroundColor3 = ParseColor(sliderOptions.KnobColor or "neon blue")
                Round(knob, 9)
                knob.Parent = sliderBg
                
                local dragging = false
                local value = default
                local function update(input)
                    local rel = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (rel * (max - min))
                    value = sliderOptions.Precision and math.floor(newVal * (10 ^ sliderOptions.Precision) + 0.5) / (10 ^ sliderOptions.Precision) or math.floor(newVal + 0.5)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, -9, 0.5, -9)
                    callback(value)
                end
                knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
                UIS.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end end)
                UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                sliderBg.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then update(input) dragging = true end end)
                
                table.insert(section.Items, frame)
                return { setValue = function(v) value = math.clamp(v, min, max) local p = (value - min) / (max - min) valueLabel.Text = tostring(value) fill.Size = UDim2.new(p, 0, 1, 0) knob.Position = UDim2.new(p, -9, 0.5, -9) callback(value) end, getValue = function() return value end }
            end
            
            -- Add Label
            function section:AddLabel(labelOptions)
                local text = labelOptions.Name or "Label"
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, labelOptions.Height or 28)
                label.Position = UDim2.new(0, labelOptions.Padding or 12, 0, 0)
                label.Text = text
                label.TextColor3 = ParseColor(labelOptions.Color or "light gray")
                label.TextSize = labelOptions.FontSize or (self.Sizing.FontSize - 2)
                label.Font = Enum.Font[labelOptions.Font or "Gotham"]
                label.TextXAlignment = Enum.TextXAlignment[labelOptions.Alignment or "Left"]
                label.BackgroundTransparency = 1
                label.Parent = elementsFrame
                table.insert(section.Items, label)
                return label
            end
            
            -- Add Gamepass Button
            function section:AddGamepassButton(gpOptions)
                local gamepassId = gpOptions.GamepassId
                local name = gpOptions.Name or "Purchase Gamepass"
                local price = gpOptions.Price or "???"
                local onPurchase = gpOptions.OnPurchase or function() end
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, gpOptions.Height or (self.Sizing.ButtonHeight + 10))
                btn.BackgroundColor3 = ParseColor(gpOptions.Color or "dark green")
                Round(btn, gpOptions.CornerRadius or 8)
                Stroke(btn, 1, ParseColor(gpOptions.StrokeColor or "green"))
                btn.Parent = elementsFrame
                
                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 35, 1, 0)
                icon.Position = UDim2.new(0, 12, 0, 0)
                icon.Text = gpOptions.Icon or "💰"
                icon.TextSize = 20
                icon.BackgroundTransparency = 1
                icon.Parent = btn
                
                local titleL = Instance.new("TextLabel")
                titleL.Size = UDim2.new(1, -100, 0, 22)
                titleL.Position = UDim2.new(0, 55, 0, 8)
                titleL.Text = name
                titleL.TextColor3 = ParseColor(gpOptions.TitleColor or "white")
                titleL.TextSize = gpOptions.FontSize or self.Sizing.FontSize
                titleL.Font = Enum.Font[gpOptions.Font or "GothamSemibold"]
                titleL.TextXAlignment = Enum.TextXAlignment.Left
                titleL.BackgroundTransparency = 1
                titleL.Parent = btn
                
                local priceL = Instance.new("TextLabel")
                priceL.Size = UDim2.new(1, -100, 0, 18)
                priceL.Position = UDim2.new(0, 55, 0, 30)
                priceL.Text = price .. " Robux"
                priceL.TextColor3 = ParseColor(gpOptions.PriceColor or "light green")
                priceL.TextSize = gpOptions.PriceFontSize or (self.Sizing.FontSize - 2)
                priceL.Font = Enum.Font[gpOptions.Font or "Gotham"]
                priceL.TextXAlignment = Enum.TextXAlignment.Left
                priceL.BackgroundTransparency = 1
                priceL.Parent = btn
                
                btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = ParseColor(gpOptions.HoverColor or "green")}, 0.15) end)
                btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = ParseColor(gpOptions.Color or "dark green")}, 0.15) end)
                btn.MouseButton1Click:Connect(function()
                    MPS:PromptGamePassPurchase(LP, gamepassId)
                    Notify("Gamepass", "Purchase prompt sent for " .. name, "info", 2)
                    onPurchase()
                end)
                
                table.insert(section.Items, btn)
                return btn
            end
            
            table.insert(tab.Sections, section)
            return section
        end
        
        table.insert(window.Tabs, tab)
        if #window.Tabs == 1 then select() end
        return tab
    end
    
    -- Utility methods
    function window:Notify(title, msg, type, dur, actionText, actionCallback)
        return Notify(title, msg, type, dur, actionText, actionCallback)
    end
    
    function window:Destroy()
        self.ScreenGui:Destroy()
    end
    
    function window:SetSize(width, height)
        self.MainFrame.Size = UDim2.new(0, width, 0, height)
        self.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    end
    
    function window:SetPosition(x, y)
        self.MainFrame.Position = UDim2.new(0, x, 0, y)
    end
    
    function window:SetColor(part, color)
        if part == "accent" then Stroke(self.MainFrame, 1.5, ParseColor(color))
        elseif part == "background" then self.MainFrame.BackgroundColor3 = ParseColor(color)
        elseif part == "sidebar" then self.Sidebar.BackgroundColor3 = ParseColor(color)
        end
    end
    
    return window
end

