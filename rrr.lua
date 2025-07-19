-- Elite V5 PRO FULL SCRIPT 2025
-- سكربت كامل متكامل، يشتغل على طول، واجهة عربية سعودية، انيميشن FadeIn/FadeOut، تحكم كامل بالسرعات، بانج مع نوكليب، ESP متعدد الألوان، نظام طيران بدون ظهور تأثير سقوط، صورة بروفايل اللاعب ومعلومات الشبكة Ping، تنبيهات، وتحكم بالواجهة تكبير وتصغير وسحب سلس.
--free

-- الخدمات الأساسية
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- إنشاء واجهة المستخدم الرئيسية (ScreenGui)
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteV5ProMenu"
EliteMenu.Enabled = true -- يشتغل على طول بدون زر تفعيل

-- إطار رئيسي
local MainFrame = Instance.new("Frame", EliteMenu)
MainFrame.Size = UDim2.new(0, 420, 0, 440)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 70)
MainFrame.BackgroundTransparency = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ClipsDescendants = true
TweenService:Create(MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

local function addUICorner(instance, radius)
    local corner = Instance.new("UICorner", instance)
    corner.CornerRadius = UDim.new(0, radius or 10)
    return corner
end

local function addShadow(frame)
    local shadow = Instance.new("ImageLabel", frame)
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Size = UDim2.new(1, 12, 1, 12)
    shadow.Position = UDim2.new(0, -6, 0, -6)
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.ZIndex = 0
end

addUICorner(MainFrame, 25)
addShadow(MainFrame)

-- تبويبات القائمة
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(0, 90, 1, -40)
TabsFrame.Position = UDim2.new(0, 10, 0, 30)
TabsFrame.BackgroundTransparency = 1

local PagesFrame = Instance.new("Frame", MainFrame)
PagesFrame.Size = UDim2.new(1, -110, 1, -40)
PagesFrame.Position = UDim2.new(0, 100, 0, 30)
PagesFrame.BackgroundTransparency = 1

local Tabs = {"الرئيسية", "بانج", "ESP", "معلومات اللاعب"}
local Pages = {}

-- إنشاء الصفحات (Frames) لكل تبويب
for i, tabName in pairs(Tabs) do
    local page = Instance.new("Frame", PagesFrame)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = (i == 1) -- الصفحة الأولى تظهر تلقائياً
    Pages[i] = page
end

-- إنشاء أزرار التبويبات
local currentTab = 1
for i, tabName in pairs(Tabs) do
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.Position = UDim2.new(0, 0, 0, (i-1)*55)
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.TextColor3 = Color3.fromRGB(230, 230, 250)
    btn.BackgroundColor3 = (i == currentTab) and Color3.fromRGB(70, 25, 130) or Color3.fromRGB(50, 15, 80)
    addUICorner(btn, 15)

    btn.MouseButton1Click:Connect(function()
        -- تغيير اللون والصفحة الظاهرة
        if currentTab ~= i then
            Pages[currentTab].Visible = false
            TabsFrame:GetChildren()[currentTab]:FindFirstChildWhichIsA("TextButton").BackgroundColor3 = Color3.fromRGB(50, 15, 80)
            currentTab = i
            Pages[currentTab].Visible = true
            btn.BackgroundColor3 = Color3.fromRGB(70, 25, 130)
        end
    end)
end

-- وظائف التنبيهات
local function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("TextLabel", EliteMenu)
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0, 20)
    notif.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Text = text
    notif.AnchorPoint = Vector2.new(0.5, 0)
    notif.BackgroundTransparency = 0.1
    addUICorner(notif, 10)
    addShadow(notif)

    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    delay(duration, function()
        TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        wait(0.5)
        notif:Destroy()
    end)
end

