-- Elite Bang System + Noclip + Menu Roblox Script
-- تصميم وشرح من ChatGPT بخبرة عالية
-- لاستخدام داخلي في بيئة Roblox

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- لوحة الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteBangMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- ألوان موحدة
local COLORS = {
    background = Color3.fromRGB(25, 25, 30),
    darkBackground = Color3.fromRGB(15, 15, 20),
    purple = Color3.fromRGB(130, 90, 220),
    green = Color3.fromRGB(80, 200, 120),
    red = Color3.fromRGB(220, 50, 50),
    white = Color3.new(1,1,1)
}

-- دالة إضافة زوايا ناعمة
local function addUICorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = instance
end

-- إشعارات بسيطة
local function createNotification(text, duration)
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0, 50)
    notif.BackgroundColor3 = COLORS.purple
    notif.TextColor3 = COLORS.white
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Text = text
    notif.BackgroundTransparency = 0.15
    addUICorner(notif, 10)
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

-- واجهة رئيسية
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = COLORS.background
addUICorner(mainFrame, 15)
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- تبويبات الصفحات
local tabs = {"Bang System", "ESP & Fly", "Player Info"}
local pages = {}
local currentPage = 1

-- إنشاء أزرار التبويب
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.Position = UDim2.new(0, (i-1)*130 + 10, 0, 10)
    btn.BackgroundColor3 = COLORS.purple
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 10)
    btn.Parent = mainFrame
    tabButtons[i] = btn
end

-- دالة تفعيل صفحة
local function setActivePage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
        tabButtons[i].BackgroundColor3 = (i == index) and COLORS.green or COLORS.purple
    end
    currentPage = index
end

