--[[
    ███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██╗██╗  ██╗
    ██╔════╝██║   ██║██╔══██╗██║████╗  ██║██║╚██╗██╔╝
    █████╗  ██║   ██║██████╔╝██║██╔██╗ ██║██║ ╚███╔╝ 
    ██╔══╝  ██║   ██║██╔══██╗██║██║╚██╗██║██║ ██╔██╗ 
    ██║     ╚██████╔╝██████╔╝██║██║ ╚████║██║██╔╝ ██╗
    ╚═╝      ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
    
    FUBNIK UI FRAMEWORK v4.0
    Simple | Powerful | Mobile-Ready | Auto-Scaling
--]]

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- ============================================================================
-- SMART SCALING SYSTEM (EASY TO USE)
-- ============================================================================
local Scale = {}

-- Detect device and return optimal sizes
function Scale:GetDeviceInfo()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled
    local aspectRatio = screenSize.X / screenSize.Y
    
    -- Auto-detect best size
    if isMobile then
        return {
            device = "Mobile",
            windowWidth = math.min(360, screenSize.X - 20),
            windowHeight = math.min(600, screenSize.Y - 100),
            fontSize = 12,
            buttonHeight = 40,
            spacing = 8,
            padding = 10
        }
    elseif aspectRatio > 1.6 then
        return {
            device = "Desktop Wide",
            windowWidth = math.min(450, screenSize.X * 0.35),
            windowHeight = math.min(650, screenSize.Y - 100),
            fontSize = 14,
            buttonHeight = 45,
            spacing = 10,
            padding = 12
        }
    else
        return {
            device = "Desktop",
            windowWidth = math.min(400, screenSize.X * 0.4),
            windowHeight = math.min(600, screenSize.Y - 100),
            fontSize = 13,
            buttonHeight = 42,
            spacing = 8,
            padding = 10
        }
    end
end

-- Easy scaling functions
function Scale:Width(percentage)
    local info = self:GetDeviceInfo()
    return math.floor(info.windowWidth * percentage)
end

function Scale:Height(percentage)
    local info = self:GetDeviceInfo()
    return math.floor(info.windowHeight * percentage)
end

function Scale:Font(size)
    local info = self:GetDeviceInfo()
    return math.floor(size * (info.fontSize / 12))
end

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================
local Utility = {}

function Utility:CreateCorner(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = frame
end

function Utility:CreateStroke(frame, thickness, color)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(60, 60, 80)
    stroke.Parent = frame
end

function Utility:CreateShadow(frame)
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(8, 8, 8, 8)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
end

function Utility:Tween(obj, props, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

function Utility:Ripple(button, x, y)
    local localX = x - button.AbsolutePosition.X
    local localY = y - button.AbsolutePosition.Y
    
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, localX, 0, localY)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    Utility:CreateCorner(ripple, 100)
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utility:Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(0, localX - size/2, 0, localY - size/2),
        BackgroundTransparency = 1
    }, 0.5)
    
    task.wait(0.5)
    ripple:Destroy()
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================
local Notify = {}
local notificationContainer = nil

function Notify:Init()
    if not notificationContainer then
        notificationContainer = Instance.new("Frame")
        notificationContainer.Name = "FubnikNotifications"
        notificationContainer.Size = UDim2.new(0, 320, 1, -20)
        notificationContainer.Position = UDim2.new(1, -340, 0, 10)
        notificationContainer.BackgroundTransparency = 1
        notificationContainer.Parent = CoreGui
    end
end

