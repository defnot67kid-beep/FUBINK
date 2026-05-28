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
    ║         FUBNIK v7.0 - FULLY FIXED                         ║
    ║    No Overlaps | Working Notifications | Gamepass System  ║
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local CG = game:GetService("CoreGui")
local TPS = game:GetService("TeleportService")
local LS = game:GetService("Lighting")
local MPS = game:GetService("MarketplaceService")

-- ============================================================================
-- AUTO DEVICE DETECTION
-- ============================================================================
local Device = {
    Type = "Unknown",
    ScreenWidth = 0,
    ScreenHeight = 0,
    RecommendedWidth = 0,
    RecommendedHeight = 0,
    ButtonHeight = 0,
    FontSize = 0,
    SidebarWidth = 0
}

function Device:Detect()
    local camera = workspace.CurrentCamera
    self.ScreenWidth = camera.ViewportSize.X
    self.ScreenHeight = camera.ViewportSize.Y
    local isMobile = UIS.TouchEnabled
    
    if isMobile then
        self.Type = "Mobile"
        self.RecommendedWidth = math.min(360, self.ScreenWidth - 20)
        self.RecommendedHeight = math.min(600, self.ScreenHeight - 80)
        self.ButtonHeight = 44
        self.FontSize = 14
        self.SidebarWidth = 120
    elseif self.ScreenWidth > 1920 then
        self.Type = "Desktop Wide"
        self.RecommendedWidth = 500
        self.RecommendedHeight = 700
        self.ButtonHeight = 45
        self.FontSize = 14
        self.SidebarWidth = 150
    else
        self.Type = "Desktop"
        self.RecommendedWidth = 420
        self.RecommendedHeight = 620
        self.ButtonHeight = 42
        self.FontSize = 13
        self.SidebarWidth = 135
    end
    
    return self
end

Device:Detect()

-- ============================================================================
-- NOTIFICATION SYSTEM (FIXED)
-- ============================================================================
local NotifyContainer = nil
local Notifications = {}

local function CreateNotifyContainer()
    if NotifyContainer and NotifyContainer.Parent then return end
    NotifyContainer = Instance.new("Frame")
    NotifyContainer.Name = "FubnikNotifications"
    NotifyContainer.Size = UDim2.new(0, 320, 1, -20)
    NotifyContainer.Position = UDim2.new(1, -340, 0, 10)
    NotifyContainer.BackgroundTransparency = 1
    NotifyContainer.Parent = CG
end

local function AddNotification(title, message, typ, duration, buttonText, buttonCallback)
    CreateNotifyContainer()
    typ = typ or "info"
    duration = duration or 3
    
    local colors = {
        info = Color3.fromRGB(80, 180, 255),
        success = Color3.fromRGB(80, 255, 120),
        warning = Color3.fromRGB(255, 200, 80),
        error = Color3.fromRGB(255, 80, 100)
    }
    
    local icons = {info = "ℹ️", success = "✅", warning = "⚠️", error = "❌"}
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 0)
    frame.Position = UDim2.new(0, 5, 1, -10)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.ClipsDescendants = true
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = colors[typ]
    stroke.Parent = frame
    
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
    msgL.Text = message
    msgL.TextColor3 = Color3.fromRGB(180, 180, 210)
    msgL.TextSize = 12
    msgL.Font = Enum.Font.Gotham
    msgL.TextXAlignment = Enum.TextXAlignment.Left
    msgL.TextWrapped = true
    msgL.BackgroundTransparency = 1
    msgL.AutomaticSize = Enum.AutomaticSize.Y
    msgL.Parent = frame
    
    -- Action button if provided
    local actionBtn = nil
    if buttonText and buttonCallback then
        actionBtn = Instance.new("TextButton")
        actionBtn.Size = UDim2.new(0, 80, 0, 30)
        actionBtn.Position = UDim2.new(1, -90, 1, -40)
        actionBtn.Text = buttonText
        actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        actionBtn.TextSize = 12
        actionBtn.Font = Enum.Font.GothamSemibold
        actionBtn.BackgroundColor3 = colors[typ]
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = actionBtn
        
        actionBtn.Parent = frame
        
        actionBtn.MouseButton1Click:Connect(function()
            buttonCallback()
            frame:Destroy()
        end)
    end
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = colors[typ]
    progressBar.BackgroundTransparency = 0.3
    progressBar.Parent = frame
    
    -- Calculate final height
    local finalHeight = msgL.AbsoluteSize.Y + 55
    if actionBtn then finalHeight = finalHeight + 35 end
    frame.Size = UDim2.new(1, -10, 0, finalHeight)
    
    -- Animate in
    frame.Position = UDim2.new(0, 5, 1, 0)
    local tween = TS:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 5, 1, -finalHeight - 10)
    })
    tween:Play()
    
    -- Progress bar animation
    local progressTween = TS:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Size = UDim2.new(0, 0, 0, 3)
    })
    progressTween:Play()
    
    -- Auto remove
    task.spawn(function()
        task.wait(duration)
        if frame and frame.Parent then
            local removeTween = TS:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 5, 1, 0),
                BackgroundTransparency = 1
            })
            removeTween:Play()
            task.wait(0.2)
            frame:Destroy()
        end
    end)
    
    return frame
