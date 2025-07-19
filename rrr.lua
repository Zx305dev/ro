-- Elite Hack System 2025 - تحديث شامل
-- من تصميم Alm6eri
-- دمج كل الهاكات في صفحة واحدة مع تحسينات Fly، إضافة Noclip، Speed، Jump، وتحسين Bang مع تعديل الكاميرا وإشعارات متقدمة

-- الخدمات
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- ألوان
local COLORS = {
    purple = Color3.fromRGB(148, 0, 211),
    white = Color3.fromRGB(255, 255, 255),
    darkBackground = Color3.fromRGB(30, 15, 45),
    green = Color3.fromRGB(0, 180, 60),
    red = Color3.fromRGB(180, 0, 0),
    blackTransparent = Color3.fromRGB(0, 0, 0),
}

-- GUI
local GUI = Instance.new("ScreenGui", game.CoreGui)
GUI.Name = "EliteHackSystem"
GUI.ResetOnSpawn = false

-- متغيرات النظام
local hackSettings = {
    bang = {
        active = false,
        target = nil,
        oscillationFrequency = 1.2,
        oscillationAmplitude = 2.5,
        baseFollowDistance = 3.5,
    },
    esp = {
        enabled = false,
        color = COLORS.purple,
        boxes = {},
    },
    fly = {
        enabled = false,
        speed = 50,
        bodyVelocity = nil,
    },
    noclip = {
        enabled = false,
    },
    speed = {
        enabled = false,
        multiplier = 2,
    },
    jump = {
        enabled = false,
        power = 100,
    },
}

-- إشعارات
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

-- دالة زوايا مستديرة
local function addUICorner(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = inst
end

-- نافذة رئيسية
local window = Instance.new("Frame", GUI)
window.Name = "MainWindow"
window.Size = UDim2.new(0, 480, 0, 460)
window.Position = UDim2.new(0.5, -240, 0.4, -230)
window.BackgroundColor3 = COLORS.darkBackground
window.BorderSizePixel = 0
window.Active = true
window.Draggable = true
addUICorner(window, 15)

-- عنوان النافذة
local title = Instance.new("TextLabel", window)
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 30
title.TextColor3 = COLORS.purple
title.Text = "Elite - Made by Alm6eri"
title.TextStrokeTransparency = 0.5

-- زر إغلاق
local closeBtn = Instance.new("TextButton", window)
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 5)
closeBtn.BackgroundColor3 = COLORS.red
closeBtn.TextColor3 = COLORS.white
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Text = "✕"
addUICorner(closeBtn, 8)
closeBtn.MouseButton1Click:Connect(function()
    GUI.Enabled = false
end)

-- زر تصغير/تكبير
local minimizeBtn = Instance.new("TextButton", window)
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -100, 0, 5)
minimizeBtn.BackgroundColor3 = COLORS.purple
minimizeBtn.TextColor3 = COLORS.white
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.Text = "─"
addUICorner(minimizeBtn, 8)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if minimized then
        window.Size = UDim2.new(0, 480, 0, 460)
        minimized = false
    else
        window.Size = UDim2.new(0, 480, 0, 50)
        minimized = true
    end
end)

-- تبويبات
local tabsContainer = Instance.new("Frame", window)
tabsContainer.Size = UDim2.new(1, 0, 0, 50)
tabsContainer.Position = UDim2.new(0, 0, 0, 45)
tabsContainer.BackgroundTransparency = 1

local pagesContainer = Instance.new("Frame", window)
pagesContainer.Size = UDim2.new(1, 0, 1, -95)
pagesContainer.Position = UDim2.new(0, 0, 0, 95)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ClipsDescendants = true

local function createTabButton(name, posX)
    local btn = Instance.new("TextButton", tabsContainer)
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.Position = UDim2.new(0, posX, 0, 0)
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.TextColor3 = COLORS.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = name
    addUICorner(btn, 10)
    return btn
end

local pages = {}

-- صفحة الهاكات كاملة
local hacksPage = Instance.new("Frame", pagesContainer)
hacksPage.Size = UDim2.new(1, 0, 1, 0)
hacksPage.BackgroundTransparency = 1
hacksPage.Visible = true
pages["الهاكات"] = hacksPage

-- صفحة معلومات اللاعب
local infoPage = Instance.new("Frame", pagesContainer)
infoPage.Size = UDim2.new(1, 0, 1, 0)
infoPage.BackgroundTransparency = 1
infoPage.Visible = false
pages["معلومات اللاعب"] = infoPage

