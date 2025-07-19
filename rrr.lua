-- Elite Hack System 2025 - نسخة كاملة مع Settings, ESP, صوت وتنبيهات بصرية
-- Author: ALm6eri
-- Language: عربي سعودي

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- الألوان المستخدمة
local COLORS = {
    background = Color3.fromRGB(30, 30, 30),
    darkBackground = Color3.fromRGB(15, 15, 15),
    orange = Color3.fromRGB(255, 165, 0),
    white = Color3.fromRGB(255, 255, 255),
    green = Color3.fromRGB(0, 200, 0),
    red = Color3.fromRGB(200, 0, 0),
    blue = Color3.fromRGB(0, 170, 255),
    gray = Color3.fromRGB(90, 90, 90),
}

-- إنشاء عنصر UI Corner لتجميل الأزرار والواجهات
local function addUICorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = obj
end

-- إنشاء النافذة الأساسية مع تحريك وتصغير وتكبير
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHackGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.3, -200)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = ScreenGui
addUICorner(mainFrame, 15)

-- شريط العنوان مع اسم الهاك
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = COLORS.darkBackground
titleBar.Parent = mainFrame
addUICorner(titleBar, 15)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Elite Made By ALm6eri"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = COLORS.orange
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- زر الإغلاق
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 1, 0)
closeBtn.Position = UDim2.new(1, -50, 0, 0)
closeBtn.BackgroundColor3 = COLORS.red
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 28
closeBtn.TextColor3 = COLORS.white
addUICorner(closeBtn, 12)
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- إطار لتصغير وتكبير النافذة (مربع صغير أسفل يمين)
local resizeHandle = Instance.new("Frame")
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -25, 1, -25)
resizeHandle.BackgroundColor3 = COLORS.orange
resizeHandle.Parent = mainFrame
resizeHandle.Cursor = "SizeNWSE"
addUICorner(resizeHandle, 5)

-- متغيرات التحكم في التكبير/التصغير
local resizing = false
local dragStartSize
local dragStartMouse

resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        dragStartSize = mainFrame.Size
        dragStartMouse = input.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

RS.RenderStepped:Connect(function()
    if resizing then
        local mousePos = UIS:GetMouseLocation()
        local delta = mousePos - dragStartMouse
        local newWidth = math.clamp(dragStartSize.X.Offset + delta.X, 300, 800)
        local newHeight = math.clamp(dragStartSize.Y.Offset + delta.Y, 250, 600)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- تبويبات رئيسية
local tabs = {
    "بانغ", "الحركة", "طيران & نو كليب", "معلومات اللاعب", "الإعدادات", "ESP"
}

local tabButtons = {}
local pages = {}

-- إطار أزرار التبويب
local tabsFrame = Instance.new("Frame")
tabsFrame.Size = UDim2.new(1, 0, 0, 40)
tabsFrame.Position = UDim2.new(0, 0, 0, 40)
tabsFrame.BackgroundTransparency = 1
tabsFrame.Parent = mainFrame

local function setActivePage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
        tabButtons[i].BackgroundColor3 = (i == index) and COLORS.orange or COLORS.darkBackground
        tabButtons[i].TextColor3 = (i == index) and COLORS.background or COLORS.white
    end
end

-- إنشاء أزرار التبويب
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, (i-1) * 80, 0, 0)
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 8)
    btn.Parent = tabsFrame
    tabButtons[i] = btn

    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
        playToggleSound()
    end)
end

-- أصوات التنبيه (تفعيل/تعطيل)
local toggleSound = Instance.new("Sound")
toggleSound.SoundId = "rbxassetid://9118824695" -- صوت بسيط للتبديل (يمكن تغييره)
toggleSound.Volume = 0.4
toggleSound.Parent = SoundService

local function playToggleSound()
    toggleSound:Play()
end

-- دالة الإشعار (نص + صوت)
local function createNotification(text, duration)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 45)
    notif.Position = UDim2.new(0.5, -150, 0, 60)
    notif.BackgroundColor3 = COLORS.orange
    notif.TextColor3 = COLORS.white
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Text = text
    notif.BackgroundTransparency = 0.1
    notif.Parent = ScreenGui
    addUICorner(notif, 10)

    local tweenIn = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, 110), BackgroundTransparency = 0})
    tweenIn:Play()

    delay(duration or 3, function()
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, 60), BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notif:Destroy()
    end)