end

-- ============================================================================
-- GAMEPASS SYSTEM
-- ============================================================================
local GamepassManager = {}

function GamepassManager:CheckOwnership(gamepassId, callback)
    MPS:PromptGamePassPurchase(LP, gamepassId)
    -- Note: Actual ownership checking requires a callback from the purchase prompt
    -- This is a simplified version
    if callback then callback(false) end
end

function GamepassManager:CreatePurchaseButton(parent, options)
    local gamepassId = options.GamepassId
    local name = options.Name or "Purchase Gamepass"
    local price = options.Price or "???"
    local onPurchase = options.OnPurchase or function() end
    local onFail = options.OnFail or function() end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, Device.ButtonHeight + 10)
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.AutoButtonColor = false
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    local btnStroke = Instance.new("UIStroke")
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(100, 100, 255)
    btnStroke.Parent = btn
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 30, 1, 0)
    icon.Position = UDim2.new(0, 12, 0, 0)
    icon.Text = "🛒"
    icon.TextSize = 18
    icon.BackgroundTransparency = 1
    icon.Parent = btn
    
    -- Title
    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -100, 0, 22)
    titleL.Position = UDim2.new(0, 55, 0, 8)
    titleL.Text = name
    titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleL.TextSize = Device.FontSize
    titleL.Font = Enum.Font.GothamSemibold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.BackgroundTransparency = 1
    titleL.Parent = btn
    
    -- Price
    local priceL = Instance.new("TextLabel")
    priceL.Size = UDim2.new(1, -100, 0, 18)
    priceL.Position = UDim2.new(0, 55, 0, 30)
    priceL.Text = price .. " Robux"
    priceL.TextColor3 = Color3.fromRGB(180, 180, 210)
    priceL.TextSize = Device.FontSize - 2
    priceL.Font = Enum.Font.Gotham
    priceL.TextXAlignment = Enum.TextXAlignment.Left
    priceL.BackgroundTransparency = 1
    priceL.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(55, 55, 85)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        MPS:PromptGamePassPurchase(LP, gamepassId)
        AddNotification("Gamepass", "Purchase prompt sent!", "info", 2)
        
        -- Simulate purchase check (simplified)
        task.wait(0.5)
        onPurchase()
    end)
    
    btn.Parent = parent
    return btn
end

