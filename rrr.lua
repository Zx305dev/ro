-- Elite Hack System 2025 - سكربت متكامل مع قائمة UI واضحة وصفحات كاملة
-- من تصميم Alm6eri
-- كامل بالعربي السعودي مع تحكم كامل، Bang مع سرعة قابلة للتعديل، ESP قابل للتفعيل والتعطيل مع اختيار اللون، Fly بدون انيميشن السقوط، نافذة قابلة للسحب والتكبير والتصغير مع تأثيرات Fade In/Out، ومعلومات اللاعب مع صورة بروفايل.

-- الخدمات
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- إعدادات عامة الألوان
local COLORS = {
    purple = Color3.fromRGB(148, 0, 211),
    white = Color3.fromRGB(255, 255, 255),
    darkBackground = Color3.fromRGB(30, 15, 45),
    green = Color3.fromRGB(0, 180, 60),
    red = Color3.fromRGB(180, 0, 0),
    blackTransparent = Color3.fromRGB(0, 0, 0),
}

-- المتغيرات الرئيسية
local GUI = Instance.new("ScreenGui", game.CoreGui)
GUI.Name = "EliteHackSystem"
GUI.ResetOnSpawn = false

-- متغيرات للنظام
local bangSettings = {
    active = false,
    target = nil,
    oscillationFrequency = 1.2,
    oscillationAmplitude = 2.5,
    baseFollowDistance = 3.5,
}

local espSettings = {
    enabled = false,
    color = COLORS.purple,
    boxes = {},
}

local flySettings = {
    enabled = false,
    speed = 50,
    bodyVelocity = nil,
}

-- واجهة الإشعارات
local notificationFrame = Instance.new("Frame", GUI)
notificationFrame.Size = UDim2.new(0, 300, 0, 40)
notificationFrame.Position = UDim2.new(0.5, -150, 0.9, 0)
notificationFrame.BackgroundColor3 = COLORS.darkBackground
notificationFrame.BackgroundTransparency = 0.85
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = false
local notificationText = Instance.new("TextLabel", notificationFrame)
notificationText.Size = UDim2.new(1, 0, 1, 0)
notificationText.BackgroundTransparency = 1
notificationText.Font = Enum.Font.GothamBold
notificationText.TextSize = 20
notificationText.TextColor3 = COLORS.white
notificationText.TextStrokeTransparency = 0.5
notificationText.Text = ""

local function notify(text, duration)
    notificationText.Text = text
    notificationFrame.Visible = true
    notificationFrame.BackgroundTransparency = 1
    TweenService:Create(notificationFrame, TweenInfo.new(0.3), {BackgroundTransparency = 0.85}):Play()
    delay(duration or 3, function()
        TweenService:Create(notificationFrame, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
        wait(0.7)
        notificationFrame.Visible = false
    end)
end

-- دالة لإضافة زوايا مستديرة بسهولة
local function addUICorner(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = inst
end

-- إنشاء النافذة الرئيسية (قابلة للسحب والتكبير والتصغير)
local window = Instance.new("Frame", GUI)
window.Name = "MainWindow"
window.Size = UDim2.new(0, 450, 0, 400)
window.Position = UDim2.new(0.5, -225, 0.4, -200)
window.BackgroundColor3 = COLORS.darkBackground
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true
addUICorner(window, 15)

-- عنوان النافذة
local title = Instance.new("TextLabel", window)
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = COLORS.purple
title.Text = "Elite - Made by Alm6eri"
title.TextStrokeTransparency = 0.5

-- زر الإغلاق
local closeBtn = Instance.new("TextButton", window)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = COLORS.red
closeBtn.TextColor3 = COLORS.white
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.Text = "✕"
addUICorner(closeBtn, 8)
closeBtn.MouseButton1Click:Connect(function()
    GUI.Enabled = false
end)

-- زر التصغير/التكبير
local minimizeBtn = Instance.new("TextButton", window)
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -80, 0, 5)
minimizeBtn.BackgroundColor3 = COLORS.purple
minimizeBtn.TextColor3 = COLORS.white
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 22
minimizeBtn.Text = "─"
addUICorner(minimizeBtn, 8)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        window.Size = UDim2.new(0, 450, 0, 400)
        minimized = false
    else
        window.Size = UDim2.new(0, 450, 0, 45)
        minimized = true
    end
end)

