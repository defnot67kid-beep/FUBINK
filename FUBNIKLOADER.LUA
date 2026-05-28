local FUBNIK = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Configuration
local Config = {
    Theme = {
        Primary = Color3.fromRGB(66, 135, 245),
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
        Theme = options.Theme or Config.Theme,
        ScreenGui = nil,
        MainFrame = nil
    }
    
    setmetatable(Window, FUBNIKLib)
    
    -- CREATE THE GUI (THIS WAS MISSING!)
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
    CreateStroke(Window.MainFrame, Window.Theme.Primary, 1.5)
    
    -- Title Bar
    Window.TitleBar = Instance.new("Frame")
    Window.TitleBar.Parent = Window.MainFrame
    Window.TitleBar.BackgroundColor3 = Window.Theme.Secondary
    Window.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    CreateRoundedCorner(Window.TitleBar, 8)
    
    -- Title Text
    Window.TitleText = Instance.new("TextLabel")
    Window.TitleText.Parent = Window.TitleBar
    Window.TitleText.BackgroundTransparency = 1
    Window.TitleText.Position = UDim2.new(0, 15, 0, 0)
    Window.TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    Window.TitleText.Font = Enum.Font.GothamBold
    Window.TitleText.Text = Window.Title
    Window.TitleText.TextColor3 = Window.Theme.Text
    Window.TitleText.TextSize = 16
    Window.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local closeBtn = Instance.new("ImageButton")
    closeBtn.Parent = Window.TitleBar
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -35, 0, 10)
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Image = "rbxassetid://1272542343"
    closeBtn.ImageColor3 = Window.Theme.Danger
    closeBtn.MouseButton1Click:Connect(function()
        Window.ScreenGui:Destroy()
    end)
    
    -- Tab Bar
    Window.TabBar = Instance.new("Frame")
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
    
    -- Make window draggable
    local dragging = false
    local dragStart, startPos
    
    Window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Window.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Window.MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return Window
end

-- Tab Creation
function FUBNIKLib:CreateTab(name)
    local Tab = {
        Name = name,
        Window = self,
        Container = Instance.new("ScrollingFrame"),
        Layout = Instance.new("UIListLayout"),
        Button = nil
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
    
    -- Update canvas size
    local function UpdateCanvas()
        local contentSize = Tab.Layout.AbsoluteContentSize
        Tab.Container.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 10)
    end
    
    Tab.Container.ChildAdded:Connect(UpdateCanvas)
    Tab.Container.ChildRemoved:Connect(UpdateCanvas)
    UpdateCanvas()
    
    -- Tab click handler
    Tab.Button.MouseButton1Click:Connect(function()
        for _, t in ipairs(self.Tabs) do
            t.Container.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.15), {
                BackgroundColor3 = self.Theme.Surface,
                TextColor3 = self.Theme.TextDim
            }):Play()
        end
        
        Tab.Container.Visible = true
        TweenService:Create(Tab.Button, TweenInfo.new(0.15), {
            BackgroundColor3 = self.Theme.Primary,
            TextColor3 = self.Theme.Text
        }):Play()
    end)
    
    table.insert(self.Tabs, Tab)
    
    -- Select first tab by default
    if #self.Tabs == 1 then
        Tab.Button.MouseButton1Click:Fire()
    end
    
    return Tab
end

-- Simple Button
function FUBNIKLib:CreateButton(tab, config)
    local button = Instance.new("TextButton")
    button.Parent = tab.Container
    button.BackgroundColor3 = config.Color or self.Theme.Primary
    button.Size = UDim2.new(0.9, 0, 0, 35)
    button.Position = UDim2.new(0.05, 0, 0, 0)
    button.Font = Enum.Font.GothamSemibold
    button.Text = config.Text or "Button"
    button.TextColor3 = self.Theme.Text
    button.TextSize = 14
    CreateRoundedCorner(button, 4)
    
    button.MouseButton1Click:Connect(function()
        if config.Callback then
            config.Callback()
        end
    end)
    
    return button
end

