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
local Tabs = {"الرئيسية", "Bang", "اللاعب", "Noclip", "الإعدادات"}
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

-- إضافة محتوى بدائي أو شرح لكل صفحة فارغة لتوضيح وجودها
for i, page in pairs(Pages) do
    if #page:GetChildren() == 0 then
        local placeholder = Instance.new("TextLabel", page)
        placeholder.Size = UDim2.new(1, 0, 1, 0)
        placeholder.BackgroundTransparency = 1
        placeholder.TextColor3 = Color3.fromRGB(150, 150, 150)
        placeholder.Font = Enum.Font.Gotham
        placeholder.TextSize = 18
        placeholder.Text = "هذه الصفحة فارغة حالياً. سيتم تحديثها قريباً."
        placeholder.TextWrapped = true
        placeholder.TextXAlignment = Enum.TextXAlignment.Center
        placeholder.TextYAlignment = Enum.TextYAlignment.Center
    end
end

-- تحسين البحث التلقائي عن اللاعب (Autocomplete)
local function findPlayerByPartialName(partial)
    if not partial or partial == "" then return nil end
    partial = partial:lower()
    local matches = {}
    for _, player in pairs(Players:GetPlayers()) do
        local name = player.Name:lower()
        if name:find(partial, 1, true) == 1 then -- يبدأ بنفس الحروف
            table.insert(matches, player)
        end
    end
    if #matches == 0 then return nil end
    return matches[1] -- نرجع أول تطابق
end

-- === صفحة Bang - تحديث نظام البحث والتحديد ===
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

    -- Variables to control Bang
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

    -- تحديث سرعة الحركة من السلايدر
    speedSlider.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relX / speedSlider.AbsoluteSize.X
            moveSpeed = percent * 5 -- سرعة من 0 إلى 5
        end
    end)

    -- Heartbeat لتحريك اللاعب تلقائياً عند تفعيل Bang
    RS.Heartbeat:Connect(function(dt)
        if bangActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            local localHRP = LocalPlayer.Character.HumanoidRootPart
            -- موقع من خلف الهدف مع رفع بسيط للأرتفاع
            local behindPos = targetHRP.CFrame * CFrame.new(0, 1.5, 2.5)
            -- تحرك سلس نحو الموقع
            localHRP.CFrame = localHRP.CFrame:Lerp(behindPos, math.clamp(moveSpeed * dt * 10, 0, 1))
        end
    end)
end

-- === صفحة اللاعب - إضافات سرعة المشي والقفز الخارقة ===
do
    local page = Pages[3]
    page:ClearAllChildren()

    -- سرعة المشي (slider)
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 280, 0, 30)
    speedLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.Text = "سرعة المشي: 16"

    local speedSlider = Instance.new("Frame", page)
    speedSlider.Size = UDim2.new(0, 280, 0, 30)
    speedSlider.Position = UDim2.new(0.1, 0, 0.15, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(30, 140, 40)
    addUICorner(speedSlider, 14)

    local speedFill = Instance.new("Frame", speedSlider)
    speedFill.Size = UDim2.new(0.5, 0, 1, 0)
    speedFill.BackgroundColor3 = Color3.fromRGB(60, 220, 80)
    addUICorner(speedFill, 14)

    local draggingSpeed = false
    speedSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSpeed = true end
    end)
    speedSlider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSpeed = false end
    end)
    speedSlider.InputChanged:Connect(function(input)
        if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
            local percent = relativeX / speedSlider.AbsoluteSize.X
            speedFill.Size = UDim2.new(percent, 0, 1, 0)
            local speedValue = math.floor(percent * 100 * 2) / 2 + 8 -- 8 إلى 108 تقريباً
            speedLabel.Text = "سرعة المشي: " .. tostring(speedValue)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speedValue
            end
        end
    end)

    -- زر القفز الخارقة
    local jumpBtn = Instance.new("TextButton", page)
    jumpBtn.Size = UDim2.new(0, 180, 0, 50)
    jumpBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
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

    -- صفحة Noclip (4) و الإعدادات (5) ... يمكنك استكمالهم بنفس الشكل السابق أو أطلب مني أكملها الآن
end

-- إظهار / إخفاء المينيو بمفتاح H
local menuVisible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        menuVisible = not menuVisible
        EliteMenu.Enabled = menuVisible
        createNotification(menuVisible and "تم إظهار EliteMenu" or "تم إخفاء EliteMenu", 2)
    end
end)

createNotification("تم تحميل Elite V5 PRO 2025 - النسخة المحسنة", 4)
