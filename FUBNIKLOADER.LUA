local FUBNIK = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Utility functions
local function HexToRGB(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber("0x" .. (hex:sub(1, 2) or "FF")) or 255,
        tonumber("0x" .. (hex:sub(3, 4) or "FF")) or 255,
        tonumber("0x" .. (hex:sub(5, 6) or "FF")) or 255
    )
end

local function RGBToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return string.format("#%02x%02x%02x", r, g, b)
end

-- Table.find implementation
local function tableFind(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then return i end
    end
    return nil
end

-- Main class
function FUBNIK:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "FUBNIK"
    local theme = {
        MainColor = config.MainColor and HexToRGB(config.MainColor) or Color3.fromRGB(66, 135, 245),
        SecondaryColor = config.SecondaryColor and HexToRGB(config.SecondaryColor) or Color3.fromRGB(45, 45, 45),
        BackgroundColor = config.BackgroundColor and HexToRGB(config.BackgroundColor) or Color3.fromRGB(30, 30, 30),
        AccentColor = config.AccentColor and HexToRGB(config.AccentColor) or Color3.fromRGB(255, 100, 100),
        TextColor = config.TextColor and HexToRGB(config.TextColor) or Color3.fromRGB(255, 255, 255),
        SubTextColor = config.SubTextColor and HexToRGB(config.SubTextColor) or Color3.fromRGB(180, 180, 180)
    }

    local isMinimized = false
    local currentPage = nil
    local notifications = {}
    local connections = {} -- Store connections for cleanup

    -- Main GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FUBNIK"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = theme.BackgroundColor
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    MainFrame.Size = UDim2.new(0, 800, 0, 600)

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = MainFrame

    -- Shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Parent = MainFrame
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(-0.02, 0, -0.02, 0)
    Shadow.Size = UDim2.new(1.04, 0, 1.04, 0)
    Shadow.Image = "rbxassetid://1316044817"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ZIndex = 0

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Parent = MainFrame
    TitleBar.BackgroundColor3 = theme.MainColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Size = UDim2.new(1, 0, 0, 45)

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar

    -- Title Bar Top Corners Fix
    local TopFix = Instance.new("Frame")
    TopFix.Parent = TitleBar
    TopFix.BackgroundColor3 = theme.MainColor
    TopFix.BorderSizePixel = 0
    TopFix.Size = UDim2.new(1, 0, 0, 10)

    -- Window Title
    local Title = Instance.new("TextLabel")
    Title.Parent = TitleBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.02, 0, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = windowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Minimize Button
    local MinimizeBtn = Instance.new("ImageButton")
    MinimizeBtn.Parent = TitleBar
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Position = UDim2.new(1, -75, 0, 0)
    MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
    MinimizeBtn.Image = "rbxassetid://5042608266"
    MinimizeBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

    -- Close Button
    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Parent = TitleBar
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Position = UDim2.new(1, -35, 0, 0)
    CloseBtn.Size = UDim2.new(0, 35, 1, 0)
    CloseBtn.Image = "rbxassetid://5042596971"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 255, 255)

    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Parent = MainFrame
    TabContainer.BackgroundColor3 = theme.SecondaryColor
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 45)
    TabContainer.Size = UDim2.new(0, 180, 1, -45)

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = TabContainer

    local TabList = Instance.new("UIListLayout")
    TabList.Parent = TabContainer
    TabList.Padding = UDim.new(0, 5)
    TabList.SortOrder = Enum.SortOrder.LayoutOrder

    local TabPadding = Instance.new("UIPadding")
    TabPadding.Parent = TabContainer
    TabPadding.PaddingTop = UDim.new(0, 10)
    TabPadding.PaddingLeft = UDim.new(0, 10)
    TabPadding.PaddingRight = UDim.new(0, 10)

    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 180, 0, 45)
    ContentContainer.Size = UDim2.new(1, -180, 1, -45)

    -- Pages Folder
    local PagesFolder = Instance.new("Folder")
    PagesFolder.Parent = ContentContainer

    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil

    local dragConnection
    local dragEndConnection
    
    local function StartDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end
    
    local function UpdateDrag(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end
    
    local function EndDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end
    
    TitleBar.InputBegan:Connect(StartDrag)
    dragConnection = UserInputService.InputChanged:Connect(UpdateDrag)
    dragEndConnection = UserInputService.InputEnded:Connect(EndDrag)
    
    table.insert(connections, dragConnection)
    table.insert(connections, dragEndConnection)

    -- Minimize functionality
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 800, 0, 45)
            }):Play()
            TweenService:Create(MinimizeBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Rotation = 180
            }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 800, 0, 600)
            }):Play()
            TweenService:Create(MinimizeBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Rotation = 0
            }):Play()
        end
    end)

    -- Close functionality
    CloseBtn.MouseButton1Click:Connect(function()
        for _, conn in ipairs(connections) do
            if conn and conn.Disconnect then
                conn:Disconnect()
            end
        end
        TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        }):Play()
        task.wait(0.2)
        ScreenGui:Destroy()
    end)

    -- Global notification function
    local function AddNotification(title, message, duration)
        duration = duration or 3
        local notificationFrame = Instance.new("Frame")
        notificationFrame.Parent = ScreenGui
        notificationFrame.BackgroundColor3 = theme.SecondaryColor
        notificationFrame.BorderSizePixel = 0
        notificationFrame.Position = UDim2.new(1, -310, 0, 50 + (#notifications * 90))
        notificationFrame.Size = UDim2.new(0, 300, 0, 80)
        notificationFrame.ClipsDescendants = true
        notificationFrame.ZIndex = 10
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 8)
        notifCorner.Parent = notificationFrame
        
        local notifTitle = Instance.new("TextLabel")
        notifTitle.Parent = notificationFrame
        notifTitle.BackgroundTransparency = 1
        notifTitle.Position = UDim2.new(0, 15, 0, 10)
        notifTitle.Size = UDim2.new(1, -30, 0, 25)
        notifTitle.Font = Enum.Font.GothamBold
        notifTitle.Text = title
        notifTitle.TextColor3 = theme.MainColor
        notifTitle.TextSize = 16
        notifTitle.TextXAlignment = Enum.TextXAlignment.Left
        notifTitle.ZIndex = 10
        
        local notifMessage = Instance.new("TextLabel")
        notifMessage.Parent = notificationFrame
        notifMessage.BackgroundTransparency = 1
        notifMessage.Position = UDim2.new(0, 15, 0, 40)
        notifMessage.Size = UDim2.new(1, -30, 0, 30)
        notifMessage.Font = Enum.Font.GothamSemibold
        notifMessage.Text = message
        notifMessage.TextColor3 = theme.TextColor
        notifMessage.TextSize = 12
        notifMessage.TextXAlignment = Enum.TextXAlignment.Left
        notifMessage.TextWrapped = true
        notifMessage.ZIndex = 10
        
        table.insert(notifications, notificationFrame)
        
        notificationFrame.Position = UDim2.new(1, -10, 0, 50 + ((#notifications - 1) * 90))
        TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -310, 0, 50 + ((#notifications - 1) * 90))
        }):Play()
        
        task.wait(duration)
        
        TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, -10, 0, 50 + ((#notifications - 1) * 90))
        }):Completed:Connect(function()
            notificationFrame:Destroy()
            for i, notif in ipairs(notifications) do
                if notif == notificationFrame then
                    table.remove(notifications, i)
                    break
                end
            end
            -- Reposition remaining notifications
            for i, notif in ipairs(notifications) do
                TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(1, -310, 0, 50 + ((i - 1) * 90))
                }):Play()
            end
        end)
    end

    -- Tab system
    local TabHandler = {}

    function TabHandler:CreateTab(tabName)
        local tabButton = Instance.new("TextButton")
        tabButton.Parent = TabContainer
        tabButton.BackgroundColor3 = theme.BackgroundColor
        tabButton.BorderSizePixel = 0
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Text = tabName
        tabButton.TextColor3 = theme.TextColor
        tabButton.TextSize = 14
        tabButton.AutoButtonColor = false

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton

        local page = Instance.new("ScrollingFrame")
        page.Parent = PagesFolder
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.Size = UDim2.new(1, 0, 1, 0)
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = theme.MainColor
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)

        local pageList = Instance.new("UIListLayout")
        pageList.Parent = page
        pageList.Padding = UDim.new(0, 10)
        pageList.SortOrder = Enum.SortOrder.LayoutOrder

        local pagePadding = Instance.new("UIPadding")
        pagePadding.Parent = page
        pagePadding.PaddingTop = UDim.new(0, 10)
        pagePadding.PaddingBottom = UDim.new(0, 10)
        pagePadding.PaddingLeft = UDim.new(0, 10)
        pagePadding.PaddingRight = UDim.new(0, 10)

        local function UpdateCanvas()
            local contentSize = pageList.AbsoluteContentSize
            page.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
        end

        pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        UpdateCanvas()

        tabButton.MouseButton1Click:Connect(function()
            if currentPage then
                currentPage.Visible = false
            end
            page.Visible = true
            currentPage = page

            for _, btn in pairs(TabContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = theme.BackgroundColor
                    }):Play()
                end
            end
            TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = theme.MainColor
            }):Play()
        end)

        if not currentPage then
            tabButton.MouseButton1Click:Fire()
        end

        local ElementHandler = {}

        -- Section (collapsible container)
        function ElementHandler:CreateSection(sectionName, defaultCollapsed)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Parent = page
            sectionFrame.BackgroundColor3 = theme.SecondaryColor
            sectionFrame.BorderSizePixel = 0
            sectionFrame.Size = UDim2.new(1, -20, 0, 50)
            sectionFrame.ClipsDescendants = true

            local sectionCorner = Instance.new("UICorner")
            sectionCorner.CornerRadius = UDim.new(0, 8)
            sectionCorner.Parent = sectionFrame

            local sectionHeader = Instance.new("TextButton")
            sectionHeader.Parent = sectionFrame
            sectionHeader.BackgroundColor3 = theme.MainColor
            sectionHeader.BorderSizePixel = 0
            sectionHeader.Size = UDim2.new(1, 0, 0, 50)
            sectionHeader.Font = Enum.Font.GothamBold
            sectionHeader.Text = sectionName
            sectionHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionHeader.TextSize = 16
            sectionHeader.TextXAlignment = Enum.TextXAlignment.Left
            sectionHeader.TextYAlignment = Enum.TextYAlignment.Center
            sectionHeader.AutoButtonColor = false

            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 8)
            headerCorner.Parent = sectionHeader

            local expandIcon = Instance.new("ImageLabel")
            expandIcon.Parent = sectionHeader
            expandIcon.BackgroundTransparency = 1
            expandIcon.Position = UDim2.new(1, -35, 0.5, -10)
            expandIcon.Size = UDim2.new(0, 20, 0, 20)
            expandIcon.Image = "rbxassetid://6031094596"
            expandIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

            local contentContainer = Instance.new("Frame")
            contentContainer.Parent = sectionFrame
            contentContainer.BackgroundTransparency = 1
            contentContainer.Position = UDim2.new(0, 0, 0, 50)
            contentContainer.Size = UDim2.new(1, 0, 0, 0)

            local contentList = Instance.new("UIListLayout")
            contentList.Parent = contentContainer
            contentList.Padding = UDim.new(0, 8)
            contentList.SortOrder = Enum.SortOrder.LayoutOrder

            local contentPadding = Instance.new("UIPadding")
            contentPadding.Parent = contentContainer
            contentPadding.PaddingTop = UDim.new(0, 10)
            contentPadding.PaddingBottom = UDim.new(0, 10)
            contentPadding.PaddingLeft = UDim.new(0, 10)
            contentPadding.PaddingRight = UDim.new(0, 10)

            local collapsed = defaultCollapsed or false

            local function UpdateSectionHeight()
                local contentHeight = contentList.AbsoluteContentSize.Y
                if collapsed then
                    sectionFrame.Size = UDim2.new(1, -20, 0, 50)
                else
                    sectionFrame.Size = UDim2.new(1, -20, 0, 50 + contentHeight + 20)
                end
                UpdateCanvas()
            end

            contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionHeight)
            UpdateSectionHeight()

            sectionHeader.MouseButton1Click:Connect(function()
                collapsed = not collapsed
                TweenService:Create(expandIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    Rotation = collapsed and 0 or 90
                }):Play()
                
                local targetSize = collapsed and 50 or (50 + contentList.AbsoluteContentSize.Y + 20)
                TweenService:Create(sectionFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(1, -20, 0, targetSize)
                }):Play()
                task.wait(0.3)
                UpdateCanvas()
            end)

            local SectionElements = {}

            function SectionElements:AddLabel(text, textColor)
                local labelFrame = Instance.new("Frame")
                labelFrame.Parent = contentContainer
                labelFrame.BackgroundColor3 = theme.BackgroundColor
                labelFrame.BorderSizePixel = 0
                labelFrame.Size = UDim2.new(1, 0, 0, 40)

                local labelCorner = Instance.new("UICorner")
                labelCorner.CornerRadius = UDim.new(0, 6)
                labelCorner.Parent = labelFrame

                local label = Instance.new("TextLabel")
                label.Parent = labelFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -20, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = textColor and HexToRGB(textColor) or theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                UpdateSectionHeight()
                return label
            end

            function SectionElements:AddButton(text, callback, buttonColor)
                local buttonFrame = Instance.new("Frame")
                buttonFrame.Parent = contentContainer
                buttonFrame.BackgroundColor3 = theme.BackgroundColor
                buttonFrame.BorderSizePixel = 0
                buttonFrame.Size = UDim2.new(1, 0, 0, 45)

                local buttonCorner = Instance.new("UICorner")
                buttonCorner.CornerRadius = UDim.new(0, 6)
                buttonCorner.Parent = buttonFrame

                local button = Instance.new("TextButton")
                button.Parent = buttonFrame
                button.BackgroundColor3 = buttonColor and HexToRGB(buttonColor) or theme.MainColor
                button.BorderSizePixel = 0
                button.Size = UDim2.new(1, -20, 0, 35)
                button.Position = UDim2.new(0, 10, 0.5, -17.5)
                button.Font = Enum.Font.GothamSemibold
                button.Text = text
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.TextSize = 14
                button.AutoButtonColor = false

                local buttonBtnCorner = Instance.new("UICorner")
                buttonBtnCorner.CornerRadius = UDim.new(0, 6)
                buttonBtnCorner.Parent = button

                button.MouseButton1Click:Connect(function()
                    TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    }):Play()
                    task.wait(0.1)
                    TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = buttonColor and HexToRGB(buttonColor) or theme.MainColor
                    }):Play()
                    if callback then 
                        local success, err = pcall(callback)
                        if not success then
                            warn("Button callback error:", err)
                        end
                    end
                end)

                UpdateSectionHeight()
                return button
            end

            function SectionElements:AddToggle(text, default, callback)
                local toggleFrame = Instance.new("Frame")
                toggleFrame.Parent = contentContainer
                toggleFrame.BackgroundColor3 = theme.BackgroundColor
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Size = UDim2.new(1, 0, 0, 45)

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 6)
                toggleCorner.Parent = toggleFrame

                local label = Instance.new("TextLabel")
                label.Parent = toggleFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -70, 1, 0)
                label.Position = UDim2.new(0, 15, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                local toggleBtn = Instance.new("Frame")
                toggleBtn.Parent = toggleFrame
                toggleBtn.BackgroundColor3 = default and theme.MainColor or Color3.fromRGB(80, 80, 80)
                toggleBtn.BorderSizePixel = 0
                toggleBtn.Position = UDim2.new(1, -55, 0.5, -12)
                toggleBtn.Size = UDim2.new(0, 45, 0, 24)

                local toggleBtnCorner = Instance.new("UICorner")
                toggleBtnCorner.CornerRadius = UDim.new(1, 0)
                toggleBtnCorner.Parent = toggleBtn

                local toggleCircle = Instance.new("Frame")
                toggleCircle.Parent = toggleBtn
                toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleCircle.BorderSizePixel = 0
                toggleCircle.Position = default and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)
                toggleCircle.Size = UDim2.new(0, 20, 0, 20)

                local toggleCircleCorner = Instance.new("UICorner")
                toggleCircleCorner.CornerRadius = UDim.new(1, 0)
                toggleCircleCorner.Parent = toggleCircle

                local toggled = default or false

                local function UpdateToggle()
                    local targetColor = toggled and theme.MainColor or Color3.fromRGB(80, 80, 80)
                    local targetCirclePos = toggled and UDim2.new(1, -22, 0, 2) or UDim2.new(0, 2, 0, 2)

                    TweenService:Create(toggleBtn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        BackgroundColor3 = targetColor
                    }):Play()
                    TweenService:Create(toggleCircle, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Position = targetCirclePos
                    }):Play()

                    if callback then 
                        local success, err = pcall(callback, toggled)
                        if not success then
                            warn("Toggle callback error:", err)
                        end
                    end
                end

                local toggleButton = Instance.new("TextButton")
                toggleButton.Parent = toggleFrame
                toggleButton.BackgroundTransparency = 1
                toggleButton.Size = UDim2.new(1, 0, 1, 0)
                toggleButton.Text = ""
                toggleButton.AutoButtonColor = false
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)

                UpdateToggle()
                UpdateSectionHeight()

                return {
                    Set = function(value)
                        toggled = value
                        UpdateToggle()
                    end,
                    Get = function()
                        return toggled
                    end
                }
            end

            function SectionElements:AddSlider(text, min, max, default, callback)
                local sliderFrame = Instance.new("Frame")
                sliderFrame.Parent = contentContainer
                sliderFrame.BackgroundColor3 = theme.BackgroundColor
                sliderFrame.BorderSizePixel = 0
                sliderFrame.Size = UDim2.new(1, 0, 0, 70)

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 6)
                sliderCorner.Parent = sliderFrame

                local label = Instance.new("TextLabel")
                label.Parent = sliderFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -20, 0, 25)
                label.Position = UDim2.new(0, 10, 0, 5)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Parent = sliderFrame
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(0, 60, 0, 25)
                valueLabel.Position = UDim2.new(1, -70, 0, 5)
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.Text = tostring(default or min)
                valueLabel.TextColor3 = theme.MainColor
                valueLabel.TextSize = 14
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local sliderBar = Instance.new("Frame")
                sliderBar.Parent = sliderFrame
                sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                sliderBar.BorderSizePixel = 0
                sliderBar.Position = UDim2.new(0, 10, 0, 40)
                sliderBar.Size = UDim2.new(1, -20, 0, 6)

                local sliderBarCorner = Instance.new("UICorner")
                sliderBarCorner.CornerRadius = UDim.new(1, 0)
                sliderBarCorner.Parent = sliderBar

                local sliderFill = Instance.new("Frame")
                sliderFill.Parent = sliderBar
                sliderFill.BackgroundColor3 = theme.MainColor
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = UDim2.new((default or min - min) / (max - min), 0, 1, 0)

                local sliderFillCorner = Instance.new("UICorner")
                sliderFillCorner.CornerRadius = UDim.new(1, 0)
                sliderFillCorner.Parent = sliderFill

                local sliderButton = Instance.new("TextButton")
                sliderButton.Parent = sliderFrame
                sliderButton.BackgroundColor3 = theme.MainColor
                sliderButton.BorderSizePixel = 0
                sliderButton.Position = UDim2.new((default or min - min) / (max - min), 10, 0, 37)
                sliderButton.Size = UDim2.new(0, 12, 0, 12)
                sliderButton.AutoButtonColor = false
                sliderButton.Text = ""

                local sliderButtonCorner = Instance.new("UICorner")
                sliderButtonCorner.CornerRadius = UDim.new(1, 0)
                sliderButtonCorner.Parent = sliderButton

                local value = default or min
                local dragging = false
                local dragConnection

                local function UpdateSlider(input)
                    local mouseX = input.Position.X
                    local barPos = sliderBar.AbsolutePosition.X
                    local barWidth = sliderBar.AbsoluteSize.X
                    local percent = math.clamp((mouseX - barPos) / barWidth, 0, 1)
                    value = math.floor(min + (max - min) * percent + 0.5)
                    value = math.clamp(value, min, max)

                    valueLabel.Text = tostring(value)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    sliderButton.Position = UDim2.new(percent, 10, 0, 37)

                    if callback then 
                        local success, err = pcall(callback, value)
                        if not success then
                            warn("Slider callback error:", err)
                        end
                    end
                end

                sliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    dragConnection = UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            UpdateSlider(input)
                        end
                    end)
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        if dragConnection then
                            dragConnection:Disconnect()
                            dragConnection = nil
                        end
                    end
                end)

                sliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateSlider(input)
                    end
                end)

                UpdateSectionHeight()

                return {
                    Set = function(newValue)
                        value = math.clamp(newValue, min, max)
                        local percent = (value - min) / (max - min)
                        valueLabel.Text = tostring(value)
                        sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                        sliderButton.Position = UDim2.new(percent, 10, 0, 37)
                        if callback then 
                            local success, err = pcall(callback, value)
                            if not success then
                                warn("Slider callback error:", err)
                            end
                        end
                    end,
                    Get = function()
                        return value
                    end
                }
            end

            function SectionElements:AddDropdown(text, options, default, callback)
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Parent = contentContainer
                dropdownFrame.BackgroundColor3 = theme.BackgroundColor
                dropdownFrame.BorderSizePixel = 0
                dropdownFrame.Size = UDim2.new(1, 0, 0, 45)
                dropdownFrame.ClipsDescendants = true

                local dropdownCorner = Instance.new("UICorner")
                dropdownCorner.CornerRadius = UDim.new(0, 6)
                dropdownCorner.Parent = dropdownFrame

                local label = Instance.new("TextLabel")
                label.Parent = dropdownFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0.6, -20, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                local dropdownBtn = Instance.new("TextButton")
                dropdownBtn.Parent = dropdownFrame
                dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                dropdownBtn.BorderSizePixel = 0
                dropdownBtn.Position = UDim2.new(0.65, 0, 0.5, -15)
                dropdownBtn.Size = UDim2.new(0.33, -10, 0, 30)
                dropdownBtn.Font = Enum.Font.GothamSemibold
                dropdownBtn.Text = default or "Select option"
                dropdownBtn.TextColor3 = theme.TextColor
                dropdownBtn.TextSize = 12
                dropdownBtn.AutoButtonColor = false

                local dropdownBtnCorner = Instance.new("UICorner")
                dropdownBtnCorner.CornerRadius = UDim.new(0, 4)
                dropdownBtnCorner.Parent = dropdownBtn

                local dropdownIcon = Instance.new("ImageLabel")
                dropdownIcon.Parent = dropdownBtn
                dropdownIcon.BackgroundTransparency = 1
                dropdownIcon.Position = UDim2.new(1, -25, 0.5, -8)
                dropdownIcon.Size = UDim2.new(0, 16, 0, 16)
                dropdownIcon.Image = "rbxassetid://6031094596"
                dropdownIcon.ImageColor3 = theme.TextColor

                local dropdownList = Instance.new("Frame")
                dropdownList.Parent = dropdownFrame
                dropdownList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdownList.BorderSizePixel = 0
                dropdownList.Position = UDim2.new(0.65, 0, 0, 45)
                dropdownList.Size = UDim2.new(0.33, -10, 0, 0)
                dropdownList.ClipsDescendants = true
                dropdownList.Visible = false

                local dropdownListCorner = Instance.new("UICorner")
                dropdownListCorner.CornerRadius = UDim.new(0, 6)
                dropdownListCorner.Parent = dropdownList

                local dropdownListLayout = Instance.new("UIListLayout")
                dropdownListLayout.Parent = dropdownList
                dropdownListLayout.Padding = UDim.new(0, 2)

                local expanded = false
                local selected = default

                local function UpdateDropdownHeight()
                    local contentHeight = dropdownListLayout.AbsoluteContentSize.Y
                    dropdownList.Size = UDim2.new(0.33, -10, 0, contentHeight + 10)
                    local totalHeight = expanded and (45 + contentHeight + 10) or 45
                    TweenService:Create(dropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Size = UDim2.new(1, 0, 0, totalHeight)
                    }):Play()
                    UpdateSectionHeight()
                end

                dropdownListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateDropdownHeight)

                for _, option in ipairs(options) do
                    local optionBtn = Instance.new("TextButton")
                    optionBtn.Parent = dropdownList
                    optionBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    optionBtn.BorderSizePixel = 0
                    optionBtn.Size = UDim2.new(1, 0, 0, 30)
                    optionBtn.Font = Enum.Font.GothamSemibold
                    optionBtn.Text = option
                    optionBtn.TextColor3 = theme.TextColor
                    optionBtn.TextSize = 12
                    optionBtn.AutoButtonColor = false

                    local optionCorner = Instance.new("UICorner")
                    optionCorner.CornerRadius = UDim.new(0, 4)
                    optionCorner.Parent = optionBtn

                    optionBtn.MouseButton1Click:Connect(function()
                        selected = option
                        dropdownBtn.Text = option
                        if callback then 
                            local success, err = pcall(callback, option)
                            if not success then
                                warn("Dropdown callback error:", err)
                            end
                        end
                        expanded = false
                        dropdownList.Visible = false
                        TweenService:Create(dropdownIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Rotation = 0
                        }):Play()
                        UpdateDropdownHeight()
                    end)
                end

                dropdownBtn.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    dropdownList.Visible = expanded
                    TweenService:Create(dropdownIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                        Rotation = expanded and 180 or 0
                    }):Play()
                    UpdateDropdownHeight()
                end)

                UpdateSectionHeight()

                return {
                    Set = function(option)
                        if tableFind(options, option) then
                            selected = option
                            dropdownBtn.Text = option
                            if callback then 
                                local success, err = pcall(callback, option)
                                if not success then
                                    warn("Dropdown callback error:", err)
                                end
                            end
                        end
                    end,
                    Get = function()
                        return selected
                    end
                }
            end

            function SectionElements:AddTextbox(text, placeholder, callback)
                local textboxFrame = Instance.new("Frame")
                textboxFrame.Parent = contentContainer
                textboxFrame.BackgroundColor3 = theme.BackgroundColor
                textboxFrame.BorderSizePixel = 0
                textboxFrame.Size = UDim2.new(1, 0, 0, 45)

                local textboxCorner = Instance.new("UICorner")
                textboxCorner.CornerRadius = UDim.new(0, 6)
                textboxCorner.Parent = textboxFrame

                local label = Instance.new("TextLabel")
                label.Parent = textboxFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0.5, -20, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                local textBox = Instance.new("TextBox")
                textBox.Parent = textboxFrame
                textBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                textBox.BorderSizePixel = 0
                textBox.Position = UDim2.new(0.52, 0, 0.5, -15)
                textBox.Size = UDim2.new(0.45, -10, 0, 30)
                textBox.Font = Enum.Font.GothamSemibold
                textBox.PlaceholderText = placeholder or ""
                textBox.PlaceholderColor3 = theme.SubTextColor
                textBox.Text = ""
                textBox.TextColor3 = theme.TextColor
                textBox.TextSize = 12

                local textboxCorner2 = Instance.new("UICorner")
                textboxCorner2.CornerRadius = UDim.new(0, 4)
                textboxCorner2.Parent = textBox

                textBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed and textBox.Text ~= "" and callback then
                        local success, err = pcall(callback, textBox.Text)
                        if not success then
                            warn("Textbox callback error:", err)
                        end
                        textBox.Text = ""
                    end
                end)

                UpdateSectionHeight()
                return textBox
            end

            function SectionElements:AddKeybind(text, defaultKey, callback)
                local keybindFrame = Instance.new("Frame")
                keybindFrame.Parent = contentContainer
                keybindFrame.BackgroundColor3 = theme.BackgroundColor
                keybindFrame.BorderSizePixel = 0
                keybindFrame.Size = UDim2.new(1, 0, 0, 45)

                local keybindCorner = Instance.new("UICorner")
                keybindCorner.CornerRadius = UDim.new(0, 6)
                keybindCorner.Parent = keybindFrame

                local label = Instance.new("TextLabel")
                label.Parent = keybindFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0.6, -20, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                local keyButton = Instance.new("TextButton")
                keyButton.Parent = keybindFrame
                keyButton.BackgroundColor3 = theme.MainColor
                keyButton.BorderSizePixel = 0
                keyButton.Position = UDim2.new(0.65, 0, 0.5, -15)
                keyButton.Size = UDim2.new(0.3, -10, 0, 30)
                keyButton.Font = Enum.Font.GothamBold
                keyButton.Text = defaultKey or "None"
                keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                keyButton.TextSize = 12
                keyButton.AutoButtonColor = false

                local keyCorner = Instance.new("UICorner")
                keyCorner.CornerRadius = UDim.new(0, 4)
                keyCorner.Parent = keyButton

                local currentKey = defaultKey
                local listening = false
                local bindConnection

                keyButton.MouseButton1Click:Connect(function()
                    listening = true
                    keyButton.Text = "..."
                    keyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    
                    if bindConnection then
                        bindConnection:Disconnect()
                    end
                    
                    bindConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                        if listening and not gameProcessed then
                            local key = input.KeyCode
                            if key ~= Enum.KeyCode.Unknown then
                                currentKey = key.Name
                                keyButton.Text = currentKey
                                listening = false
                                keyButton.BackgroundColor3 = theme.MainColor
                                if bindConnection then
                                    bindConnection:Disconnect()
                                    bindConnection = nil
                                end
                            end
                        end
                    end)
                end)

                local keyPressConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and currentKey and input.KeyCode.Name == currentKey then
                        if callback then 
                            local success, err = pcall(callback)
                            if not success then
                                warn("Keybind callback error:", err)
                            end
                        end
                    end
                end)
                
                table.insert(connections, keyPressConnection)

                UpdateSectionHeight()

                return {
                    Set = function(key)
                        currentKey = key
                        keyButton.Text = key
                    end,
                    Get = function()
                        return currentKey
                    end
                }
            end

            function SectionElements:AddColorPicker(text, defaultColor, callback)
                local colorFrame = Instance.new("Frame")
                colorFrame.Parent = contentContainer
                colorFrame.BackgroundColor3 = theme.BackgroundColor
                colorFrame.BorderSizePixel = 0
                colorFrame.Size = UDim2.new(1, 0, 0, 45)

                local colorCorner = Instance.new("UICorner")
                colorCorner.CornerRadius = UDim.new(0, 6)
                colorCorner.Parent = colorFrame

                local label = Instance.new("TextLabel")
                label.Parent = colorFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(0.6, -20, 1, 0)
                label.Position = UDim2.new(0, 10, 0, 0)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.TextYAlignment = Enum.TextYAlignment.Center

                local colorDisplay = Instance.new("Frame")
                colorDisplay.Parent = colorFrame
                colorDisplay.BackgroundColor3 = defaultColor and HexToRGB(defaultColor) or theme.MainColor
                colorDisplay.BorderSizePixel = 0
                colorDisplay.Position = UDim2.new(0.65, 0, 0.5, -12)
                colorDisplay.Size = UDim2.new(0, 24, 0, 24)

                local colorCorner2 = Instance.new("UICorner")
                colorCorner2.CornerRadius = UDim.new(0, 4)
                colorCorner2.Parent = colorDisplay

                local colorBtn = Instance.new("TextButton")
                colorBtn.Parent = colorFrame
                colorBtn.BackgroundTransparency = 1
                colorBtn.Size = UDim2.new(0.3, -10, 0, 30)
                colorBtn.Position = UDim2.new(0.65, 30, 0.5, -15)
                colorBtn.Text = "Pick Color"
                colorBtn.TextColor3 = theme.MainColor
                colorBtn.TextSize = 13
                colorBtn.Font = Enum.Font.GothamSemibold
                colorBtn.AutoButtonColor = false

                -- Working color picker
                colorBtn.MouseButton1Click:Connect(function()
                    local pickerGui = Instance.new("ScreenGui")
                    pickerGui.Parent = game.CoreGui
                    pickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                    
                    local pickerFrame = Instance.new("Frame")
                    pickerFrame.Parent = pickerGui
                    pickerFrame.BackgroundColor3 = theme.BackgroundColor
                    pickerFrame.BorderSizePixel = 0
                    pickerFrame.Position = UDim2.new(0.5, -200, 0.5, -175)
                    pickerFrame.Size = UDim2.new(0, 400, 0, 350)
                    pickerFrame.ClipsDescendants = true
                    
                    local pickerCorner = Instance.new("UICorner")
                    pickerCorner.CornerRadius = UDim.new(0, 10)
                    pickerCorner.Parent = pickerFrame
                    
                    local pickerTitle = Instance.new("Frame")
                    pickerTitle.Parent = pickerFrame
                    pickerTitle.BackgroundColor3 = theme.MainColor
                    pickerTitle.Size = UDim2.new(1, 0, 0, 40)
                    
                    local pickerTitleCorner = Instance.new("UICorner")
                    pickerTitleCorner.CornerRadius = UDim.new(0, 10)
                    pickerTitleCorner.Parent = pickerTitle
                    
                    local pickerTitleLabel = Instance.new("TextLabel")
                    pickerTitleLabel.Parent = pickerTitle
                    pickerTitleLabel.BackgroundTransparency = 1
                    pickerTitleLabel.Size = UDim2.new(1, 0, 1, 0)
                    pickerTitleLabel.Font = Enum.Font.GothamBold
                    pickerTitleLabel.Text = "Color Picker"
                    pickerTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    pickerTitleLabel.TextSize = 16
                    
                    -- Color preview
                    local previewFrame = Instance.new("Frame")
                    previewFrame.Parent = pickerFrame
                    previewFrame.BackgroundColor3 = colorDisplay.BackgroundColor3
                    previewFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
                    previewFrame.Size = UDim2.new(0.9, 0, 0, 50)
                    
                    local previewCorner = Instance.new("UICorner")
                    previewCorner.CornerRadius = UDim.new(0, 6)
                    previewCorner.Parent = previewFrame
                    
                    local previewLabel = Instance.new("TextLabel")
                    previewLabel.Parent = previewFrame
                    previewLabel.BackgroundTransparency = 1
                    previewLabel.Size = UDim2.new(1, 0, 1, 0)
                    previewLabel.Font = Enum.Font.GothamBold
                    previewLabel.Text = "Preview"
                    previewLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    previewLabel.TextSize = 14
                    previewLabel.TextStrokeTransparency = 0.5
                    previewLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    
                    -- RGB Sliders
                    local rSlider = SectionElements:AddSlider("Red", 0, 255, previewFrame.BackgroundColor3.R * 255, function(value)
                        local newColor = Color3.fromRGB(value, previewFrame.BackgroundColor3.G * 255, previewFrame.BackgroundColor3.B * 255)
                        previewFrame.BackgroundColor3 = newColor
                    end)
                    
                    local gSlider = SectionElements:AddSlider("Green", 0, 255, previewFrame.BackgroundColor3.G * 255, function(value)
                        local newColor = Color3.fromRGB(previewFrame.BackgroundColor3.R * 255, value, previewFrame.BackgroundColor3.B * 255)
                        previewFrame.BackgroundColor3 = newColor
                    end)
                    
                    local bSlider = SectionElements:AddSlider("Blue", 0, 255, previewFrame.BackgroundColor3.B * 255, function(value)
                        local newColor = Color3.fromRGB(previewFrame.BackgroundColor3.R * 255, previewFrame.BackgroundColor3.G * 255, value)
                        previewFrame.BackgroundColor3 = newColor
                    end)
                    
                    -- Buttons
                    local confirmBtn = Instance.new("TextButton")
                    confirmBtn.Parent = pickerFrame
                    confirmBtn.BackgroundColor3 = theme.MainColor
                    confirmBtn.Position = UDim2.new(0.05, 0, 0.8, 0)
                    confirmBtn.Size = UDim2.new(0.43, 0, 0, 40)
                    confirmBtn.Text = "Confirm"
                    confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    confirmBtn.Font = Enum.Font.GothamBold
                    confirmBtn.TextSize = 14
                    
                    local confirmCorner = Instance.new("UICorner")
                    confirmCorner.CornerRadius = UDim.new(0, 6)
                    confirmCorner.Parent = confirmBtn
                    
                    local cancelBtn = Instance.new("TextButton")
                    cancelBtn.Parent = pickerFrame
                    cancelBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    cancelBtn.Position = UDim2.new(0.52, 0, 0.8, 0)
                    cancelBtn.Size = UDim2.new(0.43, 0, 0, 40)
                    cancelBtn.Text = "Cancel"
                    cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    cancelBtn.Font = Enum.Font.GothamBold
                    cancelBtn.TextSize = 14
                    
                    local cancelCorner = Instance.new("UICorner")
                    cancelCorner.CornerRadius = UDim.new(0, 6)
                    cancelCorner.Parent = cancelBtn
                    
                    confirmBtn.MouseButton1Click:Connect(function()
                        colorDisplay.BackgroundColor3 = previewFrame.BackgroundColor3
                        if callback then 
                            local success, err = pcall(callback, previewFrame.BackgroundColor3)
                            if not success then
                                warn("ColorPicker callback error:", err)
                            end
                        end
                        pickerGui:Destroy()
                    end)
                    
                    cancelBtn.MouseButton1Click:Connect(function()
                        pickerGui:Destroy()
                    end)
                end)

                UpdateSectionHeight()

                return {
                    Set = function(color)
                        colorDisplay.BackgroundColor3 = HexToRGB(color)
                        if callback then 
                            local success, err = pcall(callback, HexToRGB(color))
                            if not success then
                                warn("ColorPicker set error:", err)
                            end
                        end
                    end,
                    Get = function()
                        return colorDisplay.BackgroundColor3
                    end
                }
            end

            function SectionElements:AddProgressBar(text, maxValue)
                local progressFrame = Instance.new("Frame")
                progressFrame.Parent = contentContainer
                progressFrame.BackgroundColor3 = theme.BackgroundColor
                progressFrame.BorderSizePixel = 0
                progressFrame.Size = UDim2.new(1, 0, 0, 55)

                local progressCorner = Instance.new("UICorner")
                progressCorner.CornerRadius = UDim.new(0, 6)
                progressCorner.Parent = progressFrame

                local label = Instance.new("TextLabel")
                label.Parent = progressFrame
                label.BackgroundTransparency = 1
                label.Size = UDim2.new(1, -20, 0, 20)
                label.Position = UDim2.new(0, 10, 0, 5)
                label.Font = Enum.Font.GothamSemibold
                label.Text = text
                label.TextColor3 = theme.TextColor
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                
                local valueLabel = Instance.new("TextLabel")
                valueLabel.Parent = progressFrame
                valueLabel.BackgroundTransparency = 1
                valueLabel.Size = UDim2.new(0, 50, 0, 20)
                valueLabel.Position = UDim2.new(1, -60, 0, 5)
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.Text = "0/" .. maxValue
                valueLabel.TextColor3 = theme.MainColor
                valueLabel.TextSize = 12
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right

                local progressBar = Instance.new("Frame")
                progressBar.Parent = progressFrame
                progressBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                progressBar.BorderSizePixel = 0
                progressBar.Position = UDim2.new(0, 10, 0, 30)
                progressBar.Size = UDim2.new(1, -20, 0, 10)

                local progressBarCorner = Instance.new("UICorner")
                progressBarCorner.CornerRadius = UDim.new(1, 0)
                progressBarCorner.Parent = progressBar

                local progressFill = Instance.new("Frame")
                progressFill.Parent = progressBar
                progressFill.BackgroundColor3 = theme.MainColor
                progressFill.BorderSizePixel = 0
                progressFill.Size = UDim2.new(0, 0, 1, 0)

                local progressFillCorner = Instance.new("UICorner")
                progressFillCorner.CornerRadius = UDim.new(1, 0)
                progressFillCorner.Parent = progressFill

                UpdateSectionHeight()

                return {
                    Update = function(value)
                        local percent = math.clamp(value / maxValue, 0, 1)
                        valueLabel.Text = math.floor(value) .. "/" .. maxValue
                        TweenService:Create(progressFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                            Size = UDim2.new(percent, 0, 1, 0)
                        }):Play()
                    end
                }
            end

            -- Add notification method to section elements
            function SectionElements:AddNotification(title, message, duration)
                AddNotification(title, message, duration)
            end

            return SectionElements
        end

        return ElementHandler
    end

    return TabHandler
end

return FUBNIK