end

----------------------------------------------------------------------------------
-- 1) صفحة بانغ (Bang System مع نود كليب و تحكم الحركة)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    pages[1] = page

    -- نص إرشادي
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "نظام Bang: تابع لاعب مع تذبذب وNoclip"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = COLORS.orange
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    titleLabel.Parent = page

    -- قائمة اختيار اللاعب (Dropdown)
    local targetDropdown = Instance.new("TextBox")
    targetDropdown.Size = UDim2.new(0, 180, 0, 30)
    targetDropdown.Position = UDim2.new(0, 10, 0, 50)
    targetDropdown.PlaceholderText = "اكتب اسم اللاعب الهدف"
    targetDropdown.ClearTextOnFocus = false
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.TextColor3 = COLORS.white
    targetDropdown.BackgroundColor3 = COLORS.background
    addUICorner(targetDropdown, 10)
    targetDropdown.Parent = page

    -- سرعة التذبذب
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 160, 0, 25)
    speedLabel.Position = UDim2.new(0, 210, 0, 50)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.5"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 60, 0, 25)
    speedBox.Position = UDim2.new(0, 320, 0, 50)
    speedBox.Text = "1.5"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.ClearTextOnFocus = false
    addUICorner(speedBox, 8)
    speedBox.Parent = page

    -- المسافة من الهدف
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 140, 0, 25)
    distLabel.Position = UDim2.new(0, 210, 0, 85)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة: 3.5"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 18
    distLabel.TextColor3 = COLORS.white
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = page

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0, 60, 0, 25)
    distBox.Position = UDim2.new(0, 320, 0, 85)
    distBox.Text = "3.5"
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 18
    distBox.TextColor3 = COLORS.white
    distBox.BackgroundColor3 = COLORS.background
    distBox.ClearTextOnFocus = false
    addUICorner(distBox, 8)
    distBox.Parent = page

    -- زر تشغيل Bang
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 150, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 0, 130)
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.Text = "تشغيل Bang"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 20
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 12)
    startBtn.Parent = page

    -- زر إيقاف Bang
    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 150, 0, 40)
    stopBtn.Position = UDim2.new(0, 180, 0, 130)
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.Text = "إيقاف Bang"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 20
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 12)
    stopBtn.Parent = page

    -- متغيرات Bang
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_FREQUENCY = 1.5
    local OSCILLATION_AMPLITUDE = 1
    local BASE_FOLLOW_DISTANCE = 3.5

    local moveInput = {
        forward = false,
        backward = false,
    }

    -- دالة تفعيل/تعطيل Noclip
    local function SetNoclip(enabled)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- دالة البحث عن لاعب باسم
    local function GetPlayerByName(name)
        name = name:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) then
                return plr
            end
        end
        return nil
    end

    -- دوال تحديث السرعة والمسافة
    local function UpdateSpeed()
        local val = tonumber(speedBox.Text)
        if val and val > 0 and val <= 10 then
            OSCILLATION_FREQUENCY = val
            speedLabel.Text = "سرعة التذبذب: " .. tostring(val)
        else
            speedBox.Text = tostring(OSCILLATION_FREQUENCY)
            createNotification("الرجاء إدخال رقم بين 0.1 و 10 للسرعة", 3)
        end
    end

    local function UpdateDistance()
        local val = tonumber(distBox.Text)
        if val and val >= 1 and val <= 20 then
            BASE_FOLLOW_DISTANCE = val
            distLabel.Text = "المسافة: " .. tostring(val)
        else
            distBox.Text = tostring(BASE_FOLLOW_DISTANCE)
            createNotification("الرجاء إدخال رقم بين 1 و 20 للمسافة", 3)
        end
    end

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then UpdateSpeed() end
    end)

    distBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then UpdateDistance() end
    end)

    -- التحكم بالحركة (W, S)
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if BangActive then
            if input.KeyCode == Enum.KeyCode.W then
                moveInput.forward = true
            elseif input.KeyCode == Enum.KeyCode.S then
                moveInput.backward = true
            end
        end
    end)

    UIS.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if BangActive then
            if input.KeyCode == Enum.KeyCode.W then
                moveInput.forward = false
            elseif input.KeyCode == Enum.KeyCode.S then
                moveInput.backward = false
            end
        end
    end)

    -- دالة متابعة الهدف مع تذبذب وحركة محدودة
    local function FollowTarget()
        if not BangActive or not TargetPlayer then return end
        if not TargetPlayer.Character then return end
        if not LocalPlayer.Character then return end

        local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local lookVector = targetHRP.CFrame.LookVector
        local posBase = targetHRP.Position - lookVector * BASE_FOLLOW_DISTANCE

        local oscillation = math.sin(tick() * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE
        local desiredPos = posBase + Vector3.new(0, oscillation, 0)

        local moveDirection = Vector3.new(0, 0, 0)
        if moveInput.forward then
            moveDirection = moveDirection + lookVector
        end
        if moveInput.backward then
            moveDirection = moveDirection - lookVector
        end

        local moveSpeed = 7
        local vectorToPlayer = localHRP.Position:Lerp(desiredPos + moveDirection * 3, 0.15)
        localHRP.CFrame = CFrame.new(vectorToPlayer, targetHRP.Position)

        -- نو كليب مفعّل تلقائياً أثناء التتبع
        SetNoclip(true)
    end

    -- تشغيل/إيقاف Bang
    startBtn.MouseButton1Click:Connect(function()
        local targetName = targetDropdown.Text
        local target = GetPlayerByName(targetName)
        if not target then
            createNotification("لم أجد اللاعب: " .. targetName, 3)
            return
        end
        TargetPlayer = target
        OSCILLATION_FREQUENCY = tonumber(speedBox.Text) or 1.5
        BASE_FOLLOW_DISTANCE = tonumber(distBox.Text) or 3.5
        BangActive = true
        createNotification("تم تفعيل نظام Bang على " .. target.Name, 3)
        playToggleSound()
    end)

    stopBtn.MouseButton1Click:Connect(function()
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        createNotification("تم إيقاف نظام Bang", 3)
        playToggleSound()
    end)

    -- تحديث في كل إطار
    RS.RenderStepped:Connect(function()
        if BangActive then
            FollowTarget()
        end
    end)
end

----------------------------------------------------------------------------------
-- 2) صفحة الحركة (Speed + Jump)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة المشي: 16"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = COLORS.orange
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 120, 0, 30)
    speedBox.Position = UDim2.new(0, 20, 0, 60)
    speedBox.Text = "16"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 20
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.background
    addUICorner(speedBox, 10)
    speedBox.Parent = page

    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 200, 0, 30)
    jumpLabel.Position = UDim2.new(0, 20, 0, 100)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "قوة القفز: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 20
    jumpLabel.TextColor3 = COLORS.orange
    jumpLabel.Parent = page

    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 120, 0, 30)
    jumpBox.Position = UDim2.new(0, 20, 0, 140)
    jumpBox.Text = "50"
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 20
    jumpBox.TextColor3 = COLORS.white
    jumpBox.BackgroundColor3 = COLORS.background
    addUICorner(jumpBox, 10)
    jumpBox.Parent = page

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 150, 0, 45)
    applyBtn.Position = UDim2.new(0, 20, 0, 190)
    applyBtn.BackgroundColor3 = COLORS.green
    applyBtn.Text = "تطبيق التغييرات"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 22
    applyBtn.TextColor3 = COLORS.white
    addUICorner(applyBtn, 15)
    applyBtn.Parent = page

    applyBtn.MouseButton1Click:Connect(function()
        local speedVal = tonumber(speedBox.Text)
        local jumpVal = tonumber(jumpBox.Text)
        local char = LocalPlayer.Character
        if not char then
            createNotification("لم يتم العثور على الشخصية!", 3)
            return
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            createNotification("لا يوجد Humanoid!", 3)
            return
        end
        if speedVal and speedVal > 0 and speedVal <= 100 then
            humanoid.WalkSpeed = speedVal
        else
            createNotification("الرجاء إدخال رقم صحيح لسرعة المشي (1-100)", 3)
        end
        if jumpVal and jumpVal > 0 and jumpVal <= 200 then
            humanoid.JumpPower = jumpVal
        else
            createNotification("الرجاء إدخال رقم صحيح لقوة القفز (1-200)", 3)
        end
        createNotification("تم تطبيق التغييرات بنجاح!", 3)
        playToggleSound()
    end)
