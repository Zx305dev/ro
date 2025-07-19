-- Full Elite Hack System with Multiple Pages (Bang, Movement, Flight)
-- Author: ChatGPT v2 for FNLOXER (upgraded)
-- DIDDY & FNLOXER Style

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- إعداد الألوان للواجهة (نفس ألوانك مع تحسين بسيط)
local COLORS = {
    background = Color3.fromRGB(25, 25, 30),
    darkBackground = Color3.fromRGB(15, 15, 20),
    purple = Color3.fromRGB(130, 90, 220),
    green = Color3.fromRGB(80, 200, 120),
    red = Color3.fromRGB(220, 50, 50),
    white = Color3.new(1,1,1),
    orange = Color3.fromRGB(255,140,0)
}

-- إنشاء ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHackMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local function addUICorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = inst
end

-- النافذة الرئيسية
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 460, 0, 400)
mainFrame.Position = UDim2.new(0.5, -230, 0.5, -200)
mainFrame.BackgroundColor3 = COLORS.background
addUICorner(mainFrame, 15)
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- شريط التبويبات (Tabs)
local tabs = {"Bang System", "Movement", "Flight"}
local pages = {}
local tabButtons = {}
local currentPage = 1

-- إنشاء أزرار التبويب
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = UDim2.new(0, (i-1)*150 + 20, 0, 15)
    btn.BackgroundColor3 = COLORS.purple
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 12)
    btn.Parent = mainFrame
    tabButtons[i] = btn
end

local function setActivePage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
        tabButtons[i].BackgroundColor3 = (i == index) and COLORS.green or COLORS.purple
    end
    currentPage = index
end

