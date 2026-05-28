--[[
    ╔═══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                               ║
    ║   ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗██╗  ██╗    ██╗   ██╗██████╗         ║
    ║   ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚██╗██╔╝    ██║   ██║╚════██╗        ║
    ║   █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║ ╚███╔╝     ██║   ██║ █████╔╝        ║
    ║   ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║ ██╔██╗     ╚██╗ ██╔╝██╔═══╝         ║
    ║   ██║     ╚██████╔╝██████╔╝██║ ╚████║██║██╔╝ ██╗     ╚████╔╝ ███████╗        ║
    ║   ╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝      ╚═══╝  ╚══════╝        ║
    ║                                                                               ║
    ║                    FUBNIK FRAMEWORK v3.0                                       ║
    ║              Fully Customizable UI System                                      ║
    ║         Gamepass Integration | Color System | No Limits                        ║
    ╚═══════════════════════════════════════════════════════════════════════════════╝
--]]

-- ================================================================================
-- COLOR SYSTEM - Full artistic control
-- ================================================================================

local ColorSystem = {
    -- Predefined colors with shades
    colors = {
        red = {
            bright = Color3.fromRGB(255, 80, 80),
            dark = Color3.fromRGB(139, 0, 0),
            crimson = Color3.fromRGB(220, 20, 60),
            blood = Color3.fromRGB(102, 0, 0),
            rose = Color3.fromRGB(255, 102, 102),
            maroon = Color3.fromRGB(128, 0, 0),
            brick = Color3.fromRGB(156, 62, 62),
            rust = Color3.fromRGB(183, 65, 14),
            candy = Color3.fromRGB(255, 50, 50),
            cherry = Color3.fromRGB(222, 49, 99),
        },
        blue = {
            bright = Color3.fromRGB(80, 80, 255),
            dark = Color3.fromRGB(0, 0, 139),
            ocean = Color3.fromRGB(0, 119, 190),
            sky = Color3.fromRGB(135, 206, 235),
            navy = Color3.fromRGB(0, 0, 128),
            cyan = Color3.fromRGB(0, 255, 255),
            royal = Color3.fromRGB(65, 105, 225),
            steel = Color3.fromRGB(70, 130, 180),
            ice = Color3.fromRGB(173, 216, 230),
            deep = Color3.fromRGB(0, 50, 100),
        },
        green = {
            bright = Color3.fromRGB(80, 255, 80),
            dark = Color3.fromRGB(0, 100, 0),
            lime = Color3.fromRGB(50, 205, 50),
            forest = Color3.fromRGB(34, 139, 34),
            emerald = Color3.fromRGB(80, 200, 120),
            mint = Color3.fromRGB(152, 255, 152),
            olive = Color3.fromRGB(128, 128, 0),
            neon = Color3.fromRGB(57, 255, 20),
            sea = Color3.fromRGB(46, 139, 87),
            sage = Color3.fromRGB(156, 184, 108),
        },
        purple = {
            bright = Color3.fromRGB(200, 80, 255),
            dark = Color3.fromRGB(75, 0, 130),
            lavender = Color3.fromRGB(230, 200, 255),
            violet = Color3.fromRGB(138, 43, 226),
            plum = Color3.fromRGB(221, 160, 221),
            orchid = Color3.fromRGB(218, 112, 214),
            indigo = Color3.fromRGB(75, 0, 130),
            magenta = Color3.fromRGB(255, 0, 255),
            grape = Color3.fromRGB(111, 45, 168),
            royalPurple = Color3.fromRGB(120, 81, 169),
        },
        orange = {
            bright = Color3.fromRGB(255, 165, 80),
            dark = Color3.fromRGB(204, 85, 0),
            tangerine = Color3.fromRGB(255, 140, 0),
            pumpkin = Color3.fromRGB(255, 117, 24),
            coral = Color3.fromRGB(255, 127, 80),
            peach = Color3.fromRGB(255, 200, 150),
            amber = Color3.fromRGB(255, 191, 0),
            gold = Color3.fromRGB(255, 215, 0),
            sunset = Color3.fromRGB(253, 94, 83),
            fire = Color3.fromRGB(255, 69, 0),
        },
        yellow = {
            bright = Color3.fromRGB(255, 255, 80),
            dark = Color3.fromRGB(204, 204, 0),
            lemon = Color3.fromRGB(255, 255, 150),
            banana = Color3.fromRGB(255, 240, 140),
            honey = Color3.fromRGB(255, 215, 100),
            mustard = Color3.fromRGB(255, 219, 88),
            sunflower = Color3.fromRGB(255, 218, 52),
            cream = Color3.fromRGB(255, 253, 208),
            butter = Color3.fromRGB(255, 247, 153),
            canary = Color3.fromRGB(255, 255, 102),
        },
        pink = {
            bright = Color3.fromRGB(255, 105, 180),
            dark = Color3.fromRGB(231, 84, 128),
            hot = Color3.fromRGB(255, 105, 180),
            baby = Color3.fromRGB(255, 182, 193),
            bubblegum = Color3.fromRGB(255, 192, 203),
            rose = Color3.fromRGB(255, 102, 204),
            salmon = Color3.fromRGB(250, 128, 114),
            flamingo = Color3.fromRGB(252, 142, 172),
            blush = Color3.fromRGB(255, 140, 160),
            cotton = Color3.fromRGB(255, 200, 210),
        },
        gray = {
            bright = Color3.fromRGB(200, 200, 200),
            dark = Color3.fromRGB(64, 64, 64),
            silver = Color3.fromRGB(192, 192, 192),
            charcoal = Color3.fromRGB(54, 69, 79),
            slate = Color3.fromRGB(112, 128, 144),
            ash = Color3.fromRGB(169, 169, 169),
            smoke = Color3.fromRGB(128, 128, 128),
            dim = Color3.fromRGB(105, 105, 105),
            light = Color3.fromRGB(211, 211, 211),
            gunmetal = Color3.fromRGB(44, 53, 57),
        },
        white = {
            pure = Color3.fromRGB(255, 255, 255),
            snow = Color3.fromRGB(255, 250, 250),
            ivory = Color3.fromRGB(255, 255, 240),
            pearl = Color3.fromRGB(248, 248, 255),
            off = Color3.fromRGB(250, 250, 250),
            ghost = Color3.fromRGB(248, 248, 255),
            floral = Color3.fromRGB(255, 250, 240),
            linen = Color3.fromRGB(250, 240, 230),
            antique = Color3.fromRGB(250, 235, 215),
            beige = Color3.fromRGB(245, 245, 220),
        },
        black = {
            pure = Color3.fromRGB(0, 0, 0),
            jet = Color3.fromRGB(20, 20, 20),
            obsidian = Color3.fromRGB(10, 10, 10),
            onyx = Color3.fromRGB(35, 35, 35),
            midnight = Color3.fromRGB(25, 25, 45),
            carbon = Color3.fromRGB(30, 30, 30),
            charcoal = Color3.fromRGB(40, 40, 40),
            shadow = Color3.fromRGB(15, 15, 15),
            ink = Color3.fromRGB(8, 8, 12),
            void = Color3.fromRGB(5, 5, 5),
        }
    },
    
    -- Convert hex to Color3
    hexToRGB = function(hex)
        hex = hex:gsub("#", "")
        local r = tonumber(hex:sub(1,2), 16) or 0
        local g = tonumber(hex:sub(3,4), 16) or 0
        local b = tonumber(hex:sub(5,6), 16) or 0
        return Color3.fromRGB(r, g, b)
    end,
    
    -- Create gradient colors
    createGradient = function(color1, color2, steps)
        local gradient = {}
        local r1, g1, b1 = color1.R * 255, color1.G * 255, color1.B * 255
        local r2, g2, b2 = color2.R * 255, color2.G * 255, color2.B * 255
        
        for i = 0, steps do
            local t = i / steps
            local r = r1 + (r2 - r1) * t
            local g = g1 + (g2 - g1) * t
            local b = b1 + (b2 - b1) * t
            table.insert(gradient, Color3.fromRGB(r, g, b))
        end
        return gradient
    end
}

