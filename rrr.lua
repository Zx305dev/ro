-- Elite V5 PRO كامل ومتكامل 2025
-- نسخة محسنة وجاهزة للعمل فورًا مع Bang + ESP + Fly + واجهة عربية قابلة للسحب والتكبير والتصغير
-- صنع بواسطة Alm6eri
--dw
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- الألوان الأساسية
local COLORS = {
    purple = Color3.fromRGB(148, 0, 211),
    white = Color3.fromRGB(255, 255, 255),
    green = Color3.fromRGB(0, 180, 60),
    red = Color3.fromRGB(180, 0, 0),
    darkBackground = Color3.fromRGB(35, 0, 60),
    background = Color3.fromRGB(50, 15, 80),
}

-- دالة لإنشاء UICorner
local function addUICorner(inst, radius)
    local cr = Instance.new("UICorner", inst)
    cr.CornerRadius = UDim.new(0, radius or 12)
    return cr
end

-- دالة للإشعارات مع حركة Fade In و Fade Out
local function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 280, 0, 40)
    notif.Position = UDim2.new(1, 300, 0, 20)
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
    notif.Parent = ScreenGui

    -- تحريك الظهور
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, -20, 0, 20)}):Play()
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()

    delay(duration, function()
        -- تحريك الإختفاء
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 300, 0, 20)}):Play()
        TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play()
        wait(0.4)
        notif:Destroy()
    end)
end

-- إنشاء ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteV5PRO"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Main Frame (واجهة قابلة للسحب والتكبير)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Active = true
MainFrame.Draggable = true

-- عنوان رئيسي
local TitleLabel = Instance.new("TextLabel", MainFrame)
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

local SubTitle = Instance.new("TextLabel", MainFrame)
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Made by Alm6eri"
SubTitle.Font = Enum.Font.GothamBold
SubTitle.TextSize = 16
SubTitle.TextColor3 = COLORS.white
SubTitle.TextXAlignment = Enum.TextXAlignment.Center

-- زر إغلاق
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = COLORS.red
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = COLORS.white
addUICorner(CloseBtn, 15)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- زر تصغير/تكبير الواجهة
local MaxMinBtn = Instance.new("TextButton", MainFrame)
MaxMinBtn.Size = UDim2.new(0, 30, 0, 30)
MaxMinBtn.Position = UDim2.new(1, -70, 0, 5)
MaxMinBtn.BackgroundColor3 = COLORS.purple
MaxMinBtn.Text = "↔"
MaxMinBtn.Font = Enum.Font.GothamBold
MaxMinBtn.TextSize = 20
MaxMinBtn.TextColor3 = COLORS.white
addUICorner(MaxMinBtn, 15)

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

-- Tabs
local Tabs = {"Bang", "ESP & Fly", "معلوماتي"}
local Pages = {}

local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(1, 0, 0, 40)
TabsFrame.Position = UDim2.new(0, 0, 0, 70)
TabsFrame.BackgroundTransparency = 1

local function setActiveTab(index)
    for i, page in pairs(Pages) do
        page.Visible = (i == index)
    end
    for i, btn in pairs(TabsButtons) do
        btn.BackgroundColor3 = (i == index) and COLORS.purple or COLORS.darkBackground
    end
end

local TabsButtons = {}
local btnWidth = 1 / #Tabs
for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Size = UDim2.new(btnWidth, -4, 1, 0)
    btn.Position = UDim2.new((i - 1) * btnWidth, 2, 0, 0)
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 10)
    btn.MouseButton1Click:Connect(function()
        setActiveTab(i)
    end)
    TabsButtons[i] = btn
end

-- انشاء صفحات
for i = 1, #Tabs do
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -120)
    page.Position = UDim2.new(0, 10, 0, 120)
    page.BackgroundTransparency = 1
    page.Visible = false
    Pages[i] = page
end

