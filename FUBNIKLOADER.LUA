-- FUBNIK Loader - Place this in your executor
local FUBNIK = {}

-- Color presets
FUBNIK.Colors = {
    red = Color3.fromRGB(220, 20, 60),
    blue = Color3.fromRGB(30, 144, 255),
    green = Color3.fromRGB(50, 205, 50),
    purple = Color3.fromRGB(138, 43, 226),
    orange = Color3.fromRGB(255, 140, 0),
    pink = Color3.fromRGB(255, 105, 180),
    cyan = Color3.fromRGB(0, 206, 209),
    yellow = Color3.fromRGB(255, 215, 0),
    rose = Color3.fromRGB(255, 20, 147),
    amber = Color3.fromRGB(255, 191, 0),
    lime = Color3.fromRGB(50, 205, 50),
    teal = Color3.fromRGB(0, 128, 128),
    lavender = Color3.fromRGB(230, 230, 250),
    coral = Color3.fromRGB(255, 127, 80),
    mint = Color3.fromRGB(189, 252, 201),
    gold = Color3.fromRGB(255, 215, 0),
    silver = Color3.fromRGB(192, 192, 192),
    bronze = Color3.fromRGB(205, 127, 50),
    dark = Color3.fromRGB(30, 30, 30),
    light = Color3.fromRGB(245, 245, 245)
}

-- Theme manager
FUBNIK.Themes = {
    dark = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.blue },
    light = { bg = Color3.fromRGB(240,240,240), fg = Color3.fromRGB(255,255,255), text = Color3.fromRGB(0,0,0), accent = FUBNIK.Colors.blue },
    red = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.red },
    blue = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.blue },
    green = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.green },
    purple = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.purple },
    orange = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.orange },
    pink = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.pink },
    rose = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.rose },
    amber = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.amber },
    cyan = { bg = Color3.fromRGB(25,25,25), fg = Color3.fromRGB(40,40,40), text = Color3.fromRGB(255,255,255), accent = FUBNIK.Colors.cyan }
}

-- Gamepass manager
FUBNIK.Gamepasses = {}
FUBNIK.PurchaseCallbacks = {}

function FUBNIK:RegisterGamepass(passId, itemName, price)
    self.Gamepasses[passId] = { name = itemName, price = price, owned = false }
    return self
end

function FUBNIK:PromptPurchase(passId, callback)
    if self.Gamepasses[passId] and not self.Gamepasses[passId].owned then
        game:GetService("MarketplaceService"):PromptGamePassPurchase(game.Players.LocalPlayer, passId)
        self.PurchaseCallbacks[passId] = callback
    elseif self.Gamepasses[passId] and self.Gamepasses[passId].owned then
        callback(true)
    end
end

-- Settings storage
FUBNIK.Settings = {}
function FUBNIK:SaveSetting(key, value)
    self.Settings[key] = value
    return self
end

function FUBNIK:LoadSetting(key, defaultValue)
    return self.Settings[key] or defaultValue
end