-- ================================================================================
-- GAMEPASS SYSTEM
-- ================================================================================

local GamepassSystem = {}
GamepassSystem.callbacks = {}
GamepassSystem.ownedPasses = {}

-- Check if user owns a gamepass
function GamepassSystem:Owns(passId)
    local success, result = pcall(function()
        return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(
            game.Players.LocalPlayer.UserId,
            passId
        )
    end)
    if success then
        self.ownedPasses[passId] = result
        return result
    end
    return false
end

-- Add callback for when pass is purchased or already owned
function GamepassSystem:OnPurchase(passId, callback, runIfOwned)
    if not self.callbacks[passId] then
        self.callbacks[passId] = {}
    end
    table.insert(self.callbacks[passId], callback)
    
    if runIfOwned and self:Owns(passId) then
        callback("already_owned")
    end
end

-- Process prompt purchase
function GamepassSystem:PromptPurchase(passId)
    game:GetService("MarketplaceService"):PromptGamePassPurchase(
        game.Players.LocalPlayer,
        passId
    )
    
    -- Monitor for purchase
    local connection
    connection = game:GetService("MarketplaceService").ProcessReceipt:Connect(function(receiptInfo)
        if receiptInfo.ProductId == passId and receiptInfo.PlayerId == game.Players.LocalPlayer.UserId then
            if receiptInfo.PurchaseStatus == Enum.PurchaseStatus.Purchased then
                self.ownedPasses[passId] = true
                if self.callbacks[passId] then
                    for _, callback in pairs(self.callbacks[passId]) do
                        callback("purchased")
                    end
                end
            end
            connection:Disconnect()
        end
        return Enum.ProductPurchaseDecision.PurchaseGranted
    end)
