-- Elite V5 PRO GUI متكامل ومطور 2025
-- شامل: صفحة رئيسية (بروفايل مع صورة اللاعب + معلومات كاملة)
-- صفحة معلومات السيرفر
-- صفحة 18+ مع أوامر Face و Bang على لاعب بالاسم
-- قابل للسحب والتحريك، بأحجام محسنة وتجربة مستخدم سلسة

-- منع تشغيل نسخ متعددة
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- الخدمات
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- إنشاء واجهة المستخدم الأساسية
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- دوال مساعدة
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

-- دالة جعل الإطار قابل للسحب
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

-- === إنشاء الإطار الرئيسي ===
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 500, 0, 550) -- حجم أكبر ومناسب
frame.Position = UDim2.new(0.5, -250, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = EliteMenu
addUICorner(frame, 18)
makeDraggable(frame)

-- === شريط العنوان ===
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

-- زر الإغلاق
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

-- زر التصغير
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

-- === شريط الصفحات ===
local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 55)
pageBar.Position = UDim2.new(0, 0, 0, 45)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.03, 0)

-- === حاوية الصفحات ===
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -100)
pagesContainer.Position = UDim2.new(0, 0, 0, 100)
pagesContainer.BackgroundTransparency = 1

-- إنشاء أزرار الصفحات ودوال الانتقال بينهم
local pages = {}
local pageButtons = {}

local pageNames = {"الرئيسية", "معلومات السيرفر", "18+"}

local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 140, 0, 45)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.2)
    end)

    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.2)
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

-- نفتح الصفحة الرئيسية افتراضياً
hideAllPages()
pages["الرئيسية"].Visible = true

