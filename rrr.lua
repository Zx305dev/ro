-- Elite Bang System + Auto Noclip 2025
-- يتحرك خلف الهدف بتذبذب طبيعي، يمنع تحكم اليد، ويشغل Noclip تلقائي لتجنب المشاكل

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- الحالة
local BangActive = false
local TargetPlayer = nil

-- تذبذب أمامي وخلفي (المتر)
local OSCILLATION_AMPLITUDE = 2.5
local OSCILLATION_FREQUENCY = 1.2

-- بعد ثابت خلف الهدف (المتر)
local BASE_FOLLOW_DISTANCE = 3.5

-- إنشاء الـ Noclip: بتعطيل اصطدام اللاعب مع العالم
local function SetNoclip(enabled)
    if not LocalPlayer.Character then return end
    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not enabled
        end
    end
end

-- تعطيل حركة اليد (WASD + قفز)
RS:BindToRenderStep("DisablePlayerInput", Enum.RenderPriority.Character.Value + 4, function()
    if BangActive and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true -- منع التحكم اليدوي
        end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false -- إعادة التحكم اليدوي
            end
        end
    end
end)

-- متابعة الهدف مع تذبذب أمامي وخلفي بدون تجاوز الهدف
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

-- البحث عن لاعب حسب الاسم
local function GetPlayerByName(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then
            return plr
        end
    end
    return nil
end

-- تشغيل Bang + تفعيل Noclip
local function StartBang(targetName)
    local target = GetPlayerByName(targetName)
    if not target then
        warn("لم يتم العثور على اللاعب: " .. targetName)
        return false
    end
    TargetPlayer = target
    BangActive = true
    SetNoclip(true) -- تفعيل Noclip تلقائياً
    print("Bang مفعل على اللاعب: " .. TargetPlayer.Name)
    return true
end

-- إيقاف Bang + إيقاف Noclip + إعادة التحكم
local function StopBang()
    BangActive = false
    TargetPlayer = nil
    SetNoclip(false) -- إيقاف Noclip
    print("تم إيقاف Bang وإعادة التحكم.")
end

-- واجهة بسيطة للتحكم (اختياري، يمكن دمجها بأي منيو أكبر)

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
        warn("يرجى إدخال اسم اللاعب الهدف.")
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
