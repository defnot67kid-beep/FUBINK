-- ==============================================
-- 🌟 NEBULA UI - ULTIMATE SCRIPT HUB FRAMEWORK 🌟
-- Custom Advanced UI Library
-- Version: 3.0 | Performance Optimized
-- ==============================================

local NebulaUI = {}
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- UI Settings
local Settings = {
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226),      -- Purple
        Secondary = Color3.fromRGB(75, 0, 130),      -- Dark Purple
        Accent = Color3.fromRGB(255, 69, 0),         -- Orange Red
        Background = Color3.fromRGB(20, 20, 30),     -- Dark Blue Gray
        Surface = Color3.fromRGB(30, 30, 40),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 200),
        Success = Color3.fromRGB(0, 255, 0),
        Error = Color3.fromRGB(255, 0, 0)
    },
    Animations = {
        Duration = 0.3,
        Style = Enum.EasingStyle.Quad,
        Direction = Enum.EasingDirection.Out
    }
}

-- UI Elements Storage
local Windows = {}
local Notifications = {}
local Dragging = false
local DragStart = nil
local StartPos = nil

-- ============== UTILITY FUNCTIONS ==============
local function CreateRoundedCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

local function ApplyGradient(frame, color1, color2, direction)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    if direction == "horizontal" then
        gradient.Rotation = 0
    elseif direction == "vertical" then
        gradient.Rotation = 90
    elseif direction == "diagonal" then
        gradient.Rotation = 45
    end
    gradient.Parent = frame
    return gradient
end

local function CreateGlowEffect(parent, color, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.Size = UDim2.new(1, size, 1, size)
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color
    glow.ImageTransparency = 0.7
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    return glow
end

-- ============== CORE WINDOW CLASS ==============
local NebulaWindow = {}
NebulaWindow.__index = NebulaWindow

function NebulaWindow.new(title, options)
    options = options or {}
    
    local self = setmetatable({}, NebulaWindow)
    self.Title = title or "Nebula UI"
    self.Size = options.Size or UDim2.new(0, 600, 0, 450)
    self.Theme = options.Theme or Settings.Theme
    self.Tabs = {}
    self.CurrentTab = nil
    self.Elements = {}
    
    -- Create GUI
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NebulaUI_" .. tostring(os.time())
    self.ScreenGui.Parent = game.CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = self.Theme.Background
    self.MainFrame.BackgroundTransparency = 0.05
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.Size = self.Size
    self.MainFrame.ClipsDescendants = true
    CreateRoundedCorner(self.MainFrame, 12)
    CreateShadow(self.MainFrame)
    
    -- Blur Background
    if options.Blur then
        local blur = Instance.new("BlurEffect")
        blur.Size = 12
        blur.Parent = game.Lighting
    end
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Parent = self.MainFrame
    self.TitleBar.BackgroundColor3 = self.Theme.Primary
    self.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    CreateRoundedCorner(self.TitleBar, 12)
    
    -- Gradient on Title Bar
    ApplyGradient(self.TitleBar, self.Theme.Primary, self.Theme.Secondary, "horizontal")
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Parent = self.TitleBar
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Position = UDim2.new(0, 15, 0, 0)
    self.TitleText.Size = UDim2.new(0, 200, 1, 0)
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.Text = "✦ " .. self.Title .. " ✦"
    self.TitleText.TextColor3 = self.Theme.Text
    self.TitleText.TextSize = 18
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.TextYAlignment = Enum.TextYAlignment.Center
    
    -- Close Button
    self.CloseBtn = Instance.new("ImageButton")
    self.CloseBtn.Parent = self.TitleBar
    self.CloseBtn.BackgroundTransparency = 1
    self.CloseBtn.Position = UDim2.new(1, -40, 0, 10)
    self.CloseBtn.Size = UDim2.new(0, 25, 0, 25)
    self.CloseBtn.Image = "rbxassetid://3926305904"
    self.CloseBtn.ImageColor3 = self.Theme.Text
    
    -- Minimize Button
    self.MinimizeBtn = Instance.new("ImageButton")
    self.MinimizeBtn.Parent = self.TitleBar
    self.MinimizeBtn.BackgroundTransparency = 1
    self.MinimizeBtn.Position = UDim2.new(1, -75, 0, 10)
    self.MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
    self.MinimizeBtn.Image = "rbxassetid://4892625271"
    self.MinimizeBtn.ImageColor3 = self.Theme.Text
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundColor3 = self.Theme.Surface
    self.TabContainer.BackgroundTransparency = 0.5
    self.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    self.TabContainer.Size = UDim2.new(0, 150, 1, -45)
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Position = UDim2.new(0, 150, 0, 45)
    self.ContentContainer.Size = UDim2.new(1, -150, 1, -45)
    
    -- Make draggable
    self:MakeDraggable()
    
    -- Close functionality
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimize functionality
    local minimized = false
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 50)
            }):Play()
            self.ContentContainer.Visible = false
            self.TabContainer.Visible = false
        else
            TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = self.Size
            }):Play()
            self.ContentContainer.Visible = true
            self.TabContainer.Visible = true
        end
    end)
    
    return self