-- ======= محتوى الصفحة الرئيسية: معلومات اللاعب والبروفايل =======
do
    local page = pages["الرئيسية"]

    -- حاوية معلومات اللاعب
    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.95, 0, 0, 180)
    playerInfoFrame.Position = UDim2.new(0.025, 0, 0.02, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(90, 0, 180)
    playerInfoFrame.BorderSizePixel = 0
    addUICorner(playerInfoFrame, 18)

    -- صورة البروفايل (يتم تحميل صورة لاعب تلقائياً)
    local profileImage = Instance.new("ImageLabel", playerInfoFrame)
    profileImage.Size = UDim2.new(0, 120, 0, 120)
    profileImage.Position = UDim2.new(0.02, 0, 0.1, 0)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
    addUICorner(profileImage, 60)

    -- اسم اللاعب
    local playerNameLabel = Instance.new("TextLabel", playerInfoFrame)
    playerNameLabel.Size = UDim2.new(0.6, 0, 0, 40)
    playerNameLabel.Position = UDim2.new(0.45, 0, 0.15, 0)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextSize = 28
    playerNameLabel.TextColor3 = Color3.new(1, 1, 1)
    playerNameLabel.Text = "اسم اللاعب: " .. LocalPlayer.Name
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- المستوى الافتراضي: كمثال (يمكن ربطها مع بيانات حقيقية من السيرفر)
    local levelLabel = Instance.new("TextLabel", playerInfoFrame)
    levelLabel.Size = UDim2.new(0.5, 0, 0, 30)
    levelLabel.Position = UDim2.new(0.45, 0, 0.45, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Font = Enum.Font.GothamBold
    levelLabel.TextSize = 22
    levelLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    levelLabel.Text = "المستوى: 23" -- عينة ثابتة

    -- الصحة + سرعة الحركة + الطاقة (مثال ديناميكي)
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
        fill.Size = UDim2.new(0.7, 0, 1, 0) -- نسبة تعبئة ثابتة مثلاً (يمكن ربطها بالحالة الفعلية)
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

    -- مثال لتحديث الصحة والحركة - ربط بالحالة الحقيقية لو متاح
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local function updateStats()
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            healthBar.fill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)

            local speedPercent = math.clamp(humanoid.WalkSpeed / 30, 0, 1)
            speedBar.fill:TweenSize(UDim2.new(speedPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)

            -- طاقة افتراضية (يمكن ربطها بحالة فعلية)
            local energyPercent = 0.75
            energyBar.fill:TweenSize(UDim2.new(energyPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
        end
        updateStats()
        humanoid:GetPropertyChangedSignal("Health"):Connect(updateStats)
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(updateStats)
    end

    -- زر تحديث بروفايل اللاعب (إذا تم تغيير شخصية)
    LocalPlayer.CharacterAdded:Connect(function(char)
        wait(1)
        profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
        playerNameLabel.Text = "اسم اللاعب: " .. LocalPlayer.Name
    end)
end

-- ======= محتوى صفحة معلومات السيرفر =======
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

    -- بيانات السيرفر (مثال، يمكن ربطها بالبيانات الحقيقية لو متاحة)
    local maxPlayers = 20
    local currentPlayers = #Players:GetPlayers()
    local serverName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

    infoText.Text = string.format([[
معلومات السيرفر:

• اسم السيرفر: %s
• اللاعبين المتصلين الآن: %d / %d
• الوقت: %s
• رقم المكان: %d

*تم تطوير الواجهة بواسطة Elite V5 PRO
    ]], serverName, currentPlayers, maxPlayers, os.date("%H:%M:%S"), game.PlaceId)
end

-- ======= صفحة 18+ (Face Bang) - تنفيذ حركات على لاعب معين =======
do
    local page = pages["18+"]

    -- تعليمات
    local instructions = Instance.new("TextLabel", page)
    instructions.Size = UDim2.new(0.95, 0, 0, 50)
    instructions.Position = UDim2.new(0.025, 0, 0.02, 0)
    instructions.BackgroundTransparency = 1
    instructions.TextColor3 = Color3.new(1, 1, 1)
    instructions.Font = Enum.Font.GothamBold
    instructions.TextSize = 20
    instructions.Text = "اكتب اسم اللاعب واضغط Execute لتشغيل FaceBang"
    instructions.TextXAlignment = Enum.TextXAlignment.Center

    -- حقل الإدخال
    local inputBox = Instance.new("TextBox", page)
    inputBox.Size = UDim2.new(0.6, 0, 0, 35)
    inputBox.Position = UDim2.new(0.05, 0, 0.12, 0)
    inputBox.PlaceholderText = "اسم اللاعب هنا"
    inputBox.ClearTextOnFocus = false
    inputBox.Font = Enum.Font.GothamBold
    inputBox.TextSize = 18
    inputBox.TextColor3 = Color3.new(0, 0, 0)
    addUICorner(inputBox, 14)

    -- زر التنفيذ
    local executeBtn = Instance.new("TextButton", page)
    executeBtn.Size = UDim2.new(0.3, 0, 0, 35)
    executeBtn.Position = UDim2.new(0.7, 0, 0.12, 0)
    executeBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
    executeBtn.Text = "Execute"
    executeBtn.Font = Enum.Font.GothamBold
    executeBtn.TextSize = 20
    executeBtn.TextColor3 = Color3.new(1, 1, 1)
    addUICorner(executeBtn, 14)

    -- مناطق عرض الحالة
    local statusLabel = Instance.new("TextLabel", page)
    statusLabel.Size = UDim2.new(0.95, 0, 0, 35)
    statusLabel.Position = UDim2.new(0.025, 0, 0.18, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.Font = Enum.Font.GothamBold
    statusLabel.TextSize = 18
    statusLabel.Text = "Status: Ready"
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- تنفيذ حركات Face Bang على اللاعب المحدد
    local function faceBang(targetPlayer)
        if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            statusLabel.Text = "Status: اللاعب غير متصل أو لم يتم العثور على الشخصية"
            return
        end
        local hrp = targetPlayer.Character.HumanoidRootPart
        local originalCFrame = hrp.CFrame

        statusLabel.Text = "Status: بدء Face Bang على " .. targetPlayer.Name

        -- حركة بسيطة متكررة للأمام والخلف
        for i = 1, 10 do
            hrp.CFrame = originalCFrame * CFrame.new(0, 0, -1)
            task.wait(0.15)
            hrp.CFrame = originalCFrame * CFrame.new(0, 0, 1)
            task.wait(0.15)
        end
        hrp.CFrame = originalCFrame

        statusLabel.Text = "Status: انتهى Face Bang على " .. targetPlayer.Name
    end

    -- تنفيذ الأمر عند الضغط على الزر
    executeBtn.MouseButton1Click:Connect(function()
        local targetName = inputBox.Text:match("%S+")
        if not targetName or targetName == "" then
            statusLabel.Text = "Status: يرجى إدخال اسم لاعب صالح"
            return
        end

        local targetPlayer = Players:FindFirstChild(targetName)
        if not targetPlayer then
            -- البحث بحساسية أقل (مثل الاسم الجزئي)
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
            statusLabel.Text = "Status: لم يتم العثور على اللاعب"
        end
    end)
end

-- ======== أزرار التحكم ========
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 60)}):Play()
        for _, child in pairs(frame:GetChildren()) do
            if child ~= header then
                child.Visible = false
            end
        end
    else
        TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 500, 0, 550)}):Play()
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

showNotification("مرحبا بك في Elite V5 PRO")

-- النهاية
