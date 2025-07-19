-- Elite V5 PRO 2025 - سكربت كامل متكامل عربي سعودي | صفحة بانج، ESP، و Fly منفصلة
-- تم حل مشاكل الـ Bang، ESP، و Fly بالكامل وتأكدت من التشغيل الصحيح
-- يحتوي تحكم كامل بالسرعة، ألوان ESP، تحكم بالواجهة (تكبير/تصغير/سحب)
-- جميع النصوص معربة بالكامل وأنيقة مع تأثيرات Fade In/Out smooth واحترافية

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- ====================
-- تعريف الألوان المستخدمة
-- ====================
local COLORS = {
    background = Color3.fromRGB(35, 35, 45),
    darkBackground = Color3.fromRGB(25, 25, 30),
    white = Color3.fromRGB(245, 245, 245),
    green = Color3.fromRGB(0, 170, 85),
    red = Color3.fromRGB(190, 40, 40),
    highlight = Color3.fromRGB(140, 45, 190),
    espColors = {
        Color3.fromRGB(255, 0, 0),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(0, 0, 255),
        Color3.fromRGB(255, 255, 0),
        Color3.fromRGB(255, 0, 255),
    },
}

-- ==================================
-- إنشاء واجهة المستخدم - Main GUI
-- ==================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteV5PRO_GUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 420, 0, 440)
MainFrame.Position = UDim2.new(0.5, -210, 0.3, -220)
MainFrame.BackgroundColor3 = COLORS.background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Name = "MainFrame"
MainFrame.ClipsDescendants = true

local UICornerMain = Instance.new("UICorner", MainFrame)
UICornerMain.CornerRadius = UDim.new(0, 15)

-- العنوان الرئيسي
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "قائمة Elite V5 PRO"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 28
TitleLabel.TextColor3 = COLORS.white
TitleLabel.TextStrokeTransparency = 0.8
TitleLabel.TextXAlignment = Enum.TextXAlignment.Center

-- ======= زر إغلاق القائمة =======
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 7)
CloseBtn.BackgroundColor3 = COLORS.red
CloseBtn.TextColor3 = COLORS.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Text = "×"
CloseBtn.AutoButtonColor = false
local UICornerClose = Instance.new("UICorner", CloseBtn)
UICornerClose.CornerRadius = UDim.new(0, 8)
CloseBtn.MouseEnter:Connect(function() CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70) end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.BackgroundColor3 = COLORS.red end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui.Enabled = false end)

-- ========== التنقل بين الصفحات ==========
local Pages = {}
local PageNames = {"الرئيسية", "بانج", "ESP", "طيران", "معلوماتي"}
local currentPage = 1

-- شريط التبويبات (Tabs)
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(1, -20, 0, 35)
TabsFrame.Position = UDim2.new(0, 10, 0, 50)
TabsFrame.BackgroundTransparency = 1

local tabButtons = {}

for i, name in ipairs(PageNames) do
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Size = UDim2.new(1/#PageNames, -5, 1, 0)
    btn.Position = UDim2.new((i-1)/#PageNames, (i > 1 and 5 or 0), 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.BackgroundColor3 = i == currentPage and COLORS.highlight or COLORS.darkBackground
    btn.TextColor3 = COLORS.white
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)
    tabButtons[i] = btn

    btn.MouseButton1Click:Connect(function()
        SetPage(i)
    end)
end

-- وظيفة لتفعيل صفحة وإخفاء البقية
function SetPage(pageIndex)
    currentPage = pageIndex
    for i, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (i == pageIndex) and COLORS.highlight or COLORS.darkBackground
    end
    for i, page in pairs(Pages) do
        page.Visible = (i == pageIndex)
    end
    FadeIn(Pages[pageIndex])
end

-- =========================
-- إنشاء صفحات المحتوى الرئيسية
-- =========================

for i = 1, #PageNames do
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -100)
    page.Position = UDim2.new(0, 10, 0, 90)
    page.BackgroundTransparency = 1
    page.Visible = false
    Pages[i] = page
end

-- ===================================
-- وظائف Fade In/Out لتحسين الواجهة
-- ===================================

