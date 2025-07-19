-- Elite V5 PRO - نسخة كاملة متكاملة مع نظام Bang متطور
-- صنع بواسطة Alm6eri
-- واجهة عربية، ألوان بنفسجية، تحكم كامل، سحب وتكبير وتصغير

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- =========== إعدادات الألوان =============
local COLORS = {
    purple = Color3.fromRGB(148, 0, 211),
    white = Color3.fromRGB(255, 255, 255),
    green = Color3.fromRGB(0, 180, 60),
    red = Color3.fromRGB(180, 0, 0),
    darkBackground = Color3.fromRGB(35, 0, 60),
    background = Color3.fromRGB(50, 15, 80),
}

local function addUICorner(inst, radius)
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0, radius or 12)
    cr.Parent = inst
    return cr
end

local function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 280, 0, 40)
    notif.Position = UDim2.new(1, -300, 0, 20)
    notif.BackgroundColor3 = COLORS.purple
    notif.TextColor3 = COLORS.white
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 18
    notif.Text = text
    notif.TextWrapped = true
    notif.ZIndex = 999
    notif.BackgroundTransparency = 0.2
    addUICorner(notif, 14)
    notif.AnchorPoint = Vector2.new(1, 0)
    notif.Position = UDim2.new(1, 300, 0, 20) -- خارج الشاشة يمين
    notif.Parent = ScreenGui

    -- تحريك الظهور (Fade in + slide in)
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -20, 0, 20)}):Play()
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()

    delay(duration, function()
        -- تحريك الإختفاء (Fade out + slide out)
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 300, 0, 20)}):Play()
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play()
        wait(0.4)
        notif:Destroy()
    end)
end

-- =========== واجهة المستخدم (ScreenGui) ============
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteV5PRO"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- الصندوق الرئيسي (Draggable & Resizable)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- عنوان رئيسي
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Elite V5 PRO"
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.TextSize = 28
TitleLabel.TextColor3 = COLORS.purple
TitleLabel.TextStrokeColor3 = COLORS.white
TitleLabel.TextStrokeTransparency = 0.7
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
TitleLabel.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Made by Alm6eri"
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 16
SubTitle.TextColor3 = COLORS.white
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.Parent = MainFrame

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = COLORS.red
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = COLORS.white
addUICorner(CloseBtn, 15)
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- زر التكبير / التصغير
local MaxMinBtn = Instance.new("TextButton")
MaxMinBtn.Size = UDim2.new(0, 30, 0, 30)
MaxMinBtn.Position = UDim2.new(1, -70, 0, 5)
MaxMinBtn.BackgroundColor3 = COLORS.purple
MaxMinBtn.Text = "↔"
MaxMinBtn.Font = Enum.Font.GothamBold
MaxMinBtn.TextSize = 20
MaxMinBtn.TextColor3 = COLORS.white
addUICorner(MaxMinBtn, 15)
MaxMinBtn.Parent = MainFrame

local isMinimized = false
MaxMinBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 450, 0, 500)
        isMinimized = false
    else
        MainFrame.Size = UDim2.new(0, 250, 0, 40)
        isMinimized = true
    end
end)

-- التبويبات الرئيسية
local Tabs = {"Bang", "ESP & Fly", "معلوماتي"}
local Pages = {}

-- إطار الأزرار
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, 0, 0, 40)
TabsFrame.Position = UDim2.new(0, 0, 0, 70)
TabsFrame.BackgroundTransparency = 1
TabsFrame.Parent = MainFrame

local TabsButtons = {}
local btnWidth = 1 / #Tabs

local function setActiveTab(index)
    for i, page in pairs(Pages) do
        page.Visible = (i == index)
    end
    for i, btn in pairs(TabsButtons) do
        btn.BackgroundColor3 = (i == index) and COLORS.purple or COLORS.darkBackground
    end
end

-- إنشاء أزرار التبويب
for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(btnWidth, -4, 1, 0)
    btn.Position = UDim2.new((i - 1) * btnWidth, 2, 0, 0)
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 10)
    btn.Parent = TabsFrame

    btn.MouseButton1Click:Connect(function()
        setActiveTab(i)
    end)

    TabsButtons[i] = btn
end

-- إنشاء صفحات المحتوى لكل تبويب
for i = 1, #Tabs do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -120)
    page.Position = UDim2.new(0, 10, 0, 120)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = MainFrame
    Pages[i] = page
end

