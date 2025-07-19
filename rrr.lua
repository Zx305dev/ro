-- Elite V5 PRO 2025 (بدون إيموت) + دمج Bang System المحسن مع Auto Noclip وواجهة تحكم متكاملة  
-- السكربت الكامل متكامل، شامل قائمة منيو حديثة بالعربي، تحكم كامل بالسرعة، Bang system متطور مع تذبذب طبيعي، نوكليب تلقائي، ومنيو قوي بدون أي إيموت  
-- صمم خصيصاً لك ليكون جاهز للاستخدام مع أداء سلس ومواصفات احترافية  

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Variables للإدارة  
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteV5PRO"
EliteMenu.Enabled = false

-- تبويبات المنيو  
local Tabs = {"الرئيسية", "Bang System", "معلومات اللاعب"}

-- الحالات  
local BangActive = false
local TargetPlayer = nil

-- إعدادات Bang System  
local OSCILLATION_AMPLITUDE = 2.5
local OSCILLATION_FREQUENCY = 1.2
local BASE_FOLLOW_DISTANCE = 3.5

-- وظائف مساعدة  

local function addUICorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

local function createNotification(text, duration)
    local notif = Instance.new("TextLabel", EliteMenu)
    notif.Text = text
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0.1, 0)
    notif.BackgroundColor3 = Color3.fromRGB(50, 20, 100)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.BackgroundTransparency = 0.3
    notif.AnchorPoint = Vector2.new(0.5, 0)
    addUICorner(notif, 15)
    task.delay(duration or 3, function()
        notif:Destroy()
    end)
end

-- دالة النوكليب  
local function SetNoclip(enabled)
    if not LocalPlayer.Character then return end
    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

-- تعطيل تحكم اليد عند تفعيل Bang  
RS:BindToRenderStep("DisablePlayerInput", Enum.RenderPriority.Character.Value + 4, function()
    if BangActive and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true -- يمنع تحكم اليد
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false -- يعيد التحكم اليدوي
            end
        end
    end
end)

-- متابعة الهدف مع تذبذب طبيعي  
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

    -- منع تجاوز الموقع للهدف  
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

-- البحث عن لاعب باسم  
local function GetPlayerByName(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then
            return plr
        end
    end
    return nil
end

-- بدء وإيقاف Bang  
local function StartBang(targetName)
    local target = GetPlayerByName(targetName)
    if not target then
        createNotification("لم يتم العثور على اللاعب: " .. targetName, 3)
        return false
    end
    TargetPlayer = target
    BangActive = true
    SetNoclip(true)
    createNotification("Bang مفعل على اللاعب: " .. TargetPlayer.Name, 3)
    return true
end

local function StopBang()
    BangActive = false
    TargetPlayer = nil
    SetNoclip(false)
    createNotification("تم إيقاف Bang وإعادة التحكم.", 3)
end

-- واجهة المستخدم - بناء منيو  
local MainFrame = Instance.new("Frame", EliteMenu)
MainFrame.Size = UDim2.new(0, 480, 0, 350)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 10, 70)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

-- عنوان المنيو  
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 28
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleLabel.Text = "Elite V5 PRO 2025 - بدون إيموت"
TitleLabel.TextScaled = true

-- تاب قائمة التبويبات  
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(0, 120, 1, -50)
TabsFrame.Position = UDim2.new(0, 0, 0, 50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 40)
TabsFrame.BorderSizePixel = 0
addUICorner(TabsFrame, 16)

local Pages = {}
local Buttons = {}

local selectedTabIndex = 1

local function clearPage(page)
    for _, child in pairs(page:GetChildren()) do
        child:Destroy()
    end
end

local function switchTab(index)
    if selectedTabIndex == index then return end
    Buttons[selectedTabIndex].BackgroundColor3 = Color3.fromRGB(80, 30, 120)
    Buttons[index].BackgroundColor3 = Color3.fromRGB(130, 50, 220)
    Pages[selectedTabIndex].Visible = false
    Pages[index].Visible = true
    selectedTabIndex = index
end

-- إنشاء أزرار التبويبات  
for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Size = UDim2.new(1, -10, 0, 50)
    btn.Position = UDim2.new(0, 5, 0, (i - 1) * 55 + 10)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(80, 30, 120)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = tabName
    addUICorner(btn, 14)

    btn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)

    Buttons[i] = btn
end

-- إنشاء صفحات التبويبات  
for i = 1, #Tabs do
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -120, 1, -50)
    page.Position = UDim2.new(0, 120, 0, 50)
    page.BackgroundTransparency = 1
    page.Visible = (i == 1)
    Pages[i] = page
