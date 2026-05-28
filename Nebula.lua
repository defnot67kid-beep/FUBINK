local Nebula = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Module Storage
local ActiveWindows = {}
local WindowSettings = {}

-- Utility Functions
local function HexToRGB(hex)
    hex = hex:gsub("#", "")
    local r = tonumber(hex:sub(1,2), 16) or 0
    local g = tonumber(hex:sub(3,4), 16) or 0
    local b = tonumber(hex:sub(5,6), 16) or 0
    return Color3.fromRGB(r, g, b)
end

local function RGBToHex(color3)
    return string.format("#%02x%02x%02x", color3.R * 255, color3.G * 255, color3.B * 255)
end

local function CreateCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
end

local function CreateGradient(instance, color1, color2, direction)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    if direction == "horizontal" then
        gradient.Rotation = 0
    elseif direction == "vertical" then
        gradient.Rotation = 90
    elseif direction == "diagonal" then
        gradient.Rotation = 45
    end
    gradient.Parent = instance
    return gradient
end

-- Main Window Class
local Window = {}
Window.__index = Window

function Window.new(windowName, config)
    config = config or {}
    
    local self = setmetatable({}, Window)
    
    -- Default Configuration
    self.Config = {
        Name = windowName or "Nebula",
        Size = config.Size or UDim2.new(0, 600, 0, 400),
        Position = config.Position or UDim2.new(0.5, -300, 0.5, -200),
        MinimumSize = config.MinimumSize or Vector2.new(400, 300),
        MaximumSize = config.MaximumSize or Vector2.new(1000, 800),
        Resizable = config.Resizable ~= false,
        Draggable = config.Draggable ~= false,
        Closable = config.Closable ~= false,
        
        -- Colors
        MainColor = config.MainColor or Color3.fromRGB(138, 43, 226), -- Purple
        SecondaryColor = config.SecondaryColor or Color3.fromRGB(75, 0, 130),
        BackgroundColor = config.BackgroundColor or Color3.fromRGB(20, 20, 25),
        SurfaceColor = config.SurfaceColor or Color3.fromRGB(30, 30, 35),
        TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
        AccentColor = config.AccentColor or Color3.fromRGB(0, 255, 255),
        
        -- Effects
        CornerRadius = config.CornerRadius or 8,
        GradientEnabled = config.GradientEnabled or false,
        GradientDirection = config.GradientDirection or "vertical",
        BlurEnabled = config.BlurEnabled or false,
        ShadowEnabled = config.ShadowEnabled ~= false,
        
        -- Animation
        AnimationSpeed = config.AnimationSpeed or 0.2,
        
        -- Behavior
        AutoShow = config.AutoShow ~= false,
        Pinned = config.Pinned or false,
        Transparency = config.Transparency or 0,
    }
    
    self.Tabs = {}
    self.Notifications = {}
    self.CurrentTab = nil
    self.IsVisible = self.Config.AutoShow
    self.IsMinimized = false
    
    self:CreateUI()
    self:SetupEvents()
    
    return self
end