-- ====================== صفحة Bang ======================
do
    local page = Pages[1]

    -- تعليمات
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 30)
    infoLabel.Position = UDim2.new(0, 0, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "نظام Bang متحرك مع سرعة قابلة للتعديل"
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextColor3 = COLORS.white
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center
    infoLabel.Parent = page

    -- قائمة اختيار الهدف (بدلاً من كتابة الاسم)
    local targetLabel = Instance.new("TextLabel")
    targetLabel.Size = UDim2.new(0.6, 0, 0, 30)
    targetLabel.Position = UDim2.new(0.05, 0, 0, 40)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "اختر الهدف:"
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 18
    targetLabel.TextColor3 = COLORS.white
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left
    targetLabel.Parent = page

    local targetDropdown = Instance.new("TextButton")
    targetDropdown.Size = UDim2.new(0.3, 0, 0, 30)
    targetDropdown.Position = UDim2.new(0.4, 0, 0, 40)
    targetDropdown.BackgroundColor3 = COLORS.darkBackground
    targetDropdown.Text = "اختر لاعب"
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.TextColor3 = COLORS.white
    addUICorner(targetDropdown, 10)
    targetDropdown.Parent = page

    local dropdownList = Instance.new("Frame")
    dropdownList.Size = UDim2.new(0, 200, 0, 150)
    dropdownList.Position = UDim2.new(0, 0, 0, 30)
    dropdownList.BackgroundColor3 = COLORS.background
    addUICorner(dropdownList, 12)
    dropdownList.Visible = false
    dropdownList.ClipsDescendants = true
    dropdownList.Parent = targetDropdown

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = dropdownList
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 2)

    -- ملء قائمة اللاعبين باستثناء اللاعب المحلي
    local function refreshDropdown()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.BackgroundColor3 = COLORS.darkBackground
                btn.TextColor3 = COLORS.white
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 18
                btn.Text = plr.Name
                addUICorner(btn, 10)
                btn.Parent = dropdownList
                btn.MouseButton1Click:Connect(function()
                    targetDropdown.Text = btn.Text
                    dropdownList.Visible = false
                end)
            end
        end
    end

    targetDropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then
            refreshDropdown()
        end
    end)

    -- سرعة التذبذب (oscillation speed)
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0.6, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 85)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.2"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0.3, 0, 0, 30)
    speedBox.Position = UDim2.new(0.4, 0, 0, 85)
    speedBox.BackgroundColor3 = COLORS.darkBackground
    speedBox.Text = "1.2"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    addUICorner(speedBox, 10)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    -- مسافة المتابعة
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0.6, 0, 0, 30)
    distLabel.Position = UDim2.new(0.05, 0, 0, 130)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 18
    distLabel.TextColor3 = COLORS.white
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = page

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0.3, 0, 0, 30)
    distBox.Position = UDim2.new(0.4, 0, 0, 130)
    distBox.BackgroundColor3 = COLORS.darkBackground
    distBox.Text = "3"
    distBox.TextColor3 = COLORS.white
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 18
    addUICorner(distBox, 10)
    distBox.ClearTextOnFocus = false
    distBox.Parent = page

    -- أزرار التشغيل والإيقاف
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.4, 0, 0, 40)
    startBtn.Position = UDim2.new(0.1, 0, 0, 180)
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.Text = "تشغيل Bang"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 20
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 15)
    startBtn.Parent = page

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0.4, 0, 0, 40)
    stopBtn.Position = UDim2.new(0.55, 0, 0, 180)
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.Text = "إيقاف Bang"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 20
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 15)
    stopBtn.Parent = page

    -- متغيرات Bang الأساسية
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_AMPLITUDE = 1
    local OSCILLATION_FREQUENCY = 1.2
    local BASE_FOLLOW_DISTANCE = 3

    -- تعيين نوقليب (تعطيل تصادم)
    local function SetNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- البحث عن لاعب بناءً على الاسم
    local function GetPlayerByName(name)
        name = name:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) then
                return plr
            end
        end
        return nil
    end

    -- إخطار
    local function Notify(msg)
        createNotification(msg, 4)
    end

    -- تحديث القيم من مربعات النصوص مع تحقق من الصحة
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

    -- متابعة الهدف مع التذبذب بسلاسة
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
        local desiredPosition = basePosition + Vector3.new(0, oscillation, 0) -- تذبذب عمودي

        -- منع تجاوز الهدف
        local vectorToDesired = desiredPosition - targetHRP.Position
        if vectorToDesired:Dot(targetLookVector) > 0 then
            desiredPosition = basePosition
        end

        -- تحريك سلس بسلاسة
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

    -- تشغيل Bang على لاعب محدد
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

    -- تحديث FollowTarget كل إطار رسم
    RS:BindToRenderStep("BangFollow", Enum.RenderPriority.Character.Value + 2, function()
        if BangActive then
            FollowTarget()
        end
    end)
end