-- ====================== صفحة Bang ======================
do
    local page = Pages[1]

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, 0, 0, 30)
    infoLabel.Position = UDim2.new(0, 0, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "نظام Bang متحرك مع سرعة قابلة للتعديل"
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextColor3 = COLORS.white
    infoLabel.TextXAlignment = Enum.TextXAlignment.Center

    local targetLabel = Instance.new("TextLabel", page)
    targetLabel.Size = UDim2.new(0.6, 0, 0, 30)
    targetLabel.Position = UDim2.new(0.05, 0, 0, 40)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "اسم الهدف:"
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 18
    targetLabel.TextColor3 = COLORS.white
    targetLabel.TextXAlignment = Enum.TextXAlignment.Left

    local targetBox = Instance.new("TextBox", page)
    targetBox.Size = UDim2.new(0.3, 0, 0, 30)
    targetBox.Position = UDim2.new(0.4, 0, 0, 40)
    targetBox.PlaceholderText = "أدخل اسم اللاعب"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 18
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(targetBox, 10)

    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0.6, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0, 80)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب:"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0.3, 0, 0, 30)
    speedBox.Position = UDim2.new(0.4, 0, 0, 80)
    speedBox.PlaceholderText = "1.2"
    speedBox.Text = "1.2"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedBox, 10)

    local amplitudeLabel = Instance.new("TextLabel", page)
    amplitudeLabel.Size = UDim2.new(0.6, 0, 0, 30)
    amplitudeLabel.Position = UDim2.new(0.05, 0, 0, 120)
    amplitudeLabel.BackgroundTransparency = 1
    amplitudeLabel.Text = "مقدار التذبذب (المسافة):"
    amplitudeLabel.Font = Enum.Font.GothamBold
    amplitudeLabel.TextSize = 18
    amplitudeLabel.TextColor3 = COLORS.white
    amplitudeLabel.TextXAlignment = Enum.TextXAlignment.Left

    local amplitudeBox = Instance.new("TextBox", page)
    amplitudeBox.Size = UDim2.new(0.3, 0, 0, 30)
    amplitudeBox.Position = UDim2.new(0.4, 0, 0, 120)
    amplitudeBox.PlaceholderText = "2.5"
    amplitudeBox.Text = "2.5"
    amplitudeBox.Font = Enum.Font.GothamBold
    amplitudeBox.TextSize = 18
    amplitudeBox.TextColor3 = COLORS.white
    amplitudeBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(amplitudeBox, 10)

    local baseDistanceLabel = Instance.new("TextLabel", page)
    baseDistanceLabel.Size = UDim2.new(0.6, 0, 0, 30)
    baseDistanceLabel.Position = UDim2.new(0.05, 0, 0, 160)
    baseDistanceLabel.BackgroundTransparency = 1
    baseDistanceLabel.Text = "المسافة الأساسية خلف الهدف:"
    baseDistanceLabel.Font = Enum.Font.GothamBold
    baseDistanceLabel.TextSize = 18
    baseDistanceLabel.TextColor3 = COLORS.white
    baseDistanceLabel.TextXAlignment = Enum.TextXAlignment.Left

    local baseDistanceBox = Instance.new("TextBox", page)
    baseDistanceBox.Size = UDim2.new(0.3, 0, 0, 30)
    baseDistanceBox.Position = UDim2.new(0.4, 0, 0, 160)
    baseDistanceBox.PlaceholderText = "3.5"
    baseDistanceBox.Text = "3.5"
    baseDistanceBox.Font = Enum.Font.GothamBold
    baseDistanceBox.TextSize = 18
    baseDistanceBox.TextColor3 = COLORS.white
    baseDistanceBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(baseDistanceBox, 10)

    local startBtn = Instance.new("TextButton", page)
    startBtn.Size = UDim2.new(0.4, 0, 0, 45)
    startBtn.Position = UDim2.new(0.05, 0, 0, 210)
    startBtn.Text = "تشغيل Bang"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 24
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 15)

    local stopBtn = Instance.new("TextButton", page)
    stopBtn.Size = UDim2.new(0.4, 0, 0, 45)
    stopBtn.Position = UDim2.new(0.55, 0, 0, 210)
    stopBtn.Text = "إيقاف Bang"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 24
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 15)

    -- Bang system variables
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_FREQUENCY = tonumber(speedBox.Text) or 1.2
    local OSCILLATION_AMPLITUDE = tonumber(amplitudeBox.Text) or 2.5
    local BASE_FOLLOW_DISTANCE = tonumber(baseDistanceBox.Text) or 3.5

    local function SetNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

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

    local function GetPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    local function FollowTarget(dt)
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

    RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function(dt)
        if BangActive then
            FollowTarget(dt)
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        local name = targetBox.Text
        if name == "" then
            createNotification("يرجى إدخال اسم اللاعب الهدف.", 3)
            return
        end
        local target = GetPlayerByName(name)
        if not target then
            createNotification("اللاعب غير موجود.", 3)
            return
        end
        TargetPlayer = target
        BangActive = true
        OSCILLATION_FREQUENCY = tonumber(speedBox.Text) or 1.2
        OSCILLATION_AMPLITUDE = tonumber(amplitudeBox.Text) or 2.5
        BASE_FOLLOW_DISTANCE = tonumber(baseDistanceBox.Text) or 3.5
        SetNoclip(true)
        createNotification("Bang مفعل على اللاعب: " .. TargetPlayer.Name, 3)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        createNotification("تم إيقاف Bang وإعادة التحكم.", 3)
    end)