-- ================== صفحة Bang System ==================
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -60)
    page.Position = UDim2.new(0, 10, 0, 50)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 12)
    page.Parent = mainFrame
    page.Visible = false
    pages[1] = page

    -- Dropdown اختيار الهدف
    local targetDropdown = Instance.new("TextButton")
    targetDropdown.Size = UDim2.new(0, 180, 0, 35)
    targetDropdown.Position = UDim2.new(0, 10, 0, 10)
    targetDropdown.BackgroundColor3 = COLORS.purple
    targetDropdown.Text = "اختر هدف"
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.TextColor3 = COLORS.white
    addUICorner(targetDropdown, 10)
    targetDropdown.Parent = page

    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0, 180, 0, 150)
    dropdownList.Position = UDim2.new(0, 10, 0, 50)
    dropdownList.BackgroundColor3 = COLORS.background
    dropdownList.Visible = false
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdownList.Parent = page
    addUICorner(dropdownList, 10)
    dropdownList.BorderSizePixel = 0

    -- تحديث قائمة اللاعبين في Dropdown
    local function refreshDropdown()
        dropdownList:ClearAllChildren()
        local y = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Position = UDim2.new(0, 0, 0, y)
                btn.BackgroundColor3 = COLORS.purple
                btn.Text = plr.Name
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 16
                btn.TextColor3 = COLORS.white
                addUICorner(btn, 8)
                btn.Parent = dropdownList
                y = y + 35
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

    -- مربعات النص لضبط سرعة التذبذب والمسافة
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 180, 0, 25)
    speedLabel.Position = UDim2.new(0, 10, 0, 210)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.2"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 25)
    speedBox.Position = UDim2.new(0, 200, 0, 210)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "1.2"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 180, 0, 25)
    distLabel.Position = UDim2.new(0, 10, 0, 240)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 18
    distLabel.TextColor3 = COLORS.white
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = page

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0, 80, 0, 25)
    distBox.Position = UDim2.new(0, 200, 0, 240)
    distBox.BackgroundColor3 = COLORS.background
    distBox.Text = "3"
    distBox.TextColor3 = COLORS.white
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 18
    addUICorner(distBox, 8)
    distBox.ClearTextOnFocus = false
    distBox.Parent = page

    -- أزرار التشغيل والإيقاف
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 170, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 0, 280)
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.Text = "تشغيل Bang"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 20
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 12)
    startBtn.Parent = page

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 170, 0, 40)
    stopBtn.Position = UDim2.new(0, 210, 0, 280)
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
    local OSCILLATION_AMPLITUDE = 1
    local OSCILLATION_FREQUENCY = 1.2
    local BASE_FOLLOW_DISTANCE = 3

    -- وظيفة Noclip بدون مشاكل
    local function SetNoclip(enabled)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- البحث عن لاعب
    local function GetPlayerByName(name)
        name = name:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) then
                return plr
            end
        end
        return nil
    end

    -- إشعار
    local function Notify(text)
        createNotification(text, 4)
    end

    -- تحديث القيم من مربعات النص
    local function UpdateSpeed()
        local val = tonumber(speedBox.Text)
        if val and val > 0 and val <= 10 then
            OSCILLATION_FREQUENCY = val
            speedLabel.Text = "سرعة التذبذب: " .. tostring(val)
        else
            speedBox.Text = tostring(OSCILLATION_FREQUENCY)
            Notify("الرجاء إدخال رقم بين 0.1 و 10 للسرعة")
        end
    end

    local function UpdateDistance()
        local val = tonumber(distBox.Text)
        if val and val >= 1 and val <= 20 then
            BASE_FOLLOW_DISTANCE = val
            distLabel.Text = "المسافة من الهدف: " .. tostring(val)
        else
            distBox.Text = tostring(BASE_FOLLOW_DISTANCE)
            Notify("الرجاء إدخال رقم بين 1 و 20 للمسافة")
        end
    end

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then UpdateSpeed() end
    end)
    distBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then UpdateDistance() end
    end)

    -- حركة تتبع الهدف مع التذبذب
    local function FollowTarget()
        if not BangActive or not TargetPlayer then return end
        if not TargetPlayer.Character then return end
        if not LocalPlayer.Character then return end

        local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local targetLookVector = targetHRP.CFrame.LookVector
        local time = tick()
        local oscillation = math.sin(time * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE

        local basePosition = targetHRP.Position - targetLookVector * BASE_FOLLOW_DISTANCE
        local desiredPosition = basePosition + Vector3.new(0, oscillation, 0)

        -- منع تجاوز الهدف
        local vectorToDesired = desiredPosition - targetHRP.Position
        if vectorToDesired:Dot(targetLookVector) > 0 then
            desiredPosition = basePosition
        end

        -- حركة ناعمة
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(localHRP, tweenInfo, {CFrame = CFrame.new(desiredPosition, targetHRP.Position)})
        tween:Play()
    end

    -- إيقاف Bang
    local function StopBang()
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        Notify("تم إيقاف Bang وإعادة التحكم")
    end

    -- تشغيل Bang
    local function StartBang(name)
        local target = GetPlayerByName(name)
        if not target then
            Notify("اللاعب غير موجود: " .. tostring(name))
            return false
        end
        if target == LocalPlayer then
            Notify("لا يمكنك اختيار نفسك")
            return false
        end
        TargetPlayer = target
        BangActive = true
        SetNoclip(true)
        Notify("تم تشغيل Bang على: " .. target.Name)
        return true
    end

    startBtn.MouseButton1Click:Connect(function()
        if BangActive then
            Notify("Bang مفعّل بالفعل!")
            return
        end
        StartBang(targetDropdown.Text)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        if not BangActive then
            Notify("Bang غير مفعل حالياً")
            return
        end
        StopBang()
    end)

    -- تعطيل تحكم اللاعب أثناء Bang
    RS:BindToRenderStep("DisablePlayerInput", Enum.RenderPriority.Character.Value + 4, function()
        if BangActive and LocalPlayer.Character then
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

    -- تحديث حركة Bang في كل فريم
    RS:BindToRenderStep("BangFollow", Enum.RenderPriority.Character.Value + 2, function()
        if BangActive then
            FollowTarget()
        end
    end)
end

-- ================== صفحة ESP & Fly ==================
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -60)
    page.Position = UDim2.new(0, 10, 0, 50)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 12)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    -- زر تفعيل ESP
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0, 180, 0, 40)
    espToggle.Position = UDim2.new(0, 10, 0, 10)
    espToggle.BackgroundColor3 = COLORS.purple
    espToggle.Text = "تفعيل ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 20
    espToggle.TextColor3 = COLORS.white
    addUICorner(espToggle, 12)
    espToggle.Parent = page

    -- زر تفعيل الطيران
    local flyToggle = Instance.new("TextButton")
    flyToggle.Size = UDim2.new(0, 180, 0, 40)
    flyToggle.Position = UDim2.new(0, 210, 0, 10)
    flyToggle.BackgroundColor3 = COLORS.purple
    flyToggle.Text = "تفعيل الطيران"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.TextColor3 = COLORS.white
    addUICorner(flyToggle, 12)
    flyToggle.Parent = page

    -- حالة التفعيل
    local espActive = false
    local flyActive = false

    -- جدول ESP للاعبين
    local espLabels = {}

    -- إنشاء ESP للاعب معين
    local function createESP(plr)
        if espLabels[plr] then return end
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Adornee = plr.Character and plr.Character:FindFirstChild("Head")
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.Text = plr.Name
        label.Parent = billboard

        billboard.Parent = plr.Character and plr.Character:FindFirstChild("Head") or nil
        espLabels[plr] = billboard
    end

    -- حذف ESP للاعب معين
    local function removeESP(plr)
        if espLabels[plr] then
            espLabels[plr]:Destroy()
            espLabels[plr] = nil
        end
    end

    -- تحديث ESP لجميع اللاعبين
    local function updateESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if espActive then
                    if plr.Character and plr.Character:FindFirstChild("Head") then
                        if not espLabels[plr] then createESP(plr) end
                        espLabels[plr].Adornee = plr.Character.Head
                    else
                        removeESP(plr)
                    end
                else
                    removeESP(plr)
                end
            end
        end
    end

    espToggle.MouseButton1Click:Connect(function()
        espActive = not espActive
        espToggle.Text = espActive and "إيقاف ESP" or "تفعيل ESP"
        if not espActive then
            for plr, _ in pairs(espLabels) do
                removeESP(plr)
            end
        else
            updateESP()
        end
        Notify("ESP " .. (espActive and "مفعل" or "معطل"))
    end)

    Players.PlayerAdded:Connect(function(plr)
        if espActive then updateESP() end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        removeESP(plr)
    end)

    -- نظام طيران (Fly)
    local flySpeed = 50
    local flyBodyVelocity = nil
    local flyBodyGyro = nil

    local function enableFly()
        if flyActive then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        flyBodyVelocity.Parent = hrp

        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        flyBodyGyro.CFrame = hrp.CFrame
        flyBodyGyro.Parent = hrp

        flyActive = true
        Notify("تم تفعيل الطيران")
    end

    local function disableFly()
        if not flyActive then return end
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if flyBodyGyro then
            flyBodyGyro:Destroy()
            flyBodyGyro = nil
        end
        flyActive = false
        Notify("تم تعطيل الطيران")
    end

    flyToggle.MouseButton1Click:Connect(function()
        if flyActive then
            disableFly()
            flyToggle.Text = "تفعيل الطيران"
        else
            enableFly()
            flyToggle.Text = "إيقاف الطيران"
        end
    end)

    -- تحكم الطيران مع WASD + Space + Ctrl
    local moveVector = Vector3.new(0,0,0)
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if flyActive then
            if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector + Vector3.new(0,0,-1) end
            if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector + Vector3.new(0,0,1) end
            if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector + Vector3.new(-1,0,0) end
            if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector + Vector3.new(1,0,0) end
            if input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector + Vector3.new(0,1,0) end
            if input.KeyCode == Enum.KeyCode.LeftControl then moveVector = moveVector + Vector3.new(0,-1,0) end
        end
    end)
    UIS.InputEnded:Connect(function(input, gp)
        if gp then return end
        if flyActive then
            if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector - Vector3.new(0,0,-1) end
            if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector - Vector3.new(0,0,1) end
            if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector - Vector3.new(-1,0,0) end
            if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector - Vector3.new(1,0,0) end
            if input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector - Vector3.new(0,1,0) end
            if input.KeyCode == Enum.KeyCode.LeftControl then moveVector = moveVector - Vector3.new(0,-1,0) end
        end
    end)

    RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 1, function(dt)
        if flyActive and flyBodyVelocity and flyBodyGyro and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local camCF = workspace.CurrentCamera.CFrame
                local moveDir = (camCF.RightVector * moveVector.X + camCF.LookVector * moveVector.Z + Vector3.new(0, moveVector.Y, 0)).Unit
                if moveDir ~= moveDir then -- if NaN
                    moveDir = Vector3.new(0,0,0)
                end
                flyBodyVelocity.Velocity = moveDir * flySpeed
                flyBodyGyro.CFrame = camCF
            end
        end
    end)
