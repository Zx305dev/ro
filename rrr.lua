-- المتغيرات الأساسية --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- حالات متغيرة --
local isBangActive = false
local isNoclipActive = false
local currentSpeed = 1.5 -- سرعة الحركة الافتراضية
local targetPlayerName = ""
local targetPlayer = nil

-- واجهة المستخدم --
local gui = Instance.new("ScreenGui")
gui.Name = "EliteBangGui"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

-- الوظائف المساعدة --
local function createUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

local function createTween(instance, properties, duration, style, direction)
    return TweenService:Create(instance, TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out), properties)
end

-- وظيفة السحب للنافذة --
local function makeDraggable(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                math.clamp(startPos.X.Scale + delta.X / workspace.CurrentCamera.ViewportSize.X, 0, 1),
                startPos.X.Offset + delta.X,
                math.clamp(startPos.Y.Scale + delta.Y / workspace.CurrentCamera.ViewportSize.Y, 0, 1),
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- انشاء الواجهة الرئيسية --
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 380, 0, 460)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = gui
createUICorner(mainFrame, 20)

makeDraggable(mainFrame)

-- العنوان --
local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 ELITE Bang GUI 18+ Edition"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 0)
titleLabel.TextSize = 24
titleLabel.TextStrokeTransparency = 0.7

-- زر الإغلاق --
local closeButton = Instance.new("TextButton")
closeButton.Parent = mainFrame
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 22
closeButton.TextColor3 = Color3.new(1,1,1)
createUICorner(closeButton, 12)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- قسم معلومات اللاعب --
local playerInfoFrame = Instance.new("Frame")
playerInfoFrame.Parent = mainFrame
playerInfoFrame.Size = UDim2.new(1, -20, 0, 100)
playerInfoFrame.Position = UDim2.new(0, 10, 0, 50)
playerInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
playerInfoFrame.BorderSizePixel = 0
createUICorner(playerInfoFrame, 15)

-- صورة اللاعب
local playerImage = Instance.new("ImageLabel")
playerImage.Parent = playerInfoFrame
playerImage.Size = UDim2.new(0, 80, 0, 80)
playerImage.Position = UDim2.new(0, 10, 0, 10)
playerImage.BackgroundTransparency = 1
playerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=420&h=420"

-- اسم اللاعب
local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Parent = playerInfoFrame
playerNameLabel.Size = UDim2.new(1, -100, 0, 40)
playerNameLabel.Position = UDim2.new(0, 100, 0, 20)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = "اسمك: "..LocalPlayer.Name
playerNameLabel.Font = Enum.Font.GothamBold
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.TextSize = 20
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left

-- حالة الاتصال / وقت اللعب (مثال بسيط)
local playtimeLabel = Instance.new("TextLabel")
playtimeLabel.Parent = playerInfoFrame
playtimeLabel.Size = UDim2.new(1, -100, 0, 40)
playtimeLabel.Position = UDim2.new(0, 100, 0, 60)
playtimeLabel.BackgroundTransparency = 1
playtimeLabel.Text = "الجيم بلاي قيد التحديث..."
playtimeLabel.Font = Enum.Font.Gotham
playtimeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
playtimeLabel.TextSize = 16
playtimeLabel.TextXAlignment = Enum.TextXAlignment.Left

-- قسم صفحة معلومات السيرفر --
local serverInfoFrame = Instance.new("Frame")
serverInfoFrame.Parent = mainFrame
serverInfoFrame.Size = UDim2.new(1, -20, 0, 140)
serverInfoFrame.Position = UDim2.new(0, 10, 0, 170)
serverInfoFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
serverInfoFrame.BorderSizePixel = 0
createUICorner(serverInfoFrame, 15)

local serverTitleLabel = Instance.new("TextLabel")
serverTitleLabel.Parent = serverInfoFrame
serverTitleLabel.Size = UDim2.new(1, 0, 0, 30)
serverTitleLabel.Position = UDim2.new(0, 0, 0, 0)
serverTitleLabel.BackgroundTransparency = 1
serverTitleLabel.Text = "🖥️ معلومات السيرفر"
serverTitleLabel.Font = Enum.Font.GothamBold
serverTitleLabel.TextColor3 = Color3.fromRGB(255, 150, 50)
serverTitleLabel.TextSize = 22