-- =============== الصفحة 1 - الرئيسية ===============  
do
    local page = Pages[1]

    -- عنوان الصفحة
    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "القائمة الرئيسية"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.TextColor3 = Color3.fromRGB(230, 230, 250)
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- سرعة المشي
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 160, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 60)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة المشي: 16"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 255)

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0, 100, 0, 30)
    speedBox.Position = UDim2.new(0, 20, 0, 95)
    speedBox.PlaceholderText = "أدخل سرعة المشي"
    speedBox.Text = "16"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(speedBox, 12)

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedBox.Text)
            if val and val >= 8 and val <= 100 then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = val
                    speedLabel.Text = ("سرعة المشي: %d"):format(val)
                    createNotification("تم تعديل سرعة المشي إلى " .. val, 2)
                end
            else
                createNotification("يرجى إدخال قيمة بين 8 و 100", 3)
                speedBox.Text = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16)
            end
        end
    end)

    -- قوة القفز
    local jumpLabel = Instance.new("TextLabel", page)
    jumpLabel.Size = UDim2.new(0, 160, 0, 30)
    jumpLabel.Position = UDim2.new(0, 220, 0, 60)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "قوة القفز: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 20
    jumpLabel.TextColor3 = Color3.fromRGB(230, 230, 255)

    local jumpBox = Instance.new("TextBox", page)
    jumpBox.Size = UDim2.new(0, 100, 0, 30)
    jumpBox.Position = UDim2.new(0, 220, 0, 95)
    jumpBox.PlaceholderText = "أدخل قوة القفز"
    jumpBox.Text = "50"
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 18
    jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(jumpBox, 12)

    jumpBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(jumpBox.Text)
            if val and val >= 20 and val <= 150 then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = val
                    jumpLabel.Text = ("قوة القفز: %d"):format(val)
                    createNotification("تم تعديل قوة القفز إلى " .. val, 2)
                end
            else
                createNotification("يرجى إدخال قيمة بين 20 و 150", 3)
                jumpBox.Text = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50)
            end
        end
    end)

    -- زر الطيران (Fly) والتحكم به
    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0, 140, 0, 40)
    flyToggle.Position = UDim2.new(0, 20, 0, 140)
    flyToggle.Text = "تفعيل الطيران"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(flyToggle, 15)

    local flySpeedLabel = Instance.new("TextLabel", page)
    flySpeedLabel.Size = UDim2.new(0, 160, 0, 25)
    flySpeedLabel.Position = UDim2.new(0, 180, 0, 150)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 16
    flySpeedLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    flySpeedLabel.Text = "سرعة الطيران: 50"

    local flySpeedBox = Instance.new("TextBox", page)
    flySpeedBox.Size = UDim2.new(0, 100, 0, 25)
    flySpeedBox.Position = UDim2.new(0, 180, 0, 180)
    flySpeedBox.PlaceholderText = "أدخل سرعة الطيران"
    flySpeedBox.Text = "50"
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 16
    flySpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(flySpeedBox, 12)

    local flying = false
    local flySpeed = 50
    local flyBodyVelocity, flyBodyGyro

    local function disableFallAnimation(character)
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
        end
    end

    flyToggle.MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local hrp = character.HumanoidRootPart

                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyBodyVelocity.Parent = hrp

                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                flyBodyGyro.CFrame = hrp.CFrame
                flyBodyGyro.Parent = hrp

                disableFallAnimation(character)
                createNotification("تم تفعيل الطيران بدون تأثير السقوط", 3)
            else
                createNotification("لا يمكن تفعيل الطيران الآن.", 3)
                flying = false
            end
            flyToggle.Text = "إيقاف الطيران"
            flyToggle.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
        else
            if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
            if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                end
            end
            createNotification("تم إيقاف الطيران", 3)
            flyToggle.Text = "تفعيل الطيران"
            flyToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end
    end)

    flySpeedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(flySpeedBox.Text)
            if val and val >= 10 and val <= 150 then
                flySpeed = val
                flySpeedLabel.Text = ("سرعة الطيران: %d"):format(val)
                createNotification("تم تعديل سرعة الطيران إلى " .. val, 2)
            else
                createNotification("يرجى إدخال قيمة بين 10 و 150", 3)
                flySpeedBox.Text = tostring(flySpeed)
            end
        end
    end)

    -- تحديث حركة الطيران
    RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 5, function()
        if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and flyBodyVelocity and flyBodyGyro then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local cam = workspace.CurrentCamera
            local moveDirection = Vector3.new(0,0,0)

            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0,1,0) end

            moveDirection = moveDirection.Unit
            if moveDirection ~= moveDirection then -- NaN check if no input
                moveDirection = Vector3.new(0,0,0)
            end

            flyBodyVelocity.Velocity = moveDirection * flySpeed
            flyBodyGyro.CFrame = cam.CFrame
        end
    end)
end

