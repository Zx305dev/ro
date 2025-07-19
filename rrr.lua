-- تنظيف المينيو القديم
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

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

local MainFrame = Instance.new("Frame", EliteMenu)
local defaultSize = UDim2.new(0, 560, 0, 360)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 215, 255)
Title.Text = "🔥 Elite V5 PRO 2025 🔥"

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
        isMinimized = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        isMinimized = true
    end
end)

----------------------------------------
-- إنشاء التبويب الرئيسي (صفحة واحدة فقط)
----------------------------------------

local page = Instance.new("Frame", MainFrame)
page.Size = UDim2.new(1, -20, 1, -60)
page.Position = UDim2.new(0, 10, 0, 50)
page.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
addUICorner(page, 18)

-- إدخال اسم اللاعب المستهدف
local targetInput = Instance.new("TextBox", page)
targetInput.Size = UDim2.new(0, 380, 0, 45)
targetInput.Position = UDim2.new(0, 20, 0, 20)
targetInput.PlaceholderText = "أدخل اسم اللاعب المستهدف (جزء من الاسم)"
targetInput.Font = Enum.Font.Gotham
targetInput.TextSize = 22
targetInput.TextColor3 = Color3.fromRGB(230, 230, 230)
targetInput.BackgroundColor3 = Color3.fromRGB(55, 20, 75)
addUICorner(targetInput, 16)

-- زر تفعيل/تعطيل Bang
local toggleBangBtn = Instance.new("TextButton", page)
toggleBangBtn.Size = UDim2.new(0, 140, 0, 45)
toggleBangBtn.Position = UDim2.new(0, 420, 0, 20)
toggleBangBtn.Text = "تفعيل Bang"
toggleBangBtn.Font = Enum.Font.GothamBold
toggleBangBtn.TextSize = 22
toggleBangBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
toggleBangBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
toggleBangBtn.AutoButtonColor = false
addUICorner(toggleBangBtn, 18)

-- شريط سرعة الحركة
local speedLabel = Instance.new("TextLabel", page)
speedLabel.Size = UDim2.new(0, 280, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 80)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 20
speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
speedLabel.Text = "سرعة الحركة: 1.00"

local speedSlider = Instance.new("Frame", page)
speedSlider.Size = UDim2.new(0, 280, 0, 30)
speedSlider.Position = UDim2.new(0, 20, 0, 115)
speedSlider.BackgroundColor3 = Color3.fromRGB(85, 0, 150)
addUICorner(speedSlider, 14)

local fillBar = Instance.new("Frame", speedSlider)
fillBar.Size = UDim2.new(0.1, 0, 1, 0)
fillBar.BackgroundColor3 = Color3.fromRGB(180, 0, 250)
addUICorner(fillBar, 14)

-- التحكم في السحب لشريط السرعة
local dragging = false
local sliderWidth = 280
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
        local posX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, sliderWidth)
        local ratio = posX / sliderWidth
        fillBar.Size = UDim2.new(ratio, 0, 1, 0)
        local speedVal = math.floor(ratio * 200) / 100
        if speedVal < 0.1 then speedVal = 0.1 end
        speedLabel.Text = ("سرعة الحركة: %.2f"):format(speedVal)
        bangSpeed = speedVal
    end
end)

-- متغيرات Bang و Emote
local bangActive = false
local bangSpeed = 1.0
local targetPlayer = nil
local bangConnection = nil

-- معرّف ايموت Dolphin Dance الرسمي
local emoteAssetId = 5938365243

-- دالة للعثور على لاعب بالاسم الجزئي
local function findTargetPlayer(namePart)
    if not namePart or namePart == "" then return nil end
    namePart = namePart:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(namePart) then
            return plr
        end
    end
    return nil
end

local function stopCurrentEmote()
    if currentAnimTrack then
        currentAnimTrack:Stop()
        currentAnimTrack:Destroy()
        currentAnimTrack = nil
    end
    playingEmote = false
end

local currentAnimTrack = nil
local playingEmote = false

-- وظيفة تفعيل/تعطيل Bang مع تشغيل الإيموت خلف اللاعب المستهدف
toggleBangBtn.MouseButton1Click:Connect(function()
    if not bangActive then
        targetPlayer = findTargetPlayer(targetInput.Text)
        if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            createNotification("لم يتم العثور على اللاعب المستهدف")
            return
        end

        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            createNotification("شخصيتك غير جاهزة")
            return
        end

        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        -- تشغيل الإيموت Dolphin Dance على الشخصية
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..emoteAssetId
        currentAnimTrack = humanoid:LoadAnimation(animation)
        currentAnimTrack.Priority = Enum.AnimationPriority.Action
        currentAnimTrack:Play()
        playingEmote = true

        createNotification("تم تفعيل Bang والإيموت على "..targetPlayer.Name)
        bangActive = true
        toggleBangBtn.Text = "تعطيل Bang"
        toggleBangBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)

        bangConnection = RS.Heartbeat:Connect(function()
            if not bangActive or not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                bangConnection:Disconnect()
                bangActive = false
                toggleBangBtn.Text = "تفعيل Bang"
                toggleBangBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
                stopCurrentEmote()
                return
            end

            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            if hrp then
                -- وضع اللاعب خلف الهدف على مسافة قصيرة وثابتة (1.5 studs) مع ارتفاع بسيط (2 studs)
                local behindOffset = targetHRP.CFrame.LookVector * -1.5
                local newPos = targetHRP.Position + behindOffset + Vector3.new(0, 2, 0)

                -- تحريك الشخصية بسلاسة نحو هذا الموقع
                hrp.CFrame = CFrame.new(newPos, targetHRP.Position)

                -- إيقاف تحركات المشي والقفز للمحافظة على الوضع
                humanoid.WalkSpeed = 0
                humanoid.JumpPower = 0
            end
        end)
    else
        if bangConnection then
            bangConnection:Disconnect()
            bangConnection = nil
        end
        bangActive = false
        toggleBangBtn.Text = "تفعيل Bang"
        toggleBangBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)

        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end

        stopCurrentEmote()
        createNotification("تم تعطيل Bang والإيموت")
    end
end)