local serverDetailsLabel = Instance.new("TextLabel")
serverDetailsLabel.Parent = serverInfoFrame
serverDetailsLabel.Size = UDim2.new(1, -20, 1, -40)
serverDetailsLabel.Position = UDim2.new(0, 10, 0, 35)
serverDetailsLabel.BackgroundTransparency = 1
serverDetailsLabel.Text = ""
serverDetailsLabel.Font = Enum.Font.Gotham
serverDetailsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
serverDetailsLabel.TextSize = 16
serverDetailsLabel.TextWrapped = true
serverDetailsLabel.TextYAlignment = Enum.TextYAlignment.Top

-- تحديث معلومات السيرفر
local function updateServerInfo()
    local maxPlayers = tostring(game.Players.MaxPlayers)
    local currentPlayers = tostring(#game.Players:GetPlayers())
    local serverName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

    serverDetailsLabel.Text = "اسم السيرفر: "..serverName..
        "\nعدد اللاعبين الحالي: "..currentPlayers..
        "\nالحد الأقصى للاعبين: "..maxPlayers..
        "\nID السيرفر: "..tostring(game.JobId)
end
updateServerInfo()

-- مدخل اسم الهدف للبنغ --
local targetInputBox = Instance.new("TextBox")
targetInputBox.Parent = mainFrame
targetInputBox.Size = UDim2.new(1, -20, 0, 35)
targetInputBox.Position = UDim2.new(0, 10, 0, 330)
targetInputBox.PlaceholderText = "اكتب اسم لاعب الهدف لـ Bang"
targetInputBox.ClearTextOnFocus = false
targetInputBox.Font = Enum.Font.Gotham
targetInputBox.TextSize = 18
targetInputBox.TextColor3 = Color3.new(1,1,1)
targetInputBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
createUICorner(targetInputBox, 10)

targetInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local name = targetInputBox.Text
        if name and #name > 0 then
            targetPlayerName = name
            -- بحث حساس لحالة الحروف لتقليل الأخطاء
            targetPlayer = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if string.lower(p.Name) == string.lower(name) then
                    targetPlayer = p
                    break
                end
            end
            if not targetPlayer then
                targetInputBox.Text = ""
                targetInputBox.PlaceholderText = "لا يوجد لاعب بهذا الاسم!"
            else
                targetInputBox.PlaceholderText = "الهدف: "..targetPlayer.Name
            end
        end
    end
end)

-- زر تفعيل/ايقاف Bang مع انيماشن --
local bangButton = Instance.new("TextButton")
bangButton.Parent = mainFrame
bangButton.Size = UDim2.new(1, -20, 0, 50)
bangButton.Position = UDim2.new(0, 10, 0, 380)
bangButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
bangButton.Font = Enum.Font.GothamBold
bangButton.TextSize = 24
bangButton.TextColor3 = Color3.new(1,1,1)
bangButton.Text = "تشغيل Bang ❌"
createUICorner(bangButton, 15)

-- سرعة الحركة --
local speedLabel = Instance.new("TextLabel")
speedLabel.Parent = mainFrame
speedLabel.Size = UDim2.new(1, -20, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 440)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Text = "سرعة الحركة: "..tostring(currentSpeed)

local speedSlider = Instance.new("Frame")
speedSlider.Parent = mainFrame
speedSlider.Size = UDim2.new(1, -20, 0, 20)
speedSlider.Position = UDim2.new(0, 10, 0, 470)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
createUICorner(speedSlider, 10)

local fillBar = Instance.new("Frame")
fillBar.Parent = speedSlider
fillBar.Size = UDim2.new(currentSpeed/3, 0, 1, 0) -- max speed 3
fillBar.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
createUICorner(fillBar, 10)

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
        local speedValue = math.clamp(percent * 3, 0.1, 3)
        currentSpeed = speedValue
        speedLabel.Text = ("سرعة الحركة: %.2f"):format(speedValue)
    end
end)

