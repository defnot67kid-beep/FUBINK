local Nebula = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Module Storage
local ActiveWindows = {}

-- Utility Functions
local function CreateCorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
    return corner
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
        Size = config.Size or UDim2.new(0, 550, 0, 450),
        Position = config.Position or UDim2.new(0.5, -275, 0.5, -225),
        MinimumSize = config.MinimumSize or Vector2.new(400, 300),
        MaximumSize = config.MaximumSize or Vector2.new(1000, 800),
        Resizable = config.Resizable ~= false,
        Draggable = config.Draggable ~= false,
        Closable = config.Closable ~= false,
        
        -- Colors
        MainColor = config.MainColor or Color3.fromRGB(138, 43, 226),
        SecondaryColor = config.SecondaryColor or Color3.fromRGB(75, 0, 130),
        BackgroundColor = config.BackgroundColor or Color3.fromRGB(20, 20, 25),
        SurfaceColor = config.SurfaceColor or Color3.fromRGB(30, 30, 35),
        TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
        
        -- Effects
        CornerRadius = config.CornerRadius or 8,
        GradientEnabled = config.GradientEnabled or false,
        ShadowEnabled = config.ShadowEnabled ~= false,
        
        -- Animation
        AnimationSpeed = config.AnimationSpeed or 0.2,
        
        -- Behavior
        AutoShow = config.AutoShow ~= false,
        Transparency = config.Transparency or 0,
    }
    
    self.Tabs = {}
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
    
    CreateCorner(self.MainFrame, self.Config.CornerRadius)
    
    -- Gradient
    if self.Config.GradientEnabled then
        local gradient = Instance.new("UIGradient")
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, self.Config.MainColor),
            ColorSequenceKeypoint.new(1, self.Config.SecondaryColor)
        })
        gradient.Rotation = 45
        gradient.Parent = self.MainFrame
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
    self.Controls.Parent = self.TopBar
    self.Controls.BackgroundTransparency = 1
    self.Controls.Size = UDim2.new(0, 100, 1, 0)
    self.Controls.Position = UDim2.new(1, -105, 0, 0)
    
    -- Minimize Button
    self.MinimizeBtn = Instance.new("TextButton")
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
    self.TabContainer = Instance.new("ScrollingFrame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundColor3 = self.Config.SurfaceColor
    self.TabContainer.Position = UDim2.new(0, 0, 0, 45)
    self.TabContainer.Size = UDim2.new(0, 150, 1, -45)
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.ScrollBarThickness = 3
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    CreateCorner(self.TabContainer, self.Config.CornerRadius)
    
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
    tabPadding.PaddingBottom = UDim.new(0, 10)
    
    -- Content Container
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.BackgroundColor3 = self.Config.BackgroundColor
    self.ContentContainer.BackgroundTransparency = self.Config.Transparency
    self.ContentContainer.Position = UDim2.new(0, 155, 0, 50)
    self.ContentContainer.Size = UDim2.new(1, -160, 1, -55)
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ClipsDescendants = true
    
    CreateCorner(self.ContentContainer, self.Config.CornerRadius)
    
    -- Pages Folder
    self.PagesFolder = Instance.new("Folder")
    self.PagesFolder.Name = "PagesFolder"
    self.PagesFolder.Parent = self.ContentContainer
    
    -- Update tab container canvas size
    local function updateTabCanvas()
        local contentSize = self.TabList.AbsoluteContentSize
        self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end
    
    self.TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateTabCanvas)
    updateTabCanvas()
end

function Window:SetupEvents()
    -- Dragging
    if self.Config.Draggable then
        local dragging = false
        local dragStart
        local startPos
        
        self.TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = self.MainFrame.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                self.MainFrame.Position = newPos
                if self.Shadow then
                    self.Shadow.Position = newPos + UDim2.new(0, 5, 0, 5)
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    -- Resizing
    if self.Config.Resizable then
        local resizing = false
        local resizeStart
        local startSize
        
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
            self:Destroy()
        end)
    end
end

function Window:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    local targetHeight = self.IsMinimized and 45 or self.Config.Size.Y.Offset
    
    TweenService:Create(self.MainFrame, TweenInfo.new(self.Config.AnimationSpeed, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, self.Config.Size.X.Offset, 0, targetHeight)
    }):Play()
    
    self.MinimizeBtn.Text = self.IsMinimized and "□" or "─"
end

function Window:ToggleMaximize()
    if self.IsMaximized then
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
    self.ScreenGui.Enabled = true
end

