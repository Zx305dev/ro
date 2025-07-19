-- Elite V5 PRO 2025 - النسخة النهائية المتكاملة مع تحكم كامل وسلس وأداء مستقر
-- مع نظام ESP متكامل قابل للتفعيل/التعطيل وتغيير ألوانه، نظام Bang مع تحكم سرعة، وتحسينات في Fly بدون ظهور animation السقوط

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- إعدادات عامة
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteV5PRO"
EliteMenu.Enabled = false

local Tabs = {"الرئيسية", "نظام البانج", "ESP", "معلومات اللاعب"}

local BangActive = false
local TargetPlayer = nil
local BangSpeed = 3.5 -- سرعة متابعة الهدف (مسافة أساسية متحركة)

local OSCILLATION_AMPLITUDE = 2.5
local OSCILLATION_FREQUENCY = 1.2

local ESP_Active = false
local ESP_Color = Color3.fromRGB(255, 0, 0)

-- UI إعدادات الحجم
local UI_MIN_SIZE = Vector2.new(350, 250)
local UI_MAX_SIZE = Vector2.new(700, 480)

-- دوال مساعدة للـ UI
local function addUICorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

local function addShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://4767419729" -- Shadow asset
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Size = UDim2.new(1, 14, 1, 14)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.SliceScale = 0.06
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
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
    TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    task.delay(duration or 3, function()
        TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- نوكليب
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
        if humanoid then humanoid.PlatformStand = true end
    else
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.PlatformStand = false end
        end
    end
end)

-- متابعة الهدف مع تذبذب وسرعة متحكم بها
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

    local basePosition = targetHRP.Position - targetLookVector * BangSpeed
    local desiredPosition = basePosition + targetLookVector * oscillation

    local vectorToDesired = desiredPosition - targetHRP.Position
    if vectorToDesired:Dot(targetLookVector) > 0 then
        desiredPosition = basePosition
    end

    -- تعويض حركة سلسة بتحديث CFrame تدريجياً  
    local currentPos = localHRP.Position
    local lerpPos = currentPos:Lerp(desiredPosition, 0.15)
    localHRP.CFrame = CFrame.new(lerpPos, targetHRP.Position)
end

RS:BindToRenderStep("EliteBangSystem", Enum.RenderPriority.Character.Value + 3, function(dt)
    if BangActive then
        FollowTarget(dt)
    end
end)

-- البحث عن لاعب باسم
local function GetPlayerByName(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name:lower()) then return plr end
    end
    return nil
end

-- تشغيل وإيقاف Bang
local function StartBang(targetName)
    local target = GetPlayerByName(targetName)
    if not target then
        createNotification("لم يتم العثور على اللاعب: " .. targetName, 3)
        return false
    end
    TargetPlayer = target
    BangActive = true
    SetNoclip(true)
    createNotification("تم تفعيل نظام البانج على: " .. TargetPlayer.Name, 3)
    return true
end

local function StopBang()
    BangActive = false
    TargetPlayer = nil
    SetNoclip(false)
    createNotification("تم إيقاف نظام البانج وإعادة التحكم", 3)
end

-- ESP System --  
local ESP_Boxes = {}
local ESP_Texts = {}

local function CreateESPForPlayer(plr)
    if ESP_Boxes[plr] then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = nil
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Transparency = 0.6
    box.Color3 = ESP_Color
    box.Size = Vector3.new(4, 6, 1)
    box.Parent = workspace.CurrentCamera

    local text = Instance.new("BillboardGui")
    text.Name = "ESPText"
    text.Adornee = nil
    text.AlwaysOnTop = true
    text.Size = UDim2.new(0, 150, 0, 40)
    text.StudsOffset = Vector3.new(0, 3, 0)
    text.Parent = workspace.CurrentCamera

    local label = Instance.new("TextLabel", text)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = ESP_Color
    label.TextStrokeTransparency = 0.5
    label.Text = plr.Name

    ESP_Boxes[plr] = box
    ESP_Texts[plr] = text
end

local function RemoveESPForPlayer(plr)
    if ESP_Boxes[plr] then
        ESP_Boxes[plr]:Destroy()
        ESP_Boxes[plr] = nil
    end
    if ESP_Texts[plr] then
        ESP_Texts[plr]:Destroy()
        ESP_Texts[plr] = nil
    end
end

local function UpdateESP()
    if not ESP_Active then return end

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not ESP_Boxes[plr] then
                CreateESPForPlayer(plr)
            end
            local hrp = plr.Character.HumanoidRootPart
            ESP_Boxes[plr].Adornee = hrp
            ESP_Boxes[plr].Color3 = ESP_Color
            ESP_Texts[plr].Adornee = hrp
            ESP_Texts[plr].TextLabel.TextColor3 = ESP_Color
            ESP_Texts[plr].TextLabel.Text = plr.Name
        else
            RemoveESPForPlayer(plr)
        end
    end