-- Simple Toggle
function FUBNIKLib:CreateToggle(tab, config)
    local frame = Instance.new("Frame")
    frame.Parent = tab.Container
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(0.9, 0, 0, 40)
    frame.Position = UDim2.new(0.05, 0, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Toggle"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.BackgroundColor3 = self.Theme.Background
    toggleBtn.Position = UDim2.new(0.85, -20, 0.5, -12)
    toggleBtn.Size = UDim2.new(0, 40, 0, 24)
    toggleBtn.Text = ""
    CreateRoundedCorner(toggleBtn, 12)
    
    local state = config.Default or false
    
    local function UpdateToggle()
        if state then
            toggleBtn.BackgroundColor3 = self.Theme.Success
            toggleBtn.Text = "ON"
        else
            toggleBtn.BackgroundColor3 = self.Theme.Background
            toggleBtn.Text = "OFF"
        end
        if config.Callback then
            config.Callback(state)
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        UpdateToggle()
    end)
    
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

-- Simple Slider
function FUBNIKLib:CreateSlider(tab, config)
    local frame = Instance.new("Frame")
    frame.Parent = tab.Container
    frame.BackgroundColor3 = self.Theme.Surface
    frame.Size = UDim2.new(0.9, 0, 0, 65)
    frame.Position = UDim2.new(0.05, 0, 0, 0)
    CreateRoundedCorner(frame, 4)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Size = UDim2.new(0.6, 0, 0, 20)
    label.Font = Enum.Font.GothamSemibold
    label.Text = config.Text or "Slider"
    label.TextColor3 = self.Theme.Text
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.BackgroundTransparency = 1
    valueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    valueLabel.Size = UDim2.new(0.25, 0, 0, 20)
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.Text = tostring(config.Default or 0)
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
    
    local min = config.Min or 0
    local max = config.Max or 100
    local value = config.Default or min
    
    local function UpdateSlider(input)
        local relativeX = math.clamp(input.Position.X - sliderBar.AbsolutePosition.X, 0, sliderBar.AbsoluteSize.X)
        local percent = relativeX / sliderBar.AbsoluteSize.X
        value = min + (max - min) * percent
        value = math.floor(value)
        
        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(value)
        
        if config.Callback then
            config.Callback(value)
        end
    end
    
    local dragging = false
    sliderBar.InputBegan:Connect(function(input)
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
    
    return {
        SetValue = function(newValue)
            value = math.clamp(newValue, min, max)
            local percent = (value - min) / (max - min)
            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
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

-- Notification
function FUBNIKLib:Notify(title, message, duration)
    duration = duration or 3
    
    local notification = Instance.new("Frame")
    notification.Parent = self.ScreenGui
    notification.BackgroundColor3 = self.Theme.Surface
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(1, -320, 0, 10)
    CreateRoundedCorner(notification, 6)
    CreateStroke(notification, self.Theme.Primary, 2)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.Size = UDim2.new(1, -20, 0, 20)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = self.Theme.Text
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Parent = notification
    msgLabel.BackgroundTransparency = 1
    msgLabel.Position = UDim2.new(0, 10, 0, 25)
    msgLabel.Size = UDim2.new(1, -20, 0, 20)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Text = message
    msgLabel.TextColor3 = self.Theme.TextDim
    msgLabel.TextSize = 11
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 0, 10)
    }):Play()
    
    task.wait(duration)
    
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 20, 0, 10)
    }):Play()
    
    task.wait(0.3)
    notification:Destroy()
end

return FUBNIK

-- AUTO CREATE A DEMO GUI SO IT WORKS IMMEDIATELY LIKE ORION!
-- This ensures something shows up when you load the library
local function AutoCreateDemo()
    local DemoWindow = FUBNIK:CreateWindow("FUBNIK Demo")
    local DemoHome = DemoWindow:CreateTab("Home")
    
    DemoWindow:CreateLabel(DemoHome, {
        Text = "Welcome to FUBNIK!",
        Size = 18,
        Color = Color3.fromRGB(66, 135, 245)
    })
    
    DemoWindow:CreateButton(DemoHome, {
        Text = "Click Me!",
        Callback = function()
            DemoWindow:Notify("Hello!", "FUBNIK is working!", 2)
        end
    })
    
    DemoWindow:CreateToggle(DemoHome, {
        Text = "Enable Feature",
        Default = false,
        Callback = function(state)
            print("Feature enabled:", state)
        end
    })
    
    DemoWindow:CreateSlider(DemoHome, {
        Text = "Volume",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(value)
            print("Volume:", value)
        end
    })
end

-- Auto-create demo GUI so users see something immediately
spawn(function()
    task.wait(0.5)
    AutoCreateDemo()
end)
