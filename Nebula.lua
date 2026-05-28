-- ==============================================
-- 🌟 NEBULA LITE - ULTRA COMPATIBLE UI FRAMEWORK 🌟
-- 100% Working on ALL Roblox Executors
-- No complex effects, just pure functionality!
-- ==============================================

local NebulaLite = {}

-- Simple UI Settings
local Settings = {
    Theme = {
        Primary = Color3.fromRGB(138, 43, 226),   -- Purple
        Secondary = Color3.fromRGB(75, 0, 130),   -- Dark Purple
        Background = Color3.fromRGB(25, 25, 35),  -- Dark background
        Surface = Color3.fromRGB(35, 35, 45),     -- Slightly lighter
        Text = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(180, 180, 180)
    }
}

-- ============== SIMPLE WINDOW SYSTEM ==============
function NebulaLite:CreateWindow(title, options)
    options = options or {}
    
    local window = {}
    
    -- Create GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NebulaLite_" .. tostring(os.time())
    screenGui.Parent = game.CoreGui
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Settings.Theme.Background
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.BorderSizePixel = 0
    
    -- Simple corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Settings.Theme.Primary
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Size = UDim2.new(0, 200, 1, 0)
    titleText.Font = Enum.Font.GothamBold
    titleText.Text = title
    titleText.TextColor3 = Settings.Theme.Text
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.BackgroundTransparency = 1
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Settings.Theme.Text
    closeBtn.TextSize = 20
    
    -- Tab Container
    local tabContainer = Instance.new("Frame")
    tabContainer.Parent = mainFrame
    tabContainer.BackgroundColor3 = Settings.Theme.Surface
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.Size = UDim2.new(0, 150, 1, -40)
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.Parent = tabContainer
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Parent = mainFrame
    contentContainer.BackgroundColor3 = Settings.Theme.Background
    contentContainer.Position = UDim2.new(0, 150, 0, 40)
    contentContainer.Size = UDim2.new(1, -150, 1, -40)
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    window.tabs = {}
    window.currentTab = nil
    window.mainFrame = mainFrame
    
    -- Tab creation function
    function window:CreateTab(tabName)
        local tab = {}
        
        -- Tab button
        local tabBtn = Instance.new("TextButton")
        tabBtn.Parent = tabContainer
        tabBtn.BackgroundColor3 = Settings.Theme.Background
        tabBtn.Size = UDim2.new(1, -10, 0, 40)
        tabBtn.Position = UDim2.new(0, 5, 0, (#window.tabs * 45) + 5)
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Settings.Theme.TextDim
        tabBtn.TextSize = 14
        tabBtn.BorderSizePixel = 0
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn
        
        -- Content frame for this tab
        local contentFrame = Instance.new("ScrollingFrame")
        contentFrame.Parent = contentContainer
        contentFrame.BackgroundTransparency = 1
        contentFrame.Size = UDim2.new(1, -20, 1, -20)
        contentFrame.Position = UDim2.new(0, 10, 0, 10)
        contentFrame.ScrollBarThickness = 5
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        contentFrame.Visible = false
        
        local contentList = Instance.new("UIListLayout")
        contentList.Parent = contentFrame
        contentList.Padding = UDim.new(0, 8)
        contentList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        -- Update canvas size
        local function updateCanvas()
            local size = contentList.AbsoluteContentSize
            contentFrame.CanvasSize = UDim2.new(0, 0, 0, size.Y + 20)
        end
        
        contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, btn in pairs(tabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Settings.Theme.Background
                    btn.TextColor3 = Settings.Theme.TextDim
                end
            end
            for _, frame in pairs(contentContainer:GetChildren()) do
                if frame:IsA("ScrollingFrame") then
                    frame.Visible = false
                end
            end
            tabBtn.BackgroundColor3 = Settings.Theme.Primary
            tabBtn.TextColor3 = Settings.Theme.Text
            contentFrame.Visible = true
            updateCanvas()
        end)
        
        -- Make first tab active
        if #window.tabs == 0 then
            tabBtn.BackgroundColor3 = Settings.Theme.Primary
            tabBtn.TextColor3 = Settings.Theme.Text
            contentFrame.Visible = true
        end
        
        table.insert(window.tabs, tabBtn)
        
        -- Element functions
        function tab:Label(text)
            local label = Instance.new("TextLabel")
            label.Parent = contentFrame
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(0.95, 0, 0, 30)
            label.Font = Enum.Font.GothamBold
            label.Text = text
            label.TextColor3 = Settings.Theme.Primary
            label.TextSize = 16
            label.TextXAlignment = Enum.TextXAlignment.Center
            updateCanvas()
            return label
        end
        
        function tab:Separator()
            local line = Instance.new("Frame")
            line.Parent = contentFrame
            line.BackgroundColor3 = Settings.Theme.Primary
            line.BackgroundTransparency = 0.5
            line.Size = UDim2.new(0.95, 0, 0, 2)
            updateCanvas()
            return line
        end
        
        function tab:Button(text, callback)
            local btnFrame = Instance.new("Frame")
            btnFrame.Parent = contentFrame
            btnFrame.BackgroundColor3 = Settings.Theme.Surface
            btnFrame.Size = UDim2.new(0.95, 0, 0, 45)
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = btnFrame
            
            local button = Instance.new("TextButton")
            button.Parent = btnFrame
            button.BackgroundColor3 = Settings.Theme.Primary
            button.Size = UDim2.new(0, 120, 0, 30)
            button.Position = UDim2.new(0, 15, 0, 7.5)
            button.Font = Enum.Font.GothamSemibold
            button.Text = text
            button.TextColor3 = Settings.Theme.Text
            button.TextSize = 14
            button.BorderSizePixel = 0
            
            local btnCorner2 = Instance.new("UICorner")
            btnCorner2.CornerRadius = UDim.new(0, 6)
            btnCorner2.Parent = button
            
            button.MouseButton1Click:Connect(callback)
            updateCanvas()
            return button
        end
        
        function tab:Toggle(text, default, callback)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Parent = contentFrame
            toggleFrame.BackgroundColor3 = Settings.Theme.Surface
            toggleFrame.Size = UDim2.new(0.95, 0, 0, 45)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = toggleFrame
            
            local label = Instance.new("TextLabel")
            label.Parent = toggleFrame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(0, 400, 1, 0)
            label.Font = Enum.Font.GothamSemibold
            label.Text = text
            label.TextColor3 = Settings.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Parent = toggleFrame
            toggleBtn.Position = UDim2.new(1, -55, 0, 10)
            toggleBtn.Size = UDim2.new(0, 40, 0, 25)
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.Text = default and "ON" or "OFF"
            toggleBtn.TextColor3 = Settings.Theme.Text
            toggleBtn.TextSize = 12
            toggleBtn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 12)
            btnCorner.Parent = toggleBtn
            
            local state = default or false
            toggleBtn.BackgroundColor3 = state and Settings.Theme.Primary or Settings.Theme.Background
            
            toggleBtn.MouseButton1Click:Connect(function()
                state = not state
                toggleBtn.Text = state and "ON" or "OFF"
                toggleBtn.BackgroundColor3 = state and Settings.Theme.Primary or Settings.Theme.Background
                callback(state)
            end)
            
            updateCanvas()
            return toggleBtn
        end
        
        function tab:Slider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Parent = contentFrame
            sliderFrame.BackgroundColor3 = Settings.Theme.Surface
            sliderFrame.Size = UDim2.new(0.95, 0, 0, 70)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = sliderFrame
            
            local label = Instance.new("TextLabel")
            label.Parent = sliderFrame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 10)
            label.Size = UDim2.new(0, 400, 0, 20)
            label.Font = Enum.Font.GothamSemibold
            label.Text = text
            label.TextColor3 = Settings.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Parent = sliderFrame
            valueLabel.BackgroundTransparency = 1
            valueLabel.Position = UDim2.new(1, -60, 0, 10)
            valueLabel.Size = UDim2.new(0, 50, 0, 20)
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.Text = tostring(default or min)
            valueLabel.TextColor3 = Settings.Theme.Primary
            valueLabel.TextSize = 14
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Parent = sliderFrame
            sliderBg.Position = UDim2.new(0, 15, 0, 40)
            sliderBg.Size = UDim2.new(1, -30, 0, 4)
            sliderBg.BackgroundColor3 = Settings.Theme.Background
            
            local bgCorner = Instance.new("UICorner")
            bgCorner.CornerRadius = UDim.new(0, 2)
            bgCorner.Parent = sliderBg
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Parent = sliderBg
            sliderFill.Size = UDim2.new((default or min) / max, 0, 1, 0)
            sliderFill.BackgroundColor3 = Settings.Theme.Primary
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(0, 2)
            fillCorner.Parent = sliderFill
            
            local sliderBtn = Instance.new("TextButton")
            sliderBtn.Parent = sliderBg
            sliderBtn.BackgroundColor3 = Settings.Theme.Text
            sliderBtn.Size = UDim2.new(0, 15, 0, 15)
            sliderBtn.Position = UDim2.new((default or min) / max, -7.5, -5.5, 0)
            sliderBtn.Text = ""
            sliderBtn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 15)
            btnCorner.Parent = sliderBtn
            
            local dragging = false
            local currentValue = default or min
            
            local function updateSlider(input)
                local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                currentValue = math.floor(min + (max - min) * relativeX)
                valueLabel.Text = tostring(currentValue)
                sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                sliderBtn.Position = UDim2.new(relativeX, -7.5, -5.5, 0)
                callback(currentValue)
            end
            
            sliderBtn.MouseButton1Down:Connect(function()
                dragging = true
                updateSlider(game:GetService("UserInputService"):GetMouseLocation())
            end)
            
            game:GetService("UserInputService").InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            game:GetService("UserInputService").InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            updateCanvas()
            return sliderFrame
        end
        
        function tab:Dropdown(text, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Parent = contentFrame
            dropdownFrame.BackgroundColor3 = Settings.Theme.Surface
            dropdownFrame.Size = UDim2.new(0.95, 0, 0, 45)
            dropdownFrame.ClipsDescendants = true
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = dropdownFrame
            
            local label = Instance.new("TextLabel")
            label.Parent = dropdownFrame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(0, 200, 1, 0)
            label.Font = Enum.Font.GothamSemibold
            label.Text = text
            label.TextColor3 = Settings.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropdownBtn = Instance.new("TextButton")
            dropdownBtn.Parent = dropdownFrame
            dropdownBtn.BackgroundColor3 = Settings.Theme.Background
            dropdownBtn.Position = UDim2.new(1, -120, 0, 10)
            dropdownBtn.Size = UDim2.new(0, 105, 0, 25)
            dropdownBtn.Font = Enum.Font.Gotham
            dropdownBtn.Text = default or options[1] or "Select"
            dropdownBtn.TextColor3 = Settings.Theme.Text
            dropdownBtn.TextSize = 12
            dropdownBtn.BorderSizePixel = 0
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = dropdownBtn
            
            local expanded = false
            local dropdownList = nil
            
            local function createDropdownList()
                if dropdownList then dropdownList:Destroy() end
                
                dropdownList = Instance.new("Frame")
                dropdownList.Parent = dropdownFrame
                dropdownList.BackgroundColor3 = Settings.Theme.Surface
                dropdownList.Position = UDim2.new(1, -120, 0, 40)
                dropdownList.Size = UDim2.new(0, 105, 0, math.min(#options * 30, 120))
                
                local listCorner = Instance.new("UICorner")
                listCorner.CornerRadius = UDim.new(0, 6)
                listCorner.Parent = dropdownList
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropdownList
                listLayout.Padding = UDim.new(0, 2)
                
                for _, option in pairs(options) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Parent = dropdownList
                    optionBtn.BackgroundColor3 = Settings.Theme.Background
                    optionBtn.Size = UDim2.new(1, -4, 0, 28)
                    optionBtn.Position = UDim2.new(0, 2, 0, 0)
                    optionBtn.Font = Enum.Font.Gotham
                    optionBtn.Text = option
                    optionBtn.TextColor3 = Settings.Theme.TextDim
                    optionBtn.TextSize = 11
                    optionBtn.BorderSizePixel = 0
                    
                    local optCorner = Instance.new("UICorner")
                    optCorner.CornerRadius = UDim.new(0, 4)
                    optCorner.Parent = optionBtn
                    
                    optionBtn.MouseButton1Click:Connect(function()
                        dropdownBtn.Text = option
                        callback(option)
                        expanded = false
                        dropdownList.Visible = false
                        dropdownFrame.Size = UDim2.new(0.95, 0, 0, 45)
                        updateCanvas()
                    end)
                end
            end
            
            dropdownBtn.MouseButton1Click:Connect(function()
                expanded = not expanded
                if expanded then
                    createDropdownList()
                    dropdownFrame.Size = UDim2.new(0.95, 0, 0, 45 + math.min(#options * 30, 120) + 10)
                    updateCanvas()
                else
                    if dropdownList then
                        dropdownList:Destroy()
                        dropdownFrame.Size = UDim2.new(0.95, 0, 0, 45)
                        updateCanvas()
                    end
                end
            end)
            
            updateCanvas()
            return dropdownFrame
        end
        
        function tab:Textbox(text, placeholder, callback)
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Parent = contentFrame
            textboxFrame.BackgroundColor3 = Settings.Theme.Surface
            textboxFrame.Size = UDim2.new(0.95, 0, 0, 45)
            
            local frameCorner = Instance.new("UICorner")
            frameCorner.CornerRadius = UDim.new(0, 6)
            frameCorner.Parent = textboxFrame
            
            local label = Instance.new("TextLabel")
            label.Parent = textboxFrame
            label.BackgroundTransparency = 1
            label.Position = UDim2.new(0, 15, 0, 0)
            label.Size = UDim2.new(0, 150, 1, 0)
            label.Font = Enum.Font.GothamSemibold
            label.Text = text
            label.TextColor3 = Settings.Theme.Text
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local textbox = Instance.new("TextBox")
            textbox.Parent = textboxFrame
            textbox.BackgroundColor3 = Settings.Theme.Background
            textbox.Position = UDim2.new(1, -200, 0, 10)
            textbox.Size = UDim2.new(0, 185, 0, 25)
            textbox.Font = Enum.Font.Gotham
            textbox.PlaceholderText = placeholder or "Enter text..."
            textbox.Text = ""
            textbox.TextColor3 = Settings.Theme.Text
            textbox.PlaceholderColor3 = Settings.Theme.TextDim
            textbox.TextSize = 12
            textbox.BorderSizePixel = 0
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = textbox
            
            textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed and textbox.Text ~= "" then
                    callback(textbox.Text)
                    textbox.Text = ""
                end
            end)
            
            updateCanvas()
            return textbox
        end
        
        return tab
    end
    
    return window
end

-- Simple notification system
function NebulaLite:Notify(title, message, duration)
    local notification = Instance.new("Frame")
    notification.Parent = game.CoreGui
    notification.BackgroundColor3 = Settings.Theme.Surface
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(1, -320, 0, 50)
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 6)
    notifCorner.Parent = notification
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = notification
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 15, 0, 5)
    titleLabel.Size = UDim2.new(1, -30, 0, 25)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = title
    titleLabel.TextColor3 = Settings.Theme.Primary
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Parent = notification
    msgLabel.BackgroundTransparency = 1
    msgLabel.Position = UDim2.new(0, 15, 0, 30)
    msgLabel.Size = UDim2.new(1, -30, 0, 25)
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Text = message
    msgLabel.TextColor3 = Settings.Theme.TextDim
    msgLabel.TextSize = 11
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    task.delay(duration or 3, function()
        notification:Destroy()
    end)
end

return NebulaLite
