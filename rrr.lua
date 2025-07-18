-- Elite V5 PRO 2025 - سكربت Face Bang بطيء مع تعديل موقع اللاعب: فوق، قدام، وورا مع ON/OFF + تحديث معلومات كاملة

pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")

local LocalPlayer = Players.LocalPlayer

local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
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

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 520, 0, 580)
frame.Position = UDim2.new(0.5, -260, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = EliteMenu
addUICorner(frame, 18)
makeDraggable(frame)

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(50, 0, 90)
header.BorderSizePixel = 0
addUICorner(header, 18)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | متكامل 2025"
title.Size = UDim2.new(0.75, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(0.92, 0, 0, 3)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 30
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 14)

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(0.83, 0, 0, 3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 32
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 14)

local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 55)
pageBar.Position = UDim2.new(0, 0, 0, 45)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.03, 0)

local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -100)
pagesContainer.Position = UDim2.new(0, 0, 0, 100)
pagesContainer.BackgroundTransparency = 1

local pages = {}
local pageButtons = {}

local pageNames = {"الرئيسية", "معلومات السيرفر", "18+"}

local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 150, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 0, 255)}):Play()
    end)

    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(130, 0, 200)}):Play()
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

for i, name in ipairs(pageNames) do
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
    end)
end

hideAllPages()
pages["الرئيسية"].Visible = true

