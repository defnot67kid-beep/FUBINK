local FUBNIK = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Configuration
local Config = {
    Theme = {
        Primary = Color3.fromRGB(66, 135, 245),     -- Modern blue
        Secondary = Color3.fromRGB(45, 45, 45),
        Background = Color3.fromRGB(30, 30, 35),
        Surface = Color3.fromRGB(38, 38, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 190),
        Success = Color3.fromRGB(76, 175, 80),
        Danger = Color3.fromRGB(244, 67, 54),
        Warning = Color3.fromRGB(255, 152, 0)
    },
    Animations = {
        Speed = 0.2,
        EasingStyle = Enum.EasingStyle.Quad,
        EasingDirection = Enum.EasingDirection.Out
    },
    Defaults = {
        MinWindowSize = Vector2.new(400, 300),
        MaxWindowSize = Vector2.new(800, 600)
    }
}

-- Utility Functions
local function CreateRoundedCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Parent = parent
    return stroke
end

local function CreateShadow(parent, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, size, 1, size)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 10, 10)
    shadow.Parent = parent
    return shadow
end

-- Main GUI Class
local FUBNIKLib = {}
FUBNIKLib.__index = FUBNIKLib

function FUBNIK:CreateWindow(title, options)
    options = options or {}
    
    local Window = {
        Title = title or "FUBNIK",
        Size = options.Size or UDim2.new(0, 500, 0, 400),
        Position = options.Position or UDim2.new(0.5, -250, 0.5, -200),
        Minimized = false,
        Tabs = {},
        ActiveTab = nil,
        Dragging = false,
        DragStart = nil,
        Connections = {},
        Notifications = {},
        Theme = options.Theme and self.MergeTheme(options.Theme, Config.Theme) or Config.Theme,
        CloseCallback = options.CloseCallback or nil,
        OnTabChanged = options.OnTabChanged or nil
    }
    
    setmetatable(Window, FUBNIKLib)
    
    -- Create GUI elements
    Window.ScreenGui = Instance.new("ScreenGui")
    Window.ScreenGui.Name = "FUBNIK_" .. title:gsub("%s+", "_")
    Window.ScreenGui.Parent = CoreGui
    Window.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    Window.MainFrame = Instance.new("Frame")
    Window.MainFrame.Name = "MainFrame"
    Window.MainFrame.Parent = Window.ScreenGui
    Window.MainFrame.BackgroundColor3 = Window.Theme.Background
    Window.MainFrame.BorderSizePixel = 0
    Window.MainFrame.Position = Window.Position
    Window.MainFrame.Size = Window.Size
    Window.MainFrame.ClipsDescendants = true
    CreateRoundedCorner(Window.MainFrame, 8)
    CreateShadow(Window.MainFrame, 20, 0.6)
    CreateStroke(Window.MainFrame, Window.Theme.Primary, 1.5)
    
    -- Title Bar
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Name = "TitleBar"
    Window.TitleBar.Parent = Window.MainFrame
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    Window.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    CreateRoundedCorner(Window.TitleBar, 8)
    
    -- Title Text
    Window.TitleText = Instance.new("TextLabel")
    Window.TitleText.Parent = Window.TitleBar
    Window.TitleText.BackgroundTransparency = 1
    Window.TitleText.Position = UDim2.new(0, 15, 0, 0)
    Window.TitleText.Size = UDim2.new(0.5, -30, 1, 0)
    Window.TitleText.Font = Enum.Font.GothamBold
    Window.TitleText.Text = Window.Title
    Window.TitleText.TextColor3 = Window.Theme.Text
    Window.TitleText.TextSize = 16
    Window.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Window Controls
    local controlFrame = Instance.new("Frame")
    controlFrame.Parent = Window.TitleBar
    controlFrame.BackgroundTransparency = 1
    controlFrame.Size = UDim2.new(0, 100, 1, 0)
    controlFrame.Position = UDim2.new(1, -105, 0, 0)
    
    -- Minimize Button
    Window.MinimizeBtn = Instance.new("ImageButton")
    Window.MinimizeBtn.Parent = controlFrame
    Window.MinimizeBtn.BackgroundTransparency = 1
    Window.MinimizeBtn.Position = UDim2.new(0, 5, 0, 10)
    Window.MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    Window.MinimizeBtn.Image = "rbxassetid://1272542312"
    Window.MinimizeBtn.ImageColor3 = Window.Theme.TextDim
    
    -- Maximize Button
    Window.MaximizeBtn = Instance.new("ImageButton")
    Window.MaximizeBtn.Parent = controlFrame
    Window.MaximizeBtn.BackgroundTransparency = 1
    Window.MaximizeBtn.Position = UDim2.new(0, 35, 0, 10)
    Window.MaximizeBtn.Size = UDim2.new(0, 20, 0, 20)
    Window.MaximizeBtn.Image = "rbxassetid://1272542329"
    Window.MaximizeBtn.ImageColor3 = Window.Theme.TextDim
    
    -- Close Button
    Window.CloseBtn = Instance.new("ImageButton")
    Window.CloseBtn.Parent = controlFrame
    Window.CloseBtn.BackgroundTransparency = 1
    Window.CloseBtn.Position = UDim2.new(0, 65, 0, 10)
    Window.CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    Window.CloseBtn.Image = "rbxassetid://1272542343"
    Window.CloseBtn.ImageColor3 = Window.Theme.Danger
    
    -- Tab Bar
    Window.TabBar = Instance.new("Frame")
    Window.TabBar.Name = "TabBar"
    Window.TabBar.Parent = Window.MainFrame
    Window.TabBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TabBar.Size = UDim2.new(1, 0, 0, 35)
    Window.TabBar.Position = UDim2.new(0, 0, 0, 40)
    
    -- Tab Container
    Window.TabContainer = Instance.new("Frame")
    Window.TabContainer.Parent = Window.TabBar
    Window.TabContainer.BackgroundTransparency = 1
    Window.TabContainer.Size = UDim2.new(1, -10, 1, 0)
    Window.TabContainer.Position = UDim2.new(0, 5, 0, 0)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = Window.TabContainer
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    
    -- Content Container
    Window.ContentContainer = Instance.new("Frame")
    Window.ContentContainer.Parent = Window.MainFrame
    Window.ContentContainer.BackgroundTransparency = 1
    Window.ContentContainer.Position = UDim2.new(0, 0, 0, 75)
    Window.ContentContainer.Size = UDim2.new(1, 0, 1, -75)
    
    -- Setup dragging
    Window:SetupDragging()
    
    -- Setup window controls
    Window:SetupControls()
    
    return Window
