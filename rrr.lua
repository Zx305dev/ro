-- Elite V5 PRO 2025 - سكربت متكامل واجهة مع نظام Bang, ESP, Fly, معلومات اللاعب

-- الخدمات
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- تنسيق الألوان والخطوط
local COLORS = {
    background = Color3.fromRGB(40, 20, 70),
    darkBackground = Color3.fromRGB(30, 15, 60),
    highlight = Color3.fromRGB(140, 80, 230),
    green = Color3.fromRGB(0, 180, 70),
    red = Color3.fromRGB(180, 0, 0),
    white = Color3.fromRGB(255, 255, 255),
    espColors = {
        Color3.fromRGB(0,255,0),
        Color3.fromRGB(255,0,0),
        Color3.fromRGB(0,170,255),
        Color3.fromRGB(255,255,0),
        Color3.fromRGB(150,50,200),
    }
}

-- دالة لإضافة زوايا دائرية لأي عنصر
local function addUICorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = obj
end

-- دالة إنشاء إشعار منبثق (Notification)
local NotificationFolder = Instance.new("Folder", LocalPlayer.PlayerGui)
NotificationFolder.Name = "EliteNotifications"

local function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 1, -60 - (#NotificationFolder:GetChildren() * 60))
    notif.BackgroundColor3 = COLORS.highlight
    notif.BorderSizePixel = 0
    notif.Parent = NotificationFolder
    notif.AnchorPoint = Vector2.new(0,1)
    addUICorner(notif, 15)

    local label = Instance.new("TextLabel", notif)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = COLORS.white
    label.TextSize = 20
    label.TextWrapped = true

    notif.BackgroundTransparency = 1
    TweenService:Create(notif, TweenInfo.new(0.4), {BackgroundTransparency=0}):Play()
    wait(duration)
    TweenService:Create(notif, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play()
    wait(0.4)
    notif:Destroy()
end

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "EliteV5GUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 440)
MainFrame.Position = UDim2.new(0.5, -210, 0.4, -220)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.ClipsDescendants = true
addUICorner(MainFrame, 20)

-- شريط العنوان مع السحب
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = COLORS.darkBackground
addUICorner(TitleBar, 20)

local TitleLabel = Instance.new("TextLabel", TitleBar)
TitleLabel.Text = "قائمة Elite V5 PRO"
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 22
TitleLabel.TextColor3 = COLORS.white

-- تمكين السحب من العنوان
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- أزرار الصفحات (Tabs)
local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, 0, 0, 40)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundTransparency = 1

local Tabs = {"الرئيسية", "بانج", "ESP", "طيران", "معلوماتي"}
local Pages = {}

local function createTabButton(name, index)
    local btn = Instance.new("TextButton", TabBar)
    btn.Size = UDim2.new(1/#Tabs, 0, 1, 0)
    btn.Position = UDim2.new((index-1)/#Tabs, 0, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 12)
    return btn
end

local activeTab = 1
local TabButtons = {}

for i, tabName in ipairs(Tabs) do
    TabButtons[i] = createTabButton(tabName, i)
end

-- إنشاء صفحات محتوى (Frames) مخفية في البداية
for i=1, #Tabs do
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -90)
    page.Position = UDim2.new(0, 10, 0, 80)
    page.BackgroundTransparency = 1
    page.Visible = false
    Pages[i] = page
end

-- تفعيل صفحة افتراضية
local function activatePage(index)
    for i, page in ipairs(Pages) do
        if i == index then
            page.Visible = true
            TabButtons[i].BackgroundColor3 = COLORS.highlight
        else
            page.Visible = false
            TabButtons[i].BackgroundColor3 = COLORS.darkBackground
        end
    end
    activeTab = index
end

-- ربط أزرار التنقل
for i, btn in ipairs(TabButtons) do
    btn.MouseButton1Click:Connect(function()
        activatePage(i)
    end)
end

-- تفعيل الصفحة الأولى تلقائياً عند البدء
activatePage(1)

-- =========================================
-- =========== الصفحة 1 - الرئيسية =========
-- =========================================

do
    local page = Pages[1]

    local welcome = Instance.new("TextLabel", page)
    welcome.Size = UDim2.new(1, 0, 0, 40)
    welcome.Position = UDim2.new(0, 0, 0, 0)
    welcome.BackgroundTransparency = 1
    welcome.Font = Enum.Font.GothamBold
    welcome.TextSize = 26
    welcome.TextColor3 = COLORS.white
    welcome.Text = "مرحباً بك في Elite V5 PRO"
    welcome.TextXAlignment = Enum.TextXAlignment.Center

    local desc = Instance.new("TextLabel", page)
    desc.Size = UDim2.new(1, 0, 0, 120)
    desc.Position = UDim2.new(0, 0, 0, 50)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.GothamBold
    desc.TextSize = 20
    desc.TextColor3 = COLORS.white
    desc.TextWrapped = true
    desc.Text = [[
- استخدم أزرار التنقل أعلاه للتبديل بين الأنظمة المختلفة.
- في صفحة بانج، يمكنك تعيين الهدف وتشغيل النظام مع تحكم كامل.
- صفحة ESP تسمح لك برؤية اللاعبين مع إمكانية تغيير لون الألوان.
- في صفحة الطيران، استمتع بالتحليق بدون تأثير السقوط.
- معلوماتك الشخصية تظهر في آخر صفحة مع صورة ملفك.

استخدم القائمة بكل سهولة وتمتع بمميزات قوية واحترافية!]]
    desc.TextXAlignment = Enum.TextXAlignment.Left
end

-- =========================================
-- =========== الصفحة 2 - Bang System ======
-- =========================================

do
    local page = Pages[2]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "نظام بانج مع نوكليب وتحكم سرعة"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- إدخال اسم الهدف
    local targetBox = Instance.new("TextBox", page)
    targetBox.Size = UDim2.new(0, 300, 0, 40)
    targetBox.Position = UDim2.new(0, 10, 0, 60)
    targetBox.PlaceholderText = "أدخل اسم اللاعب الهدف"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 20
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(targetBox, 15)

    -- سرعة التذبذب (Oscillation Frequency)
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 300, 0, 25)
    speedLabel.Position = UDim2.new(0, 10, 0, 110)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.2"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0, 140, 0, 30)
    speedBox.Position = UDim2.new(0, 10, 0, 140)
    speedBox.PlaceholderText = "سرعة التذبذب"
    speedBox.Text = "1.2"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedBox, 12)

    -- المسافة من الهدف (Base Follow Distance)
    local distLabel = Instance.new("TextLabel", page)
    distLabel.Size = UDim2.new(0, 300, 0, 25)
    distLabel.Position = UDim2.new(0, 160, 0, 110)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3.5"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 18
    distLabel.TextColor3 = COLORS.white

    local distBox = Instance.new("TextBox", page)
    distBox.Size = UDim2.new(0, 140, 0, 30)
    distBox.Position = UDim2.new(0, 160, 0, 140)
    distBox.PlaceholderText = "المسافة من الهدف"
    distBox.Text = "3.5"
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 18
    distBox.TextColor3 = COLORS.white
    distBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(distBox, 12)

    -- أزرار التشغيل والإيقاف
    local startBtn = Instance.new("TextButton", page)
    startBtn.Size = UDim2.new(0.45, -10, 0, 40)
    startBtn.Position = UDim2.new(0, 10, 0, 190)
    startBtn.Text = "تشغيل بانج"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 20
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 15)

    local stopBtn = Instance.new("TextButton", page)
    stopBtn.Size = UDim2.new(0.45, -10, 0, 40)
    stopBtn.Position = UDim2.new(0.55, -10, 0, 190)
    stopBtn.Text = "إيقاف بانج"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 20
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 15)

    -- الحالة والمتغيرات
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_FREQUENCY = 1.2
    local OSCILLATION_AMPLITUDE = 2.5
    local BASE_FOLLOW_DISTANCE = 3.5

    -- دالة Noclip
    local function SetNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- تعطيل تحكم اليد (PlatformStand)
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

    -- متابعة الهدف مع التذبذب
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
        local desiredPosition = basePosition + targetLookVector * oscillation

        local vectorToDesired = desiredPosition - targetHRP.Position
        if vectorToDesired:Dot(targetLookVector) > 0 then
            desiredPosition = basePosition
        end

        localHRP.CFrame = CFrame.new(desiredPosition, targetHRP.Position)
    end

    RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function()
        if BangActive then
            FollowTarget()
        end
    end)

    -- البحث عن لاعب بالاسم
    local function GetPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    local function StartBang(targetName)
        local target = GetPlayerByName(targetName)
        if not target then
            createNotification("لم يتم العثور على اللاعب: " .. targetName, 3)
            return false
        end
        TargetPlayer = target
        BangActive = true
        SetNoclip(true)
        createNotification("بانج مفعل على اللاعب: " .. TargetPlayer.Name, 3)
        return true
    end

    local function StopBang()
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        createNotification("تم إيقاف بانج وإعادة التحكم", 3)
    end

    startBtn.MouseButton1Click:Connect(function()
        local name = targetBox.Text
        if name == "" then
            createNotification("يرجى إدخال اسم اللاعب الهدف", 2)
            return
        end

        -- تحديث الإعدادات من مربعات النص
        local freq = tonumber(speedBox.Text)
        if freq and freq > 0 then
            OSCILLATION_FREQUENCY = freq
            speedLabel.Text = "سرعة التذبذب: " .. freq
        else
            speedBox.Text = tostring(OSCILLATION_FREQUENCY)
        end

        local dist = tonumber(distBox.Text)
        if dist and dist > 0 then
            BASE_FOLLOW_DISTANCE = dist
            distLabel.Text = "المسافة من الهدف: " .. dist
        else
            distBox.Text = tostring(BASE_FOLLOW_DISTANCE)
        end

        StartBang(name)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        StopBang()
    end)