end

-- ================================================================================
-- NOTIFICATION SYSTEM
-- ================================================================================

local NotificationSystem = {}
NotificationSystem.activeNotifications = {}
NotificationSystem.customButtons = {}

-- Create notification holder
local notificationHolder = Instance.new("ScreenGui")
notificationHolder.Name = "FUBNIK_Notifications"
notificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
notificationHolder.Parent = game:GetService("CoreGui")

local notificationList = Instance.new("Frame")
notificationList.Name = "NotificationList"
notificationList.Size = UDim2.new(0, 320, 1, 0)
notificationList.Position = UDim2.new(1, -330, 0, 10)
notificationList.BackgroundTransparency = 1
notificationList.Parent = notificationHolder

-- Add custom notification button
function NotificationSystem:AddButton(buttonText, buttonColor, callback)
    table.insert(self.customButtons, {
        text = buttonText,
        color = buttonColor,
        callback = callback
    })
end

-- Show notification
function NotificationSystem:Show(title, message, duration, buttons)
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(1, -10, 0, 0)
    notification.Position = UDim2.new(0, 0, 1, 5)
    notification.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notification.BackgroundTransparency = 0.05
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.Parent = notificationList
    
    -- Auto height
    local contentHeight = 70
    
    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = notification
    
    -- Message
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 40)
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    msgLabel.TextSize = 13
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Parent = notification
    
    local buttonFrame = nil
    local buttonCount = 0
    
    -- Add custom buttons if provided
    if buttons and #buttons > 0 then
        buttonFrame = Instance.new("Frame")
        buttonFrame.Size = UDim2.new(1, -20, 0, 35)
        buttonFrame.Position = UDim2.new(0, 10, 0, 75)
        buttonFrame.BackgroundTransparency = 1
        buttonFrame.Parent = notification
        
        local buttonWidth = 80
        local spacing = 10
        
        for i, btn in pairs(buttons) do
            local btnObj = Instance.new("TextButton")
            btnObj.Size = UDim2.new(0, buttonWidth, 0, 30)
            btnObj.Position = UDim2.new(0, (i-1) * (buttonWidth + spacing), 0, 0)
            btnObj.Text = btn.text
            btnObj.TextSize = 12
            btnObj.Font = Enum.Font.GothamBold
            btnObj.BackgroundColor3 = btn.color or Color3.fromRGB(70, 70, 80)
            btnObj.BorderSizePixel = 0
            btnObj.TextColor3 = Color3.fromRGB(255, 255, 255)
            btnObj.AutoButtonColor = true
            
            btnObj.MouseButton1Click:Connect(function()
                if btn.callback then btn.callback() end
                notification:Destroy()
            end)
            
            btnObj.Parent = buttonFrame
            buttonCount = buttonCount + 1
        end
        
        contentHeight = 120
    end
    
    notification.Size = UDim2.new(1, -10, 0, contentHeight)
    
    -- Animate in
    notification.Position = UDim2.new(0, 0, 1, 5)
    local tween = game:GetService("TweenService"):Create(notification, 
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, 5)}
    )
    tween:Play()
    
    -- Auto remove after duration
    task.delay(duration or 3, function()
        if notification and notification.Parent then
            local outTween = game:GetService("TweenService"):Create(notification,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {Position = UDim2.new(0, 0, 1, 5)}
            )
            outTween:Play()
            outTween.Completed:Connect(function()
                notification:Destroy()
            end)
        end
    end)
    
    return notification
end

-- ================================================================================
-- CUSTOMIZABLE UI ELEMENT CLASS
-- ================================================================================

local Element = {}
Element.__index = Element

function Element.new(type, parent, name)
    local self = {}
    self.instance = Instance.new(type)
    self.instance.Name = name or "Element"
    self.instance.Parent = parent
    self.properties = {}
    self.customColors = {}
    return setmetatable(self, Element)
end