end

function NebulaWindow:MakeDraggable()
    local dragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil
    
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
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function NebulaWindow:CreateTab(tabName, icon)
    local tabButton = Instance.new("TextButton")
    tabButton.Parent = self.TabContainer
    tabButton.BackgroundColor3 = self.Theme.Background
    tabButton.BackgroundTransparency = 0.3
    tabButton.Size = UDim2.new(1, -10, 0, 45)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 50) + 5)
    tabButton.Text = "  " .. (icon or "📁") .. "  " .. tabName
    tabButton.TextColor3 = self.Theme.TextSecondary
    tabButton.TextSize = 14
    tabButton.Font = Enum.Font.GothamSemibold
    tabButton.TextXAlignment = Enum.TextXAlignment.Left
    CreateRoundedCorner(tabButton, 8)
    
    -- Hover effect
    tabButton.MouseEnter:Connect(function()
        TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
        TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = self.Theme.Text}):Play()
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabButton then
            TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
            TweenService:Create(tabButton, TweenInfo.new(0.2), {TextColor3 = self.Theme.TextSecondary}):Play()
        end
    end)
    
    -- Tab Content Frame
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Parent = self.ContentContainer
    tabFrame.BackgroundTransparency = 1
    tabFrame.Size = UDim2.new(1, -20, 1, -20)
    tabFrame.Position = UDim2.new(0, 10, 0, 10)
    tabFrame.ScrollBarThickness = 6
    tabFrame.ScrollBarImageColor3 = self.Theme.Primary
    tabFrame.Visible = false
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabFrame
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Update canvas size
    local function updateCanvas()
        local contentSize = uiListLayout.AbsoluteContentSize
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end
    
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    task.defer(updateCanvas)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, btn in pairs(self.TabContainer:GetChildren()) do
            if btn:IsA("TextButton") then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3, TextColor3 = self.Theme.TextSecondary}):Play()
            end
        end
        for _, frame in pairs(self.ContentContainer:GetChildren()) do
            if frame:IsA("ScrollingFrame") then
                frame.Visible = false
            end
        end
        
        TweenService:Create(tabButton, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = self.Theme.Accent}):Play()
        tabFrame.Visible = true
        self.CurrentTab = tabButton
    end)
    
    table.insert(self.Tabs, {Button = tabButton, Frame = tabFrame, Name = tabName})
    
    -- Element handler for this tab
    local tabHandler = {}
    
    function tabHandler:Section(title)
        local sectionFrame = Instance.new("Frame")
        sectionFrame.Parent = tabFrame
        sectionFrame.BackgroundColor3 = self.Theme.Surface
        sectionFrame.BackgroundTransparency = 0.3
        sectionFrame.Size = UDim2.new(0.95, 0, 0, 60)
        sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
        CreateRoundedCorner(sectionFrame, 8)
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = sectionFrame
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Position = UDim2.new(0, 15, 0, 10)
        sectionTitle.Size = UDim2.new(1, -30, 0, 30)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = title
        sectionTitle.TextColor3 = self.Theme.Accent
        sectionTitle.TextSize = 16
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local divider = Instance.new("Frame")
        divider.Parent = sectionFrame
        divider.BackgroundColor3 = self.Theme.Primary
        divider.BackgroundTransparency = 0.5
        divider.Position = UDim2.new(0, 15, 0, 40)
        divider.Size = UDim2.new(0.95, -30, 0, 2)
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Parent = sectionFrame
        contentFrame.BackgroundTransparency = 1
        contentFrame.Position = UDim2.new(0, 15, 0, 50)
        contentFrame.Size = UDim2.new(1, -30, 1, -60)
        contentFrame.AutomaticSize = Enum.AutomaticSize.Y
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Parent = contentFrame
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        return {
            AddElement = function(elementFunc, ...)
                local element = elementFunc(contentFrame, ...)
                return element
            end
        }
    end
    
    function tabHandler:Button(text, description, callback)
        local buttonFrame = Instance.new("Frame")
        buttonFrame.Parent = tabFrame
        buttonFrame.BackgroundColor3 = self.Theme.Surface
        buttonFrame.BackgroundTransparency = 0.5
        buttonFrame.Size = UDim2.new(0.95, 0, 0, 50)
        CreateRoundedCorner(buttonFrame, 8)
        
        local button = Instance.new("TextButton")
        button.Parent = buttonFrame
        button.BackgroundColor3 = self.Theme.Primary
        button.Size = UDim2.new(0, 120, 0, 35)
        button.Position = UDim2.new(0, 15, 0, 7.5)
        button.Text = text
        button.TextColor3 = self.Theme.Text
        button.TextSize = 14
        button.Font = Enum.Font.GothamSemibold
        CreateRoundedCorner(button, 6)
        
        -- Hover animation
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 125, 0, 38)}):Play()
            CreateGlowEffect(button, self.Theme.Primary, 15)
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 35)}):Play()
        end)
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = buttonFrame
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 145, 0, 0)
        descLabel.Size = UDim2.new(1, -160, 1, 0)
        descLabel.Text = description or ""
        descLabel.TextColor3 = self.Theme.TextSecondary
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        
        button.MouseButton1Click:Connect(function()
            task.spawn(callback)
            -- Ripple effect
            local ripple = Instance.new("Frame")
            ripple.Parent = button
            ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ripple.BackgroundTransparency = 0.5
            ripple.Size = UDim2.new(0, 0, 0, 0)
            ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
            CreateRoundedCorner(ripple, 100)
            TweenService:Create(ripple, TweenInfo.new(0.3), {Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1}):Play()
            task.delay(0.3, function() ripple:Destroy() end)
        end)
        
        return buttonFrame
    end
    
    function tabHandler:Toggle(text, default, callback)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = tabFrame
        toggleFrame.BackgroundColor3 = self.Theme.Surface
        toggleFrame.BackgroundTransparency = 0.5
        toggleFrame.Size = UDim2.new(0.95, 0, 0, 45)
        CreateRoundedCorner(toggleFrame, 8)
        
        local label = Instance.new("TextLabel")
        label.Parent = toggleFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(1, -80, 1, 0)
        label.Text = text
        label.TextColor3 = self.Theme.Text
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggleBtn = Instance.new("Frame")
        toggleBtn.Parent = toggleFrame
        toggleBtn.Position = UDim2.new(1, -55, 0, 10)
        toggleBtn.Size = UDim2.new(0, 45, 0, 25)
        toggleBtn.BackgroundColor3 = default and self.Theme.Primary or self.Theme.Surface
        CreateRoundedCorner(toggleBtn, 25)
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Parent = toggleBtn
        toggleIndicator.Position = default and UDim2.new(1, -23, 0, 2) or UDim2.new(0, 2, 0, 2)
        toggleIndicator.Size = UDim2.new(0, 21, 0, 21)
        toggleIndicator.BackgroundColor3 = self.Theme.Text
        CreateRoundedCorner(toggleIndicator, 21)
        
        local toggled = default or false
        
        local function updateToggle()
            if toggled then
                TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Primary}):Play()
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0, 2)}):Play()
            else
                TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Surface}):Play()
                TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            end
            callback(toggled)
        end
        
        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                toggled = not toggled
                updateToggle()
            end
        end)
        
        updateToggle()
        return toggleFrame
    end
    
    function tabHandler:Slider(text, min, max, default, callback)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = tabFrame
        sliderFrame.BackgroundColor3 = self.Theme.Surface
        sliderFrame.BackgroundTransparency = 0.5
        sliderFrame.Size = UDim2.new(0.95, 0, 0, 70)
        CreateRoundedCorner(sliderFrame, 8)
        
        local label = Instance.new("TextLabel")
        label.Parent = sliderFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 10)
        label.Size = UDim2.new(1, -30, 0, 20)
        label.Text = text
        label.TextColor3 = self.Theme.Text
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = sliderFrame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Position = UDim2.new(1, -60, 0, 10)
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Text = tostring(default or min)
        valueLabel.TextColor3 = self.Theme.Accent
        valueLabel.TextSize = 14
        valueLabel.Font = Enum.Font.GothamBold
        
        local sliderBg = Instance.new("Frame")
        sliderBg.Parent = sliderFrame
        sliderBg.Position = UDim2.new(0, 15, 0, 40)
        sliderBg.Size = UDim2.new(1, -30, 0, 4)
        sliderBg.BackgroundColor3 = self.Theme.Secondary
        CreateRoundedCorner(sliderBg, 2)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Parent = sliderBg
        sliderFill.Size = UDim2.new((default or min) / max, 0, 1, 0)
        sliderFill.BackgroundColor3 = self.Theme.Primary
        CreateRoundedCorner(sliderFill, 2)
        
        local sliderBtn = Instance.new("TextButton")
        sliderBtn.Parent = sliderBg
        sliderBtn.BackgroundColor3 = self.Theme.Text
        sliderBtn.Size = UDim2.new(0, 15, 0, 15)
        sliderBtn.Position = UDim2.new((default or min) / max, -7.5, -5.5, 0)
        CreateRoundedCorner(sliderBtn, 15)
        
        local dragging = false
        local value = default or min
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            value = math.floor(min + (max - min) * relativeX)
            valueLabel.Text = tostring(value)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderBtn.Position = UDim2.new(relativeX, -7.5, -5.5, 0)
            callback(value)
        end
        
        sliderBtn.MouseButton1Down:Connect(function()
            dragging = true
            updateSlider(Mouse)
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        return sliderFrame
    end
    
    function tabHandler:Dropdown(text, options, default, callback)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Parent = tabFrame
        dropdownFrame.BackgroundColor3 = self.Theme.Surface
        dropdownFrame.BackgroundTransparency = 0.5
        dropdownFrame.Size = UDim2.new(0.95, 0, 0, 45)
        CreateRoundedCorner(dropdownFrame, 8)
        dropdownFrame.ClipsDescendants = true
        
        local label = Instance.new("TextLabel")
        label.Parent = dropdownFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(0.6, -20, 1, 0)
        label.Text = text
        label.TextColor3 = self.Theme.Text
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Parent = dropdownFrame
        dropdownBtn.BackgroundColor3 = self.Theme.Background
        dropdownBtn.Position = UDim2.new(0.65, 0, 0, 10)
        dropdownBtn.Size = UDim2.new(0.3, -20, 0, 25)
        dropdownBtn.Text = default or options[1] or "Select"
        dropdownBtn.TextColor3 = self.Theme.Text
        dropdownBtn.TextSize = 12
        dropdownBtn.Font = Enum.Font.Gotham
        CreateRoundedCorner(dropdownBtn, 6)
        
        local expanded = false
        local dropdownList = nil
        
        local function createDropdownList()
            if dropdownList then dropdownList:Destroy() end
            
            dropdownList = Instance.new("Frame")
            dropdownList.Parent = dropdownFrame
            dropdownList.BackgroundColor3 = self.Theme.Surface
            dropdownList.Position = UDim2.new(0.65, 0, 0, 40)
            dropdownList.Size = UDim2.new(0.3, -20, 0, math.min(#options * 30, 150))
            dropdownList.ZIndex = 10
            CreateRoundedCorner(dropdownList, 6)
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.Parent = dropdownList
            listLayout.Padding = UDim.new(0, 2)
            
            for _, option in pairs(options) do
                local optionBtn = Instance.new("TextButton")
                optionBtn.Parent = dropdownList
                optionBtn.BackgroundColor3 = self.Theme.Background
                optionBtn.Size = UDim2.new(1, -4, 0, 28)
                optionBtn.Position = UDim2.new(0, 2, 0, 0)
                optionBtn.Text = option
                optionBtn.TextColor3 = self.Theme.TextSecondary
                optionBtn.TextSize = 12
                optionBtn.Font = Enum.Font.Gotham
                CreateRoundedCorner(optionBtn, 4)
                
                optionBtn.MouseButton1Click:Connect(function()
                    dropdownBtn.Text = option
                    callback(option)
                    expanded = false
                    dropdownList.Visible = false
                end)
                
                optionBtn.MouseEnter:Connect(function()
                    TweenService:Create(optionBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Primary, TextColor3 = self.Theme.Text}):Play()
                end)
                
                optionBtn.MouseLeave:Connect(function()
                    TweenService:Create(optionBtn, TweenInfo.new(0.2), {BackgroundColor3 = self.Theme.Background, TextColor3 = self.Theme.TextSecondary}):Play()
                end)
            end
        end
        
        dropdownBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                createDropdownList()
                local newHeight = 45 + math.min(#options * 30, 150) + 10
                TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, newHeight)}):Play()
            else
                if dropdownList then
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 45)}):Play()
                    task.delay(0.3, function() if dropdownList then dropdownList:Destroy() end end)
                end
            end
        end)
        
        return dropdownFrame
    end
    
    function tabHandler:Textbox(text, placeholder, callback)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Parent = tabFrame
        textboxFrame.BackgroundColor3 = self.Theme.Surface
        textboxFrame.BackgroundTransparency = 0.5
        textboxFrame.Size = UDim2.new(0.95, 0, 0, 45)
        CreateRoundedCorner(textboxFrame, 8)
        
        local label = Instance.new("TextLabel")
        label.Parent = textboxFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(0.4, -20, 1, 0)
        label.Text = text
        label.TextColor3 = self.Theme.Text
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local textbox = Instance.new("TextBox")
        textbox.Parent = textboxFrame
        textbox.BackgroundColor3 = self.Theme.Background
        textbox.Position = UDim2.new(0.45, 0, 0, 10)
        textbox.Size = UDim2.new(0.5, -25, 0, 25)
        textbox.PlaceholderText = placeholder or "Enter text..."
        textbox.Text = ""
        textbox.TextColor3 = self.Theme.Text
        textbox.PlaceholderColor3 = self.Theme.TextSecondary
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 12
        CreateRoundedCorner(textbox, 6)
        
        textbox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                callback(textbox.Text)
                textbox.Text = ""
            end
        end)
        
        return textboxFrame
    end
    
    function tabHandler:ColorPicker(text, default, callback)
        local pickerFrame = Instance.new("Frame")
        pickerFrame.Parent = tabFrame
        pickerFrame.BackgroundColor3 = self.Theme.Surface
        pickerFrame.BackgroundTransparency = 0.5
        pickerFrame.Size = UDim2.new(0.95, 0, 0, 45)
        CreateRoundedCorner(pickerFrame, 8)
        
        local label = Instance.new("TextLabel")
        label.Parent = pickerFrame
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Size = UDim2.new(0.6, -20, 1, 0)
        label.Text = text
        label.TextColor3 = self.Theme.Text
        label.TextSize = 14
        label.Font = Enum.Font.GothamSemibold
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local colorDisplay = Instance.new("Frame")
        colorDisplay.Parent = pickerFrame
        colorDisplay.Position = UDim2.new(0.65, 0, 0, 10)
        colorDisplay.Size = UDim2.new(0.1, 0, 0, 25)
        colorDisplay.BackgroundColor3 = default or self.Theme.Primary
        CreateRoundedCorner(colorDisplay, 6)
        
        local colorPicker = Instance.new("Frame")
        colorPicker.Parent = pickerFrame
        colorPicker.BackgroundColor3 = self.Theme.Background
        colorPicker.Position = UDim2.new(0.65, 0, 0, 40)
        colorPicker.Size = UDim2.new(0.3, -20, 0, 120)
        colorPicker.Visible = false
        colorPicker.ZIndex = 10
        CreateRoundedCorner(colorPicker, 6)
        
        local hueSlider = Instance.new("Frame")
        hueSlider.Parent = colorPicker
        hueSlider.Position = UDim2.new(0, 10, 0, 10)
        hueSlider.Size = UDim2.new(0, 20, 1, -20)
        hueSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        CreateRoundedCorner(hueSlider, 10)
        
        local satPicker = Instance.new("Frame")
        satPicker.Parent = colorPicker
        satPicker.Position = UDim2.new(0, 40, 0, 10)
        satPicker.Size = UDim2.new(1, -50, 1, -20)
        satPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        
        colorDisplay.MouseButton1Click:Connect(function()
            colorPicker.Visible = not colorPicker.Visible
            if colorPicker.Visible then
                TweenService:Create(pickerFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 180)}):Play()
            else
                TweenService:Create(pickerFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 45)}):Play()
            end
        end)
        
        return pickerFrame
    end
    
    function tabHandler:Label(text, style)
        local label = Instance.new("TextLabel")
        label.Parent = tabFrame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0.95, 0, 0, 30)
        label.Text = text
        label.TextColor3 = style == "title" and self.Theme.Accent or self.Theme.TextSecondary
        label.TextSize = style == "title" and 18 or 12
        label.Font = style == "title" and Enum.Font.GothamBold or Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Center
        
        if style == "separator" then
            label.Size = UDim2.new(0.95, 0, 0, 2)
            label.BackgroundColor3 = self.Theme.Primary
            label.BackgroundTransparency = 0.5
        end
        
        return label
    end
    
    return tabHandler