end

-- ====================== صفحة ESP و Fly ======================
do
    local page = Pages[2]

    -- ESP variables
    local ESPEnabled = false
    local ESPBoxes = {}

    -- Fly variables
    local FlyEnabled = false
    local flySpeed = 50
    local flyBodyVelocity = nil

    local function parseColor(text)
        local r, g, b = string.match(text, "(%d+),%s*(%d+),%s*(%d+)")
        if r and g and b then
            return Color3.new(tonumber(r)/255, tonumber(g)/255, tonumber(b)/255)
        else
            return COLORS.purple
        end
    end

    local espToggle = Instance.new("TextButton", page)
    espToggle.Size = UDim2.new(0.4, 0, 0, 40)
    espToggle.Position = UDim2.new(0.05, 0, 0, 0)
    espToggle.Text = "تفعيل ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 20
    espToggle.BackgroundColor3 = COLORS.purple
    espToggle.TextColor3 = COLORS.white
    addUICorner(espToggle, 12)

    local espColorLabel = Instance.new("TextLabel", page)
    espColorLabel.Size = UDim2.new(0.4, 0, 0, 30)
    espColorLabel.Position = UDim2.new(0.55, 0, 0, 5)
    espColorLabel.Text = "لون ESP:"
    espColorLabel.TextColor3 = COLORS.white
    espColorLabel.Font = Enum.Font.GothamBold
    espColorLabel.TextSize = 18
    espColorLabel.BackgroundTransparency = 1

    local espColorPicker = Instance.new("TextBox", page)
    espColorPicker.Size = UDim2.new(0.3, 0, 0, 30)
    espColorPicker.Position = UDim2.new(0.75, 0, 0, 5)
    espColorPicker.PlaceholderText = "مثال: 148,0,211"
    espColorPicker.Text = "148,0,211" -- اللون البنفسجي الافتراضي
    espColorPicker.Font = Enum.Font.GothamBold
    espColorPicker.TextSize = 16
    espColorPicker.TextColor3 = COLORS.white
    espColorPicker.BackgroundColor3 = COLORS.darkBackground
    addUICorner(espColorPicker, 10)

    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0.4, 0, 0, 40)
    flyToggle.Position = UDim2.new(0.05, 0, 0, 50)
    flyToggle.Text = "تفعيل الطيران"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.BackgroundColor3 = COLORS.purple
    flyToggle.TextColor3 = COLORS.white
    addUICorner(flyToggle, 12)

    local flySpeedLabel = Instance.new("TextLabel", page)
    flySpeedLabel.Size = UDim2.new(0.6, 0, 0, 30)
    flySpeedLabel.Position = UDim2.new(0.05, 0, 0, 100)
    flySpeedLabel.Text = "سرعة الطيران: " .. tostring(flySpeed)
    flySpeedLabel.TextColor3 = COLORS.white
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 18
    flySpeedLabel.BackgroundTransparency = 1

    local flySpeedBox = Instance.new("TextBox", page)
    flySpeedBox.Size = UDim2.new(0.3, 0, 0, 30)
    flySpeedBox.Position = UDim2.new(0.55, 0, 0, 100)
    flySpeedBox.PlaceholderText = "مثال: 50"
    flySpeedBox.Text = tostring(flySpeed)
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 18
    flySpeedBox.TextColor3 = COLORS.white
    flySpeedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(flySpeedBox, 10)

    local function createESPBox(plr)
        if ESPBoxes[plr] then return end
        local box = Drawing and Drawing.new and Drawing.new("Square")
        if box then
            box.Visible = false
            box.Color = parseColor(espColorPicker.Text)
            box.Thickness = 2
            box.Filled = false
            box.Transparency = 1
            ESPBoxes[plr] = box
        end
    end

    local function removeESPBox(plr)
        if ESPBoxes[plr] then
            ESPBoxes[plr]:Remove()
            ESPBoxes[plr] = nil
        end
    end

    local function updateESP()
        if not ESPEnabled then return end
        for plr, box in pairs(ESPBoxes) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr ~= LocalPlayer then
                local root = plr.Character.HumanoidRootPart
                local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
                if onScreen then
                    box.Position = Vector2.new(pos.X - 25, pos.Y - 50)
                    box.Size = Vector2.new(50, 100)
                    box.Visible = true
                    box.Color = parseColor(espColorPicker.Text)
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end
    end

    espToggle.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        if ESPEnabled then
            espToggle.Text = "إيقاف ESP"
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer then
                    createESPBox(plr)
                end
            end
            createNotification("تم تفعيل ESP", 3)
        else
            espToggle.Text = "تفعيل ESP"
            for plr, _ in pairs(ESPBoxes) do
                removeESPBox(plr)
            end
            createNotification("تم إيقاف ESP", 3)
        end
    end)

    espColorPicker.FocusLost:Connect(function(enter)
        if enter and ESPEnabled then
            for _, box in pairs(ESPBoxes) do
                box.Color = parseColor(espColorPicker.Text)
            end
            createNotification("تم تغيير لون ESP", 3)
        end
    end)

    flyToggle.MouseButton1Click:Connect(function()
        FlyEnabled = not FlyEnabled
        if FlyEnabled then
            flyToggle.Text = "إيقاف الطيران"
            createNotification("تم تفعيل الطيران", 3)
        else
            flyToggle.Text = "تفعيل الطيران"
            createNotification("تم إيقاف الطيران", 3)
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
        end
    end)

    flySpeedBox.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(flySpeedBox.Text)
            if val and val > 1 and val <= 200 then
                flySpeed = val
                flySpeedLabel.Text = "سرعة الطيران: " .. tostring(flySpeed)
                createNotification("تم تغيير سرعة الطيران", 3)
            else
                flySpeedBox.Text = tostring(flySpeed)
            end
        end
    end)

    RunService:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value + 1, function()
        if FlyEnabled and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hrp and humanoid then
                if not flyBodyVelocity then
                    flyBodyVelocity = Instance.new("BodyVelocity", hrp)
                    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                end

                local direction = Vector3.new()
                if UIS:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + workspace.CurrentCamera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - workspace.CurrentCamera.CFrame.LookVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - workspace.CurrentCamera.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + workspace.CurrentCamera.CFrame.RightVector
                end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0,1,0)
                end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                    direction = direction - Vector3.new(0,1,0)
                end

                if direction.Magnitude > 0 then
                    flyBodyVelocity.Velocity = direction.Unit * flySpeed
                    humanoid.PlatformStand = true
                else
                    flyBodyVelocity.Velocity = Vector3.new()
                    humanoid.PlatformStand = false
                end
            end
        else
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end)

    RunService:BindToRenderStep("UpdateESP", Enum.RenderPriority.Camera.Value + 1, function()
        if ESPEnabled then
            updateESP()
        end
    end)
