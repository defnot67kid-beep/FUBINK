--[[
    ███████╗██╗   ██╗██████╗ ██╗███╗   ██╗██╗██╗  ██╗
    ██╔════╝██║   ██║██╔══██╗██║████╗  ██║██║╚██╗██╔╝
    █████╗  ██║   ██║██████╔╝██║██╔██╗ ██║██║ ╚███╔╝ 
    ██╔══╝  ██║   ██║██╔══██╗██║██║╚██╗██║██║ ██╔██╗ 
    ██║     ╚██████╔╝██████╔╝██║██║ ╚████║██║██╔╝ ██╗
    ╚═╝      ╚═════╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝
    
    SYNAPSE UI STUDIO - Professional GUI Creator Framework
    Version: 3.0.0
    Type: Roblox LocalScript UI Framework & Visual Editor
    Capabilities: Live UI Editing | Animation System | Monetization | API Integration
    
    This is a COMPLETE professional-grade UI framework for Roblox developers.
    Features include live UI editing, tween animation editor, marketplace integration,
    object serialization, undo/redo system, and advanced component library.
--]]

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local ContextActionService = game:GetService("ContextActionService")

-- ============================================================================
-- UTILITY MODULE
-- ============================================================================
local Utility = {}

function Utility:CreateRoundedCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

function Utility:CreateStroke(instance, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0
    stroke.Parent = instance
    return stroke
end

function Utility:CreateGradient(instance, rotation, colorSequence)
    local gradient = Instance.new("UIGradient")
    gradient.Rotation = rotation or 45
    gradient.Color = colorSequence or ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 50, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 200))
    })
    gradient.Parent = instance
    return gradient
end

function Utility:CreateShadow(instance, size, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = transparency or 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(8, 8, 8, 8)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.ZIndex = instance.ZIndex - 1
    shadow.Parent = instance
    return shadow
end

function Utility:CreateBlur(parent, size)
    local blur = Instance.new("BlurEffect")
    blur.Size = size or 8
    blur.Parent = parent
    return blur
end

function Utility:TweenObject(obj, properties, duration, style, direction, repeatCount, reverses)
    local tweenInfo = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out,
        repeatCount or 0,
        reverses or false
    )
    local tween = TweenService:Create(obj, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utility:DeepCopy(original)
    local copy = {}
    for k, v in pairs(original) do
        if type(v) == "table" then
            copy[k] = Utility:DeepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function Utility:GenerateGUID()
    return HttpService:GenerateGUID(false)
end

-- ============================================================================
-- SIGNAL / EVENT SYSTEM
-- ============================================================================
local Signal = {}
Signal.__index = Signal

function Signal.new()
    local self = setmetatable({}, Signal)
    self._listeners = {}
    return self
end

function Signal:Connect(callback)
    local id = Utility:GenerateGUID()
    self._listeners[id] = callback
    return {
        Disconnect = function()
            self._listeners[id] = nil
        end
    }
end

function Signal:Fire(...)
    for _, callback in pairs(self._listeners) do
        task.spawn(callback, ...)
    end
end

function Signal:Clear()
    self._listeners = {}
end

-- ============================================================================
-- CONNECTION MANAGER (Memory leak prevention)
-- ============================================================================
local ConnectionManager = {
    _connections = {},
    _nextId = 0
}

function ConnectionManager:Add(connection)
    self._nextId = self._nextId + 1
    local id = self._nextId
    self._connections[id] = connection
    return id
end

function ConnectionManager:Remove(id)
    if self._connections[id] then
        self._connections[id]:Disconnect()
        self._connections[id] = nil
    end
end

function ConnectionManager:Cleanup()
    for id, connection in pairs(self._connections) do
        connection:Disconnect()
        self._connections[id] = nil
    end
end

-- ============================================================================
-- UNDO/REDO SYSTEM
-- ============================================================================
local UndoRedoManager = {
    _undoStack = {},
    _redoStack = {},
    _maxSize = 50
}

function UndoRedoManager:Push(action)
    table.insert(self._undoStack, action)
    if #self._undoStack > self._maxSize then
        table.remove(self._undoStack, 1)
    end
    self._redoStack = {}
end

function UndoRedoManager:Undo()
    local action = table.remove(self._undoStack)
    if action then
        action:Undo()
        table.insert(self._redoStack, action)
    end
end

function UndoRedoManager:Redo()
    local action = table.remove(self._redoStack)
    if action then
        action:Redo()
        table.insert(self._undoStack, action)
    end
end

function UndoRedoManager:Clear()
    self._undoStack = {}
    self._redoStack = {}
end

-- ============================================================================
-- THEME MANAGER (Enhanced)
-- ============================================================================
local Theme = {
    Current = "Dark",
    Themes = {
        Dark = {
            Background = Color3.fromRGB(10, 10, 20),
            Surface = Color3.fromRGB(20, 20, 35),
            SurfaceHover = Color3.fromRGB(30, 30, 50),
            SurfaceActive = Color3.fromRGB(40, 40, 65),
            Accent = Color3.fromRGB(100, 100, 255),
            AccentHover = Color3.fromRGB(130, 130, 255),
            AccentActive = Color3.fromRGB(80, 80, 220),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 180, 210),
            TextMuted = Color3.fromRGB(130, 130, 160),
            Border = Color3.fromRGB(50, 50, 70),
            Danger = Color3.fromRGB(255, 80, 100),
            Success = Color3.fromRGB(80, 255, 120),
            Warning = Color3.fromRGB(255, 200, 80),
            Info = Color3.fromRGB(80, 180, 255),
        },
        Light = {
            Background = Color3.fromRGB(245, 245, 255),
            Surface = Color3.fromRGB(255, 255, 255),
            SurfaceHover = Color3.fromRGB(240, 240, 250),
            SurfaceActive = Color3.fromRGB(230, 230, 245),
            Accent = Color3.fromRGB(80, 80, 220),
            AccentHover = Color3.fromRGB(100, 100, 240),
            AccentActive = Color3.fromRGB(60, 60, 200),
            Text = Color3.fromRGB(20, 20, 30),
            TextSecondary = Color3.fromRGB(80, 80, 100),
            TextMuted = Color3.fromRGB(120, 120, 140),
            Border = Color3.fromRGB(200, 200, 220),
            Danger = Color3.fromRGB(220, 60, 80),
            Success = Color3.fromRGB(60, 200, 80),
            Warning = Color3.fromRGB(220, 160, 40),
            Info = Color3.fromRGB(60, 160, 220),
        },
        Neon = {
            Background = Color3.fromRGB(8, 5, 18),
            Surface = Color3.fromRGB(18, 12, 32),
            SurfaceHover = Color3.fromRGB(28, 22, 48),
            SurfaceActive = Color3.fromRGB(38, 32, 62),
            Accent = Color3.fromRGB(0, 255, 200),
            AccentHover = Color3.fromRGB(80, 255, 220),
            AccentActive = Color3.fromRGB(0, 220, 170),
            Text = Color3.fromRGB(255, 255, 255),
            TextSecondary = Color3.fromRGB(180, 200, 255),
            TextMuted = Color3.fromRGB(150, 150, 200),
            Border = Color3.fromRGB(0, 200, 150),
            Danger = Color3.fromRGB(255, 50, 150),
            Success = Color3.fromRGB(50, 255, 100),
            Warning = Color3.fromRGB(255, 200, 50),
            Info = Color3.fromRGB(50, 200, 255),
        },
        Midnight = {
            Background = Color3.fromRGB(5, 5, 15),
            Surface = Color3.fromRGB(12, 12, 28),
            SurfaceHover = Color3.fromRGB(22, 22, 42),
            SurfaceActive = Color3.fromRGB(32, 32, 56),
            Accent = Color3.fromRGB(150, 50, 200),
            AccentHover = Color3.fromRGB(170, 80, 220),
            AccentActive = Color3.fromRGB(130, 40, 180),
            Text = Color3.fromRGB(230, 230, 255),
            TextSecondary = Color3.fromRGB(170, 170, 210),
            TextMuted = Color3.fromRGB(120, 120, 160),
            Border = Color3.fromRGB(40, 30, 60),
            Danger = Color3.fromRGB(220, 60, 120),
            Success = Color3.fromRGB(100, 220, 140),
            Warning = Color3.fromRGB(240, 180, 60),
            Info = Color3.fromRGB(100, 160, 240),
        }
    },
    _listeners = {}
}