-- ============================================================================
-- LOADING SCREEN
-- ============================================================================
local function ShowLoading(message, duration)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CG
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.Parent = screenGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 250, 0, 120)
    frame.Position = UDim2.new(0.5, -125, 0.5, -60)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 12)
    frameCorner.Parent = frame
    
    local frameStroke = Instance.new("UIStroke")
    frameStroke.Thickness = 1
    frameStroke.Color = Color3.fromRGB(100, 100, 255)
    frameStroke.Parent = frame
    
    frame.Parent = overlay
    
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, -20, 0, 40)
    text.Position = UDim2.new(0, 10, 0, 10)
    text.Text = message or "Loading..."
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 16
    text.Font = Enum.Font.GothamBold
    text.BackgroundTransparency = 1
    text.Parent = frame
    
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0, 30, 0, 30)
    spinner.Position = UDim2.new(0.5, -15, 0, 60)
    spinner.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    
    local spinnerCorner = Instance.new("UICorner")
    spinnerCorner.CornerRadius = UDim.new(0, 15)
    spinnerCorner.Parent = spinner
    
    spinner.Parent = frame
    
    local spin = 0
    local conn
    conn = game:GetService("RunService").RenderStepped:Connect(function()
        spin = spin + 10
        spinner.Rotation = spin
    end)
    
    if duration then
        task.spawn(function()
            task.wait(duration)
            conn:Disconnect()
            screenGui:Destroy()
        end)
    end
    
    return {
        Hide = function()
            conn:Disconnect()
            screenGui:Destroy()
        end
    }
end

-- ============================================================================
-- MAIN GUI CLASS
-- ============================================================================
local Fubnik = {}
Fubnik.__index = Fubnik

