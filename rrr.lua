-- Elite V5 PRO Full Bang System - Follow Target From Behind Only
-- يمنع تحريك اللاعب يدوياً أثناء تفعيل Bang System

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- حالة تفعيل البانغ
local BangActive = false

-- اسم الهدف (يمكن تغييره في أي وقت)
local TargetName = ""

-- هدف المتابعة كـ Player instance
local TargetPlayer = nil

-- حفظ حالة input لأجل تعطيل WASD و غيرها أثناء Bang
local inputBlocked = false

-- سرعة التذبذب والمسافة التي سيتم متابعتها من الخلف
local OSCILLATION_AMPLITUDE = 3 -- مقدار التذبذب (بالمتر)
local OSCILLATION_FREQUENCY = 1.5 -- سرعة التذبذب (مرة كل ثانية تقريبًا)
local FOLLOW_DISTANCE = 4 -- المسافة خلف الهدف التي يتبعها اللاعب

-- دالة لجلب اللاعب المستهدف من اسم جزئي
local function GetPlayerByName(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then
            return plr
        end
    end
    return nil
end

-- منع تحكم WASD أثناء البانغ
local function BlockInputs()
    if inputBlocked then return end
    inputBlocked = true
    -- حظر جميع أزرار WASD ومسافات القفز
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if BangActive and not gameProcessed then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode
                if key == Enum.KeyCode.W or key == Enum.KeyCode.A or key == Enum.KeyCode.S or key == Enum.KeyCode.D
                or key == Enum.KeyCode.Space or key == Enum.KeyCode.LeftShift or key == Enum.KeyCode.LeftControl then
                    -- منع التفاعل - بفعل إلغاء الحدث فقط
                    -- لا يوجد cancel في Roblox، الحل هو تجاهل أي input خارجية في التحكم اليدوي باللعبة
                    -- هذه هنا للتمثيل فقط (مش دوماً ناجح)
                end
            end
        end
    end)
end

-- وظيفة إلغاء منع input - تعيد التحكم الطبيعي (قد تكون غير ضرورية حسب بيئة اللعبة)
local function UnblockInputs()
    inputBlocked = false
    -- من الناحية العملية Roblox لا تسمح بإلغاء حدث InputBegan بسهولة
    -- لذا عند BangActive = false يكفي أن نترك النظام لا يتحكم بالشخصية ويفتح المجال للعب يدويًا
end

-- الوظيفة الأساسية: متابعة الهدف مع التذبذب من الخلف
local function FollowTarget(dt)
    if not BangActive or not TargetPlayer then return end
    if not TargetPlayer.Character then return end
    if not LocalPlayer.Character then return end

    local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not localHRP then return end

    -- حساب الاتجاه من اللاعب نحو الهدف (من LocalPlayer للهدف)
    local directionToTarget = (targetHRP.Position - localHRP.Position).Unit

    -- حساب الاتجاه المعاكس (الجهة الخلفية للهدف)
    local targetLookVector = targetHRP.CFrame.LookVector
    local behindPosition = targetHRP.Position - targetLookVector * FOLLOW_DISTANCE

    -- إضافة التذبذب الطبيعي باستخدام دالة الجيب
    local oscillationOffset = math.sin(tick() * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE

    -- حساب إزاحة التذبذب على محور عمودي مع اتجاه الهدف (لإعطاء حركة جانبية خفيفة)
    local rightVector = targetHRP.CFrame.RightVector
    local oscillatedPosition = behindPosition + rightVector * oscillationOffset

    -- تحريك اللاعب إلى الموقع الجديد مع توجيه وجهة اللاعب باتجاه الهدف (نعم، سيواجه الهدف دائماً)
    localHRP.CFrame = CFrame.new(oscillatedPosition, targetHRP.Position)
end

-- ربط Update في كل إطار لتتبع الهدف أثناء تفعيل Bang
RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function(dt)
    if BangActive then
        FollowTarget(dt)
    end
end)

-- وظائف لتشغيل وإيقاف البانغ
local function StartBang(targetName)
    local target = GetPlayerByName(targetName)
    if not target then
        warn("Target not found: " .. targetName)
        return false
    end
    TargetPlayer = target
    BangActive = true
    BlockInputs()
    print("Bang system started on target: " .. TargetPlayer.Name)
    return true
end

local function StopBang()
    BangActive = false
    TargetPlayer = nil
    UnblockInputs()
    print("Bang system stopped.")
end

-- إضافة واجهة مستخدم بسيطة لاختبار النظام (يمكن دمجها مع GUI خاص بك)

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BangSystemGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 150)
Frame.Position = UDim2.new(0, 50, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(40, 10, 70)
Frame.BorderSizePixel = 0
local corner = Instance.new("UICorner", Frame)
corner.CornerRadius = UDim.new(0, 15)

local TextBox = Instance.new("TextBox", Frame)
TextBox.Size = UDim2.new(1, -40, 0, 35)
TextBox.Position = UDim2.new(0, 20, 0, 30)
TextBox.PlaceholderText = "اكتب اسم اللاعب الهدف"
TextBox.Font = Enum.Font.GothamBold
TextBox.TextSize = 22
TextBox.TextColor3 = Color3.fromRGB(220,220,220)
TextBox.BackgroundColor3 = Color3.fromRGB(60, 20, 90)
local tbCorner = Instance.new("UICorner", TextBox)
tbCorner.CornerRadius = UDim.new(0, 12)

local StartBtn = Instance.new("TextButton", Frame)
StartBtn.Size = UDim2.new(0.4, -10, 0, 40)
StartBtn.Position = UDim2.new(0, 20, 0, 90)
StartBtn.Text = "تشغيل Bang"
StartBtn.Font = Enum.Font.GothamBold
StartBtn.TextSize = 22
StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
StartBtn.TextColor3 = Color3.fromRGB(255,255,255)
local sbCorner = Instance.new("UICorner", StartBtn)
sbCorner.CornerRadius = UDim.new(0, 15)

local StopBtn = Instance.new("TextButton", Frame)
StopBtn.Size = UDim2.new(0.4, -10, 0, 40)
StopBtn.Position = UDim2.new(0.6, -10, 0, 90)
StopBtn.Text = "إيقاف Bang"
StopBtn.Font = Enum.Font.GothamBold
StopBtn.TextSize = 22
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopBtn.TextColor3 = Color3.fromRGB(255,255,255)
local spCorner = Instance.new("UICorner", StopBtn)
spCorner.CornerRadius = UDim.new(0, 15)

StartBtn.MouseButton1Click:Connect(function()
    local targetText = TextBox.Text
    if targetText == "" then
        warn("Please enter a target name!")
        return
    end
    local success = StartBang(targetText)
    if not success then
        warn("Failed to start Bang. Target not found.")
    end
end)

StopBtn.MouseButton1Click:Connect(function()
    StopBang()
end)

-- منع تحرك WASD بالكامل أثناء Bang (تعطيل تحكم الشخصية)
-- للأسف، Roblox لا يسمح بمنع input بشكل مباشر، لكن يمكن إزالة التحكم اليدوي عن طريق إعداد Humanoid.PlatformStand
-- استخدام هذا الأسلوب لتعطيل تحكم اليدوي مؤقتًا:

RS:BindToRenderStep("DisableWASD", Enum.RenderPriority.Character.Value + 4, function(dt)
    if BangActive and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true -- تعطيل التحكم اليدوي
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
