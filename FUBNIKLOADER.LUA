--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║   ███████╗██╗   ██╗██████╗ ███╗   ██╗██╗██╗  ██╗             ║
    ║   ██╔════╝██║   ██║██╔══██╗████╗  ██║██║╚██╗██╔╝             ║
    ║   █████╗  ██║   ██║██████╔╝██╔██╗ ██║██║ ╚███╔╝              ║
    ║   ██╔══╝  ██║   ██║██╔══██╗██║╚██╗██║██║ ██╔██╗              ║
    ║   ██║     ╚██████╔╝██████╔╝██║ ╚████║██║██╔╝ ██╗              ║
    ║   ╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝              ║
    ║                                                               ║
    ║                    FUBNIK MODULE v3.0                         ║
    ║              Simple. Powerful. No breaking.                   ║
    ╚═══════════════════════════════════════════════════════════════╝
--]]

local FUBNIK = {}

-- ============================================================
-- SIMPLE NOTIFICATION SYSTEM
-- ============================================================

local function CreateNotificationHolder()
    local holder = Instance.new("ScreenGui")
    holder.Name = "FUBNIK_Notifs"
    holder.Parent = game:GetService("CoreGui")
    holder.ResetOnSpawn = false
    
    local list = Instance.new("Frame")
    list.Name = "List"
    list.Size = UDim2.new(0, 300, 1, 0)
    list.Position = UDim2.new(1, -310, 0, 10)
    list.BackgroundTransparency = 1
    list.Parent = holder
    
    return list
end

local notifList = CreateNotificationHolder()

function FUBNIK.Notify(title, message, duration)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, -10, 0, 60)
    notif.Position = UDim2.new(0, 0, 1, 5)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.Parent = notifList
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 25)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = notif
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 30)
    msgLabel.Position = UDim2.new(0, 10, 0, 30)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    msgLabel.TextSize = 12
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.TextWrapped = true
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.Parent = notif
    
    notif:TweenPosition(UDim2.new(0, 0, 0, 5), "Out", "Quad", 0.3)
    
    task.delay(duration or 3, function()
        if notif then
            notif:TweenPosition(UDim2.new(0, 0, 1, 5), "Out", "Quad", 0.3)
            task.delay(0.3, function() notif:Destroy() end)
        end
    end)
end

-- ============================================================
-- SIMPLE WINDOW CREATION
-- ============================================================