function Notify:Show(options)
    local title = options.Title or "Notice"
    local message = options.Message or ""
    local duration = options.Duration or 3
    local type = options.Type or "info"
    
    local colors = {
        info = Color3.fromRGB(80, 180, 255),
        success = Color3.fromRGB(80, 255, 120),
        warning = Color3.fromRGB(255, 200, 80),
        error = Color3.fromRGB(255, 80, 100)
    }
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    frame.BackgroundTransparency = 0.1
    frame.AutomaticSize = Enum.AutomaticSize.Y
    Utility:CreateCorner(frame, 12)
    Utility:CreateStroke(frame, 1, colors[type], 0.5)
    frame.Parent = notificationContainer
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, -8)
    accent.Position = UDim2.new(0, 4, 0, 4)
    accent.BackgroundColor3 = colors[type]
    Utility:CreateCorner(accent, 2)
    accent.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 0, 25)
    titleLabel.Position = UDim2.new(0, 20, 0, 8)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -50, 0, 0)
    msgLabel.Position = UDim2.new(0, 20, 0, 33)
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.BackgroundTransparency = 1
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.Parent = frame
    
    -- Animate in
    frame.Size = UDim2.new(1, -10, 0, 0)
    Utility:Tween(frame, {Size = UDim2.new(1, -10, 0, msgLabel.AbsoluteSize.Y + 55)}, 0.3)
    
    -- Auto remove
    task.spawn(function()
        task.wait(duration)
        if frame and frame.Parent then
            Utility:Tween(frame, {Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 1, 0), BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            frame:Destroy()
        end
    end)
end

-- ============================================================================
-- BUTTON COMPONENT
-- ============================================================================
local Button = {}
Button.__index = Button

function Button.new(parent, options)
    local self = setmetatable({}, Button)
    self.Name = options.Name or "Button"
    self.Callback = options.Callback or function() end
    
    local scale = Scale:GetDeviceInfo()
    
    self.Instance = Instance.new("TextButton")
    self.Instance.Size = UDim2.new(1, -20, 0, scale.buttonHeight)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.Text = self.Name
    self.Instance.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Instance.TextSize = Scale:Font(13)
    self.Instance.Font = Enum.Font.GothamSemibold
    self.Instance.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    self.Instance.BackgroundTransparency = 0.1
    Utility:CreateCorner(self.Instance, 8)
    Utility:CreateStroke(self.Instance, 1, Color3.fromRGB(100, 100, 150), 0.3)
    self.Instance.Parent = parent
    
    -- Hover effect
    self.Instance.MouseEnter:Connect(function()
        Utility:Tween(self.Instance, {BackgroundColor3 = Color3.fromRGB(50, 50, 80), BackgroundTransparency = 0.05}, 0.15)
    end)
    
    self.Instance.MouseLeave:Connect(function()
        Utility:Tween(self.Instance, {BackgroundColor3 = Color3.fromRGB(30, 30, 50), BackgroundTransparency = 0.1}, 0.15)
    end)
    
    self.Instance.MouseButton1Click:Connect(function(x, y)
        Utility:Ripple(self.Instance, x, y)
        self.Callback()
    end)
    
    return self
end

-- ============================================================================
-- TOGGLE COMPONENT
-- ============================================================================
local Toggle = {}
Toggle.__index = Toggle

function Toggle.new(parent, options)
    local self = setmetatable({}, Toggle)
    self.Name = options.Name or "Toggle"
    self.Value = options.Default or false
    self.Callback = options.Callback or function() end
    
    local scale = Scale:GetDeviceInfo()
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(1, -20, 0, scale.buttonHeight)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    self.Instance.BackgroundTransparency = 0.1
    Utility:CreateCorner(self.Instance, 8)
    Utility:CreateStroke(self.Instance, 1, Color3.fromRGB(100, 100, 150), 0.3)
    self.Instance.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = self.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = Scale:Font(13)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = self.Instance
    
    self.ToggleBtn = Instance.new("TextButton")
    self.ToggleBtn.Size = UDim2.new(0, 50, 0, 26)
    self.ToggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
    self.ToggleBtn.Text = ""
    self.ToggleBtn.BackgroundColor3 = self.Value and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(100, 100, 150)
    Utility:CreateCorner(self.ToggleBtn, 13)
    self.ToggleBtn.Parent = self.Instance
    
    self.Knob = Instance.new("Frame")
    self.Knob.Size = UDim2.new(0, 22, 0, 22)
    self.Knob.Position = UDim2.new(0, self.Value and 26 or 2, 0.5, -11)
    self.Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Utility:CreateCorner(self.Knob, 11)
    self.Knob.Parent = self.ToggleBtn
    
    self.ToggleBtn.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    function self:SetValue(value)
        if self.Value == value then return end
        self.Value = value
        Utility:Tween(self.ToggleBtn, {BackgroundColor3 = self.Value and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(100, 100, 150)}, 0.2)
        Utility:Tween(self.Knob, {Position = UDim2.new(0, self.Value and 26 or 2, 0.5, -11)}, 0.2)
        self.Callback(self.Value)
    end
    
    function self:GetValue()
        return self.Value
    end
    
    return self
end

-- ============================================================================
-- SLIDER COMPONENT
-- ============================================================================
local Slider = {}
Slider.__index = Slider

function Slider.new(parent, options)
    local self = setmetatable({}, Slider)
    self.Name = options.Name or "Slider"
    self.Min = options.Min or 0
    self.Max = options.Max or 100
    self.Value = options.Default or self.Min
    self.Callback = options.Callback or function() end
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(1, -20, 0, 70)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    self.Instance.BackgroundTransparency = 0.1
    Utility:CreateCorner(self.Instance, 8)
    Utility:CreateStroke(self.Instance, 1, Color3.fromRGB(100, 100, 150), 0.3)
    self.Instance.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 25)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.Text = self.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = Scale:Font(13)
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = self.Instance
    
    self.ValueLabel = Instance.new("TextLabel")
    self.ValueLabel.Size = UDim2.new(0, 80, 0, 25)
    self.ValueLabel.Position = UDim2.new(1, -92, 0, 5)
    self.ValueLabel.Text = tostring(self.Value)
    self.ValueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
    self.ValueLabel.TextSize = Scale:Font(12)
    self.ValueLabel.Font = Enum.Font.GothamBold
    self.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    self.ValueLabel.BackgroundTransparency = 1
    self.ValueLabel.Parent = self.Instance
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 4)
    sliderBg.Position = UDim2.new(0, 12, 0, 42)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Utility:CreateCorner(sliderBg, 2)
    sliderBg.Parent = self.Instance
    
    self.SliderFill = Instance.new("Frame")
    self.SliderFill.Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)
    self.SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Utility:CreateCorner(self.SliderFill, 2)
    self.SliderFill.Parent = sliderBg
    
    self.Knob = Instance.new("Frame")
    self.Knob.Size = UDim2.new(0, 16, 0, 16)
    self.Knob.Position = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), -8, 0.5, -8)
    self.Knob.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Utility:CreateCorner(self.Knob, 8)
    self.Knob.Parent = sliderBg
    
    local dragging = false
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local newValue = self.Min + (relativeX * (self.Max - self.Min))
        newValue = math.floor(newValue + 0.5)
        self.Value = math.clamp(newValue, self.Min, self.Max)
        self.ValueLabel.Text = tostring(self.Value)
        self.SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        self.Knob.Position = UDim2.new(relativeX, -8, 0.5, -8)
        self.Callback(self.Value)
    end
    
    self.Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input)
            dragging = true
        end
    end)
    
    return self
