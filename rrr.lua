-- Elite Made By ALm6eri - نظام Bang + Movement + Flight & Noclip مع صورة بروفايل ومعلومات اللاعب + واجهة قابلة للتكبير والتصغير والتحريك
-- Author: ChatGPT v2 for FNLOXER, Edited by ALm6eri

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- إعداد الألوان للواجهة
local COLORS = {
    background = Color3.fromRGB(25, 25, 30),
    darkBackground = Color3.fromRGB(15, 15, 20),
    purple = Color3.fromRGB(130, 90, 220),
    green = Color3.fromRGB(80, 200, 120),
    red = Color3.fromRGB(220, 50, 50),
    orange = Color3.fromRGB(255, 165, 0),
    white = Color3.new(1,1,1)
}

-- دالة لإنشاء زوايا مدورة
local function addUICorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = inst
end

-- دالة لإنشاء ظل خفيف
local function addShadow(inst)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217" -- صورة ظل خفيف جاهزة
    shadow.ImageColor3 = Color3.new(0,0,0)
    shadow.ImageTransparency = 0.75
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    shadow.Size = UDim2.new(1,10,1,10)
    shadow.Position = UDim2.new(0,-5,0,-5)
    shadow.ZIndex = 0
    shadow.Parent = inst
end

-- إنشاء واجهة المستخدم (ScreenGui)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteMadeByAlm6eri"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = true

-- النافذة الرئيسية للمينيو (Frame)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 420)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -210)
mainFrame.BackgroundColor3 = COLORS.background
addUICorner(mainFrame, 15)
addShadow(mainFrame)
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- المتغيرات الخاصة بتحجيم النافذة
local minSize = Vector2.new(300, 300)
local maxSize = Vector2.new(800, 700)
local resizing = false
local resizeStartPos = Vector2.new()
local resizeStartSize = Vector2.new()

-- منطقة السحب (الحافة السفلى اليمنى للتكبير)
local resizeGrip = Instance.new("Frame")
resizeGrip.Size = UDim2.new(0, 25, 0, 25)
resizeGrip.Position = UDim2.new(1, -25, 1, -25)
resizeGrip.BackgroundColor3 = COLORS.purple
resizeGrip.BorderSizePixel = 0
resizeGrip.AnchorPoint = Vector2.new(0, 0)
addUICorner(resizeGrip, 10)
resizeGrip.Parent = mainFrame
resizeGrip.ZIndex = 5

-- إضافة أيقونة صغيرة للسحب في الزاوية
local gripIcon = Instance.new("ImageLabel")
gripIcon.Size = UDim2.new(1, -10, 1, -10)
gripIcon.Position = UDim2.new(0, 5, 0, 5)
gripIcon.BackgroundTransparency = 1
gripIcon.Image = "rbxassetid://3926307971" -- أيقونة السحب
gripIcon.ImageColor3 = COLORS.white
gripIcon.Parent = resizeGrip

-- التعامل مع سحب التكبير والتصغير
resizeGrip.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStartPos = input.Position
        resizeStartSize = Vector2.new(mainFrame.Size.X.Offset, mainFrame.Size.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStartPos
        local newSize = resizeStartSize + Vector2.new(delta.X, delta.Y)
        newSize = Vector2.new(
            math.clamp(newSize.X, minSize.X, maxSize.X),
            math.clamp(newSize.Y, minSize.Y, maxSize.Y)
        )
        mainFrame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
    end
end)

-- اسم النظام في الأعلى
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Elite Made By ALm6eri - نظام هاكات متكامل"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = COLORS.white
titleLabel.Parent = mainFrame

-- نظام الصفحات Tabs
local tabs = {"بانغ", "الحركة", "طيران + نو كليب", "معلومات اللاعب"}
local pages = {}
local currentPage = 1

-- أزرار التبويب
local tabButtons = {}
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.Position = UDim2.new(0, (i-1)*105 + 10, 0, 45)
    btn.BackgroundColor3 = COLORS.purple
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 12)
    btn.Parent = mainFrame
    tabButtons[i] = btn