end

function FUBNIKLib:SetupDragging()
    local dragging = false
    local dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

function FUBNIKLib:SetupControls()
    -- Minimize
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Maximize/Restore
    self.MaximizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMaximize()
    end)
    
    -- Close
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
        if self.CloseCallback then
            self.CloseCallback()
        end
    end)
end

function FUBNIKLib:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    local targetSize = self.Minimized and UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 40) or self.Size
    local targetContentAlpha = self.Minimized and 0 or 1
    
    TweenService:Create(self.MainFrame, TweenInfo.new(Config.Animations.Speed, Config.Animations.EasingStyle, Config.Animations.EasingDirection), {
        Size = targetSize
    }):Play()
    
    TweenService:Create(self.ContentContainer, TweenInfo.new(Config.Animations.Speed, Config.Animations.EasingStyle, Config.Animations.EasingDirection), {
        BackgroundTransparency = targetContentAlpha
    }):Play()
    TweenService:Create(self.TabBar, TweenInfo.new(Config.Animations.Speed, Config.Animations.EasingStyle, Config.Animations.EasingDirection), {
        BackgroundTransparency = targetContentAlpha
    }):Play()
end

function FUBNIKLib:ToggleMaximize()
    if self.Maximized then
        -- Restore
        TweenService:Create(self.MainFrame, TweenInfo.new(Config.Animations.Speed, Config.Animations.EasingStyle, Config.Animations.EasingDirection), {
            Size = self.PreviousSize,
            Position = self.PreviousPosition
        }):Play()
        self.Maximized = false
    else
        -- Maximize
        self.PreviousSize = self.MainFrame.Size
        self.PreviousPosition = self.MainFrame.Position
        
        TweenService:Create(self.MainFrame, TweenInfo.new(Config.Animations.Speed, Config.Animations.EasingStyle, Config.Animations.EasingDirection), {
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        self.Maximized = true
    end
end

function FUBNIKLib:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

-- Tab Creation
function FUBNIKLib:CreateTab(name, icon)
    local Tab = {
        Name = name,
        Icon = icon,
        Window = self,
        Elements = {},
        Active = false,
        Container = Instance.new("ScrollingFrame"),
        Layout = Instance.new("UIListLayout"),
        Padding = Instance.new("UIPadding")
    }
    
    -- Tab Button
    Tab.Button = Instance.new("TextButton")
    Tab.Button.Parent = self.TabContainer
    Tab.Button.BackgroundColor3 = self.Theme.Surface
    Tab.Button.BorderSizePixel = 0
    Tab.Button.Size = UDim2.new(0, 80, 1, -5)
    Tab.Button.Position = UDim2.new(0, 0, 0, 2.5)
    Tab.Button.Font = Enum.Font.GothamSemibold
    Tab.Button.Text = name
    Tab.Button.TextColor3 = self.Theme.TextDim
    Tab.Button.TextSize = 13
    CreateRoundedCorner(Tab.Button, 4)
    
    -- Tab Container
    Tab.Container.Parent = self.ContentContainer
    Tab.Container.BackgroundTransparency = 1
    Tab.Container.Size = UDim2.new(1, -20, 1, -10)
    Tab.Container.Position = UDim2.new(0, 10, 0, 5)
    Tab.Container.ScrollBarThickness = 4
    Tab.Container.ScrollBarImageColor3 = self.Theme.Primary
    Tab.Container.Visible = false
    
    Tab.Layout.Parent = Tab.Container
    Tab.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    Tab.Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Tab.Layout.Padding = UDim.new(0, 8)
    
    Tab.Padding.Parent = Tab.Container
    Tab.Padding.PaddingTop = UDim.new(0, 5)
    Tab.Padding.PaddingBottom = UDim.new(0, 5)
    
    -- Update canvas size
    local function UpdateCanvas()
        local contentSize = Tab.Layout.AbsoluteContentSize
        Tab.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
    end
    
    Tab.Container.ChildAdded:Connect(UpdateCanvas)
    Tab.Container.ChildRemoved:Connect(UpdateCanvas)
    UpdateCanvas()
    
    -- Tab selection
    Tab.Button.MouseButton1Click:Connect(function()
        self:SetActiveTab(Tab)
    end)
    
    table.insert(self.Tabs, Tab)
    
    if not self.ActiveTab then
        self:SetActiveTab(Tab)
    end
    
    return Tab
end

function FUBNIKLib:SetActiveTab(tab)
    if self.ActiveTab then
        self.ActiveTab.Active = false
        self.ActiveTab.Container.Visible = false
        TweenService:Create(self.ActiveTab.Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = self.Theme.Surface,
            TextColor3 = self.Theme.TextDim
        }):Play()
    end
    
    self.ActiveTab = tab
    tab.Active = true
    tab.Container.Visible = true
    
    TweenService:Create(tab.Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = self.Theme.Primary,
        TextColor3 = self.Theme.Text
    }):Play()
    
    if self.OnTabChanged then
        self.OnTabChanged(tab.Name)
    end