function Theme:Get()
    return self.Themes[self.Current]
end

function Theme:Set(themeName)
    if self.Themes[themeName] then
        self.Current = themeName
        for _, callback in pairs(self._listeners) do
            callback(self.Current, self:Get())
        end
        return true
    end
    return false
end

function Theme:OnChange(callback)
    local id = Utility:GenerateGUID()
    self._listeners[id] = callback
    return {
        Disconnect = function()
            self._listeners[id] = nil
        end
    }
end

-- ============================================================================
-- NOTIFICATION SYSTEM (Enhanced)
-- ============================================================================
local NotificationManager = {
    Notifications = {},
    Container = nil,
    _id = 0,
    MaxNotifications = 8
}

function NotificationManager:Init(parent)
    if not self.Container then
        self.Container = Instance.new("Frame")
        self.Container.Name = "NotificationContainer"
        self.Container.Size = UDim2.new(0, 350, 1, -20)
        self.Container.Position = UDim2.new(1, -370, 0, 10)
        self.Container.BackgroundTransparency = 1
        self.Container.ClipsDescendants = true
        self.Container.Parent = parent or CoreGui
    end
end

function NotificationManager:Notify(options)
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 3.5
    local type = options.Type or "info"
    local icon = options.Icon or nil
    
    local typeColors = {
        info = Theme:Get().Info,
        success = Theme:Get().Success,
        warning = Theme:Get().Warning,
        error = Theme:Get().Danger
    }
    
    self._id = self._id + 1
    local notificationId = self._id
    
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification_" .. notificationId
    notificationFrame.Size = UDim2.new(1, -10, 0, 0)
    notificationFrame.Position = UDim2.new(0, 5, 1, -10)
    notificationFrame.BackgroundColor3 = Theme:Get().Surface
    notificationFrame.BackgroundTransparency = 0.05
    notificationFrame.AutomaticSize = Enum.AutomaticSize.Y
    Utility:CreateRoundedCorner(notificationFrame, 12)
    Utility:CreateStroke(notificationFrame, 1, typeColors[type], 0.4)
    Utility:CreateShadow(notificationFrame, 8, 0.5)
    notificationFrame.Parent = self.Container
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = typeColors[type]
    progressBar.BackgroundTransparency = 0.3
    progressBar.Parent = notificationFrame
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, -8)
    accentBar.Position = UDim2.new(0, 4, 0, 4)
    accentBar.BackgroundColor3 = typeColors[type]
    Utility:CreateRoundedCorner(accentBar, 2)
    accentBar.Parent = notificationFrame
    
    local iconLabel = nil
    if icon then
        iconLabel = Instance.new("ImageLabel")
        iconLabel.Size = UDim2.new(0, 24, 0, 24)
        iconLabel.Position = UDim2.new(0, 16, 0, 12)
        iconLabel.Image = icon
        iconLabel.BackgroundTransparency = 1
        iconLabel.Parent = notificationFrame
    end
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, (icon and -60 or -50), 0, 25)
    titleLabel.Position = UDim2.new(0, (icon and 50 or 20), 0, 8)
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme:Get().Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = notificationFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, (icon and -60 or -50), 0, 0)
    messageLabel.Position = UDim2.new(0, (icon and 50 or 20), 0, 33)
    messageLabel.Text = message
    messageLabel.TextColor3 = Theme:Get().TextSecondary
    messageLabel.TextSize = 12
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.BackgroundTransparency = 1
    messageLabel.AutomaticSize = Enum.AutomaticSize.Y
    messageLabel.Parent = notificationFrame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -34, 0, 6)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme:Get().TextMuted
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = notificationFrame
    
    closeBtn.MouseButton1Click:Connect(function()
        self:RemoveNotification(notificationFrame)
    end)
    
    -- Animate in
    notificationFrame.Size = UDim2.new(1, -10, 0, 0)
    notificationFrame.Position = UDim2.new(0, 5, 1, -10)
    Utility:TweenObject(notificationFrame, {Size = UDim2.new(1, -10, 0, messageLabel.AbsoluteSize.y + 55)}, 0.3)
    
    -- Animate progress bar
    local progressTween = Utility:TweenObject(progressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration, Enum.EasingStyle.Linear)
    
    -- Auto remove
    task.spawn(function()
        task.wait(duration)
        if notificationFrame and notificationFrame.Parent then
            self:RemoveNotification(notificationFrame)
        end
    end)
    
    table.insert(self.Notifications, notificationFrame)
    
    while #self.Notifications > self.MaxNotifications do
        local oldest = table.remove(self.Notifications, 1)
        self:RemoveNotification(oldest)
    end
    
    return notificationId
end

function NotificationManager:RemoveNotification(frame)
    if not frame or not frame.Parent then return end
    Utility:TweenObject(frame, {
        Size = UDim2.new(1, -10, 0, 0),
        Position = UDim2.new(0, 5, 1, 0),
        BackgroundTransparency = 1
    }, 0.2)
    task.wait(0.2)
    frame:Destroy()
    for i, notif in ipairs(self.Notifications) do
        if notif == frame then
            table.remove(self.Notifications, i)
            break
        end
    end
