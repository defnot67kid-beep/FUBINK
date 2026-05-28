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
    ║         FUBNIK v6.0 - SCRIPT LOADER                       ║
    ║    A framework for creating script hubs                   ║
    ║                                                           ║
    ╚═══════════════════════════════════════════════════════════╝
--]]

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
    TitleHeight = 45,
    TabHeight = 0
}

-- Auto detect device and calculate perfect sizes
function Device:Detect()
    local camera = workspace.CurrentCamera
    self.ScreenWidth = camera.ViewportSize.X
    self.ScreenHeight = camera.ViewportSize.Y
    local isMobile = game:GetService("UserInputService").TouchEnabled
    local aspectRatio = self.ScreenWidth / self.ScreenHeight
    
    -- Detect device type
    if isMobile then
        self.Type = "Mobile"
        self.RecommendedWidth = math.min(360, self.ScreenWidth - 20)
        self.RecommendedHeight = math.min(600, self.ScreenHeight - 80)
        self.ButtonHeight = 44
        self.FontSize = 14
        self.SidebarWidth = 120
        self.Padding = 12
        self.Scale = 0.9
        self.TabHeight = 40
    elseif aspectRatio > 1.6 then
        self.Type = "Desktop Wide"
        self.RecommendedWidth = math.min(450, self.ScreenWidth * 0.35)
        self.RecommendedHeight = math.min(650, self.ScreenHeight - 100)
        self.ButtonHeight = 45
        self.FontSize = 14
        self.SidebarWidth = 140
        self.Padding = 15
        self.Scale = 1
        self.TabHeight = 42
    elseif aspectRatio > 1.3 then
        self.Type = "Desktop"
        self.RecommendedWidth = math.min(420, self.ScreenWidth * 0.4)
        self.RecommendedHeight = math.min(620, self.ScreenHeight - 100)
        self.ButtonHeight = 42
        self.FontSize = 13
        self.SidebarWidth = 135
        self.Padding = 12
        self.Scale = 1
        self.TabHeight = 40
    else
        self.Type = "Tablet"
        self.RecommendedWidth = math.min(500, self.ScreenWidth - 40)
        self.RecommendedHeight = math.min(700, self.ScreenHeight - 80)
        self.ButtonHeight = 48
        self.FontSize = 15
        self.SidebarWidth = 150
        self.Padding = 15
        self.Scale = 1.1
        self.TabHeight = 44
    end
    
    return self
end

-- Get recommended window size (auto-scales)
function Device:GetWindowSize()
    return self.RecommendedWidth, self.RecommendedHeight
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

