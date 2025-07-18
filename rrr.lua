--[[
🔥 Elite V5 PRO 2025 - الإصدار المحسّن 🔥
سكربت كامل مع تحسينات قوية + نظام Bang خلف الهدف + Noclip + تحكم كامل بالسرعة والحركة + واجهة مستخدم متطورة
--]]

-- تنظيف المينيو القديم
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- الخدمات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- إنشاء GUI رئيسية
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- دوال مساعدة لتجميل الواجهة
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

-- إنشاء الإطار الرئيسي للمينيو
local MainFrame = Instance.new("Frame", EliteMenu)
MainFrame.Size = UDim2.new(0, 560, 0, 450)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

-- العنوان العلوي
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

-- زر تصغير المينيو
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
        MainFrame.Size = UDim2.new(0, 560, 0, 450)
        for _, p in pairs(Pages) do p.Visible = true end
        isMinimized = false
    else
        MainFrame.Size = UDim2.new(0, 560, 0, 45)
        for _, p in pairs(Pages) do p.Visible = false end
        isMinimized = true
    end
end)

-- قائمة التبويبات (Tabs)
local Tabs = {"الرئيسية", "Bang", "اللاعب", "Noclip", "الإعدادات"}
local TabButtons = {}
local Pages = {}

-- إنشاء أزرار التبويبات والصفحات
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

-- === صفحة Bang - تنفيذ حركة Bang من خلف الهدف مع تحكم كامل ===
do
    local page = Pages[2]

    -- مدخل اسم اللاعب المستهدف
    local targetInput = Instance.new("TextBox", page)
    targetInput.Size = UDim2.new(0, 280, 0, 40)
    targetInput.Position = UDim2.new(0.05, 0, 0.1, 0)
    targetInput.PlaceholderText = "أدخل اسم اللاعب المستهدف"
    targetInput.Font = Enum.Font.Gotham
    targetInput.TextSize = 22
    targetInput.TextColor3 = Color3.fromRGB(230, 230, 230)
    targetInput.BackgroundColor3 = Color3.fromRGB(55, 20, 75)
    addUICorner(targetInput, 14)

    -- زر تشغيل / إيقاف Bang
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

    -- شريط سرعة الحركة
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
            local relativeX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relativeX / speedSlider.AbsoluteSize.X
            fillBar.Size = UDim2.new(percent, 0, 1, 0)
            local speedValue = math.floor(percent * 100) / 100
            speedLabel.Text = "سرعة الحركة: " .. tostring(speedValue)
        end
    end)

    local isBangActive = false
    local currentSpeed = 0.5

    toggleBangBtn.MouseButton1Click:Connect(function()
        isBangActive = not isBangActive
        toggleBangBtn.Text = isBangActive and "إيقاف Bang" or "تفعيل Bang (من خلف الهدف)"
        createNotification(isBangActive and "Bang مفعّل" or "Bang متوقف", 3)
    end)

    -- تفعيل noclip بتبديل CanCollide لكل أجزاء الشخصية
    local function noclip(state)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state and true or false
            end
        end
    end

    RS.Heartbeat:Connect(function()
        if isBangActive then
            local targetName = targetInput.Text
            if not targetName or targetName == "" then return end

            local targetPlayer = nil
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Name:lower():find(targetName:lower()) then
                    targetPlayer = plr
                    break
                end
            end

            if not targetPlayer then return end
            local targetChar = targetPlayer.Character
            local localChar = LocalPlayer.Character
            if not targetChar or not localChar then return end

            local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
            local localHRP = localChar:FindFirstChild("HumanoidRootPart")
            if not targetHRP or not localHRP then return end

            noclip(true)

            -- سرعة الحركة من السلايدر
            currentSpeed = tonumber(speedLabel.Text:match("%d+%.?%d*")) or 0.5
            local speed = math.clamp(currentSpeed, 0.1, 3)

            -- تحديد موقع خلف الهدف + ارتفاع مناسب
            local backOffset = targetHRP.CFrame.LookVector * -2.5
            local upOffset = Vector3.new(0, 1.5, 0)

            local desiredPos = targetHRP.Position + backOffset + upOffset

            -- تحريك سلس للاعب باستخدام Lerp (يفضل أقل قيمة للـ Alpha لتخفيف التقطيع)
            local currentPos = localHRP.Position
            local lerpAlpha = 0.07 * speed
            local newPos = currentPos:Lerp(desiredPos, lerpAlpha)

            -- تعيين CFrame مع النظر باتجاه الهدف
            localHRP.CFrame = CFrame.new(newPos, targetHRP.Position)

            -- خفض سرعة المشي والقفز للسيطرة الكاملة
            local humanoid = localChar:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        else
            noclip(false)
            -- إعادة السرعة للقيم الأصلية
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
        end
    end)