-- Noclip Toggle --
local noclipActive = false
local noclipButton = Instance.new("TextButton")
noclipButton.Parent = mainFrame
noclipButton.Size = UDim2.new(1, -20, 0, 40)
noclipButton.Position = UDim2.new(0, 10, 0, 510)
noclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
noclipButton.Font = Enum.Font.GothamBold
noclipButton.TextSize = 20
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Text = "تشغيل Noclip ❌"
createUICorner(noclipButton, 15)

noclipButton.MouseButton1Click:Connect(function()
    noclipActive = not noclipActive
    noclipButton.Text = noclipActive and "إيقاف Noclip ✅" or "تشغيل Noclip ❌"
    noclipButton.BackgroundColor3 = noclipActive and Color3.fromRGB(255, 150, 50) or Color3.fromRGB(80, 80, 80)
end)

-- دالة تفعيل/تعطيل النوكليب --
local function setNoclip(state)
    local character = LocalPlayer.Character
    if not character then return end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.CanCollide ~= nil then
            part.CanCollide = not state
        end
    end
end

-- وظيفة البنغ --
local runConnection = nil
bangButton.MouseButton1Click:Connect(function()
    if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        bangButton.Text = "الهدف غير صالح!"
        task.delay(2, function()
            bangButton.Text = isBangActive and "إيقاف Bang ✅" or "تشغيل Bang ❌"
        end)
        return
    end

    isBangActive = not isBangActive
    bangButton.Text = isBangActive and "إيقاف Bang ✅" or "تشغيل Bang ❌"
    bangButton.BackgroundColor3 = isBangActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 30, 30)

    if isBangActive then
        -- تفعيل النوكليب مع البنغ تلقائيًا --
        noclipActive = true
        noclipButton.Text = "إيقاف Noclip ✅"
        noclipButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        setNoclip(true)

        -- تشغيل حلقة تحريك اللاعب --
        local character = LocalPlayer.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        -- أنيميشن Bang (حركة انزلاق أمام الهدف بشكل بطيء) --
        local bangAnimId = "rbxassetid://5077710199" -- مثال على أنيميشن Sliding (يمكن تغييره)
        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
        local animation = Instance.new("Animation")
        animation.AnimationId = bangAnimId
        local playAnim = animator:LoadAnimation(animation)
        playAnim.Looped = true
        playAnim:Play()

        runConnection = RunService.Heartbeat:Connect(function()
            if not isBangActive then
                runConnection:Disconnect()
                playAnim:Stop()
                setNoclip(false)
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                return
            end

            -- تحديث هدف البنغ --
            if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                bangButton.Text = "هدف غير موجود!"
                return
            end

            local targetRoot = targetPlayer.Character.HumanoidRootPart

            -- تحديد موقع الوجه: فوق الرأس بقليل ومن أمامه قليلاً --
            local offset = Vector3.new(0, 1.5, -1) -- فوق الرأس بـ 1.5 متر، وخلفه بمتر واحد (يمكن تعديل)
            local targetCFrame = targetRoot.CFrame * CFrame.new(offset)

            -- توجيه اللاعب ليواجه هدفه --
            local lookAt = CFrame.new(rootPart.Position, targetRoot.Position)

            -- تحريك اللاعب ببطء نحو الوجه --
            rootPart.CFrame = rootPart.CFrame:Lerp(targetCFrame, 0.12)

            -- تطبيق التوجيه --
            rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, lookAt.Y - rootPart.CFrame.Y, 0)

            -- ضبط السرعة وحرية القفز --
            humanoid.WalkSpeed = currentSpeed
            humanoid.JumpPower = 0
        end)
    else
        if runConnection then
            runConnection:Disconnect()
            runConnection = nil
        end
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
            end
            setNoclip(false)
            noclipActive = false
            noclipButton.Text = "تشغيل Noclip ❌"
            noclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        end
    end
end)

-- تحديث صورة اللاعب واسم اللاعب كل 10 ثواني تلقائياً --
task.spawn(function()
    while gui.Parent do
        pcall(function()
            playerImage.Image = "rbxthumb://type=AvatarHeadShot&id="..LocalPlayer.UserId.."&w=420&h=420"
            playerNameLabel.Text = "اسمك: "..LocalPlayer.Name
            updateServerInfo()
        end)
        task.wait(10)
    end
end)

print("[EliteBangGui] Loaded successfully!")