-- أزرار التبويبات
local tabButtons = {}
local tabNames = {"الهاكات", "معلومات اللاعب"}
for i, name in ipairs(tabNames) do
    local btn = createTabButton(name, (i-1)*135 + 15)
    tabButtons[name] = btn
end

local function setActiveTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
        tabButtons[tabName].BackgroundColor3 = (tabName == name) and COLORS.purple or COLORS.darkBackground
    end
end
setActiveTab("الهاكات")

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActiveTab(name)
    end)
end

-- =================== صفحة الهاكات ===================
do
    local page = hacksPage
    local spacingY = 50
    local startX = 20
    local startY = 20

    -- عنوان
    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, startX, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "جميع الهاكات والتحكم الكامل"

    -- --- Bang ---
    local bangTitle = Instance.new("TextLabel", page)
    bangTitle.Size = UDim2.new(0.5, -10, 0, 30)
    bangTitle.Position = UDim2.new(0, startX, 0, 45)
    bangTitle.BackgroundTransparency = 1
    bangTitle.Font = Enum.Font.GothamBold
    bangTitle.TextSize = 20
    bangTitle.TextColor3 = COLORS.white
    bangTitle.Text = "Bang - الهدف والسرعة"

    local targetBox = Instance.new("TextBox", page)
    targetBox.Size = UDim2.new(0.45, 0, 0, 30)
    targetBox.Position = UDim2.new(0.5, 10, 0, 50)
    targetBox.PlaceholderText = "اسم اللاعب الهدف"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 18
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(targetBox, 8)

    -- سرعة التذبذب
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0.3, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, startX, 0, 85)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 16
    speedLabel.TextColor3 = COLORS.white
    speedLabel.Text = "سرعة التذبذب:"

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0.15, 0, 0, 25)
    speedBox.Position = UDim2.new(0.3, 10, 0, 85)
    speedBox.PlaceholderText = "1.2"
    speedBox.Text = tostring(hackSettings.bang.oscillationFrequency)
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 14
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedBox, 6)

    -- مقدار التذبذب
    local amplitudeLabel = Instance.new("TextLabel", page)
    amplitudeLabel.Size = UDim2.new(0.3, 0, 0, 25)
    amplitudeLabel.Position = UDim2.new(0, startX, 0, 115)
    amplitudeLabel.BackgroundTransparency = 1
    amplitudeLabel.Font = Enum.Font.GothamBold
    amplitudeLabel.TextSize = 16
    amplitudeLabel.TextColor3 = COLORS.white
    amplitudeLabel.Text = "مقدار التذبذب:"

    local amplitudeBox = Instance.new("TextBox", page)
    amplitudeBox.Size = UDim2.new(0.15, 0, 0, 25)
    amplitudeBox.Position = UDim2.new(0.3, 10, 0, 115)
    amplitudeBox.PlaceholderText = "2.5"
    amplitudeBox.Text = tostring(hackSettings.bang.oscillationAmplitude)
    amplitudeBox.Font = Enum.Font.GothamBold
    amplitudeBox.TextSize = 14
    amplitudeBox.TextColor3 = COLORS.white
    amplitudeBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(amplitudeBox, 6)

    -- المسافة الأساسية خلف الهدف
    local baseDistLabel = Instance.new("TextLabel", page)
    baseDistLabel.Size = UDim2.new(0.4, 0, 0, 25)
    baseDistLabel.Position = UDim2.new(0, startX, 0, 145)
    baseDistLabel.BackgroundTransparency = 1
    baseDistLabel.Font = Enum.Font.GothamBold
    baseDistLabel.TextSize = 16
    baseDistLabel.TextColor3 = COLORS.white
    baseDistLabel.Text = "المسافة الأساسية خلف الهدف:"

    local baseDistBox = Instance.new("TextBox", page)
    baseDistBox.Size = UDim2.new(0.15, 0, 0, 25)
    baseDistBox.Position = UDim2.new(0.4, 10, 0, 145)
    baseDistBox.PlaceholderText = "3.5"
    baseDistBox.Text = tostring(hackSettings.bang.baseFollowDistance)
    baseDistBox.Font = Enum.Font.GothamBold
    baseDistBox.TextSize = 14
    baseDistBox.TextColor3 = COLORS.white
    baseDistBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(baseDistBox, 6)

    local bangStartBtn = Instance.new("TextButton", page)
    bangStartBtn.Size = UDim2.new(0.45, -15, 0, 40)
    bangStartBtn.Position = UDim2.new(0, startX, 1, -65)
    bangStartBtn.BackgroundColor3 = COLORS.green
    bangStartBtn.TextColor3 = COLORS.white
    bangStartBtn.Font = Enum.Font.GothamBold
    bangStartBtn.TextSize = 20
    bangStartBtn.Text = "تشغيل Bang"
    addUICorner(bangStartBtn, 10)

    local bangStopBtn = Instance.new("TextButton", page)
    bangStopBtn.Size = UDim2.new(0.45, -15, 0, 40)
    bangStopBtn.Position = UDim2.new(0.5, 10, 1, -65)
    bangStopBtn.BackgroundColor3 = COLORS.red
    bangStopBtn.TextColor3 = COLORS.white
    bangStopBtn.Font = Enum.Font.GothamBold
    bangStopBtn.TextSize = 20
    bangStopBtn.Text = "إيقاف Bang"
    addUICorner(bangStopBtn, 10)

    -- --- Noclip ---
    local noclipTitle = Instance.new("TextLabel", page)
    noclipTitle.Size = UDim2.new(0.5, -10, 0, 30)
    noclipTitle.Position = UDim2.new(0, startX, 0, 200)
    noclipTitle.BackgroundTransparency = 1
    noclipTitle.Font = Enum.Font.GothamBold
    noclipTitle.TextSize = 20
    noclipTitle.TextColor3 = COLORS.white
    noclipTitle.Text = "Noclip"

    local noclipToggleBtn = Instance.new("TextButton", page)
    noclipToggleBtn.Size = UDim2.new(0.3, 0, 0, 35)
    noclipToggleBtn.Position = UDim2.new(0.5, 10, 0, 200)
    noclipToggleBtn.BackgroundColor3 = COLORS.purple
    noclipToggleBtn.TextColor3 = COLORS.white
    noclipToggleBtn.Font = Enum.Font.GothamBold
    noclipToggleBtn.TextSize = 18
    noclipToggleBtn.Text = "تفعيل Noclip"
    addUICorner(noclipToggleBtn, 8)

    -- --- Fly ---
    local flyTitle = Instance.new("TextLabel", page)
    flyTitle.Size = UDim2.new(0.5, -10, 0, 30)
    flyTitle.Position = UDim2.new(0, startX, 0, 245)
    flyTitle.BackgroundTransparency = 1
    flyTitle.Font = Enum.Font.GothamBold
    flyTitle.TextSize = 20
    flyTitle.TextColor3 = COLORS.white
    flyTitle.Text = "Fly - طيران"

    local flyToggleBtn = Instance.new("TextButton", page)
    flyToggleBtn.Size = UDim2.new(0.3, 0, 0, 35)
    flyToggleBtn.Position = UDim2.new(0.5, 10, 0, 245)
    flyToggleBtn.BackgroundColor3 = COLORS.purple
    flyToggleBtn.TextColor3 = COLORS.white
    flyToggleBtn.Font = Enum.Font.GothamBold
    flyToggleBtn.TextSize = 18
    flyToggleBtn.Text = "تفعيل Fly"
    addUICorner(flyToggleBtn, 8)

    local flySpeedLabel = Instance.new("TextLabel", page)
    flySpeedLabel.Size = UDim2.new(0.3, 0, 0, 25)
    flySpeedLabel.Position = UDim2.new(0, startX, 0, 280)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 16
    flySpeedLabel.TextColor3 = COLORS.white
    flySpeedLabel.Text = "سرعة الطيران:"

    local flySpeedBox = Instance.new("TextBox", page)
    flySpeedBox.Size = UDim2.new(0.15, 0, 0, 25)
    flySpeedBox.Position = UDim2.new(0.3, 10, 0, 280)
    flySpeedBox.PlaceholderText = "50"
    flySpeedBox.Text = tostring(hackSettings.fly.speed)
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 14
    flySpeedBox.TextColor3 = COLORS.white
    flySpeedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(flySpeedBox, 6)

    -- --- Speed Hack ---
    local speedTitle = Instance.new("TextLabel", page)
    speedTitle.Size = UDim2.new(0.5, -10, 0, 30)
    speedTitle.Position = UDim2.new(0, startX, 0, 320)
    speedTitle.BackgroundTransparency = 1
    speedTitle.Font = Enum.Font.GothamBold
    speedTitle.TextSize = 20
    speedTitle.TextColor3 = COLORS.white
    speedTitle.Text = "Speed Hack - سرعة اللاعب"

    local speedToggleBtn = Instance.new("TextButton", page)
    speedToggleBtn.Size = UDim2.new(0.3, 0, 0, 35)
    speedToggleBtn.Position = UDim2.new(0.5, 10, 0, 320)
    speedToggleBtn.BackgroundColor3 = COLORS.purple
    speedToggleBtn.TextColor3 = COLORS.white
    speedToggleBtn.Font = Enum.Font.GothamBold
    speedToggleBtn.TextSize = 18
    speedToggleBtn.Text = "تفعيل Speed"
    addUICorner(speedToggleBtn, 8)

    local speedMultLabel = Instance.new("TextLabel", page)
    speedMultLabel.Size = UDim2.new(0.3, 0, 0, 25)
    speedMultLabel.Position = UDim2.new(0, startX, 0, 355)
    speedMultLabel.BackgroundTransparency = 1
    speedMultLabel.Font = Enum.Font.GothamBold
    speedMultLabel.TextSize = 16
    speedMultLabel.TextColor3 = COLORS.white
    speedMultLabel.Text = "مضاعف السرعة:"

    local speedMultBox = Instance.new("TextBox", page)
    speedMultBox.Size = UDim2.new(0.15, 0, 0, 25)
    speedMultBox.Position = UDim2.new(0.3, 10, 0, 355)
    speedMultBox.PlaceholderText = "2"
    speedMultBox.Text = tostring(hackSettings.speed.multiplier)
    speedMultBox.Font = Enum.Font.GothamBold
    speedMultBox.TextSize = 14
    speedMultBox.TextColor3 = COLORS.white
    speedMultBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedMultBox, 6)

    -- --- Jump Hack ---
    local jumpTitle = Instance.new("TextLabel", page)
    jumpTitle.Size = UDim2.new(0.5, -10, 0, 30)
    jumpTitle.Position = UDim2.new(0, startX, 0, 395)
    jumpTitle.BackgroundTransparency = 1
    jumpTitle.Font = Enum.Font.GothamBold
    jumpTitle.TextSize = 20
    jumpTitle.TextColor3 = COLORS.white
    jumpTitle.Text = "Jump Hack - ارتفاع القفز"

    local jumpToggleBtn = Instance.new("TextButton", page)
    jumpToggleBtn.Size = UDim2.new(0.3, 0, 0, 35)
    jumpToggleBtn.Position = UDim2.new(0.5, 10, 0, 395)
    jumpToggleBtn.BackgroundColor3 = COLORS.purple
    jumpToggleBtn.TextColor3 = COLORS.white
    jumpToggleBtn.Font = Enum.Font.GothamBold
    jumpToggleBtn.TextSize = 18
    jumpToggleBtn.Text = "تفعيل Jump"
    addUICorner(jumpToggleBtn, 8)

    local jumpPowerLabel = Instance.new("TextLabel", page)
    jumpPowerLabel.Size = UDim2.new(0.3, 0, 0, 25)
    jumpPowerLabel.Position = UDim2.new(0, startX, 0, 430)
    jumpPowerLabel.BackgroundTransparency = 1
    jumpPowerLabel.Font = Enum.Font.GothamBold
    jumpPowerLabel.TextSize = 16
    jumpPowerLabel.TextColor3 = COLORS.white
    jumpPowerLabel.Text = "قوة القفز:"

    local jumpPowerBox = Instance.new("TextBox", page)
    jumpPowerBox.Size = UDim2.new(0.15, 0, 0, 25)
    jumpPowerBox.Position = UDim2.new(0.3, 10, 0, 430)
    jumpPowerBox.PlaceholderText = "100"
    jumpPowerBox.Text = tostring(hackSettings.jump.power)
    jumpPowerBox.Font = Enum.Font.GothamBold
    jumpPowerBox.TextSize = 14
    jumpPowerBox.TextColor3 = COLORS.white
    jumpPowerBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(jumpPowerBox, 6)

    -- وظائف Bang
    local function getPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    local function setNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    local function modifyCameraForBang(targetHRP)
        local cam = workspace.CurrentCamera
        if cam then
            cam.CameraSubject = targetHRP.Parent:FindFirstChildOfClass("Humanoid") or targetHRP
            cam.CameraType = Enum.CameraType.Custom
        end
    end

    local bangTime = 0
    local function bangFollow(dt)
        if not hackSettings.bang.active or not hackSettings.bang.target then return end
        local targetHRP = hackSettings.bang.target.Character and hackSettings.bang.target.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        localLookVector = targetHRP.CFrame.LookVector
        bangTime = bangTime + dt

        local oscillation = math.sin(bangTime * hackSettings.bang.oscillationFrequency * math.pi * 2) * hackSettings.bang.oscillationAmplitude
        local basePos = targetHRP.Position - localLookVector * hackSettings.bang.baseFollowDistance
        local desiredPos = basePos + localLookVector * oscillation

        -- منع تجاوز الهدف
        local vecToDesired = desiredPos - targetHRP.Position
        if vecToDesired:Dot(localLookVector) > 0 then
            desiredPos = basePos
        end

        localHRP.CFrame = CFrame.new(desiredPos, targetHRP.Position)
    end

    local function startBang(targetName)
        local target = getPlayerByName(targetName)
        if not target then
            notify("اللاعب غير موجود: " .. targetName)
            return false
        end
        hackSettings.bang.target = target
        hackSettings.bang.active = true
        setNoclip(true)
        modifyCameraForBang(target.Character:FindFirstChild("HumanoidRootPart"))
        notify("Bang مفعل على: " .. target.Name)
        return true
    end

    local function stopBang()
        hackSettings.bang.active = false
        hackSettings.bang.target = nil
        setNoclip(false)
        workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or workspace.CurrentCamera.CameraSubject
        notify("تم إيقاف Bang")
    end

    bangStartBtn.MouseButton1Click:Connect(function()
        local targetName = targetBox.Text
        if targetName == "" then
            notify("يرجى إدخال اسم اللاعب الهدف")
            return
        end
        -- تحديث إعدادات السرعة والقيم
        local freq = tonumber(speedBox.Text)
        local amp = tonumber(amplitudeBox.Text)
        local baseDist = tonumber(baseDistBox.Text)
        if freq and freq > 0 then
            hackSettings.bang.oscillationFrequency = freq
        else
            speedBox.Text = tostring(hackSettings.bang.oscillationFrequency)
        end
        if amp and amp >= 0 then
            hackSettings.bang.oscillationAmplitude = amp
        else
            amplitudeBox.Text = tostring(hackSettings.bang.oscillationAmplitude)
        end
        if baseDist and baseDist >= 0 then
            hackSettings.bang.baseFollowDistance = baseDist
        else
            baseDistBox.Text = tostring(hackSettings.bang.baseFollowDistance)
        end
        startBang(targetName)
    end)

    bangStopBtn.MouseButton1Click:Connect(stopBang)

    -- --- Noclip toggle ---
    local noclipEnabled = false
    noclipToggleBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        hackSettings.noclip.enabled = noclipEnabled
        setNoclip(noclipEnabled)
        noclipToggleBtn.Text = noclipEnabled and "إيقاف Noclip" or "تفعيل Noclip"
        notify(noclipEnabled and "تم تفعيل Noclip" or "تم إيقاف Noclip")
    end)

    -- --- Fly hack ---
    local flyEnabled = false
    local flySpeed = hackSettings.fly.speed
    local flying = false
    local flyBodyVelocity = nil

    flyToggleBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        hackSettings.fly.enabled = flyEnabled
        flyToggleBtn.Text = flyEnabled and "إيقاف Fly" or "تفعيل Fly"
        notify(flyEnabled and "تم تفعيل Fly" or "تم إيقاف Fly")

        if flyEnabled then
            local character = LocalPlayer.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    humanoid.PlatformStand = true
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
                    flyBodyVelocity.Parent = hrp
                    flying = true
                end
            end
        else
            if flying and flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
                flying = false
            end
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end)

    flySpeedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(flySpeedBox.Text)
            if val and val > 0 then
                flySpeed = val
                hackSettings.fly.speed = flySpeed
                notify("تم تحديث سرعة الطيران: " .. flySpeed)
            else
                flySpeedBox.Text = tostring(flySpeed)
            end
        end
    end)

    -- --- Speed Hack ---
    local speedEnabled = false
    local speedMult = hackSettings.speed.multiplier
    speedToggleBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        hackSettings.speed.enabled = speedEnabled
        speedToggleBtn.Text = speedEnabled and "إيقاف Speed" or "تفعيل Speed"
        notify(speedEnabled and "تم تفعيل Speed" or "تم إيقاف Speed")

        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = 16 * speedMult
            else
                humanoid.WalkSpeed = 16
            end
        end
    end)

    speedMultBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedMultBox.Text)
            if val and val > 0 then
                speedMult = val
                hackSettings.speed.multiplier = speedMult
                notify("تم تحديث مضاعف السرعة: " .. speedMult)
                if speedEnabled then
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 16 * speedMult
                    end
                end
            else
                speedMultBox.Text = tostring(speedMult)
            end
        end
    end)

    -- --- Jump Hack ---
    local jumpEnabled = false
    local jumpPower = hackSettings.jump.power
    jumpToggleBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        hackSettings.jump.enabled = jumpEnabled
        jumpToggleBtn.Text = jumpEnabled and "إيقاف Jump" or "تفعيل Jump"
        notify(jumpEnabled and "تم تفعيل Jump" or "تم إيقاف Jump")

        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if jumpEnabled then
                humanoid.JumpPower = jumpPower
            else
                humanoid.JumpPower = 50
            end
        end
    end)

    jumpPowerBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(jumpPowerBox.Text)
            if val and val > 0 then
                jumpPower = val
                hackSettings.jump.power = jumpPower
                notify("تم تحديث قوة القفز: " .. jumpPower)
                if jumpEnabled then
                    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.JumpPower = jumpPower
                    end
                end
            else
                jumpPowerBox.Text = tostring(jumpPower)
            end
        end
    end)

    -- تحديث متحرك Fly
    RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 5, function(dt)
        if flyEnabled and flying and flyBodyVelocity then
            local camera = workspace.CurrentCamera
            local character = LocalPlayer.Character
            if not character then return end
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local moveDirection = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0,1,0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDirection = moveDirection - Vector3.new(0,1,0)
            end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end
            flyBodyVelocity.Velocity = moveDirection * flySpeed
        end
    end)

    -- تحديث Bang Follow
    RS:BindToRenderStep("BangFollow", Enum.RenderPriority.Character.Value + 4, function(dt)
        if hackSettings.bang.active then
            bangFollow(dt)
        end
    end)