-- قائمة التبويبات (Tabs)
local tabsContainer = Instance.new("Frame", window)
tabsContainer.Size = UDim2.new(0, 450, 0, 40)
tabsContainer.Position = UDim2.new(0, 0, 0, 40)
tabsContainer.BackgroundTransparency = 1

local pagesContainer = Instance.new("Frame", window)
pagesContainer.Size = UDim2.new(1, 0, 1, -80)
pagesContainer.Position = UDim2.new(0, 0, 0, 80)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ClipsDescendants = true

-- دالة مساعدة لتغيير الألوان عند التبويب
local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", tabsContainer)
    btn.Size = UDim2.new(0, 110, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.TextColor3 = COLORS.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = name
    addUICorner(btn, 10)
    return btn
end

-- إنشاء الصفحات وتخزينها
local pages = {}

-- صفحة Bang
local bangPage = Instance.new("Frame", pagesContainer)
bangPage.Size = UDim2.new(1, 0, 1, 0)
bangPage.BackgroundTransparency = 1
bangPage.Visible = true
pages["Bang"] = bangPage

-- صفحة ESP & Fly
local espFlyPage = Instance.new("Frame", pagesContainer)
espFlyPage.Size = UDim2.new(1, 0, 1, 0)
espFlyPage.BackgroundTransparency = 1
espFlyPage.Visible = false
pages["ESP & Fly"] = espFlyPage

-- صفحة معلومات اللاعب
local infoPage = Instance.new("Frame", pagesContainer)
infoPage.Size = UDim2.new(1, 0, 1, 0)
infoPage.BackgroundTransparency = 1
infoPage.Visible = false
pages["معلومات اللاعب"] = infoPage

-- إنشاء أزرار التبويبات
local tabButtons = {}
local tabNames = {"Bang", "ESP & Fly", "معلومات اللاعب"}
for i, name in ipairs(tabNames) do
    local btn = createTabButton(name, (i-1)*115 + 10)
    tabButtons[name] = btn
end

-- تغيير التبويب
local function setActiveTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
        tabButtons[tabName].BackgroundColor3 = (tabName == name) and COLORS.purple or COLORS.darkBackground
    end
end

-- اجعل التبويب "Bang" هو الافتراضي
setActiveTab("Bang")

-- ربط أزرار التبويبات
for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActiveTab(name)
    end)
end

