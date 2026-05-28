local Nebula = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ActiveWindows = {}

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(name, config)
    local self = setmetatable({}, Window)
    
    config = config or {}
    
    self.Name = name or "Nebula"
    self.Config = {
        Size = config.Size or UDim2.new(0, 550, 0, 450),
        Position = config.Position or UDim2.new(0.5, -275, 0.5, -225),
        MainColor = config.MainColor or Color3.fromRGB(138, 43, 226),
        BackgroundColor = config.BackgroundColor or Color3.fromRGB(20, 20, 25),
        SurfaceColor = config.SurfaceColor or Color3.fromRGB(30, 30, 35),
        TextColor = config.TextColor or Color3.fromRGB(255, 255, 255),
        CornerRadius = config.CornerRadius or 8,
    }
    
    self.Tabs = {}
    self.CurrentTab = nil
    self.Visible = true
    
    self:CreateUI()
    self:SetupDragging()
    
    return self
end

function Window:CreateUI()
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Nebula_" .. self.Name
    self.ScreenGui.Parent = game.CoreGui
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Parent = self.ScreenGui
    self.MainFrame.BackgroundColor3 = self.Config.BackgroundColor
    self.MainFrame.Position = self.Config.Position
    self.MainFrame.Size = self.Config.Size
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    corner.Parent = self.MainFrame
    
    -- Top Bar
    self.TopBar = Instance.new("Frame")
    self.TopBar.Parent = self.MainFrame
    self.TopBar.BackgroundColor3 = self.Config.MainColor
    self.TopBar.Size = UDim2.new(1, 0, 0, 40)
    self.TopBar.BorderSizePixel = 0
    
    local topCorner = Instance.new("UICorner")
    topCorner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    topCorner.Parent = self.TopBar
    
    -- Title
    self.Title = Instance.new("TextLabel")
    self.Title.Parent = self.TopBar
    self.Title.BackgroundTransparency = 1
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.Size = UDim2.new(0, 200, 1, 0)
    self.Title.Font = Enum.Font.GothamBold
    self.Title.Text = self.Name
    self.Title.TextColor3 = self.Config.TextColor
    self.Title.TextSize = 16
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    self.CloseBtn = Instance.new("TextButton")
    self.CloseBtn.Parent = self.TopBar
    self.CloseBtn.BackgroundTransparency = 1
    self.CloseBtn.Size = UDim2.new(0, 40, 1, 0)
    self.CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    self.CloseBtn.Font = Enum.Font.GothamBold
    self.CloseBtn.Text = "✕"
    self.CloseBtn.TextColor3 = self.Config.TextColor
    self.CloseBtn.TextSize = 18
    self.CloseBtn.AutoButtonColor = false
    self.CloseBtn.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Tab Container (Left Side)
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Parent = self.MainFrame
    self.TabContainer.BackgroundColor3 = self.Config.SurfaceColor
    self.TabContainer.Position = UDim2.new(0, 0, 0, 40)
    self.TabContainer.Size = UDim2.new(0, 120, 1, -40)
    self.TabContainer.BorderSizePixel = 0
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    tabCorner.Parent = self.TabContainer
    
    -- Content Container (Right Side)
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.BackgroundColor3 = self.Config.BackgroundColor
    self.ContentContainer.Position = UDim2.new(0, 125, 0, 45)
    self.ContentContainer.Size = UDim2.new(1, -130, 1, -50)
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ClipsDescendants = true
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, self.Config.CornerRadius)
    contentCorner.Parent = self.ContentContainer
    
    -- Pages Folder
    self.PagesFolder = Instance.new("Folder")
    self.PagesFolder.Parent = self.ContentContainer
    
    -- Tab Layout
    self.TabLayout = Instance.new("UIListLayout")
    self.TabLayout.Parent = self.TabContainer
    self.TabLayout.Padding = UDim.new(0, 5)
    self.TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.Parent = self.TabContainer
    tabPadding.PaddingTop = UDim.new(0, 10)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
end

function Window:SetupDragging()
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
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