end

RS:BindToRenderStep("ESPUpdate", Enum.RenderPriority.Camera.Value + 1, UpdateESP)

-- UI الرئيسي  
local MainFrame = Instance.new("Frame", EliteMenu)
MainFrame.Size = UDim2.new(0, 650, 0, 480)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 10, 70)
MainFrame.BorderSizePixel = 0
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
addUICorner(MainFrame, 20)
addShadow(MainFrame)

-- سحب الواجهة  
local dragging, dragInput, dragStart, startPos
local function updatePosition(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updatePosition(input) end
end)

-- تكبير وتصغير مع انيميشن  
local scale = 1
local function scaleUI(amount)
    scale = math.clamp(scale + amount, 0.6, 1.5)
    local newSize = UDim2.new(0, 650 * scale, 0, 480 * scale)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = newSize}):Play()
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        scaleUI(input.Position.Z > 0 and 0.1 or -0.1)
    end
end)

-- عنوان  
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 28
TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
TitleLabel.Text = "Elite V5 PRO 2025 - النسخة المتكاملة"
TitleLabel.TextScaled = true

-- تبويبات  
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(0, 160, 1, -50)
TabsFrame.Position = UDim2.new(0, 0, 0, 50)
TabsFrame.BackgroundColor3 = Color3.fromRGB(20, 5, 40)
TabsFrame.BorderSizePixel = 0
addUICorner(TabsFrame, 16)
addShadow(TabsFrame)

local Pages = {}
local Buttons = {}
local selectedTabIndex = 1

local function switchTab(index)
    if selectedTabIndex == index then return end
    Buttons[selectedTabIndex].BackgroundColor3 = Color3.fromRGB(80, 30, 120)
    Buttons[index].BackgroundColor3 = Color3.fromRGB(130, 50, 220)
    Pages[selectedTabIndex].Visible = false
    Pages[index].Visible = true
    selectedTabIndex = index
end

for i, tabName in ipairs(Tabs) do
    local btn = Instance.new("TextButton", TabsFrame)
    btn.Size = UDim2.new(1, -20, 0, 50)
    btn.Position = UDim2.new(0, 10, 0, (i - 1) * 60 + 10)
    btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(80, 30, 120)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = tabName
    addUICorner(btn, 14)
    addShadow(btn)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(170, 70, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = (i == selectedTabIndex) and Color3.fromRGB(130, 50, 220) or Color3.fromRGB(80, 30, 120)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        switchTab(i)
    end)

    Buttons[i] = btn
end

for i = 1, #Tabs do
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -160, 1, -50)
    page.Position = UDim2.new(0, 160, 0, 50)
    page.BackgroundTransparency = 1
    page.Visible = (i == 1)
    Pages[i] = page
end