-- ============================================================================
-- COLOR THEME SYSTEM
-- ============================================================================
local Theme = {
    -- Default colors
    Primary = Color3.fromRGB(100, 100, 255),
    PrimaryDark = Color3.fromRGB(70, 70, 200),
    Secondary = Color3.fromRGB(80, 80, 120),
    Background = Color3.fromRGB(18, 18, 28),
    BackgroundAlt = Color3.fromRGB(25, 25, 40),
    Surface = Color3.fromRGB(35, 35, 55),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 210),
    TextDark = Color3.fromRGB(150, 150, 180),
    Success = Color3.fromRGB(80, 255, 120),
    Warning = Color3.fromRGB(255, 200, 80),
    Error = Color3.fromRGB(255, 80, 100),
    
    -- Custom colors (can be changed by user)
    CustomTitleColor = nil,
    CustomWindowColor = nil,
    CustomTabColor = nil,
    CustomButtonColor = nil,
    CustomAccentColor = nil,
    
    -- Getter functions with fallback
    GetTitleColor = function(self)
        return self.CustomTitleColor or self.Primary
    end,
    GetWindowColor = function(self)
        return self.CustomWindowColor or self.Background
    end,
    GetTabColor = function(self)
        return self.CustomTabColor or self.Primary
    end,
    GetButtonColor = function(self)
        return self.CustomButtonColor or self.Primary
    end,
    GetAccentColor = function(self)
        return self.CustomAccentColor or self.Primary
    end,
    
    -- Set custom colors
    SetTitleColor = function(self, color)
        self.CustomTitleColor = color
    end,
    SetWindowColor = function(self, color)
        self.CustomWindowColor = color
    end,
    SetTabColor = function(self, color)
        self.CustomTabColor = color
    end,
    SetButtonColor = function(self, color)
        self.CustomButtonColor = color
    end,
    SetAccentColor = function(self, color)
        self.CustomAccentColor = color
    end,
    
    -- Reset to defaults
    Reset = function(self)
        self.CustomTitleColor = nil
        self.CustomWindowColor = nil
        self.CustomTabColor = nil
        self.CustomButtonColor = nil
        self.CustomAccentColor = nil
    end
}

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================
local function MakeRounded(frame, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = frame
end

local function MakeStroke(frame, t, c)
    local s = Instance.new("UIStroke")
    s.Thickness = t or 1
    s.Color = c or Theme:GetAccentColor()
    s.Parent = frame
end

local function Tween(obj, props, time)
    local t = TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

-- ============================================================================
-- HOVER INFO SYSTEM
-- ============================================================================
local HoverInfo = nil

local function CreateHoverInfo()
    if HoverInfo then return end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "HoverInfo"
    gui.ResetOnSpawn = false
    gui.Parent = CG
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    frame.BackgroundTransparency = 0.05
    frame.Visible = false
    frame.ZIndex = 999
    MakeRounded(frame, 8)
    MakeStroke(frame, 1, Theme.Primary)
    frame.Parent = gui
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -16, 0, 25)
    titleLabel.Position = UDim2.new(0, 8, 0, 8)
    titleLabel.Text = ""
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -16, 0, 0)
    descLabel.Position = UDim2.new(0, 8, 0, 33)
    descLabel.Text = ""
    descLabel.TextColor3 = Theme.TextDim
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.BackgroundTransparency = 1
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.Parent = frame
    
    HoverInfo = {
        gui = gui,
        frame = frame,
        title = titleLabel,
        desc = descLabel,
        active = false
    }
    
    local function updateSize()
        local h = descLabel.AbsoluteSize.Y + 50
        frame.Size = UDim2.new(0, 200, 0, h)
    end
    
    descLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateSize)
    updateSize()
end

local function ShowHoverInfo(title, description, position)
    if not HoverInfo then CreateHoverInfo() end
    
    HoverInfo.title.Text = title or ""
    HoverInfo.desc.Text = description or ""
    HoverInfo.frame.Position = UDim2.new(0, position.X + 10, 0, position.Y + 10)
    HoverInfo.frame.Visible = true
    HoverInfo.active = true
end

local function HideHoverInfo()
    if HoverInfo then
        HoverInfo.frame.Visible = false
        HoverInfo.active = false
    end
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
        info = Theme.Primary,
        success = Theme.Success,
        warn = Theme.Warning,
        error = Theme.Error
    }
    
    local icons = {info = "ℹ️", success = "✅", warn = "⚠️", error = "❌"}
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Theme.BackgroundAlt
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
    titleL.TextColor3 = Theme.Text
    titleL.TextSize = 14
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.BackgroundTransparency = 1
    titleL.Parent = frame
    
    local msgL = Instance.new("TextLabel")
    msgL.Size = UDim2.new(1, -55, 0, 0)
    msgL.Position = UDim2.new(0, 48, 0, 33)
    msgL.Text = msg
    msgL.TextColor3 = Theme.TextDim
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
    overlay.BackgroundTransparency = 0.5
    overlay.Parent = screenGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 120)
    frame.Position = UDim2.new(0.5, -125, 0.5, -60)
    frame.BackgroundColor3 = Theme.BackgroundAlt
    MakeRounded(frame, 12)
    MakeStroke(frame, 1, Theme:GetAccentColor())
    frame.Parent = overlay
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 0, 40)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.Text = message or "Loading..."
    text.TextColor3 = Theme.Text
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.BackgroundTransparency = 1
    text.Parent = frame
    
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0, 30, 0, 30)
    spinner.Position = UDim2.new(0.5, -15, 0, 60)
    spinner.BackgroundColor3 = Theme:GetAccentColor()
    MakeRounded(spinner, 15)
    spinner.Parent = frame
    
    local spin = 0
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        spin = spin + 10
        spinner.Rotation = spin
    end)
    
    if duration then
        task.spawn(function()
            task.wait(duration)
            conn:Disconnect()
            screenGui:Destroy()
        end)
    end
    
    return {
        Hide = function()
            conn:Disconnect()
            screenGui:Destroy()
        end
    }