end

-- =========================================
-- =========== الصفحة 3 - ESP ==============
-- =========================================

do
    local page = Pages[3]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "نظام ESP مع تغيير الألوان"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- تفعيل/إيقاف ESP
    local espToggle = Instance.new("TextButton", page)
    espToggle.Size = UDim2.new(0, 200, 0, 40)
    espToggle.Position = UDim2.new(0, 10, 0, 60)
    espToggle.Text = "تفعيل ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 20
    espToggle.BackgroundColor3 = COLORS.green
    espToggle.TextColor3 = COLORS.white
    addUICorner(espToggle, 15)

    -- تغيير اللون
    local colorBtn = Instance.new("TextButton", page)
    colorBtn.Size = UDim2.new(0, 200, 0, 40)
    colorBtn.Position = UDim2.new(0, 10, 0, 110)
    colorBtn.Text = "تغيير لون ESP"
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 20
    colorBtn.BackgroundColor3 = COLORS.highlight
    colorBtn.TextColor3 = COLORS.white
    addUICorner(colorBtn, 15)

    local currentColorIndex = 1
    local ESPActive = false
    local ESPBoxes = {}

    local function createESPForPlayer(plr)
        if ESPBoxes[plr] then return end
        local box = Instance.new("BillboardGui")
        box.Name = "ESPBox"
        box.Adornee = plr.Character and plr.Character:FindFirstChild("Head") or nil
        box.Size = UDim2.new(0, 100, 0, 40)
        box.AlwaysOnTop = true
        box.ExtentsOffset = Vector3.new(0, 1, 0)
        box.Parent = plr.Character and plr.Character:FindFirstChild("Head") and plr.Character or nil

        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = COLORS.espColors[currentColorIndex]
        frame.BorderSizePixel = 2
        frame.BorderColor3 = COLORS.white
        frame.BackgroundTransparency = 0.5
        addUICorner(frame, 6)

        ESPBoxes[plr] = box
    end

    local function removeESPForPlayer(plr)
        if ESPBoxes[plr] then
            ESPBoxes[plr]:Destroy()
            ESPBoxes[plr] = nil
        end
    end

    local function updateESP()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                if ESPActive then
                    if not ESPBoxes[plr] then
                        if plr.Character and plr.Character:FindFirstChild("Head") then
                            createESPForPlayer(plr)
                        end
                    else
                        -- تحديث اللون
                        local box = ESPBoxes[plr]
                        if box and box:FindFirstChildWhichIsA("Frame") then
                            box:FindFirstChildWhichIsA("Frame").BackgroundColor3 = COLORS.espColors[currentColorIndex]
                        end
                    end
                else
                    removeESPForPlayer(plr)
                end
            end
        end
    end

    espToggle.MouseButton1Click:Connect(function()
        ESPActive = not ESPActive
        espToggle.Text = ESPActive and "إيقاف ESP" or "تفعيل ESP"
        espToggle.BackgroundColor3 = ESPActive and COLORS.red or COLORS.green
        if not ESPActive then
            for plr,_ in pairs(ESPBoxes) do
                removeESPForPlayer(plr)
            end
        end
    end)

    colorBtn.MouseButton1Click:Connect(function()
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #COLORS.espColors then
            currentColorIndex = 1
        end
        if ESPActive then
            updateESP()
        end
        createNotification("تم تغيير لون ESP", 2)
    end)

    -- تحديث مستمر للـ ESP
    RS.Heartbeat:Connect(function()
        if ESPActive then
            updateESP()
        end
    end)