end

-- === صفحة اللاعب - معلومات وتعديلات ===
do
    local page = Pages[3]

    -- زر Heal اللاعب
    local healBtn = Instance.new("TextButton", page)
    healBtn.Size = UDim2.new(0, 180, 0, 50)
    healBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
    healBtn.Text = "Heal اللاعب"
    healBtn.Font = Enum.Font.GothamBold
    healBtn.TextSize = 22
    healBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
    healBtn.TextColor3 = Color3.new(1, 1, 1)
    healBtn.AutoButtonColor = false
    addUICorner(healBtn, 16)

    healBtn.MouseEnter:Connect(function()
        tweenColor(healBtn, "BackgroundColor3", Color3.fromRGB(20, 200, 100), 0.3)
    end)
    healBtn.MouseLeave:Connect(function()
        tweenColor(healBtn, "BackgroundColor3", Color3.fromRGB(0, 150, 80), 0.3)
    end)

    healBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if not char then
            createNotification("لم يتم العثور على الشخصية!", 3)
            return
        end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            createNotification("تم شفاء اللاعب بالكامل!", 3)
        end
    end)

    -- أزرار زيادة السرعة والقفز
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 280, 0, 30)
    speedLabel.Position = UDim2.new(0.1, 0, 0.3, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.Text = "سرعة المشي: 16"

    local speedSlider = Instance.new("Frame", page)
    speedSlider.Size = UDim2.new(0, 280, 0, 30)
    speedSlider.Position = UDim2.new(0.1, 0, 0.35, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(30, 140, 40)
    addUICorner(speedSlider, 14)

    local speedFill = Instance.new("Frame", speedSlider)
    speedFill.Size = UDim2.new(1, 0, 1, 0)
    speedFill.BackgroundColor3 = Color3.fromRGB(60, 220, 80)
    addUICorner(speedFill, 14)

    local draggingSpeed = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSpeed = true
        end
    end)
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSpeed = false
        end
    end)
    speedSlider.InputChanged:Connect(function(input)
        if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relativeX / speedSlider.AbsoluteSize.X
            speedFill.Size = UDim2.new(percent, 0, 1, 0)
            local speedValue = math.floor(percent * 100 * 2) / 2 + 8 -- من 8 إلى 108 تقريباً
            speedLabel.Text = "سرعة المشي: " .. tostring(speedValue)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedValue
            end
        end
    end)

    -- زر القفز السريع
    local jumpBtn = Instance.new("TextButton", page)
    jumpBtn.Size = UDim2.new(0, 180, 0, 50)
    jumpBtn.Position = UDim2.new(0.1, 0, 0.5, 0)
    jumpBtn.Text = "قفزة خارقة (Jump Power)"
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 22
    jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 160)
    jumpBtn.TextColor3 = Color3.new(1, 1, 1)
    jumpBtn.AutoButtonColor = false
    addUICorner(jumpBtn, 16)

    jumpBtn.MouseEnter:Connect(function()
        tweenColor(jumpBtn, "BackgroundColor3", Color3.fromRGB(30, 140, 210), 0.3)
    end)
    jumpBtn.MouseLeave:Connect(function()
        tweenColor(jumpBtn, "BackgroundColor3", Color3.fromRGB(0, 100, 160), 0.3)
    end)

    jumpBtn.MouseButton1Click:Connect(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = 150
            createNotification("تم تفعيل القفزة الخارقة!", 3)
            task.delay(8, function()
                if humanoid then
                    humanoid.JumpPower = 50
                    createNotification("تم إعادة قوة القفز للوضع الطبيعي", 3)
                end
            end)
        end
    end)
end