end

-- ====================== صفحة معلومات اللاعب ======================
do
    local page = Pages[3]

    local profilePic = Instance.new("ImageLabel", page)
    profilePic.Size = UDim2.new(0, 128, 0, 128)
    profilePic.Position = UDim2.new(0.5, -64, 0, 20)
    profilePic.BackgroundColor3 = COLORS.darkBackground
    profilePic.BorderSizePixel = 0
    addUICorner(profilePic, 20)

    local nameLabel = Instance.new("TextLabel", page)
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 160)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 24
    nameLabel.TextColor3 = COLORS.purple
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center

    local userIdLabel = Instance.new("TextLabel", page)
    userIdLabel.Size = UDim2.new(1, 0, 0, 25)
    userIdLabel.Position = UDim2.new(0, 0, 0, 210)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.Font = Enum.Font.GothamBold
    userIdLabel.TextSize = 18
    userIdLabel.TextColor3 = COLORS.white
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Center

    local function updatePlayerInfo()
        local plr = LocalPlayer
        if plr then
            profilePic.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"
            nameLabel.Text = "الاسم: " .. plr.Name
            userIdLabel.Text = "معرّف المستخدم: " .. tostring(plr.UserId)
        end
    end

    updatePlayerInfo()

    -- تحديث الصورة كل 10 ثواني
    while true do
        wait(10)
        updatePlayerInfo()
    end
end

-- تفعيل الصفحة الأولى عند بدء السكربت
setActiveTab(1)

-- تشغيل GUI تلقائيًا عند بداية اللعب
ScreenGui.Enabled = true

return ScreenGui