end

-- Element Creation Methods
function FUBNIKLib:CreateSection(tab, name, options)
    options = options or {}
    
    local section = Instance.new("Frame")
    section.Name = "Section_" .. name
    section.Parent = tab.Container
    section.BackgroundColor3 = self.Theme.Surface
    section.Size = UDim2.new(0.95, 0, 0, options.Height or 50)
    section.BackgroundTransparency = options.Transparency or 0
    CreateRoundedCorner(section, 6)
    
    if options.Collapsible then
        local header = Instance.new("TextButton")
        header.Parent = section
        header.BackgroundTransparency = 1
        header.Size = UDim2.new(1, 0, 0, 30)
        header.Font = Enum.Font.GothamSemibold
        header.Text = "▼ " .. name
        header.TextColor3 = self.Theme.Text
        header.TextSize = 14
        header.TextXAlignment = Enum.TextXAlignment.Left
        
        local content = Instance.new("Frame")
        content.Parent = section
        content.BackgroundTransparency = 1
        content.Position = UDim2.new(0, 10, 0, 35)
        content.Size = UDim2.new(1, -20, 1, -40)
        
        local collapsed = false
        header.MouseButton1Click:Connect(function()
            collapsed = not collapsed
            content.Visible = not collapsed
            header.Text = (collapsed and "▶ " or "▼ ") .. name
            section.Size = UDim2.new(0.95, 0, 0, collapsed and 30 or options.Height or 50)
        end)
        
        return content
    else
        local label = Instance.new("TextLabel")
        label.Parent = section
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Size = UDim2.new(1, -20, 0, 25)
        label.Font = Enum.Font.GothamSemibold
        label.Text = name
        label.TextColor3 = self.Theme.Primary
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local content = Instance.new("Frame")
        content.Parent = section
        content.BackgroundTransparency = 1
        content.Position = UDim2.new(0, 10, 0, 30)
        content.Size = UDim2.new(1, -20, 1, -35)
        
        return content
    end