-- =============== الصفحة 2 - بانج (Bang System) ===============  
do
    local page = Pages[2]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "نظام بانج مع نوكليب وتحكم سرعة"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.fromRGB(230, 230, 250)
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- إدخال اسم الهدف
    local targetBox = Instance.new("TextBox", page)
    targetBox.Size = UDim2.new(0, 280, 0, 35)
    targetBox.Position = UDim2.new(0, 20, 0, 70)
    targetBox.PlaceholderText = "أدخل اسم اللاعب الهدف"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 20
    targetBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(targetBox, 15)

    -- سرعة التذبذب (Oscillation Amplitude)
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 280, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 115)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.2"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 255)

    local speedBox = Instance.new("TextBox", page)
    speedBox.Size = UDim2.new(0, 120, 0, 30)
    speedBox.Position = UDim2.new(0, 20, 0, 145)
    speedBox.PlaceholderText = "سرعة التذبذب"
    speedBox.Text = "1.2"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(speedBox, 12)

    -- المسافة من الهدف (Base Follow Distance)
    local distLabel = Instance.new("TextLabel", page)
    distLabel.Size = UDim2.new(0, 280, 0, 25)
    distLabel.Position = UDim2.new(0, 170, 0, 115)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3.5"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 18
    distLabel.TextColor3 = Color3.fromRGB(230, 230, 255)

    local distBox = Instance.new("TextBox", page)
    distBox.Size = UDim2.new(0, 120, 0, 30)
    distBox.Position = UDim2.new(0, 170, 0, 145)
    distBox.PlaceholderText = "المسافة من الهدف"
    distBox.Text = "3.5"
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 18
    distBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    distBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(distBox, 12)

    -- أزرار التشغيل والإيقاف
    local startBtn = Instance.new("TextButton", page)
    startBtn.Size = UDim2.new(0.45, -10, 0, 40)
    startBtn.Position = UDim2.new(0, 20, 0, 195)
    startBtn.Text = "تشغيل بانج"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 20
    startBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 60)
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(startBtn, 15)

    local stopBtn = Instance.new("TextButton", page)
    stopBtn.Size = UDim2.new(0.45, -10, 0, 40)
    stopBtn.Position = UDim2.new(0.55, -10, 0, 195)
    stopBtn.Text = "إيقاف بانج"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 20
    stopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(stopBtn, 15)

    -- حالة النظام
    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_FREQUENCY = 1.2
    local OSCILLATION_AMPLITUDE = 2.5
    local BASE_FOLLOW_DISTANCE = 3.5

    -- تفعيل / إيقاف النوكليب
    local function SetNoclip(enabled)
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    -- تعطيل حركة اليد (WASD + القفز)
    RS:BindToRenderStep("DisablePlayerInput", Enum.RenderPriority.Character.Value + 4, function()
        if BangActive and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true -- منع تحكم اليد
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

    -- متابعة الهدف مع التذبذب
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

    local function GetPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    -- تحديث المتغيرات من الإدخالات
    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedBox.Text)
            if val and val > 0 then
                OSCILLATION_FREQUENCY = val
                speedLabel.Text = ("سرعة التذبذب: %.2f"):format(val)
                createNotification("تم تعديل سرعة التذبذب إلى " .. val, 2)
            else
                speedBox.Text = tostring(OSCILLATION_FREQUENCY)
                createNotification("يرجى إدخال قيمة صحيحة", 3)
            end
        end
    end)

    distBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(distBox.Text)
            if val and val > 0 then
                BASE_FOLLOW_DISTANCE = val
                distLabel.Text = ("المسافة من الهدف: %.2f"):format(val)
                createNotification("تم تعديل المسافة إلى " .. val, 2)
            else
                distBox.Text = tostring(BASE_FOLLOW_DISTANCE)
                createNotification("يرجى إدخال قيمة صحيحة", 3)
            end
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        local name = targetBox.Text
        if name == "" then
            createNotification("يرجى إدخال اسم اللاعب الهدف", 3)
            return
        end
        local target = GetPlayerByName(name)
        if target then
            TargetPlayer = target
            BangActive = true
            SetNoclip(true)
            createNotification("تم تفعيل بانج على اللاعب: " .. target.Name, 3)
        else
            createNotification("لم يتم العثور على اللاعب: " .. name, 3)
        end
    end)

    stopBtn.MouseButton1Click:Connect(function()
        BangActive = false
        TargetPlayer = nil
        SetNoclip(false)
        createNotification("تم إيقاف بانج وإعادة التحكم", 3)
    end)
end

