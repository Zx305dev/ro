-- Full Bang System: Move Slightly Front and Back Behind Target, No Player Manual Movement Allowed

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- حالة تفعيل البنغ
local BangActive = false

-- هدف المتابعة كـ Player instance
local TargetPlayer = nil

-- مدى التذبذب أمام ووراء (بالمتر)
local OSCILLATION_AMPLITUDE = 2.5 -- مقدار التذبذب للأمام والخلف
local OSCILLATION_FREQUENCY = 1.2 -- سرعة التذبذب

-- المسافة الثابتة من اللاعب الهدف (الحد الأقصى للبعد)
local BASE_FOLLOW_DISTANCE = 3.5 -- اللاعب يبقى وراء الهدف على هذا البعد تقريباً

-- دالة البحث عن لاعب بالاسم (يمكن تعديلها لاختيار أقرب لاعب أو غيره)
local function GetPlayerByName(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then
            return plr
        end
    end
    return nil
end

-- منع تحكم اللاعب اليدوي (WASD والقفز)
RS:BindToRenderStep("DisablePlayerInput", Enum.RenderPriority.Character.Value + 4, function()
    if BangActive and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true -- تعطيل التحكم اليدوي بالكامل
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false -- إعادة التحكم اليدوي عند إيقاف البنغ
            end
        end
    end
end)

-- متابعة الهدف مع تذبذب أمامي وخلفي، لكن لا يتعدى الهدف
local function FollowTarget(dt)
    if not BangActive or not TargetPlayer then return end
    if not TargetPlayer.Character then return end
    if not LocalPlayer.Character then return end

    local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not localHRP then return end

    -- اتجاه نظر الهدف (vector أمام اللاعب الهدف)
    local targetLookVector = targetHRP.CFrame.LookVector

    -- الوقت الحالي لحساب التذبذب
    local time = tick()

    -- التذبذب (قيمته بين -OSCILLATION_AMPLITUDE و +OSCILLATION_AMPLITUDE)
    local oscillation = math.sin(time * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE

    -- الموقع الأساسي خلف الهدف (مثلاً 3.5 متر)
    local basePosition = targetHRP.Position - targetLookVector * BASE_FOLLOW_DISTANCE

    -- الموقع المتذبذب: يتحرك أمام وخلف بين حدود ثابتة (لا يتعدى الهدف أبداً)
    -- التذبذب يكون على طول اتجاه نظر الهدف (LookVector) بحيث لا يتعدى نقطة الهدف
    local desiredPosition = basePosition + targetLookVector * oscillation

    -- التحقق أن الموقع لا يتجاوز اللاعب الهدف (أي لا يصبح أمامه)
    local vectorToDesired = desiredPosition - targetHRP.Position
    if vectorToDesired:Dot(targetLookVector) > 0 then
        -- إذا أصبح أمام الهدف، نعيده للخلف عند النقطة الأساسية فقط
        desiredPosition = basePosition
    end

    -- تحريك اللاعب مع توجيه النظر تجاه الهدف بسلاسة
    localHRP.CFrame = CFrame.new(desiredPosition, targetHRP.Position)
end

-- ربط تحديث الحركة
RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function(dt)
    if BangActive then
        FollowTarget(dt)
    end
end)

-- بدء البنغ مع تعيين هدف معين
local function StartBang(targetName)
    local target = GetPlayerByName(targetName)
    if not target then
        warn("لم يتم العثور على الهدف: " .. targetName)
        return false
    end
    TargetPlayer = target
    BangActive = true
    print("تم تشغيل Bang على اللاعب: " .. TargetPlayer.Name)
    return true
end

-- إيقاف البنغ وإعادة التحكم اليدوي
local function StopBang()
    BangActive = false
    TargetPlayer = nil
    print("تم إيقاف Bang وإعادة التحكم اليدوي.")
end

-- واجهة بسيطة لاختبار السكربت (يمكن استبدالها أو دمجها مع منيو أكبر)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BangSystemGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 320, 0, 160)
Frame.Position = UDim2.new(0, 30, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
Frame.BorderSizePixel = 0
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1, -40, 0, 40)
TextBox.Position = UDim2.new(0, 20, 0, 30)
TextBox.PlaceholderText = "أدخل اسم اللاعب الهدف"
TextBox.Font = Enum.Font.GothamBold
TextBox.TextSize = 22
TextBox.TextColor3 = Color3.fromRGB(230, 230, 230)
TextBox.BackgroundColor3 = Color3.fromRGB(70, 25, 100)
Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 12)

local StartBtn = Instance.new("TextButton", Frame)
StartBtn.Size = UDim2.new(0.45, -10, 0, 45)
StartBtn.Position = UDim2.new(0, 20, 0, 90)
StartBtn.Text = "تشغيل Bang"
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 24
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 15)

local StopBtn = Instance.new("TextButton", Frame)
StopBtn.Size = UDim2.new(0.45, -10, 0, 45)
StopBtn.Position = UDim2.new(0.55, -10, 0, 90)
StopBtn.Text = "إيقاف Bang"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 24
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 15)

StartBtn.MouseButton1Click:Connect(function()
    local name = TextBox.Text
    if name == "" then
        warn("يرجى إدخال اسم الهدف.")
        return
    end
    local success = StartBang(name)
    if not success then
        warn("اللاعب غير موجود.")
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    StopBang()
end)