end

-- ============================================================================
-- SECTION COMPONENT
-- ============================================================================
local Section = {}
Section.__index = Section

function Section.new(parent, options)
    local self = setmetatable({}, Section)
    self.Name = options.Name or "Section"
    self.Buttons = {}
    
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.AutomaticSize = Enum.AutomaticSize.Y
    self.Container.Parent = parent
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundTransparency = 1
    header.Parent = self.Container
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Text = self.Name
    title.TextColor3 = Color3.fromRGB(100, 100, 255)
    title.TextSize = Scale:Font(14)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = header
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -20, 0, 1)
    line.Position = UDim2.new(0, 10, 0, 32)
    line.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    line.BackgroundTransparency = 0.5
    line.Parent = self.Container
    
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, 0, 0, 0)
    self.Content.Position = UDim2.new(0, 0, 0, 38)
    self.Content.BackgroundTransparency = 1
    self.Content.AutomaticSize = Enum.AutomaticSize.Y
    self.Content.Parent = self.Container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, Scale:GetDeviceInfo().spacing)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.Content
    
    function self:AddButton(options)
        local btn = Button.new(self.Content, options)
        table.insert(self.Buttons, btn)
        return btn
    end
    
    function self:AddToggle(options)
        local toggle = Toggle.new(self.Content, options)
        table.insert(self.Buttons, toggle)
        return toggle
    end
    
    function self:AddSlider(options)
        local slider = Slider.new(self.Content, options)
        table.insert(self.Buttons, slider)
        return slider
    end
    
    function self:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Position = UDim2.new(0, 12, 0, 0)
        label.Text = text
        label.TextColor3 = Color3.fromRGB(180, 180, 210)
        label.TextSize = Scale:Font(11)
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = self.Content
        return label
    end
    
    return self
end