end

-- Button
function FUBNIKLib:CreateButton(parent, config)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.BackgroundColor3 = config.Color or self.Theme.Primary
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.Font = Enum.Font.GothamSemibold
    button.Text = config.Text or "Button"
    button.TextColor3 = self.Theme.Text
    button.TextSize = 14
    CreateRoundedCorner(button, 4)
    
    if config.Description then
        local desc = Instance.new("TextLabel")
        desc.Parent = parent
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 10, 0, 40)
        desc.Size = UDim2.new(1, -20, 0, 20)
        desc.Font = Enum.Font.Gotham
        desc.Text = config.Description
        desc.TextColor3 = self.Theme.TextDim
        desc.TextSize = 12
        desc.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = config.Color and config.Color:Lerp(Color3.new(1, 1, 1), 0.2) or self.Theme.Primary:Lerp(Color3.new(1, 1, 1), 0.2)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundColor3 = config.Color or self.Theme.Primary
        }):Play()
    end)
    
    return button
end

-- Toggle
function FUBNIKLib:CreateToggle(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.7, -20, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Toggle"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("ImageButton")
    toggleBtn.Parent = frame
    toggleBtn.BackgroundColor3 = self.Theme.Background
    toggleBtn.Position = UDim2.new(0.85, 0, 0.5, -12)
    toggleBtn.Size = UDim2.new(0, 40, 0, 24)
    CreateRoundedCorner(toggleBtn, 12)
    CreateStroke(toggleBtn, self.Theme.TextDim, 1)
    
    local toggleIndicator = Instance.new("Frame")
    toggleIndicator.Parent = toggleBtn
    toggleIndicator.BackgroundColor3 = self.Theme.TextDim
    toggleIndicator.Position = UDim2.new(0, 2, 0, 2)
    toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
    CreateRoundedCorner(toggleIndicator, 10)
    
    local state = config.Default or false
    
    local function UpdateToggle()
        if state then
            TweenService:Create(toggleIndicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 18, 0, 2),
                BackgroundColor3 = self.Theme.Success
            }):Play()
            TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Success
            }):Play()
        else
            TweenService:Create(toggleIndicator, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, 2, 0, 2),
                BackgroundColor3 = self.Theme.TextDim
            }):Play()
            TweenService:Create(toggleBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundColor3 = self.Theme.Background
            }):Play()
        end
        
        if config.Callback then
            config.Callback(state)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        UpdateToggle()
    end)
    
    if config.Description then
        local desc = Instance.new("TextLabel")
        desc.Parent = frame
        desc.BackgroundTransparency = 1
        desc.Position = UDim2.new(0, 10, 0, 25)
        desc.Size = UDim2.new(1, -20, 0, 15)
        desc.Font = Enum.Font.Gotham
        desc.Text = config.Description
        desc.TextColor3 = self.Theme.TextDim
        desc.TextSize = 11
        desc.TextXAlignment = Enum.TextXAlignment.Left
        frame.Size = UDim2.new(1, -20, 0, 60)
    end
    
    UpdateToggle()
    
    return {
        SetValue = function(newState)
            state = newState
            UpdateToggle()
        end,
        GetValue = function()
            return state
        end
    }