-- =================== صفحة Bang ===================
do
    local page = bangPage

    -- النص الإرشادي
    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 30)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "نظام Bang - تحكم كامل بالسرعة والمسافة"

    -- مربع إدخال اسم الهدف
    local targetBox = Instance.new("TextBox", page)
    targetBox.Size = UDim2.new(0.7, -20, 0, 35)
    targetBox.Position = UDim2.new(0, 20, 0, 50)
    targetBox.PlaceholderText = "أدخل اسم اللاعب الهدف"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 20
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(targetBox, 10)

    -- سرعة التذبذب
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0.4, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 95)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.Text = "سرعة التذبذب:"

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0.25, 0, 0, 25)
    speedBox.Position = UDim2.new(0.4, 10, 0, 95)
    speedBox.PlaceholderText = "1.2"
    speedBox.Text = tostring(bangSettings.oscillationFrequency)
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 16
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedBox, 8)

    -- مقدار التذبذب (المسافة)
    local amplitudeLabel = Instance.new("TextLabel", page)
    amplitudeLabel.Size = UDim2.new(0.4, 0, 0, 25)
    amplitudeLabel.Position = UDim2.new(0, 20, 0, 130)
    amplitudeLabel.BackgroundTransparency = 1
    amplitudeLabel.Font = Enum.Font.GothamBold
    amplitudeLabel.TextSize = 18
    amplitudeLabel.TextColor3 = COLORS.white
    amplitudeLabel.Text = "مقدار التذبذب:"

    local amplitudeBox = Instance.new("TextBox", page)
    amplitudeBox.Size = UDim2.new(0.25, 0, 0, 25)
    amplitudeBox.Position = UDim2.new(0.4, 10, 0, 130)
    amplitudeBox.PlaceholderText = "2.5"
    amplitudeBox.Text = tostring(bangSettings.oscillationAmplitude)
    amplitudeBox.Font = Enum.Font.GothamBold
    amplitudeBox.TextSize = 16
    amplitudeBox.TextColor3 = COLORS.white
    amplitudeBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(amplitudeBox, 8)

    -- المسافة الأساسية خلف الهدف
    local baseDistLabel = Instance.new("TextLabel", page)
    baseDistLabel.Size = UDim2.new(0.6, 0, 0, 25)
    baseDistLabel.Position = UDim2.new(0, 20, 0, 165)
    baseDistLabel.BackgroundTransparency = 1
    baseDistLabel.Font = Enum.Font.GothamBold
    baseDistLabel.TextSize = 18
    baseDistLabel.TextColor3 = COLORS.white
    baseDistLabel.Text = "المسافة الأساسية خلف الهدف:"

    local baseDistBox = Instance.new("TextBox", page)
    baseDistBox.Size = UDim2.new(0.25, 0, 0, 25)
    baseDistBox.Position = UDim2.new(0.55, 10, 0, 165)
    baseDistBox.PlaceholderText = "3.5"
    baseDistBox.Text = tostring(bangSettings.baseFollowDistance)
    baseDistBox.Font = Enum.Font.GothamBold
    baseDistBox.TextSize = 16
    baseDistBox.TextColor3 = COLORS.white
    baseDistBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(baseDistBox, 8)

    -- زر تشغيل Bang
    local startBtn = Instance.new("TextButton", page)
    startBtn.Size = UDim2.new(0.45, -15, 0, 45)
    startBtn.Position = UDim2.new(0, 20, 1, -70)
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.TextColor3 = COLORS.white
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 22
    startBtn.Text = "تشغيل Bang"
    addUICorner(startBtn, 12)

    -- زر إيقاف Bang
    local stopBtn = Instance.new("TextButton", page)
    stopBtn.Size = UDim2.new(0.45, -15, 0, 45)
    stopBtn.Position = UDim2.new(0.55, 0, 1, -70)
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.TextColor3 = COLORS.white
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 22
    stopBtn.Text = "إيقاف Bang"
    addUICorner(stopBtn, 12)

    -- دوال Bang

    local function SetNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- منع تحكم اليد عند Bang مفعل
    RS:BindToRenderStep("DisablePlayerInput", Enum.RenderPriority.Character.Value + 4, function()
        if bangSettings.active and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
            end
        else
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end)

    local function GetPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    local function FollowTarget(dt)
        if not bangSettings.active or not bangSettings.target then return end
        if not bangSettings.target.Character then return end
        if not LocalPlayer.Character then return end

        local targetHRP = bangSettings.target.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local targetLookVector = targetHRP.CFrame.LookVector
        local time = tick()
        local oscillation = math.sin(time * bangSettings.oscillationFrequency * math.pi * 2) * bangSettings.oscillationAmplitude

        local basePosition = targetHRP.Position - targetLookVector * bangSettings.baseFollowDistance
        local desiredPosition = basePosition + targetLookVector * oscillation

        local vectorToDesired = desiredPosition - targetHRP.Position
        if vectorToDesired:Dot(targetLookVector) > 0 then
            desiredPosition = basePosition
        end

        localHRP.CFrame = CFrame.new(desiredPosition, targetHRP.Position)
    end

    RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function(dt)
        if bangSettings.active then
            FollowTarget(dt)
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        local name = targetBox.Text
        if name == "" then
            notify("يرجى إدخال اسم اللاعب الهدف.", 3)
            return
        end
        local target = GetPlayerByName(name)
        if not target then
            notify("اللاعب غير موجود.", 3)
            return
        end
        bangSettings.target = target
        bangSettings.active = true
        bangSettings.oscillationFrequency = tonumber(speedBox.Text) or 1.2
        bangSettings.oscillationAmplitude = tonumber(amplitudeBox.Text) or 2.5
        bangSettings.baseFollowDistance = tonumber(baseDistBox.Text) or 3.5
        SetNoclip(true)
        notify("تم تفعيل Bang على اللاعب: " .. target.Name, 3)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        bangSettings.active = false
        bangSettings.target = nil
        SetNoclip(false)
        notify("تم إيقاف Bang وإعادة التحكم.", 3)
    end)
end