-- =============== الصفحة 3 - ESP ===============  
do
    local page = Pages[3]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "نظام ESP مع تغيير الألوان"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.fromRGB(230, 230, 250)
    title.TextXAlignment = Enum.TextXAlignment.Center

    local toggleESP = Instance.new("TextButton", page)
    toggleESP.Size = UDim2.new(0, 140, 0, 40)
    toggleESP.Position = UDim2.new(0, 20, 0, 70)
    toggleESP.Text = "تفعيل ESP"
    toggleESP.Font = Enum.Font.GothamBold
    toggleESP.TextSize = 20
    toggleESP.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
    toggleESP.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(toggleESP, 15)

    local btnChangeColor = Instance.new("TextButton", page)
    btnChangeColor.Size = UDim2.new(0, 140, 0, 40)
    btnChangeColor.Position = UDim2.new(0, 180, 0, 70)
    btnChangeColor.Text = "تغيير لون ESP"
    btnChangeColor.Font = Enum.Font.GothamBold
    btnChangeColor.TextSize = 20
    btnChangeColor.BackgroundColor3 = Color3.fromRGB(70, 25, 130)
    btnChangeColor.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(btnChangeColor, 15)

    local ESP_Active = false
    local ESP_Color = Color3.fromRGB(0, 255, 0)
    local ESP_Boxes = {}

    local colors = {
        {Name = "أخضر", Color = Color3.fromRGB(0, 255, 0)},
        {Name = "أحمر", Color = Color3.fromRGB(255, 0, 0)},
        {Name = "أزرق", Color = Color3.fromRGB(0, 170, 255)},
        {Name = "أصفر", Color = Color3.fromRGB(255, 255, 0)},
        {Name = "بنفسجي", Color = Color3.fromRGB(150, 50, 200)},
    }
    local currentColorIndex = 1

    -- إنشاء إطار ESP لكل لاعب
    local function CreateESPForPlayer(plr)
        if ESP_Boxes[plr] then return end
        local box = Instance.new("BillboardGui")
        box.Name = "ESPBox"
        box.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        box.Size = UDim2.new(0, 140, 0, 50)
        box.StudsOffset = Vector3.new(0, 2, 0)
        box.AlwaysOnTop = true

        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.6
        frame.BackgroundColor3 = ESP_Color
        addUICorner(frame, 10)

        local nameLabel = Instance.new("TextLabel", frame)
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = plr.Name
        nameLabel.TextColor3 = Color3.new(1,1,1)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 20
        nameLabel.TextStrokeColor3 = Color3.new(0,0,0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextXAlignment = Enum.TextXAlignment.Center
        nameLabel.TextYAlignment = Enum.TextYAlignment.Center

        box.Parent = workspace.CurrentCamera
        ESP_Boxes[plr] = box
    end

    local function RemoveESPForPlayer(plr)
        if ESP_Boxes[plr] then
            ESP_Boxes[plr]:Destroy()
            ESP_Boxes[plr] = nil
        end
    end

    -- تحديث ESP كل إطار
    RS:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, function()
        if ESP_Active then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not ESP_Boxes[plr] then
                        CreateESPForPlayer(plr)
                    end
                    ESP_Boxes[plr].Adornee = plr.Character.HumanoidRootPart
                    ESP_Boxes[plr].Frame.BackgroundColor3 = ESP_Color
                else
                    RemoveESPForPlayer(plr)
                end
            end
        else
            -- إزالة كل ESP عند الإيقاف
            for plr, _ in pairs(ESP_Boxes) do
                RemoveESPForPlayer(plr)
            end
        end
    end)

    toggleESP.MouseButton1Click:Connect(function()
        ESP_Active = not ESP_Active
        if ESP_Active then
            toggleESP.Text = "إيقاف ESP"
            toggleESP.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
            createNotification("تم تفعيل ESP", 2)
        else
            toggleESP.Text = "تفعيل ESP"
            toggleESP.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
            createNotification("تم إيقاف ESP", 2)
            -- إزالة كل الـ ESP عند الإيقاف
            for plr, _ in pairs(ESP_Boxes) do
                RemoveESPForPlayer(plr)
            end
        end
    end)

    btnChangeColor.MouseButton1Click:Connect(function()
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #colors then currentColorIndex = 1 end
        ESP_Color = colors[currentColorIndex].Color
        btnChangeColor.Text = "لون ESP: " .. colors[currentColorIndex].Name
        createNotification("تم تغيير لون ESP إلى " .. colors[currentColorIndex].Name, 2)
    end)
end