end

-- دالة تفعيل الصفحة
local function setActivePage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
        tabButtons[i].BackgroundColor3 = (i == index) and COLORS.green or COLORS.purple
    end
    currentPage = index
end

------------------------
-- 1) صفحة بانغ (Bang System)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -100)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[1] = page

    -- Dropdown اختيار هدف اللاعب
    local targetDropdown = Instance.new("TextButton")
    targetDropdown.Size = UDim2.new(0, 180, 0, 40)
    targetDropdown.Position = UDim2.new(0, 20, 0, 20)
    targetDropdown.BackgroundColor3 = COLORS.purple
    targetDropdown.Text = "اختـر هدف"
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.TextColor3 = COLORS.white
    addUICorner(targetDropdown, 10)
    targetDropdown.Parent = page

    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0, 180, 0, 160)
    dropdownList.Position = UDim2.new(0, 20, 0, 65)
    dropdownList.BackgroundColor3 = COLORS.background
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    addUICorner(dropdownList, 10)
    dropdownList.Parent = page

    -- تحديث قائمة اللاعبين داخل Dropdown
    local function refreshDropdown()
        dropdownList:ClearAllChildren()
        local y = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 35)
                btn.Position = UDim2.new(0, 0, 0, y)
                btn.BackgroundColor3 = COLORS.purple
                btn.Text = plr.Name
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 18
                btn.TextColor3 = COLORS.white
                addUICorner(btn, 8)
                btn.Parent = dropdownList
                y = y + 40
                btn.MouseButton1Click:Connect(function()
                    targetDropdown.Text = btn.Text
                    dropdownList.Visible = false
                end)
            end
        end
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, y)
    end

    targetDropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then refreshDropdown() end
    end)

    -- مربعات النص لسرعة التذبذب والمسافة
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 240)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.5"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 25)
    speedBox.Position = UDim2.new(0, 230, 0, 240)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "1.5"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 20
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 200, 0, 25)
    distLabel.Position = UDim2.new(0, 20, 0, 275)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3.5"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 20
    distLabel.TextColor3 = COLORS.white
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = page

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0, 80, 0, 25)
    distBox.Position = UDim2.new(0, 230, 0, 275)
    distBox.BackgroundColor3 = COLORS.background
    distBox.Text = "3.5"
    distBox.TextColor3 = COLORS.white
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 20
    addUICorner(distBox, 8)
    distBox.ClearTextOnFocus = false
    distBox.Parent = page

    -- أزرار تشغيل وإيقاف Bang
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 180, 0, 45)
    startBtn.Position = UDim2.new(0, 20, 0, 310)
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.Text = "تشغيل بانغ + نو كليب"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 22
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 12)
    startBtn.Parent = page

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 180, 0, 45)
    stopBtn.Position = UDim2.new(0, 220, 0, 310)
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.Text = "إيقاف بانغ"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 22
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 12)
    stopBtn.Parent = page

    -- متغيرات Bang و Noclip
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_FREQUENCY = 1.5
    local OSCILLATION_AMPLITUDE = 1
    local BASE_FOLLOW_DISTANCE = 3.5

    -- متغير تخزين حالة تحكم حركة اللاعب (W/S فقط)
    local moveInput = {
        forward = false,
        backward = false,
    }

    -- دالة تعطيل تفعيل Noclip (تفعيل/تعطيل التصادم)
    local function SetNoclip(enabled)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- دالة للبحث عن لاعب بواسطة الاسم
    local function GetPlayerByName(name)
        name = name:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) then
                return plr
            end
        end
        return nil
    end

    -- إشعارات على الشاشة
    local function createNotification(text, duration)
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 300, 0, 45)
        notif.Position = UDim2.new(0.5, -150, 0, 50)
        notif.BackgroundColor3 = COLORS.orange
        notif.TextColor3 = COLORS.white
        notif.Font = Enum.Font.GothamBold
        notif.TextSize = 22
        notif.Text = text
        notif.BackgroundTransparency = 0.1
        notif.Parent = ScreenGui

        local tweenIn = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, 100), BackgroundTransparency = 0})
        tweenIn:Play()

        delay(duration or 3, function()
            local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -150, 0, 50), BackgroundTransparency = 1})
            tweenOut:Play()
            tweenOut.Completed:Wait()
            notif:Destroy()
        end)
    end

    -- تحديث القيم من مربعات النص
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
            distLabel.Text = "المسافة من الهدف: " .. tostring(val)
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

    -- التحكم بحركة اللاعب (تقييد W/S فقط)
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

    -- متابعة الهدف مع حركة محدودة ضمن المسافة
    local function FollowTarget()
        if not BangActive or not TargetPlayer then return end
        if not TargetPlayer.Character then return end
        if not LocalPlayer.Character then return end

        local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local lookVector = targetHRP.CFrame.LookVector
        local posBase = targetHRP.Position - lookVector * BASE_FOLLOW_DISTANCE

        -- تذبذب عمودي ناعم
        local oscillation = math.sin(tick() * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE
        local desiredPos = posBase + Vector3.new(0, oscillation, 0)

        -- حركة أمام وخلف بناءً على WASD (مقيدة)
        local moveDirection = Vector3.new(0, 0, 0)
        if moveInput.forward then
            moveDirection = moveDirection + lookVector
        end
        if moveInput.backward then
            moveDirection = moveDirection - lookVector
        end

        local moveSpeed = 7

        -- حساب المسافة الحالية بين اللاعب والهدف على محور LookVector
        local vectorToPlayer = localHRP.Position - targetHRP.Position
        local projectedLength = vectorToPlayer:Dot(lookVector)

        local maxDistance = BASE_FOLLOW_DISTANCE + 1 -- الحد الأعلى
        local minDistance = BASE_FOLLOW_DISTANCE - 1 -- الحد الأدنى

        -- منع تجاوز الحد الأمامي أو الخلفي
        if moveInput.forward and projectedLength > maxDistance then
            moveDirection = Vector3.new(0, 0, 0)
        elseif moveInput.backward and projectedLength < minDistance then
            moveDirection = Vector3.new(0, 0, 0)
        end

        -- دمج الحركة مع التذبذب
        desiredPos = desiredPos + moveDirection * moveSpeed * RS.RenderStepped:Wait()

        -- تحريك HumanoidRootPart بسلاسة نحو الموقع الجديد
        local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(localHRP, tweenInfo, {CFrame = CFrame.new(desiredPos, targetHRP.Position)})
        tween:Play()
    end

    -- وظيفة بدء Bang مع تفعيل Noclip
    local function StartBang(targetName)
        if BangActive then
            createNotification("بانغ مفعّل بالفعل!", 3)
            return
        end
        local plr = GetPlayerByName(targetName)
        if not plr then
            createNotification("ما لقينا اللاعب: "..targetName, 3)
            return
        end
        if plr == LocalPlayer then
            createNotification("ما تقدر تختار نفسك!", 3)
            return
        end
        TargetPlayer = plr
        BangActive = true
        SetNoclip(true)
        createNotification("بانغ شغّل على "..plr.Name, 3)
    end

    -- إيقاف Bang وإلغاء Noclip
    local function StopBang()
        if not BangActive then
            createNotification("بانغ مو شغّال", 3)
            return
        end
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        moveInput.forward = false
        moveInput.backward = false
        createNotification("بانغ توقف، التحكم رجع طبيعي", 3)
    end

    startBtn.MouseButton1Click:Connect(function()
        UpdateSpeed()
        UpdateDistance()
        StartBang(targetDropdown.Text)
    end)

    stopBtn.MouseButton1Click:Connect(StopBang)

    -- تحديث التتبع باستمرار
    RS.RenderStepped:Connect(function()
        if BangActive then
            FollowTarget()
        end
    end)
end

------------------------
-- 2) صفحة الحركة (Movement)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -100)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    -- عنوان السرعة
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة المشي: 16"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    -- مربع نص السرعة
    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 25)
    speedBox.Position = UDim2.new(0, 220, 0, 20)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16)
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 20
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    -- عنوان قوة القفز
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 200, 0, 25)
    jumpLabel.Position = UDim2.new(0, 20, 0, 60)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "قوة القفز: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 20
    jumpLabel.TextColor3 = COLORS.white
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = page

    -- مربع نص قوة القفز
    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 80, 0, 25)
    jumpBox.Position = UDim2.new(0, 220, 0, 60)
    jumpBox.BackgroundColor3 = COLORS.background
    jumpBox.Text = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50)
    jumpBox.TextColor3 = COLORS.white
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 20
    addUICorner(jumpBox, 8)
    jumpBox.ClearTextOnFocus = false
    jumpBox.Parent = page

    -- زر تحديث الحركة
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 180, 0, 40)
    applyBtn.Position = UDim2.new(0, 20, 0, 100)
    applyBtn.BackgroundColor3 = COLORS.green
    applyBtn.Text = "تطبيق الإعدادات"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 22
    applyBtn.TextColor3 = COLORS.white
    addUICorner(applyBtn, 12)
    applyBtn.Parent = page

    -- دالة تطبيق الإعدادات
    local function ApplyMovementSettings()
        local speed = tonumber(speedBox.Text)
        local jump = tonumber(jumpBox.Text)
        if not speed or speed < 1 or speed > 100 then
            createNotification("سرعة المشي لازم تكون بين 1 و 100", 3)
            return
        end
        if not jump or jump < 1 or jump > 200 then
            createNotification("قوة القفز لازم تكون بين 1 و 200", 3)
            return
        end
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            humanoid.JumpPower = jump
            createNotification("تم تطبيق الإعدادات بنجاح!", 3)
        else
            createNotification("ما قدرنا نلاقي شخصية اللاعب!", 3)
        end
    end

    applyBtn.MouseButton1Click:Connect(ApplyMovementSettings)