end

-- ================== صفحة معلومات اللاعب ==================
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -60)
    page.Position = UDim2.new(0, 10, 0, 50)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 12)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    -- صورة البروفايل (avatar)
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(0, 100, 0, 100)
    avatarImage.Position = UDim2.new(0, 20, 0, 20)
    avatarImage.BackgroundColor3 = COLORS.purple
    addUICorner(avatarImage, 12)
    avatarImage.Parent = page

    local userId = LocalPlayer.UserId
    local userName = LocalPlayer.Name

    -- تحميل صورة الأفاتار عبر API
    avatarImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..tostring(userId).."&width=420&height=420&format=png"

    -- اسم المستخدم
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 200, 0, 40)
    nameLabel.Position = UDim2.new(0, 140, 0, 40)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = COLORS.white
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 28
    nameLabel.Text = "الاسم: " .. userName
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = page

    -- معرف المستخدم
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(0, 200, 0, 30)
    idLabel.Position = UDim2.new(0, 140, 0, 90)
    idLabel.BackgroundTransparency = 1
    idLabel.TextColor3 = COLORS.white
    idLabel.Font = Enum.Font.GothamBold
    idLabel.TextSize = 24
    idLabel.Text = "UserId: " .. tostring(userId)
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.Parent = page
end

-- تفعيل التبويب الأول تلقائياً عند بداية التشغيل
setActivePage(1)

-- التعامل مع ضغط أزرار التبويب
for i, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
end