function Element:SetColor(color, elementType)
    if type(color) == "string" then
        -- Check if it's a color name like "red.crimson" or "blue.ocean"
        local colorParts = {}
        for part in color:gmatch("[^.]+") do
            table.insert(colorParts, part)
        end
        
        if #colorParts == 2 then
            local colorFamily = ColorSystem.colors[colorParts[1]]
            if colorFamily and colorFamily[colorParts[2]] then
                color = colorFamily[colorParts[2]]
            else
                color = Color3.fromRGB(255, 255, 255)
            end
        elseif ColorSystem.colors[color] then
            -- Default to bright variant
            color = ColorSystem.colors[color].bright
        elseif color:match("^#") then
            color = ColorSystem.hexToRGB(color)
        else
            color = Color3.fromRGB(255, 255, 255)
        end
    end
    
    if elementType == "background" then
        self.instance.BackgroundColor3 = color
        self.instance.BackgroundTransparency = 0
    elseif elementType == "text" then
        self.instance.TextColor3 = color
    elseif elementType == "border" then
        self.instance.BorderColor3 = color
    else
        self.instance.BackgroundColor3 = color
    end
    
    return self
end

function Element:SetGradient(color1, color2, direction)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    if direction == "horizontal" then
        gradient.Rotation = 0
    elseif direction == "vertical" then
        gradient.Rotation = 90
    elseif direction == "diagonal" then
        gradient.Rotation = 45
    end
    gradient.Parent = self.instance
    return self
end

function Element:SetSize(width, height, scale)
    if scale then
        self.instance.Size = UDim2.new(0, width, 0, height)
    else
        self.instance.Size = UDim2.new(width, 0, height, 0)
    end
    return self
end

function Element:SetPosition(x, y, anchorX, anchorY)
    self.instance.Position = UDim2.new(x, 0, y, 0)
    if anchorX and anchorY then
        self.instance.AnchorPoint = Vector2.new(anchorX, anchorY)
    end
    return self
end

function Element:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.instance.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.instance.Position
        end
    end)
    
    self.instance.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.instance.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    return self
end

function Element:SetText(text)
    if self.instance:IsA("TextLabel") or self.instance:IsA("TextButton") then
        self.instance.Text = text
    end
    return self
end

function Element:OnClick(callback)
    if self.instance:IsA("TextButton") or self.instance:IsA("ImageButton") then
        self.instance.MouseButton1Click:Connect(callback)
    end
    return self
end

-- ================================================================================
-- CUSTOMIZABLE HUB CLASS
-- ================================================================================

local Hub = {}
Hub.__index = Hub