end

-- =================== صفحة معلومات اللاعب ===================
do
    local page = infoPage

    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 26
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "معلومات اللاعب"

    local playerImage = Instance.new("ImageLabel", page)
    playerImage.Size = UDim2.new(0, 140, 0, 140)
    playerImage.Position = UDim2.new(0, 20, 0, 55)
    playerImage.BackgroundColor3 = COLORS.darkBackground
    playerImage.BorderSizePixel = 0
    addUICorner(playerImage, 12)
    playerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    local playerNameLabel = Instance.new("TextLabel", page)
    playerNameLabel.Size = UDim2.new(0, 250, 0, 35)
    playerNameLabel.Position = UDim2.new(0, 180, 0, 70)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextSize = 24
    playerNameLabel.TextColor3 = COLORS.white
    playerNameLabel.Text = "الاسم: " .. LocalPlayer.Name

    local playerUserIdLabel = Instance.new("TextLabel", page)
    playerUserIdLabel.Size = UDim2.new(0, 250, 0, 30)
    playerUserIdLabel.Position = UDim2.new(0, 180, 0, 110)
    playerUserIdLabel.BackgroundTransparency = 1
    playerUserIdLabel.Font = Enum.Font.GothamBold
    playerUserIdLabel.TextSize = 18
    playerUserIdLabel.TextColor3 = COLORS.white
    playerUserIdLabel.Text = "UserID: " .. tostring(LocalPlayer.UserId)

    local playerAccountAgeLabel = Instance.new("TextLabel", page)
    playerAccountAgeLabel.Size = UDim2.new(0, 250, 0, 30)
    playerAccountAgeLabel.Position = UDim2.new(0, 180, 0, 145)
    playerAccountAgeLabel.BackgroundTransparency = 1
    playerAccountAgeLabel.Font = Enum.Font.GothamBold
    playerAccountAgeLabel.TextSize = 18
    playerAccountAgeLabel.TextColor3 = COLORS.white
    playerAccountAgeLabel.Text = "عمر الحساب: " .. tostring(LocalPlayer.AccountAge) .. " يوم"

    -- تحديث صورة اللاعب كل 60 ثانية
    coroutine.wrap(function()
        while true do
            wait(60)
            playerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
        end
    end)()