function FUBNIK.CreateWindow(title, width, height)
    width = width or 400
    height = height or 500
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "FUBNIK_Hub"
    gui.Parent = game:GetService("CoreGui")
    gui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = gui
    
    -- Make draggable
    local dragStart, startPos, dragging = nil, nil, false
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 35)
    topBar.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    topBar.BorderSizePixel = 0
    topBar.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = topBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 35, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.Text = "✕"
    closeBtn.TextSize = 18
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Parent = topBar
    closeBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
    end)
    
    -- Tab bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = frame
    
    local tabButtons = {}
    
    -- Content area
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 1, -70)
    content.Position = UDim2.new(0, 0, 0, 70)
    content.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
    content.BorderSizePixel = 0
    content.Parent = frame
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 4
    scroll.Parent = content
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = scroll
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
    end)
    
    local window = {
        _frame = frame,
        _gui = gui,
        _content = scroll,
        _contentList = contentList,
        _tabBar = tabBar,
        _tabButtons = tabButtons,
        _tabs = {},
        _currentTab = nil,
        
        AddTab = function(self, name, icon)
            icon = icon or "📄"
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 100, 1, 0)
            btn.Text = icon .. " " .. name
            btn.TextSize = 12
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
            btn.BorderSizePixel = 0
            btn.Parent = tabBar
            
            local tabFrame = Instance.new("Frame")
            tabFrame.Size = UDim2.new(1, 0, 0, 0)
            tabFrame.BackgroundTransparency = 1
            tabFrame.Visible = false
            tabFrame.Parent = scroll
            
            local tabList = Instance.new("UIListLayout")
            tabList.Padding = UDim.new(0, 10)
            tabList.SortOrder = Enum.SortOrder.LayoutOrder
            tabList.Parent = tabFrame
            
            tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabFrame.Size = UDim2.new(1, 0, 0, tabList.AbsoluteContentSize.Y + 20)
            end)
            
            local tab = {
                name = name,
                frame = tabFrame,
                layout = tabList,
                btn = btn,
                sections = {}
            }
            
            table.insert(self._tabs, tab)
            table.insert(tabButtons, btn)
            
            -- Position buttons
            for i, button in pairs(tabButtons) do
                button.Position = UDim2.new(0, (i-1) * 100, 0, 0)
            end
            tabBar.CanvasSize = UDim2.new(0, #tabButtons * 100, 0, 0)
            
            btn.MouseButton1Click:Connect(function()
                if self._currentTab then
                    self._currentTab.frame.Visible = false
                    self._currentTab.btn.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
                end
                self._currentTab = tab
                tab.frame.Visible = true
                tab.btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            end)
            
            if not self._currentTab then
                btn.MouseButton1Click:Fire()
            end
            
            return {
                AddSection = function(_, sectionName)
                    local sectionFrame = Instance.new("Frame")
                    sectionFrame.Size = UDim2.new(1, 0, 0, 0)
                    sectionFrame.BackgroundColor3 = Color3.fromRGB(33, 33, 38)
                    sectionFrame.BorderSizePixel = 0
                    sectionFrame.Parent = tabFrame
                    
                    local header = Instance.new("TextLabel")
                    header.Size = UDim2.new(1, 0, 0, 30)
                    header.Text = "  " .. sectionName
                    header.TextSize = 13
                    header.TextXAlignment = Enum.TextXAlignment.Left
                    header.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
                    header.BorderSizePixel = 0
                    header.TextColor3 = Color3.fromRGB(255, 255, 255)
                    header.Font = Enum.Font.GothamBold
                    header.Parent = sectionFrame
                    
                    local sectionContent = Instance.new("Frame")
                    sectionContent.Size = UDim2.new(1, 0, 0, 0)
                    sectionContent.Position = UDim2.new(0, 0, 0, 30)
                    sectionContent.BackgroundTransparency = 1
                    sectionContent.Parent = sectionFrame
                    
                    local sectionList = Instance.new("UIListLayout")
                    sectionList.Padding = UDim.new(0, 6)
                    sectionList.SortOrder = Enum.SortOrder.LayoutOrder
                    sectionList.Parent = sectionContent
                    
                    sectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        local h = 30 + sectionList.AbsoluteContentSize.Y + 10
                        sectionFrame.Size = UDim2.new(1, 0, 0, h)
                        sectionContent.Size = UDim2.new(1, 0, 0, sectionList.AbsoluteContentSize.Y + 5)
                    end)
                    
                    return {
                        AddLabel = function(_, text, color)
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1, -20, 0, 24)
                            lbl.Position = UDim2.new(0, 10, 0, 0)
                            lbl.Text = text
                            lbl.TextSize = 12
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.BackgroundTransparency = 1
                            lbl.TextColor3 = color or Color3.fromRGB(180, 180, 180)
                            lbl.Font = Enum.Font.Gotham
                            lbl.Parent = sectionContent
                            return {
                                SetText = function(_, newText) lbl.Text = newText end
                            }
                        end,
                        
                        AddButton = function(_, text, callback, color)
                            local btn = Instance.new("TextButton")
                            btn.Size = UDim2.new(0.96, 0, 0, 32)
                            btn.Position = UDim2.new(0.02, 0, 0, 0)
                            btn.Text = text
                            btn.TextSize = 13
                            btn.Font = Enum.Font.GothamBold
                            btn.BackgroundColor3 = color or Color3.fromRGB(65, 65, 75)
                            btn.BorderSizePixel = 0
                            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            btn.Parent = sectionContent
                            btn.MouseButton1Click:Connect(callback)
                            return btn
                        end,
                        
                        AddToggle = function(_, text, default, callback)
                            local container = Instance.new("Frame")
                            container.Size = UDim2.new(1, 0, 0, 32)
                            container.BackgroundTransparency = 1
                            container.Parent = sectionContent
                            
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(0.7, 0, 1, 0)
                            lbl.Position = UDim2.new(0.05, 0, 0, 0)
                            lbl.Text = text
                            lbl.TextSize = 12
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.BackgroundTransparency = 1
                            lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                            lbl.Font = Enum.Font.Gotham
                            lbl.Parent = container
                            
                            local toggle = Instance.new("TextButton")
                            toggle.Size = UDim2.new(0, 60, 0, 26)
                            toggle.Position = UDim2.new(0.95, 0, 0.5, 0)
                            toggle.AnchorPoint = Vector2.new(1, 0.5)
                            toggle.Text = default and "ON" or "OFF"
                            toggle.TextSize = 11
                            toggle.Font = Enum.Font.GothamBold
                            toggle.BackgroundColor3 = default and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
                            toggle.BorderSizePixel = 0
                            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                            toggle.Parent = container
                            
                            local state = default
                            toggle.MouseButton1Click:Connect(function()
                                state = not state
                                toggle.Text = state and "ON" or "OFF"
                                toggle.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
                                callback(state)
                            end)
                            
                            return { SetValue = function(_, s)
                                state = s
                                toggle.Text = state and "ON" or "OFF"
                                toggle.BackgroundColor3 = state and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(244, 67, 54)
                                callback(state)
                            end }
                        end,
                        
                        AddSlider = function(_, text, min, max, default, callback)
                            local container = Instance.new("Frame")
                            container.Size = UDim2.new(1, 0, 0, 50)
                            container.BackgroundTransparency = 1
                            container.Parent = sectionContent
                            
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(1, 0, 0, 20)
                            lbl.Text = text .. ": " .. default
                            lbl.TextSize = 12
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.BackgroundTransparency = 1
                            lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                            lbl.Font = Enum.Font.Gotham
                            lbl.Parent = container
                            
                            local box = Instance.new("TextBox")
                            box.Size = UDim2.new(0.7, 0, 0, 28)
                            box.Position = UDim2.new(0.05, 0, 0.4, 0)
                            box.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
                            box.BorderSizePixel = 0
                            box.TextColor3 = Color3.fromRGB(255, 255, 255)
                            box.Text = tostring(default)
                            box.TextSize = 13
                            box.Parent = container
                            
                            local function update(v)
                                local val = math.clamp(tonumber(v) or default, min, max)
                                lbl.Text = text .. ": " .. math.floor(val)
                                box.Text = tostring(math.floor(val))
                                callback(math.floor(val))
                            end
                            
                            box.FocusLost:Connect(function() update(box.Text) end)
                            update(default)
                            
                            return { SetValue = function(_, v) update(v) end }
                        end,
                        
                        AddDropdown = function(_, text, options, default, callback)
                            local container = Instance.new("Frame")
                            container.Size = UDim2.new(1, 0, 0, 45)
                            container.BackgroundTransparency = 1
                            container.Parent = sectionContent
                            
                            local lbl = Instance.new("TextLabel")
                            lbl.Size = UDim2.new(0.4, 0, 1, 0)
                            lbl.Position = UDim2.new(0.05, 0, 0, 0)
                            lbl.Text = text
                            lbl.TextSize = 12
                            lbl.TextXAlignment = Enum.TextXAlignment.Left
                            lbl.BackgroundTransparency = 1
                            lbl.TextColor3 = Color3.fromRGB(180, 180, 180)
                            lbl.Font = Enum.Font.Gotham
                            lbl.Parent = container
                            
                            local btn = Instance.new("TextButton")
                            btn.Size = UDim2.new(0.45, 0, 0, 32)
                            btn.Position = UDim2.new(0.5, 0, 0.05, 0)
                            btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                            btn.BorderSizePixel = 0
                            btn.Text = default or options[1]
                            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            btn.TextSize = 12
                            btn.Font = Enum.Font.Gotham
                            btn.Parent = container
                            
                            local open = false
                            local list = nil
                            
                            btn.MouseButton1Click:Connect(function()
                                if open then if list then list:Destroy() end open = false return end
                                open = true
                                list = Instance.new("Frame")
                                list.Size = UDim2.new(0.45, 0, 0, #options * 28)
                                list.Position = UDim2.new(0.5, 0, 0.05, 37)
                                list.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
                                list.BorderSizePixel = 0
                                list.ClipsDescendants = true
                                list.Parent = container
                                
                                local layout = Instance.new("UIListLayout")
                                layout.Padding = UDim.new(0, 2)
                                layout.Parent = list
                                
                                for _, opt in pairs(options) do
                                    local optBtn = Instance.new("TextButton")
                                    optBtn.Size = UDim2.new(1, 0, 0, 28)
                                    optBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
                                    optBtn.BorderSizePixel = 0
                                    optBtn.Text = opt
                                    optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                                    optBtn.TextSize = 11
                                    optBtn.Parent = list
                                    optBtn.MouseButton1Click:Connect(function()
                                        btn.Text = opt
                                        callback(opt)
                                        list:Destroy()
                                        open = false
                                    end)
                                end
                            end)
                            
                            return { SetValue = function(_, v) btn.Text = v callback(v) end }
                        end,
                        
                        AddGamepass = function(_, passId, text, callback, color)
                            local btn = Instance.new("TextButton")
                            btn.Size = UDim2.new(0.96, 0, 0, 38)
                            btn.Position = UDim2.new(0.02, 0, 0, 0)
                            btn.Text = "🎮 " .. text
                            btn.TextSize = 13
                            btn.Font = Enum.Font.GothamBold
                            btn.BackgroundColor3 = color or Color3.fromRGB(88, 86, 214)
                            btn.BorderSizePixel = 0
                            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                            btn.Parent = sectionContent
                            
                            -- Check ownership
                            local owned = false
                            pcall(function()
                                owned = game:GetService("MarketplaceService"):UserOwnsGamePassAsync(
                                    game.Players.LocalPlayer.UserId, passId
                                )
                            end)
                            
                            if owned then
                                btn.Text = "✓ " .. text
                                btn.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                                callback("already_owned")
                            end
                            
                            btn.MouseButton1Click:Connect(function()
                                game:GetService("MarketplaceService"):PromptGamePassPurchase(
                                    game.Players.LocalPlayer, passId
                                )
                                
                                local conn
                                conn = game:GetService("MarketplaceService").ProcessReceipt:Connect(function(receipt)
                                    if receipt.ProductId == passId and receipt.PlayerId == game.Players.LocalPlayer.UserId then
                                        if receipt.PurchaseStatus == Enum.PurchaseStatus.Purchased then
                                            btn.Text = "✓ " .. text
                                            btn.BackgroundColor3 = Color3.fromRGB(76, 175, 80)
                                            callback("purchased")
                                        end
                                        conn:Disconnect()
                                    end
                                    return Enum.ProductPurchaseDecision.PurchaseGranted
                                end)
                            end)
                            
                            return btn
                        end
                    }
                end
            }
        end,
        
        Notify = function(_, title, msg, duration)
            FUBNIK.Notify(title, msg, duration)
        end,
        
        Close = function(self)
            self._gui:Destroy()
        end,
        
        Show = function(self)
            self._frame.Visible = true
        end,
        
        Hide = function(self)
            self._frame.Visible = false
        end
    }
    
    return window
end

function FUBNIK.GetDevice()
    local ts = game:GetService("UserInputService")
    local ss = game:GetService("GuiService"):GetScreenResolution()
    if ts.TouchEnabled then
        return ss.X < 800 and "Phone" or "Tablet"
    end
    return "PC"
end

return FUBNIK