function Hub:CreateWindow(title, customSettings)
    local self = setmetatable({}, Hub)
    
    self.title = title or "FUBNIK Hub"
    self.elements = {}
    self.tabs = {}
    self.currentTab = nil
    self.customColors = customSettings or {}
    
    -- Create Main GUI
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "FUBNIK_Hub_v3"
    self.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.gui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    self.mainFrame = Element.new("Frame", self.gui, "MainFrame")
    self.mainFrame.instance.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    self.mainFrame.instance.BorderSizePixel = 0
    self.mainFrame.instance.ClipsDescendants = true
    
    -- Default size (will be adjustable)
    self.mainFrame:SetSize(450, 600, false)
    self.mainFrame:SetPosition(0.5, 0.5, 0.5, 0.5)
    self.mainFrame.instance.Position = UDim2.new(0.5, -225, 0.5, -300)
    self.mainFrame:MakeDraggable()
    
    -- Top Bar
    self.topBar = Element.new("Frame", self.mainFrame.instance, "TopBar")
    self.topBar:SetSize(1, 40, true)
    self.topBar.instance.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    self.topBar.instance.BorderSizePixel = 0
    
    -- Title Label
    self.titleLabel = Element.new("TextLabel", self.topBar.instance, "Title")
    self.titleLabel:SetSize(0.6, 1, true)
    self.titleLabel:SetPosition(0.05, 0)
    self.titleLabel.instance.BackgroundTransparency = 1
    self.titleLabel:SetText(title)
    self.titleLabel.instance.TextSize = 18
    self.titleLabel.instance.TextXAlignment = Enum.TextXAlignment.Left
    self.titleLabel.instance.Font = Enum.Font.GothamBold
    self.titleLabel:SetColor("white.pure", "text")
    
    -- Close Button
    self.closeBtn = Element.new("TextButton", self.topBar.instance, "CloseBtn")
    self.closeBtn:SetSize(40, 40, false)
    self.closeBtn:SetPosition(1, 0, 1, 0)
    self.closeBtn.instance.Text = "✕"
    self.closeBtn.instance.TextSize = 20
    self.closeBtn.instance.BackgroundTransparency = 1
    self.closeBtn:SetColor("red.crimson", "text")
    self.closeBtn:OnClick(function()
        self.mainFrame.instance.Visible = not self.mainFrame.instance.Visible
        if self.mainFrame.instance.Visible then
            self:Notify("UI", "Hub shown", "info", 1.5)
        end
    end)
    
    -- Minimize Button
    self.minimizeBtn = Element.new("TextButton", self.topBar.instance, "MinimizeBtn")
    self.minimizeBtn:SetSize(40, 40, false)
    self.minimizeBtn:SetPosition(1, -40, 1, 0)
    self.minimizeBtn.instance.Text = "−"
    self.minimizeBtn.instance.TextSize = 20
    self.minimizeBtn.instance.BackgroundTransparency = 1
    self.minimizeBtn:SetColor("white.pure", "text")
    self.minimizeBtn:OnClick(function()
        local minimized = self.mainFrame.instance.Size.Y.Offset < 100
        if minimized then
            self.mainFrame.instance:TweenSize(UDim2.new(0, 450, 0, 600), "Out", "Quad", 0.3)
        else
            self.mainFrame.instance:TweenSize(UDim2.new(0, 450, 0, 50), "Out", "Quad", 0.3)
        end
    end)
    
    -- Tab Container
    self.tabContainer = Element.new("Frame", self.mainFrame.instance, "TabContainer")
    self.tabContainer:SetSize(1, 40, true)
    self.tabContainer:SetPosition(0, 40)
    self.tabContainer.instance.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    self.tabContainer.instance.BorderSizePixel = 0
    
    -- Tab Buttons Frame (scrollable)
    self.tabButtonsFrame = Element.new("ScrollingFrame", self.tabContainer.instance, "TabButtons")
    self.tabButtonsFrame:SetSize(1, 1, true)
    self.tabButtonsFrame.instance.BackgroundTransparency = 1
    self.tabButtonsFrame.instance.ScrollBarThickness = 3
    self.tabButtonsFrame.instance.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Content Container
    self.contentContainer = Element.new("Frame", self.mainFrame.instance, "Content")
    self.contentContainer:SetSize(1, -80, true)
    self.contentContainer:SetPosition(0, 80)
    self.contentContainer.instance.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    self.contentContainer.instance.BorderSizePixel = 0
    
    -- Make content scrollable
    self.scrollFrame = Element.new("ScrollingFrame", self.contentContainer.instance, "ScrollFrame")
    self.scrollFrame:SetSize(1, 1, true)
    self.scrollFrame.instance.BackgroundTransparency = 1
    self.scrollFrame.instance.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.scrollFrame.instance.ScrollBarThickness = 6
    
    self.contentLayout = Element.new("UIListLayout", self.scrollFrame.instance, "ContentLayout")
    self.contentLayout.instance.Padding = UDim.new(0, 10)
    self.contentLayout.instance.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Update canvas size when content changes
    self.contentLayout.instance:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.scrollFrame.instance.CanvasSize = UDim2.new(0, 0, 0, self.contentLayout.instance.AbsoluteContentSize.Y + 20)
    end)
    
    return self
end