end

-- ========== ESP System ===========
do
    local espPage = Instance.new("Frame", pagesContainer)
    espPage.Size = UDim2.new(1, 0, 1, 0)
    espPage.BackgroundTransparency = 1
    espPage.Visible = false
    pages["ESP"] = espPage

    local espTitle = Instance.new("TextLabel", espPage)
    espTitle.Size = UDim2.new(1, -40, 0, 40)
    espTitle.Position = UDim2.new(0, 20, 0, 10)
    espTitle.BackgroundTransparency = 1
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 24
    espTitle.TextColor3 = COLORS.white
    espTitle.Text = "نظام ESP"

    local espToggleBtn = Instance.new("TextButton", espPage)
    espToggleBtn.Size = UDim2.new(0.4, 0, 0, 40)
    espToggleBtn.Position = UDim2.new(0, 20, 0, 60)
    espToggleBtn.BackgroundColor3 = COLORS.purple
    espToggleBtn.TextColor3 = COLORS.white
    espToggleBtn.Font = Enum.Font.GothamBold
    espToggleBtn.TextSize = 20
    espToggleBtn.Text = "تفعيل ESP"
    addUICorner(espToggleBtn, 10)

    local colorLabel = Instance.new("TextLabel", espPage)
    colorLabel.Size = UDim2.new(0.4, 0, 0, 30)
    colorLabel.Position = UDim2.new(0, 20, 0, 110)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel.TextSize = 18
    colorLabel.TextColor3 = COLORS.white
    colorLabel.Text = "اختر لون ESP:"

    local colorDropdown = Instance.new("TextBox", espPage)
    colorDropdown.Size = UDim2.new(0.4, 0, 0, 30)
    colorDropdown.Position = UDim2.new(0, 150, 0, 110)
    colorDropdown.PlaceholderText = "purple / red / green / white"
    colorDropdown.Font = Enum.Font.GothamBold
    colorDropdown.TextSize = 16
    colorDropdown.TextColor3 = COLORS.white
    colorDropdown.BackgroundColor3 = COLORS.darkBackground
    addUICorner(colorDropdown, 8)

    local function createESPBox(player)
        local box = Instance.new("BillboardGui")
        box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        box.Size = UDim2.new(0, 100, 0, 40)
        box.AlwaysOnTop = true
        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = hackSettings.esp.color
        frame.BorderSizePixel = 1
        frame.BorderColor3 = COLORS.white
        addUICorner(frame, 8)
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Text = player.Name
        return box
    end

    local function updateESPColor(colorName)
        local c = COLORS[colorName:lower()] or COLORS.purple
        hackSettings.esp.color = c
        for _, box in pairs(hackSettings.esp.boxes) do
            if box and box.Frame then
                box.Frame.BackgroundColor3 = c
            end
        end
    end

    local function removeESPBoxes()
        for _, box in pairs(hackSettings.esp.boxes) do
            if box then box:Destroy() end
        end
        hackSettings.esp.boxes = {}
    end

    espToggleBtn.MouseButton1Click:Connect(function()
        hackSettings.esp.enabled = not hackSettings.esp.enabled
        if hackSettings.esp.enabled then
            espToggleBtn.Text = "إيقاف ESP"
            notify("تم تفعيل ESP")
            -- إنشاء الصناديق لكل اللاعبين
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local box = createESPBox(plr)
                    box.Parent = workspace.CurrentCamera
                    box.Frame = box:FindFirstChildOfClass("Frame")
                    table.insert(hackSettings.esp.boxes, box)
                end
            end
        else
            espToggleBtn.Text = "تفعيل ESP"
            notify("تم إيقاف ESP")
            removeESPBoxes()
        end
    end)

    colorDropdown.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            updateESPColor(colorDropdown.Text)
        end
    end)