end

-- ============================================================================
-- CONFIG MANAGER (Enhanced)
-- ============================================================================
local ConfigManager = {
    Data = {},
    AutoSave = true,
    FileName = "SynapseUIStudio_Config",
    _saveDebounce = nil
}

function ConfigManager:Load()
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(self.FileName .. ".json"))
    end)
    if success and type(data) == "table" then
        self.Data = data
    end
    return self.Data
end

function ConfigManager:Save()
    if not self.AutoSave then return end
    if self._saveDebounce then
        self._saveDebounce:Disconnect()
    end
    self._saveDebounce = task.delay(0.5, function()
        pcall(function()
            writefile(self.FileName .. ".json", HttpService:JSONEncode(self.Data))
        end)
    end)
end

function ConfigManager:Set(key, value)
    self.Data[key] = value
    self:Save()
end

function ConfigManager:Get(key, defaultValue)
    local val = self.Data[key]
    if val == nil then
        return defaultValue
    end
    return val
end

function ConfigManager:Export()
    return HttpService:JSONEncode(self.Data)
end

function ConfigManager:Import(jsonData)
    local success, data = pcall(function()
        return HttpService:JSONDecode(jsonData)
    end)
    if success and type(data) == "table" then
        self.Data = data
        self:Save()
        return true
    end
    return false
end

-- ============================================================================
-- OBJECT SERIALIZATION
-- ============================================================================
local ObjectSerializer = {}

function ObjectSerializer:SerializeGuiObject(instance)
    local data = {
        ClassName = instance.ClassName,
        Name = instance.Name,
        Properties = {},
        Children = {}
    }
    
    local serializableProps = {
        "Size", "Position", "AnchorPoint", "BackgroundColor3", "BackgroundTransparency",
        "BorderSizePixel", "BorderColor3", "Text", "TextColor3", "TextSize", "TextXAlignment",
        "TextYAlignment", "Font", "Image", "ImageColor3", "ImageTransparency", "Visible",
        "Rotation", "ZIndex", "ClipsDescendants", "Active", "Selectable"
    }
    
    for _, prop in ipairs(serializableProps) do
        local success, value = pcall(function()
            return instance[prop]
        end)
        if success and value ~= nil then
            data.Properties[prop] = value
        end
    end
    
    for _, child in ipairs(instance:GetChildren()) do
        if child:IsA("GuiObject") then
            table.insert(data.Children, self:SerializeGuiObject(child))
        end
    end
    
    return data
end

function ObjectSerializer:DeserializeGuiObject(data, parent)
    local instance = Instance.new(data.ClassName)
    instance.Name = data.Name
    
    for prop, value in pairs(data.Properties) do
        pcall(function()
            instance[prop] = value
        end)
    end
    
    instance.Parent = parent
    
    for _, childData in ipairs(data.Children) do
        self:DeserializeGuiObject(childData, instance)
    end
    
    return instance
end

-- ============================================================================
-- TWEEN PRESETS
-- ============================================================================
local TweenPresets = {
    FadeIn = {
        properties = {BackgroundTransparency = 0},
        duration = 0.3,
        style = Enum.EasingStyle.Quad
    },
    FadeOut = {
        properties = {BackgroundTransparency = 1},
        duration = 0.3,
        style = Enum.EasingStyle.Quad
    },
    ScaleIn = {
        properties = {Size = UDim2.new(1, 0, 1, 0)},
        duration = 0.25,
        style = Enum.EasingStyle.Elastic
    },
    ScaleOut = {
        properties = {Size = UDim2.new(0, 0, 0, 0)},
        duration = 0.25,
        style = Enum.EasingStyle.Quad
    },
    SlideUp = {
        properties = {Position = UDim2.new(0.5, 0, 0, 0)},
        duration = 0.3,
        style = Enum.EasingStyle.Quad
    },
    SlideDown = {
        properties = {Position = UDim2.new(0.5, 0, 1, 0)},
        duration = 0.3,
        style = Enum.EasingStyle.Quad
    },
    Bounce = {
        properties = {Position = UDim2.new(0.5, 0, 0.5, -20)},
        duration = 0.4,
        style = Enum.EasingStyle.Elastic
    },
    Pulse = {
        properties = {Size = UDim2.new(1.05, 0, 1.05, 0)},
        duration = 0.15,
        style = Enum.EasingStyle.Quad,
        repeatCount = 1,
        reverses = true
    },
    Glow = {
        properties = {ImageTransparency = 0.2},
        duration = 0.5,
        style = Enum.EasingStyle.Sine,
        repeatCount = -1,
        reverses = true
    },
    Shake = {
        properties = {Position = UDim2.new(0.5, math.random(-5, 5), 0.5, math.random(-5, 5))},
        duration = 0.05,
        style = Enum.EasingStyle.Linear,
        repeatCount = 5
    }
}

-- ============================================================================
-- RESIZE HANDLE
-- ============================================================================
local ResizeHandle = {}
ResizeHandle.__index = ResizeHandle

function ResizeHandle.new(target, direction)
    local self = setmetatable({}, ResizeHandle)
    self.Target = target
    self.Direction = direction
    self.Active = false
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(0, 8, 0, 8)
    self.Instance.BackgroundColor3 = Theme:Get().Accent
    self.Instance.BackgroundTransparency = 0.5
    Utility:CreateRoundedCorner(self.Instance, 4)
    Utility:CreateStroke(self.Instance, 1, Theme:Get().Accent, 0)
    self.Instance.Parent = target
    
    self:UpdatePosition()
    
    local dragging = false
    local startPos, startSize, startMouse
    
    self.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startPos = target.Position
            startSize = target.Size
            startMouse = input.Position
            self.Active = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - startMouse
            local newSize = startSize
            local newPos = startPos
            
            if direction == "top-left" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset - delta.X, startSize.Y.Scale, startSize.Y.Offset - delta.Y)
                newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif direction == "top" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset, startSize.Y.Scale, startSize.Y.Offset - delta.Y)
                newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif direction == "top-right" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset + delta.X, startSize.Y.Scale, startSize.Y.Offset - delta.Y)
                newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            elseif direction == "left" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset - delta.X, startSize.Y.Scale, startSize.Y.Offset)
                newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset)
            elseif direction == "right" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset + delta.X, startSize.Y.Scale, startSize.Y.Offset)
            elseif direction == "bottom-left" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset - delta.X, startSize.Y.Scale, startSize.Y.Offset + delta.Y)
                newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset)
            elseif direction == "bottom" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset, startSize.Y.Scale, startSize.Y.Offset + delta.Y)
            elseif direction == "bottom-right" then
                newSize = UDim2.new(startSize.X.Scale, startSize.X.Offset + delta.X, startSize.Y.Scale, startSize.Y.Offset + delta.Y)
            end
            
            -- Clamp minimum size
            newSize = UDim2.new(newSize.X.Scale, math.max(50, newSize.X.Offset), newSize.Y.Scale, math.max(50, newSize.Y.Offset))
            
            target.Size = newSize
            target.Position = newPos
            self:UpdatePosition()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            self.Active = false
        end
    end)
    
    return self
