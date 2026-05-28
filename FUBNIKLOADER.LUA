--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║                                                           ║
    ║   ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗██╗  ██╗         ║
    ║   ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚██╗██╔╝         ║
    ║   █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║ ╚███╔╝          ║
    ║   ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║ ██╔██╗          ║
    ║   ██║     ╚██████╔╝██████╔╝██║ ╚████║██║██╔╝ ██╗          ║
    ║   ╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝          ║
    ║                                                           ║
    ║         FUBNIK v6.1 - GUI MODULE                          ║
    ║    Simple GUI creation for non-coders                     ║
    ║    NO pre-made tabs - Build your own!                     ║
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- AUTO DEVICE DETECTION & SCALING
-- ============================================================================
local Device = {
    Type = "Unknown",
    ScreenWidth = 0,
    ScreenHeight = 0,
    Scale = 1,
    RecommendedWidth = 0,
    RecommendedHeight = 0,
    ButtonHeight = 0,
    FontSize = 0,
    SidebarWidth = 0,
    Padding = 0
}

function Device:Detect()
    local camera = workspace.CurrentCamera
    self.ScreenWidth = camera.ViewportSize.X
    self.ScreenHeight = camera.ViewportSize.Y
    local isMobile = game:GetService("UserInputService").TouchEnabled
    local aspectRatio = self.ScreenWidth / self.ScreenHeight

    if isMobile then
        self.Type = "Mobile"
        self.RecommendedWidth = math.min(360, self.ScreenWidth - 20)
        self.RecommendedHeight = math.min(600, self.ScreenHeight - 80)
        self.ButtonHeight = 44
        self.FontSize = 14
        self.SidebarWidth = 120
        self.Padding = 12
        self.Scale = 0.9
    elseif aspectRatio > 1.6 then
        self.Type = "Desktop Wide"
        self.RecommendedWidth = math.min(450, self.ScreenWidth * 0.35)
        self.RecommendedHeight = math.min(650, self.ScreenHeight - 100)
        self.ButtonHeight = 45
        self.FontSize = 14
        self.SidebarWidth = 140
        self.Padding = 15
        self.Scale = 1
    elseif aspectRatio > 1.3 then
        self.Type = "Desktop"
        self.RecommendedWidth = math.min(420, self.ScreenWidth * 0.4)
        self.RecommendedHeight = math.min(620, self.ScreenHeight - 100)
        self.ButtonHeight = 42
        self.FontSize = 13
        self.SidebarWidth = 135
        self.Padding = 12
        self.Scale = 1
    else
        self.Type = "Tablet"
        self.RecommendedWidth = math.min(500, self.ScreenWidth - 40)
        self.RecommendedHeight = math.min(700, self.ScreenHeight - 80)
        self.ButtonHeight = 48
        self.FontSize = 15
        self.SidebarWidth = 150
        self.Padding = 15
        self.Scale = 1.1
    end

    print(string.format("[FUBNIK] Device: %s | %dx%d", self.Type, self.RecommendedWidth, self.RecommendedHeight))
    return self
end

Device:Detect()

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")