function Window:CreateUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Nebula_" .. self.Config.Name
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = game.CoreGui
    
    -- Shadow
    if self.Config.ShadowEnabled then
        self.Shadow = Instance.new("Frame")
        self.Shadow.Name = "Shadow"
        self.Shadow.Parent = self.ScreenGui
        self.Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        self.Shadow.BackgroundTransparency = 0.6
        self.Shadow.Position = self.Config.Position + UDim2.new(0, 5, 0, 5)
        self.Shadow.Size = self.Config.Size
        self.Shadow.BorderSizePixel = 0
        
        local shadowCorner = Instance.new("UICorner")
        shadowCorner.CornerRadius = UDim.new(0, self.Config.CornerRadius + 2)
        shadowCorner.Parent = self.Shadow
    end
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = self.Config.BackgroundColor
    self.MainFrame.BackgroundTransparency = self.Config.Transparency
    self.MainFrame.Position = self.Config.Position
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    
    -- Main Corner
    self.MainCorner = CreateCorner(self.MainFrame, self.Config.CornerRadius)
    
    -- Gradient
    if self.Config.GradientEnabled then
        self.MainGradient = CreateGradient(self.MainFrame, self.Config.MainColor, self.Config.SecondaryColor, self.Config.GradientDirection)
        self.MainGradient.Transparency = NumberSequence.new(0.3)
    end
    
    -- Blur Effect
    if self.Config.BlurEnabled then
        self.Blur = Instance.new("BlurEffect")
        self.Blur.Name = "NebulaBlur"
        self.Blur.Size = 12
        self.Blur.Parent = self.ScreenGui
    end
    
    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Name = "TopBar"
    self.TopBar.Parent = self.MainFrame
    self.TopBar.BackgroundColor3 = self.Config.MainColor
    self.TopBar.BackgroundTransparency = 0.1
    self.TopBar.Size = UDim2.new(1, 0, 0, 45)
    self.TopBar.BorderSizePixel = 0
    
    CreateCorner(self.TopBar, self.Config.CornerRadius)
    
    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Parent = self.TopBar
    self.Title.BackgroundTransparency = 1
    self.Title.Position = UDim2.new(0, 15, 0, 0)
    self.Title.Size = UDim2.new(0, 200, 1, 0)
    self.Title.Font = Enum.Font.GothamBold
    self.Title.Text = self.Config.Name
    self.Title.TextColor3 = self.Config.TextColor
    self.Title.TextSize = 16
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Window Controls
    self.Controls = Instance.new("Frame")
    self.Controls.Name = "Controls"
    self.Controls.Parent = self.TopBar
    self.Controls.BackgroundTransparency = 1
    self.Controls.Size = UDim2.new(0, 100, 1, 0)
    self.Controls.Position = UDim2.new(1, -105, 0, 0)
    
    -- Minimize Button
    self.MinimizeBtn = Instance.new("TextButton")
    self.MinimizeBtn.Name = "MinimizeBtn"
    self.MinimizeBtn.Parent = self.Controls
    self.MinimizeBtn.BackgroundTransparency = 1
    self.MinimizeBtn.Size = UDim2.new(0, 30, 1, 0)
    self.MinimizeBtn.Position = UDim2.new(0, 0, 0, 0)
    self.MinimizeBtn.Font = Enum.Font.GothamBold
    self.MinimizeBtn.Text = "─"
    self.MinimizeBtn.TextColor3 = self.Config.TextColor
    self.MinimizeBtn.TextSize = 20
    self.MinimizeBtn.AutoButtonColor = false
    
    -- Maximize Button
    self.MaximizeBtn = Instance.new("TextButton")
    self.MaximizeBtn.Name = "MaximizeBtn"
    self.MaximizeBtn.Parent = self.Controls
    self.MaximizeBtn.BackgroundTransparency = 1
    self.MaximizeBtn.Size = UDim2.new(0, 30, 1, 0)
    self.MaximizeBtn.Position = UDim2.new(0, 35, 0, 0)
    self.MaximizeBtn.Font = Enum.Font.GothamBold
    self.MaximizeBtn.Text = "□"
    self.MaximizeBtn.TextColor3 = self.Config.TextColor
    self.MaximizeBtn.TextSize = 18
    self.MaximizeBtn.AutoButtonColor = false
    
    -- Close Button
    if self.Config.Closable then
        self.CloseBtn = Instance.new("TextButton")
        self.CloseBtn.Name = "CloseBtn"
        self.CloseBtn.Parent = self.Controls
        self.CloseBtn.BackgroundTransparency = 1
        self.CloseBtn.Size = UDim2.new(0, 30, 1, 0)
        self.CloseBtn.Position = UDim2.new(0, 70, 0, 0)
        self.CloseBtn.Font = Enum.Font.GothamBold
        self.CloseBtn.Text = "✕"
        self.CloseBtn.TextColor3 = self.Config.TextColor
        self.CloseBtn.TextSize = 16
        self.CloseBtn.AutoButtonColor = false
    end
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundColor3 = self.Config.SurfaceColor
    self.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    self.TabContainer.Size = UDim2.new(0, 150, 1, -45)
    self.TabContainer.BorderSizePixel = 0
    
    CreateCorner(self.TabContainer, self.Config.CornerRadius)
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.BackgroundColor3 = self.Config.BackgroundColor
    self.ContentContainer.BackgroundTransparency = self.Config.Transparency
    self.ContentContainer.Position = UDim2.new(0, 155, 0, 50)
    self.ContentContainer.Size = UDim2.new(1, -160, 1, -55)
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ClipsDescendants = true
    
    CreateCorner(self.ContentContainer, self.Config.CornerRadius)
    
    -- Tab List Layout
    self.TabList = Instance.new("UIListLayout")
    self.TabList.Parent = self.TabContainer
    self.TabList.Padding = UDim.new(0, 5)
    self.TabList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.Parent = self.TabContainer
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 10)
    tabPadding.PaddingRight = UDim.new(0, 10)
    
    -- Content Layout
    self.ContentList = Instance.new("UIListLayout")
    self.ContentList.Parent = self.ContentContainer
    self.ContentList.Padding = UDim.new(0, 8)
    self.ContentList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local contentPadding = Instance.new("UIPadding")
    contentPadding.Parent = self.ContentContainer
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingBottom = UDim.new(0, 10)
    
    -- Pages Folder
    self.PagesFolder = Instance.new("Folder")
    self.PagesFolder.Name = "PagesFolder"
    self.PagesFolder.Parent = self.ContentContainer