end

function ResizeHandle:UpdatePosition()
    local x = 0
    local y = 0
    local anchorX = 0
    local anchorY = 0
    
    if string.find(self.Direction, "left") then
        x = -4
        anchorX = 0
    elseif string.find(self.Direction, "right") then
        x = 1
        anchorX = 1
    else
        x = 0.5
        anchorX = 0.5
    end
    
    if string.find(self.Direction, "top") then
        y = -4
        anchorY = 0
    elseif string.find(self.Direction, "bottom") then
        y = 1
        anchorY = 1
    else
        y = 0.5
        anchorY = 0.5
    end
    
    self.Instance.Position = UDim2.new(x, 0, y, 0)
    self.Instance.AnchorPoint = Vector2.new(anchorX, anchorY)
end

function ResizeHandle:Destroy()
    self.Instance:Destroy()
end

-- ============================================================================
-- ROTATION HANDLE
-- ============================================================================
local RotationHandle = {}
RotationHandle.__index = RotationHandle

function RotationHandle.new(target)
    local self = setmetatable({}, RotationHandle)
    self.Target = target
    self.Active = false
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(0, 20, 0, 20)
    self.Instance.Position = UDim2.new(0.5, -10, 0, -30)
    self.Instance.BackgroundColor3 = Theme:Get().Accent
    Utility:CreateRoundedCorner(self.Instance, 10)
    Utility:CreateStroke(self.Instance, 1, Color3.fromRGB(255, 255, 255), 0.5)
    self.Instance.Parent = target
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.Text = "↻"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 12
    icon.Font = Enum.Font.GothamBold
    icon.BackgroundTransparency = 1
    icon.Parent = self.Instance
    
    local dragging = false
    local startRotation, startMouse, center
    
    self.Instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            startRotation = target.Rotation
            center = target.AbsolutePosition + Vector2.new(target.AbsoluteSize.X / 2, target.AbsoluteSize.Y / 2)
            startMouse = input.Position
            self.Active = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local angle = math.atan2(input.Position.Y - center.Y, input.Position.X - center.X)
            local startAngle = math.atan2(startMouse.Y - center.Y, startMouse.X - center.X)
            local deltaAngle = math.deg(angle - startAngle)
            target.Rotation = startRotation + deltaAngle
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
            self.Active = false
        end
    end)
    
    return self
end

function RotationHandle:Destroy()
    self.Instance:Destroy()
end

-- ============================================================================
-- LIVE UI EDITOR
-- ============================================================================
local UIEditor = {}
UIEditor.__index = UIEditor

function UIEditor.new(targetContainer)
    local self = setmetatable({}, UIEditor)
    self.Target = targetContainer
    self.SelectedObject = nil
    self.ResizeHandles = {}
    self.RotationHandle = nil
    self.EditingEnabled = false
    self.SnapToGrid = false
    self.GridSize = 10
    
    self.EditorOverlay = Instance.new("Frame")
    self.EditorOverlay.Size = UDim2.new(1, 0, 1, 0)
    self.EditorOverlay.BackgroundTransparency = 1
    self.EditorOverlay.Parent = targetContainer
    
    self.SelectionOutline = Instance.new("Frame")
    self.SelectionOutline.Size = UDim2.new(0, 0, 0, 0)
    self.SelectionOutline.Position = UDim2.new(0, 0, 0, 0)
    self.SelectionOutline.BackgroundTransparency = 1
    self.SelectionOutline.BorderSizePixel = 2
    self.SelectionOutline.BorderColor3 = Theme:Get().Accent
    self.SelectionOutline.Visible = false
    self.SelectionOutline.ZIndex = 999
    self.SelectionOutline.Parent = self.EditorOverlay
    
    function self:SelectObject(obj)
        if self.SelectedObject then
            self:ClearSelection()
        end
        
        self.SelectedObject = obj
        
        -- Create resize handles
        local directions = {"top-left", "top", "top-right", "left", "right", "bottom-left", "bottom", "bottom-right"}
        for _, dir in ipairs(directions) do
            table.insert(self.ResizeHandles, ResizeHandle.new(obj, dir))
        end
        
        self.RotationHandle = RotationHandle.new(obj)
        
        self.SelectionOutline.Size = obj.Size
        self.SelectionOutline.Position = obj.Position
        self.SelectionOutline.Visible = true
        
        -- Update outline position on object change
        self._connection = obj:GetPropertyChangedSignal("Position"):Connect(function()
            self.SelectionOutline.Position = obj.Position
        end)
        self._sizeConnection = obj:GetPropertyChangedSignal("Size"):Connect(function()
            self.SelectionOutline.Size = obj.Size
        end)
    end
    
    function self:ClearSelection()
        if self.SelectedObject then
            for _, handle in ipairs(self.ResizeHandles) do
                handle:Destroy()
            end
            self.ResizeHandles = {}
            if self.RotationHandle then
                self.RotationHandle:Destroy()
                self.RotationHandle = nil
            end
            if self._connection then
                self._connection:Disconnect()
            end
            if self._sizeConnection then
                self._sizeConnection:Disconnect()
            end
            self.SelectedObject = nil
            self.SelectionOutline.Visible = false
        end
    end
    
    function self:EnableEditing()
        self.EditingEnabled = true
        -- Enable dragging for all GUI objects in target
    end
    
    function self:DisableEditing()
        self.EditingEnabled = false
        self:ClearSelection()
    end
    
    function self:SetSnapToGrid(enabled, gridSize)
        self.SnapToGrid = enabled
        if gridSize then
            self.GridSize = gridSize
        end
    end
    
    return self
end

-- ============================================================================
-- ADVANCED BUTTON COMPONENT
-- ============================================================================
local AdvancedButton = {}
AdvancedButton.__index = AdvancedButton