end

----------------------------------------------------------------------------------
-- 3) صفحة طيران + نو كليب (Flight + Noclip)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    local flightActive = false
    local noclipActive = false
    local bodyVelocity = nil

    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0, 180, 0, 45)
    flyBtn.Position = UDim2.new(0, 20, 0, 20)
    flyBtn.BackgroundColor3 = COLORS.green
    flyBtn.Text = "تشغيل الطيران"
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 22
    flyBtn.TextColor3 = COLORS.white
    addUICorner(flyBtn, 12)
    flyBtn.Parent = page

    local flyStopBtn = Instance.new("TextButton")
    flyStopBtn.Size = UDim2.new(0, 180, 0, 45)
    flyStopBtn.Position = UDim2.new(0, 220, 0, 20)
    flyStopBtn.BackgroundColor3 = COLORS.red
    flyStopBtn.Text = "إيقاف الطيران"
    flyStopBtn.Font = Enum.Font.GothamBold
    flyStopBtn.TextSize = 22
    flyStopBtn.TextColor3 = COLORS.white
    addUICorner(flyStopBtn, 12)
    flyStopBtn.Parent = page

    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 180, 0, 45)
    noclipBtn.Position = UDim2.new(0, 20, 0, 90)
    noclipBtn.BackgroundColor3 = COLORS.green
    noclipBtn.Text = "تشغيل نو كليب"
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 22
    noclipBtn.TextColor3 = COLORS.white
    addUICorner(noclipBtn, 12)
    noclipBtn.Parent = page

    local noclipStopBtn = Instance.new("TextButton")
    noclipStopBtn.Size = UDim2.new(0, 180, 0, 45)
    noclipStopBtn.Position = UDim2.new(0, 220, 0, 90)
    noclipStopBtn.BackgroundColor3 = COLORS.red
    noclipStopBtn.Text = "إيقاف نو كليب"
    noclipStopBtn.Font = Enum.Font.GothamBold
    noclipStopBtn.TextSize = 22
    noclipStopBtn.TextColor3 = COLORS.white
    addUICorner(noclipStopBtn, 12)
    noclipStopBtn.Parent = page

    local humanoid = nil
    local rootPart = nil

    local flySpeed = 50
    local flying = false

    local function enableFlight()
        local char = LocalPlayer.Character
        if not char then createNotification("ما في شخصية لتفعيل الطيران!", 3) return end
        humanoid = char:FindFirstChildOfClass("Humanoid")
        rootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then
            createNotification("مكونات الشخصية ناقصة للطيران!", 3)
            return
        end
        if flying then
            createNotification("الطيران مفعّل من قبل!", 3)
            return
        end
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = rootPart

        -- تحكم الطيران بالأسهم أو WASD
        RS.RenderStepped:Connect(function()
            if flying and bodyVelocity then
                local moveDir = Vector3.new(0,0,0)
                local camCF = workspace.CurrentCamera.CFrame
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

                if moveDir.Magnitude > 0 then
                    bodyVelocity.Velocity = moveDir.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0,0,0)
                end
            end
        end)

        createNotification("تم تفعيل الطيران!", 3)
        playToggleSound()
    end

    local function disableFlight()
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        createNotification("تم إيقاف الطيران!", 3)
        playToggleSound()
    end

    local function enableNoclip()
        if noclipActive then
            createNotification("نو كليب مفعّل من قبل", 3)
            return
        end
        noclipActive = true
        local char = LocalPlayer.Character
        if not char then createNotification("لا توجد شخصية لتفعيل نو كليب!", 3) return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        createNotification("تم تفعيل نو كليب!", 3)
        playToggleSound()
    end

    local function disableNoclip()
        if not noclipActive then
            createNotification("نو كليب مو شغال", 3)
            return
        end
        noclipActive = false
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        createNotification("تم إيقاف نو كليب!", 3)
        playToggleSound()
    end

    flyBtn.MouseButton1Click:Connect(enableFlight)
    flyStopBtn.MouseButton1Click:Connect(disableFlight)
    noclipBtn.MouseButton1Click:Connect(enableNoclip)
    noclipStopBtn.MouseButton1Click:Connect(disableNoclip)
