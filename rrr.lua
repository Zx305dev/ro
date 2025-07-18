pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- ==== دوال مساعدة ====

local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function createNotification(text)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotifGui"
    notifGui.Parent = game.CoreGui

    local frameNotif = Instance.new("Frame", notifGui)
    frameNotif.Size = UDim2.new(0, 300, 0, 50)
    frameNotif.Position = UDim2.new(0.5, -150, 0.9, 0)
    frameNotif.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    frameNotif.BorderSizePixel = 0
    addUICorner(frameNotif, 20)

    local labelNotif = Instance.new("TextLabel", frameNotif)
    labelNotif.Size = UDim2.new(1, -20, 1, 0)
    labelNotif.Position = UDim2.new(0, 10, 0, 0)
    labelNotif.BackgroundTransparency = 1
    labelNotif.Text = text
    labelNotif.TextColor3 = Color3.new(1, 1, 1)
    labelNotif.Font = Enum.Font.GothamBold
    labelNotif.TextSize = 20
    labelNotif.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(frameNotif, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(labelNotif, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    task.delay(4, function()
        TweenService:Create(frameNotif, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(labelNotif, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        notifGui:Destroy()
    end)
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- ==== إنشاء واجهة المستخدم ====

local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 540, 0, 620)
frame.Position = UDim2.new(0.5, -270, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
frame.Parent = EliteMenu
addUICorner(frame, 18)
makeDraggable(frame)

-- رأس المينيو
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(90, 0, 180)
header.BorderSizePixel = 0
addUICorner(header, 18)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | FiveM & Roblox"
title.Size = UDim2.new(0.75, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(0.92, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 32
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 16)

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 40, 1, 0)
minimizeBtn.Position = UDim2.new(0.83, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 34
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 16)

closeBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
end)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        frame.Size = UDim2.new(0, 540, 0, 620)
        pagesContainer.Visible = true
        pageBar.Visible = true
        isMinimized = false
    else
        frame.Size = UDim2.new(0, 540, 0, 45)
        pagesContainer.Visible = false
        pageBar.Visible = false
        isMinimized = true
    end
end)

-- شريط الصفحات
local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 50)
pageBar.Position = UDim2.new(0, 0, 0, 45)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.04, 0)

local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -95)
pagesContainer.Position = UDim2.new(0, 0, 0, 95)
pagesContainer.BackgroundTransparency = 1

local pages = {}
local pageButtons = {}

local pageNames = {"الرئيسية", "ESP", "السيرفر", "18+"}

local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 130, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.AutoButtonColor = false
    addUICorner(btn, 18)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(200, 0, 255)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(130, 0, 200)}):Play()
    end)

    return btn
end

local function hideAllPages()
    for _, p in pairs(pagesContainer:GetChildren()) do
        if p:IsA("Frame") then
            p.Visible = false
        end
    end
end

for _, name in ipairs(pageNames) do
    local btn = createPageButton(name)
    btn.Parent = pageBar
    pageButtons[name] = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pagesContainer
    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        hideAllPages()
        page.Visible = true
        TweenService:Create(page, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end)
end

hideAllPages()
pages["الرئيسية"].Visible = true

-- === الصفحة الرئيسية: معلومات اللاعب ===
do
    local page = pages["الرئيسية"]

    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.9, 0, 0.35, 0)
    playerInfoFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 140)
    addUICorner(playerInfoFrame, 20)

    local title = Instance.new("TextLabel", playerInfoFrame)
    title.Text = "معلومات اللاعب"
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 24
    title.Position = UDim2.new(0, 0, 0, 10)

    local profileImage = Instance.new("ImageLabel", playerInfoFrame)
    profileImage.Size = UDim2.new(0, 120, 0, 120)
    profileImage.Position = UDim2.new(0, 20, 0, 50)
    profileImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    profileImage.BorderSizePixel = 0
    addUICorner(profileImage, 60)
    profileImage.Image = "rbxassetid://0"

    local playerNameLabel = Instance.new("TextLabel", playerInfoFrame)
    playerNameLabel.Size = UDim2.new(0.65, 0, 0, 40)
    playerNameLabel.Position = UDim2.new(0, 160, 0, 60)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextColor3 = Color3.new(1, 1, 1)
    playerNameLabel.TextSize = 28
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local function updatePlayerInfo()
        local plr = LocalPlayer
        if plr then
            playerNameLabel.Text = "الاسم: " .. plr.Name
            profileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"
        end
    end

    updatePlayerInfo()
    RunService.Heartbeat:Connect(updatePlayerInfo)
end

-- === صفحة السيرفر ===
do
    local page = pages["السيرفر"]

    local serverInfoFrame = Instance.new("Frame", page)
    serverInfoFrame.Size = UDim2.new(0.9, 0, 0.9, 0)
    serverInfoFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    serverInfoFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 140)
    addUICorner(serverInfoFrame, 20)

    local title = Instance.new("TextLabel", serverInfoFrame)
    title.Text = "معلومات السيرفر"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 30
    title.Position = UDim2.new(0, 0, 0, 5)

    local infoText = Instance.new("TextLabel", serverInfoFrame)
    infoText.Size = UDim2.new(1, -20, 1, -60)
    infoText.Position = UDim2.new(0, 10, 0, 50)
    infoText.BackgroundTransparency = 1
    infoText.Font = Enum.Font.Gotham
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.TextSize = 20
    infoText.TextWrapped = true
    infoText.TextYAlignment = Enum.TextYAlignment.Top

    local function updateServerInfo()
        local playersCount = #Players:GetPlayers()
        local serverTime = os.date("%Y-%m-%d %H:%M:%S")

        infoText.Text = 
            "عدد اللاعبين: " .. playersCount .. "\n" ..
            "وقت السيرفر: " .. serverTime .. "\n" ..
            "اسم السيرفر: Elite V5 Private Server\n" ..
            "إصدار السكربت: 2025 PRO\n" ..
            "حالة الشبكة: مستقر\n" ..
            "تحديث تلقائي كل ثانية"
    end

    updateServerInfo()
    RunService.Heartbeat:Connect(updateServerInfo)
end

-- === صفحة 18+ مع Bang وNoclip وAuto-Complete ===
do
    local page = pages["18+"]

    -- TextBox لادخال اسم الهدف
    local targetInput = Instance.new("TextBox", page)
    targetInput.Size = UDim2.new(0, 300, 0, 40)
    targetInput.Position = UDim2.new(0.15, 0, 0.1, 0)
    targetInput.PlaceholderText = "أدخل اسم اللاعب المستهدف"
    targetInput.Font = Enum.Font.Gotham
    targetInput.TextSize = 22
    targetInput.TextColor3 = Color3.new(0, 0, 0)
    addUICorner(targetInput, 15)

    -- قائمة اختيار للاعبين المطابقة (Dropdown)
    local dropdown = Instance.new("Frame", page)
    dropdown.Size = UDim2.new(0, 300, 0, 120)
    dropdown.Position = UDim2.new(0.15, 0, 0.16, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 0, 90)
    dropdown.Visible = false
    addUICorner(dropdown, 12)
    dropdown.ClipsDescendants = true

    local dropdownLayout = Instance.new("UIListLayout", dropdown)
    dropdownLayout.Padding = UDim.new(0, 