function AdvancedButton.new(parent, options)
    local self = setmetatable({}, AdvancedButton)
    self.Name = options.Name or "Button"
    self.Callback = options.Callback or function() end
    self.HoverAnimation = options.HoverAnimation or "scale"
    self.ClickAnimation = options.ClickAnimation or "ripple"
    self.Icon = options.Icon
    
    self.Instance = Instance.new("TextButton")
    self.Instance.Size = options.Size or UDim2.new(0, 150, 0, 40)
    self.Instance.Position = options.Position or UDim2.new(0, 0, 0, 0)
    self.Instance.Text = self.Name
    self.Instance.TextColor3 = Theme:Get().Text
    self.Instance.TextSize = options.TextSize or 14
    self.Instance.Font = Enum.Font.GothamSemibold
    self.Instance.BackgroundColor3 = Theme:Get().Surface
    self.Instance.BackgroundTransparency = 0.05
    Utility:CreateRoundedCorner(self.Instance, 8)
    Utility:CreateStroke(self.Instance, 1, Theme:Get().Border, 0.3)
    self.Instance.Parent = parent
    
    if self.Icon then
        local iconLabel = Instance.new("ImageLabel")
        iconLabel.Size = UDim2.new(0, 20, 0, 20)
        iconLabel.Position = UDim2.new(0, 12, 0.5, -10)
        iconLabel.Image = self.Icon
        iconLabel.BackgroundTransparency = 1
        iconLabel.Parent = self.Instance
        self.Instance.Text = "  " .. self.Name
    end
    
    -- Hover animations
    self.Instance.MouseEnter:Connect(function()
        if self.HoverAnimation == "scale" then
            Utility:TweenObject(self.Instance, {Size = UDim2.new(0, 155, 0, 45)}, 0.1)
        elseif self.HoverAnimation == "glow" then
            Utility:TweenObject(self.Instance, {BackgroundColor3 = Theme:Get().Accent}, 0.2)
            self.Instance.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif self.HoverAnimation == "slide" then
            Utility:TweenObject(self.Instance, {Position = UDim2.new(0, 5, 0, 0)}, 0.1)
        end
    end)
    
    self.Instance.MouseLeave:Connect(function()
        if self.HoverAnimation == "scale" then
            Utility:TweenObject(self.Instance, {Size = options.Size or UDim2.new(0, 150, 0, 40)}, 0.1)
        elseif self.HoverAnimation == "glow" then
            Utility:TweenObject(self.Instance, {BackgroundColor3 = Theme:Get().Surface}, 0.2)
            self.Instance.TextColor3 = Theme:Get().Text
        elseif self.HoverAnimation == "slide" then
            Utility:TweenObject(self.Instance, {Position = options.Position or UDim2.new(0, 0, 0, 0)}, 0.1)
        end
    end)
    
    self.Instance.MouseButton1Click:Connect(function(x, y)
        if self.ClickAnimation == "ripple" then
            local clickPos = Vector2.new(x.X - self.Instance.AbsolutePosition.X, x.Y - self.Instance.AbsolutePosition.Y)
            Utility:CreateRippleEffect(self.Instance, clickPos)
        elseif self.ClickAnimation == "pulse" then
            Utility:TweenObject(self.Instance, {Size = UDim2.new(0, 140, 0, 35)}, 0.05)
            task.wait(0.05)
            Utility:TweenObject(self.Instance, {Size = options.Size or UDim2.new(0, 150, 0, 40)}, 0.05)
        end
        self.Callback()
    end)
    
    return self
end

function AdvancedButton:SetText(text)
    self.Name = text
    self.Instance.Text = self.Icon and "  " .. text or text
end

function AdvancedButton:SetEnabled(enabled)
    self.Instance.Active = enabled
    self.Instance.Selectable = enabled
    self.Instance.BackgroundTransparency = enabled and 0.05 or 0.6
end

-- ============================================================================
-- ADVANCED TOGGLE COMPONENT
-- ============================================================================
local AdvancedToggle = {}
AdvancedToggle.__index = AdvancedToggle

function AdvancedToggle.new(parent, options)
    local self = setmetatable({}, AdvancedToggle)
    self.Name = options.Name or "Toggle"
    self.Value = options.Default or false
    self.Callback = options.Callback or function() end
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(1, -20, 0, 40)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.BackgroundColor3 = Theme:Get().Surface
    self.Instance.BackgroundTransparency = 0.05
    Utility:CreateRoundedCorner(self.Instance, 8)
    Utility:CreateStroke(self.Instance, 1, Theme:Get().Border, 0.3)
    self.Instance.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Text = self.Name
    label.TextColor3 = Theme:Get().Text
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = self.Instance
    
    self.ToggleBtn = Instance.new("TextButton")
    self.ToggleBtn.Size = UDim2.new(0, 50, 0, 26)
    self.ToggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
    self.ToggleBtn.Text = ""
    self.ToggleBtn.BackgroundColor3 = self.Value and Theme:Get().Accent or Theme:Get().TextMuted
    Utility:CreateRoundedCorner(self.ToggleBtn, 13)
    self.ToggleBtn.Parent = self.Instance
    
    self.Knob = Instance.new("Frame")
    self.Knob.Size = UDim2.new(0, 22, 0, 22)
    self.Knob.Position = UDim2.new(0, self.Value and 26 or 2, 0.5, -11)
    self.Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Utility:CreateRoundedCorner(self.Knob, 11)
    self.Knob.Parent = self.ToggleBtn
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = parent
    
    self.ToggleBtn.MouseButton1Click:Connect(function()
        self:SetValue(not self.Value)
    end)
    
    return self
end

function AdvancedToggle:SetValue(value)
    if self.Value == value then return end
    self.Value = value
    Utility:TweenObject(self.ToggleBtn, {BackgroundColor3 = self.Value and Theme:Get().Accent or Theme:Get().TextMuted}, 0.2)
    Utility:TweenObject(self.Knob, {Position = UDim2.new(0, self.Value and 26 or 2, 0.5, -11)}, 0.2)
    self.Callback(self.Value)
end

function AdvancedToggle:GetValue()
    return self.Value
end