end

-- إضافة تبويبة جديدة لصفحة الهاكات
do
    local hacksPage = Instance.new("Frame", pagesContainer)
    hacksPage.Size = UDim2.new(1, 0, 1, 0)
    hacksPage.BackgroundTransparency = 1
    hacksPage.Visible = false
    pages["Hacks"] = hacksPage

    local hacksTitle = Instance.new("TextLabel", hacksPage)
    hacksTitle.Size = UDim2.new(1, -40, 0, 40)
    hacksTitle.Position = UDim2.new(0, 20, 0, 10)
    hacksTitle.BackgroundTransparency = 1
    hacksTitle.Font = Enum.Font.GothamBold
    hacksTitle.TextSize = 26
    hacksTitle.TextColor3 = COLORS.white
    hacksTitle.Text = "الهاكات - Hacks"

    -- قائمة هاكات
    local startY = 60
    local paddingY = 45

    -- Noclip toggle
    local noclipBtn = Instance.new("TextButton", hacksPage)
    noclipBtn.Size = UDim2.new(0.4, 0, 0, 40)
    noclipBtn.Position = UDim2.new(0, 20, 0, startY)
    noclipBtn.BackgroundColor3 = COLORS.purple
    noclipBtn.TextColor3 = COLORS.white
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 20
    noclipBtn.Text = "تفعيل Noclip"
    addUICorner(noclipBtn, 10)

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        hackSettings.noclip.enabled = noclipEnabled
        setNoclip(noclipEnabled)
        noclipBtn.Text = noclipEnabled and "إيقاف Noclip" or "تفعيل Noclip"
        notify(noclipEnabled and "تم تفعيل Noclip" or "تم إيقاف Noclip")
    end)

    -- Fly toggle
    local flyBtn = Instance.new("TextButton", hacksPage)
    flyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.5, 10, 0, startY)
    flyBtn.BackgroundColor3 = COLORS.purple
    flyBtn.TextColor3 = COLORS.white
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 20
    flyBtn.Text = "تفعيل Fly"
    addUICorner(flyBtn, 10)

    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        hackSettings.fly.enabled = flyEnabled
        flyBtn.Text = flyEnabled and "إيقاف Fly" or "تفعيل Fly"
        notify(flyEnabled and "تم تفعيل Fly" or "تم إيقاف Fly")

        if flyEnabled then
            local character = LocalPlayer.Character
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    humanoid.PlatformStand = true
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
                    flyBodyVelocity.Parent = hrp
                    flying = true
                end
            end
        else
            if flying and flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
                flying = false
            end
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end)

    -- Speed toggle
    local speedBtn = Instance.new("TextButton", hacksPage)
    speedBtn.Size = UDim2.new(0.4, 0, 0, 40)
    speedBtn.Position = UDim2.new(0, 20, 0, startY + paddingY)
    speedBtn.BackgroundColor3 = COLORS.purple
    speedBtn.TextColor3 = COLORS.white
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.TextSize = 20
    speedBtn.Text = "تفعيل Speed"
    addUICorner(speedBtn, 10)

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        hackSettings.speed.enabled = speedEnabled
        speedBtn.Text = speedEnabled and "إيقاف Speed" or "تفعيل Speed"
        notify(speedEnabled and "تم تفعيل Speed" or "تم إيقاف Speed")

        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = 16 * speedMult
            else
                humanoid.WalkSpeed = 16
            end
        end
    end)

    -- Jump toggle
    local jumpBtn = Instance.new("TextButton", hacksPage)
    jumpBtn.Size = UDim2.new(0.4, 0, 0, 40)
    jumpBtn.Position = UDim2.new(0.5, 10, 0, startY + paddingY)
    jumpBtn.BackgroundColor3 = COLORS.purple
    jumpBtn.TextColor3 = COLORS.white
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 20
    jumpBtn.Text = "تفعيل Jump"
    addUICorner(jumpBtn, 10)

    jumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        hackSettings.jump.enabled = jumpEnabled
        jumpBtn.Text = jumpEnabled and "إيقاف Jump" or "تفعيل Jump"
        notify(jumpEnabled and "تم تفعيل Jump" or "تم إيقاف Jump")

        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if jumpEnabled then
                humanoid.JumpPower = jumpPower
            else
                humanoid.JumpPower = 50
            end
        end
    end)