end

function Window:SetupEvents()
    -- Dragging
    if self.Config.Draggable then
        local dragging = false
        local dragInput
        local dragStart
        local startPos
        
        self.TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
        
        self.TopBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                self.MainFrame.Position = newPos
                if self.Shadow then
                    self.Shadow.Position = newPos + UDim2.new(0, 5, 0, 5)
                end
            end
        end)
    end
    
    -- Resizing
    if self.Config.Resizable then
        local resizing = false
        local resizeStart
        local startSize
        local startPos
        local edge = nil
        
        local ResizeHandle = Instance.new("Frame")
        ResizeHandle.Name = "ResizeHandle"
        ResizeHandle.Parent = self.MainFrame
        ResizeHandle.BackgroundColor3 = self.Config.MainColor
        ResizeHandle.BackgroundTransparency = 0.8
        ResizeHandle.Size = UDim2.new(0, 10, 0, 10)
        ResizeHandle.Position = UDim2.new(1, -10, 1, -10)
        ResizeHandle.BorderSizePixel = 0
        ResizeHandle.ZIndex = 10
        
        ResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resizeStart = input.Position
                startSize = self.MainFrame.Size
                startPos = self.MainFrame.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - resizeStart
                local newWidth = math.clamp(startSize.X.Offset + delta.X, self.Config.MinimumSize.X, self.Config.MaximumSize.X)
                local newHeight = math.clamp(startSize.Y.Offset + delta.Y, self.Config.MinimumSize.Y, self.Config.MaximumSize.Y)
                self.MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
                if self.Shadow then
                    self.Shadow.Size = UDim2.new(0, newWidth, 0, newHeight)
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
        end)
    end
    
    -- Minimize
    self.MinimizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Maximize/Restore
    self.MaximizeBtn.MouseButton1Click:Connect(function()
        self:ToggleMaximize()
    end)
    
    -- Close
    if self.CloseBtn then
        self.CloseBtn.MouseButton1Click:Connect(function()
            self:Hide()
        end)
    end
end

function Window:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    local targetHeight = self.IsMinimized and 45 or self.Config.Size.Y.Offset
    local targetContentTransparency = self.IsMinimized and 1 or 0
    
    TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, self.Config.Size.X.Offset, 0, targetHeight)
    }):Play()
    
    TweenService:Create(self.ContentContainer, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
        BackgroundTransparency = targetContentTransparency
    }):Play()
    
    TweenService:Create(self.TabContainer, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
        BackgroundTransparency = targetContentTransparency
    }):Play()
    
    self.MinimizeBtn.Text = self.IsMinimized and "□" or "─"
end

function Window:ToggleMaximize()
    if self.IsMaximized then
        -- Restore
        TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
            Size = self.OriginalSize,
            Position = self.OriginalPosition
        }):Play()
        if self.Shadow then
            TweenService:Create(self.Shadow, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
                Size = self.OriginalSize,
                Position = self.OriginalPosition + UDim2.new(0, 5, 0, 5)
            }):Play()
        end
        self.IsMaximized = false
        self.MaximizeBtn.Text = "□"
    else
        -- Maximize
        self.OriginalSize = self.MainFrame.Size
        self.OriginalPosition = self.MainFrame.Position
        local viewportSize = workspace.CurrentCamera.ViewportSize
        TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, viewportSize.X, 0, viewportSize.Y),
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()
        if self.Shadow then
            TweenService:Create(self.Shadow, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, viewportSize.X, 0, viewportSize.Y),
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
        self.IsMaximized = true
        self.MaximizeBtn.Text = "❐"
    end