-- ============================================================================
-- COLOR PICKER COMPONENT
-- ============================================================================
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.new(parent, options)
    local self = setmetatable({}, ColorPicker)
    self.Name = options.Name or "Color"
    self.Value = options.Default or Color3.fromRGB(255, 255, 255)
    self.Callback = options.Callback or function() end
    
    self.Instance = Instance.new("Frame")
    self.Instance.Size = UDim2.new(1, -20, 0, 50)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.BackgroundColor3 = Theme:Get().Surface
    self.Instance.BackgroundTransparency = 0.05
    Utility:CreateRoundedCorner(self.Instance, 8)
    Utility:CreateStroke(self.Instance, 1, Theme:Get().Border, 0.3)
    self.Instance.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -80, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 5)
    label.Text = self.Name
    label.TextColor3 = Theme:Get().Text
    label.TextSize = 13
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1
    label.Parent = self.Instance
    
    self.ColorDisplay = Instance.new("Frame")
    self.ColorDisplay.Size = UDim2.new(0, 60, 0, 30)
    self.ColorDisplay.Position = UDim2.new(1, -72, 0.5, -15)
    self.ColorDisplay.BackgroundColor3 = self.Value
    Utility:CreateRoundedCorner(self.ColorDisplay, 6)
    Utility:CreateStroke(self.ColorDisplay, 1, Theme:Get().Border, 0.5)
    self.ColorDisplay.Parent = self.Instance
    
    local hexLabel = Instance.new("TextLabel")
    hexLabel.Size = UDim2.new(0, 80, 0, 20)
    hexLabel.Position = UDim2.new(0, 12, 0, 28)
    hexLabel.Text = string.format("#%02X%02X%02X", self.Value.R * 255, self.Value.G * 255, self.Value.B * 255)
    hexLabel.TextColor3 = Theme:Get().TextSecondary
    hexLabel.TextSize = 10
    hexLabel.Font = Enum.Font.Gotham
    hexLabel.TextXAlignment = Enum.TextXAlignment.Left
    hexLabel.BackgroundTransparency = 1
    hexLabel.Parent = self.Instance
    
    -- Simple color presets
    local presetContainer = Instance.new("Frame")
    presetContainer.Size = UDim2.new(1, -80, 0, 30)
    presetContainer.Position = UDim2.new(0, 12, 0, 50)
    presetContainer.BackgroundTransparency = 1
    presetContainer.Parent = self.Instance
    
    local presets = {
        Color3.fromRGB(255, 80, 100), Color3.fromRGB(80, 255, 100), Color3.fromRGB(80, 100, 255),
        Color3.fromRGB(255, 200, 80), Color3.fromRGB(200, 80, 255), Color3.fromRGB(80, 255, 200),
        Color3.fromRGB(255, 255, 255), Color3.fromRGB(0, 0, 0)
    }
    
    for i, color in ipairs(presets) do
        local presetBtn = Instance.new("TextButton")
        presetBtn.Size = UDim2.new(0, 28, 0, 28)
        presetBtn.Position = UDim2.new((i-1) * 0.125, 2, 0, 0)
        presetBtn.BackgroundColor3 = color
        Utility:CreateRoundedCorner(presetBtn, 14)
        presetBtn.Parent = presetContainer
        
        presetBtn.MouseButton1Click:Connect(function()
            self:SetValue(color)
        end)
    end
    
    self.Instance.Size = UDim2.new(1, -20, 0, 90)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = parent
    
    return self
end

function ColorPicker:SetValue(color)
    self.Value = color
    self.ColorDisplay.BackgroundColor3 = color
    local hexLabel = self.Instance:FindFirstChild("TextLabel")
    if hexLabel then
        hexLabel.Text = string.format("#%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255)
    end
    self.Callback(color)
end

function ColorPicker:GetValue()
    return self.Value
end

-- ============================================================================
-- GAMEPASS BUTTON COMPONENT
-- ============================================================================
local GamepassButton = {}
GamepassButton.__index = GamepassButton

function GamepassButton.new(parent, options)
    local self = setmetatable({}, GamepassButton)
    self.GamepassId = options.GamepassId
    self.Name = options.Name or "Purchase Gamepass"
    self.Price = options.Price or "???"
    self.Callback = options.Callback or function() end
    
    self.Instance = Instance.new("TextButton")
    self.Instance.Size = UDim2.new(1, -20, 0, 55)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.Text = ""
    self.Instance.BackgroundColor3 = Theme:Get().Surface
    self.Instance.BackgroundTransparency = 0.05
    Utility:CreateRoundedCorner(self.Instance, 10)
    Utility:CreateStroke(self.Instance, 1, Theme:Get().Accent, 0.3)
    self.Instance.Parent = parent
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 12, 0, 0)
    icon.Text = "🛒"
    icon.TextColor3 = Theme:Get().Accent
    icon.TextSize = 20
    icon.BackgroundTransparency = 1
    icon.Parent = self.Instance
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 0, 22)
    titleLabel.Position = UDim2.new(0, 55, 0, 8)
    titleLabel.Text = self.Name
    titleLabel.TextColor3 = Theme:Get().Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = self.Instance
    
    local priceLabel = Instance.new("TextLabel")
    priceLabel.Size = UDim2.new(1, -100, 0, 18)
    priceLabel.Position = UDim2.new(0, 55, 0, 30)
    priceLabel.Text = self.Price .. " Robux"
    priceLabel.TextColor3 = Theme:Get().TextSecondary
    priceLabel.TextSize = 11
    priceLabel.Font = Enum.Font.Gotham
    priceLabel.TextXAlignment = Enum.TextXAlignment.Left
    priceLabel.BackgroundTransparency = 1
    priceLabel.Parent = self.Instance
    
    local purchaseIcon = Instance.new("TextLabel")
    purchaseIcon.Size = UDim2.new(0, 30, 1, 0)
    purchaseIcon.Position = UDim2.new(1, -42, 0, 0)
    purchaseIcon.Text = "→"
    purchaseIcon.TextColor3 = Theme:Get().Accent
    purchaseIcon.TextSize = 18
    purchaseIcon.BackgroundTransparency = 1
    purchaseIcon.Parent = self.Instance
    
    self.Instance.MouseButton1Click:Connect(function()
        if self.GamepassId then
            MarketplaceService:PromptGamePassPurchase(LocalPlayer, self.GamepassId)
        end
        self.Callback()
    end)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = parent
    
    return self
end

-- ============================================================================
-- DEVELOPER PRODUCT BUTTON
-- ============================================================================
local DeveloperProductButton = {}
DeveloperProductButton.__index = DeveloperProductButton

function DeveloperProductButton.new(parent, options)
    local self = setmetatable({}, DeveloperProductButton)
    self.ProductId = options.ProductId
    self.Name = options.Name or "Purchase Item"
    self.Price = options.Price or "???"
    self.Callback = options.Callback or function() end
    
    self.Instance = Instance.new("TextButton")
    self.Instance.Size = UDim2.new(1, -20, 0, 55)
    self.Instance.Position = UDim2.new(0, 10, 0, 0)
    self.Instance.Text = ""
    self.Instance.BackgroundColor3 = Theme:Get().Surface
    self.Instance.BackgroundTransparency = 0.05
    Utility:CreateRoundedCorner(self.Instance, 10)
    Utility:CreateStroke(self.Instance, 1, Theme:Get().Success, 0.3)
    self.Instance.Parent = parent
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 12, 0, 0)
    icon.Text = "💰"
    icon.TextColor3 = Theme:Get().Success
    icon.TextSize = 20
    icon.BackgroundTransparency = 1
    icon.Parent = self.Instance
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -100, 0, 22)
    titleLabel.Position = UDim2.new(0, 55, 0, 8)
    titleLabel.Text = self.Name
    titleLabel.TextColor3 = Theme:Get().Text
    titleLabel.TextSize = 14
    titleLabel.Font = Enum.Font.GothamSemibold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1
    titleLabel.Parent = self.Instance
    
    local priceLabel = Instance.new("TextLabel")
    priceLabel.Size = UDim2.new(1, -100, 0, 18)
    priceLabel.Position = UDim2.new(0, 55, 0, 30)
    priceLabel.Text = self.Price .. " Robux"
    priceLabel.TextColor3 = Theme:Get().TextSecondary
    priceLabel.TextSize = 11
    priceLabel.Font = Enum.Font.Gotham
    priceLabel.TextXAlignment = Enum.TextXAlignment.Left
    priceLabel.BackgroundTransparency = 1
    priceLabel.Parent = self.Instance
    
    self.Instance.MouseButton1Click:Connect(function()
        if self.ProductId then
            MarketplaceService:PromptProductPurchase(LocalPlayer, self.ProductId)
        end
        self.Callback()
    end)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = parent
    
    return self