-- ======= الصفحة الرئيسية: معلومات اللاعب المتجددة ======= --
do
    local page = pages["الرئيسية"]

    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.95, 0, 0, 180)
    playerInfoFrame.Position = UDim2.new(0.025, 0, 0.02, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(90, 0, 180)
    playerInfoFrame.BorderSizePixel = 0
    addUICorner(playerInfoFrame, 18)

    local profileImage = Instance.new("ImageLabel", playerInfoFrame)
    profileImage.Size = UDim2.new(0, 120, 0, 120)
    profileImage.Position = UDim2.new(0.02, 0, 0.1, 0)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
    addUICorner(profileImage, 60)

    local playerNameLabel = Instance.new("TextLabel", playerInfoFrame)
    playerNameLabel.Size = UDim2.new(0.6, 0, 0, 40)
    playerNameLabel.Position = UDim2.new(0.45, 0, 0.15, 0)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextSize = 28
    playerNameLabel.TextColor3 = Color3.new(1, 1, 1)
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local levelLabel = Instance.new("TextLabel", playerInfoFrame)
    levelLabel.Size = UDim2.new(0.5, 0, 0, 30)
    levelLabel.Position = UDim2.new(0.45, 0, 0.45, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Font = Enum.Font.GothamBold
    levelLabel.TextSize = 22
    levelLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    
    local statsContainer = Instance.new("Frame", playerInfoFrame)
    statsContainer.Size = UDim2.new(0.9, 0, 0, 60)
    statsContainer.Position = UDim2.new(0.05, 0, 0.7, 0)
    statsContainer.BackgroundTransparency = 1

    local function createStatBar(parent, label, color, positionX)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0.3, 0, 0.8, 0)
        container.Position = UDim2.new(positionX, 0, 0.1, 0)
        container.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        addUICorner(container, 12)

        local fill = Instance.new("Frame", container)
        fill.Size = UDim2.new(0.7, 0, 1, 0)
        fill.BackgroundColor3 = color
        addUICorner(fill, 12)

        local labelText = Instance.new("TextLabel", container)
        labelText.Size = UDim2.new(1, 0, 1, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.Font = Enum.Font.GothamBold
        labelText.TextSize = 16
        labelText.TextColor3 = Color3.new(1, 1, 1)
        labelText.TextXAlignment = Enum.TextXAlignment.Center

        return {container = container, fill = fill}
    end

    local healthBar = createStatBar(statsContainer, "الصحة", Color3.fromRGB(0, 200, 90), 0)
    local speedBar = createStatBar(statsContainer, "السرعة", Color3.fromRGB(0, 150, 255), 0.35)
    local energyBar = createStatBar(statsContainer, "الطاقة", Color3.fromRGB(255, 215, 0), 0.7)

    local function updatePlayerInfo()
        playerNameLabel.Text = "اسم اللاعب: " .. LocalPlayer.Name
        levelLabel.Text = "المستوى: 23"
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            healthBar.fill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)

            local speedPercent = math.clamp(humanoid.WalkSpeed / 30, 0, 1)
            speedBar.fill:TweenSize(UDim2.new(speedPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)

            local energyPercent = 0.75
            energyBar.fill:TweenSize(UDim2.new(energyPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
        else
            healthBar.fill.Size = UDim2.new(0, 0, 1, 0)
            speedBar.fill.Size = UDim2.new(0, 0, 1, 0)
            energyBar.fill.Size = UDim2.new(0, 0, 1, 0)
        end
    end

    spawn(function()
        while EliteMenu.Parent do
            updatePlayerInfo()
            profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
            task.wait(0.5)
        end
    end)

    playerNameLabel.Parent = playerInfoFrame
    levelLabel.Parent = playerInfoFrame
end

-- ======= صفحة معلومات السيرفر مع تحديث تلقائي ======= --
do
    local page = pages["معلومات السيرفر"]

    local infoText = Instance.new("TextLabel", page)
    infoText.Size = UDim2.new(0.95, 0, 0.9, 0)
    infoText.Position = UDim2.new(0.025, 0, 0.05, 0)
    infoText.BackgroundColor3 = Color3.fromRGB(90, 0, 180)
    infoText.TextColor3 = Color3.new(1, 1, 1)
    infoText.Font = Enum.Font.GothamBold
    infoText.TextSize = 18
    infoText.TextWrapped = true
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.BorderSizePixel = 0
    addUICorner(infoText, 18)

    local function updateServerInfo()
        local serverName = game:GetService("NetworkServer") and "Local Server" or "Roblox Server" -- مجرد مثال للتغيير
        local playerCount = #Players:GetPlayers()
        local maxPlayers = 50 -- يمكنك تغييره حسب سيرفرك
        local fps = math.floor(1 / task.wait(0))
        local placeId = game.PlaceId

        infoText.Text = ("معلومات السيرفر:\n\nاسم السيرفر: %s\nعدد اللاعبين: %d/%d\nوقت اللعب: %s\nمعرف الخريطة: %d\nFPS تقريبي: %d")
            :format(serverName, playerCount, maxPlayers, os.date("%X"), placeId, fps)
    end

    spawn(function()
        while EliteMenu.Parent do
            updateServerInfo()
            task.wait(1)
        end
    end)
end

-- ======= صفحة 18+ مع Face Bang بطيء مع تحريك اللاعب فوق، أمام، ووراء مع On/Off ======= --
do
    local page = pages["18+"]

    local instructions = Instance.new("TextLabel", page)
    instructions.Size = UDim2.new(0.95, 0, 0, 50)
    instructions.Position = UDim2.new(0.025, 0, 0.02, 0)
    instructions.BackgroundTransparency = 1
    instructions.TextColor3 = Color3.new(1, 1, 1)
    instructions.Font = Enum.Font.GothamBold
    instructions.TextSize = 20
    instructions.Text = "اكتب اسم اللاعب المستهدف ثم اضغط تشغيل أو إيقاف Face Bang."
    instructions.TextXAlignment = Enum.TextXAlignment.Center

    local inputBox = Instance.new("TextBox", page)
    inputBox.Size = UDim2.new(0.95, 0, 0, 40)
    inputBox.Position = UDim2.new(0.025, 0, 0.1, 0)
    inputBox.PlaceholderText = "اسم اللاعب المستهدف"
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 20
    inputBox.TextColor3 = Color3.new(0, 0, 0)
    inputBox.ClearTextOnFocus = false
    addUICorner(inputBox, 14)

    local statusLabel = Instance.new("TextLabel", page)
    statusLabel.Size = UDim2.new(0.95, 0, 0, 30)
    statusLabel.Position = UDim2.new(0.025, 0, 0.17, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 18
    statusLabel.Text = "الحالة: غير شغال"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    local buttonsFrame = Instance.new("Frame", page)
    buttonsFrame.Size = UDim2.new(0.95, 0, 0, 50)
    buttonsFrame.Position = UDim2.new(0.025, 0, 0.22, 0)
    buttonsFrame.BackgroundTransparency = 1

    local btnOn = Instance.new("TextButton", buttonsFrame)
    btnOn.Size = UDim2.new(0.48, 0, 1, 0)
    btnOn.Position = UDim2.new(0, 0, 0, 0)
    btnOn.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
    btnOn.Text = "تشغيل"
    btnOn.Font = Enum.Font.GothamBold
    btnOn.TextSize = 22
    btnOn.TextColor3 = Color3.new(1, 1, 1)
    addUICorner(btnOn, 14)

    local btnOff = Instance.new("TextButton", buttonsFrame)
    btnOff.Size = UDim2.new(0.48, 0, 1, 0)
    btnOff.Position = UDim2.new(0.52, 0, 0, 0)
    btnOff.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    btnOff.Text = "إيقاف"
    btnOff.Font = Enum.Font.GothamBold
    btnOff.TextSize = 22
    btnOff.TextColor3 = Color3.new(1, 1, 1)
    addUICorner(btnOff, 14)

    local faceBangRunning = false
    local faceBangConnection

    local function faceBang(targetPlayer)
        if faceBangRunning then
            statusLabel.Text = "الحالة: Face Bang شغال بالفعل"
            return
        end
        if not targetPlayer or not targetPlayer.Character then
            statusLabel.Text = "الحالة: اللاعب غير متصل أو لا توجد شخصية"
            return
        end

        local localChar = LocalPlayer.Character
        if not localChar or not localChar:FindFirstChild("HumanoidRootPart") then
            statusLabel.Text = "الحالة: لم يتم العثور على شخصية اللاعب المحلي"
            return
        end

        local hrpLocal = localChar.HumanoidRootPart
        local targetChar = targetPlayer.Character
        local hrpTarget = targetChar:FindFirstChild("HumanoidRootPart")
        local headTarget = targetChar:FindFirstChild("Head")
        if not hrpTarget or not headTarget then
            statusLabel.Text = "الحالة: لا يمكن الوصول إلى أجزاء جسم الهدف"
            return
        end

        faceBangRunning = true
        statusLabel.Text = "الحالة: بدأ Face Bang على " .. targetPlayer.Name

        local toggle = true
        local count = 0
        local speed = 0.2 -- بطيء جداً

        faceBangConnection = RunService.RenderStepped:Connect(function(dt)
            if not faceBangRunning then
                faceBangConnection:Disconnect()
                statusLabel.Text = "الحالة: تم إيقاف Face Bang"
                return
            end

            count += dt
            if count < speed then return end
            count = 0

            -- تعديل الموقع: فوق (1.2 studs) + أمام (1.5 studs) ووراء (0.3 studs)
            local targetCFrame = headTarget.CFrame
            local upOffset = Vector3.new(0, 1.2, 0)
            local forwardOffset = targetCFrame.LookVector * 1.5
            local backOffset = targetCFrame.LookVector * -0.3

            local newPos
            if toggle then
                newPos = targetCFrame.Position + upOffset + forwardOffset
            else
                newPos = targetCFrame.Position + upOffset + backOffset
            end

            hrpLocal.CFrame = CFrame.new(newPos, targetCFrame.Position)

            toggle = not toggle
        end)
    end

    btnOn.MouseButton1Click:Connect(function()
        if faceBangRunning then
            statusLabel.Text = "الحالة: Face Bang شغال بالفعل"
            return
        end

        local targetName = inputBox.Text:match("%S+")
        if not targetName or targetName == "" then
            statusLabel.Text = "الحالة: الرجاء إدخال اسم لاعب صحيح"
            return
        end

        local targetPlayer = Players:FindFirstChild(targetName)
        if not targetPlayer then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Name:lower():find(targetName:lower()) then
                    targetPlayer = plr
                    break
                end
            end
        end

        if targetPlayer then
            faceBang(targetPlayer)
        else
            statusLabel.Text = "الحالة: لم يتم العثور على اللاعب"
        end
    end)

    btnOff.MouseButton1Click:Connect(function()
        if not faceBangRunning then
            statusLabel.Text = "الحالة: Face Bang غير شغال"
            return
        end
        faceBangRunning = false
    end)
end

-- زر الإغلاق
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

-- زر التصغير والتوسيع مع أنيميشن
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 520, 0, 90)}):Play()
        for _, child in pairs(frame:GetChildren()) do
            if child ~= header then
                child.Visible = false
            end
        end
    else
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 520, 0, 580)}):Play()
        for _, child in pairs(frame:GetChildren()) do
            child.Visible = true
        end
    end
end)

-- إشعار ترحيبي
local function showNotification(text)
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

showNotification("مرحبا بك في Elite V5 PRO | 2025 | متكامل ومحسن مع Face Bang بطيء!")