-- === صفحة Noclip - تفعيل وتعطيل ===
do
    local page = Pages[4]

    local noclipToggle = Instance.new("TextButton", page)
    noclipToggle.Size = UDim2.new(0, 200, 0, 60)
    noclipToggle.Position = UDim2.new(0.2, 0, 0.2, 0)
    noclipToggle.Text = "تفعيل / تعطيل Noclip"
    noclipToggle.Font = Enum.Font.GothamBold
    noclipToggle.TextSize = 24
    noclipToggle.BackgroundColor3 = Color3.fromRGB(160, 0, 160)
    noclipToggle.TextColor3 = Color3.new(1, 1, 1)
    noclipToggle.AutoButtonColor = false
    addUICorner(noclipToggle, 20)

    local noclipActive = false
    local noclipSpeed = 1.5
    local noclipSpeedLabel = Instance.new("TextLabel", page)
    noclipSpeedLabel.Size = UDim2.new(0, 260, 0, 30)
    noclipSpeedLabel.Position = UDim2.new(0.2, 0, 0.35, 0)
    noclipSpeedLabel.BackgroundTransparency = 1
    noclipSpeedLabel.Font = Enum.Font.Gotham
    noclipSpeedLabel.TextSize = 20
    noclipSpeedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    noclipSpeedLabel.Text = "سرعة Noclip: 1.5"

    local speedSlider = Instance.new("Frame", page)
    speedSlider.Size = UDim2.new(0, 260, 0, 30)
    speedSlider.Position = UDim2.new(0.2, 0, 0.4, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(80, 20, 80)
    addUICorner(speedSlider, 16)

    local fillBar = Instance.new("Frame", speedSlider)
    fillBar.Size = UDim2.new(0.5, 0, 1, 0)
    fillBar.BackgroundColor3 = Color3.fromRGB(220, 100, 220)
    addUICorner(fillBar, 16)

    local draggingSpeed = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSpeed = true
        end
    end)
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSpeed = false
        end
    end)
    speedSlider.InputChanged:Connect(function(input)
        if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relativeX / speedSlider.AbsoluteSize.X
            fillBar.Size = UDim2.new(percent, 0, 1, 0)
            noclipSpeed = math.floor(percent * 100) / 50 + 0.5 -- من 0.5 إلى 2.5
            noclipSpeedLabel.Text = "سرعة Noclip: " .. string.format("%.2f", noclipSpeed)
        end
    end)

    noclipToggle.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        noclipToggle.Text = noclipActive and "إيقاف Noclip" or "تفعيل Noclip"
        createNotification(noclipActive and "تم تفعيل Noclip" or "تم تعطيل Noclip", 3)
    end)

    -- حركة Noclip مع WASD و Space / Ctrl
    local velocity = Vector3.new()
    local function getMovementVector()
        local moveDir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        return moveDir.Unit * noclipSpeed
    end

    RS.Heartbeat:Connect(function()
        if noclipActive then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- تعطيل التصادم (noclip)
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end

                local moveVec = getMovementVector()
                if moveVec and moveVec.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + moveVec * RS.Heartbeat:Wait()
                end

                -- تعطيل الجاذبية
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end)
end

-- === صفحة الإعدادات - خيارات عامة وإدخال سكربت خارجي ===
do
    local page = Pages[5]

    local execInput = Instance.new("TextBox", page)
    execInput.Size = UDim2.new(0, 400, 0, 100)
    execInput.Position = UDim2.new(0.05, 0, 0.05, 0)
    execInput.PlaceholderText = "-- أدخل كود Lua هنا لتشغيله"
    execInput.MultiLine = true
    execInput.Font = Enum.Font.Code
    execInput.TextSize = 18
    execInput.TextColor3 = Color3.fromRGB(230, 230, 230)
    execInput.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    addUICorner(execInput, 16)

    local execBtn = Instance.new("TextButton", page)
    execBtn.Size = UDim2.new(0, 180, 0, 50)
    execBtn.Position = UDim2.new(0.7, 0, 0.18, 0)
    execBtn.Text = "تشغيل الكود"
    execBtn.Font = Enum.Font.GothamBold
    execBtn.TextSize = 22
    execBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    execBtn.TextColor3 = Color3.new(1, 1, 1)
    execBtn.AutoButtonColor = false
    addUICorner(execBtn, 16)

    execBtn.MouseButton1Click:Connect(function()
        local code = execInput.Text
        if code == nil or code == "" then
            createNotification("يرجى إدخال كود لتشغيله", 3)
            return
        end
        local func, err = loadstring(code)
        if not func then
            createNotification("خطأ في الكود: "..tostring(err), 5)
            return
        end
        local success, execErr = pcall(func)
        if not success then
            createNotification("حدث خطأ أثناء التنفيذ: "..tostring(execErr), 5)
            return
        end
        createNotification("تم تنفيذ الكود بنجاح!", 3)
    end)
end

-- تفعيل الإظهار والإخفاء بالمفتاح H
local menuVisible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        menuVisible = not menuVisible
        EliteMenu.Enabled = menuVisible
        createNotification(menuVisible and "تم إظهار EliteMenu" or "تم إخفاء EliteMenu", 2)
    end
end)

createNotification("تم تحميل Elite V5 PRO 2025", 4)