end

-- =========================================
-- =========== الصفحة 4 - Fly System ========
-- =========================================

do
    local page = Pages[4]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "نظام الطيران بدون تأثير سقوط"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- تفعيل/إيقاف الطيران
    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0, 200, 0, 40)
    flyToggle.Position = UDim2.new(0, 10, 0, 60)
    flyToggle.Text = "تفعيل الطيران"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.BackgroundColor3 = COLORS.green
    flyToggle.TextColor3 = COLORS.white
    addUICorner(flyToggle, 15)

    local flyActive = false
    local speed = 70
    local flyVelocity = nil
    local bodyGyro = nil

    local function enableFly()
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        humanoid.PlatformStand = true

        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        flyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyVelocity.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp
    end

    local function disableFly()
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return end

        humanoid.PlatformStand = false

        if flyVelocity then
            flyVelocity:Destroy()
            flyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
    end

    flyToggle.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        if flyActive then
            enableFly()
            flyToggle.Text = "إيقاف الطيران"
            flyToggle.BackgroundColor3 = COLORS.red
            createNotification("تم تفعيل الطيران", 3)
        else
            disableFly()
            flyToggle.Text = "تفعيل الطيران"
            flyToggle.BackgroundColor3 = COLORS.green
            createNotification("تم إيقاف الطيران", 3)
        end
    end)

    -- التحكم بالحركة للطيران
    RS.Heartbeat:Connect(function()
        if flyActive and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hrp or not humanoid then return end

            local cam = workspace.CurrentCamera
            local moveVector = Vector3.new(0, 0, 0)
            local speedMod = speed

            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
                speedMod = speedMod * 2
            end

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + cam.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - cam.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveVector = moveVector + Vector3.new(0,1,0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveVector = moveVector - Vector3.new(0,1,0)
            end

            moveVector = moveVector.Unit * speedMod
            if moveVector.Magnitude == 0 then
                moveVector = Vector3.new(0,0,0)
            end

            if flyVelocity then
                flyVelocity.Velocity = moveVector
            end

            if bodyGyro then
                bodyGyro.CFrame = cam.CFrame
            end
        end
    end)
end

-- =========================================
-- ======== الصفحة 5 - معلومات اللاعب =====
-- =========================================

do
    local page = Pages[5]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "معلومات اللاعب"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- صورة البروفايل
    local profileImage = Instance.new("ImageLabel", page)
    profileImage.Size = UDim2.new(0, 150, 0, 150)
    profileImage.Position = UDim2.new(0, 10, 0, 60)
    profileImage.BackgroundColor3 = COLORS.darkBackground
    addUICorner(profileImage, 20)

    -- تحميل صورة AvatarHeadShot
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    -- معلومات نصية
    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -180, 0, 150)
    infoLabel.Position = UDim2.new(0, 170, 0, 60)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextColor3 = COLORS.white
    infoLabel.TextWrapped = true
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- تحديث معلومات اللاعب دوريًا
    local function updateInfo()
        local ping = 0
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)

        infoLabel.Text = string.format(
            [[اسم اللاعب: %s
رقم المستخدم: %d
سنوات اللعب: %d
Ping الشبكة: %d ms
أصدقاء متصلين: %d]],
            LocalPlayer.Name,
            LocalPlayer.UserId,
            math.floor(LocalPlayer.AccountAge / 365),
            ping,
            #LocalPlayer:GetFriendsOnline()
        )
    end

    updateInfo()

    coroutine.wrap(function()
        while true do
            wait(5)
            updateInfo()
        end
    end)()