-- ============================================================================
-- UTILITIES
-- ============================================================================
local function MakeRounded(frame, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = frame
end

local function MakeStroke(frame, t, c)
    local s = Instance.new("UIStroke")
    s.Thickness = t or 1
    s.Color = c or Color3.fromRGB(100, 100, 255)
    s.Parent = frame
end

local function Tween(obj, props, time)
    return TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================
local NotifyContainer = nil

local function CreateNotifyContainer()
    if NotifyContainer then return end
    NotifyContainer = Instance.new("Frame")
    NotifyContainer.Name = "NotifContainer"
    NotifyContainer.Size = UDim2.new(0, 320, 1, -20)
    NotifyContainer.Position = UDim2.new(1, -340, 0, 10)
    NotifyContainer.BackgroundTransparency = 1
    NotifyContainer.Parent = CG
end

local function Notify(title, msg, typ, duration)
    CreateNotifyContainer()
    typ = typ or "info"
    duration = duration or 3
    
    local colors = {
        info = Color3.fromRGB(80, 180, 255),
        success = Color3.fromRGB(80, 255, 120),
        warn = Color3.fromRGB(255, 200, 80),
        error = Color3.fromRGB(255, 80, 100)
    }
    local icons = {info = "ℹ️", success = "✅", warn = "⚠️", error = "❌"}
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.BackgroundTransparency = 0.1
    frame.AutomaticSize = Enum.AutomaticSize.Y
    MakeRounded(frame, 12)
    MakeStroke(frame, 1, colors[typ])
    frame.Parent = NotifyContainer
    
    local iconL = Instance.new("TextLabel")
    iconL.Size = UDim2.new(0, 30, 0, 30)
    iconL.Position = UDim2.new(0, 12, 0, 12)
    iconL.Text = icons[typ]
    iconL.TextSize = 18
    iconL.BackgroundTransparency = 1
    iconL.Parent = frame
    
    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -55, 0, 25)
    titleL.Position = UDim2.new(0, 48, 0, 8)
    titleL.Text = title
    titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleL.TextSize = 14
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.BackgroundTransparency = 1
    titleL.Parent = frame
    
    local msgL = Instance.new("TextLabel")
    msgL.Size = UDim2.new(1, -55, 0, 0)
    msgL.Position = UDim2.new(0, 48, 0, 33)
    msgL.Text = msg
    msgL.TextColor3 = Color3.fromRGB(180, 180, 210)
    msgL.TextSize = 12
    msgL.Font = Enum.Font.Gotham
    msgL.TextXAlignment = Enum.TextXAlignment.Left
    msgL.TextWrapped = true
    msgL.BackgroundTransparency = 1
    msgL.AutomaticSize = Enum.AutomaticSize.Y
    msgL.Parent = frame
    
    local h = msgL.AbsoluteSize.Y + 55
    Tween(frame, {Size = UDim2.new(1, -10, 0, h)}, 0.3)
    
    task.spawn(function()
        task.wait(duration)
        if frame then
            Tween(frame, {Size = UDim2.new(1, -10, 0, 0), BackgroundTransparency = 1}, 0.2)
            task.wait(0.2)
            frame:Destroy()
        end
    end)
end

-- ============================================================================
-- GUI MODULE (FIXED TAB OVERLAY)
-- ============================================================================
local Hub = { windows = {} }