end

function NebulaWindow:Destroy()
    self.ScreenGui:Destroy()
end

-- ============== NOTIFICATION SYSTEM ==============
function NebulaUI:Notify(title, message, duration, type)
    type = type or "info"
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Parent = game.CoreGui
    notificationFrame.BackgroundColor3 = Settings.Theme.Surface
    notificationFrame.Size = UDim2.new(0, 350, 0, 80)
    notificationFrame.Position = UDim2.new(1, -370, 0, 50)
    notificationFrame.ZIndex = 1000
    CreateRoundedCorner(notificationFrame, 8)
    CreateShadow(notificationFrame)
    
    local titleColor = type == "success" and Settings.Theme.Success or type == "error" and Settings.Theme.Error or Settings.Theme.Primary
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notificationFrame
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 10)
    titleLabel.Size = UDim2.new(1, -30, 0, 25)
    titleLabel.Text = title
    titleLabel.TextColor3 = titleColor
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Parent = notificationFrame
    messageLabel.BackgroundTransparency = 1
    messageLabel.Position = UDim2.new(0, 15, 0, 35)
    messageLabel.Size = UDim2.new(1, -30, 0, 35)
    messageLabel.Text = message
    messageLabel.TextColor3 = Settings.Theme.TextSecondary
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    
    notificationFrame.Position = UDim2.new(1, -350, 0, 50)
    TweenService:Create(notificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -370, 0, 50)
    }):Play()
    
    task.delay(duration or 3, function()
        TweenService:Create(notificationFrame, TweenInfo.new(0.5), {
            Position = UDim2.new(1, -350, 0, 50)
        }):Play()
        task.delay(0.5, function()
            notificationFrame:Destroy()
        end)
    end)
end

-- ============== WATERMARK SYSTEM ==============
function NebulaUI:CreateWatermark(text)
    local watermark = Instance.new("TextLabel")
    watermark.Parent = game.CoreGui
    watermark.BackgroundTransparency = 1
    watermark.Position = UDim2.new(0, 10, 1, -30)
    watermark.Size = UDim2.new(0, 200, 0, 20)
    watermark.Text = text
    watermark.TextColor3 = Settings.Theme.TextSecondary
    watermark.TextSize = 11
    watermark.Font = Enum.Font.Gotham
    watermark.TextXAlignment = Enum.TextXAlignment.Left
    return watermark
end

-- ============== EXPORT ==============
return NebulaUI