end

-- ============================================================================
-- ANIMATION PREVIEW
-- ============================================================================
local AnimationPreview = {}
AnimationPreview.__index = AnimationPreview

function AnimationPreview.new(target)
    local self = setmetatable({}, AnimationPreview)
    self.Target = target
    self.CurrentAnimation = nil
    
    function self:PlayPreset(presetName)
        local preset = TweenPresets[presetName]
        if preset then
            self.CurrentAnimation = Utility:TweenObject(
                self.Target,
                preset.properties,
                preset.duration,
                preset.style,
                nil,
                preset.repeatCount,
                preset.reverses
            )
        end
    end
    
    function self:Stop()
        if self.CurrentAnimation then
            self.CurrentAnimation:Cancel()
        end
    end
    
    function self:CreateCustom(properties, duration, style)
        return Utility:TweenObject(self.Target, properties, duration, style)
    end
    
    return self
end

-- ============================================================================
-- SECTION CLASS (Enhanced)
-- ============================================================================
local Section = {}
Section.__index = Section

function Section.new(parent, options)
    local self = setmetatable({}, Section)
    self.Name = options.Name or "Section"
    self.Elements = {}
    
    self.Container = Instance.new("Frame")
    self.Container.Size = UDim2.new(1, -20, 0, 0)
    self.Container.Position = UDim2.new(0, 10, 0, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.AutomaticSize = Enum.AutomaticSize.Y
    self.Container.Parent = parent
    
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundTransparency = 1
    header.Parent = self.Container
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 5, 0, 0)
    icon.Text = options.Icon or "▸"
    icon.TextColor3 = Theme:Get().Accent
    icon.TextSize = 14
    icon.BackgroundTransparency = 1
    icon.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 1, 0)
    title.Position = UDim2.new(0, 35, 0, 0)
    title.Text = self.Name
    title.TextColor3 = Theme:Get().Text
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = header
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, -10, 0, 1)
    line.Position = UDim2.new(0, 5, 0, 35)
    line.BackgroundColor3 = Theme:Get().Border
    line.BackgroundTransparency = 0.5
    line.Parent = self.Container
    
    self.Content = Instance.new("Frame")
    self.Content.Size = UDim2.new(1, 0, 0, 0)
    self.Content.Position = UDim2.new(0, 0, 0, 40)
    self.Content.BackgroundTransparency = 1
    self.Content.AutomaticSize = Enum.AutomaticSize.Y
    self.Content.Parent = self.Container
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 6)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = self.Content
    
    -- Collapsible functionality
    local collapsed = false
    local contentHeight = 0
    
    header.MouseButton1Click:Connect(function()
        collapsed = not collapsed
        if collapsed then
            Utility:TweenObject(self.Content, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            icon.Text = "▸"
        else
            Utility:TweenObject(self.Content, {Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y)}, 0.2)
            icon.Text = "▾"
        end
    end)
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentHeight = contentLayout.AbsoluteContentSize.Y
        if not collapsed then
            self.Content.Size = UDim2.new(1, 0, 0, contentHeight)
        end
        self.Container.Size = UDim2.new(1, -20, 0, 40 + contentHeight)
    end)
    
    function self:CreateButton(options)
        local btn = AdvancedButton.new(self.Content, options)
        table.insert(self.Elements, btn)
        return btn
    end
    
    function self:CreateToggle(options)
        local toggle = AdvancedToggle.new(self.Content, options)
        table.insert(self.Elements, toggle)
        return toggle
    end
    
    function self:CreateColorPicker(options)
        local picker = ColorPicker.new(self.Content, options)
        table.insert(self.Elements, picker)
        return picker
    end
    
    function self:CreateGamepassButton(options)
        local btn = GamepassButton.new(self.Content, options)
        table.insert(self.Elements, btn)
        return btn
    end
    
    function self:CreateProductButton(options)
        local btn = DeveloperProductButton.new(self.Content, options)
        table.insert(self.Elements, btn)
        return btn
    end
    
    function self:CreateLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 25)
        label.Position = UDim2.new(0, 5, 0, 0)
        label.Text = text
        label.TextColor3 = Theme:Get().TextSecondary
        label.TextSize = 12
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        label.Parent = self.Content
        return label
    end
    
    return self
end

-- ============================================================================
-- TAB CLASS (Enhanced)
-- ============================================================================
local Tab = {}
Tab.__index = Tab

function Tab.new(parent, options)
    local self = setmetatable({}, Tab)
    self.Name = options.Name or "Tab"
    self.Icon = options.Icon or ""
    self.Sections = {}
    
    self.Button = Instance.new("TextButton")
    self.Button.Size = UDim2.new(1, 0, 0, 45)
    self.Button.Text = "  " .. self.Icon .. "  " .. self.Name
    self.Button.TextColor3 = Theme:Get().TextSecondary
    self.Button.TextSize = 13
    self.Button.Font = Enum.Font.Gotham
    self.Button.TextXAlignment = Enum.TextXAlignment.Left
    self.Button.BackgroundTransparency = 1
    self.Button.Parent = parent
    
    self.Container = Instance.new("ScrollingFrame")
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.BackgroundTransparency = 1
    self.Container.BorderSizePixel = 0
    self.Container.ScrollBarThickness = 4
    self.Container.ScrollBarImageColor3 = Theme:Get().Accent
    self.Container.Visible = false
    self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.Container.Parent = parent.Parent
    
    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 10)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Parent = self.Container
    
    containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, containerLayout.AbsoluteContentSize.Y + 20)
    end)
    
    function self:CreateSection(options)
        local section = Section.new(self.Container, options)
        table.insert(self.Sections, section)
        return section
    end
    
    function self:Show()
        self.Container.Visible = true
        Utility:TweenObject(self.Button, {TextColor3 = Theme:Get().Text, BackgroundTransparency = 0.1}, 0.2)
    end
    
    function self:Hide()
        self.Container.Visible = false
        Utility:TweenObject(self.Button, {TextColor3 = Theme:Get().TextSecondary, BackgroundTransparency = 1}, 0.2)
    end
    
    self.Button.MouseButton1Click:Connect(function()
        for _, sibling in pairs(parent:GetChildren()) do
            if sibling:IsA("TextButton") and sibling ~= self.Button then
                local siblingTab = sibling:GetAttribute("TabRef")
                if siblingTab then siblingTab:Hide() end
            end
        end
        self:Show()
    end)
    
    self.Button:SetAttribute("TabRef", self)
    
    return self