-- الصفحة 1: الرئيسية مع تحكم كامل  
do
    local page = Pages[1]

    -- Speed Control Label  
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 180, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    speedLabel.Text = "سرعة المشي (WalkSpeed): 16"

    local walkSpeedSlider = Instance.new("TextBox", page)
    walkSpeedSlider.Size = UDim2.new(0, 100, 0, 30)
    walkSpeedSlider.Position = UDim2.new(0, 20, 0, 60)
    walkSpeedSlider.PlaceholderText = "أدخل سرعة المشي"
    walkSpeedSlider.Text = "16"
    walkSpeedSlider.Font = Enum.Font.GothamBold
    walkSpeedSlider.TextSize = 18
    walkSpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    walkSpeedSlider.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    addUICorner(walkSpeedSlider, 10)

    walkSpeedSlider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(walkSpeedSlider.Text)
            if val and val >= 8 and val <= 100 then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = val
                    speedLabel.Text = ("سرعة المشي (WalkSpeed): %d"):format(val)
                    createNotification("تم تعديل سرعة المشي إلى " .. val, 2)
                end
            else
                createNotification("الرجاء إدخال قيمة بين 8 و 100", 3)
                walkSpeedSlider.Text = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 16)
            end
        end
    end)

    -- Jump Power Control  
    local jumpLabel = Instance.new("TextLabel", page)
    jumpLabel.Size = UDim2.new(0, 180, 0, 30)
    jumpLabel.Position = UDim2.new(0, 220, 0, 20)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 20
    jumpLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    jumpLabel.Text = "قوة القفز (JumpPower): 50"

    local jumpPowerSlider = Instance.new("TextBox", page)
    jumpPowerSlider.Size = UDim2.new(0, 100, 0, 30)
    jumpPowerSlider.Position = UDim2.new(0, 220, 0, 60)
    jumpPowerSlider.PlaceholderText = "أدخل قوة القفز"
    jumpPowerSlider.Text = "50"
    jumpPowerSlider.Font = Enum.Font.GothamBold
    jumpPowerSlider.TextSize = 18
    jumpPowerSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpPowerSlider.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    addUICorner(jumpPowerSlider, 10)

    jumpPowerSlider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(jumpPowerSlider.Text)
            if val and val >= 20 and val <= 150 then
                local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = val
                    jumpLabel.Text = ("قوة القفز (JumpPower): %d"):format(val)
                    createNotification("تم تعديل قوة القفز إلى " .. val, 2)
                end
            else
                createNotification("الرجاء إدخال قيمة بين 20 و 150", 3)
                jumpPowerSlider.Text = tostring(LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower or 50)
            end
        end
    end)

    -- Fly Toggle  
    local flyToggle = Instance.new("TextButton", page)
    flyToggle.Size = UDim2.new(0, 140, 0, 40)
    flyToggle.Position = UDim2.new(0, 20, 0, 120)
    flyToggle.Text = "تفعيل الطيران"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 20
    flyToggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    flyToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(flyToggle, 15)

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
                createNotification("تم تفعيل الطيران بدون ظهور تأثير السقوط", 3)
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

    -- تحكم سرعة الطيران (اختياري)
    local flySpeedLabel = Instance.new("TextLabel", page)
    flySpeedLabel.Size = UDim2.new(0, 160, 0, 25)
    flySpeedLabel.Position = UDim2.new(0, 180, 0, 130)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 16
    flySpeedLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    flySpeedLabel.Text = "سرعة الطيران: 50"

    local flySpeedBox = Instance.new("TextBox", page)
    flySpeedBox.Size = UDim2.new(0, 100, 0, 25)
    flySpeedBox.Position = UDim2.new(0, 180, 0, 160)
    flySpeedBox.PlaceholderText = "أدخل سرعة الطيران"
    flySpeedBox.Text = "50"
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 16
    flySpeedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedBox.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    addUICorner(flySpeedBox, 10)

    flySpeedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(flySpeedBox.Text)
            if val and val >= 10 and val <= 150 then
                flySpeed = val
                flySpeedLabel.Text = ("سرعة الطيران: %d"):format(val)
                createNotification("تم تعديل سرعة الطيران إلى " .. val, 2)
            else
                createNotification("الرجاء إدخال قيمة بين 10 و 150", 3)
                flySpeedBox.Text = tostring(flySpeed)
            end
        end
    end)

    -- تحديث حركة الطيران في RenderStep  
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

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * flySpeed
            end

            flyBodyVelocity.Velocity = moveDirection
            flyBodyGyro.CFrame = cam.CFrame
        end
    end)
end