function Window:CreateTab(tabName)
    local self = self
    local tab = {}
    
    tab.Name = tabName
    tab.Window = self
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Parent = self.TabContainer
    tab.Button.BackgroundColor3 = self.Config.SurfaceColor
    tab.Button.Size = UDim2.new(1, 0, 0, 35)
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.Text = tabName
    tab.Button.TextColor3 = self.Config.TextColor
    tab.Button.TextSize = 14
    tab.Button.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = tab.Button
    
    -- Tab Page (Scrolling Frame)
    tab.Page = Instance.new("ScrollingFrame")
    tab.Page.Parent = self.PagesFolder
    tab.Page.BackgroundTransparency = 1
    tab.Page.Size = UDim2.new(1, 0, 1, 0)
    tab.Page.ScrollBarThickness = 4
    tab.Page.ScrollBarImageColor3 = self.Config.MainColor
    tab.Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.Page.Visible = false
    
    -- Page Layout
    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = tab.Page
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.Parent = tab.Page
    pagePadding.PaddingTop = UDim.new(0, 10)
    pagePadding.PaddingLeft = UDim.new(0, 10)
    pagePadding.PaddingRight = UDim.new(0, 10)
    pagePadding.PaddingBottom = UDim.new(0, 10)
    
    -- Update canvas size when content changes
    local function updateCanvas()
        task.wait()
        local contentHeight = pageLayout.AbsoluteContentSize.Y
        tab.Page.CanvasSize = UDim2.new(0, 0, 0, contentHeight + 20)
    end
    
    pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    tab.Page.ChildAdded:Connect(updateCanvas)
    tab.Page.ChildRemoved:Connect(updateCanvas)
    
    -- Tab click handler
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    if not self.CurrentTab then
        self:SelectTab(tab)
    end
    
    -- ============ UI ELEMENTS ============
    
    function tab:CreateSection(title)
        local section = Instance.new("Frame")
        section.Parent = self.Page
        section.BackgroundColor3 = self.Window.Config.SurfaceColor
        section.Size = UDim2.new(1, 0, 0, 40)
        section.BorderSizePixel = 0
        section.AutomaticSize = Enum.AutomaticSize.Y
        
        local sectionCorner = Instance.new("UICorner")
        sectionCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        sectionCorner.Parent = section
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Parent = section
        titleLabel.BackgroundTransparency = 1
        titleLabel.Size = UDim2.new(1, -20, 0, 30)
        titleLabel.Position = UDim2.new(0, 10, 0, 5)
        titleLabel.Font = Enum.Font.GothamBold
        titleLabel.Text = title
        titleLabel.TextColor3 = self.Window.Config.MainColor
        titleLabel.TextSize = 14
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local sectionLayout = Instance.new("UIListLayout")
        sectionLayout.Parent = section
        sectionLayout.Padding = UDim.new(0, 5)
        sectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local sectionPadding = Instance.new("UIPadding")
        sectionPadding.Parent = section
        sectionPadding.PaddingTop = UDim.new(0, 35)
        sectionPadding.PaddingLeft = UDim.new(0, 10)
        sectionPadding.PaddingRight = UDim.new(0, 10)
        sectionPadding.PaddingBottom = UDim.new(0, 10)
        
        return section
    end
    
    function tab:Button(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Window.Config.SurfaceColor
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        frameCorner.Parent = frame
        
        local button = Instance.new("TextButton")
        button.Parent = frame
        button.BackgroundColor3 = config.Color or self.Window.Config.MainColor
        button.Size = UDim2.new(0, config.Width or 120, 0, 35)
        button.Position = UDim2.new(0, 10, 0.5, -17.5)
        button.Font = Enum.Font.GothamSemibold
        button.Text = config.Text or "Button"
        button.TextColor3 = self.Window.Config.TextColor
        button.TextSize = 14
        button.AutoButtonColor = false
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        
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
        frame.BackgroundColor3 = self.Window.Config.SurfaceColor
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Toggle"
        label.TextColor3 = self.Window.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Parent = frame
        toggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        toggleFrame.Size = UDim2.new(0, 50, 0, 26)
        toggleFrame.Position = UDim2.new(1, -60, 0.5, -13)
        toggleFrame.BorderSizePixel = 0
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 13)
        toggleCorner.Parent = toggleFrame
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Parent = toggleFrame
        toggleCircle.BackgroundColor3 = self.Window.Config.TextColor
        toggleCircle.Size = UDim2.new(0, 22, 0, 22)
        toggleCircle.Position = UDim2.new(0, 2, 0, 2)
        toggleCircle.BorderSizePixel = 0
        
        local circleCorner = Instance.new("UICorner")
        circleCorner.CornerRadius = UDim.new(0, 11)
        circleCorner.Parent = toggleCircle
        
        local state = config.Default or false
        
        local function updateToggle()
            local targetPos = state and 26 or 2
            local targetColor = state and self.Window.Config.MainColor or Color3.fromRGB(50, 50, 55)
            
            TweenService:Create(toggleCircle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, targetPos, 0, 2)
            }):Play()
            
            TweenService:Create(toggleFrame, TweenInfo.new(0.2), {
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
        frame.BackgroundColor3 = self.Window.Config.SurfaceColor
        frame.Size = UDim2.new(1, 0, 0, 75)
        frame.BorderSizePixel = 0
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 0, 25)
        label.Position = UDim2.new(0, 15, 0, 5)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Slider"
        label.TextColor3 = self.Window.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Parent = frame
        valueLabel.BackgroundTransparency = 1
        valueLabel.Size = UDim2.new(0, 100, 0, 25)
        valueLabel.Position = UDim2.new(1, -115, 0, 5)
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextColor3 = self.Window.Config.MainColor
        valueLabel.TextSize = 14
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Parent = frame
        sliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
        sliderFrame.Size = UDim2.new(1, -30, 0, 4)
        sliderFrame.Position = UDim2.new(0, 15, 0, 45)
        sliderFrame.BorderSizePixel = 0
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 2)
        sliderCorner.Parent = sliderFrame
        
        local fill = Instance.new("Frame")
        fill.Parent = sliderFrame
        fill.BackgroundColor3 = self.Window.Config.MainColor
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.BorderSizePixel = 0
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 2)
        fillCorner.Parent = fill
        
        local handle = Instance.new("Frame")
        handle.Parent = sliderFrame
        handle.BackgroundColor3 = self.Window.Config.MainColor
        handle.Size = UDim2.new(0, 14, 0, 14)
        handle.Position = UDim2.new(0, -7, 0.5, -7)
        handle.BorderSizePixel = 0
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(0, 7)
        handleCorner.Parent = handle
        
        local min = config.Min or 0
        local max = config.Max or 100
        local decimals = config.Decimals or 0
        local value = config.Default or min
        
        valueLabel.Text = tostring(value)
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
            local newValue = min + (max - min) * relativeX
            
            if decimals > 0 then
                value = math.floor(newValue * (10^decimals) + 0.5) / (10^decimals)
            else
                value = math.floor(newValue + 0.5)
            end
            
            value = math.clamp(value, min, max)
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
        
        -- Initialize slider position
        if config.Default then
            local initValue = (config.Default - min) / (max - min)
            fill.Size = UDim2.new(initValue, 0, 1, 0)
            handle.Position = UDim2.new(initValue, -7, 0.5, -7)
        end
        
        return frame
    end
    
    function tab:Dropdown(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundColor3 = self.Window.Config.SurfaceColor
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Dropdown"
        label.TextColor3 = self.Window.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local dropdownBtn = Instance.new("TextButton")
        dropdownBtn.Parent = frame
        dropdownBtn.BackgroundColor3 = self.Window.Config.SurfaceColor
        dropdownBtn.Size = UDim2.new(0, 180, 0, 35)
        dropdownBtn.Position = UDim2.new(1, -195, 0.5, -17.5)
        dropdownBtn.Font = Enum.Font.Gotham
        dropdownBtn.Text = config.Default or "Select option"
        dropdownBtn.TextColor3 = self.Window.Config.TextColor
        dropdownBtn.TextSize = 13
        dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
        
        local dropdownCorner = Instance.new("UICorner")
        dropdownCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        dropdownCorner.Parent = dropdownBtn
        
        local arrow = Instance.new("TextLabel")
        arrow.Parent = dropdownBtn
        arrow.BackgroundTransparency = 1
        arrow.Size = UDim2.new(0, 30, 1, 0)
        arrow.Position = UDim2.new(1, -30, 0, 0)
        arrow.Font = Enum.Font.GothamBold
        arrow.Text = "▼"
        arrow.TextColor3 = self.Window.Config.TextColor
        arrow.TextSize = 12
        
        local expanded = false
        local optionsFrame = Instance.new("ScrollingFrame")
        optionsFrame.Parent = frame
        optionsFrame.BackgroundColor3 = self.Window.Config.SurfaceColor
        optionsFrame.Size = UDim2.new(0, 180, 0, 0)
        optionsFrame.Position = UDim2.new(1, -195, 0.5, 17.5)
        optionsFrame.BorderSizePixel = 0
        optionsFrame.ClipsDescendants = true
        optionsFrame.ScrollBarThickness = 3
        
        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        optionsCorner.Parent = optionsFrame
        
        local optionsLayout = Instance.new("UIListLayout")
        optionsLayout.Parent = optionsFrame
        optionsLayout.Padding = UDim.new(0, 2)
        
        local options = config.Options or {}
        
        for _, option in ipairs(options) do
            local btn = Instance.new("TextButton")
            btn.Parent = optionsFrame
            btn.BackgroundColor3 = self.Window.Config.SurfaceColor
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Font = Enum.Font.Gotham
            btn.Text = option
            btn.TextColor3 = self.Window.Config.TextColor
            btn.TextSize = 13
            btn.AutoButtonColor = false
            
            btn.MouseEnter:Connect(function()
                btn.BackgroundColor3 = self.Window.Config.MainColor
                btn.BackgroundTransparency = 0.7
            end)
            
            btn.MouseLeave:Connect(function()
                btn.BackgroundColor3 = self.Window.Config.SurfaceColor
            end)
            
            btn.MouseButton1Click:Connect(function()
                dropdownBtn.Text = option
                expanded = false
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 180, 0, 0)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, 45)
                }):Play()
                arrow.Text = "▼"
                
                if config.Callback then
                    config.Callback(option)
                end
            end)
        end
        
        dropdownBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                local totalHeight = #options * 35
                local maxHeight = math.min(totalHeight, 200)
                optionsFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 180, 0, maxHeight)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2), {
                    Size = UDim2.new(1, 0, 0, 45 + maxHeight)
                }):Play()
                arrow.Text = "▲"
            else
                TweenService:Create(optionsFrame, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 180, 0, 0)
                }):Play()
                TweenService:Create(frame, TweenInfo.new(0.2), {
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
        frame.BackgroundColor3 = self.Window.Config.SurfaceColor
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Text Box"
        label.TextColor3 = self.Window.Config.TextColor
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
        box.TextColor3 = self.Window.Config.TextColor
        box.TextSize = 13
        
        local boxCorner = Instance.new("UICorner")
        boxCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        boxCorner.Parent = box
        
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
        frame.BackgroundColor3 = self.Window.Config.SurfaceColor
        frame.Size = UDim2.new(1, 0, 0, 45)
        frame.BorderSizePixel = 0
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        frameCorner.Parent = frame
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 200, 1, 0)
        label.Position = UDim2.new(0, 15, 0, 0)
        label.Font = Enum.Font.GothamSemibold
        label.Text = config.Text or "Keybind"
        label.TextColor3 = self.Window.Config.TextColor
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        local keyBtn = Instance.new("TextButton")
        keyBtn.Parent = frame
        keyBtn.BackgroundColor3 = self.Window.Config.MainColor
        keyBtn.Size = UDim2.new(0, 100, 0, 35)
        keyBtn.Position = UDim2.new(1, -115, 0.5, -17.5)
        keyBtn.Font = Enum.Font.GothamBold
        keyBtn.Text = config.Default or "None"
        keyBtn.TextColor3 = self.Window.Config.TextColor
        keyBtn.TextSize = 13
        
        local keyCorner = Instance.new("UICorner")
        keyCorner.CornerRadius = UDim.new(0, 6)
        keyCorner.Parent = keyBtn
        
        local currentKey = config.Default
        local listening = false
        
        keyBtn.MouseButton1Click:Connect(function()
            listening = true
            keyBtn.Text = "..."
            keyBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        end)
        
        local inputConnection
        inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and not gameProcessed then
                local key = input.KeyCode.Name
                if key ~= "Unknown" then
                    currentKey = key
                    keyBtn.Text = key
                    listening = false
                    keyBtn.BackgroundColor3 = self.Window.Config.MainColor
                    
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
        frame.BackgroundColor3 = self.Window.Config.MainColor
        frame.BackgroundTransparency = 0.5
        frame.Size = UDim2.new(1, 0, 0, 1)
        frame.BorderSizePixel = 0
        
        return frame
    end
    
    function tab:TextLabel(config)
        local frame = Instance.new("Frame")
        frame.Parent = self.Page
        frame.BackgroundTransparency = 1
        frame.Size = UDim2.new(1, 0, 0, config.Height or 25)
        frame.BorderSizePixel = 0
        
        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Font = config.Font or Enum.Font.Gotham
        label.Text = config.Text or ""
        label.TextColor3 = config.Color or self.Window.Config.TextColor
        label.TextSize = config.Size or 14
        label.TextXAlignment = config.XAlign or Enum.TextXAlignment.Left
        label.TextYAlignment = Enum.TextYAlignment.Center
        
        return frame
    end
    
    function tab:Notification(config)
        local notification = Instance.new("Frame")
        notification.Parent = self.Window.ScreenGui
        notification.BackgroundColor3 = config.Color or self.Window.Config.MainColor
        notification.Size = UDim2.new(0, 300, 0, 60)
        notification.Position = UDim2.new(1, -10, 0, 10)
        notification.BorderSizePixel = 0
        notification.ZIndex = 100
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, self.Window.Config.CornerRadius)
        notifCorner.Parent = notification
        
        local title = Instance.new("TextLabel")
        title.Parent = notification
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1, -20, 0, 25)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.Font = Enum.Font.GothamBold
        title.Text = config.Title or "Notification"
        title.TextColor3 = self.Window.Config.TextColor
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        
        local message = Instance.new("TextLabel")
        message.Parent = notification
        message.BackgroundTransparency = 1
        message.Size = UDim2.new(1, -20, 0, 25)
        message.Position = UDim2.new(0, 10, 0, 30)
        message.Font = Enum.Font.Gotham
        message.Text = config.Message or ""
        message.TextColor3 = Color3.fromRGB(200, 200, 200)
        message.TextSize = 12
        message.TextXAlignment = Enum.TextXAlignment.Left
        
        TweenService:Create(notification, TweenInfo.new(0.3), {
            Position = UDim2.new(1, -320, 0, 10)
        }):Play()
        
        task.delay(config.Duration or 3, function()
            TweenService:Create(notification, TweenInfo.new(0.3), {
                Position = UDim2.new(1, -10, 0, 10)
            }):Play()
            task.wait(0.3)
            notification:Destroy()
        end)
        
        return notification
    end
    
    return tab
end

function Window:SelectTab(tab)
    if self.CurrentTab == tab then return end
    
    for _, t in ipairs(self.Tabs) do
        t.Button.BackgroundColor3 = self.Config.SurfaceColor
        t.Page.Visible = false
    end
    
    tab.Button.BackgroundColor3 = self.Config.MainColor
    tab.Page.Visible = true
    
    self.CurrentTab = tab
end

function Window:Show()
    self.ScreenGui.Enabled = true
    self.Visible = true
end

function Window:Hide()
    self.ScreenGui.Enabled = false
    self.Visible = false
end

function Window:Destroy()
    self.ScreenGui:Destroy()
    for i, w in ipairs(ActiveWindows) do
        if w == self then
            table.remove(ActiveWindows, i)
            break
        end
    end
end

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