function Fubnik:CreateWindow(name, customWidth, customHeight)
    local self = setmetatable({}, Fubnik)
    self.Name = name
    self.Tabs = {}
    self.CurrentTab = nil
    
    local width = customWidth or Device.RecommendedWidth
    local height = customHeight or Device.RecommendedHeight
    
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "Fubnik_" .. tostring(os.time())
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = CG
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Size = UDim2.new(0, width, 0, height)
    self.MainFrame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 12)
    mainCorner.Parent = self.MainFrame
    
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Thickness = 1.5
    mainStroke.Color = Color3.fromRGB(100, 100, 255)
    mainStroke.Parent = self.MainFrame
    
    self.MainFrame.Parent = self.ScreenGui
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 45)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.MainFrame
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 15, 0, 0)
    titleText.Text = name
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextSize = Device.FontSize + 2
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Parent = self.TitleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -42, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.TextSize = 16
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = self.TitleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, Device.SidebarWidth, 1, -45)
    self.Sidebar.Position = UDim2.new(0, 0, 0, 45)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    self.Sidebar.BackgroundTransparency = 0.5
    self.Sidebar.Parent = self.MainFrame
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, -10, 1, -10)
    tabList.Position = UDim2.new(0, 5, 0, 5)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 2
    tabList.Parent = self.Sidebar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabList
    
    -- Content Area
    self.ContentArea = Instance.new("Frame")
    self.ContentArea.Size = UDim2.new(1, -(Device.SidebarWidth + 15), 1, -55)
    self.ContentArea.Position = UDim2.new(0, Device.SidebarWidth + 10, 0, 50)
    self.ContentArea.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    self.ContentArea.BackgroundTransparency = 0.3
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = self.ContentArea
    
    self.ContentArea.Parent = self.MainFrame
    
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
    
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Tab container (to hold all tab contents - FIX for overlapping)
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Size = UDim2.new(1, 0, 1, 0)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.ContentArea
    
    -- Methods
    function self:AddTab(tabName, icon)
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, Device.ButtonHeight)
        tabButton.Position = UDim2.new(0, 5, 0, 0)
        tabButton.Text = icon ~= "" and (icon .. "  " .. tabName) or tabName
        tabButton.TextColor3 = Color3.fromRGB(180, 180, 210)
        tabButton.TextSize = Device.FontSize - 1
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextXAlignment = Enum.TextXAlignment.Left
        tabButton.BackgroundTransparency = 1
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabButton
        
        tabButton.Parent = tabList
        
        -- Tab Content (ScrollingFrame)
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 3
        tabContent.Visible = false
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Parent = self.TabContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 12)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        -- Tab click handler
        local function selectTab()
            -- Hide all tab contents
            for _, child in pairs(self.TabContainer:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            -- Reset all tab buttons
            for _, child in pairs(tabList:GetChildren()) do
                if child:IsA("TextButton") then
                    TS:Create(child, TweenInfo.new(0.1), {
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        TextColor3 = Color3.fromRGB(180, 180, 210)
                    }):Play()
                    child.BackgroundTransparency = 1
                end
            end
            -- Show selected tab
            tabContent.Visible = true
            TS:Create(tabButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 70),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            tabButton.BackgroundTransparency = 0.1
        end
        
        tabButton.MouseButton1Click:Connect(selectTab)
        
        -- Section creator for this tab
        local tab = {
            Button = tabButton,
            Content = tabContent,
            Layout = contentLayout,
            Sections = {}
        }
        
        function tab:AddSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 0)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
            sectionFrame.Parent = tabContent
            
            local header = Instance.new("TextLabel")
            header.Size = UDim2.new(1, 0, 0, 30)
            header.Text = sectionName
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
                Frame = sectionFrame,
                Elements = elementsFrame,
                Items = {}
            }
            
            -- Button creator
            function section:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextSize = Device.FontSize - 1
                btn.Font = Enum.Font.GothamSemibold
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                local btnStroke = Instance.new("UIStroke")
                btnStroke.Thickness = 1
                btnStroke.Color = Color3.fromRGB(80, 80, 120)
                btnStroke.Parent = btn
                
                btn.Parent = elementsFrame
                
                btn.MouseEnter:Connect(function()
                    TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 85)}):Play()
                end)
                
                btn.MouseLeave:Connect(function()
                    TS:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(35, 35, 55)}):Play()
                end)
                
                btn.MouseButton1Click:Connect(function()
                    if callback then callback() end
                end)
                
                table.insert(section.Items, btn)
                return btn
            end
            
            -- Toggle creator
            function section:AddToggle(text, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = frame
                
                local frameStroke = Instance.new("UIStroke")
                frameStroke.Thickness = 1
                frameStroke.Color = Color3.fromRGB(80, 80, 120)
                frameStroke.Parent = frame
                
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
                
                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 13)
                toggleCorner.Parent = toggleBtn
                
                toggleBtn.Parent = frame
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 22, 0, 22)
                knob.Position = UDim2.new(0, default and 26 or 2, 0.5, -11)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 11)
                knobCorner.Parent = knob
                
                knob.Parent = toggleBtn
                
                local state = default
                
                local function toggle()
                    state = not state
                    TS:Create(toggleBtn, TweenInfo.new(0.2), {
                        BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)
                    }):Play()
                    TS:Create(knob, TweenInfo.new(0.2), {
                        Position = UDim2.new(0, state and 26 or 2, 0.5, -11)
                    }):Play()
                    if callback then callback(state) end
                end
                
                toggleBtn.MouseButton1Click:Connect(toggle)
                
                table.insert(section.Items, {frame = frame, toggle = toggleBtn})
                return {setValue = function(v)
                    state = v
                    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(100, 100, 255) or Color3.fromRGB(80, 80, 120)
                    knob.Position = UDim2.new(0, state and 26 or 2, 0.5, -11)
                    if callback then callback(state) end
                end}
            end
            
            -- Slider creator
            function section:AddSlider(text, min, max, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, 75)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = frame
                
                local frameStroke = Instance.new("UIStroke")
                frameStroke.Thickness = 1
                frameStroke.Color = Color3.fromRGB(80, 80, 120)
                frameStroke.Parent = frame
                
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
                
                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 2)
                sliderCorner.Parent = sliderBg
                
                sliderBg.Parent = frame
                
                local fill = Instance.new("Frame")
                local percent = (default - min) / (max - min)
                fill.Size = UDim2.new(percent, 0, 1, 0)
                fill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(0, 2)
                fillCorner.Parent = fill
                
                fill.Parent = sliderBg
                
                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 18, 0, 18)
                knob.Position = UDim2.new(percent, -9, 0.5, -9)
                knob.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                
                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(0, 9)
                knobCorner.Parent = knob
                
                knob.Parent = sliderBg
                
                local dragging = false
                local value = default
                
                local function update(input)
                    local relative = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
                    local newVal = min + (relative * (max - min))
                    value = math.floor(newVal + 0.5)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    knob.Position = UDim2.new(relative, -9, 0.5, -9)
                    if callback then callback(value) end
                end
                
                knob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                UIS.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
                
                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        update(input)
                        dragging = true
                    end
                end)
                
                table.insert(section.Items, frame)
                return {setValue = function(v)
                    value = math.clamp(v, min, max)
                    local p = (value - min) / (max - min)
                    valueLabel.Text = tostring(value)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -9, 0.5, -9)
                    if callback then callback(value) end
                end}
            end
            
            -- Dropdown creator
            function section:AddDropdown(text, options, default, callback)
                local frame = Instance.new("Frame")
                frame.Size = UDim2.new(1, 0, 0, Device.ButtonHeight)
                frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
                
                local frameCorner = Instance.new("UICorner")
                frameCorner.CornerRadius = UDim.new(0, 8)
                frameCorner.Parent = frame
                
                local frameStroke = Instance.new("UIStroke")
                frameStroke.Thickness = 1
                frameStroke.Color = Color3.fromRGB(80, 80, 120)
                frameStroke.Parent = frame
                
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
                
                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 6)
                dropdownCorner.Parent = dropdownBtn
                
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
                    list.ZIndex = 100
                    
                    local listCorner = Instance.new("UICorner")
                    listCorner.CornerRadius = UDim.new(0, 6)
                    listCorner.Parent = list
                    
                    local listStroke = Instance.new("UIStroke")
                    listStroke.Thickness = 1
                    listStroke.Color = Color3.fromRGB(80, 80, 120)
                    listStroke.Parent = list
                    
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
                        optBtn.Position = UDim2.new(0, 5, 0, height)
                        optBtn.Text = opt
                        optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
                        optBtn.TextSize = Device.FontSize - 2
                        optBtn.Font = Enum.Font.Gotham
                        optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                        
                        local optCorner = Instance.new("UICorner")
                        optCorner.CornerRadius = UDim.new(0, 4)
                        optCorner.Parent = optBtn
                        
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
                
                table.insert(section.Items, frame)
                return {setValue = function(val)
                    dropdownBtn.Text = val
                    if callback then callback(val) end
                end}
            end
            
            -- Gamepass button creator
            function section:AddGamepassButton(options)
                local gamepassId = options.GamepassId
                local name = options.Name or "Purchase Gamepass"
                local price = options.Price or "???"
                local onPurchase = options.OnPurchase or function() end
                
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, Device.ButtonHeight + 10)
                btn.BackgroundColor3 = Color3.fromRGB(35, 45, 55)
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 8)
                btnCorner.Parent = btn
                
                local btnStroke = Instance.new("UIStroke")
                btnStroke.Thickness = 1
                btnStroke.Color = Color3.fromRGB(100, 200, 100)
                btnStroke.Parent = btn
                
                btn.Parent = elementsFrame
                
                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 30, 1, 0)
                icon.Position = UDim2.new(0, 12, 0, 0)
                icon.Text = "💰"
                icon.TextSize = 18
                icon.BackgroundTransparency = 1
                icon.Parent = btn
                
                local titleL = Instance.new("TextLabel")
                titleL.Size = UDim2.new(1, -100, 0, 22)
                titleL.Position = UDim2.new(0, 55, 0, 8)
                titleL.Text = name
                titleL.TextColor3 = Color3.fromRGB(255, 255, 255)
                titleL.TextSize = Device.FontSize
                titleL.Font = Enum.Font.GothamSemibold
                titleL.TextXAlignment = Enum.TextXAlignment.Left
                titleL.BackgroundTransparency = 1
                titleL.Parent = btn
                
                local priceL = Instance.new("TextLabel")
                priceL.Size = UDim2.new(1, -100, 0, 18)
                priceL.Position = UDim2.new(0, 55, 0, 30)
                priceL.Text = price .. " Robux"
                priceL.TextColor3 = Color3.fromRGB(180, 200, 180)
                priceL.TextSize = Device.FontSize - 2
                priceL.Font = Enum.Font.Gotham
                priceL.TextXAlignment = Enum.TextXAlignment.Left
                priceL.BackgroundTransparency = 1
                priceL.Parent = btn
                
                btn.MouseEnter:Connect(function()
                    TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 55, 65)}):Play()
                end)
                
                btn.MouseLeave:Connect(function()
                    TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35, 45, 55)}):Play()
                end)
                
                btn.MouseButton1Click:Connect(function()
                    MPS:PromptGamePassPurchase(LP, gamepassId)
                    AddNotification("Gamepass", "Purchase prompt sent for " .. name, "info", 2, "OK", nil)
                    onPurchase()
                end)
                
                table.insert(section.Items, btn)
                return btn
            end
            
            -- Label creator
            function section:AddLabel(text)
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 0, 25)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Text = text
                label.TextColor3 = Color3.fromRGB(180, 180, 210)
                label.TextSize = Device.FontSize - 2
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.BackgroundTransparency = 1
                label.Parent = elementsFrame
                table.insert(section.Items, label)
                return label
            end
            
            table.insert(tab.Sections, section)
            return section
        end
        
        table.insert(self.Tabs, tab)
        
        -- Select first tab automatically
        if #self.Tabs == 1 then
            selectTab()
        end
        
        return tab
    end
    
    -- User info display
    function self:AddUserInfo()
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 90)
        frame.Position = UDim2.new(0, 10, 0, 0)
        frame.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 10)
        frameCorner.Parent = frame
        
        local frameStroke = Instance.new("UIStroke")
        frameStroke.Thickness = 1
        frameStroke.Color = Color3.fromRGB(80, 80, 120)
        frameStroke.Parent = frame
        
        frame.Parent = self.TabContainer
        
        local avatar = Instance.new("Frame")
        avatar.Size = UDim2.new(0, 55, 0, 55)
        avatar.Position = UDim2.new(0, 12, 0, 17)
        avatar.BackgroundColor3 = Color3.fromRGB(55, 55, 85)
        
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(0, 27)
        avatarCorner.Parent = avatar
        
        local avatarStroke = Instance.new("UIStroke")
        avatarStroke.Thickness = 2
        avatarStroke.Color = Color3.fromRGB(100, 100, 255)
        avatarStroke.Parent = avatar
        
        avatar.Parent = frame
        
        local avatarText = Instance.new("TextLabel")
        avatarText.Size = UDim2.new(1, 0, 1, 0)
        avatarText.Text = "👤"
        avatarText.TextSize = 28
        avatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
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
    
    -- Notification methods
    function self:Notify(title, message, typ, duration)
        return AddNotification(title, message, typ, duration)
    end
    
    function self:NotifyWithButton(title, message, typ, duration, buttonText, buttonCallback)
        return AddNotification(title, message, typ, duration, buttonText, buttonCallback)
    end
    
    function self:ShowLoading(message, duration)
        return ShowLoading(message, duration)
    end
    
    function self:GetDeviceInfo()
        return Device.Type, Device.RecommendedWidth, Device.RecommendedHeight
    end
    
    function self:Destroy()
        self.ScreenGui:Destroy()
    end
    
    return self
end

-- ============================================================================
-- EXPORT
-- ============================================================================
return {
    CreateWindow = function(name, w, h) return Fubnik:CreateWindow(name, w, h) end,
    Notify = AddNotification,
    Device = Device
}