end

-- ==========================
-- = زر تكبير وتصغير الواجهة =
-- ==========================

do
    local minSize = Vector2.new(320, 320)
    local maxSize = Vector2.new(900, 700)
    local resizing = false
    local resizeStartPos = Vector2.new()
    local originalSize = Vector2.new()

    local resizeBtn = Instance.new("TextButton", MainFrame)
    resizeBtn.Size = UDim2.new(0, 40, 0, 40)
    resizeBtn.Position = UDim2.new(1, -50, 0, 5)
    resizeBtn.Text = "+"
    resizeBtn.Font = Enum.Font.GothamBold
    resizeBtn.TextSize = 30
    resizeBtn.BackgroundColor3 = COLORS.darkBackground
    resizeBtn.TextColor3 = COLORS.white
    addUICorner(resizeBtn, 12)

    resizeBtn.MouseButton1Down:Connect(function(input)
        resizing = true
        resizeStartPos = input.Position
        originalSize = Vector2.new(MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end)

    UIS.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStartPos
            local newSize = Vector2.new(
                math.clamp(originalSize.X + delta.X, minSize.X, maxSize.X),
                math.clamp(originalSize.Y + delta.Y, minSize.Y, maxSize.Y)
            )
            MainFrame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
        end
    end)

    local toggleSmall = false
    resizeBtn.MouseButton2Click:Connect(function()
        if toggleSmall then
            MainFrame.Size = UDim2.new(0, 420, 0, 440)
            toggleSmall = false
        else
            MainFrame.Size = UDim2.new(0, 320, 0, 320)
            toggleSmall = true
        end
    end)
end

-- ==============
-- Fade In / Out
-- ==============

local function FadeIn(frame, duration)
    duration = duration or 0.5
    frame.BackgroundTransparency = 1
    TweenService:Create(frame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("Frame") then
            child.TextTransparency = 1
            TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            child.BackgroundTransparency = 1
            TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        end
    end
end

local function FadeOut(frame, duration)
    duration = duration or 0.5
    TweenService:Create(frame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("Frame") then
            TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
            TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        end
    end
end

FadeIn(MainFrame)

-- =========================================
-- = تفعيل واجهة المستخدم تلقائياً عند بداية اللعبة =
-- =========================================

ScreenGui.Enabled = true

createNotification("تم تحميل قائمة Elite V5 PRO بنجاح!", 4)

-- السكربت كامل ومتكامل جاهز للاستخدام