end

----------------------------------------------------------------------------------
-- 4) صفحة معلومات اللاعب مع صورة البروفايل
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[4] = page

    -- صورة البروفايل
    local profileImage = Instance.new("ImageLabel")
    profileImage.Size = UDim2.new(0, 140, 0, 140)
    profileImage.Position = UDim2.new(0.5, -70, 0, 20)
    profileImage.BackgroundColor3 = COLORS.background
    profileImage.BorderSizePixel = 0
    profileImage.Parent = page
    addUICorner(profileImage, 70)
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    -- اسم اللاعب
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 170)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "الاسم: " .. LocalPlayer.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 24
    nameLabel.TextColor3 = COLORS.white
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = page

    -- معرف المستخدم
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(1, 0, 0, 30)
    idLabel.Position = UDim2.new(0, 0, 0, 210)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "معرف المستخدم: " .. LocalPlayer.UserId
    idLabel.Font = Enum.Font.GothamBold
    idLabel.TextSize = 18
    idLabel.TextColor3 = COLORS.white
    idLabel.TextXAlignment = Enum.TextXAlignment.Center
    idLabel.Parent = page

    -- نص ترحيبي
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, -40, 0, 70)
    welcomeLabel.Position = UDim2.new(0, 20, 0, 250)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = [[
مرحباً بك في نظام Elite Made By ALm6eri  
تقدر تتحكم بكل خصائص الهك بسهولة وأمان.  
تأكد من استخدام الأدوات بعقلانية وتجنب كشف هويتك.  
]]
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 20
    welcomeLabel.TextColor3 = COLORS.orange
    welcomeLabel.TextWrapped = true
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.Parent = page
end

