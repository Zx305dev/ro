-- تنظيف المينيو القديم
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- الخدمات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService") -- لتحميل صورة البروفايل

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
local defaultSize = UDim2.new(0, 560, 0, 500)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -250)
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

-----------------------
-- الصفحة 1 - الرئيسية
-----------------------
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

---------------------------
-- الصفحة 2 - Bang (تحديث مع حركة أمام ووراء)
---------------------------
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
    local oscillationAmount = 1 -- مقدار التحرك للأمام والخلف
    local oscillationSpeed = 3 -- سرعة التحرك ذهاباً وإياباً
    local oscillationTimer = 0

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

            -- حساب حركة ذهاب وإياب أمام وخلف الهدف
            oscillationTimer = oscillationTimer + dt * oscillationSpeed
            local oscillationOffset = math.sin(oscillationTimer) * oscillationAmount

            -- الموقع الأساسي خلف الهدف
            local basePos = targetHRP.CFrame * CFrame.new(0, 1.5, 2.5)
            -- تحرك ذهاب وإياب على محور الـZ بالنسبة للهدف (أمام وخلف)
            local oscillatedPos = basePos * CFrame.new(0, 0, oscillationOffset)

            -- التحريك بسلاسة نحو الموقع المتحرك
            localHRP.CFrame = localHRP.CFrame:Lerp(oscillatedPos, math.clamp(moveSpeed * dt * 10, 0, 1))
        end
    end)
end

--------------------------
-- الصفحة 3 - معلومات اللاعب (محدثة مع صورة البروفايل)
--------------------------
do
    local page = Pages[3]
    page:ClearAllChildren()

    local profileImage = Instance.new("ImageLabel", page)
    profileImage.Size = UDim2.new(0, 100, 0, 100)
    profileImage.Position = UDim2.new(0, 20, 0, 20)
    profileImage.BackgroundColor3 = Color3.fromRGB(60, 20, 90)
    addUICorner(profileImage, 50)
    profileImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png" -- صورة افتراضية

    local playerNameLabel = Instance.new("TextLabel", page)
    playerNameLabel.Size = UDim2.new(0, 300, 0, 30)
    playerNameLabel.Position = UDim2.new(0, 130, 0, 20)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextSize = 26
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerNameLabel.Text = "اسم اللاعب: " .. LocalPlayer.Name

    local userIdLabel = Instance.new("TextLabel", page)
    userIdLabel.Size = UDim2.new(0, 300, 0, 25)
    userIdLabel.Position = UDim2.new(0, 130, 0, 60)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    userIdLabel.Font = Enum.Font.Gotham
    userIdLabel.TextSize = 18
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    userIdLabel.Text = "UserId: " .. tostring(LocalPlayer.UserId)

    local healthLabel = Instance.new("TextLabel", page)
    healthLabel.Size = UDim2.new(0, 300, 0, 25)
    healthLabel.Position = UDim2.new(0, 20, 0, 140)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 22
    healthLabel.TextXAlignment = Enum.TextXAlignment.Left
    healthLabel.Text = "الصحة: غير متاح"

    local armorLabel = Instance.new("TextLabel", page)
    armorLabel.Size = UDim2.new(0, 300, 0, 25)
    armorLabel.Position = UDim2.new(0, 20, 0, 175)
    armorLabel.BackgroundTransparency = 1
    armorLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    armorLabel.Font = Enum.Font.GothamBold
    armorLabel.TextSize = 22
    armorLabel.TextXAlignment = Enum.TextXAlignment.Left
    armorLabel.Text = "الدروع: غير متاح"

    local posLabel = Instance.new("TextLabel", page)
    posLabel.Size = UDim2.new(0, 300, 0, 25)
    posLabel.Position = UDim2.new(0, 20, 0, 210)
    posLabel.BackgroundTransparency = 1
    posLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    posLabel.Font = Enum.Font.GothamBold
    posLabel.TextSize = 22
    posLabel.TextXAlignment = Enum.TextXAlignment.Left
    posLabel.Text = "الموقع: غير متاح"

    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 300, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 245)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 22
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Text = "السرعة: غير متاح"

    RS.Heartbeat:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if humanoid then
                healthLabel.Text = string.format("الصحة: %.0f / %.0f", humanoid.Health, humanoid.MaxHealth)
            end
            -- الدروع في روبلوكس ليست موجودة بشكل افتراضي، يمكن تعديل حسب اللعبة
            armorLabel.Text = "الدروع: غير مدعوم"

            if rootPart then
                local pos = rootPart.Position
                posLabel.Text = string.format("الموقع: X=%.1f, Y=%.1f, Z=%.1f", pos.X, pos.Y, pos.Z)

                local vel = rootPart.Velocity
                local speed = vel.Magnitude
                speedLabel.Text = string.format("السرعة: %.2f", speed)
            end
        end
    end)

    -- تحميل صورة البروفايل من avatar
    local success, userThumbnailUrl = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if success and userThumbnailUrl then
        profileImage.Image = userThumbnailUrl
    end
end

-----------------------------
-- الصفحة 4 - الإعدادات (مثال: تفعيل/تعطيل الهاكات)
-----------------------------
do
    local page = Pages[4]
    page:ClearAllChildren()

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 30)
    infoLabel.Position = UDim2.new(0, 20, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 22
    infoLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    infoLabel.Text = "الإعدادات (تحديث مستقبلي)"

    -- هنا يمكنك إضافة أزرار إعدادات إضافية حسب الطلب
end

---------------------------------
-- الصفحة 5 - معلومات السيرفر
---------------------------------
do
    local page = Pages[5]
    page:ClearAllChildren()

    local serverNameLabel = Instance.new("TextLabel", page)
    serverNameLabel.Size = UDim2.new(1, -40, 0, 40)
    serverNameLabel.Position = UDim2.new(0, 20, 0, 20)
    serverNameLabel.BackgroundTransparency = 1
    serverNameLabel.Font = Enum.Font.GothamBold
    serverNameLabel.TextSize = 28
    serverNameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    serverNameLabel.TextXAlignment = Enum.TextXAlignment.Center
    serverNameLabel.Text = "اسم السيرفر: EL Roleplay"

    local serverDescLabel = Instance.new("TextLabel", page)
    serverDescLabel.Size = UDim2.new(1, -40, 0, 60)
    serverDescLabel.Position = UDim2.new(0, 20, 0, 80)
    serverDescLabel.BackgroundTransparency = 1
    serverDescLabel.Font = Enum.Font.Gotham
    serverDescLabel.TextSize = 20
    serverDescLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    serverDescLabel.TextWrapped = true
    serverDescLabel.Text = "السيرفر الخاص بلعبتك في الفايف إم - يمكنك إضافة المزيد من المعلومات هنا.\nالتواصل والدعم متوفر."

    -- مثال: عرض عدد اللاعبين الحاليين
    local playersCountLabel = Instance.new("TextLabel", page)
    playersCountLabel.Size = UDim2.new(1, -40, 0, 30)
    playersCountLabel.Position = UDim2.new(0, 20, 0, 150)
    playersCountLabel.BackgroundTransparency = 1
    playersCountLabel.Font = Enum.Font.GothamBold
    playersCountLabel.TextSize = 24
    playersCountLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    playersCountLabel.TextXAlignment = Enum.TextXAlignment.Center

    RS.Heartbeat:Connect(function()
        playersCountLabel.Text = "عدد اللاعبين الحاليين: " .. tostring(#Players:GetPlayers())
    end)
end

-----------------
-- إظهار المينيو
-----------------
EliteMenu.Enabled = true