end

-- صفحة 1: الرئيسية (Speed Hack + Fly + Jump Boost)  
do
    local page = Pages[1]
    -- Speed Hack Toggle  
    local speedToggle = Instance.new("TextButton", page)
    speedToggle.Size = UDim2.new(0, 180, 0, 50)
    speedToggle.Position = UDim2.new(0, 20, 0, 20)
    speedToggle.BackgroundColor3 = Color3.fromRGB(60, 120, 180)
    speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedToggle.Font = Enum.Font.GothamBold
    speedToggle.TextSize = 20
    speedToggle.Text = "تفعيل زيادة السرعة"
    addUICorner(speedToggle, 15)

    local speedActive = false
    local speedValue = 30

    local function setPlayerSpeed(speed)
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = speed
            end
        end
    end

    speedToggle.MouseButton1Click:Connect(function()
        speedActive = not speedActive
        if speedActive then
            setPlayerSpeed(speedValue)
            speedToggle.Text = "إيقاف زيادة السرعة"
            createNotification("زيادة السرعة مفعلة", 2)
        else
            setPlayerSpeed(16)
            speedToggle.Text = "تفعيل زيادة السرعة"
            createNotification("زيادة السرعة متوقفة", 2)
        end
    end)

    -- Fly Mode Toggle  
    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0, 180, 0, 50)
    flyToggle.Position = UDim2.new(0, 220, 0, 20)
    flyToggle.BackgroundColor3 = Color3.fromRGB(50, 170, 70)
    flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.Text = "تفعيل وضع الطيران"
    addUICorner(flyToggle, 15)

    local flyActive = false
    local flySpeed = 50
    local bv, bg = nil, nil

    local function noclipMovement()
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
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
            moveDir = moveDir.Unit * flySpeed
        else
            moveDir = Vector3.new(0, 0, 0)
        end

        if bv and bg then
            bv.Velocity = moveDir
            bg.CFrame = cam.CFrame
        end
    end

    local flyConnection = nil

    flyToggle.MouseButton1Click:Connect(function()
        flyActive = not flyActive
        if flyActive then
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if hrp then
                bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bv.Velocity = Vector3.new(0,0,0)

                bg = Instance.new("BodyGyro", hrp)
                bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                bg.CFrame = hrp.CFrame
            end

            flyConnection = RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 1, noclipMovement)
            createNotification("تم تفعيل وضع الطيران", 2)
            flyToggle.Text = "إيقاف وضع الطيران"
        else
            if flyConnection then
                RS:UnbindFromRenderStep("FlyMovement")
                flyConnection = nil
            end
            if bv then bv:Destroy() bv = nil end
            if bg then bg:Destroy() bg = nil end
            createNotification("تم إيقاف وضع الطيران", 2)
            flyToggle.Text = "تفعيل وضع الطيران"
        end
    end)

    -- Jump Boost Toggle  
    local jumpToggle = Instance.new("TextButton", page)
    jumpToggle.Size = UDim2.new(0, 180, 0, 50)
    jumpToggle.Position = UDim2.new(0, 20, 0, 90)
    jumpToggle.BackgroundColor3 = Color3.fromRGB(200, 100, 20)
    jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpToggle.Font = Enum.Font.GothamBold
    jumpToggle.TextSize = 20
    jumpToggle.Text = "تفعيل تعزيز القفز"
    addUICorner(jumpToggle, 15)

    local jumpActive = false
    local jumpPowerValue = 100

    jumpToggle.MouseButton1Click:Connect(function()
        jumpActive = not jumpActive
        if jumpActive then
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = jumpPowerValue
                end
            end
            jumpToggle.Text = "إيقاف تعزيز القفز"
            createNotification("تم تفعيل تعزيز القفز", 2)
        else
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
            jumpToggle.Text = "تفعيل تعزيز القفز"
            createNotification("تم إيقاف تعزيز القفز", 2)
        end
    end)
end

