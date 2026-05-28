--[[
    ███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██╗██╗  ██╗
    ██╔════╝██║   ██║██╔══██╗██║████╗  ██║██║╚██╗██╔╝
    █████╗  ██║   ██║██████╔╝██║██╔██╗ ██║██║ ╚███╔╝ 
    ██╔══╝  ██║   ██║██╔══██╗██║██║╚██╗██║██║ ██╔██╗ 
    ██║     ╚██████╔╝██████╔╝██║██║ ╚████║██║██╔╝ ██╗
    ╚═╝      ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
    
    FUBNIK UI FRAMEWORK v5.0
    Professional | Bug-Free | Feature-Rich | Mobile Ready
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
local MarketplaceService = game:GetService("MarketplaceService")
local TeleportService = game:GetService("TeleportService")

-- ============================================================================
-- SMART SCALING SYSTEM
-- ============================================================================
local Scale = {}

function Scale:GetDeviceInfo()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local isMobile = UserInputService.TouchEnabled
    local aspectRatio = screenSize.X / screenSize.Y
    
    if isMobile then
        return {
            device = "Mobile",
            windowWidth = math.min(360, screenSize.X - 20),
            windowHeight = math.min(600, screenSize.Y - 100),
            fontSize = 12,
            buttonHeight = 40,
            spacing = 8,
            padding = 10,
            sidebarWidth = 140
        }
    elseif aspectRatio > 1.6 then
        return {
            device = "Desktop Wide",
            windowWidth = math.min(450, screenSize.X * 0.35),
            windowHeight = math.min(650, screenSize.Y - 100),
            fontSize = 14,
            buttonHeight = 45,
            spacing = 10,
            padding = 12,
            sidebarWidth = 160
        }
    else
        return {
            device = "Desktop",
            windowWidth = math.min(400, screenSize.X * 0.4),
            windowHeight = math.min(600, screenSize.Y - 100),
            fontSize = 13,
            buttonHeight = 42,
            spacing = 8,
            padding = 10,
            sidebarWidth = 150
        }
    end
end

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

function Utility:CreateStroke(frame, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(60, 60, 80)
    stroke.Transparency = transparency or 0
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

function Utility:Tween(obj, props, duration, style)
    local tweenInfo = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

function Utility:Ripple(button, input)
    local x, y
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        x = input.Position.X - button.AbsolutePosition.X
        y = input.Position.Y - button.AbsolutePosition.Y
    else
        x = button.AbsoluteSize.X / 2
        y = button.AbsoluteSize.Y / 2
    end
    
    local ripple = Instance.new("Frame")
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.BorderSizePixel = 0
    Utility:CreateCorner(ripple, 100)
    ripple.ZIndex = 10
    ripple.Parent = button
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Utility:Tween(ripple, {
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(0, x - size/2, 0, y - size/2),
        BackgroundTransparency = 1
    }, 0.5)
    
    task.spawn(function()
        task.wait(0.5)
        if ripple then ripple:Destroy() end
    end)
end

function Utility:FormatTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- ============================================================================
-- LOADING SCREEN
-- ============================================================================
local LoadingScreen = {}

function LoadingScreen:Show(message, duration)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = CoreGui
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Parent = screenGui
    
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Size = UDim2.new(0, 250, 0, 150)
    loadingFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    Utility:CreateCorner(loadingFrame, 12)
    Utility:CreateStroke(loadingFrame, 1, Color3.fromRGB(100, 100, 255), 0.5)
    loadingFrame.Parent = overlay
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 10)
    titleLabel.Text = message or "Loading..."
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = loadingFrame
    
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0, 40, 0, 40)
    spinner.Position = UDim2.new(0.5, -20, 0, 55)
    spinner.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Utility:CreateCorner(spinner, 20)
    spinner.Parent = loadingFrame
    
    -- Animate spinner
    local spinConnection
    spinConnection = RunService.RenderStepped:Connect(function()
        spinner.Rotation = spinner.Rotation + 10
    end)
    
    if duration then
        task.spawn(function()
            task.wait(duration)
            spinConnection:Disconnect()
            screenGui:Destroy()
        end)
    end
    
    return {
        Hide = function()
            spinConnection:Disconnect()
            screenGui:Destroy()
        end
    }
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================
local NotificationManager = {
    container = nil,
    notifications = {},
    maxNotifications = 5
}

function NotificationManager:Init()
    if not self.container then
        self.container = Instance.new("Frame")
        self.container.Name = "FubnikNotifications"
        self.container.Size = UDim2.new(0, 340, 1, -20)
        self.container.Position = UDim2.new(1, -360, 0, 10)
        self.container.BackgroundTransparency = 1
        self.container.ClipsDescendants = true
        self.container.Parent = CoreGui
    end
end

function NotificationManager:Show(options)
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
    
    local icons = {
        info = "ℹ️",
        success = "✅",
        warning = "⚠️",
        error = "❌"
    }
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    frame.BackgroundTransparency = 0.1
    frame.AutomaticSize = Enum.AutomaticSize.Y
    Utility:CreateCorner(frame, 12)
    Utility:CreateStroke(frame, 1, colors[type], 0.5)
    frame.Parent = self.container
    
    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 4, 1, -8)
    accent.Position = UDim2.new(0, 4, 0, 4)
    accent.BackgroundColor3 = colors[type]
    Utility:CreateCorner(accent, 2)
    accent.Parent = frame
    
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 30, 0, 30)
    iconLabel.Position = UDim2.new(0, 12, 0, 12)
    iconLabel.Text = icons[type]
    iconLabel.TextSize = 18
    iconLabel.BackgroundTransparency = 1
    iconLabel.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -55, 0, 25)
    titleLabel.Position = UDim2.new(0, 48, 0, 8)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = frame
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -55, 0, 0)
    msgLabel.Position = UDim2.new(0, 48, 0, 33)
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
    msgLabel.TextSize = 12
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.BackgroundTransparency = 1
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.Parent = frame
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 2)
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.BackgroundColor3 = colors[type]
    progressBar.BackgroundTransparency = 0.5
    progressBar.Parent = frame
    
    -- Animate in
    frame.Size = UDim2.new(1, -10, 0, 0)
    Utility:Tween(frame, {Size = UDim2.new(1, -10, 0, msgLabel.AbsoluteSize.Y + 55)}, 0.3)
    
    -- Progress bar animation
    local progressTween = Utility:Tween(progressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto remove
    task.spawn(function()
        task.wait(duration)
        if frame and frame.Parent then
            Utility:Tween(frame, {Size = UDim2.new(1, -10, 0, 0), Position = UDim2.new(0, 5, 1, 0), BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            frame:Destroy()
        end
    end)
    
    -- Limit notifications
    table.insert(self.notifications, frame)
    while #self.notifications > self.maxNotifications do
        local oldest = table.remove(self.notifications, 1)
        if oldest and oldest.Parent then
            oldest:Destroy()
        end
    end
    
    return frame
end

-- ============================================================================
-- USER INFO DISPLAY
-- ============================================================================
local UserInfo = {}

function UserInfo:CreateDisplay(parent)
    local scale = Scale:GetDeviceInfo()
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 100)
    frame.Position = UDim2.new(0, 10, 0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
    frame.BackgroundTransparency = 0.1
    Utility:CreateCorner(frame, 12)
    Utility:CreateStroke(frame, 1, Color3.fromRGB(100, 100, 150), 0.3)
    frame.Parent = parent
    
    -- Avatar placeholder (circular)
    local avatarCircle = Instance.new("Frame")
    avatarCircle.Size = UDim2.new(0, 60, 0, 60)
    avatarCircle.Position = UDim2.new(0, 12, 0, 20)
    avatarCircle.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
    Utility:CreateCorner(avatarCircle, 30)
    Utility:CreateStroke(avatarCircle, 2, Color3.fromRGB(100, 100, 255), 0)
    avatarCircle.Parent = frame
    
    local avatarText = Instance.new("TextLabel")
    avatarText.Size = UDim2.new(1, 0, 1, 0)
    avatarText.Text = "👤"
    avatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
    avatarText.TextSize = 30
    avatarText.BackgroundTransparency = 1
    avatarText.Parent = avatarCircle
    
    -- Username
    local username = Instance.new("TextLabel")
    username.Size = UDim2.new(1, -90, 0, 25)
    username.Position = UDim2.new(0, 85, 0, 15)
    username.Text = LocalPlayer.Name
    username.TextColor3 = Color3.fromRGB(255, 255, 255)
    username.TextSize = Scale:Font(16)
    username.Font = Enum.Font.GothamBold
    username.TextXAlignment = Enum.TextXAlignment.Left
    username.BackgroundTransparency = 1
    username.Parent = frame
    
    -- Display Name
    local displayName = Instance.new("TextLabel")
    displayName.Size = UDim2.new(1, -90, 0, 20)
    displayName.Position = UDim2.new(0, 85, 0, 40)
    displayName.Text = "@" .. (LocalPlayer.DisplayName or LocalPlayer.Name)
    displayName.TextColor3 = Color3.fromRGB(180, 180, 210)
    displayName.TextSize = Scale:Font(11)
    displayName.Font = Enum.Font.Gotham
    displayName.TextXAlignment = Enum.TextXAlignment.Left
    displayName.BackgroundTransparency = 1
    displayName.Parent = frame
    
    -- User ID
    local userId = Instance.new("TextLabel")
    userId.Size = UDim2.new(1, -90, 0, 18)
    userId.Position = UDim2.new(0, 85, 0, 60)
    userId.Text = "ID: " .. LocalPlayer.UserId
    userId.TextColor3 = Color3.fromRGB(150, 150, 180)
    userId.TextSize = Scale:Font(10)
    userId.Font = Enum.Font.Gotham
    userId.TextXAlignment = Enum.TextXAlignment.Left
    userId.BackgroundTransparency = 1
    userId.Parent = frame
    
    -- Try to load actual avatar
    task.spawn(function()
        local success, thumb = pcall(function()
            return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        end)
        if success and thumb then
            avatarText.Visible = false
            local imageLabel = Instance.new("ImageLabel")
            imageLabel.Size = UDim2.new(1, 0, 1, 0)
            imageLabel.Image = thumb
            imageLabel.BackgroundTransparency = 1
            Utility:CreateCorner(imageLabel, 30)
            imageLabel.Parent = avatarCircle
        end
    end)
    
    return frame
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
    
    local hoverTween = nil
    
    self.Instance.MouseEnter:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = Utility:Tween(self.Instance, {BackgroundColor3 = Color3.fromRGB(50, 50, 80), BackgroundTransparency = 0.05}, 0.15)
    end)
    
    self.Instance.MouseLeave:Connect(function()
        if hoverTween then hoverTween:Cancel() end
        hoverTween = Utility:Tween(self.Instance, {BackgroundColor3 = Color3.fromRGB(30, 30, 50), BackgroundTransparency = 0.1}, 0.15)
    end)
    
    self.Instance.MouseButton1Click:Connect(function(input)
        Utility:Ripple(self.Instance, input)
        self.Callback()
    end)
    
    self.Instance.TouchTap:Connect(function(input)
        Utility:Ripple(self.Instance, input)
        self.Callback()
    end)
    
    return self
end

function Button:SetText(text)
    self.Name = text
    self.Instance.Text = text
end

function Button:SetEnabled(enabled)
    self.Instance.Active = enabled
    self.Instance.Selectable = enabled
    self.Instance.BackgroundTransparency = enabled and 0.1 or 0.6
    self.Instance.TextColor3 = enabled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
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
    
    self.ToggleBtn.TouchTap:Connect(function()
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
    self.Precision = options.Precision or 0
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(1, -20, 0, 75)
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
    sliderBg.Position = UDim2.new(0, 12, 0, 45)
    sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Utility:CreateCorner(sliderBg, 2)
    sliderBg.Parent = self.Instance
    
    self.SliderFill = Instance.new("Frame")
    self.SliderFill.Size = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), 0, 1, 0)
    self.SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Utility:CreateCorner(self.SliderFill, 2)
    self.SliderFill.Parent = sliderBg
    
    self.Knob = Instance.new("Frame")
    self.Knob.Size = UDim2.new(0, 18, 0, 18)
    self.Knob.Position = UDim2.new((self.Value - self.Min) / (self.Max - self.Min), -9, 0.5, -9)
    self.Knob.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    Utility:CreateCorner(self.Knob, 9)
    Utility:CreateStroke(self.Knob, 1, Color3.fromRGB(255, 255, 255), 0.5)
    self.Knob.Parent = sliderBg
    
    local dragging = false
    
    local function formatValue(value)
        if self.Precision > 0 then
            return string.format("%." .. self.Precision .. "f", value)
        end
        return tostring(math.floor(value + 0.5))
    end
    
    local function updateSlider(input)
        local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local newValue = self.Min + (relativeX * (self.Max - self.Min))
        
        if self.Precision > 0 then
            local multiplier = 10 ^ self.Precision
            newValue = math.floor(newValue * multiplier + 0.5) / multiplier
        else
            newValue = math.floor(newValue + 0.5)
        end
        
        self.Value = math.clamp(newValue, self.Min, self.Max)
        self.ValueLabel.Text = formatValue(self.Value)
        
        local percentage = (self.Value - self.Min) / (self.Max - self.Min)
        self.SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        self.Knob.Position = UDim2.new(percentage, -9, 0.5, -9)
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
    
    function self:SetValue(value)
        local clamped = math.clamp(value, self.Min, self.Max)
        if clamped == self.Value then return end
        self.Value = clamped
        self.ValueLabel.Text = formatValue(self.Value)
        local percentage = (self.Value - self.Min) / (self.Max - self.Min)
        self.SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        self.Knob.Position = UDim2.new(percentage, -9, 0.5, -9)
        self.Callback(self.Value)
    end
    
    function self:GetValue()
        return self.Value
    end
    
    return self
end

-- ============================================================================
-- DROPDOWN COMPONENT
-- ============================================================================
local Dropdown = {}
Dropdown.__index = Dropdown

function Dropdown.new(parent, options)
    local self = setmetatable({}, Dropdown)
    self.Name = options.Name or "Dropdown"
    self.Options = options.Options or {}
    self.Value = options.Default or self.Options[1] or ""
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
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = self.Name
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = Scale:Font(13)
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = self.Instance
    
    self.SelectBtn = Instance.new("TextButton")
    self.SelectBtn.Size = UDim2.new(0, 100, 0, 30)
    self.SelectBtn.Position = UDim2.new(1, -110, 0.5, -15)
    self.SelectBtn.Text = self.Value
    self.SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.SelectBtn.TextSize = Scale:Font(12)
    self.SelectBtn.Font = Enum.Font.Gotham
    self.SelectBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    Utility:CreateCorner(self.SelectBtn, 6)
    self.SelectBtn.Parent = self.Instance
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(180, 180, 210)
    arrow.TextSize = 10
    arrow.BackgroundTransparency = 1
    arrow.Parent = self.SelectBtn
    
    self.DropdownList = Instance.new("ScrollingFrame")
    self.DropdownList.Size = UDim2.new(0, 120, 0, 0)
    self.DropdownList.Position = UDim2.new(1, -130, 0, 45)
    self.DropdownList.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    Utility:CreateCorner(self.DropdownList, 6)
    Utility:CreateStroke(self.DropdownList, 1, Color3.fromRGB(100, 100, 150), 0.5)
    self.DropdownList.ScrollBarThickness = 3
    self.DropdownList.Visible = false
    self.DropdownList.ZIndex = 20
    self.DropdownList.Parent = self.Instance
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = self.DropdownList
    
    local listVisible = false
    
    function self:RefreshList()
        for _, child in pairs(self.DropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local height = 0
        for i, opt in ipairs(self.Options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -10, 0, 32)
            optBtn.Position = UDim2.new(0, 5, 0, height)
            optBtn.Text = opt
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
            optBtn.TextSize = Scale:Font(11)
            optBtn.Font = Enum.Font.Gotham
            optBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
            Utility:CreateCorner(optBtn, 4)
            optBtn.Parent = self.DropdownList
            
            optBtn.MouseButton1Click:Connect(function()
                self.Value = opt
                self.SelectBtn.Text = opt
                self.Callback(opt)
                self.DropdownList.Visible = false
                listVisible = false
            end)
            
            optBtn.TouchTap:Connect(function()
                self.Value = opt
                self.SelectBtn.Text = opt
                self.Callback(opt)
                self.DropdownList.Visible = false
                listVisible = false
            end)
            
            height = height + 34
        end
        
        self.DropdownList.CanvasSize = UDim2.new(0, 0, 0, height)
        self.DropdownList.Size = UDim2.new(0, 120, 0, math.min(height, 200))
    end
    
    self.SelectBtn.MouseButton1Click:Connect(function()
        listVisible = not listVisible
        self.DropdownList.Visible = listVisible
        if listVisible then
            self:RefreshList()
        end
    end)
    
    self.SelectBtn.TouchTap:Connect(function()
        listVisible = not listVisible
        self.DropdownList.Visible = listVisible
        if listVisible then
            self:RefreshList()
        end
    end)
    
    function self:SetOptions(options)
        self.Options = options
        if not table.find(self.Options, self.Value) then
            self.Value = self.Options[1] or ""
            self.SelectBtn.Text = self.Value
            self.Callback(self.Value)
        end
        self:RefreshList()
    end
    
    function self:GetValue()
        return self.Value
    end
    
    self:RefreshList()
    
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
    self.Collapsible = options.Collapsible ~= false
    self.Elements = {}
    
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(1, 0, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.AutomaticSize = Enum.AutomaticSize.Y
    self.Container.Parent = parent
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 38)
    header.BackgroundTransparency = 1
    header.Parent = self.Container
    
    local expandIcon = Instance.new("TextLabel")
    expandIcon.Size = UDim2.new(0, 30, 1, 0)
    expandIcon.Position = UDim2.new(0, 5, 0, 0)
    expandIcon.Text = "▾"
    expandIcon.TextColor3 = Color3.fromRGB(100, 100, 255)
    expandIcon.TextSize = 14
    expandIcon.BackgroundTransparency = 1
    expandIcon.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 35, 0, 0)
    title.Text = self.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = Scale:Font(14)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = header
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -10, 0, 1)
    line.Position = UDim2.new(0, 5, 0, 37)
    line.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
    line.BackgroundTransparency = 0.5
    line.Parent = self.Container
    
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, 0, 0, 0)
    self.Content.Position = UDim2.new(0, 0, 0, 42)
    self.Content.BackgroundTransparency = 1
    self.Content.AutomaticSize = Enum.AutomaticSize.Y
    self.Content.Parent = self.Container
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, Scale:GetDeviceInfo().spacing)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = self.Content
    
    local collapsed = false
    local contentHeight = 0
    
    if self.Collapsible then
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                collapsed = not collapsed
                if collapsed then
                    Utility:Tween(self.Content, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    expandIcon.Text = "▸"
                else
                    Utility:Tween(self.Content, {Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)}, 0.2)
                    expandIcon.Text = "▾"
                end
            end
        end)
    end
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentHeight = contentLayout.AbsoluteContentSize.Y
        if not collapsed then
            self.Content.Size = UDim2.new(1, 0, 0, contentHeight)
        end
        self.Container.Size = UDim2.new(1, 0, 0, 42 + contentHeight)
    end)
    
    function self:AddButton(options)
        local btn = Button.new(self.Content, options)
        table.insert(self.Elements, btn)
        return btn
    end
    
    function self:AddToggle(options)
        local toggle = Toggle.new(self.Content, options)
        table.insert(self.Elements, toggle)
        return toggle
    end
    
    function self:AddSlider(options)
        local slider = Slider.new(self.Content, options)
        table.insert(self.Elements, slider)
        return slider
    end
    
    function self:AddDropdown(options)
        local dropdown = Dropdown.new(self.Content, options)
        table.insert(self.Elements, dropdown)
        return dropdown
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
-- TAB COMPONENT (FIXED - No overlapping)
-- ============================================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(parent, sidebar, contentArea, options)
    local self = setmetatable({}, Tab)
    self.Name = options.Name or "Tab"
    self.Icon = options.Icon or ""
    self.Sections = {}
    self.Visible = false
    
    local scale = Scale:GetDeviceInfo()
    
    -- Tab Button in Sidebar
    self.Button = Instance.new("TextButton")
    self.Button.Size = UDim2.new(1, -20, 0, 42)
    self.Button.Position = UDim2.new(0, 10, 0, 0)
    self.Button.Text = self.Icon ~= "" and (self.Icon .. "  " .. self.Name) or self.Name
    self.Button.TextColor3 = Color3.fromRGB(180, 180, 210)
    self.Button.TextSize = Scale:Font(13)
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.BackgroundTransparency = 1
    Utility:CreateCorner(self.Button, 8)
    self.Button.Parent = sidebar
    
    -- Tab Content Container
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.ScrollBarThickness = 3
    self.Container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 255)
    self.Container.Visible = false
    self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Container.Parent = contentArea
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 8)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Parent = self.Container
    
    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab switching logic
    self.Button.MouseButton1Click:Connect(function()
        self:Show()
    end)
    
    self.Button.TouchTap:Connect(function()
        self:Show()
    end)
    
    function self:AddSection(options)
        local section = Section.new(self.Container, options)
        table.insert(self.Sections, section)
        return section
    end
    
    function self:Show()
        -- Hide all other tabs
        for _, child in pairs(contentArea:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        
        -- Hide all other tab buttons
        for _, child in pairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") and child ~= self.Button then
                Utility:Tween(child, {BackgroundColor3 = Color3.fromRGB(0, 0, 0), TextColor3 = Color3.fromRGB(180, 180, 210)}, 0.2)
                child.BackgroundTransparency = 1
            end
        end
        
        -- Show current tab
        self.Container.Visible = true
        Utility:Tween(self.Button, {BackgroundColor3 = Color3.fromRGB(40, 40, 70), TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        self.Button.BackgroundTransparency = 0.1
        self.Visible = true
    end
    
    function self:Hide()
        self.Container.Visible = false
        self.Visible = false
    end
    
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
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
    self.TitleBar.Size = UDim2.new(1, 0, 0, 48)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.MainFrame
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 35, 1, 0)
    logo.Position = UDim2.new(0, 12, 0, 0)
    logo.Text = "⚡"
    logo.TextColor3 = Color3.fromRGB(100, 100, 255)
    logo.TextSize = 22
    logo.BackgroundTransparency = 1
    logo.Parent = self.TitleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 200, 1, 0)
    title.Position = UDim2.new(0, 50, 0, 0)
    title.Text = self.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = Scale:Font(16)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = self.TitleBar
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Size = UDim2.new(0, 38, 0, 38)
    self.CloseBtn.Position = UDim2.new(1, -45, 0, 5)
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 100)
    self.CloseBtn.TextSize = 16
    self.CloseBtn.Font = Enum.Font.Gotham
    self.CloseBtn.BackgroundTransparency = 1
    self.CloseBtn.Parent = self.TitleBar
    
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    self.CloseBtn.TouchTap:Connect(function()
        self:Destroy()
    end)
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, scale.sidebarWidth, 1, -48)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 48)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    self.Sidebar.BackgroundTransparency = 0.3
    self.Sidebar.Parent = self.MainFrame
    
    local sidebarStroke = Utility:CreateStroke(self.Sidebar, 1, Color3.fromRGB(100, 100, 150), 0.3)
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, -10)
    tabList.Position = UDim2.new(0, 0, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = self.Sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabList
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -(scale.sidebarWidth + 10), 1, -58)
    self.ContentArea.Position = UDim2.new(0, scale.sidebarWidth + 5, 0, 53)
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
        local tab = Tab.new(self, tabList, self.ContentArea, options)
        table.insert(self.Tabs, tab)
        
        -- Select first tab automatically
        if #self.Tabs == 1 then
            tab:Show()
        end
        
        return tab
    end
    
    function self:AddUserInfo()
        return UserInfo:CreateDisplay(self.ContentArea)
    end
    
    function self:Notify(options)
        return NotificationManager:Show(options)
    end
    
    function self:ShowLoading(message, duration)
        return LoadingScreen:Show(message, duration)
    end
    
    function self:Destroy()
        self.ScreenGui:Destroy()
    end
    
    function self:SetSize(width, height)
        self.MainFrame.Size = UDim2.new(0, width, 0, height)
        self.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    end
    
    function self:SetTheme(theme)
        -- Theme switching placeholder
        self:Notify({Title = "Theme", Message = "Theme switching coming soon!", Duration = 2})
    end
    
    return self
end

-- ============================================================================
-- INITIALIZE
-- ============================================================================
NotificationManager:Init()

-- Print device info
local deviceInfo = Scale:GetDeviceInfo()
print(string.format("[FUBNIK v5.0] Loaded on %s | Size: %dx%d", deviceInfo.device, deviceInfo.windowWidth, deviceInfo.windowHeight))

-- Return the library
return {
    CreateWindow = function(options) return Fubnik:CreateWindow(options) end,
    Notify = function(options) return NotificationManager:Show(options) end,
    ShowLoading = function(message, duration) return LoadingScreen:Show(message, duration) end,
    Scale = Scale,
    GetDeviceInfo = function() return Scale:GetDeviceInfo() end,
    Version = "5.0.0"
}