end

------------------------
-- 3) صفحة طيران + نو كليب (Flight + Noclip)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -100)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    local flightActive = false
    local noclipActive = false

    -- زر تشغيل الطيران
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

    -- زر إيقاف الطيران
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

    -- زر تشغيل نو كليب
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

    -- زر إيقاف نو كليب
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

    -- تفعيل الطيران (الأساسي)
    local flySpeed = 50
    local flying = false
    local bodyVelocity = nil

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
    end

    local function disableFlight()
        flying = false
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        createNotification("تم إيقاف الطيران!", 3)
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
    end

    flyBtn.MouseButton1Click:Connect(enableFlight)
    flyStopBtn.MouseButton1Click:Connect(disableFlight)
    noclipBtn.MouseButton1Click:Connect(enableNoclip)
    noclipStopBtn.MouseButton1Click:Connect(disableNoclip)
end

------------------------
-- 4) صفحة معلومات اللاعب مع صورة البروفايل
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -100)
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
    -- صورة افتراضية
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

    -- معرف اللاعب
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(1, 0, 0, 30)
    idLabel.Position = UDim2.new(0, 0, 0, 210)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "معرف المستخدم (UserId): " .. LocalPlayer.UserId
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
هنا تقدر تتحكم بكل خصائص الهك بسهولة وأمان.  
تأكد من استخدام الأدوات بعقلانية وتجنب كشف هويتك.  
]]
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 20
    welcomeLabel.TextColor3 = COLORS.orange
    welcomeLabel.TextWrapped = true
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.Parent = page
end

-- تفعيل الصفحة الأولى (بانغ) تلقائياً
setActivePage(1)

-- ربط أزرار التبويب
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
end

-- زر إغلاق النافذة
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -45, 0, 5)
closeBtn.BackgroundColor3 = COLORS.red
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 32
closeBtn.TextColor3 = COLORS.white
addUICorner(closeBtn, 12)
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)
