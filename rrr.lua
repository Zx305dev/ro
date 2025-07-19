-- Elite V5 PRO 2025 - نسخة كاملة ومتطورة بدون Emotes
-- نظام Bang متطور: يتبع الهدف مع تذبذب أمامي وخلفي طبيعي
-- دعم كامل للميزات: Speed, Fly, Jump, ESP, Player Info, قوائم متجاوبة

-- تنظيف القائمة القديمة إذا كانت موجودة
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- الخدمات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- إنشاء واجهة المستخدم الرئيسية
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.Parent = game.CoreGui
EliteMenu.ResetOnSpawn = false
EliteMenu.Enabled = true

-- دالة إضافة زوايا مستديرة
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

-- دالة إنشاء إشعارات بتأثيرات Tween
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

-- الإطار الرئيسي للمينيو
local MainFrame = Instance.new("Frame", EliteMenu)
local defaultSize = UDim2.new(0, 560, 0, 480)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

-- عنوان القائمة
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 215, 255)
Title.Text = "🔥 Elite V5 PRO 2025 - New & Improved 🔥"

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
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(190, 20, 20)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
    createNotification("تم إغلاق Elite V5 PRO")
end)

-- زر التصغير
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
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = defaultSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = true end
        end)
        isMinimized = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = false end
        end)
        isMinimized = true
    end
end)

-- إنشاء تبويبات
local Tabs = {"الرئيسية", "Bang System", "معلومات اللاعب"}
local TabButtons = {}
Pages = {}

local function createTabButton(name, idx)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = UDim2.new(0, 10 + (idx - 1) * 185, 0, 45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BackgroundColor3 = Color3.fromRGB(65, 15, 85)
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(110, 25, 140)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if Pages[idx].Visible then
            TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(65, 15, 85)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for i, p in pairs(Pages) do
            p.Visible = false
            TweenService:Create(TabButtons[i], TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(65, 15, 85)}):Play()
        end
        Pages[idx].Visible = true
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()
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

----------------------------
-- Tab 1: الرئيسية (Main Tab)
----------------------------
do
    local page = Pages[1]
    page:ClearAllChildren()

    local options = {
        {Name = "Speed Hack", State = false},
        {Name = "ESP", State = false},
        {Name = "Jump Boost", State = false},
        {Name = "Fly Mode", State = false},
    }

    local labels = {}
    local toggles = {}

    local humanoid = nil
    local function updateHumanoid()
        if LocalPlayer.Character then
            humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        else
            humanoid = nil
        end
    end
    LocalPlayer.CharacterAdded:Connect(updateHumanoid)
    updateHumanoid()

    local flyEnabled = false
    local flySpeed = 50
    local bodyGyro, bodyVelocity

    for i, option in ipairs(options) do
        local label = Instance.new("TextLabel", page)
        label.Size = UDim2.new(0, 200, 0, 35)
        label.Position = UDim2.new(0, 20, 0, 20 + (i - 1) * 50)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 22
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = option.Name
        labels[i] = label

        local toggle = Instance.new("TextButton", page)
        toggle.Size = UDim2.new(0, 80, 0, 35)
        toggle.Position = UDim2.new(0, 230, 0, 20 + (i - 1) * 50)
        toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 20
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Text = "OFF"
        addUICorner(toggle, 14)

        toggle.MouseButton1Click:Connect(function()
            options[i].State = not options[i].State
            toggle.Text = options[i].State and "ON" or "OFF"
            toggle.BackgroundColor3 = options[i].State and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(100, 0, 150)

            if option.Name == "Speed Hack" then
                if humanoid then
                    humanoid.WalkSpeed = options[i].State and 50 or 16
                    createNotification("Speed Hack " .. (options[i].State and "مفعل" or "معطل"))
                end
            elseif option.Name == "Jump Boost" then
                if humanoid then
                    humanoid.JumpPower = options[i].State and 100 or 50
                    createNotification("Jump Boost " .. (options[i].State and "مفعل" or "معطل"))
                end
            elseif option.Name == "Fly Mode" then
                flyEnabled = options[i].State
                if flyEnabled then
                    createNotification("Fly Mode مفعل - استخدم WASD + Space + Ctrl للطيران")
                else
                    createNotification("Fly Mode معطل")
                    if bodyGyro then
                        bodyGyro:Destroy()
                        bodyGyro = nil
                    end
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
                end
            elseif option.Name == "ESP" then
                if options[i].State then
                    createNotification("ESP مفعل")
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not plr.Character:FindFirstChild("BoxESP") then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Name = "BoxESP"
                                box.Adornee = plr.Character.HumanoidRootPart
                                box.AlwaysOnTop = true
                                box.ZIndex = 10
                                box.Size = Vector3.new(2, 5, 1)
                                box.Transparency = 0.6
                                box.Color3 = Color3.fromRGB(255, 0, 0)
                                box.Parent = plr.Character.HumanoidRootPart
                            end
                        end
                    end
                else
                    createNotification("ESP معطل")
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Character and plr.Character:FindFirstChild("BoxESP") then
                            plr.Character.BoxESP:Destroy()
                        end
                    end
                end
            end
        end)
        toggles[i] = toggle
    end

    -- تحكم حركة الطيران Fly Mode
    RS:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value + 1, function()
        if not flyEnabled or not LocalPlayer.Character or not humanoid then return end

        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        local speed = flySpeed

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
        else
            moveDir = Vector3.new(0,0,0)
        end

        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.P = 1e4
            bodyVelocity.Parent = root
        end

        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.P = 1e4
            bodyGyro.Parent = root
        end

        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = cam.CFrame
    end)