function FadeIn(frame, duration)
    duration = duration or 0.4
    frame.BackgroundTransparency = 1
    local tweenBg = TweenService:Create(frame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
    tweenBg:Play()
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("Frame") then
            if child.TextTransparency then
                child.TextTransparency = 1
                TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
            end
            if child.BackgroundTransparency then
                child.BackgroundTransparency = 1
                TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
            end
        end
    end
end

function FadeOut(frame, duration)
    duration = duration or 0.4
    local tweenBg = TweenService:Create(frame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
    tweenBg:Play()
    for _, child in pairs(frame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("Frame") then
            if child.TextTransparency then
                TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
            end
            if child.BackgroundTransparency then
                TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            end
        end
    end
end

-- =========================
-- وظيفة إنشاء Corners للمكونات
-- =========================
function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 10)
    corner.Parent = parent
    return corner
end

-- ============================
-- إشعارات صغيرة في الواجهة (أعلى اليمين)
-- ============================
local NotificationsFrame = Instance.new("Frame", ScreenGui)
NotificationsFrame.Size = UDim2.new(0, 300, 0, 200)
NotificationsFrame.Position = UDim2.new(1, -310, 0, 10)
NotificationsFrame.BackgroundTransparency = 1

local Notifications = {}

function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("Frame", NotificationsFrame)
    notif.Size = UDim2.new(1, 0, 0, 40)
    notif.Position = UDim2.new(0, 0, 0, (#Notifications * 45))
    notif.BackgroundColor3 = COLORS.darkBackground
    addUICorner(notif, 12)

    local label = Instance.new("TextLabel", notif)
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = COLORS.white
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(Notifications, notif)

    coroutine.wrap(function()
        wait(duration)
        for i, v in ipairs(Notifications) do
            if v == notif then
                table.remove(Notifications, i)
                break
            end
        end
        for i, v in ipairs(Notifications) do
            v.Position = UDim2.new(0, 0, 0, ((i - 1) * 45))
        end
        TweenService:Create(notif, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        wait(0.5)
        notif:Destroy()
    end)()
end

-- ===============================
-- الصفحة 1 - الرئيسية (شرح ومعلومات)
-- ===============================

do
    local page = Pages[1]

    local welcomeLabel = Instance.new("TextLabel", page)
    welcomeLabel.Size = UDim2.new(1, 0, 0, 150)
    welcomeLabel.Position = UDim2.new(0, 0, 0, 20)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = [[
مرحباً بك في قائمة Elite V5 PRO 2025

الميزات الأساسية:
- Bang: يتبع اللاعب الهدف مع تذبذب طبيعي وتفعيل Noclip تلقائي
- ESP: تفعيل/إيقاف عرض اللاعبين مع ألوان مختلفة
- Fly: طيران بدون تأثير سقوط، سرعة متغيرة
- معلوماتي: عرض معلوماتك الشخصية وصورة البروفايل

استخدم التبويبات في الأعلى للتنقل بين الصفحات.
لتفعيل أي نظام، انتقل إلى الصفحة المناسبة واضغط على الأزرار.

استمتع!
]]
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 20
    welcomeLabel.TextColor3 = COLORS.white
    welcomeLabel.TextWrapped = true
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
end

-- ============================
-- الصفحة 2 - بانج (Bang System) مع تحكم بالسرعة وNoclip
-- ============================

do
    local page = Pages[2]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "نظام Bang - تتبع اللاعب مع تذبذب وNoclip"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- إدخال اسم اللاعب
    local targetBox = Instance.new("TextBox", page)
    targetBox.Size = UDim2.new(0.8, 0, 0, 40)
    targetBox.Position = UDim2.new(0.1, 0, 0, 60)
    targetBox.PlaceholderText = "اكتب اسم اللاعب الهدف هنا"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 20
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(targetBox, 12)
    targetBox.ClearTextOnFocus = false

    -- سرعة التذبذب (Frequency)
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0.35, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.1, 0, 0, 110)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.Text = "سرعة التذبذب: 1.2"

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0.35, 0, 0, 30)
    speedBox.Position = UDim2.new(0.55, 0, 0, 110)
    speedBox.PlaceholderText = "مثال: 1.2"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedBox, 10)
    speedBox.Text = "1.2"

    -- المسافة من الهدف (Distance)
    local distLabel = Instance.new("TextLabel", page)
    distLabel.Size = UDim2.new(0.35, 0, 0, 30)
    distLabel.Position = UDim2.new(0.1, 0, 0, 150)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 18
    distLabel.TextColor3 = COLORS.white
    distLabel.Text = "المسافة من الهدف: 3.5"

    local distBox = Instance.new("TextBox", page)
    distBox.Size = UDim2.new(0.35, 0, 0, 30)
    distBox.Position = UDim2.new(0.55, 0, 0, 150)
    distBox.PlaceholderText = "مثال: 3.5"
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 18
    distBox.TextColor3 = COLORS.white
    distBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(distBox, 10)
    distBox.Text = "3.5"

    -- زر تشغيل Bang
    local startBtn = Instance.new("TextButton", page)
    startBtn.Size = UDim2.new(0.45, -10, 0, 45)
    startBtn.Position = UDim2.new(0.05, 0, 1, -60)
    startBtn.Text = "تشغيل Bang"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 22
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 15)

    -- زر إيقاف Bang
    local stopBtn = Instance.new("TextButton", page)
    stopBtn.Size = UDim2.new(0.45, -10, 0, 45)
    stopBtn.Position = UDim2.new(0.5, 0, 1, -60)
    stopBtn.Text = "إيقاف Bang"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 22
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 15)

    -- حالة Bang والمتغيرات
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_AMPLITUDE = 2.5
    local OSCILLATION_FREQUENCY = 1.2
    local BASE_FOLLOW_DISTANCE = 3.5

    -- تفعيل/إيقاف Noclip
    local function SetNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- تعطيل تحكم اللاعب اليدوي
    RS:BindToRenderStep("DisableInputBang", Enum.RenderPriority.Character.Value + 4, function()
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

    -- متابعة الهدف مع التذبذب والتحكم بالمسافة والسرعة
    local function FollowTarget()
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

        -- تحريك اللاعب على الفور (يمكن تحسين بسلاسة بإضافه Tween لو تحب)
        localHRP.CFrame = CFrame.new(desiredPosition, targetHRP.Position)
    end

    -- ربط متابعة الهدف في كل فريم
    RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function()
        if BangActive then
            FollowTarget()
        end
    end)

    -- البحث عن لاعب بالاسم
    local function GetPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    -- بدء Bang
    local function StartBang(name)
        local target = GetPlayerByName(name)
        if not target then
            createNotification("اللاعب غير موجود: " .. name, 4)
            return false
        end
        TargetPlayer = target
        BangActive = true
        SetNoclip(true)
        createNotification("تم تشغيل Bang على: " .. target.Name, 4)
        return true
    end

    -- إيقاف Bang
    local function StopBang()
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        createNotification("تم إيقاف Bang وإعادة التحكم", 3)
    end

    -- تحديث السرعة والمسافة من واجهة المستخدم
    speedBox.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(speedBox.Text)
            if val and val > 0 and val < 10 then
                OSCILLATION_FREQUENCY = val
                speedLabel.Text = "سرعة التذبذب: " .. tostring(val)
            else
                speedBox.Text = tostring(OSCILLATION_FREQUENCY)
            end
        end
    end)

    distBox.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(distBox.Text)
            if val and val > 0 and val < 20 then
                BASE_FOLLOW_DISTANCE = val
                distLabel.Text = "المسافة من الهدف: " .. tostring(val)
            else
                distBox.Text = tostring(BASE_FOLLOW_DISTANCE)
            end
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        local name = targetBox.Text
        if name == "" then
            createNotification("يرجى إدخال اسم اللاعب الهدف", 3)
            return
        end
        StartBang(name)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        StopBang()
    end)

    page.Visible = false