end

function Window:Show()
    self.IsVisible = true
    TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
        BackgroundTransparency = self.Config.Transparency
    }):Play()
end

function Window:Hide()
    self.IsVisible = false
    TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 1
    }):Play()
end

function Window:Destroy()
    self.ScreenGui:Destroy()
    if self.Blur then
        self.Blur:Destroy()
    end
    table.remove(ActiveWindows, table.find(ActiveWindows, self))
end

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Window:CreateTab(tabName, config)
    config = config or {}
    
    local self = self
    local tab = setmetatable({}, Tab)
    
    tab.Name = tabName
    tab.Parent = self
    tab.Config = {
        Icon = config.Icon or nil,
        Color = config.Color or self.Config.MainColor,
        LayoutOrder = config.LayoutOrder or #self.Tabs + 1
    }
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = "Tab_" .. tabName
    tab.Button.Parent = self.TabContainer
    tab.Button.BackgroundColor3 = self.Config.SurfaceColor
    tab.Button.Size = UDim2.new(1, 0, 0, 40)
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.Text = tabName
    tab.Button.TextColor3 = self.Config.TextColor
    tab.Button.TextSize = 14
    tab.Button.AutoButtonColor = false
    tab.Button.LayoutOrder = tab.Config.LayoutOrder
    
    CreateCorner(tab.Button, 6)
    
    -- Tab Page
    tab.Page = Instance.new("ScrollingFrame")
    tab.Page.Name = "Page_" .. tabName
    tab.Page.Parent = self.PagesFolder
    tab.Page.BackgroundTransparency = 1
    tab.Page.Size = UDim2.new(1, 0, 1, 0)
    tab.Page.ScrollBarThickness = 5
    tab.Page.ScrollBarImageColor3 = self.Config.MainColor
    tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Page.Visible = false
    
    local pageList = Instance.new("UIListLayout")
    pageList.Parent = tab.Page
    pageList.Padding = UDim.new(0, 8)
    pageList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.Parent = tab.Page
    pagePadding.PaddingTop = UDim.new(0, 10)
    pagePadding.PaddingLeft = UDim.new(0, 10)
    pagePadding.PaddingRight = UDim.new(0, 10)
    pagePadding.PaddingBottom = UDim.new(0, 10)
    
    -- Update canvas size
    local function updateCanvas()
        local contentSize = pageList.AbsoluteContentSize
        tab.Page.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end
    
    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    tab.Page.ChildAdded:Connect(updateCanvas)
    tab.Page.ChildRemoved:Connect(updateCanvas)
    
    -- Tab click event
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    -- Store tab
    table.insert(self.Tabs, tab)
    
    -- Select first tab if none selected
    if not self.CurrentTab then
        self:SelectTab(tab)
    end
    
    -- Element Handler
    local ElementHandler = {}
    
    function ElementHandler:CreateSection(sectionName)
        local section = Instance.new("Frame")
        section.Name = "Section_" .. sectionName
        section.Parent = tab.Page
        section.BackgroundColor3 = self.Config.SurfaceColor
        section.BackgroundTransparency = self.Config.Transparency
        section.Size = UDim2.new(1, -20, 0, 40)
        section.BorderSizePixel = 0
        
        CreateCorner(section, self.Config.CornerRadius)
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = section
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Size = UDim2.new(1, -20, 0, 30)
        sectionTitle.Position = UDim2.new(0, 10, 0, 0)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = sectionName
        sectionTitle.TextColor3 = self.Config.MainColor
        sectionTitle.TextSize = 14
        sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local sectionList = Instance.new("UIListLayout")
        sectionList.Parent = section
        sectionList.Padding = UDim.new(0, 5)
        sectionList.SortOrder = Enum.SortOrder.LayoutOrder
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.Parent = section
        sectionPadding.PaddingTop = UDim.new(0, 35)
        sectionPadding.PaddingLeft = UDim.new(0, 10)
        sectionPadding.PaddingRight = UDim.new(0, 10)
        sectionPadding.PaddingBottom = UDim.new(0, 10)
        
        -- Auto resize section
        local function resizeSection()
            local contentHeight = sectionList.AbsoluteContentSize.Y
            section.Size = UDim2.new(1, -20, 0, contentHeight + 45)
        end
        
        sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resizeSection)
        resizeSection()
        
        return {
            AddElement = function(element)
                element.Parent = section
                resizeSection()
            end
        }
    end
    
    function ElementHandler:TextLabel(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, config.Height or 30)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = config.Font or Enum.Font.GothamSemibold
        label.Text = config.Text or ""
        label.TextColor3 = config.Color or self.Config.TextColor
        label.TextSize = config.Size or 14
        label.TextXAlignment = config.XAlign or Enum.TextXAlignment.Left
        label.TextYAlignment = config.YAlign or Enum.TextYAlignment.Center
        
        return frame
    end
    
    function ElementHandler:Button(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, config.Height or 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local button = Instance.new("TextButton")
        button.Parent = frame
        button.BackgroundColor3 = config.Color or self.Config.MainColor
        button.Size = UDim2.new(0, config.Width or 120, 0, config.Height or 35)
        button.Position = UDim2.new(0, 10, 0.5, -17)
        button.Font = Enum.Font.GothamSemibold
        button.Text = config.Text or "Button"
        button.TextColor3 = self.Config.TextColor
        button.TextSize = 14
        button.AutoButtonColor = false
        
        CreateCorner(button, self.Config.CornerRadius)
        
        local info = Instance.new("TextLabel")
        info.Parent = frame
        info.BackgroundTransparency = 1
        info.Size = UDim2.new(0, frame.Size.X.Offset - 140, 1, 0)
        info.Position = UDim2.new(1, -10, 0, 0)
        info.Font = Enum.Font.Gotham
        info.Text = config.Info or ""
        info.TextColor3 = self.Config.TextColor
        info.TextColor3 = Color3.fromRGB(150, 150, 150)
        info.TextSize = 12
        info.TextXAlignment = Enum.TextXAlignment.Right
        info.TextYAlignment = Enum.TextYAlignment.Center
        
        -- Hover effect
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = config.HoverColor or self.Config.SecondaryColor
            }):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = config.Color or self.Config.MainColor
            }):Play()
        end)
        
        button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
        end)
        
        return frame
    end
    
    function ElementHandler:Toggle(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Toggle"
        label.TextColor3 = self.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = frame
        toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        toggleFrame.Size = UDim2.new(0, 50, 0, 26)
        toggleFrame.Position = UDim2.new(1, -60, 0.5, -13)
        toggleFrame.BorderSizePixel = 0
        
        CreateCorner(toggleFrame, 13)
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Parent = toggleFrame
        toggleCircle.BackgroundColor3 = self.Config.TextColor
        toggleCircle.Size = UDim2.new(0, 22, 0, 22)
        toggleCircle.Position = UDim2.new(0, 2, 0, 2)
        toggleCircle.BorderSizePixel = 0
        
        CreateCorner(toggleCircle, 11)
        
        local state = false
        
        local function updateToggle()
            local targetPos = state and 26 or 2
            local targetColor = state and self.Config.MainColor or Color3.fromRGB(50, 50, 55)
            
            TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0, targetPos, 0, 2)
            }):Play()
            
            TweenService:Create(toggleFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = targetColor
            }):Play()
        end
        
        toggleFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                state = not state
                updateToggle()
                if config.Callback then
                    config.Callback(state)
                end
            end
        end)
        
        if config.Default then
            state = config.Default
            updateToggle()
        end
        
        return frame
    end
    
    function ElementHandler:Slider(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, 65)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Slider"
        label.TextColor3 = self.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = frame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.new(0, 100, 0, 25)
        valueLabel.Position = UDim2.new(1, -115, 0, 0)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = tostring(config.Default or config.Min or 0)
        valueLabel.TextColor3 = self.Config.MainColor
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = frame
        sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        sliderFrame.Size = UDim2.new(1, -30, 0, 4)
        sliderFrame.Position = UDim2.new(0, 15, 0, 40)
        sliderFrame.BorderSizePixel = 0
        
        CreateCorner(sliderFrame, 2)
        
        local fill = Instance.new("Frame")
        fill.Parent = sliderFrame
        fill.BackgroundColor3 = self.Config.MainColor
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BorderSizePixel = 0
        
        CreateCorner(fill, 2)
        
        local handle = Instance.new("Frame")
        handle.Parent = sliderFrame
        handle.BackgroundColor3 = self.Config.MainColor
        handle.Size = UDim2.new(0, 12, 0, 12)
        handle.Position = UDim2.new(0, -6, 0.5, -6)
        handle.BorderSizePixel = 0
        
        CreateCorner(handle, 6)
        
        local value = config.Default or config.Min or 0
        local min = config.Min or 0
        local max = config.Max or 100
        local decimals = config.Decimals or 0
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * relativeX
            value = decimals > 0 and math.floor(newValue * (10^decimals)) / (10^decimals) or math.floor(newValue)
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            handle.Position = UDim2.new(relativeX, -6, 0.5, -6)
            
            if config.Callback then
                config.Callback(value)
            end
        end
        
        local dragging = false
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
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
        
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                updateSlider(input)
            end
        end)
        
        -- Initialize
        if config.Default then
            local initValue = (config.Default - min) / (max - min)
            fill.Size = UDim2.new(initValue, 0, 1, 0)
            handle.Position = UDim2.new(initValue, -6, 0.5, -6)
            valueLabel.Text = tostring(config.Default)
        end
        
        return frame
    end
    
    function ElementHandler:Dropdown(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Dropdown"
        label.TextColor3 = self.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Parent = frame
        dropdownBtn.BackgroundColor3 = self.Config.SurfaceColor
        dropdownBtn.Size = UDim2.new(0, 200, 0, 35)
        dropdownBtn.Position = UDim2.new(1, -215, 0.5, -17)
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.Text = config.Default or "Select option"
        dropdownBtn.TextColor3 = self.Config.TextColor
        dropdownBtn.TextSize = 13
        dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        CreateCorner(dropdownBtn, self.Config.CornerRadius)
        
        local arrow = Instance.new("TextLabel")
        arrow.Parent = dropdownBtn
        arrow.BackgroundTransparency = 1
        arrow.Size = UDim2.new(0, 30, 1, 0)
        arrow.Position = UDim2.new(1, -30, 0, 0)
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = "▼"
        arrow.TextColor3 = self.Config.TextColor
        arrow.TextSize = 12
        
        local expanded = false
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Parent = frame
        optionsFrame.BackgroundColor3 = self.Config.SurfaceColor
        optionsFrame.Size = UDim2.new(0, 200, 0, 0)
        optionsFrame.Position = UDim2.new(1, -215, 0.5, 18)
        optionsFrame.BorderSizePixel = 0
        optionsFrame.ClipsDescendants = true
        
        CreateCorner(optionsFrame, self.Config.CornerRadius)
        
        local optionsList = Instance.new("UIListLayout")
        optionsList.Parent = optionsFrame
        optionsList.Padding = UDim.new(0, 2)
        
        local function updateHeight()
            local count = #optionsFrame:GetChildren() - 1
            local newHeight = count * 35
            optionsFrame.Size = UDim2.new(0, 200, 0, newHeight)
            frame.Size = UDim2.new(1, 0, 0, 45 + (expanded and newHeight or 0))
        end
        
        for _, option in ipairs(config.Options or {}) do
            local btn = Instance.new("TextButton")
            btn.Parent = optionsFrame
            btn.BackgroundColor3 = self.Config.SurfaceColor
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Font = Enum.Font.Gotham
            btn.Text = option
            btn.TextColor3 = self.Config.TextColor
            btn.TextSize = 13
            btn.AutoButtonColor = false
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = self.Config.MainColor
                btn.BackgroundTransparency = 0.3
            end)
            
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = self.Config.SurfaceColor
            end)
            
            btn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                if config.Callback then
                    config.Callback(option)
                end
                expanded = false
                TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 200, 0, 0)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
                arrow.Text = "▼"
            end)
        end
        
        dropdownBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 200, 0, #config.Options * 35)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, 0, 0, 45 + (#config.Options * 35))
                }):Play()
                arrow.Text = "▲"
            else
                TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 200, 0, 0)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
                arrow.Text = "▼"
            end
        end)
        
        return frame
    end
    
    function ElementHandler:TextBox(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Text Box"
        label.TextColor3 = self.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local box = Instance.new("TextBox")
        box.Parent = frame
        box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        box.Size = UDim2.new(0, 200, 0, 35)
        box.Position = UDim2.new(1, -215, 0.5, -17)
        box.Font = Enum.Font.Gotham
        box.PlaceholderText = config.Placeholder or ""
        box.Text = config.Default or ""
        box.TextColor3 = self.Config.TextColor
        box.TextSize = 13
        
        CreateCorner(box, self.Config.CornerRadius)
        
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed and config.Callback then
                config.Callback(box.Text)
            end
        end)
        
        return frame
    end
    
    function ElementHandler:Keybind(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Keybind"
        label.TextColor3 = self.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = frame
        keyBtn.BackgroundColor3 = self.Config.MainColor
        keyBtn.Size = UDim2.new(0, 80, 0, 35)
        keyBtn.Position = UDim2.new(1, -95, 0.5, -17)
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.Text = config.Default or "None"
        keyBtn.TextColor3 = self.Config.TextColor
        keyBtn.TextSize = 13
        
        CreateCorner(keyBtn, self.Config.CornerRadius)
        
        local currentKey = config.Default
        local listening = false
        
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
            keyBtn.BackgroundColor3 = self.Config.SecondaryColor
        end)
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and not gameProcessed then
                local key = input.KeyCode.Name
                if key ~= "Unknown" then
                    currentKey = key
                    keyBtn.Text = key
                    listening = false
                    keyBtn.BackgroundColor3 = self.Config.MainColor
                    if config.Callback then
                        config.Callback(key)
                    end
                end
            end
        end)
        
        -- Keybind trigger
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not listening and not gameProcessed and currentKey then
                if input.KeyCode.Name == currentKey then
                    if config.OnPress then
                        config.OnPress()
                    end
                end
            end
        end)
        
        return frame
    end
    
    function ElementHandler:ColorPicker(config)
        config = config or {}
        
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.SurfaceColor
        frame.BackgroundTransparency = self.Config.Transparency
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Color Picker"
        label.TextColor3 = self.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local colorDisplay = Instance.new("Frame")
        colorDisplay.Parent = frame
        colorDisplay.BackgroundColor3 = config.Default or self.Config.MainColor
        colorDisplay.Size = UDim2.new(0, 35, 0, 35)
        colorDisplay.Position = UDim2.new(1, -50, 0.5, -17)
        colorDisplay.BorderSizePixel = 0
        
        CreateCorner(colorDisplay, self.Config.CornerRadius)
        
        colorDisplay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                -- Open color picker dialog
                local colorPicker = Instance.new("Frame")
                colorPicker.Parent = frame
                colorPicker.BackgroundColor3 = self.Config.SurfaceColor
                colorPicker.Size = UDim2.new(0, 250, 0, 200)
                colorPicker.Position = UDim2.new(1, -260, 0, 50)
                colorPicker.BorderSizePixel = 0
                colorPicker.ZIndex = 10
                
                CreateCorner(colorPicker, self.Config.CornerRadius)
                
                -- Simple RGB sliders for demo (in production, use actual color wheel)
                local rSlider = self:Slider({
                    Text = "Red",
                    Min = 0,
                    Max = 255,
                    Default = colorDisplay.BackgroundColor3.R * 255,
                    Callback = function(val)
                        local newColor = Color3.fromRGB(val, colorDisplay.BackgroundColor3.G * 255, colorDisplay.BackgroundColor3.B * 255)
                        colorDisplay.BackgroundColor3 = newColor
                        if config.Callback then
                            config.Callback(newColor)
                        end
                    end
                })
                rSlider.Parent = colorPicker
                rSlider.Size = UDim2.new(1, -20, 0, 45)
                rSlider.Position = UDim2.new(0, 10, 0, 10)
                
                local gSlider = self:Slider({
                    Text = "Green",
                    Min = 0,
                    Max = 255,
                    Default = colorDisplay.BackgroundColor3.G * 255,
                    Callback = function(val)
                        local newColor = Color3.fromRGB(colorDisplay.BackgroundColor3.R * 255, val, colorDisplay.BackgroundColor3.B * 255)
                        colorDisplay.BackgroundColor3 = newColor
                        if config.Callback then
                            config.Callback(newColor)
                        end
                    end
                })
                gSlider.Parent = colorPicker
                gSlider.Size = UDim2.new(1, -20, 0, 45)
                gSlider.Position = UDim2.new(0, 10, 0, 60)
                
                local bSlider = self:Slider({
                    Text = "Blue",
                    Min = 0,
                    Max = 255,
                    Default = colorDisplay.BackgroundColor3.B * 255,
                    Callback = function(val)
                        local newColor = Color3.fromRGB(colorDisplay.BackgroundColor3.R * 255, colorDisplay.BackgroundColor3.G * 255, val)
                        colorDisplay.BackgroundColor3 = newColor
                        if config.Callback then
                            config.Callback(newColor)
                        end
                    end
                })
                bSlider.Parent = colorPicker
                bSlider.Size = UDim2.new(1, -20, 0, 45)
                bSlider.Position = UDim2.new(0, 10, 0, 110)
                
                -- Auto remove after 5 seconds
                task.delay(5, function()
                    colorPicker:Destroy()
                end)
            end
        end)
        
        return frame
    end
    
    function ElementHandler:Notification(config)
        config = config or {}
        
        local notificationFrame = Instance.new("Frame")
        notificationFrame.Parent = self.Parent.ScreenGui
        notificationFrame.BackgroundColor3 = config.Color or self.Config.MainColor
        notificationFrame.Size = UDim2.new(0, 300, 0, 60)
        notificationFrame.Position = UDim2.new(1, -320, 0, 10)
        notificationFrame.BorderSizePixel = 0
        
        CreateCorner(notificationFrame, self.Config.CornerRadius)
        
        local title = Instance.new("TextLabel")
        title.Parent = notificationFrame
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Title or "Notification"
        title.TextColor3 = self.Config.TextColor
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local message = Instance.new("TextLabel")
        message.Parent = notificationFrame
        message.BackgroundTransparency = 1
        message.Size = UDim2.new(1, -20, 0, 25)
        message.Position = UDim2.new(0, 10, 0, 30)
        message.Font = Enum.Font.Gotham
        message.Text = config.Message or ""
        message.TextColor3 = self.Config.TextColor
        message.TextSize = 12
        message.TextXAlignment = Enum.TextXAlignment.Left
        message.TextColor3 = Color3.fromRGB(200, 200, 200)
        
        -- Animate in
        notificationFrame.Position = UDim2.new(1, -10, 0, 10)
        TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -320, 0, 10)
        }):Play()
        
        -- Auto remove
        task.delay(config.Duration or 3, function()
            TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -10, 0, 10)
            }):Play()
            task.wait(0.3)
            notificationFrame:Destroy()
        end)
        
        return notificationFrame
    end
    
    function ElementHandler:Separator()
        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = self.Config.MainColor
        frame.BackgroundTransparency = 0.3
        frame.Size = UDim2.new(1, 0, 0, 1)
        frame.BorderSizePixel = 0
        
        return frame
    end
    
    return ElementHandler
end

function Window:SelectTab(tab)
    if self.CurrentTab == tab then return end
    
    -- Update button colors
    for _, t in ipairs(self.Tabs) do
        TweenService:Create(t.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = self.Config.SurfaceColor
        }):Play()
        t.Button.TextColor3 = self.Config.TextColor
    end
    
    TweenService:Create(tab.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = self.Config.MainColor
    }):Play()
    tab.Button.TextColor3 = self.Config.TextColor
    
    -- Switch pages
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
    end
    tab.Page.Visible = true
    
    self.CurrentTab = tab
end

-- Public API
function Nebula:CreateWindow(name, config)
    local window = Window.new(name, config)
    table.insert(ActiveWindows, window)
    return window
end

function Nebula:DestroyAll()
    for _, window in ipairs(ActiveWindows) do
        window:Destroy()
    end
    ActiveWindows = {}
end

function Nebula:HexToRGB(hex)
    return HexToRGB(hex)
end

function Nebula:RGBToHex(color3)
    return RGBToHex(color3)
end

return Nebula