-- =================== صفحة ESP و Fly ===================
do
    local page = espFlyPage

    -- العنوان
    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 30)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "ESP و Fly - التحكم الكامل"

    -- تفعيل/إيقاف ESP
    local espToggle = Instance.new("TextButton", page)
    espToggle.Size = UDim2.new(0.3, 0, 0, 40)
    espToggle.Position = UDim2.new(0, 20, 0, 50)
    espToggle.BackgroundColor3 = COLORS.purple
    espToggle.TextColor3 = COLORS.white
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 20
    espToggle.Text = "تفعيل ESP"
    addUICorner(espToggle, 10)

    -- اختيار لون ESP (زر للتبديل بين ألوان مختلفة)
    local espColors = {COLORS.purple, COLORS.green, COLORS.red, COLORS.white}
    local espColorNames = {"بنفسجي", "أخضر", "أحمر", "أبيض"}
    local currentEspColorIndex = 1

    local espColorBtn = Instance.new("TextButton", page)
    espColorBtn.Size = UDim2.new(0.25, 0, 0, 40)
    espColorBtn.Position = UDim2.new(0.35, 20, 0, 50)
    espColorBtn.BackgroundColor3 = espColors[currentEspColorIndex]
    espColorBtn.TextColor3 = COLORS.white
    espColorBtn.Font = Enum.Font.GothamBold
    espColorBtn.TextSize = 18
    espColorBtn.Text = espColorNames[currentEspColorIndex]
    addUICorner(espColorBtn, 10)

    espColorBtn.MouseButton1Click:Connect(function()
        currentEspColorIndex = currentEspColorIndex + 1
        if currentEspColorIndex > #espColors then currentEspColorIndex = 1 end
        espSettings.color = espColors[currentEspColorIndex]
        espColorBtn.BackgroundColor3 = espSettings.color
        espColorBtn.Text = espColorNames[currentEspColorIndex]
    end)

    -- تفعيل/إيقاف Fly
    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0.3, 0, 0, 40)
    flyToggle.Position = UDim2.new(0, 20, 0, 105)
    flyToggle.BackgroundColor3 = COLORS.purple
    flyToggle.TextColor3 = COLORS.white
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.Text = "تفعيل Fly"
    addUICorner(flyToggle, 10)

    -- سرعة الطيران
    local flySpeedLabel = Instance.new("TextLabel", page)
    flySpeedLabel.Size = UDim2.new(0.4, 0, 0, 25)
    flySpeedLabel.Position = UDim2.new(0, 20, 0, 155)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 18
    flySpeedLabel.TextColor3 = COLORS.white
    flySpeedLabel.Text = "سرعة الطيران:"

    local flySpeedBox = Instance.new("TextBox", page)
    flySpeedBox.Size = UDim2.new(0.25, 0, 0, 25)
    flySpeedBox.Position = UDim2.new(0.4, 10, 0, 155)
    flySpeedBox.PlaceholderText = "50"
    flySpeedBox.Text = tostring(flySettings.speed)
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 16
    flySpeedBox.TextColor3 = COLORS.white
    flySpeedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(flySpeedBox, 8)

    -- Fly logic
    local function toggleFly(enable)
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if enable then
            flySettings.bodyVelocity = Instance.new("BodyVelocity", hrp)
            flySettings.bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flySettings.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            notify("تم تفعيل Fly", 3)
        else
            if flySettings.bodyVelocity then
                flySettings.bodyVelocity:Destroy()
                flySettings.bodyVelocity = nil
            end
            notify("تم إيقاف Fly", 3)
        end
    end

    flyToggle.MouseButton1Click:Connect(function()
        flySettings.enabled = not flySettings.enabled
        flyToggle.Text = flySettings.enabled and "إيقاف Fly" or "تفعيل Fly"
        toggleFly(flySettings.enabled)
    end)

    flySpeedBox.FocusLost:Connect(function()
        local val = tonumber(flySpeedBox.Text)
        if val and val > 0 and val <= 200 then
            flySettings.speed = val
        else
            flySpeedBox.Text = tostring(flySettings.speed)
            notify("الرجاء إدخال سرعة صحيحة بين 1 و 200", 3)
        end
    end)

    -- ESP Logic: رسم مربعات حول اللاعبين (باستخدام BillboardGui)
    local function createESPBox(player)
        if espSettings.boxes[player] then return end
        if not player.Character then return end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local box = Instance.new("BillboardGui")
        box.Name = "ESPBox"
        box.Adornee = hrp
        box.AlwaysOnTop = true
        box.Size = UDim2.new(0, 100, 0, 40)
        box.StudsOffset = Vector3.new(0, 2.5, 0)
        box.Parent = GUI

        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 1
        frame.BorderColor3 = espSettings.color
        frame.BorderSizePixel = 2
        addUICorner(frame, 6)

        local nameLabel = Instance.new("TextLabel", frame)
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = espSettings.color
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeTransparency = 0.7
        nameLabel.TextSize = 18
        nameLabel.Text = player.Name
        nameLabel.TextWrapped = true
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center

        espSettings.boxes[player] = box
    end

    local function removeESPBox(player)
        if espSettings.boxes[player] then
            espSettings.boxes[player]:Destroy()
            espSettings.boxes[player] = nil
        end
    end

    local function updateESPBoxes()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if espSettings.enabled then
                    if not espSettings.boxes[player] then
                        createESPBox(player)
                    end
                else
                    removeESPBox(player)
                end
            end
        end
    end

    -- تحديث ألوان ESP boxes
    local function updateESPColors()
        for player, box in pairs(espSettings.boxes) do
            if box and box:FindFirstChildOfClass("Frame") then
                local frame = box:FindFirstChildOfClass("Frame")
                frame.BorderColor3 = espSettings.color
                if frame:FindFirstChildOfClass("TextLabel") then
                    frame:FindFirstChildOfClass("TextLabel").TextColor3 = espSettings.color
                end
            end
        end
    end

    espToggle.MouseButton1Click:Connect(function()
        espSettings.enabled = not espSettings.enabled
        espToggle.Text = espSettings.enabled and "إيقاف ESP" or "تفعيل ESP"
        updateESPBoxes()
    end)

    espColorBtn.MouseButton1Click:Connect(function()
        updateESPColors()
    end)

    -- تحديث ESP بشكل دوري
    RS:BindToRenderStep("UpdateESP", Enum.RenderPriority.Last.Value, function()
        if espSettings.enabled then
            updateESPBoxes()
            updateESPColors()
        else
            -- تأكد من إزالة كل الصناديق عند تعطيل ESP
            for player, _ in pairs(espSettings.boxes) do
                removeESPBox(player)
            end
        end
    end)

    -- Fly سرعة تحديث
    RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Last.Value, function()
        if flySettings.enabled and flySettings.bodyVelocity and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local moveVector = Vector3.new(0, 0, 0)
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + hrp.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - hrp.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - hrp.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + hrp.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                if moveVector.Magnitude > 0 then
                    moveVector = moveVector.Unit * flySettings.speed
                end
                flySettings.bodyVelocity.Velocity = moveVector
            end
        end
    end)