function Hub:AddTab(tabName, icon, customSettings)
    local tab = {}
    tab.name = tabName
    tab.icon = icon or "📄"
    tab.sections = {}
    tab.frame = Element.new("Frame", self.scrollFrame.instance, tabName .. "_Tab")
    tab.frame:SetSize(1, 0, true)
    tab.frame.instance.BackgroundTransparency = 1
    tab.frame.instance.Visible = false
    tab.frame.instance.LayoutOrder = 1
    
    -- Tab button
    local btn = Element.new("TextButton", self.tabButtonsFrame.instance, tabName .. "_Btn")
    btn:SetSize(80, 36, false)
    btn:SetPosition(0, 0)
    btn.instance.Text = icon .. " " .. tabName
    btn.instance.TextSize = 13
    btn.instance.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    btn.instance.BorderSizePixel = 0
    btn.instance.AutoButtonColor = true
    
    -- Position buttons horizontally
    local buttonPos = (#self.tabs) * 85
    btn:SetPosition(buttonPos / self.tabButtonsFrame.instance.AbsoluteSize.X, 0)
    self.tabButtonsFrame.instance.CanvasSize = UDim2.new(0, (#self.tabs + 1) * 85, 0, 0)
    
    btn:OnClick(function()
        self:SelectTab(tabName)
    end)
    
    tab.btn = btn
    tab.sectionsLayout = Element.new("UIListLayout", tab.frame.instance, tabName .. "_Layout")
    tab.sectionsLayout.instance.Padding = UDim.new(0, 10)
    tab.sectionsLayout.instance.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Update tab frame height
    tab.sectionsLayout.instance:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.frame:SetSize(1, tab.sectionsLayout.instance.AbsoluteContentSize.Y + 20, false)
    end)
    
    self.tabs[tabName] = tab
    
    if not self.currentTab then
        self:SelectTab(tabName)
    end
    
    return {
        AddSection = function(_, sectionName)
            return self:AddSection(tabName, sectionName)
        end
    }
end

function Hub:SelectTab(tabName)
    if self.currentTab then
        local oldTab = self.tabs[self.currentTab]
        if oldTab then
            oldTab.frame.instance.Visible = false
            oldTab.btn.instance.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
        end
    end
    
    self.currentTab = tabName
    local newTab = self.tabs[tabName]
    if newTab then
        newTab.frame.instance.Visible = true
        newTab.btn.instance.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end
end

function Hub:AddSection(tabName, sectionName, customSettings)
    local tab = self.tabs[tabName]
    if not tab then return nil end
    
    local section = {}
    section.frame = Element.new("Frame", tab.frame.instance, sectionName .. "_Section")
    section.frame:SetSize(1, 0, true)
    section.frame.instance.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    section.frame.instance.BorderSizePixel = 0
    
    -- Section header
    local header = Element.new("TextLabel", section.frame.instance, "Header")
    header:SetSize(1, 35, true)
    header:SetPosition(0, 0)
    header.instance.Text = "  " .. sectionName
    header.instance.TextSize = 14
    header.instance.TextXAlignment = Enum.TextXAlignment.Left
    header.instance.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
    header.instance.BorderSizePixel = 0
    header:SetColor("white.pure", "text")
    header.instance.Font = Enum.Font.GothamBold
    
    -- Content container
    section.content = Element.new("Frame", section.frame.instance, "Content")
    section.content:SetSize(1, 0, true)
    section.content:SetPosition(0, 35)
    section.content.instance.BackgroundTransparency = 1
    
    section.layout = Element.new("UIListLayout", section.content.instance, "Layout")
    section.layout.instance.Padding = UDim.new(0, 8)
    section.layout.instance.SortOrder = Enum.SortOrder.LayoutOrder
    
    -- Update section height
    section.layout.instance:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentHeight = section.layout.instance.AbsoluteContentSize.Y
        section.frame:SetSize(1, 35 + contentHeight + 15, false)
        section.content:SetSize(1, contentHeight + 5, false)
    end)
    
    table.insert(tab.sections, section)
    
    -- Return section methods
    return {
        AddLabel = function(_, text, color)
            local label = Element.new("TextLabel", section.content.instance, "Label")
            label:SetSize(1, 25, true)
            label.instance.Text = "  " .. text
            label.instance.TextSize = 13
            label.instance.TextXAlignment = Enum.TextXAlignment.Left
            label.instance.BackgroundTransparency = 1
            if color then
                label:SetColor(color, "text")
            else
                label:SetColor("gray.light", "text")
            end
            label.instance.Font = Enum.Font.Gotham
            return {
                SetText = function(_, newText)
                    label.instance.Text = "  " .. newText
                end
            }
        end,
        
        AddButton = function(_, buttonText, callback, color)
            local btn = Element.new("TextButton", section.content.instance, "Button_" .. buttonText)
            btn:SetSize(0.95, 35, true)
            btn:SetPosition(0.025, 0)
            btn.instance.Text = buttonText
            btn.instance.TextSize = 14
            btn.instance.Font = Enum.Font.GothamBold
            btn.instance.BackgroundColor3 = color and (type(color) == "string" and (ColorSystem.colors[color] and ColorSystem.colors[color].bright or Color3.fromRGB(70, 70, 80)) or color) or Color3.fromRGB(70, 70, 80)
            btn.instance.BorderSizePixel = 0
            btn.instance.AutoButtonColor = true
            btn:OnClick(callback)
            return btn
        end,
        
        AddToggle = function(_, toggleText, defaultValue, callback)
            local container = Element.new("Frame", section.content.instance, "Toggle_" .. toggleText)
            container:SetSize(1, 35, true)
            container.instance.BackgroundTransparency = 1
            
            local label = Element.new("TextLabel", container.instance, "Label")
            label:SetSize(0.7, 1, true)
            label:SetPosition(0.05, 0)
            label.instance.Text = toggleText
            label.instance.TextSize = 13
            label.instance.TextXAlignment = Enum.TextXAlignment.Left
            label.instance.BackgroundTransparency = 1
            label:SetColor("gray.light", "text")
            
            local toggleBtn = Element.new("TextButton", container.instance, "ToggleBtn")
            toggleBtn:SetSize(60, 30, false)
            toggleBtn:SetPosition(0.95, 0.5, 1, 0.5)
            toggleBtn.instance.Text = defaultValue and "ON" or "OFF"
            toggleBtn.instance.TextSize = 12
            toggleBtn.instance.Font = Enum.Font.GothamBold
            toggleBtn.instance.BackgroundColor3 = defaultValue and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
            toggleBtn.instance.BorderSizePixel = 0
            
            local state = defaultValue
            toggleBtn:OnClick(function()
                state = not state
                toggleBtn.instance.Text = state and "ON" or "OFF"
                toggleBtn.instance.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
                callback(state)
            end)
            
            return {
                setValue = function(_, newState)
                    state = newState
                    toggleBtn.instance.Text = state and "ON" or "OFF"
                    toggleBtn.instance.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
                    callback(state)
                end
            }
        end,
        
        AddSlider = function(_, sliderText, minVal, maxVal, defaultVal, callback)
            local container = Element.new("Frame", section.content.instance, "Slider_" .. sliderText)
            container:SetSize(1, 55, true)
            container.instance.BackgroundTransparency = 1
            
            local label = Element.new("TextLabel", container.instance, "Label")
            label:SetSize(1, 20, true)
            label.instance.Text = sliderText .. ": " .. defaultVal
            label.instance.TextSize = 12
            label.instance.TextXAlignment = Enum.TextXAlignment.Left
            label.instance.BackgroundTransparency = 1
            label:SetColor("gray.light", "text")
            
            local slider = Instance.new("TextBox")
            slider.Size = UDim2.new(0.7, 0, 0, 30)
            slider.Position = UDim2.new(0.05, 0, 0.4, 0)
            slider.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
            slider.BorderSizePixel = 0
            slider.TextColor3 = Color3.fromRGB(255, 255, 255)
            slider.Text = tostring(defaultVal)
            slider.TextSize = 14
            slider.Parent = container.instance
            
            local function updateValue(val)
                local clamped = math.clamp(tonumber(val) or defaultVal, minVal, maxVal)
                label.instance.Text = sliderText .. ": " .. math.floor(clamped)
                slider.Text = tostring(math.floor(clamped))
                callback(math.floor(clamped))
            end
            
            slider.FocusLost:Connect(function()
                updateValue(slider.Text)
            end)
            
            updateValue(defaultVal)
            
            return {
                setValue = function(_, val)
                    updateValue(val)
                end
            }
        end,
        
        AddDropdown = function(_, dropdownText, options, defaultOption, callback)
            local container = Element.new("Frame", section.content.instance, "Dropdown_" .. dropdownText)
            container:SetSize(1, 45, true)
            container.instance.BackgroundTransparency = 1
            
            local label = Element.new("TextLabel", container.instance, "Label")
            label:SetSize(0.4, 1, true)
            label:SetPosition(0.05, 0)
            label.instance.Text = dropdownText
            label.instance.TextSize = 13
            label.instance.TextXAlignment = Enum.TextXAlignment.Left
            label.instance.BackgroundTransparency = 1
            label:SetColor("gray.light", "text")
            
            local dropdown = Instance.new("TextButton")
            dropdown.Size = UDim2.new(0.45, 0, 0, 35)
            dropdown.Position = UDim2.new(0.5, 0, 0.05, 0)
            dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
            dropdown.BorderSizePixel = 0
            dropdown.Text = defaultOption or options[1]
            dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
            dropdown.TextSize = 13
            dropdown.Font = Enum.Font.Gotham
            dropdown.Parent = container.instance
            
            local isOpen = false
            local listFrame = nil
            
            dropdown.MouseButton1Click:Connect(function()
                if isOpen then
                    if listFrame then listFrame:Destroy() end
                    isOpen = false
                    return
                end
                
                isOpen = true
                listFrame = Instance.new("Frame")
                listFrame.Size = UDim2.new(0.45, 0, 0, #options * 30)
                listFrame.Position = UDim2.new(0.5, 0, 0.05, 40)
                listFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
                listFrame.BorderSizePixel = 0
                listFrame.ClipsDescendants = true
                listFrame.Parent = container.instance
                
                local listLayout = Instance.new("UIListLayout")
                listLayout.Padding = UDim.new(0, 2)
                listLayout.Parent = listFrame
                
                for _, option in pairs(options) do
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, 0, 0, 30)
                    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                    btn.BorderSizePixel = 0
                    btn.Text = option
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.TextSize = 12
                    btn.Parent = listFrame
                    
                    btn.MouseButton1Click:Connect(function()
                        dropdown.Text = option
                        callback(option)
                        listFrame:Destroy()
                        isOpen = false
                    end)
                end
            end)
            
            return {
                setValue = function(_, val)
                    dropdown.Text = val
                    callback(val)
                end
            }
        end,
        
        AddGamepassButton = function(_, passId, buttonText, afterPurchaseCallback, color, runIfOwned)
            local btn = Element.new("TextButton", section.content.instance, "Gamepass_" .. passId)
            btn:SetSize(0.95, 40, true)
            btn:SetPosition(0.025, 0)
            btn.instance.Text = "🎮 " .. buttonText
            btn.instance.TextSize = 14
            btn.instance.Font = Enum.Font.GothamBold
            btn.instance.BackgroundColor3 = color and (type(color) == "string" and (ColorSystem.colors[color] and ColorSystem.colors[color].bright or Color3.fromRGB(70, 70, 80)) or color) or Color3.fromRGB(88, 86, 214)
            btn.instance.BorderSizePixel = 0
            
            -- Check if already owned
            if GamepassSystem:Owns(passId) and runIfOwned then
                afterPurchaseCallback("already_owned")
                btn.instance.Text = "✓ " .. buttonText
                btn.instance.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
            end
            
            btn:OnClick(function()
                GamepassSystem:PromptPurchase(passId)
                GamepassSystem:OnPurchase(passId, function(status)
                    if status == "purchased" or status == "already_owned" then
                        btn.instance.Text = "✓ " .. buttonText
                        btn.instance.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                        afterPurchaseCallback(status)
                    end
                end, true)
            end)
            
            return btn
        end
    }
end

function Hub:Notify(title, message, type, duration, customButtons)
    if type == "success" then
        title = "✓ " .. title
    elseif type == "error" then
        title = "✗ " .. title
    elseif type == "warning" then
        title = "⚠ " .. title
    elseif type == "info" then
        title = "ℹ " .. title
    end
    
    return NotificationSystem:Show(title, message, duration or 3, customButtons)
end

function Hub:AddCustomNotificationButton(buttonText, buttonColor, callback)
    NotificationSystem:AddButton(buttonText, buttonColor, callback)
end

function Hub:GetDeviceInfo()
    local screenSize = game:GetService("GuiService"):GetScreenResolution()
    local deviceType = "PC"
    
    if game:GetService("UserInputService").TouchEnabled then
        if screenSize.X < 800 then
            deviceType = "Phone"
        else
            deviceType = "Tablet"
        end
    end
    
    return deviceType, screenSize.X, screenSize.Y
end

function Hub:GetGamepassSystem()
    return GamepassSystem
end

function Hub:GetColorSystem()
    return ColorSystem
end

-- ================================================================================
-- EXAMPLE USAGE (REMOVE THIS IN YOUR ACTUAL SCRIPT - THIS IS JUST FOR DEMO)
-- ================================================================================

--[[
-- UNCOMMENT THIS TO SEE AN EXAMPLE OF HOW TO USE THE FRAMEWORK

local MyHub = Hub:CreateWindow("My Custom Hub")

-- Example with gamepass (replace with your actual pass ID)
local PlayerTab = MyHub:AddTab("Player", "👤")

local MovementSection = PlayerTab:AddSection("Movement")

MovementSection:AddButton("Fly Mode", function()
    -- User adds their own fling/fly script here
    print("Fly mode activated - user adds their own code")
end, "blue.ocean")

-- Gamepass example - FLING AFTER PURCHASE
local PassSection = PlayerTab:AddSection("Gamepasses")

PassSection:AddGamepassButton(1859760880, "FLING POWER (Purchase)", function(status)
    if status == "purchased" or status == "already_owned" then
        -- User adds their own fling logic here
        print("FLING ACTIVATED - user adds their own fling code")
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            -- This is just an example - user customizes this
            char.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
        end
    end
end, "red.crimson", true)

-- Color customization example
local CustomSection = PlayerTab:AddSection("Colors")
CustomSection:AddButton("Change Tab Color", function()
    for _, tab in pairs(MyHub.tabs) do
        tab.btn.instance.BackgroundColor3 = ColorSystem.colors.purple.bright
    end
    MyHub:Notify("Colors", "Tabs changed to purple!", "success", 2)
end, "purple.violet")

--]]

return Hub