-- ============================================================================
-- TAB COMPONENT
-- ============================================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(sidebar, container, options)
    local self = setmetatable({}, Tab)
    self.Name = options.Name or "Tab"
    self.Sections = {}
    
    self.Button = Instance.new("TextButton")
    self.Button.Size = UDim2.new(1, -20, 0, 40)
    self.Button.Position = UDim2.new(0, 10, 0, 0)
    self.Button.Text = options.Icon and (options.Icon .. "  " .. self.Name) or self.Name
    self.Button.TextColor3 = Color3.fromRGB(180, 180, 210)
    self.Button.TextSize = Scale:Font(13)
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.BackgroundTransparency = 1
    Utility:CreateCorner(self.Button, 8)
    self.Button.Parent = sidebar
    
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.ScrollBarThickness = 3
    self.Container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    self.Container.Visible = false
    self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Container.Parent = container
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = self.Container
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    
    function self:AddSection(options)
        local section = Section.new(self.Container, options)
        table.insert(self.Sections, section)
        return section
    end
    
    function self:Show()
        self.Container.Visible = true
        Utility:Tween(self.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
    end
    
    function self:Hide()
        self.Container.Visible = false
        Utility:Tween(self.Button, {BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0), TextColor3 = Color3.fromRGB(180, 180, 210)}, 0.2)
    end
    
    self.Button.MouseButton1Click:Connect(function()
        self:Show()
    end)
    
    return self
end

-- ============================================================================
-- MAIN WINDOW CLASS
-- ============================================================================
local Fubnik = {}
Fubnik.__index = Fubnik

function Fubnik:CreateWindow(options)
    local self = setmetatable({}, Fubnik)
    self.Name = options.Name or "Fubnik UI"
    self.Tabs = {}
    
    local scale = Scale:GetDeviceInfo()
    local windowWidth = options.Width or scale.windowWidth
    local windowHeight = options.Height or scale.windowHeight
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "FubnikUI_" .. HttpService:GenerateGUID(false)
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    self.MainFrame.Position = UDim2.new(0.5, -windowWidth/2, 0.5, -windowHeight/2)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    self.MainFrame.BackgroundTransparency = 0.05
    Utility:CreateCorner(self.MainFrame, 12)
    Utility:CreateStroke(self.MainFrame, 1.5, Color3.fromRGB(100, 100, 255), 0.3)
    Utility:CreateShadow(self.MainFrame)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.MainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 150, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Text = self.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = Scale:Font(16)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = self.TitleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 80, 100)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = self.TitleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 160, 1, -45)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 45)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    self.Sidebar.BackgroundTransparency = 0.3
    self.Sidebar.Parent = self.MainFrame
    
    local sidebarList = Instance.new("ScrollingFrame")
    sidebarList.Size = UDim2.new(1, 0, 1, -10)
    sidebarList.Position = UDim2.new(0, 0, 0, 5)
    sidebarList.BackgroundTransparency = 1
    sidebarList.BorderSizePixel = 0
    sidebarList.ScrollBarThickness = 2
    sidebarList.Parent = self.Sidebar
    
    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4)
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarList
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -170, 1, -55)
    self.ContentArea.Position = UDim2.new(0, 165, 0, 50)
    self.ContentArea.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    self.ContentArea.BackgroundTransparency = 0.2
    Utility:CreateCorner(self.ContentArea, 8)
    self.ContentArea.Parent = self.MainFrame
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    function self:AddTab(options)
        local tab = Tab.new(sidebarList, self.ContentArea, options)
        table.insert(self.Tabs, tab)
        
        -- Select first tab automatically
        if #self.Tabs == 1 then
            tab:Show()
        end
        
        return tab
    end
    
    function self:Notify(options)
        Notify:Show(options)
    end
    
    function self:Destroy()
        self.ScreenGui:Destroy()
    end
    
    function self:SetSize(width, height)
        self.MainFrame.Size = UDim2.new(0, width, 0, height)
        self.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    end
    
    return self
end

-- ============================================================================
-- INITIALIZE
-- ============================================================================
Notify:Init()

-- Print device info
local deviceInfo = Scale:GetDeviceInfo()
print(string.format("[FUBNIK] Loaded on %s | Size: %dx%d", deviceInfo.device, deviceInfo.windowWidth, deviceInfo.windowHeight))

-- Return the library
return {
    CreateWindow = function(options) return Fubnik:CreateWindow(options) end,
    Notify = function(options) Notify:Show(options) end,
    Scale = Scale,
    GetDeviceInfo = function() return Scale:GetDeviceInfo() end
}