end

-- =================== صفحة معلومات اللاعب ===================
do
    local page = infoPage

    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 30)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "معلومات اللاعب الشخصية"

    -- صورة البروفايل
    local profilePic = Instance.new("ImageLabel", page)
    profilePic.Size = UDim2.new(0, 140, 0, 140)
    profilePic.Position = UDim2.new(0.5, -70, 0, 50)
    profilePic.BackgroundTransparency = 1
    profilePic.Image = ""
    addUICorner(profilePic, 15)

    -- اسم اللاعب
    local nameLabel = Instance.new("TextLabel", page)
    nameLabel.Size = UDim2.new(1, -40, 0, 30)
    nameLabel.Position = UDim2.new(0, 20, 0, 200)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 20
    nameLabel.TextColor3 = COLORS.white
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- معرّف المستخدم
    local userIdLabel = Instance.new("TextLabel", page)
    userIdLabel.Size = UDim2.new(1, -40, 0, 25)
    userIdLabel.Position = UDim2.new(0, 20, 0, 235)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.Font = Enum.Font.GothamBold
    userIdLabel.TextSize = 18
    userIdLabel.TextColor3 = COLORS.white
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- تحديث معلومات اللاعب
    local function updatePlayerInfo()
        local plr = LocalPlayer
        if plr then
            profilePic.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"
            nameLabel.Text = "الاسم: " .. plr.Name
            userIdLabel.Text = "معرّف المستخدم: " .. tostring(plr.UserId)
        end
    end

    updatePlayerInfo()

    -- تحديث الصورة كل 10 ثواني لضمان تحديث صورة البروفايل في حال تغيرت
    spawn(function()
        while wait(10) do
            updatePlayerInfo()
        end
    end)
end

-- تفعيل GUI تلقائيًا عند بدء اللعب
GUI.Enabled = true

-- تأثير Fade In للنافذة عند الظهور
TweenService:Create(window, TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

-- يمكن إضافة هنا المزيد من التحسينات حسب الطلب مثل الصوتيات، أو أوامر الاختصارات، أو حماية السكربت.

return GUI