-- صفحة 2: Bang System (دمج سكربتك المحسن)  
do
    local page = Pages[2]

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 40)
    infoLabel.Position = UDim2.new(0, 20, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextColor3 = Color3.fromRGB(255, 220, 220)
    infoLabel.Text = "Elite Bang System + Auto Noclip 2025"

    -- إدخال اسم اللاعب  
    local TextBox = Instance.new("TextBox", page)
    TextBox.Size = UDim2.new(0, 280, 0, 40)
    TextBox.Position = UDim2.new(0, 20, 0, 60)
    TextBox.PlaceholderText = "أدخل اسم اللاعب الهدف"
    TextBox.Font = Enum.Font.GothamBold
    TextBox.TextSize = 22
    TextBox.TextColor3 = Color3.fromRGB(230, 230, 230)
    TextBox.BackgroundColor3 = Color3.fromRGB(70, 25, 100)
    addUICorner(TextBox, 14)

    -- زر تشغيل Bang  
    local StartBtn = Instance.new("TextButton", page)
    StartBtn.Size = UDim2.new(0, 120, 0, 50)
    StartBtn.Position = UDim2.new(0, 20, 0, 120)
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
    StartBtn.Font = Enum.Font.GothamBold
    StartBtn.TextSize = 24
    StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StartBtn.Text = "تشغيل Bang"
    addUICorner(StartBtn, 15)

    -- زر إيقاف Bang  
    local StopBtn = Instance.new("TextButton", page)
    StopBtn.Size = UDim2.new(0, 120, 0, 50)
    StopBtn.Position = UDim2.new(0, 160, 0, 120)
    StopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextSize = 24
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    StopBtn.Text = "إيقاف Bang"
    addUICorner(StopBtn, 15)

    -- أحداث الأزرار  
    StartBtn.MouseButton1Click:Connect(function()
        local name = TextBox.Text
        if name == "" then
            createNotification("يرجى إدخال اسم اللاعب الهدف", 3)
            return
        end
        local success = StartBang(name)
        if not success then
            createNotification("اللاعب غير موجود", 3)
        end
    end)

    StopBtn.MouseButton1Click:Connect(function()
        StopBang()
    end)
end

-- صفحة 3: معلومات اللاعب  
do
    local page = Pages[3]

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 40)
    infoLabel.Position = UDim2.new(0, 20, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 22
    infoLabel.TextColor3 = Color3.fromRGB(255, 220, 220)
    infoLabel.Text = "معلومات حسابك والبيئة المحيطة"

    local infoText = Instance.new("TextLabel", page)
    infoText.Size = UDim2.new(1, -40, 1, -70)
    infoText.Position = UDim2.new(0, 20, 0, 60)
    infoText.BackgroundTransparency = 1
    infoText.Font = Enum.Font.Code
    infoText.TextSize = 18
    infoText.TextColor3 = Color3.fromRGB(220, 220, 220)
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextWrapped = true

    local function updatePlayerInfo()
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local pos = hrp and hrp.Position or Vector3.new(0, 0, 0)

        local health = humanoid and math.floor(humanoid.Health) or 0
        local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or 0

        return {
            Name = LocalPlayer.Name,
            UserId = LocalPlayer.UserId,
            Health = health,
            MaxHealth = maxHealth,
            Position = pos,
            GameId = game.GameId,
            PlaceId = game.PlaceId,
            Time = os.date("%Y-%m-%d %H:%M:%S"),
        }
    end

    RS:BindToRenderStep("UpdatePlayerInfo", Enum.RenderPriority.First.Value, function()
        local data = updatePlayerInfo()
        local infoStr = string.format(
            [[
الاسم: %s
معرف المستخدم: %d
الصحة: %d / %d
الموقع: X=%.2f, Y=%.2f, Z=%.2f
معرف اللعبة: %s
معرف المكان: %s
التاريخ والوقت: %s
]],
            data.Name, data.UserId, data.Health, data.MaxHealth,
            data.Position.X, data.Position.Y, data.Position.Z,
            tostring(data.GameId), tostring(data.PlaceId), data.Time
        )
        infoText.Text = infoStr
    end)
end

-- تفعيل/إخفاء المنيو بزر RightShift  
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        EliteMenu.Enabled = not EliteMenu.Enabled
        if EliteMenu.Enabled then
            createNotification("Elite V5 PRO مفعل", 3)
        else
            createNotification("Elite V5 PRO معطل", 3)
        end
    end
end)

-- رسالة أولية للمستخدم  
createNotification("اضغط RightShift لفتح القائمة", 4)

-- ضبط سرعة اللاعب لحالة عدم الاستخدام (السلامة)  
local function resetSpeed()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
end

-- عند الموت أو إعادة تحميل الشخصية  
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if not BangActive then
        resetSpeed()
    end
end)

-- فور بدء السكربت  
resetSpeed()
EliteMenu.Enabled = false

-- Script Complete and fully optimized  