function Window:Hide()
    self.IsVisible = false
    self.ScreenGui.Enabled = false
end

function Window:Destroy()
    self.ScreenGui:Destroy()
    for i, window in ipairs(ActiveWindows) do
        if window == self then
            table.remove(ActiveWindows, i)
            break
        end
    end
end

function Window:CreateTab(tabName)
    local self = self
    local tab = {}
    
    tab.Name = tabName
    tab.Parent = self
    
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
    
    CreateCorner(tab.Button, 6)
    
    -- Tab Page (ScrollingFrame for content)
    tab.Page = Instance.new("ScrollingFrame")
    tab.Page.Name = "Page_" .. tabName
    tab.Page.Parent = self.PagesFolder
    tab.Page.BackgroundTransparency = 1
    tab.Page.Size = UDim2.new(1, 0, 1, 0)
    tab.Page.ScrollBarThickness = 5
    tab.Page.ScrollBarImageColor3 = self.Config.MainColor
    tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Page.Visible = false
    
    -- Page layout
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
        task.wait()
        local contentSize = pageList.AbsoluteContentSize
        tab.Page.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end
    
    pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    tab.Page.ChildAdded:Connect(updateCanvas)
    tab.Page.ChildRemoved:Connect(updateCanvas)
    updateCanvas()
    
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
    
    -- Element creation methods
    function tab:CreateSection(sectionName)
        local section = Instance.new("Frame")
        section.Name = "Section_" .. sectionName
        section.Parent = self.Page
        section.BackgroundColor3 = self.Parent.Config.SurfaceColor
        section.BackgroundTransparency = 0
        section.Size = UDim2.new(1, -20, 0, 40)
        section.BorderSizePixel = 0
        section.AutomaticSize = Enum.AutomaticSize.Y
        
        CreateCorner(section, self.Parent.Config.CornerRadius)
        
        local sectionTitle = Instance.new("TextLabel")
        sectionTitle.Parent = section
        sectionTitle.BackgroundTransparency = 1
        sectionTitle.Size = UDim2.new(1, -20, 0, 30)
        sectionTitle.Position = UDim2.new(0, 10, 0, 0)
        sectionTitle.Font = Enum.Font.GothamBold
        sectionTitle.Text = sectionName
        sectionTitle.TextColor3 = self.Parent.Config.MainColor
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
        
        return section
    end
    
    function tab:TextLabel(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, config.Height or 30)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.Font = config.Font or Enum.Font.GothamSemibold
        label.Text = config.Text or ""
        label.TextColor3 = config.Color or self.Parent.Config.TextColor
        label.TextSize = config.Size or 14
        label.TextXAlignment = config.XAlign or Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        return frame
    end
    
    function tab:Button(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local button = Instance.new("TextButton")
        button.Parent = frame
        button.BackgroundColor3 = config.Color or self.Parent.Config.MainColor
        button.Size = UDim2.new(0, config.Width or 120, 0, 35)
        button.Position = UDim2.new(0, 10, 0.5, -17.5)
        button.Font = Enum.Font.GothamSemibold
        button.Text = config.Text or "Button"
        button.TextColor3 = self.Parent.Config.TextColor
        button.TextSize = 14
        button.AutoButtonColor = false
        
        CreateCorner(button, self.Parent.Config.CornerRadius)
        
        if config.Info then
            local info = Instance.new("TextLabel")
            info.Parent = frame
            info.BackgroundTransparency = 1
            info.Size = UDim2.new(0, 200, 1, 0)
            info.Position = UDim2.new(1, -210, 0, 0)
            info.Font = Enum.Font.Gotham
            info.Text = config.Info
            info.TextColor3 = Color3.fromRGB(150, 150, 150)
            info.TextSize = 12
            info.TextXAlignment = Enum.TextXAlignment.Right
            info.TextYAlignment = Enum.TextYAlignment.Center
        end
        
        button.MouseButton1Click:Connect(function()
            if config.Callback then
                config.Callback()
            end
        end)
        
        return frame
    end
    
    function tab:Toggle(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Toggle"
        label.TextColor3 = self.Parent.Config.TextColor
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
        toggleCircle.BackgroundColor3 = self.Parent.Config.TextColor
        toggleCircle.Size = UDim2.new(0, 22, 0, 22)
        toggleCircle.Position = UDim2.new(0, 2, 0, 2)
        toggleCircle.BorderSizePixel = 0
        
        CreateCorner(toggleCircle, 11)
        
        local state = config.Default or false
        
        local function updateToggle()
            local targetPos = state and 26 or 2
            local targetColor = state and self.Parent.Config.MainColor or Color3.fromRGB(50, 50, 55)
            
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
        
        updateToggle()
        
        return frame
    end
    
    function tab:Slider(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, 75)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Slider"
        label.TextColor3 = self.Parent.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = frame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.new(0, 100, 0, 25)
        valueLabel.Position = UDim2.new(1, -115, 0, 5)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.Text = tostring(config.Default or config.Min or 0)
        valueLabel.TextColor3 = self.Parent.Config.MainColor
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = frame
        sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        sliderFrame.Size = UDim2.new(1, -30, 0, 4)
        sliderFrame.Position = UDim2.new(0, 15, 0, 45)
        sliderFrame.BorderSizePixel = 0
        
        CreateCorner(sliderFrame, 2)
        
        local fill = Instance.new("Frame")
        fill.Parent = sliderFrame
        fill.BackgroundColor3 = self.Parent.Config.MainColor
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BorderSizePixel = 0
        
        CreateCorner(fill, 2)
        
        local handle = Instance.new("Frame")
        handle.Parent = sliderFrame
        handle.BackgroundColor3 = self.Parent.Config.MainColor
        handle.Size = UDim2.new(0, 14, 0, 14)
        handle.Position = UDim2.new(0, -7, 0.5, -7)
        handle.BorderSizePixel = 0
        
        CreateCorner(handle, 7)
        
        local min = config.Min or 0
        local max = config.Max or 100
        local decimals = config.Decimals or 0
        local value = config.Default or min
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * relativeX
            if decimals > 0 then
                value = math.floor(newValue * (10^decimals) + 0.5) / (10^decimals)
            else
                value = math.floor(newValue + 0.5)
            end
            valueLabel.Text = tostring(value)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            handle.Position = UDim2.new(relativeX, -7, 0.5, -7)
            
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
            handle.Position = UDim2.new(initValue, -7, 0.5, -7)
            valueLabel.Text = tostring(config.Default)
        end
        
        return frame
    end
    
    function tab:Dropdown(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Dropdown"
        label.TextColor3 = self.Parent.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Parent = frame
        dropdownBtn.BackgroundColor3 = self.Parent.Config.SurfaceColor
        dropdownBtn.Size = UDim2.new(0, 180, 0, 35)
        dropdownBtn.Position = UDim2.new(1, -195, 0.5, -17.5)
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.Text = config.Default or "Select option"
        dropdownBtn.TextColor3 = self.Parent.Config.TextColor
        dropdownBtn.TextSize = 13
        dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        CreateCorner(dropdownBtn, self.Parent.Config.CornerRadius)
        
        local arrow = Instance.new("TextLabel")
        arrow.Parent = dropdownBtn
        arrow.BackgroundTransparency = 1
        arrow.Size = UDim2.new(0, 30, 1, 0)
        arrow.Position = UDim2.new(1, -30, 0, 0)
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = "▼"
        arrow.TextColor3 = self.Parent.Config.TextColor
        arrow.TextSize = 12
        
        local expanded = false
        local optionsFrame = Instance.new("Frame")
        optionsFrame.Parent = frame
        optionsFrame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        optionsFrame.Size = UDim2.new(0, 180, 0, 0)
        optionsFrame.Position = UDim2.new(1, -195, 0.5, 17.5)
        optionsFrame.BorderSizePixel = 0
        optionsFrame.ClipsDescendants = true
        
        CreateCorner(optionsFrame, self.Parent.Config.CornerRadius)
        
        local optionsList = Instance.new("UIListLayout")
        optionsList.Parent = optionsFrame
        optionsList.Padding = UDim.new(0, 2)
        
        for _, option in ipairs(config.Options or {}) do
            local btn = Instance.new("TextButton")
            btn.Parent = optionsFrame
            btn.BackgroundColor3 = self.Parent.Config.SurfaceColor
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Font = Enum.Font.Gotham
            btn.Text = option
            btn.TextColor3 = self.Parent.Config.TextColor
            btn.TextSize = 13
            btn.AutoButtonColor = false
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = self.Parent.Config.MainColor
                btn.BackgroundTransparency = 0.3
            end)
            
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = self.Parent.Config.SurfaceColor
            end)
            
            btn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                if config.Callback then
                    config.Callback(option)
                end
                expanded = false
                TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 180, 0, 0)
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
                local numOptions = #(config.Options or {})
                TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 180, 0, numOptions * 35)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, 0, 0, 45 + (numOptions * 35))
                }):Play()
                arrow.Text = "▲"
            else
                TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, 180, 0, 0)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
                arrow.Text = "▼"
            end
        end)
        
        return frame
    end
    
    function tab:TextBox(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Text Box"
        label.TextColor3 = self.Parent.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local box = Instance.new("TextBox")
        box.Parent = frame
        box.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        box.Size = UDim2.new(0, 180, 0, 35)
        box.Position = UDim2.new(1, -195, 0.5, -17.5)
        box.Font = Enum.Font.Gotham
        box.PlaceholderText = config.Placeholder or ""
        box.Text = config.Default or ""
        box.TextColor3 = self.Parent.Config.TextColor
        box.TextSize = 13
        
        CreateCorner(box, self.Parent.Config.CornerRadius)
        
        box.FocusLost:Connect(function(enterPressed)
            if enterPressed and config.Callback then
                config.Callback(box.Text)
            end
        end)
        
        return frame
    end
    
    function tab:Keybind(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.SurfaceColor
        frame.BackgroundTransparency = 0
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        CreateCorner(frame, self.Parent.Config.CornerRadius)
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Keybind"
        label.TextColor3 = self.Parent.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = frame
        keyBtn.BackgroundColor3 = self.Parent.Config.MainColor
        keyBtn.Size = UDim2.new(0, 100, 0, 35)
        keyBtn.Position = UDim2.new(1, -115, 0.5, -17.5)
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.Text = config.Default or "None"
        keyBtn.TextColor3 = self.Parent.Config.TextColor
        keyBtn.TextSize = 13
        
        CreateCorner(keyBtn, self.Parent.Config.CornerRadius)
        
        local currentKey = config.Default
        local listening = false
        
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
            keyBtn.BackgroundColor3 = self.Parent.Config.SecondaryColor
        end)
        
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and not gameProcessed then
                local key = input.KeyCode.Name
                if key ~= "Unknown" then
                    currentKey = key
                    keyBtn.Text = key
                    listening = false
                    keyBtn.BackgroundColor3 = self.Parent.Config.MainColor
                    if config.Callback then
                        config.Callback(key)
                    end
                end
            end
        end)
        
        if config.OnPress then
            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if not listening and not gameProcessed and currentKey then
                    if input.KeyCode.Name == currentKey then
                        config.OnPress()
                    end
                end
            end)
        end
        
        return frame
    end
    
    function tab:Separator()
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Parent.Config.MainColor
        frame.BackgroundTransparency = 0.3
        frame.Size = UDim2.new(1, 0, 0, 1)
        frame.BorderSizePixel = 0
        
        return frame
    end
    
    function tab:Notification(config)
        local notificationFrame = Instance.new("Frame")
        notificationFrame.Parent = self.Parent.ScreenGui
        notificationFrame.BackgroundColor3 = config.Color or self.Parent.Config.MainColor
        notificationFrame.Size = UDim2.new(0, 300, 0, 60)
        notificationFrame.Position = UDim2.new(1, -320, 0, 10)
        notificationFrame.BorderSizePixel = 0
        notificationFrame.ZIndex = 20
        
        CreateCorner(notificationFrame, self.Parent.Config.CornerRadius)
        
        local title = Instance.new("TextLabel")
        title.Parent = notificationFrame
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Title or "Notification"
        title.TextColor3 = self.Parent.Config.TextColor
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local message = Instance.new("TextLabel")
        message.Parent = notificationFrame
        message.BackgroundTransparency = 1
        message.Size = UDim2.new(1, -20, 0, 25)
        message.Position = UDim2.new(0, 10, 0, 30)
        message.Font = Enum.Font.Gotham
        message.Text = config.Message or ""
        message.TextColor3 = Color3.fromRGB(200, 200, 200)
        message.TextSize = 12
        message.TextXAlignment = Enum.TextXAlignment.Left
        
        notificationFrame.Position = UDim2.new(1, -10, 0, 10)
        TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -320, 0, 10)
        }):Play()
        
        task.delay(config.Duration or 3, function()
            TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, -10, 0, 10)
            }):Play()
            task.wait(0.3)
            notificationFrame:Destroy()
        end)
        
        return notificationFrame
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.CurrentTab == tab then return end
    
    -- Update button colors
    for _, t in ipairs(self.Tabs) do
        TweenService:Create(t.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = self.Config.SurfaceColor
        }):Play()
    end
    
    TweenService:Create(tab.Button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundColor3 = self.Config.MainColor
    }):Play()
    
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

return Nebula