end

-- إضافة إشعارات عند بدء وقف Bang
local function notifyBang(status, targetName)
    local msg = status and ("Bang مفعل على: " .. targetName) or "تم إيقاف Bang"
    notify(msg)
end

-- تعديل دالة بدء Bang لإظهار إشعارات أفضل وتحريك الكاميرا
local function startBangWithNotif(targetName)
    local target = getPlayerByName(targetName)
    if not target then
        notify("اللاعب غير موجود: " .. targetName)
        return false
    end
    hackSettings.bang.target = target
    hackSettings.bang.active = true
    setNoclip(true)
    modifyCameraForBang(target.Character:FindFirstChild("HumanoidRootPart"))
    notifyBang(true, target.Name)
    return true
end

bangStartBtn.MouseButton1Click:Connect(function()
    local targetName = targetBox.Text
    if targetName == "" then
        notify("يرجى إدخال اسم اللاعب الهدف")
        return
    end
    -- تحديث إعدادات Bang من الواجهات
    local freq = tonumber(speedBox.Text)
    local amp = tonumber(amplitudeBox.Text)
    local baseDist = tonumber(baseDistBox.Text)
    if freq and freq > 0 then
        hackSettings.bang.oscillationFrequency = freq
    else
        speedBox.Text = tostring(hackSettings.bang.oscillationFrequency)
    end
    if amp and amp >= 0 then
        hackSettings.bang.oscillationAmplitude = amp
    else
        amplitudeBox.Text = tostring(hackSettings.bang.oscillationAmplitude)
    end
    if baseDist and baseDist >= 0 then
        hackSettings.bang.baseFollowDistance = baseDist
    else
        baseDistBox.Text = tostring(hackSettings.bang.baseFollowDistance)
    end
    startBangWithNotif(targetName)
end)

bangStopBtn.MouseButton1Click:Connect(function()
    hackSettings.bang.active = false
    hackSettings.bang.target = nil
    setNoclip(false)
    workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or workspace.CurrentCamera.CameraSubject
    notifyBang(false)
end)