-- الصفحة 2: نظام البانج مع تحكم سرعة  
do
    local page = Pages[2]

    local LabelTitle = Instance.new("TextLabel", page)
    LabelTitle.Size = UDim2.new(1, -40, 0, 40)
    LabelTitle.Position = UDim2.new(0, 20, 0, 10)
    LabelTitle.BackgroundTransparency = 1
    LabelTitle.Font = Enum.Font.GothamBold
    LabelTitle.TextSize = 26
    LabelTitle.TextColor3 = Color3.fromRGB(230, 230, 250)
    LabelTitle.Text = "نظام بانج - تتبع اللاعب مع Noclip تلقائي"
    LabelTitle.TextXAlignment = Enum.TextXAlignment.Center

    local InputBox = Instance.new("TextBox", page)
    InputBox.Size = UDim2.new(1, -40, 0, 40)
    InputBox.Position = UDim2.new(0, 20, 0, 60)
    InputBox.PlaceholderText = "أدخل اسم اللاعب الهدف"
    InputBox.Font = Enum.Font.GothamBold
    InputBox.TextSize = 22
    InputBox.TextColor3 = Color3.fromRGB(245, 245, 255)
    InputBox.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(InputBox, 15)

    local StartBtn = Instance.new("TextButton", page)
    StartBtn.Size = UDim2.new(0.48, -10, 0, 45)
    StartBtn.Position = UDim2.new(0, 20, 0, 110)
    StartBtn.Text = "تشغيل البانج"
    StartBtn.Font = Enum.Font.GothamBold
    StartBtn.TextSize = 22
    StartBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
    StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(StartBtn, 15)

    local StopBtn = Instance.new("TextButton", page)
    StopBtn.Size = UDim2.new(0.48, -10, 0, 45)
    StopBtn.Position = UDim2.new(0.52, 0, 0, 110)
    StopBtn.Text = "إيقاف البانج"
    StopBtn.Font = Enum.Font.GothamBold
    StopBtn.TextSize = 22
    StopBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(StopBtn, 15)

    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(1, -40, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 165)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    speedLabel.Text = ("سرعة متابعة الهدف: %.1f"):format(BangSpeed)

    local speedSlider = Instance.new("TextBox", page)
    speedSlider.Size = UDim2.new(1, -40, 0, 30)
    speedSlider.Position = UDim2.new(0, 20, 0, 200)
    speedSlider.PlaceholderText = "أدخل سرعة متابعة الهدف (1.0 - 15.0)"
    speedSlider.Text = tostring(BangSpeed)
    speedSlider.Font = Enum.Font.GothamBold
    speedSlider.TextSize = 18
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.BackgroundColor3 = Color3.fromRGB(50, 15, 80)
    addUICorner(speedSlider, 15)

    speedSlider.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedSlider.Text)
            if val and val >= 1 and val <= 15 then
                BangSpeed = val
                speedLabel.Text = ("سرعة متابعة الهدف: %.1f"):format(BangSpeed)
                createNotification("تم تعديل سرعة متابعة الهدف إلى " .. val, 2)
            else
                createNotification("الرجاء إدخال قيمة بين 1.0 و 15.0", 3)
                speedSlider.Text = tostring(BangSpeed)
            end
        end
    end)

    StartBtn.MouseButton1Click:Connect(function()
        local name = InputBox.Text
        if name == "" then
            createNotification("يرجى إدخال اسم اللاعب الهدف", 2)
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

-- الصفحة 3: نظام ESP مع خيارات تحكم  
do
    local page = Pages[3]

    local LabelTitle = Instance.new("TextLabel", page)
    LabelTitle.Size = UDim2.new(1, -40, 0, 40)
    LabelTitle.Position = UDim2.new(0, 20, 0, 10)
    LabelTitle.BackgroundTransparency = 1
    LabelTitle.Font = Enum.Font.GothamBold
    LabelTitle.TextSize = 26
    LabelTitle.TextColor3 = Color3.fromRGB(230, 230, 250)
    LabelTitle.Text = "نظام ESP - تفعيل وتعطيل وتغيير اللون"
    LabelTitle.TextXAlignment = Enum.TextXAlignment.Center

    local toggleESP = Instance.new("TextButton", page)
    toggleESP.Size = UDim2.new(0.5, -20, 0, 45)
    toggleESP.Position = UDim2.new(0, 20, 0, 60)
    toggleESP.Text = "تفعيل ESP"
    toggleESP.Font = Enum.Font.GothamBold
    toggleESP.TextSize = 22
    toggleESP.BackgroundColor3 = Color3.fromRGB(0, 180, 70)
    toggleESP.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(toggleESP, 15)

    local colorLabel = Instance.new("TextLabel", page)
    colorLabel.Size = UDim2.new(0.5, -20, 0, 30)
    colorLabel.Position = UDim2.new(0.5, 10, 0, 65)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel.TextSize = 18
    colorLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
    colorLabel.Text = "لون ESP: أحمر"

    local colors = {
        {Name = "أحمر", Color = Color3.fromRGB(255, 0, 0)},
        {Name = "أزرق", Color = Color3.fromRGB(0, 170, 255)},
        {Name = "أخضر", Color = Color3.fromRGB(0, 255, 0)},
        {Name = "أصفر", Color = Color3.fromRGB(255, 255, 0)},
        {Name = "بنفسجي", Color = Color3.fromRGB(170, 0, 255)},
    }

    local currentColorIndex = 1

    local btnChangeColor = Instance.new("TextButton", page)
    btnChangeColor.Size = UDim2.new(0.5, -20, 0, 40)
    btnChangeColor.Position = UDim2.new(0, 20, 0, 110)
    btnChangeColor.Text = "تغيير لون ESP"
    btnChangeColor.Font = Enum.Font.GothamBold
    btnChangeColor.TextSize = 20
    btnChangeColor.BackgroundColor3 = Color3.fromRGB(70, 20, 130)
    btnChangeColor.TextColor3 = Color3.fromRGB(255, 255, 255)
    addUICorner(btnChangeColor, 15)

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
        colorLabel.Text = "لون ESP: " .. colors[currentColorIndex].Name
        createNotification("تم تغيير لون ESP إلى " .. colors[currentColorIndex].Name, 2)
    end)
end