-- =================== صفحة ESP & Fly ======================
do
    local page = Pages[2]

    -- تفعيل ESP
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0.4, 0, 0, 40)
    espToggle.Position = UDim2.new(0.1, 0, 0, 20)
    espToggle.BackgroundColor3 = COLORS.purple
    espToggle.Text = "تفعيل ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 20
    espToggle.TextColor3 = COLORS.white
    addUICorner(espToggle, 15)
    espToggle.Parent = page

    -- تفعيل الطيران
    local flyToggle = Instance.new("TextButton")
    flyToggle.Size = UDim2.new(0.4, 0, 0, 40)
    flyToggle.Position = UDim2.new(0.1, 0, 0, 70)
    flyToggle.BackgroundColor3 = COLORS.purple
    flyToggle.Text = "تفعيل الطيران"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.TextColor3 = COLORS.white
    addUICorner(flyToggle, 15)
    flyToggle.Parent = page

    local flying = false
    local flySpeed = 50

    -- ESP: أبسط مثال - تظليل اللاعبين بعلامة فوق الرأس
    local ESP_Labels = {}

    local function CreateESP(plr)
        if ESP_Labels[plr] then return end
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPLabel"
        billboard.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.AlwaysOnTop = true
        billboard.Parent = plr.Character or LocalPlayer.PlayerGui

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 0.5
        label.BackgroundColor3 = COLORS.purple
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.Text = plr.Name
        label.Parent = billboard

        ESP_Labels[plr] = billboard
    end

    local function RemoveESP(plr)
        if ESP_Labels[plr] then
            ESP_Labels[plr]:Destroy()
            ESP_Labels[plr] = nil
        end
    end

    local function ToggleESP(enabled)
        if enabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    CreateESP(plr)
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if espToggle.Text == "إيقاف ESP" then
                    wait(1)
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        CreateESP(plr)
                    end
                end
            end)
            Players.PlayerRemoving:Connect(function(plr)
                RemoveESP(plr)
            end)
        else
            for plr, esp in pairs(ESP_Labels) do
                RemoveESP(plr)
            end
        end
    end

    local espEnabled = false
    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        if espEnabled then
            espToggle.Text = "إيقاف ESP"
        else
            espToggle.Text = "تفعيل ESP"
        end
        ToggleESP(espEnabled)
    end)

    -- نظام الطيران البسيط
    local BodyVelocity = nil
    local BodyGyro = nil

    local function StartFly()
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = hrp

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(9e5, 9e5, 9e5)
        BodyGyro.CFrame = hrp.CFrame
        BodyGyro.Parent = hrp

        flying = true
    end

    local function StopFly()
        if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
        if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
        flying = false
    end

    flyToggle.MouseButton1Click:Connect(function()
        if flying then
            StopFly()
            flyToggle.Text = "تفعيل الطيران"
        else
            StartFly()
            flyToggle.Text = "إيقاف الطيران"
        end
    end)

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe or not flying then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local camCFrame = workspace.CurrentCamera.CFrame
            if input.KeyCode == Enum.KeyCode.W then
                BodyVelocity.Velocity = camCFrame.LookVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.S then
                BodyVelocity.Velocity = -camCFrame.LookVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.A then
                BodyVelocity.Velocity = -camCFrame.RightVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.D then
                BodyVelocity.Velocity = camCFrame.RightVector * flySpeed
            elseif input.KeyCode == Enum.KeyCode.Space then
                BodyVelocity.Velocity = Vector3.new(0, flySpeed, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                BodyVelocity.Velocity = Vector3.new(0, -flySpeed, 0)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input, gpe)
        if gpe or not flying then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

-- =================== صفحة معلوماتي ======================
do
    local page = Pages[3]

    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 30)
    infoLabel.Position = UDim2.new(0, 0, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "معلومات اللاعب"
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 24
    infoLabel.TextColor3 = COLORS.white
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center
    infoLabel.Parent = page

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(0, 100, 0, 100)
    avatarImage.Position = UDim2.new(0.5, -50, 0, 40)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Parent = page

    -- تحميل صورة اللاعب
    local function updateAvatar()
        local userId = LocalPlayer.UserId
        avatarImage.Image = ("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png"):format(userId)
    end
    updateAvatar()

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 30)
    nameLabel.Position = UDim2.new(0, 0, 0, 150)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "الاسم: " .. LocalPlayer.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 20
    nameLabel.TextColor3 = COLORS.white
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = page

    -- رابط الحساب (فقط عرض)
    local userIdLabel = Instance.new("TextLabel")
    userIdLabel.Size = UDim2.new(1, 0, 0, 30)
    userIdLabel.Position = UDim2.new(0, 0, 0, 180)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.Text = "UserId: " .. LocalPlayer.UserId
    userIdLabel.Font = Enum.Font.Gotham
    userIdLabel.TextSize = 18
    userIdLabel.TextColor3 = COLORS.white
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Center
    userIdLabel.Parent = page
end

-- تفعيل التبويب الأول تلقائياً
setActiveTab(1)