end

-- ============================================================================
-- MAIN HUB FRAMEWORK (LOADER)
-- ============================================================================
local Hub = {
    windows = {},
    currentWindow = nil,
    Device = Device,
    Theme = Theme
}

function Hub:CreateWindow(name, customWidth, customHeight)
    -- Use auto-detected sizes if no custom sizes provided
    local width = customWidth or Device.RecommendedWidth
    local height = customHeight or Device.RecommendedHeight
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ScriptHub_" .. tostring(os.time())
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CG
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    main.BackgroundColor3 = Theme:GetWindowColor()
    MakeRounded(main, 12)
    MakeStroke(main, 1.5, Theme:GetAccentColor())
    main.Parent = screenGui
    
    -- Title bar (color can be customized)
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, Device.TitleHeight)
    titleBar.BackgroundColor3 = Theme:GetTitleColor()
    titleBar.BackgroundTransparency = 0.85
    MakeRounded(titleBar, 12)
    titleBar.Parent = main
    
    -- Fix corner rounding (only top corners)
    local topLeft = Instance.new("UICorner")
    topLeft.CornerRadius = UDim.new(0, 12)
    topLeft.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = name
    titleText.TextColor3 = Theme.Text
    titleText.TextSize = Device.FontSize + 2
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    -- Subheading
    local subText = Instance.new("TextLabel")
    subText.Size = UDim2.new(1, -50, 0, 20)
    subText.Position = UDim2.new(0, 15, 0, 22)
    subText.Text = "Script Hub"
    subText.TextColor3 = Theme.TextDark
    subText.TextSize = Device.FontSize - 3
    subText.Font = Enum.Font.Gotham
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.BackgroundTransparency = 1
    subText.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.Error
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = titleBar
    
    -- Tabs container (sidebar)
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0, Device.SidebarWidth, 1, -Device.TitleHeight)
    tabsFrame.Position = UDim2.new(0, 0, 0, Device.TitleHeight)
    tabsFrame.BackgroundColor3 = Theme.BackgroundAlt
    tabsFrame.BackgroundTransparency = 0.3
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
    contentFrame.Size = UDim2.new(1, -(Device.SidebarWidth + 15), 1, -Device.TitleHeight - 10)
    contentFrame.Position = UDim2.new(0, Device.SidebarWidth + 10, 0, Device.TitleHeight + 5)
    contentFrame.BackgroundColor3 = Theme.Background
    contentFrame.BackgroundTransparency = 0.2
    MakeRounded(contentFrame, 8)
    contentFrame.Parent = main
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    local function startDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end
    
    local function dragUpdate(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    local function endDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end
    
    titleBar.InputBegan:Connect(startDrag)
    UIS.InputChanged:Connect(dragUpdate)
    UIS.InputEnded:Connect(endDrag)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    closeBtn.TouchTap:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Hover info for close button
    closeBtn.MouseEnter:Connect(function()
        ShowHoverInfo("Close", "Close the script hub", UIS:GetMouseLocation())
    end)
    closeBtn.MouseLeave:Connect(HideHoverInfo)
    
    local window = {
        screenGui = screenGui,
        main = main,
        contentFrame = contentFrame,
        tabList = tabList,
        tabLayout = tabLayout,
        tabs = {},
        currentTab = nil,
        device = Device,
        theme = Theme,
        name = name
    }
    
    -- Color customization methods
    function window:SetTitleColor(color)
        titleBar.BackgroundColor3 = color
        Theme:SetTitleColor(color)
    end
    
    function window:SetWindowColor(color)
        main.BackgroundColor3 = color
        Theme:SetWindowColor(color)
    end
    
    function window:SetAccentColor(color)
        MakeStroke(main, 1.5, color)
        Theme:SetAccentColor(color)
    end
    
    function window:SetButtonColor(color)
        Theme:SetButtonColor(color)
        -- Update existing buttons (optional)
    end
    
    function window:SetTabColor(color)
        Theme:SetTabColor(color)
    end
    
    function window:AddTab(name, icon, description)
        icon = icon or ""
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, Device.TabHeight)
        btn.Position = UDim2.new(0, 5, 0, 0)
        btn.Text = icon ~= "" and (icon .. "  " .. name) or name
        btn.TextColor3 = Theme.TextDim
        btn.TextSize = Device.FontSize - 1
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundTransparency = 1
        MakeRounded(btn, 6)
        btn.Parent = self.tabList
        
        -- Hover info for tab
        btn.MouseEnter:Connect(function()
            if description then
                ShowHoverInfo(name, description, UIS:GetMouseLocation())
            end
        end)
        btn.MouseLeave:Connect(HideHoverInfo)
        
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
        
        local function selectTab()
            for _, t in pairs(self.tabs) do
                t.content.Visible = false
                t.button.BackgroundTransparency = 1
                t.button.TextColor3 = Theme.TextDim
            end
            tabContent.Visible = true
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Theme.Text
            Tween(btn, {BackgroundColor3 = Theme:GetTabColor(), TextColor3 = Theme.Text}, 0.1)
            btn.BackgroundColor3 = Theme:GetTabColor()
        end
        
        btn.MouseButton1Click:Connect(selectTab)
        btn.TouchTap:Connect(selectTab)
        
        local tab = {
            button = btn,
            content = tabContent,
            layout = contentLayout,
            elements = {},
            name = name
        }
        
        function tab:AddSection(title, sectionDesc)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabContent
            
            local header = Instance.new("TextLabel")
            header.Size = UDim2.new(1, 0, 0, 30)
            header.Text = title
            header.TextColor3 = Theme:GetAccentColor()
            header.TextSize = Device.FontSize
            header.Font = Enum.Font.GothamBold
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.BackgroundTransparency = 1
            header.Parent = sectionFrame
            
            -- Hover info for section header
            if sectionDesc then
                header.MouseEnter:Connect(function()
                    ShowHoverInfo(title, sectionDesc, UIS:GetMouseLocation())
                end)
                header.MouseLeave:Connect(HideHoverInfo)
            end
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 28)
            line.BackgroundColor3 = Theme:GetAccentColor()
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
            
            function section:AddButton(text, description, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                btn.Text = text
                btn.TextColor3 = Theme.Text
                btn.TextSize = Device.FontSize - 1
                btn.Font = Enum.Font.GothamSemibold
                btn.BackgroundColor3 = Theme.Surface
                MakeRounded(btn, 8)
                MakeStroke(btn, 1, Theme.Secondary)
                btn.Parent = elementsFrame
                
                -- Hover info
                if description then
                    btn.MouseEnter:Connect(function()
                        ShowHoverInfo(text, description, UIS:GetMouseLocation())
                    end)
                    btn.MouseLeave:Connect(HideHoverInfo)
                end
                
                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = Color3.fromRGB(55, 55, 85)}, 0.1)
                end)
                
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = Theme.Surface}, 0.1)
                end)
                
                btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                
                btn.TouchTap:Connect(function()
                    if callback then callback() end
                end)
                
                table.insert(section.elements, btn)
                return btn
            end
            
            function section:AddToggle(text, description, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Theme.Surface
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Theme.Secondary)
                frame.Parent = elementsFrame
                
                -- Hover info
                if description then
                    frame.MouseEnter:Connect(function()
                        ShowHoverInfo(text, description, UIS:GetMouseLocation())
                    end)
                    frame.MouseLeave:Connect(HideHoverInfo)
                end
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Theme.Text
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 26)
                toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
                toggleBtn.Text = ""
                toggleBtn.BackgroundColor3 = default and Theme:GetButtonColor() or Theme.Secondary
                MakeRounded(toggleBtn, 13)
                toggleBtn.Parent = frame
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 22, 0, 22)
                knob.Position = UDim2.new(0, default and 26 or 2, 0.5, -11)
                knob.BackgroundColor3 = Theme.Text
                MakeRounded(knob, 11)
                knob.Parent = toggleBtn
                
                local state = default
                
                local function toggle()
                    state = not state
                    Tween(toggleBtn, {BackgroundColor3 = state and Theme:GetButtonColor() or Theme.Secondary}, 0.2)
                    Tween(knob, {Position = UDim2.new(0, state and 26 or 2, 0.5, -11)}, 0.2)
                    if callback then callback(state) end
                end
                
                toggleBtn.MouseButton1Click:Connect(toggle)
                toggleBtn.TouchTap:Connect(toggle)
                
                table.insert(section.elements, {frame = frame, toggle = toggleBtn, state = state})
                return {
                    setValue = function(v) 
                        state = v
                        toggleBtn.BackgroundColor3 = state and Theme:GetButtonColor() or Theme.Secondary
                        knob.Position = UDim2.new(0, state and 26 or 2, 0.5, -11)
                        if callback then callback(state) end
                    end,
                    getValue = function() return state end
                }
            end
            
            function section:AddSlider(text, description, min, max, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 75)
                frame.BackgroundColor3 = Theme.Surface
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Theme.Secondary)
                frame.Parent = elementsFrame
                
                -- Hover info
                if description then
                    frame.MouseEnter:Connect(function()
                        ShowHoverInfo(text, description, UIS:GetMouseLocation())
                    end)
                    frame.MouseLeave:Connect(HideHoverInfo)
                end
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -80, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 5)
                label.Text = text
                label.TextColor3 = Theme.Text
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.GothamSemibold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 60, 0, 25)
                valueLabel.Position = UDim2.new(1, -72, 0, 5)
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Theme:GetAccentColor()
                valueLabel.TextSize = Device.FontSize - 2
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.BackgroundTransparency = 1
                valueLabel.Parent = frame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -24, 0, 4)
                sliderBg.Position = UDim2.new(0, 12, 0, 48)
                sliderBg.BackgroundColor3 = Theme.Secondary
                MakeRounded(sliderBg, 2)
                sliderBg.Parent = frame
                
                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = Theme:GetButtonColor()
                MakeRounded(fill, 2)
                fill.Parent = sliderBg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = UDim2.new(percent, -9, 0.5, -9)
                knob.BackgroundColor3 = Theme:GetButtonColor()
                MakeRounded(knob, 9)
                knob.Parent = sliderBg
                
                local dragging = false
                local value = default
                
                local function update(pos)
                    local relative = math.clamp((pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (relative * (max - min))
                    value = math.floor(newVal + 0.5)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    knob.Position = UDim2.new(relative, -9, 0.5, -9)
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
                        dragging = true
                    end
                end)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(v) 
                        value = math.clamp(v, min, max)
                        local p = (value - min) / (max - min)
                        valueLabel.Text = tostring(value)
                        fill.Size = UDim2.new(p, 0, 1, 0)
                        knob.Position = UDim2.new(p, -9, 0.5, -9)
                        if callback then callback(value) end
                    end,
                    getValue = function() return value end
                }
            end
            
            function section:AddDropdown(text, description, options, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Theme.Surface
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Theme.Secondary)
                frame.Parent = elementsFrame
                
                -- Hover info
                if description then
                    frame.MouseEnter:Connect(function()
                        ShowHoverInfo(text, description, UIS:GetMouseLocation())
                    end)
                    frame.MouseLeave:Connect(HideHoverInfo)
                end
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -110, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Theme.Text
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Size = UDim2.new(0, 100, 0, 32)
                dropdownBtn.Position = UDim2.new(1, -110, 0.5, -16)
                dropdownBtn.Text = default or options[1]
                dropdownBtn.TextColor3 = Theme.Text
                dropdownBtn.TextSize = Device.FontSize - 2
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.BackgroundColor3 = Theme.BackgroundAlt
                MakeRounded(dropdownBtn, 6)
                dropdownBtn.Parent = frame
                
                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0, 25, 1, 0)
                arrow.Position = UDim2.new(1, -25, 0, 0)
                arrow.Text = "▼"
                arrow.TextColor3 = Theme.TextDim
                arrow.TextSize = 10
                arrow.BackgroundTransparency = 1
                arrow.Parent = dropdownBtn
                
                local listVisible = false
                local list = nil
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    if list then list:Destroy() end
                    listVisible = true
                    
                    list = Instance.new("ScrollingFrame")
                    list.Size = UDim2.new(0, 120, 0, 0)
                    list.Position = UDim2.new(1, -130, 0, 45)
                    list.BackgroundColor3 = Theme.BackgroundAlt
                    MakeRounded(list, 6)
                    MakeStroke(list, 1, Theme.Secondary)
                    list.ScrollBarThickness = 2
                    list.ClipsDescendants = true
                    list.Parent = frame
                    
                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Padding = UDim.new(0, 2)
                    listLayout.Parent = list
                    
                    local height = 0
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, -10, 0, 32)
                        optBtn.Position = UDim2.new(0, 5, 0, height)
                        optBtn.Text = opt
                        optBtn.TextColor3 = Theme.TextDim
                        optBtn.TextSize = Device.FontSize - 2
                        optBtn.Font = Enum.Font.Gotham
                        optBtn.BackgroundColor3 = Theme.Surface
                        MakeRounded(optBtn, 4)
                        optBtn.Parent = list
                        
                        optBtn.MouseButton1Click:Connect(function()
                            dropdownBtn.Text = opt
                            if callback then callback(opt) end
                            list:Destroy()
                            listVisible = false
                        end)
                        
                        height = height + 34
                    end
                    
                    list.CanvasSize = UDim2.new(0, 0, 0, height)
                    list.Size = UDim2.new(0, 120, 0, math.min(height, 150))
                end)
                
                -- Close dropdown when clicking elsewhere
                UIS.InputBegan:Connect(function(input)
                    if listVisible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = input.Position
                        local btnPos = dropdownBtn.AbsolutePosition
                        local listPos = list and list.AbsolutePosition
                        
                        if not (mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + 100 and
                               mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + 32) then
                            if list then list:Destroy() end
                            listVisible = false
                        end
                    end
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
            
            function section:AddLabel(text, description)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Theme.TextDim
                label.TextSize = Device.FontSize - 2
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = elementsFrame
                
                if description then
                    label.MouseEnter:Connect(function()
                        ShowHoverInfo("Info", description, UIS:GetMouseLocation())
                    end)
                    label.MouseLeave:Connect(HideHoverInfo)
                end
                
                table.insert(section.elements, label)
                return label
            end
            
            function section:AddTextbox(text, description, placeholder, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Theme.Surface
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Theme.Secondary)
                frame.Parent = elementsFrame
                
                if description then
                    frame.MouseEnter:Connect(function()
                        ShowHoverInfo(text, description, UIS:GetMouseLocation())
                    end)
                    frame.MouseLeave:Connect(HideHoverInfo)
                end
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0, 80, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Theme.Text
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local textBox = Instance.new("TextBox")
                textBox.Size = UDim2.new(1, -105, 0, 32)
                textBox.Position = UDim2.new(0, 95, 0.5, -16)
                textBox.PlaceholderText = placeholder or "Enter text..."
                textBox.Text = ""
                textBox.TextColor3 = Theme.Text
                textBox.PlaceholderColor3 = Theme.TextDark
                textBox.TextSize = Device.FontSize - 2
                textBox.Font = Enum.Font.Gotham
                textBox.BackgroundColor3 = Theme.BackgroundAlt
                MakeRounded(textBox, 6)
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
            
            table.insert(tab.elements, section)
            return section
        end
        
        function tab:Clear()
            for _, element in pairs(self.elements) do
                element.frame:Destroy()
            end
            self.elements = {}
        end
        
        table.insert(self.tabs, tab)
        
        -- Select first tab
        if #self.tabs == 1 then
            tabContent.Visible = true
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Theme.Text
            btn.BackgroundColor3 = Theme:GetTabColor()
        end
        
        return tab
    end
    
    function window:AddUserInfo()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 90)
        frame.Position = UDim2.new(0, 10, 0, 0)
        frame.BackgroundColor3 = Theme.Surface
        MakeRounded(frame, 10)
        MakeStroke(frame, 1, Theme.Secondary)
        frame.Parent = self.contentFrame
        
        -- Avatar circle
        local avatar = Instance.new("Frame")
        avatar.Size = UDim2.new(0, 55, 0, 55)
        avatar.Position = UDim2.new(0, 12, 0, 17)
        avatar.BackgroundColor3 = Theme.BackgroundAlt
        MakeRounded(avatar, 27)
        MakeStroke(avatar, 2, Theme:GetAccentColor())
        avatar.Parent = frame
        
        local avatarText = Instance.new("TextLabel")
        avatarText.Size = UDim2.new(1, 0, 1, 0)
        avatarText.Text = "👤"
        avatarText.TextSize = 28
        avatarText.TextColor3 = Theme.Text
        avatarText.BackgroundTransparency = 1
        avatarText.Parent = avatar
        
        -- Username
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -85, 0, 28)
        nameLabel.Position = UDim2.new(0, 80, 0, 12)
        nameLabel.Text = LP.Name
        nameLabel.TextColor3 = Theme.Text
        nameLabel.TextSize = Device.FontSize + 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = frame
        
        -- Display name
        local displayLabel = Instance.new("TextLabel")
        displayLabel.Size = UDim2.new(1, -85, 0, 20)
        displayLabel.Position = UDim2.new(0, 80, 0, 40)
        displayLabel.Text = "@" .. (LP.DisplayName or LP.Name)
        displayLabel.TextColor3 = Theme.TextDim
        displayLabel.TextSize = Device.FontSize - 2
        displayLabel.Font = Enum.Font.Gotham
        displayLabel.TextXAlignment = Enum.TextXAlignment.Left
        displayLabel.BackgroundTransparency = 1
        displayLabel.Parent = frame
        
        -- User ID
        local idLabel = Instance.new("TextLabel")
        idLabel.Size = UDim2.new(1, -85, 0, 18)
        idLabel.Position = UDim2.new(0, 80, 0, 60)
        idLabel.Text = "ID: " .. LP.UserId
        idLabel.TextColor3 = Theme.TextDark
        idLabel.TextSize = Device.FontSize - 3
        idLabel.Font = Enum.Font.Gotham
        idLabel.TextXAlignment = Enum.TextXAlignment.Left
        idLabel.BackgroundTransparency = 1
        idLabel.Parent = frame
        
        return frame
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
    
    function window:GetTheme()
        return Theme
    end
    
    function window:Destroy()
        screenGui:Destroy()
    end
    
    function window:SetTitle(newTitle)
        titleText.Text = newTitle
        self.name = newTitle
    end
    
    function window:SetSubtitle(newSubtitle)
        subText.Text = newSubtitle
    end
    
    table.insert(Hub.windows, window)
    Hub.currentWindow = window
    
    return window