end

-- Slider
function FUBNIKLib:CreateSlider(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Slider"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.Size = UDim2.new(0.25, -10, 0, 20)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(config.Default or config.Min or 0)
    valueLabel.TextColor3 = self.Theme.Primary
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Parent = frame
    sliderBar.BackgroundColor3 = self.Theme.Background
    sliderBar.Position = UDim2.new(0, 10, 0, 35)
    sliderBar.Size = UDim2.new(1, -20, 0, 4)
    CreateRoundedCorner(sliderBar, 2)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Parent = sliderBar
    sliderFill.BackgroundColor3 = self.Theme.Primary
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    CreateRoundedCorner(sliderFill, 2)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Parent = sliderBar
    sliderKnob.BackgroundColor3 = self.Theme.Text
    sliderKnob.Position = UDim2.new(0, -7, 0.5, -7)
    sliderKnob.Size = UDim2.new(0, 14, 0, 14)
    CreateRoundedCorner(sliderKnob, 7)
    CreateStroke(sliderKnob, self.Theme.Primary, 2)
    
    local min = config.Min or 0
    local max = config.Max or 100
    local decimal = config.Decimal or 0
    local value = config.Default or min
    
    local function UpdateSlider(input)
        local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        local percent = relativeX / sliderBar.AbsoluteSize.X
        value = min + (max - min) * percent
        
        if decimal > 0 then
            value = tonumber(string.format("%." .. decimal .. "f", value))
        else
            value = math.floor(value)
        end
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percent, -7, 0.5, -7)
        valueLabel.Text = tostring(value)
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    local dragging = false
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UpdateSlider({Position = Vector2.new(sliderBar.AbsolutePosition.X + (value - min) / (max - min) * sliderBar.AbsoluteSize.X, 0)})
    
    return {
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local percent = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
            sliderKnob.Position = UDim2.new(percent, -7, 0.5, -7)
            valueLabel.Text = tostring(value)
            if config.Callback then
                config.Callback(value)
            end
        end,
        GetValue = function()
            return value
        end
    }
end