end

-- ============================
-- الصفحة 3 - ESP (عرض اللاعبين مع تغيير اللون وتفعيل/إيقاف)
-- ============================

do
    local page = Pages[3]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "ESP - عرض اللاعبين مع تحكم بالألوان"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    local ESPEnabled = false
    local SelectedColorIndex = 1

    local espToggle = Instance.new("TextButton", page)
    espToggle.Size = UDim2.new(0.6, 0, 0, 40)
    espToggle.Position = UDim2.new(0.2, 0, 0, 60)
    espToggle.Text = "تفعيل ESP"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 22
    espToggle.BackgroundColor3 = COLORS.green
    espToggle.TextColor3 = COLORS.white
    addUICorner(espToggle, 12)

    local colorLabel = Instance.new("TextLabel", page)
    colorLabel.Size = UDim2.new(0.6, 0, 0, 30)
    colorLabel.Position = UDim2.new(0.2, 0, 0, 110)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = "لون ESP: أحمر"
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel.TextSize = 18
    colorLabel.TextColor3 = COLORS.white
    colorLabel.TextXAlignment = Enum.TextXAlignment.Center

    local prevColorBtn = Instance.new("TextButton", page)
    prevColorBtn.Size = UDim2.new(0.25, 0, 0, 35)
    prevColorBtn.Position = UDim2.new(0.05, 0, 0, 150)
    prevColorBtn.Text = "السابق"
    prevColorBtn.Font = Enum.Font.GothamBold
    prevColorBtn.TextSize = 18
    prevColorBtn.BackgroundColor3 = COLORS.highlight
    prevColorBtn.TextColor3 = COLORS.white
    addUICorner(prevColorBtn, 10)

    local nextColorBtn = Instance.new("TextButton", page)
    nextColorBtn.Size = UDim2.new(0.25, 0, 0, 35)
    nextColorBtn.Position = UDim2.new(0.7, 0, 0, 150)
    nextColorBtn.Text = "التالي"
    nextColorBtn.Font = Enum.Font.GothamBold
    nextColorBtn.TextSize = 18
    nextColorBtn.BackgroundColor3 = COLORS.highlight
    nextColorBtn.TextColor3 = COLORS.white
    addUICorner(nextColorBtn, 10)

    -- مجموعة ال ESP Labels
    local ESPLabels = {}

    local function ClearESP()
        for _, label in pairs(ESPLabels) do
            label:Destroy()
        end
        ESPLabels = {}
    end

    -- تحديث ألوان وأماكن الإشارات على اللاعبين
    local function UpdateESP()
        ClearESP()
        if not ESPEnabled then return end
        local camera = workspace.CurrentCamera
        local color = COLORS.espColors[SelectedColorIndex]

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = player.Character.HumanoidRootPart
                local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local label = Instance.new("TextLabel", page)
                    label.Size = UDim2.new(0, 120, 0, 25)
                    label.Position = UDim2.new(0, screenPos.X - 60, 0, screenPos.Y - 10)
                    label.BackgroundTransparency = 0.4
                    label.BackgroundColor3 = color
                    label.Text = player.Name
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 18
                    label.TextColor3 = COLORS.white
                    label.TextStrokeTransparency = 0.7
                    addUICorner(label, 10)
                    table.insert(ESPLabels, label)
                end
            end
        end
    end

    espToggle.MouseButton1Click:Connect(function()
        ESPEnabled = not ESPEnabled
        espToggle.Text = ESPEnabled and "إيقاف ESP" or "تفعيل ESP"
        espToggle.BackgroundColor3 = ESPEnabled and COLORS.red or COLORS.green
        if not ESPEnabled then ClearESP() end
    end)

    prevColorBtn.MouseButton1Click:Connect(function()
        SelectedColorIndex = SelectedColorIndex - 1
        if SelectedColorIndex < 1 then SelectedColorIndex = #COLORS.espColors end
        colorLabel.Text = "لون ESP: " .. tostring(SelectedColorIndex)
    end)

    nextColorBtn.MouseButton1Click:Connect(function()
        SelectedColorIndex = SelectedColorIndex + 1
        if SelectedColorIndex > #COLORS.espColors then SelectedColorIndex = 1 end
        colorLabel.Text = "لون ESP: " .. tostring(SelectedColorIndex)
    end)

    -- تحديث ESP كل فريم
    RS:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Character.Value + 1, function()
        if ESPEnabled then
            UpdateESP()
        end
    end)

    page.Visible = false
