-- تنظيف المينيو القديم
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- الخدمات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- إنشاء GUI رئيسية
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

local function createNotification(text, duration)
    duration = duration or 3
    local notifGui = Instance.new("ScreenGui", game.CoreGui)
    notifGui.Name = "NotifGui"

    local frame = Instance.new("Frame", notifGui)
    frame.Size = UDim2.new(0, 320, 0, 50)
    frame.Position = UDim2.new(0.5, -160, 0.85, 0)
    frame.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
    frame.BorderSizePixel = 0
    addUICorner(frame, 18)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        notifGui:Destroy()
    end)
end

-- الإطار الرئيسي مع قابلية التصغير والتكبير مع انيميشن سلس
local MainFrame = Instance.new("Frame", EliteMenu)
local defaultSize = UDim2.new(0, 560, 0, 450)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

-- العنوان
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 215, 255)
Title.Text = "🔥 Elite V5 PRO 2025 🔥"

-- زر الإغلاق
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 20, 20)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 30
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.AutoButtonColor = false
addUICorner(CloseBtn, 12)
CloseBtn.MouseEnter:Connect(function()
    tweenColor(CloseBtn, "BackgroundColor3", Color3.fromRGB(255, 50, 50), 0.2)
end)
CloseBtn.MouseLeave:Connect(function()
    tweenColor(CloseBtn, "BackgroundColor3", Color3.fromRGB(190, 20, 20), 0.2)
end)
CloseBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
    createNotification("تم إغلاق Elite V5 PRO")
end)

-- زر تصغير/تكبير المينيو
local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -90, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(170, 140, 30)
MinimizeBtn.Text = "–"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 34
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.AutoButtonColor = false
addUICorner(MinimizeBtn, 12)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        -- تكبير مع أنيميشن سلس
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = defaultSize}):Play()
        for _, p in pairs(Pages) do p.Visible = true end
        isMinimized = false
    else
        -- تصغير مع أنيميشن سلس
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = false end
        end)
        isMinimized = true
    end
end)

-- التبويبات
local Tabs = {"الرئيسية", "Bang", "اللاعب", "الإعدادات", "معلومات السيرفر"}
local TabButtons = {}
Pages = {}

local function createTabButton(name, idx)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.Position = UDim2.new(0, 10 + (idx - 1) * 110, 0, 45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BackgroundColor3 = Color3.fromRGB(65, 15, 85)
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(110, 25, 140), 0.25)
    end)
    btn.MouseLeave:Connect(function()
        if Pages[idx].Visible then
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(90, 20, 120), 0.25)
        else
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(65, 15, 85), 0.25)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for i, p in pairs(Pages) do
            p.Visible = false
            tweenColor(TabButtons[i], "BackgroundColor3", Color3.fromRGB(65, 15, 85), 0.25)
        end
        Pages[idx].Visible = true
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(90, 20, 120), 0.25)
    end)

    return btn
end

for i, tabName in ipairs(Tabs) do
    TabButtons[i] = createTabButton(tabName, i)
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -90)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
    page.Visible = (i == 1)
    addUICorner(page, 18)
    Pages[i] = page
end

-- الصفحة 1 - الرئيسية (يمكن تعديلها أو إضافة أي أدوات)
do
    local page = Pages[1]
    page:ClearAllChildren()
    local welcomeLabel = Instance.new("TextLabel", page)
    welcomeLabel.Size = UDim2.new(1, 0, 0, 60)
    welcomeLabel.Position = UDim2.new(0, 0, 0, 20)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 26
    welcomeLabel.Text = "مرحباً بك في Elite V5 PRO 2025!"
    welcomeLabel.TextWrapped = true
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.TextYAlignment = Enum.TextYAlignment.Center

    local descLabel = Instance.new("TextLabel", page)
    descLabel.Size = UDim2.new(1, -20, 0, 40)
    descLabel.Position = UDim2.new(0, 10, 0, 90)
    descLabel.BackgroundTransparency = 1
    descLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextSize = 16
    descLabel.Text = "استخدم القائمة للتنقل بين الخيارات وتفعيل الهاكات بسهولة."
    descLabel.TextWrapped = true
    descLabel.TextXAlignment = Enum.TextXAlignment.Center
end