-- Dropdown
function FUBNIKLib:CreateDropdown(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    frame.ClipsDescendants = true
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -20, 0, 45)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Dropdown"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Parent = frame
    dropdownBtn.BackgroundColor3 = self.Theme.Background
    dropdownBtn.Position = UDim2.new(0.7, -5, 0.5, -12)
    dropdownBtn.Size = UDim2.new(0.25, -10, 0, 24)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Text = config.Default or "Select"
    dropdownBtn.TextColor3 = self.Theme.Text
    dropdownBtn.TextSize = 12
    CreateRoundedCorner(dropdownBtn, 4)
    
    local expanded = false
    local optionsFrame = Instance.new("Frame")
    optionsFrame.Parent = frame
    optionsFrame.BackgroundColor3 = self.Theme.Background
    optionsFrame.Position = UDim2.new(0, 5, 0, 45)
    optionsFrame.Size = UDim2.new(1, -10, 0, 0)
    CreateRoundedCorner(optionsFrame, 4)
    optionsFrame.ClipsDescendants = true
    
    local optionsList = Instance.new("UIListLayout")
    optionsList.Parent = optionsFrame
    optionsList.Padding = UDim.new(0, 2)
    
    local function UpdateHeight()
        local count = #optionsFrame:GetChildren() - 1
        optionsFrame.Size = UDim2.new(1, -10, 0, count * 30)
        frame.Size = UDim2.new(1, -20, 0, 45 + (expanded and count * 30 or 0))
    end
    
    for _, option in ipairs(config.Options or {}) do
        local optBtn = Instance.new("TextButton")
        optBtn.Parent = optionsFrame
        optBtn.BackgroundColor3 = self.Theme.Surface
        optBtn.Size = UDim2.new(1, -10, 0, 28)
        optBtn.Position = UDim2.new(0, 5, 0, 0)
        optBtn.Font = Enum.Font.Gotham
        optBtn.Text = option
        optBtn.TextColor3 = self.Theme.TextDim
        optBtn.TextSize = 12
        CreateRoundedCorner(optBtn, 3)
        
        optBtn.MouseButton1Click:Connect(function()
            dropdownBtn.Text = option
            expanded = false
            optionsFrame.Visible = false
            frame.Size = UDim2.new(1, -20, 0, 45)
            if config.Callback then
                config.Callback(option)
            end
        end)
        
        optBtn.MouseEnter:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.Primary, TextColor3 = self.Theme.Text}):Play()
        end)
        
        optBtn.MouseLeave:Connect(function()
            TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = self.Theme.Surface, TextColor3 = self.Theme.TextDim}):Play()
        end)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        optionsFrame.Visible = expanded
        local count = #config.Options
        if expanded then
            frame.Size = UDim2.new(1, -20, 0, 45 + count * 30)
        else
            frame.Size = UDim2.new(1, -20, 0, 45)
        end
    end)
    
    return {
        SetValue = function(option)
            dropdownBtn.Text = option
            if config.Callback then
                config.Callback(option)
            end
        end,
        GetValue = function()
            return dropdownBtn.Text
        end
    }
end

-- TextBox
function FUBNIKLib:CreateTextBox(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 70)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Text Input"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local textBox = Instance.new("TextBox")
    textBox.Parent = frame
    textBox.BackgroundColor3 = self.Theme.Background
    textBox.Position = UDim2.new(0, 10, 0, 30)
    textBox.Size = UDim2.new(1, -20, 0, 30)
    textBox.Font = Enum.Font.Gotham
    textBox.PlaceholderText = config.Placeholder or "Enter text..."
    textBox.PlaceholderColor3 = self.Theme.TextDim
    textBox.TextColor3 = self.Theme.Text
    textBox.TextSize = 13
    CreateRoundedCorner(textBox, 4)
    CreateStroke(textBox, self.Theme.Primary, 1)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and config.Callback then
            config.Callback(textBox.Text)
        end
    end)
    
    return {
        SetText = function(text)
            textBox.Text = text
        end,
        GetText = function()
            return textBox.Text
        end
    }
end

-- Keybind
function FUBNIKLib:CreateKeybind(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Keybind"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local keyBtn = Instance.new("TextButton")
    keyBtn.Parent = frame
    keyBtn.BackgroundColor3 = self.Theme.Background
    keyBtn.Position = UDim2.new(0.7, -5, 0.5, -12)
    keyBtn.Size = UDim2.new(0.25, -10, 0, 24)
    keyBtn.Font = Enum.Font.GothamBold
    keyBtn.Text = config.Default or "None"
    keyBtn.TextColor3 = self.Theme.Text
    keyBtn.TextSize = 12
    CreateRoundedCorner(keyBtn, 4)
    
    local listening = false
    local currentKey = config.Default
    
    keyBtn.MouseButton1Click:Connect(function()
        listening = true
        keyBtn.Text = "..."
        keyBtn.BackgroundColor3 = self.Theme.Primary
    end)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if listening and not gameProcessed then
            local key = input.KeyCode.Name
            if key ~= "Unknown" then
                listening = false
                currentKey = key
                keyBtn.Text = key
                keyBtn.BackgroundColor3 = self.Theme.Background
                
                if config.Callback then
                    config.Callback(key)
                end
            end
            connection:Disconnect()
        end
    end)
    
    return {
        GetKey = function()
            return currentKey
        end,
        SetKey = function(key)
            currentKey = key
            keyBtn.Text = key
        end
    }