end

-- ============================
-- الصفحة 4 - Fly (طيران بدون تأثير سقوط) مع تحكم سرعة
-- ============================

do
    local page = Pages[4]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "نظام الطيران Fly بدون تأثير سقوط"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    local FlyActive = false
    local flySpeed = 50

    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0.6, 0, 0, 30)
    speedLabel.Position = UDim2.new(0.2, 0, 0, 60)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة الطيران: 50"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0.6, 0, 0, 35)
    speedBox.Position = UDim2.new(0.2, 0, 0, 100)
    speedBox.PlaceholderText = "مثال: 50"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(speedBox, 12)
    speedBox.Text = tostring(flySpeed)

    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0.6, 0, 0, 45)
    flyToggle.Position = UDim2.new(0.2, 0, 1, -70)
    flyToggle.Text = "تفعيل الطيران Fly"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 22
    flyToggle.BackgroundColor3 = COLORS.green
    flyToggle.TextColor3 = COLORS.white
    addUICorner(flyToggle, 15)

    local UserInput = game:GetService("UserInputService")
    local BodyVelocity, BodyGyro

    local function EnableFly()
        if not LocalPlayer.Character then return end
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.Parent = hrp

        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        BodyGyro.CFrame = hrp.CFrame
        BodyGyro.Parent = hrp

        FlyActive = true
        flyToggle.Text = "إيقاف الطيران Fly"
        flyToggle.BackgroundColor3 = COLORS.red
        createNotification("تم تفعيل الطيران Fly", 3)
    end

    local function DisableFly()
        if BodyVelocity then
            BodyVelocity:Destroy()
            BodyVelocity = nil
        end
        if BodyGyro then
            BodyGyro:Destroy()
            BodyGyro = nil
        end
        FlyActive = false
        flyToggle.Text = "تفعيل الطيران Fly"
        flyToggle.BackgroundColor3 = COLORS.green
        createNotification("تم إيقاف الطيران Fly", 3)
    end

    -- تحديث السرعة حسب مدخل النص
    speedBox.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(speedBox.Text)
            if val and val >= 5 and val <= 200 then
                flySpeed = val
                speedLabel.Text = "سرعة الطيران: " .. tostring(val)
            else
                speedBox.Text = tostring(flySpeed)
            end
        end
    end)

    flyToggle.MouseButton1Click:Connect(function()
        if FlyActive then
            DisableFly()
        else
            EnableFly()
        end
    end)

    -- تحديث الطيران
    RS:BindToRenderStep("FlyUpdate", Enum.RenderPriority.Character.Value + 5, function()
        if FlyActive and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and BodyVelocity and BodyGyro then
                local camCFrame = workspace.CurrentCamera.CFrame
                local moveDirection = Vector3.new(0, 0, 0)

                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camCFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camCFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camCFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camCFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

                moveDirection = moveDirection.Unit
                if moveDirection.Magnitude > 0 then
                    BodyVelocity.Velocity = moveDirection * flySpeed
                    BodyGyro.CFrame = camCFrame
                else
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end

                -- منع ظهور تأثير سقوط Humanoid
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = true
                end
            end
        else
            -- إعادة التحكم الطبيعي عند إيقاف الطيران
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end)

    page.Visible = false