end

-- ============================================================================
-- WINDOW CLASS (Enhanced)
-- ============================================================================
local Window = {}
Window.__index = Window

function Window.new(options)
    local self = setmetatable({}, Window)
    
    self.Name = options.Name or "Synapse UI Studio"
    self.Size = options.Size or UDim2.new(0, 1100, 0, 700)
    self.Tabs = {}
    self.Editor = nil
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SynapseUIStudio_" .. Utility:GenerateGUID()
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CoreGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = Theme:Get().Background
    self.MainFrame.BackgroundTransparency = 0.05
    Utility:CreateRoundedCorner(self.MainFrame, 16)
    Utility:CreateStroke(self.MainFrame, 1.5, Theme:Get().Accent, 0.3)
    Utility:CreateShadow(self.MainFrame, 25, 0.6)
    self.MainFrame.Parent = self.ScreenGui
    
    -- Blur background
    local blurBg = Instance.new("Frame")
    blurBg.Size = UDim2.new(1, 0, 1, 0)
    blurBg.BackgroundTransparency = 1
    blurBg.Parent = self.MainFrame
    local blur = Utility:CreateBlur(blurBg, 10)
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 55)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.MainFrame
    
    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.new(0, 40, 1, 0)
    logo.Position = UDim2.new(0, 12, 0, 0)
    logo.Text = "⚡"
    logo.TextColor3 = Theme:Get().Accent
    logo.TextSize = 24
    logo.BackgroundTransparency = 1
    logo.Parent = self.TitleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 250, 1, 0)
    title.Position = UDim2.new(0, 55, 0, 0)
    title.Text = self.Name
    title.TextColor3 = Theme:Get().Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1
    title.Parent = self.TitleBar
    
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Size = UDim2.new(0, 80, 0, 18)
    versionLabel.Position = UDim2.new(0, 210, 0, 20)
    versionLabel.Text = "v3.0.0"
    versionLabel.TextColor3 = Theme:Get().Accent
    versionLabel.TextSize = 11
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.BackgroundTransparency = 1
    versionLabel.Parent = self.TitleBar
    
    -- Window Controls
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 38, 0, 38)
    minimizeBtn.Position = UDim2.new(1, -95, 0, 8)
    minimizeBtn.Text = "─"
    minimizeBtn.TextColor3 = Theme:Get().TextSecondary
    minimizeBtn.TextSize = 22
    minimizeBtn.Font = Enum.Font.Gotham
    minimizeBtn.BackgroundTransparency = 1
    minimizeBtn.Parent = self.TitleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 38, 0, 38)
    closeBtn.Position = UDim2.new(1, -50, 0, 8)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme:Get().Danger
    closeBtn.TextSize = 18
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = self.TitleBar
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 200, 1, -55)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 55)
    self.Sidebar.BackgroundColor3 = Theme:Get().Surface
    self.Sidebar.BackgroundTransparency = 0.3
    Utility:CreateRoundedCorner(self.Sidebar, 0)
    self.Sidebar.Parent = self.MainFrame
    
    local sidebarStroke = Utility:CreateStroke(self.Sidebar, 1, Theme:Get().Border, 0.3)
    
    self.TabList = Instance.new("ScrollingFrame")
    self.TabList.Size = UDim2.new(1, -16, 1, -16)
    self.TabList.Position = UDim2.new(0, 8, 0, 8)
    self.TabList.BackgroundTransparency = 1
    self.TabList.BorderSizePixel = 0
    self.TabList.ScrollBarThickness = 2
    self.TabList.Parent = self.Sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = self.TabList
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -215, 1, -65)
    self.ContentArea.Position = UDim2.new(0, 205, 0, 60)
    self.ContentArea.BackgroundColor3 = Theme:Get().Background
    self.ContentArea.BackgroundTransparency = 0.1
    Utility:CreateRoundedCorner(self.ContentArea, 12)
    self.ContentArea.Parent = self.MainFrame
    
    -- Minimize
    local minimized = false
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Utility:TweenObject(self.MainFrame, {Size = UDim2.new(0, 320, 0, 55)}, 0.3)
            self.Sidebar.Visible = false
            self.ContentArea.Visible = false
        else
            Utility:TweenObject(self.MainFrame, {Size = self.Size}, 0.3)
            task.wait(0.3)
            self.Sidebar.Visible = true
            self.ContentArea.Visible = true
        end
    end)
    
    -- Close
    closeBtn.MouseButton1Click:Connect(function()
        Utility:TweenObject(self.MainFrame, {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        self.ScreenGui:Destroy()
    end)
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    function self:CreateTab(options)
        local tab = Tab.new(self.TabList, options)
        table.insert(self.Tabs, tab)
        return tab
    end
    
    function self:EnableLiveEditing(targetContainer)
        self.Editor = UIEditor.new(targetContainer or self.ContentArea)
        self.Editor:EnableEditing()
        return self.Editor
    end
    
    function self:Notify(options)
        NotificationManager:Notify(options)
    end
    
    function self:SetTheme(themeName)
        Theme:Set(themeName)
        self:Notify({Title = "Theme Changed", Message = "Theme set to " .. themeName, Duration = 2, Type = "info"})
    end
    
    function self:Destroy()
        self.ScreenGui:Destroy()
    end
    
    -- Show first tab
    task.spawn(function()
        task.wait(0.1)
        for _, tab in ipairs(self.Tabs) do
            tab:Show()
            break
        end
    end)
    
    NotificationManager:Init(self.ScreenGui)
    ConfigManager:Load()
    
    return self
end

-- ============================================================================
-- LIBRARY EXPORT
-- ============================================================================
local Library = {
    Version = "3.0.0",
    Theme = Theme,
    Notify = function(options) NotificationManager:Notify(options) end,
    TweenPresets = TweenPresets,
    UndoRedo = UndoRedoManager,
    Serializer = ObjectSerializer,
}

function Library:CreateWindow(options)
    return Window.new(options)
end

function Library:CreateAnimationPreview(target)
    return AnimationPreview.new(target)
end

function Library:Notify(options)
    return NotificationManager:Notify(options)
end

function Library:SetTheme(themeName)
    return Theme:Set(themeName)
end

function Library:SaveConfig()
    ConfigManager:Save()
end

function Library:LoadConfig()
    return ConfigManager:Load()
end

-- Initialize
NotificationManager:Init(CoreGui)

-- Return the library
return Library