-- الصفحة 2 - Bang (الكود السابق مع البحث الذكي)
do
    local page = Pages[2]
    page:ClearAllChildren()

    local targetInput = Instance.new("TextBox", page)
    targetInput.Size = UDim2.new(0, 280, 0, 40)
    targetInput.Position = UDim2.new(0.05, 0, 0.1, 0)
    targetInput.PlaceholderText = "أدخل اسم اللاعب المستهدف (أول حرفين كافي)"
    targetInput.Font = Enum.Font.Gotham
    targetInput.TextSize = 22
    targetInput.TextColor3 = Color3.fromRGB(230, 230, 230)
    targetInput.BackgroundColor3 = Color3.fromRGB(55, 20, 75)
    addUICorner(targetInput, 14)

    local toggleBangBtn = Instance.new("TextButton", page)
    toggleBangBtn.Size = UDim2.new(0, 160, 0, 50)
    toggleBangBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
    toggleBangBtn.Text = "تفعيل Bang (من خلف الهدف)"
    toggleBangBtn.Font = Enum.Font.GothamBold
    toggleBangBtn.TextSize = 20
    toggleBangBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    toggleBangBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
    toggleBangBtn.AutoButtonColor = false
    addUICorner(toggleBangBtn, 18)

    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 280, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.Text = "سرعة الحركة: 0.5"

    local speedSlider = Instance.new("Frame", page)
    speedSlider.Size = UDim2.new(0, 280, 0, 30)
    speedSlider.Position = UDim2.new(0.05, 0, 0.3, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(85, 0, 150)
    addUICorner(speedSlider, 14)

    local fillBar = Instance.new("Frame", speedSlider)
    fillBar.Size = UDim2.new(0.5, 0, 1, 0)
    fillBar.BackgroundColor3 = Color3.fromRGB(220, 20, 220)
    addUICorner(fillBar, 14)

    local dragging = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    speedSlider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relX / speedSlider.AbsoluteSize.X
            fillBar.Size = UDim2.new(percent, 0, 1, 0)
            speedLabel.Text = "سرعة الحركة: " .. string.format("%.2f", percent)
        end
    end)

    local function findPlayerByPartialName(partial)
        if not partial or partial == "" then return nil end
        partial = partial:lower()
        local matches = {}
        for _, player in pairs(Players:GetPlayers()) do
            local name = player.Name:lower()
            if name:find(partial, 1, true) == 1 then
                table.insert(matches, player)
            end
        end
        if #matches == 0 then return nil end
        return matches[1]
    end

    local bangActive = false
    local moveSpeed = 0.5
    local targetPlayer = nil

    toggleBangBtn.MouseButton1Click:Connect(function()
        local inputText = targetInput.Text
        local playerFound = findPlayerByPartialName(inputText)
        if not playerFound then
            createNotification("لم يتم العثور على لاعب بهذا الاسم", 3)
            return
        end
        targetPlayer = playerFound
        bangActive = not bangActive
        toggleBangBtn.Text = bangActive and ("إيقاف Bang على " .. targetPlayer.Name) or "تفعيل Bang (من خلف الهدف)"
        createNotification(bangActive and ("تم تفعيل Bang على " .. targetPlayer.Name) or "تم إيقاف Bang", 3)
    end)

    speedSlider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relX / speedSlider.AbsoluteSize.X
            moveSpeed = percent * 5
        end
    end)

    RS.Heartbeat:Connect(function(dt)
        if bangActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            local localHRP = LocalPlayer.Character.HumanoidRootPart
            local behindPos = targetHRP.CFrame * CFrame.new(0, 1.5, 2.5)
            localHRP.CFrame = localHRP.CFrame:Lerp(behindPos, math.clamp(moveSpeed * dt * 10, 0, 1))
        end
    end)
end