----------------------------------------------------------------------------------
-- 5) صفحة الإعدادات (Settings)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[5] = page

    -- عنوان الإعدادات
    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Size = UDim2.new(1, -20, 0, 40)
    settingsLabel.Position = UDim2.new(0, 10, 0, 10)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Text = "الإعدادات العامة"
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 26
    settingsLabel.TextColor3 = COLORS.orange
    settingsLabel.TextXAlignment = Enum.TextXAlignment.Center
    settingsLabel.Parent = page

    -- خيار التنبيهات الصوتية
    local soundNotifLabel = Instance.new("TextLabel")
    soundNotifLabel.Size = UDim2.new(0, 250, 0, 30)
    soundNotifLabel.Position = UDim2.new(0, 20, 0, 70)
    soundNotifLabel.BackgroundTransparency = 1
    soundNotifLabel.Text = "تنبيهات صوتية عند تفعيل/تعطيل الخصائص"
    soundNotifLabel.Font = Enum.Font.GothamBold
    soundNotifLabel.TextSize = 18
    soundNotifLabel.TextColor3 = COLORS.white
    soundNotifLabel.TextXAlignment = Enum.TextXAlignment.Left
    soundNotifLabel.Parent = page

    local soundToggle = Instance.new("TextButton")
    soundToggle.Size = UDim2.new(0, 100, 0, 35)
    soundToggle.Position = UDim2.new(0, 280, 0, 70)
    soundToggle.BackgroundColor3 = COLORS.green
    soundToggle.Text = "مفعّل"
    soundToggle.Font = Enum.Font.GothamBold
    soundToggle.TextSize = 18
    soundToggle.TextColor3 = COLORS.white
    addUICorner(soundToggle, 12)
    soundToggle.Parent = page

    local soundEnabled = true

    soundToggle.MouseButton1Click:Connect(function()
        soundEnabled = not soundEnabled
        soundToggle.Text = soundEnabled and "مفعّل" or "معطل"
        soundToggle.BackgroundColor3 = soundEnabled and COLORS.green or COLORS.red
        createNotification("تم " .. (soundEnabled and "تفعيل" or "تعطيل") .. " التنبيهات الصوتية", 3)
        if soundEnabled then
            playToggleSound()
        end
    end)

    -- خيار اللون للواجهة (ثيم داكن/فاتح)
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Size = UDim2.new(0, 250, 0, 30)
    themeLabel.Position = UDim2.new(0, 20, 0, 120)
    themeLabel.BackgroundTransparency = 1
    themeLabel.Text = "اختيار ثيم الواجهة"
    themeLabel.Font = Enum.Font.GothamBold
    themeLabel.TextSize = 18
    themeLabel.TextColor3 = COLORS.white
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = page

    local themeToggle = Instance.new("TextButton")
    themeToggle.Size = UDim2.new(0, 100, 0, 35)
    themeToggle.Position = UDim2.new(0, 280, 0, 120)
    themeToggle.BackgroundColor3 = COLORS.orange
    themeToggle.Text = "داكن"
    themeToggle.Font = Enum.Font.GothamBold
    themeToggle.TextSize = 18
    themeToggle.TextColor3 = COLORS.white
    addUICorner(themeToggle, 12)
    themeToggle.Parent = page

    local darkTheme = true

    local function switchTheme()
        if darkTheme then
            -- تفعيل الثيم الفاتح
            mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            titleBar.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextColor3 = Color3.fromRGB(40, 40, 40)
            end
            themeToggle.Text = "فاتح"
        else
            mainFrame.BackgroundColor3 = COLORS.background
            titleBar.BackgroundColor3 = COLORS.darkBackground
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = COLORS.darkBackground
                btn.TextColor3 = COLORS.white
            end
            themeToggle.Text = "داكن"
        end
        darkTheme = not darkTheme
    end

    themeToggle.MouseButton1Click:Connect(function()
        switchTheme()
        createNotification("تم تغيير الثيم", 2)
        playToggleSound()
    end)