function Hub:CreateWindow(name, customWidth, customHeight)
    local width = customWidth or Device.RecommendedWidth
    local height = customHeight or Device.RecommendedHeight
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FUBNIK_" .. tostring(os.time())
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CG
    
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, width, 0, height)
    main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    main.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    MakeRounded(main, 12)
    MakeStroke(main, 1.5, Color3.fromRGB(100, 100, 255))
    main.Parent = screenGui
    
    -- Title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.BackgroundTransparency = 1
    titleBar.Parent = main
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = name
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = Device.FontSize
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = titleBar
    
    -- Close button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
    closeBtn.TouchTap:Connect(function() screenGui:Destroy() end)
    
    -- Sidebar
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Size = UDim2.new(0, Device.SidebarWidth, 1, -45)
    tabsFrame.Position = UDim2.new(0, 0, 0, 45)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    tabsFrame.BackgroundTransparency = 0.5
    tabsFrame.Parent = main
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = tabsFrame
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabList
    
    -- Content area
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -(Device.SidebarWidth + 15), 1, -55)
    contentFrame.Position = UDim2.new(0, Device.SidebarWidth + 10, 0, 50)
    contentFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    contentFrame.BackgroundTransparency = 0.3
    MakeRounded(contentFrame, 8)
    contentFrame.Parent = main
    
    -- Make draggable
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    local window = {
        screenGui = screenGui,
        main = main,
        contentFrame = contentFrame,
        tabList = tabList,
        tabs = {},
        currentTab = nil,
        device = Device
    }
    
    -- ========================================================================
    -- FIXED: AddTab with proper tab switching (no overlay)
    -- ========================================================================
    function window:AddTab(name, icon)
        icon = icon or ""
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, Device.ButtonHeight)
        btn.Text = icon ~= "" and (icon .. "  " .. name) or name
        btn.TextColor3 = Color3.fromRGB(180, 180, 210)
        btn.TextSize = Device.FontSize - 1
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundTransparency = 1
        MakeRounded(btn, 6)
        btn.Parent = self.tabList
        
        -- Create NEW content container for this tab
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.Visible = false  -- Start hidden
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = self.contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        -- Update canvas size when content changes
        local function updateCanvas()
            task.defer(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
            end)
        end
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        
        -- FIXED: Proper tab switching - CLEARLY hide all others first
        local function selectTab()
            -- CRITICAL FIX: Hide EVERY other tab's content FIRST
            for _, existingTab in pairs(self.tabs) do
                if existingTab.content then
                    existingTab.content.Visible = false
                    existingTab.content.Visible = false -- Double ensure
                end
                if existingTab.button then
                    existingTab.button.BackgroundTransparency = 1
                    existingTab.button.TextColor3 = Color3.fromRGB(180, 180, 210)
                end
            end
            
            -- Now show THIS tab
            tabContent.Visible = true
            btn.BackgroundTransparency = 0.1
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            -- Update canvas
            updateCanvas()
        end
        
        btn.MouseButton1Click:Connect(selectTab)
        btn.TouchTap:Connect(selectTab)
        
        local tab = {
            button = btn,
            content = tabContent,
            layout = contentLayout,
            elements = {}
        }
        
        -- ====================================================================
        -- SECTION CREATION
        -- ====================================================================
        function tab:AddSection(title)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabContent
            
            local header = Instance.new("TextLabel")
            header.Size = UDim2.new(1, 0, 0, 30)
            header.Text = title
            header.TextColor3 = Color3.fromRGB(100, 100, 255)
            header.TextSize = Device.FontSize
            header.Font = Enum.Font.GothamBold
            header.TextXAlignment = Enum.TextXAlignment.Left
            header.BackgroundTransparency = 1
            header.Parent = sectionFrame
            
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, 0, 0, 1)
            line.Position = UDim2.new(0, 0, 0, 28)
            line.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
            line.BackgroundTransparency = 0.5
            line.Parent = sectionFrame
            
            local elementsFrame = Instance.new("Frame")
            elementsFrame.Size = UDim2.new(1, 0, 0, 0)
            elementsFrame.Position = UDim2.new(0, 0, 0, 35)
            elementsFrame.BackgroundTransparency = 1
            elementsFrame.AutomaticSize = Enum.AutomaticSize.Y
            elementsFrame.Parent = sectionFrame
            
            local elementsLayout = Instance.new("UIListLayout")
            elementsLayout.Padding = UDim.new(0, 8)
            elementsLayout.Parent = elementsFrame
            
            local section = {
                frame = sectionFrame,
                elementsFrame = elementsFrame,
                elements = {}
            }
            
            -- Button
            function section:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextSize = Device.FontSize - 1
                btn.Font = Enum.Font.GothamSemibold
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(btn, 8)
                MakeStroke(btn, 1, Color3.fromRGB(80, 80, 120))
                btn.Parent = elementsFrame
                
                btn.MouseEnter:Connect(function() Tween(btn, {BackgroundColor3 = Color3.fromRGB(55, 55, 85)}, 0.1) end)
                btn.MouseLeave:Connect(function() Tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}, 0.1) end)
                btn.MouseButton1Click:Connect(function() if callback then callback() end end)
                btn.TouchTap:Connect(function() if callback then callback() end end)
                
                table.insert(section.elements, btn)
                return btn
            end
            
            -- Toggle
            function section:AddToggle(text, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 120))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 50, 0, 26)
                toggleBtn.Position = UDim2.new(1, -60, 0.5, -13)
                toggleBtn.Text = ""
                toggleBtn.BackgroundColor3 = default and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)
                MakeRounded(toggleBtn, 13)
                toggleBtn.Parent = frame
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 22, 0, 22)
                knob.Position = UDim2.new(0, default and 26 or 2, 0.5, -11)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                MakeRounded(knob, 11)
                knob.Parent = toggleBtn
                
                local state = default
                
                local function toggle()
                    state = not state
                    Tween(toggleBtn, {BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)}, 0.2)
                    Tween(knob, {Position = UDim2.new(0, state and 26 or 2, 0.5, -11)}, 0.2)
                    if callback then callback(state) end
                end
                
                toggleBtn.MouseButton1Click:Connect(toggle)
                toggleBtn.TouchTap:Connect(toggle)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(v)
                        state = v
                        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)
                        knob.Position = UDim2.new(0, state and 26 or 2, 0.5, -11)
                        if callback then callback(state) end
                    end
                }
            end
            
            -- Label
            function section:AddLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 25)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(180, 180, 210)
                label.TextSize = Device.FontSize - 2
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = elementsFrame
                table.insert(section.elements, label)
                return label
            end
            
            -- Slider
            function section:AddSlider(text, min, max, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 75)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 120))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -80, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 5)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.GothamSemibold
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0, 60, 0, 25)
                valueLabel.Position = UDim2.new(1, -72, 0, 5)
                valueLabel.Text = tostring(default)
                valueLabel.TextColor3 = Color3.fromRGB(100, 100, 255)
                valueLabel.TextSize = Device.FontSize - 2
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.BackgroundTransparency = 1
                valueLabel.Parent = frame
                
                local sliderBg = Instance.new("Frame")
                sliderBg.Size = UDim2.new(1, -24, 0, 4)
                sliderBg.Position = UDim2.new(0, 12, 0, 48)
                sliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                MakeRounded(sliderBg, 2)
                sliderBg.Parent = frame
                
                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                MakeRounded(fill, 2)
                fill.Parent = sliderBg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = UDim2.new(percent, -9, 0.5, -9)
                knob.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                MakeRounded(knob, 9)
                knob.Parent = sliderBg
                
                local dragging = false
                local value = default
                
                local function update(pos)
                    local relative = math.clamp((pos.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (relative * (max - min))
                    value = math.floor(newVal + 0.5)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    knob.Position = UDim2.new(relative, -9, 0.5, -9)
                    if callback then callback(value) end
                end
                
                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                
                UIS.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        update(input)
                    end
                end)
                
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        update(input)
                        dragging = true
                    end
                end)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(v)
                        value = math.clamp(v, min, max)
                        local p = (value - min) / (max - min)
                        valueLabel.Text = tostring(value)
                        fill.Size = UDim2.new(p, 0, 1, 0)
                        knob.Position = UDim2.new(p, -9, 0.5, -9)
                        if callback then callback(value) end
                    end
                }
            end
            
            -- Dropdown
            function section:AddDropdown(text, options, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                MakeRounded(frame, 8)
                MakeStroke(frame, 1, Color3.fromRGB(80, 80, 120))
                frame.Parent = elementsFrame
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -110, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.TextSize = Device.FontSize - 1
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = frame
                
                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Size = UDim2.new(0, 100, 0, 32)
                dropdownBtn.Position = UDim2.new(1, -110, 0.5, -16)
                dropdownBtn.Text = default or options[1]
                dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                dropdownBtn.TextSize = Device.FontSize - 2
                dropdownBtn.Font = Enum.Font.Gotham
                dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
                MakeRounded(dropdownBtn, 6)
                dropdownBtn.Parent = frame
                
                local arrow = Instance.new("TextLabel")
                arrow.Size = UDim2.new(0, 25, 1, 0)
                arrow.Position = UDim2.new(1, -25, 0, 0)
                arrow.Text = "▼"
                arrow.TextColor3 = Color3.fromRGB(180, 180, 210)
                arrow.TextSize = 10
                arrow.BackgroundTransparency = 1
                arrow.Parent = dropdownBtn
                
                local listVisible = false
                local list = nil
                
                dropdownBtn.MouseButton1Click:Connect(function()
                    if list then list:Destroy() end
                    listVisible = true
                    
                    list = Instance.new("ScrollingFrame")
                    list.Size = UDim2.new(0, 120, 0, 0)
                    list.Position = UDim2.new(1, -130, 0, 45)
                    list.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                    MakeRounded(list, 6)
                    MakeStroke(list, 1, Color3.fromRGB(80, 80, 120))
                    list.ScrollBarThickness = 2
                    list.ClipsDescendants = true
                    list.Parent = frame
                    
                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Padding = UDim.new(0, 2)
                    listLayout.Parent = list
                    
                    local height = 0
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, -10, 0, 32)
                        optBtn.Text = opt
                        optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                        optBtn.TextSize = Device.FontSize - 2
                        optBtn.Font = Enum.Font.Gotham
                        optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                        MakeRounded(optBtn, 4)
                        optBtn.Parent = list
                        
                        optBtn.MouseButton1Click:Connect(function()
                            dropdownBtn.Text = opt
                            if callback then callback(opt) end
                            list:Destroy()
                            listVisible = false
                        end)
                        
                        height = height + 34
                    end
                    
                    list.CanvasSize = UDim2.new(0, 0, 0, height)
                    list.Size = UDim2.new(0, 120, 0, math.min(height, 150))
                end)
                
                UIS.InputBegan:Connect(function(input)
                    if listVisible and input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = input.Position
                        local btnPos = dropdownBtn.AbsolutePosition
                        if not (mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + 100 and
                               mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + 32) then
                            if list then list:Destroy() end
                            listVisible = false
                        end
                    end
                end)
                
                table.insert(section.elements, frame)
                return {
                    setValue = function(val)
                        dropdownBtn.Text = val
                        if callback then callback(val) end
                    end
                }
            end
            
            return section
        end
        
        table.insert(self.tabs, tab)
        
        -- Auto-select first tab
        if #self.tabs == 1 then
            selectTab()
        end
        
        return tab
    end
    
    -- Helper: Add user info frame
    function window:AddUserInfo()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 90)
        frame.Position = UDim2.new(0, 10, 0, 0)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        MakeRounded(frame, 10)
        MakeStroke(frame, 1, Color3.fromRGB(80, 80, 120))
        frame.Parent = self.contentFrame
        
        local avatar = Instance.new("Frame")
        avatar.Size = UDim2.new(0, 55, 0, 55)
        avatar.Position = UDim2.new(0, 12, 0, 17)
        avatar.BackgroundColor3 = Color3.fromRGB(55, 55, 85)
        MakeRounded(avatar, 27)
        MakeStroke(avatar, 2, Color3.fromRGB(100, 100, 255))
        avatar.Parent = frame
        
        local avatarText = Instance.new("TextLabel")
        avatarText.Size = UDim2.new(1, 0, 1, 0)
        avatarText.Text = "👤"
        avatarText.TextSize = 28
        avatarText.BackgroundTransparency = 1
        avatarText.Parent = avatar
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -85, 0, 28)
        nameLabel.Position = UDim2.new(0, 80, 0, 12)
        nameLabel.Text = LP.Name
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = Device.FontSize + 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.BackgroundTransparency = 1
        nameLabel.Parent = frame
        
        local displayLabel = Instance.new("TextLabel")
        displayLabel.Size = UDim2.new(1, -85, 0, 20)
        displayLabel.Position = UDim2.new(0, 80, 0, 40)
        displayLabel.Text = "@" .. (LP.DisplayName or LP.Name)
        displayLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
        displayLabel.TextSize = Device.FontSize - 2
        displayLabel.Font = Enum.Font.Gotham
        displayLabel.TextXAlignment = Enum.TextXAlignment.Left
        displayLabel.BackgroundTransparency = 1
        displayLabel.Parent = frame
        
        local idLabel = Instance.new("TextLabel")
        idLabel.Size = UDim2.new(1, -85, 0, 18)
        idLabel.Position = UDim2.new(0, 80, 0, 60)
        idLabel.Text = "ID: " .. LP.UserId
        idLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
        idLabel.TextSize = Device.FontSize - 3
        idLabel.Font = Enum.Font.Gotham
        idLabel.TextXAlignment = Enum.TextXAlignment.Left
        idLabel.BackgroundTransparency = 1
        idLabel.Parent = frame
        
        return frame
    end
    
    function window:Notify(title, msg, typ, duration)
        Notify(title, msg, typ, duration)
    end
    
    function window:GetDeviceInfo()
        return Device.Type, Device.RecommendedWidth, Device.RecommendedHeight
    end
    
    table.insert(Hub.windows, window)
    return window
end

-- ============================================================================
-- EXPOSE MODULE (NO PRE-MADE HUB!)
-- ============================================================================
_G.FUBNIK = {
    CreateWindow = function(name, width, height) 
        return Hub:CreateWindow(name, width, height) 
    end,
    Device = Device,
    Notify = Notify
}

print("========================================")
print("FUBNIK v6.1 - GUI MODULE LOADED")
print("Create your hub: _G.FUBNIK:CreateWindow('My Hub')")
print("NO pre-made tabs - Build what YOU want!")
print("========================================")

-- Return the module for loadstring users
return _G.FUBNIK