end

-- Notification System
function FUBNIKLib:Notify(title, message, duration, type)
    type = type or "info"
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Parent = self.ScreenGui
    notification.BackgroundColor3 = self.Theme.Surface
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(1, 20, 0, 50)
    notification.ClipsDescendants = true
    CreateRoundedCorner(notification, 6)
    CreateStroke(notification, self.Theme[type:gsub("^%l", string.upper)] or self.Theme.Primary, 2)
    
    local icon = Instance.new("ImageLabel")
    icon.Parent = notification
    icon.BackgroundTransparency = 1
    icon.Position = UDim2.new(0, 10, 0, 15)
    icon.Size = UDim2.new(0, 30, 0, 30)
    
    if type == "success" then
        icon.Image = "rbxassetid://1272542304"
        icon.ImageColor3 = self.Theme.Success
    elseif type == "error" then
        icon.Image = "rbxassetid://1272542343"
        icon.ImageColor3 = self.Theme.Danger
    elseif type == "warning" then
        icon.Image = "rbxassetid://1272542321"
        icon.ImageColor3 = self.Theme.Warning
    else
        icon.Image = "rbxassetid://1272542329"
        icon.ImageColor3 = self.Theme.Primary
    end
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 50, 0, 8)
    titleLabel.Size = UDim2.new(1, -60, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Parent = notification
    msgLabel.BackgroundTransparency = 1
    msgLabel.Position = UDim2.new(0, 50, 0, 28)
    msgLabel.Size = UDim2.new(1, -60, 0, 20)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Text = message
    msgLabel.TextColor3 = self.Theme.TextDim
    msgLabel.TextSize = 11
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    
    notification.Position = UDim2.new(1, 20, 0, #self.Notifications * 70 + 50)
    table.insert(self.Notifications, notification)
    
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, #self.Notifications * 70 + 50)
    }):Play()
    
    task.wait(duration)
    
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, 0, #self.Notifications * 70 + 50)
    }):Play()
    
    task.wait(0.3)
    notification:Destroy()
    table.remove(self.Notifications, 1)
    
    for i, notif in ipairs(self.Notifications) do
        TweenService:Create(notif, TweenInfo.new(0.2), {
            Position = UDim2.new(1, -320, 0, i * 70 + 50)
        }):Play()
    end
end