-- ============================
-- 1) صفحة Bang System (مطور منك)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -70)
    page.Position = UDim2.new(0, 20, 0, 70)
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
    targetDropdown.Text = "اختر هدف"
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

    -- مربعات نص سرعة التذبذب والمسافة
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
    startBtn.Text = "تشغيل Bang + Noclip"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 22
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 12)
    startBtn.Parent = page

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 180, 0, 45)
    stopBtn.Position = UDim2.new(0, 260, 0, 310)
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.Text = "إيقاف Bang"
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

    local moveInput = {forward=false, backward=false}

    local function SetNoclip(enabled)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    local function GetPlayerByName(name)
        name = name:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) then
                return plr
            end
        end
        return nil
    end

    local function createNotification(text, duration)
        local notif = Instance.new("TextLabel")
        notif.Size = UDim2.new(0, 300, 0, 45)
        notif.Position = UDim2.new(0.5, -150, 0, 50)
        notif.BackgroundColor3 = COLORS.purple
        notif.TextColor3 = COLORS.white
        notif.Font = Enum.Font.GothamBold
        notif.TextSize = 22
        notif.Text = text
        notif.BackgroundTransparency = 0.2
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

    local function FollowTarget()
        if not BangActive or not TargetPlayer then return end
        if not TargetPlayer.Character then return end
        if not LocalPlayer.Character then return end

        local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local lookVector = targetHRP.CFrame.LookVector
        local posBase = targetHRP.Position - lookVector * BASE_FOLLOW_DISTANCE

        local oscillation = math.sin(tick() * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE
        local desiredPos = posBase + Vector3.new(0, oscillation, 0)

        local moveDirection = Vector3.new(0, 0, 0)
        if moveInput.forward then
            moveDirection = moveDirection + lookVector
        end
        if moveInput.backward then
            moveDirection = moveDirection - lookVector
        end

        local moveSpeed = 7

        local vectorToPlayer = localHRP.Position - targetHRP.Position
        local projectedLength = vectorToPlayer:Dot(lookVector)

        local maxDistance = BASE_FOLLOW_DISTANCE + 1
        local minDistance = BASE_FOLLOW_DISTANCE - 1

        if moveInput.forward and projectedLength > maxDistance then
            moveDirection = Vector3.new(0, 0, 0)
        elseif moveInput.backward and projectedLength < minDistance then
            moveDirection = Vector3.new(0, 0, 0)
        end

        desiredPos = desiredPos + moveDirection * moveSpeed * RS.RenderStepped:Wait()

        local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(localHRP, tweenInfo, {CFrame = CFrame.new(desiredPos, targetHRP.Position)})
        tween:Play()
    end

    local function StartBang(targetName)
        if BangActive then
            createNotification("Bang مفعل بالفعل!", 3)
            return
        end
        local plr = GetPlayerByName(targetName)
        if not plr then
            createNotification("لم يتم العثور على اللاعب: "..targetName, 3)
            return
        end
        if plr == LocalPlayer then
            createNotification("لا يمكنك اختيار نفسك!", 3)
            return
        end
        TargetPlayer = plr
        BangActive = true
        SetNoclip(true)
        createNotification("تم تفعيل Bang على "..plr.Name, 3)
    end

    local function StopBang()
        if not BangActive then
            createNotification("Bang غير مفعل", 3)
            return
        end
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        moveInput.forward = false
        moveInput.backward = false
        createNotification("تم إيقاف Bang وإعادة التحكم", 3)
    end

    startBtn.MouseButton1Click:Connect(function()
        UpdateSpeed()
        UpdateDistance()
        StartBang(targetDropdown.Text)
    end)

    stopBtn.MouseButton1Click:Connect(StopBang)

    RS.RenderStepped:Connect(function()
        if BangActive then
            FollowTarget()
        end
    end)
end

-- ============================
-- 2) صفحة Movement (Speed & JumpPower)
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -70)
    page.Position = UDim2.new(0, 20, 0, 70)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 16"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 22
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 30)
    speedBox.Position = UDim2.new(0, 230, 0, 20)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "16"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 22
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 200, 0, 30)
    jumpLabel.Position = UDim2.new(0, 20, 0, 70)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "JumpPower: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 22
    jumpLabel.TextColor3 = COLORS.white
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = page

    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 80, 0, 30)
    jumpBox.Position = UDim2.new(0, 230, 0, 70)
    jumpBox.BackgroundColor3 = COLORS.background
    jumpBox.Text = "50"
    jumpBox.TextColor3 = COLORS.white
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 22
    addUICorner(jumpBox, 8)
    jumpBox.ClearTextOnFocus = false
    jumpBox.Parent = page

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 290, 0, 50)
    applyBtn.Position = UDim2.new(0, 20, 0, 130)
    applyBtn.BackgroundColor3 = COLORS.orange
    applyBtn.Text = "تطبيق السرعة والقفز"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 24
    applyBtn.TextColor3 = COLORS.white
    addUICorner(applyBtn, 12)
    applyBtn.Parent = page

    local function applyMovement()
        local speedVal = tonumber(speedBox.Text)
        local jumpVal = tonumber(jumpBox.Text)

        if speedVal and speedVal >= 8 and speedVal <= 150 then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedVal
            speedLabel.Text = "Speed: " .. tostring(speedVal)
        else
            speedBox.Text = tostring(LocalPlayer.Character.Humanoid.WalkSpeed)
            createNotification("السرعة يجب أن تكون بين 8 و150", 3)
        end

        if jumpVal and jumpVal >= 0 and jumpVal <= 300 then
            LocalPlayer.Character.Humanoid.JumpPower = jumpVal
            jumpLabel.Text = "JumpPower: " .. tostring(jumpVal)
        else
            jumpBox.Text = tostring(LocalPlayer.Character.Humanoid.JumpPower)
            createNotification("قوة القفز يجب أن تكون بين 0 و300", 3)
        end
    end

    applyBtn.MouseButton1Click:Connect(applyMovement)

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then applyMovement() end
    end)

    jumpBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then applyMovement() end
    end)
end