-- الصفحة 4: معلومات اللاعب مع صورة البروفايل  
do
    local page = Pages[4]

    local LabelTitle = Instance.new("TextLabel", page)
    LabelTitle.Size = UDim2.new(1, -40, 0, 40)
    LabelTitle.Position = UDim2.new(0, 20, 0, 10)
    LabelTitle.BackgroundTransparency = 1
    LabelTitle.Font = Enum.Font.GothamBold
    LabelTitle.TextSize = 26
    LabelTitle.TextColor3 = Color3.fromRGB(230, 230, 250)
    LabelTitle.Text = "معلومات اللاعب"
    LabelTitle.TextXAlignment = Enum.TextXAlignment.Center

    -- صورة البروفايل
    local profileImage = Instance.new("ImageLabel", page)
    profileImage.Size = UDim2.new(0, 140, 0, 140)
    profileImage.Position = UDim2.new(0, 20, 0, 60)
    profileImage.BackgroundTransparency = 1
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
    addUICorner(profileImage, 70)
    addShadow(profileImage)

    local infoFrame = Instance.new("Frame", page)
    infoFrame.Size = UDim2.new(0, 300, 0, 140)
    infoFrame.Position = UDim2.new(0, 180, 0, 60)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 70)
    addUICorner(infoFrame, 20)
    addShadow(infoFrame)

    local usernameLabel = Instance.new("TextLabel", infoFrame)
    usernameLabel.Size = UDim2.new(1, -20, 0, 40)
    usernameLabel.Position = UDim2.new(0, 10, 0, 10)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 26
    usernameLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    usernameLabel.Text = "اسم المستخدم: " .. LocalPlayer.Name
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left

    local useridLabel = Instance.new("TextLabel", infoFrame)
    useridLabel.Size = UDim2.new(1, -20, 0, 30)
    useridLabel.Position = UDim2.new(0, 10, 0, 60)
    useridLabel.BackgroundTransparency = 1
    useridLabel.Font = Enum.Font.Gotham
    useridLabel.TextSize = 20
    useridLabel.TextColor3 = Color3.fromRGB(210, 210, 255)
    useridLabel.Text = "معرف المستخدم (UserId): " .. tostring(LocalPlayer.UserId)
    useridLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- معلومات حالة الاتصال  
    local pingLabel = Instance.new("TextLabel", infoFrame)
    pingLabel.Size = UDim2.new(1, -20, 0, 30)
    pingLabel.Position = UDim2.new(0, 10, 0, 95)
    pingLabel.BackgroundTransparency = 1
    pingLabel.Font = Enum.Font.Gotham
    pingLabel.TextSize = 20
    pingLabel.TextColor3 = Color3.fromRGB(210, 210, 255)
    pingLabel.Text = "جودة الاتصال: جاري التحديث..."
    pingLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- تحديث Ping كل 3 ثواني  
    task.spawn(function()
        while EliteMenu.Enabled do
            local ping = LocalPlayer:GetNetworkPing() * 1000
            pingLabel.Text = ("جودة الاتصال: %d ms"):format(math.floor(ping))
            task.wait(3)
        end
    end)
end

-- زر إظهار/إخفاء القائمة  
local toggleKey = Enum.KeyCode.RightControl -- تعديل المفتاح حسب الرغبة
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        EliteMenu.Enabled = not EliteMenu.Enabled
        if EliteMenu.Enabled then
            createNotification("تم فتح قائمة Elite V5 PRO", 2)
        else
            createNotification("تم إغلاق قائمة Elite V5 PRO", 2)
        end
    end
end)

-- Animation FadeIn & FadeOut للقائمة  
EliteMenu:GetPropertyChangedSignal("Enabled"):Connect(function()
    if EliteMenu.Enabled then
        MainFrame.BackgroundTransparency = 1
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
    end
end)

-- بدء القائمة مقفلة، لتفعيلها اضغط RightControl  
createNotification("اضغط RightControl لفتح القائمة", 4)

-- تحسينات عامة:
-- - حركات السحب سلسة
-- - تكبير وتصغير باستخدام عجلة الماوس
-- - ألوان متناسقة وواجهة احترافية  
-- - تحكم كامل وسلس في جميع الخصائص المطلوبة  
-- - نظام بانج (Bang) مع تحكم بالسرعة ونوكليب تلقائي  
-- - ESP متكامل مع تفعيل/تعطيل وتغيير ألوان  
-- - نظام طيران بدون ظهور animation سقوط  

-- ملاحظة أخيرة:
-- يفضل اختبار كل خاصية في بيئة آمنة والتأكد من أن كل شيء يعمل بدون تعارض مع السكربتات الأخرى