-- Color Picker
function FUBNIKLib:CreateColorPicker(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Color"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local colorDisplay = Instance.new("Frame")
    colorDisplay.Parent = frame
    colorDisplay.Position = UDim2.new(0.85, -15, 0.5, -10)
    colorDisplay.Size = UDim2.new(0, 20, 0, 20)
    CreateRoundedCorner(colorDisplay, 4)
    CreateStroke(colorDisplay, self.Theme.TextDim, 1)
    
    local currentColor = config.Default or self.Theme.Primary
    colorDisplay.BackgroundColor3 = currentColor
    
    colorDisplay.MouseButton1Click:Connect(function()
        -- Simplified color picker UI
        local pickerFrame = Instance.new("Frame")
        pickerFrame.Parent = self.ScreenGui
        pickerFrame.BackgroundColor3 = self.Theme.Surface
        pickerFrame.Size = UDim2.new(0, 200, 0, 150)
        pickerFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
        pickerFrame.ZIndex = 10
        CreateRoundedCorner(pickerFrame, 8)
        
        -- Color presets would go here
        local closeBtn = Instance.new("TextButton")
        closeBtn.Parent = pickerFrame
        closeBtn.Size = UDim2.new(1, -20, 0, 30)
        closeBtn.Position = UDim2.new(0, 10, 0, 110)
        closeBtn.Text = "Close"
        closeBtn.BackgroundColor3 = self.Theme.Primary
        closeBtn.TextColor3 = self.Theme.Text
        CreateRoundedCorner(closeBtn, 4)
        
        closeBtn.MouseButton1Click:Connect(function()
            pickerFrame:Destroy()
        end)
        
        if config.Callback then
            -- In real implementation, you'd add actual color picking
            config.Callback(currentColor)
        end
    end)
    
    return {
        SetColor = function(color)
            currentColor = color
            colorDisplay.BackgroundColor3 = color
            if config.Callback then
                config.Callback(color)
            end
        end,
        GetColor = function()
            return currentColor
        end
    }
end

-- Progress Bar
function FUBNIKLib:CreateProgressBar(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, 50)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(0.7, 0, 0, 20)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Progress"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local percentLabel = Instance.new("TextLabel")
    percentLabel.Parent = frame
    percentLabel.BackgroundTransparency = 1
    percentLabel.Position = UDim2.new(0.7, 0, 0, 5)
    percentLabel.Size = UDim2.new(0.25, -10, 0, 20)
    percentLabel.Font = Enum.Font.GothamBold
    percentLabel.Text = "0%"
    percentLabel.TextColor3 = self.Theme.Primary
    percentLabel.TextSize = 13
    percentLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local barBg = Instance.new("Frame")
    barBg.Parent = frame
    barBg.BackgroundColor3 = self.Theme.Background
    barBg.Position = UDim2.new(0, 10, 0, 30)
    barBg.Size = UDim2.new(1, -20, 0, 8)
    CreateRoundedCorner(barBg, 4)
    
    local barFill = Instance.new("Frame")
    barFill.Parent = barBg
    barFill.BackgroundColor3 = config.Color or self.Theme.Primary
    barFill.Size = UDim2.new(0, 0, 1, 0)
    CreateRoundedCorner(barFill, 4)
    
    local progress = config.Default or 0
    local max = config.Max or 100
    
    local function UpdateProgress(value)
        progress = math.clamp(value, 0, max)
        local percent = progress / max
        barFill.Size = UDim2.new(percent, 0, 1, 0)
        percentLabel.Text = math.floor(percent * 100) .. "%"
        
        if config.Callback then
            config.Callback(progress)
        end
    end
    
    UpdateProgress(progress)
    
    return {
        SetValue = UpdateProgress,
        GetValue = function() return progress end,
        Increment = function(amount)
            UpdateProgress(progress + (amount or 1))
        end
    }
end

-- Label
function FUBNIKLib:CreateLabel(parent, config)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(1, -20, 0, config.Height or 35)
    frame.Position = UDim2.new(0, 10, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = config.Text or "Label"
    label.TextColor3 = config.Color or self.Theme.TextDim
    label.TextSize = config.Size or 13
    label.TextXAlignment = config.XAlign or Enum.TextXAlignment.Center
    label.TextWrapped = true
    
    if config.Icon then
        local icon = Instance.new("ImageLabel")
        icon.Parent = frame
        icon.BackgroundTransparency = 1
        icon.Position = UDim2.new(0, 5, 0.5, -10)
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Image = config.Icon
        icon.ImageColor3 = config.Color or self.Theme.Primary
        label.Position = UDim2.new(0, 30, 0, 0)
        label.Size = UDim2.new(1, -35, 1, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    return {
        SetText = function(text)
            label.Text = text
        end,
        SetColor = function(color)
            label.TextColor3 = color
        end
    }
end

-- Separator
function FUBNIKLib:CreateSeparator(parent)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = self.Theme.TextDim
    frame.BackgroundTransparency = 0.7
    frame.Size = UDim2.new(1, -20, 0, 1)
    frame.Position = UDim2.new(0, 10, 0, 0)
    return frame
end

-- Bind to Hotkey
function FUBNIKLib:BindToHotkey(key, callback)
    local connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode.Name == key then
            callback()
        end
    end)
    
    table.insert(self.Connections, connection)
    return connection
end

-- Unbind all
function FUBNIKLib:UnbindAll()
    for _, conn in ipairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
end

-- Merge themes
function FUBNIK:MergeTheme(custom, default)
    local merged = {}
    for k, v in pairs(default) do
        merged[k] = custom[k] or v
    end
    return merged
end

return FUBNIK