end

----------------------------------------------------------------------------------
-- 6) صفحة ESP (رسم إطارات حول اللاعبين)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -85)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[6] = page

    local espActive = false

    local espToggleBtn = Instance.new("TextButton")
    espToggleBtn.Size = UDim2.new(0, 150, 0, 45)
    espToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    espToggleBtn.BackgroundColor3 = COLORS.green
    espToggleBtn.Text = "تفعيل ESP"
    espToggleBtn.Font = Enum.Font.GothamBold
    espToggleBtn.TextSize = 22
    espToggleBtn.TextColor3 = COLORS.white
    addUICorner(espToggleBtn, 12)
    espToggleBtn.Parent = page

    local espStopBtn = Instance.new("TextButton")
    espStopBtn.Size = UDim2.new(0, 150, 0, 45)
    espStopBtn.Position = UDim2.new(0, 180, 0, 20)
    espStopBtn.BackgroundColor3 = COLORS.red
    espStopBtn.Text = "إيقاف ESP"
    espStopBtn.Font = Enum.Font.GothamBold
    espStopBtn.TextSize = 22
    espStopBtn.TextColor3 = COLORS.white
    addUICorner(espStopBtn, 12)
    espStopBtn.Parent = page

    local espBoxes = {}

    local function createBoxForPlayer(player)
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 100, 0, 35)
        box.BackgroundTransparency = 0.5
        box.BackgroundColor3 = COLORS.orange
        box.BorderSizePixel = 2
        box.BorderColor3 = COLORS.white
        box.Visible = false
        box.ZIndex = 10
        box.Parent = ScreenGui
        addUICorner(box, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.Text = player.Name
        label.Parent = box

        return box
    end

    local function updateESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local box = espBoxes[player]
                if not box then
                    box = createBoxForPlayer(player)
                    espBoxes[player] = box
                end

                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        box.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 40)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                else
                    box.Visible = false
                end
            end
        end
    end

    local espConnection

    espToggleBtn.MouseButton1Click:Connect(function()
        if espActive then return end
        espActive = true
        createNotification("تم تفعيل ESP", 3)
        playToggleSound()
        espConnection = RS.RenderStepped:Connect(updateESP)
    end)

    espStopBtn.MouseButton1Click:Connect(function()
        if not espActive then return end
        espActive = false
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for _, box in pairs(espBoxes) do
            box.Visible = false
        end
        createNotification("تم إيقاف ESP", 3)
        playToggleSound()
    end)
end

----------------------------------------------------------------------------------
-- تفعيل تبويب أول عند بداية التشغيل
setActivePage(1)

-- إزالة زر التفعيل بالكيبورد حسب طلبك
-- يمكنك الإضافة فيما بعد لو تبي تحكم خاص