-- Main UI Builder
function FUBNIK:Create(title, theme)
    local window = {}
    theme = theme or "dark"
    local currentTheme = self.Themes[theme] or self.Themes.dark
    
    -- Create GUI
    local gui = Instance.new("ScreenGui")
    gui.Name = "FUBNIK_" .. title
    gui.Parent = game.CoreGui
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Parent = gui
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = currentTheme.bg
    mainFrame.BorderSizePixel = 0
    
    Instance.new("UICorner").Parent = mainFrame
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Parent = mainFrame
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = currentTheme.accent
    titleBar.BackgroundTransparency = 0.8
    
    local titleText = Instance.new("TextLabel")
    titleText.Parent = titleBar
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = title
    titleText.TextColor3 = currentTheme.text
    titleText.TextSize = 18
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Font = Enum.Font.GothamBold
    titleText.BackgroundTransparency = 1
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = titleBar
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = currentTheme.text
    closeBtn.TextSize = 18
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    
    -- Tabs container
    local tabContainer = Instance.new("Frame")
    tabContainer.Parent = mainFrame
    tabContainer.Size = UDim2.new(0, 120, 1, -40)
    tabContainer.Position = UDim2.new(0, 0, 0, 40)
    tabContainer.BackgroundColor3 = currentTheme.fg
    tabContainer.BackgroundTransparency = 0.5
    
    local tabList = Instance.new("UIListLayout")
    tabList.Parent = tabContainer
    tabList.Padding = UDim.new(0, 5)
    tabList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Parent = mainFrame
    contentContainer.Size = UDim2.new(1, -120, 1, -40)
    contentContainer.Position = UDim2.new(0, 120, 0, 40)
    contentContainer.BackgroundColor3 = currentTheme.bg
    contentContainer.BackgroundTransparency = 0
    
    local pages = Instance.new("Folder")
    pages.Parent = contentContainer
    
    -- Dragging
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
        gui:Destroy()
    end)
    
    -- Tab system
    window.tabs = {}
    
    function window:Tab(name)
        local tab = {}
        local page = Instance.new("ScrollingFrame")
        page.Parent = pages
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 5
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        
        local pageList = Instance.new("UIListLayout")
        pageList.Parent = page
        pageList.Padding = UDim.new(0, 8)
        pageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Parent = tabContainer
        tabBtn.Size = UDim2.new(0.9, 0, 0, 35)
        tabBtn.Text = name
        tabBtn.TextColor3 = currentTheme.text
        tabBtn.BackgroundColor3 = currentTheme.fg
        tabBtn.Font = Enum.Font.GothamSemibold
        tabBtn.TextSize = 14
        tabBtn.BorderSizePixel = 0
        
        Instance.new("UICorner").Parent = tabBtn
        
        local function updateCanvas()
            local size = pageList.AbsoluteContentSize
            page.CanvasSize = UDim2.new(0, 0, 0, size.Y + 10)
        end
        
        page.ChildAdded:Connect(updateCanvas)
        page.ChildRemoved:Connect(updateCanvas)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(pages:GetChildren()) do
                v.Visible = false
            end
            page.Visible = true
            updateCanvas()
        end)
        
        -- Element creator
        function tab:Add(label, elementType, ...)
            local frame = Instance.new("Frame")
            frame.Parent = page
            frame.Size = UDim2.new(0.95, 0, 0, 45)
            frame.BackgroundColor3 = currentTheme.fg
            frame.BackgroundTransparency = 0.3
            
            Instance.new("UICorner").Parent = frame
            
            local labelText = Instance.new("TextLabel")
            labelText.Parent = frame
            labelText.Size = UDim2.new(0.6, -10, 1, 0)
            labelText.Position = UDim2.new(0, 10, 0, 0)
            labelText.Text = label
            labelText.TextColor3 = currentTheme.text
            labelText.TextSize = 14
            labelText.TextXAlignment = Enum.TextXAlignment.Left
            labelText.BackgroundTransparency = 1
            labelText.Font = Enum.Font.GothamSemibold
            
            local elementContainer = Instance.new("Frame")
            elementContainer.Parent = frame
            elementContainer.Size = UDim2.new(0.4, -10, 0.7, 0)
            elementContainer.Position = UDim2.new(0.6, 0, 0.15, 0)
            elementContainer.BackgroundTransparency = 1
            
            if elementType == "Button" then
                local btn = Instance.new("TextButton")
                btn.Parent = elementContainer
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.Text = ... or "Click"
                btn.BackgroundColor3 = currentTheme.accent
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.Font = Enum.Font.GothamSemibold
                btn.TextSize = 12
                Instance.new("UICorner").Parent = btn
                
                btn.MouseButton1Click:Connect(function(...)
                    local callback = select(2, ...)
                    if callback then callback() end
                end)
                
            elseif elementType == "Toggle" then
                local toggle = Instance.new("TextButton")
                toggle.Parent = elementContainer
                toggle.Size = UDim2.new(0, 40, 1, 0)
                toggle.Position = UDim2.new(1, -40, 0, 0)
                toggle.Text = "OFF"
                toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
                toggle.TextColor3 = Color3.fromRGB(255,255,255)
                toggle.Font = Enum.Font.GothamBold
                toggle.TextSize = 11
                Instance.new("UICorner").Parent = toggle
                
                local state = false
                toggle.MouseButton1Click:Connect(function()
                    state = not state
                    toggle.Text = state and "ON" or "OFF"
                    toggle.BackgroundColor3 = state and currentTheme.accent or Color3.fromRGB(60,60,60)
                    local callback = ...
                    if callback then callback(state) end
                end)
                
            elseif elementType == "Slider" then
                local min, max, callback = ...
                local slider = Instance.new("Frame")
                slider.Parent = elementContainer
                slider.Size = UDim2.new(1, 0, 0.5, 0)
                slider.Position = UDim2.new(0, 0, 0.25, 0)
                slider.BackgroundColor3 = Color3.fromRGB(60,60,60)
                Instance.new("UICorner").Parent = slider
                
                local fill = Instance.new("Frame")
                fill.Parent = slider
                fill.Size = UDim2.new(0, 0, 1, 0)
                fill.BackgroundColor3 = currentTheme.accent
                Instance.new("UICorner").Parent = fill
                
                local valueText = Instance.new("TextLabel")
                valueText.Parent = elementContainer
                valueText.Size = UDim2.new(1, 0, 0.4, 0)
                valueText.Position = UDim2.new(0, 0, 0, 0)
                valueText.Text = tostring(min)
                valueText.TextColor3 = currentTheme.text
                valueText.TextSize = 11
                valueText.BackgroundTransparency = 1
                valueText.Font = Enum.Font.Gotham
                
                local current = min
                local dragging = false
                
                local function updateSlider(input)
                    local x = math.clamp(input.Position.X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
                    local percent = x / slider.AbsoluteSize.X
                    current = math.floor(min + (max - min) * percent)
                    fill.Size = UDim2.new(percent, 0, 1, 0)
                    valueText.Text = tostring(current)
                    if callback then callback(current) end
                end
                
                slider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        updateSlider(input)
                    end
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
                
            elseif elementType == "Dropdown" then
                local options, callback = ...
                local dropdown = Instance.new("TextButton")
                dropdown.Parent = elementContainer
                dropdown.Size = UDim2.new(1, 0, 1, 0)
                dropdown.Text = "Select..."
                dropdown.BackgroundColor3 = Color3.fromRGB(60,60,60)
                dropdown.TextColor3 = currentTheme.text
                dropdown.Font = Enum.Font.Gotham
                dropdown.TextSize = 12
                Instance.new("UICorner").Parent = dropdown
                
                local expanded = false
                local dropdownList = Instance.new("Frame")
                dropdownList.Parent = frame
                dropdownList.Size = UDim2.new(0.4, -10, 0, 0)
                dropdownList.Position = UDim2.new(0.6, 0, 0.15, 0)
                dropdownList.BackgroundColor3 = Color3.fromRGB(50,50,50)
                dropdownList.Visible = false
                Instance.new("UICorner").Parent = dropdownList
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = dropdownList
                listLayout.Padding = UDim.new(0, 2)
                
                for _, option in pairs(options) do
                    local btn = Instance.new("TextButton")
                    btn.Parent = dropdownList
                    btn.Size = UDim2.new(1, 0, 0, 30)
                    btn.Text = option
                    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
                    btn.TextColor3 = currentTheme.text
                    btn.Font = Enum.Font.Gotham
                    btn.TextSize = 11
                    Instance.new("UICorner").Parent = btn
                    
                    btn.MouseButton1Click:Connect(function()
                        dropdown.Text = option
                        if callback then callback(option) end
                        dropdownList.Visible = false
                        expanded = false
                        frame.Size = UDim2.new(0.95, 0, 0, 45)
                    end)
                end
                
                dropdown.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    dropdownList.Visible = expanded
                    if expanded then
                        local height = #options * 32 + 10
                        dropdownList.Size = UDim2.new(0.4, -10, 0, height)
                        frame.Size = UDim2.new(0.95, 0, 0, 45 + height)
                        updateCanvas()
                    else
                        frame.Size = UDim2.new(0.95, 0, 0, 45)
                        updateCanvas()
                    end
                end)
                
            elseif elementType == "Gamepass" then
                local passId, price, callback = ...
                local buyBtn = Instance.new("TextButton")
                buyBtn.Parent = elementContainer
                buyBtn.Size = UDim2.new(1, 0, 1, 0)
                buyBtn.Text = "Buy " .. price .. " Robux"
                buyBtn.BackgroundColor3 = currentTheme.accent
                buyBtn.TextColor3 = Color3.fromRGB(255,255,255)
                buyBtn.Font = Enum.Font.GothamBold
                buyBtn.TextSize = 12
                Instance.new("UICorner").Parent = buyBtn
                
                buyBtn.MouseButton1Click:Connect(function()
                    FUBNIK:PromptPurchase(passId, function(success)
                        if success and callback then callback() end
                    end)
                end)
            end
            
            updateCanvas()
            return frame
        end
        
        -- Make first tab visible
        if #window.tabs == 0 then
            page.Visible = true
            tabBtn.BackgroundColor3 = currentTheme.accent
            tabBtn.BackgroundTransparency = 0.7
        end
        
        table.insert(window.tabs, tab)
        return tab
    end
    
    return window
end

return FUBNIK1