-- الصفحة 3 - معلومات اللاعب الكاملة
do
    local page = Pages[3]
    page:ClearAllChildren()

    local function createInfoLabel(text, posY)
        local label = Instance.new("TextLabel", page)
        label.Size = UDim2.new(1, -40, 0, 30)
        label.Position = UDim2.new(0, 20, 0, posY)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = text
        return label
    end

    local playerNameLabel = createInfoLabel("اسم اللاعب: " .. LocalPlayer.Name, 10)
    local userIdLabel = createInfoLabel("UserId: " .. tostring(LocalPlayer.UserId), 45)
    local healthLabel = createInfoLabel("الصحة: غير متاح", 80)
    local armorLabel = createInfoLabel("الدروع: غير متاح", 115)
    local posLabel = createInfoLabel("الموقع: غير متاح", 150)
    local speedLabel = createInfoLabel("السرعة: غير متاح", 185)
    local velLabel = createInfoLabel("السرعة الحالية: غير متاح", 220)

    RS.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                healthLabel.Text = string.format("الصحة: %.0f / %.0f", humanoid.Health, humanoid.MaxHealth)
            end
            if humanoid and humanoid:FindFirstChild("Armor") then
                armorLabel.Text = "الدروع: " .. tostring(humanoid.Armor.Value)
            else
                armorLabel.Text = "الدروع: غير متاح"
            end
            if rootPart then
                local pos = rootPart.Position
                posLabel.Text = string.format("الموقع: X=%.1f Y=%.1f Z=%.1f", pos.X, pos.Y, pos.Z)
                local vel = rootPart.Velocity
                velLabel.Text = string.format("السرعة الحالية: X=%.1f Y=%.1f Z=%.1f", vel.X, vel.Y, vel.Z)
                speedLabel.Text = string.format("السرعة: %.1f", vel.Magnitude)
            else
                posLabel.Text = "الموقع: غير متاح"
                velLabel.Text = "السرعة الحالية: غير متاح"
                speedLabel.Text = "السرعة: غير متاح"
            end
        else
            healthLabel.Text = "الصحة: غير متاح"
            armorLabel.Text = "الدروع: غير متاح"
            posLabel.Text = "الموقع: غير متاح"
            speedLabel.Text = "السرعة: غير متاح"
            velLabel.Text = "السرعة الحالية: غير متاح"
        end
    end)

    -- أزرار لتعديل سرعة المشي والقفز
    local speedBtn = Instance.new("TextButton", page)
    speedBtn.Size = UDim2.new(0, 180, 0, 45)
    speedBtn.Position = UDim2.new(0, 20, 0, 260)
    speedBtn.Text = "زيادة سرعة المشي"
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.TextSize = 22
    speedBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 180)
    speedBtn.TextColor3 = Color3.new(1, 1, 1)
    addUICorner(speedBtn, 12)

    speedBtn.MouseButton1Click:Connect(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 100
            createNotification("تم زيادة سرعة المشي لـ 100", 3)
        end
    end)

    local jumpBtn = Instance.new("TextButton", page)
    jumpBtn.Size = UDim2.new(0, 180, 0, 45)
    jumpBtn.Position = UDim2.new(0, 220, 0, 260)
    jumpBtn.Text = "قفزة خارقة"
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 22
    jumpBtn.BackgroundColor3 = Color3.fromRGB(45, 100, 180)
    jumpBtn.TextColor3 = Color3.new(1, 1, 1)
    addUICorner(jumpBtn, 12)

    jumpBtn.MouseButton1Click:Connect(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = 150
            createNotification("تم تفعيل القفزة الخارقة!", 3)
            task.delay(7, function()
                if humanoid then
                    humanoid.JumpPower = 50
                    createNotification("تم إعادة قوة القفز للوضع الطبيعي", 3)
                end
            end)
        end
    end)
end