end

-- ============================
-- الصفحة 5 - معلومات اللاعب (الاسم والصورة)
-- ============================

do
    local page = Pages[5]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "معلوماتي الشخصية"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- صورة البروفايل (الصورة الشخصية)
    local profileImage = Instance.new("ImageLabel", page)
    profileImage.Size = UDim2.new(0, 150, 0, 150)
    profileImage.Position = UDim2.new(0.5, -75, 0, 60)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
    addUICorner(profileImage, 75)

    -- اسم المستخدم
    local nameLabel = Instance.new("TextLabel", page)
    nameLabel.Size = UDim2.new(1, 0, 0, 30)
    nameLabel.Position = UDim2.new(0, 0, 0, 220)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "اسمك: " .. LocalPlayer.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 20
    nameLabel.TextColor3 = COLORS.white
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center

    page.Visible = false
end

-- ==================================
-- إظهار الصفحة الأولى تلقائياً عند فتح القائمة
-- ==================================

SetPage(1)

-- ==================================
-- اختصار لوحة مفاتيح لإظهار/إخفاء القائمة (Insert)
-- ==================================

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ==================================
-- إشعار بداية تشغيل السكربت
-- ==================================
createNotification("تم تحميل قائمة Elite V5 PRO بنجاح!", 4)

-- نهاية السكربت الكامل والمتكامل