end

--------------------------------
-- Tab 2: Bang System
--------------------------------
do
    local page = Pages[2]
    page:ClearAllChildren()

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 50)
    infoLabel.Position = UDim2.new(0, 20, 0, 20)
    infoLabel.BackgroundTransparency = 1
    infoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 22
    infoLabel.Text = "Bang System - يتبع الهدف مع تذبذب طبيعي"

    local toggleBtn = Instance.new("TextButton", page)
    toggleBtn.Size = UDim2.new(0, 120, 0, 40)
    toggleBtn.Position = UDim2.new(0, 20, 0, 80)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 22
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Text = "OFF"
    addUICorner(toggleBtn, 14)

    local bangEnabled = false
    toggleBtn.MouseButton1Click:Connect(function()
        bangEnabled = not bangEnabled
        toggleBtn.Text = bangEnabled and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = bangEnabled and Color3.fromRGB(0, 180, 60) or Color3.fromRGB(120, 0, 180)
        createNotification("Bang System " .. (bangEnabled and "مفعل" or "معطل"))
    end)

    local targetDropdownLabel = Instance.new("TextLabel", page)
    targetDropdownLabel.Size = UDim2.new(0, 120, 0, 25)
    targetDropdownLabel.Position = UDim2.new(0, 160, 0, 88)
    targetDropdownLabel.BackgroundTransparency = 1
    targetDropdownLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    targetDropdownLabel.Font = Enum.Font.Gotham
    targetDropdownLabel.TextSize = 18
    targetDropdownLabel.Text = "اختر هدف:"

    local targetDropdown = Instance.new("TextBox", page)
    targetDropdown.Size = UDim2.new(0, 140, 0, 30)
    targetDropdown.Position = UDim2.new(0, 250, 0, 80)
    targetDropdown.BackgroundColor3 = Color3.fromRGB(50, 15, 90)
    targetDropdown.TextColor3 = Color3.fromRGB(230, 230, 230)
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 20
    targetDropdown.PlaceholderText = "اكتب اسم الهدف"
    addUICorner(targetDropdown, 14)

    local function getPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    -- نظام التتبع مع تذبذب
    local oscillationAmplitude = 3
    local oscillationFrequency = 1.6 -- oscillations per second

    RS:BindToRenderStep("BangSystem", Enum.RenderPriority.Character.Value + 2, function(dt)
        if not bangEnabled then return end
        if not LocalPlayer.Character then return end

        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local targetName = targetDropdown.Text
        if targetName == "" then return end

        local targetPlayer = getPlayerByName(targetName)
        if not targetPlayer or not targetPlayer.Character then return end

        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot then return end

        -- حساب تذبذب أمامي وخلفي بناء على الوقت
        local oscillationOffset = math.sin(tick() * oscillationFrequency * math.pi * 2) * oscillationAmplitude
        -- الاتجاه بين اللاعبين
        local direction = (targetRoot.Position - root.Position).Unit

        -- الموقــع الجديد مع تذبذب أمامي وخلفي (أمام الهدف + أو - التذبذب)
        local offsetPosition = targetRoot.Position + direction * oscillationOffset

        -- تحريك اللاعب بشكل ناعم نحو الموقع الجديد
        root.CFrame = CFrame.new(offsetPosition) * CFrame.Angles(0, math.atan2(direction.X, direction.Z), 0)
    end)
end

------------------------------
-- Tab 3: معلومات اللاعب (Player Info)
------------------------------
do
    local page = Pages[3]
    page:ClearAllChildren()

    local infoTitle = Instance.new("TextLabel", page)
    infoTitle.Size = UDim2.new(1, -40, 0, 50)
    infoTitle.Position = UDim2.new(0, 20, 0, 20)
    infoTitle.BackgroundTransparency = 1
    infoTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.TextSize = 24
    infoTitle.Text = "معلومات اللاعب"

    local infoText = Instance.new("TextLabel", page)
    infoText.Size = UDim2.new(1, -40, 0, 180)
    infoText.Position = UDim2.new(0, 20, 0, 80)
    infoText.BackgroundTransparency = 1
    infoText.TextColor3 = Color3.fromRGB(200, 200, 200)
    infoText.Font = Enum.Font.Gotham
    infoText.TextSize = 20
    infoText.TextWrapped = true
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top

    local function updatePlayerInfo()
        local plr = LocalPlayer
        local char = plr.Character

        if not char then
            infoText.Text = "الشخصية غير موجودة."
            return
        end

        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

        if not humanoid or not hrp then
            infoText.Text = "لا يمكن إيجاد معلومات كافية."
            return
        end

        local health = math.floor(humanoid.Health)
        local maxHealth = math.floor(humanoid.MaxHealth)
        local pos = hrp.Position
        local speed = humanoid.WalkSpeed

        local infoStr = string.format(
            "الاسم: %s\nالصحة: %d / %d\nالإحداثيات: (%.1f, %.1f, %.1f)\nالسرعة الحالية: %d",
            plr.Name,
            health,
            maxHealth,
            pos.X, pos.Y, pos.Z,
            speed
        )

        infoText.Text = infoStr
    end

    RS.RenderStepped:Connect(updatePlayerInfo)
end

-- تنشيط صفحة الرئيسية تلقائياً مع تلوين الزر
TweenService:Create(TabButtons[1], TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()

createNotification("تم تحميل Elite V5 PRO بنجاح! استمتع 😈🔥")