end

function Hub:GetDevice()
    return Device
end

function Hub:GetTheme()
    return Theme
end

-- ============================================================================
-- RETURN THE LOADER (for other scripts to use)
-- ============================================================================
print("========================================")
print("FUBNIK v6.0 Loader Ready!")
print("Device: " .. Device.Type)
print("Screen: " .. Device.ScreenWidth .. "x" .. Device.ScreenHeight)
print("========================================")
print("")
print("HOW TO USE THIS LOADER:")
print("------------------------")
print("local Hub = loadstring(game:HttpGet('URL_HERE'))()")
print("")
print("local myWindow = Hub:CreateWindow('My Script Hub')")
print("local tab = myWindow:AddTab('Main', '🏠', 'Main features tab')")
print("local section = tab:AddSection('Settings', 'Configure your settings')")
print("section:AddButton('Click Me', 'This button does something', function() print('Clicked!') end)")
print("section:AddToggle('Enable Feature', 'Turn this on/off', false, function(state) print(state) end)")
print("section:AddSlider('Speed', 'Adjust speed', 0, 100, 50, function(v) print(v) end)")
print("section:AddDropdown('Option', 'Select an option', {'A', 'B', 'C'}, 'A', function(v) print(v) end)")
print("section:AddLabel('Status: Ready', 'Current status')")
print("section:AddTextbox('Input', 'Enter a value', 'Type here...', function(v) print(v) end)")
print("")
print("-- Color customization")
print("myWindow:SetTitleColor(Color3.fromRGB(255, 100, 100))")
print("myWindow:SetAccentColor(Color3.fromRGB(255, 100, 255))")
print("")
print("myWindow:Notify('Hello', 'Welcome!', 'success', 3)")
print("========================================")

-- Return the Hub for other scripts to use
return Hub