-- الصفحة 4 - الإعدادات
do
    local page = Pages[4]
    page:ClearAllChildren()

    local espToggle = Instance.new("TextButton", page)
    espToggle.Size = UDim2.new(0, 200, 0, 50)
    espToggle.Position = UDim2.new(0.1, 0, 0.1, 0)
    espToggle.Text = "تبديل ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 24
    espToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    espToggle.TextColor3 = Color3.new(1, 1, 1)
    espToggle.AutoButtonColor = false
    addUICorner(espToggle, 16)

    local espActive = false
    espToggle.MouseButton1Click:Connect(function()
        espActive = not espActive
        espToggle.Text = espActive and "تعطيل ESP" or "تبديل ESP"
        createNotification(espActive and "تم تفعيل ESP" or "تم تعطيل ESP", 3)
        -- هنا تضيف كود ESP عند التفعيل
    end)

    local nightModeToggle = Instance.new("TextButton", page)
    nightModeToggle.Size = UDim2.new(0, 200, 0, 50)
    nightModeToggle.Position = UDim2.new(0.1, 0, 0.3, 0)
    nightModeToggle.Text = "تبديل الوضع الليلي"
    nightModeToggle.Font = Enum.Font.GothamBold
    nightModeToggle.TextSize = 24
    nightModeToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    nightModeToggle.TextColor3 = Color3.new(1, 1, 1)
    nightModeToggle.AutoButtonColor = false
    addUICorner(nightModeToggle, 16)

    local nightActive = false
    nightModeToggle.MouseButton1Click:Connect(function()
        nightActive = not nightActive
        nightModeToggle.Text = nightActive and "تعطيل الوضع الليلي" or "تبديل الوضع الليلي"
        createNotification(nightActive and "تم تفعيل الوضع الليلي" or "تم تعطيل الوضع الليلي", 3)
        -- أضف كود تعديل الإضاءة هنا
    end)

    local showServerInfoToggle = Instance.new("TextButton", page)
    showServerInfoToggle.Size = UDim2.new(0, 200, 0, 50)
    showServerInfoToggle.Position = UDim2.new(0.1, 0, 0.5, 0)
    showServerInfoToggle.Text = "عرض معلومات السيرفر"
    showServerInfoToggle.Font = Enum.Font.GothamBold
    showServerInfoToggle.TextSize = 24
    showServerInfoToggle.BackgroundColor3 = Color3.fromRGB(50, 0, 100)
    showServerInfoToggle.TextColor3 = Color3.new(1, 1, 1)
    showServerInfoToggle.AutoButtonColor = false
    addUICorner(showServerInfoToggle, 16)

    local showServerInfo = false
    showServerInfoToggle.MouseButton1Click:Connect(function()
        showServerInfo = not showServerInfo
        showServerInfoToggle.Text = showServerInfo and "إخفاء معلومات السيرفر" or "عرض معلومات السيرفر"
        Pages[5].Visible = showServerInfo
        createNotification(showServerInfo and "تم عرض معلومات السيرفر" or "تم إخفاء معلومات السيرفر", 3)
    end)
end

-- الصفحة 5 - معلومات السيرفر
do
    local page = Pages[5]
    page.Visible = false
    page:ClearAllChildren()

    local playerCountLabel = Instance.new("TextLabel", page)
    playerCountLabel.Size = UDim2.new(1, -40, 0, 30)
    playerCountLabel.Position = UDim2.new(0, 20, 0, 20)
    playerCountLabel.BackgroundTransparency = 1
    playerCountLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    playerCountLabel.Font = Enum.Font.GothamBold
    playerCountLabel.TextSize = 22
    playerCountLabel.TextXAlignment = Enum.TextXAlignment.Left

    local serverTimeLabel = Instance.new("TextLabel", page)
    serverTimeLabel.Size = UDim2.new(1, -40, 0, 30)
    serverTimeLabel.Position = UDim2.new(0, 20, 0, 60)
    serverTimeLabel.BackgroundTransparency = 1
    serverTimeLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    serverTimeLabel.Font = Enum.Font.GothamBold
    serverTimeLabel.TextSize = 22
    serverTimeLabel.TextXAlignment = Enum.TextXAlignment.Left

    local pingLabel = Instance.new("TextLabel", page)
    pingLabel.Size = UDim2.new(1, -40, 0, 30)
    pingLabel.Position = UDim2.new(0, 20, 0, 100)
    pingLabel.BackgroundTransparency = 1
    pingLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    pingLabel.Font = Enum.Font.GothamBold
    pingLabel.TextSize = 22
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left

    RunService.Heartbeat:Connect(function()
        local playerCount = #Players:GetPlayers()
        playerCountLabel.Text = "عدد اللاعبين في السيرفر: " .. playerCount

        -- الوقت المحلي في السيرفر (تاريخ ووقت الجهاز المحلي هنا)
        local timeNow = os.date("*t")
        serverTimeLabel.Text = string.format("الوقت الحالي: %02d:%02d:%02d", timeNow.hour, timeNow.min, timeNow.sec)

        -- Ping تقريبي (لو كانت خاصية متاحة)
        local pingValue = LocalPlayer:GetNetworkPing()
        pingLabel.Text = string.format("Ping: %.0f ms", pingValue * 1000)
    end)
end

-- إظهار/إخفاء المينيو بمفتاح H
local menuVisible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        menuVisible = not menuVisible
        EliteMenu.Enabled = menuVisible
        createNotification(menuVisible and "تم إظهار EliteMenu" or "تم إخفاء EliteMenu", 2)
    end
end)

createNotification("تم تحميل Elite V5 PRO 2025 - النسخة المحسنة مع صفحات كاملة", 4)