-- ============================
-- 3) صفحة Flight & Noclip
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -70)
    page.Position = UDim2.new(0, 20, 0, 70)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    local noclipLabel = Instance.new("TextLabel")
    noclipLabel.Size = UDim2.new(0, 300, 0, 30)
    noclipLabel.Position = UDim2.new(0, 20, 0, 20)
    noclipLabel.BackgroundTransparency = 1
    noclipLabel.Text = "Noclip: OFF (اضغط N للتفعيل)"
    noclipLabel.Font = Enum.Font.GothamBold
    noclipLabel.TextSize = 22
    noclipLabel.TextColor3 = COLORS.white
    noclipLabel.TextXAlignment = Enum.TextXAlignment.Left
    noclipLabel.Parent = page

    local flyLabel = Instance.new("TextLabel")
    flyLabel.Size = UDim2.new(0, 300, 0, 30)
    flyLabel.Position = UDim2.new(0, 20, 0, 60)
    flyLabel.BackgroundTransparency = 1
    flyLabel.Text = "Fly: OFF (اضغط F للتفعيل)"
    flyLabel.Font = Enum.Font.GothamBold
    flyLabel.TextSize = 22
    flyLabel.TextColor3 = COLORS.white
    flyLabel.TextXAlignment = Enum.TextXAlignment.Left
    flyLabel.Parent = page

    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Size = UDim2.new(0, 200, 0, 25)
    flySpeedLabel.Position = UDim2.new(0, 20, 0, 110)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "سرعة الطيران: 1"
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 20
    flySpeedLabel.TextColor3 = COLORS.white
    flySpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
    flySpeedLabel.Parent = page

    local flySpeedBox = Instance.new("TextBox")
    flySpeedBox.Size = UDim2.new(0, 80, 0, 25)
    flySpeedBox.Position = UDim2.new(0, 220, 0, 110)
    flySpeedBox.BackgroundColor3 = COLORS.background
    flySpeedBox.Text = "1"
    flySpeedBox.TextColor3 = COLORS.white
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 20
    addUICorner(flySpeedBox, 8)
    flySpeedBox.ClearTextOnFocus = false
    flySpeedBox.Parent = page

    local noclipActive = false
    local flyActive = false
    local flySpeed = 1

    -- تفعيل/إيقاف Noclip
    local function toggleNoclip()
        noclipActive = not noclipActive
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not noclipActive
            end
        end
        noclipLabel.Text = "Noclip: " .. (noclipActive and "ON (اضغط N للتعطيل)" or "OFF (اضغط N للتفعيل)")
        createNotification("Noclip " .. (noclipActive and "مفعل" or "معطل"), 3)
    end

    -- تحكم الطيران Fly
    local bodyVelocity = nil
    local bodyGyro = nil

    local function startFly()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e5, 9e5, 9e5)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp

        flyActive = true
        flyLabel.Text = "Fly: ON (اضغط F للتعطيل)"
        createNotification("Fly مفعل", 3)
    end

    local function stopFly()
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if bodyGyro then
            bodyGyro:Destroy()
            bodyGyro = nil
        end
        flyActive = false
        flyLabel.Text = "Fly: OFF (اضغط F للتفعيل)"
        createNotification("Fly معطل", 3)
    end

    local function toggleFly()
        if flyActive then
            stopFly()
        else
            startFly()
        end
    end

    local function updateFlySpeed()
        local val = tonumber(flySpeedBox.Text)
        if val and val > 0 and val <= 50 then
            flySpeed = val
            flySpeedLabel.Text = "سرعة الطيران: " .. tostring(val)
        else
            flySpeedBox.Text = tostring(flySpeed)
            createNotification("الرجاء إدخال رقم بين 1 و 50 للسرعة", 3)
        end
    end

    flySpeedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then updateFlySpeed() end
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.N then
            toggleNoclip()
        elseif input.KeyCode == Enum.KeyCode.F then
            toggleFly()
        end
    end)

    -- تحكم حركة الطيران مع WASD + الفأرة
    RS.RenderStepped:Connect(function(dt)
        if flyActive and bodyVelocity and bodyGyro then
            local char = LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            local camCF = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.new(0,0,0)

            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

            moveDir = moveDir.Unit
            if moveDir ~= moveDir then -- NaN check
                moveDir = Vector3.new(0,0,0)
            end

            bodyVelocity.Velocity = moveDir * flySpeed * 50
            bodyGyro.CFrame = camCF
        end
    end)
end

-- تعيين الصفحة الأولى مفعلة عند التشغيل
setActivePage(1)

-- ربط أزرار التبويب للصفحات
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
end

-- إظهار/إخفاء القائمة بزر F1
local menuVisible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        menuVisible = not menuVisible
        ScreenGui.Enabled = menuVisible
    end
end)

-- إشعار ترحيب
print("[Elite Hack System] Loaded and Ready! اضغط F1 لفتح القائمة.")