-- =============== الصفحة 4 - معلومات اللاعب مع صورة البروفايل ===============  
do
    local page = Pages[4]

    local title = Instance.new("TextLabel", page)
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.TextColor3 = Color3.fromRGB(230, 230, 250)
    title.Text = "معلومات اللاعب"
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- صورة البروفايل
    local profileImage = Instance.new("ImageLabel", page)
    profileImage.Size = UDim2.new(0, 140, 0, 140)
    profileImage.Position = UDim2.new(0, 20, 0, 60)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    addUICorner(profileImage, 20)

    -- نص معلومات أخرى
    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -180, 0, 140)
    infoLabel.Position = UDim2.new(0, 180, 0, 60)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 22
    infoLabel.TextColor3 = Color3.fromRGB(230, 230, 250)
    infoLabel.TextWrapped = true
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- تحديث معلومات اللاعب
    local function updateInfo()
        local ping = 0
        -- محاولة جلب بيانات Ping من Network stats (محدودية حسب بيئة اللعب)
        pcall(function()
            ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        infoLabel.Text = string.format(
            [[اسم اللاعب: %s
رقم المستخدم: %d
Ping الشبكة: %d ms
عدد الأصدقاء: %d
الحالة: %s]],
            LocalPlayer.Name,
            LocalPlayer.UserId,
            ping,
            #LocalPlayer:GetFriendsOnline(), -- أصدقاء متصلين
            LocalPlayer.AccountAge > 365 and "مخضرم" or "جديد"
        )
    end

    updateInfo()

    -- تحديث دوري كل 5 ثواني
    while true do
        wait(5)
        updateInfo()
    end
end

-- =============== تحكم بحجم الواجهة (تكبير وتصغير) وسحب سلس ===============  
do
    local minSize = Vector2.new(300, 300)
    local maxSize = Vector2.new(900, 700)
    local resizing = false
    local resizeStartPos = Vector2.new()
    local originalSize = Vector2.new()

    -- زر التكبير والتصغير
    local resizeBtn = Instance.new("TextButton", MainFrame)
    resizeBtn.Size = UDim2.new(0, 40, 0, 40)
    resizeBtn.Position = UDim2.new(1, -50, 0, 5)
    resizeBtn.Text = "+"
    resizeBtn.Font = Enum.Font.GothamBold
    resizeBtn.TextSize = 30
    resizeBtn.BackgroundColor3 = Color3.fromRGB(70, 25, 130)
    resizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(resizeBtn, 10)

    resizeBtn.MouseButton1Down:Connect(function(input)
        resizing = true
        resizeStartPos = input.Position
        originalSize = Vector2.new(MainFrame.Size.X.Offset, MainFrame.Size.Y.Offset)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                resizing = false
            end
        end)
    end)

    UIS.InputChanged:Connect(function(input)
        if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - resizeStartPos
            local newSize = Vector2.new(
                math.clamp(originalSize.X + delta.X, minSize.X, maxSize.X),
                math.clamp(originalSize.Y + delta.Y, minSize.Y, maxSize.Y)
            )
            MainFrame.Size = UDim2.new(0, newSize.X, 0, newSize.Y)
        end
    end)

    -- الزر للتصغير (Toggle between original size and small size)
    local toggleSmall = false
    resizeBtn.MouseButton2Click:Connect(function()
        if toggleSmall then
            MainFrame.Size = UDim2.new(0, 420, 0, 440)
            toggleSmall = false
        else
            MainFrame.Size = UDim2.new(0, 320, 0, 320)
            toggleSmall = true
        end
    end)
end

-- =============== Fade In / Fade Out Animations للمينيو ===============  
do
    local function FadeIn(frame, duration)
        duration = duration or 0.5
        frame.BackgroundTransparency = 1
        TweenService:Create(frame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        for _, child in pairs(frame:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("Frame") then
                child.BackgroundTransparency = 1
                TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    child.TextTransparency = 1
                    TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
                end
            end
        end
    end

    local function FadeOut(frame, duration)
        duration = duration or 0.5
        TweenService:Create(frame, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        for _, child in pairs(frame:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") or child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
                if child:IsA("TextLabel") or child:IsA("TextButton") then
                    TweenService:Create(child, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
                end
            end
        end
        wait(duration)
        frame.Visible = false
    end

    -- يمكنك استدعاء FadeIn(MainFrame) أو FadeOut(MainFrame) حسب الحاجة لإظهار أو إخفاء المينيو بسلاسة
    FadeIn(MainFrame, 1)
end

-- تأكد من أن الشخص يملك شخصية عند الدخول واضبط المشي والقفز الأساسيين
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
end)

-- إعداد أولي في حالة وجود الشخصية مسبقاً
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
end

-- READY!
createNotification("قائمة Elite V5 PRO جاهزة للاستخدام", 4)

