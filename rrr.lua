-- تنظيف المينيو القديم
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")

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
local defaultSize = UDim2.new(0, 560, 0, 500)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -250)
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
        for _, p in pairs(Pages) do p.Visible = true end
        isMinimized = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = false end
        end)
        isMinimized = true
    end
end)

local Tabs = {"الرئيسية", "Bang", "Emote", "معلومات اللاعب"}
local TabButtons = {}
Pages = {}

local function createTabButton(name, idx)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0, 10 + (idx - 1) * 150, 0, 45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BackgroundColor3 = Color3.fromRGB(65, 15, 85)
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(110, 25, 140)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if Pages[idx].Visible then
            TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(65, 15, 85)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for i, p in pairs(Pages) do
            p.Visible = false
            TweenService:Create(TabButtons[i], TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(65, 15, 85)}):Play()
        end
        Pages[idx].Visible = true
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()
    end)

    return btn
end

for i, tabName in ipairs(Tabs) do
    TabButtons[i] = createTabButton(tabName, i)
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -90)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
    page.Visible = (i == 1)
    addUICorner(page, 18)
    Pages[i] = page
end

-----------------------
-- الصفحة 1 - الرئيسية
-----------------------
do
    local page = Pages[1]
    page:ClearAllChildren()

    local options = {
        {Name = "Speed Hack", State = false},
        {Name = "ESP", State = false},
        {Name = "Jump Boost", State = false},
        {Name = "Fly Mode", State = false},
    }

    local labels = {}
    local toggles = {}

    for i, option in ipairs(options) do
        local label = Instance.new("TextLabel", page)
        label.Size = UDim2.new(0, 200, 0, 35)
        label.Position = UDim2.new(0, 20, 0, 20 + (i - 1) * 50)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 22
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = option.Name
        labels[i] = label

        local toggle = Instance.new("TextButton", page)
        toggle.Size = UDim2.new(0, 80, 0, 35)
        toggle.Position = UDim2.new(0, 230, 0, 20 + (i - 1) * 50)
        toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 20
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Text = "OFF"
        addUICorner(toggle, 14)

        toggle.MouseButton1Click:Connect(function()
            options[i].State = not options[i].State
            toggle.Text = options[i].State and "ON" or "OFF"
            toggle.BackgroundColor3 = options[i].State and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(100, 0, 150)

            -- تطبيق خصائص الهاكات بشكل مبسط
            if option.Name == "Speed Hack" then
                if options[i].State then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 50
                    end
                    createNotification("Speed Hack مفعل")
                else
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 16
                    end
                    createNotification("Speed Hack معطل")
                end
            elseif option.Name == "Jump Boost" then
                if options[i].State then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid.JumpPower = 100
                    end
                    createNotification("Jump Boost مفعل")
                else
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid.JumpPower = 50
                    end
                    createNotification("Jump Boost معطل")
                end
            elseif option.Name == "Fly Mode" then
                if options[i].State then
                    createNotification("Fly Mode مفعل - استخدم WASD + Space + Ctrl للطيران")
                    flyEnabled = true
                else
                    createNotification("Fly Mode معطل")
                    flyEnabled = false
                end
            elseif option.Name == "ESP" then
                if options[i].State then
                    createNotification("ESP مفعل")
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not plr.Character:FindFirstChild("BoxESP") then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Name = "BoxESP"
                                box.Adornee = plr.Character.HumanoidRootPart
                                box.AlwaysOnTop = true
                                box.ZIndex = 10
                                box.Size = Vector3.new(2, 5, 1)
                                box.Transparency = 0.6
                                box.Color3 = Color3.fromRGB(255, 0, 0)
                                box.Parent = plr.Character.HumanoidRootPart
                            end
                        end
                    end
                else
                    createNotification("ESP معطل")
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Character and plr.Character:FindFirstChild("BoxESP") then
                            plr.Character.BoxESP:Destroy()
                        end
                    end
                end
            end
        end)

        toggles[i] = toggle
    end

    -- Fly Mode Implementation
    local flyEnabled = false
    local flySpeed = 50
    local bodyGyro, bodyVelocity

    RS.Heartbeat:Connect(function(dt)
        if flyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            if not bodyGyro then
                bodyGyro = Instance.new("BodyGyro", hrp)
                bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                bodyGyro.P = 1e4
            end
            if not bodyVelocity then
                bodyVelocity = Instance.new("BodyVelocity", hrp)
                bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
            local camera = workspace.CurrentCamera
            local moveDir = Vector3.new(0, 0, 0)

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit * flySpeed
            end

            bodyVelocity.Velocity = moveDir
            bodyGyro.CFrame = camera.CFrame
        else
            if bodyGyro then
                bodyGyro:Destroy()
                bodyGyro = nil
            end
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
        end
    end)
end

---------------------------
-- الصفحة 2 - Bang (تحكم حركة ذهاب وإياب مع إضافة حركة جانبية صغيرة)
---------------------------
do
    local page = Pages[2]
    page:ClearAllChildren()

    local targetInput = Instance.new("TextBox", page)
    targetInput.Size = UDim2.new(0, 280, 0, 40)
    targetInput.Position = UDim2.new(0.05, 0, 0.1, 0)
    targetInput.PlaceholderText = "أدخل اسم اللاعب المستهدف (جزء من الاسم)"
    targetInput.Font = Enum.Font.Gotham
    targetInput.TextSize = 22
    targetInput.TextColor3 = Color3.fromRGB(230, 230, 230)
    targetInput.BackgroundColor3 = Color3.fromRGB(55, 20, 75)
    addUICorner(targetInput, 14)

    local toggleBangBtn = Instance.new("TextButton", page)
    toggleBangBtn.Size = UDim2.new(0, 160, 0, 50)
    toggleBangBtn.Position = UDim2.new(0.65, 0, 0.1, 0)
    toggleBangBtn.Text = "تفعيل Bang"
    toggleBangBtn.Font = Enum.Font.GothamBold
    toggleBangBtn.TextSize = 20
    toggleBangBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    toggleBangBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
    toggleBangBtn.AutoButtonColor = false
    addUICorner(toggleBangBtn, 18)

    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 280, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0.25, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.Text = "سرعة الحركة: 1.00"

    local speedSlider = Instance.new("Frame", page)
    speedSlider.Size = UDim2.new(0, 280, 0, 30)
    speedSlider.Position = UDim2.new(0.05, 0, 0.3, 0)
    speedSlider.BackgroundColor3 = Color3.fromRGB(85, 0, 150)
    addUICorner(speedSlider, 14)

    local fillBar = Instance.new("Frame", speedSlider)
    fillBar.Size = UDim2.new(0.1, 0, 1, 0)
    fillBar.BackgroundColor3 = Color3.fromRGB(180, 0, 250)
    addUICorner(fillBar, 14)

    -- Drag logic for slider
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

    local bangActive = false
    local bangSpeed = 1.0
    local targetPlayer = nil
    local bangConnection = nil

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

    local bangMoveDirection = 1
    local bangOffset = 0
    local maxBangOffset = 10

    toggleBangBtn.MouseButton1Click:Connect(function()
        if not bangActive then
            targetPlayer = findTargetPlayer(targetInput.Text)
            if not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                createNotification("لم يتم العثور على اللاعب المستهدف")
                return
            end
            createNotification("تم تفعيل Bang على "..targetPlayer.Name)
            bangActive = true
            toggleBangBtn.Text = "تعطيل Bang"
            toggleBangBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 70)

            bangConnection = RS.Heartbeat:Connect(function()
                if not bangActive or not targetPlayer or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    bangConnection:Disconnect()
                    bangActive = false
                    toggleBangBtn.Text = "تفعيل Bang"
                    toggleBangBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 180)
                    return
                end

                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local targetHRP = targetPlayer.Character.HumanoidRootPart
                if hrp then
                    -- تعديل موقع اللاعب ليكون خلف الهدف بمسافة ثابتة مع حركة جانبية متذبذبة
                    local targetCF = targetHRP.CFrame
                    bangOffset = bangOffset + bangMoveDirection * bangSpeed
                    if math.abs(bangOffset) > maxBangOffset then
                        bangMoveDirection = -bangMoveDirection
                    end

                    -- نحسب مكان خلف الهدف مع حركة يمين ويسار بسيطة
                    local offsetVector = (targetCF.LookVector * -5) + (targetCF.RightVector * (bangOffset / 10))
                    local newPos = targetCF.Position + offsetVector + Vector3.new(0, 3, 0)

                    -- حركة سلسة
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newPos, targetCF.Position)

                    -- منع الحركة العادية
                    if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                        LocalPlayer.Character.Humanoid.WalkSpeed = 0
                        LocalPlayer.Character.Humanoid.JumpPower = 0
                    end
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
            -- استعادة سرعة الحركة والقفز
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
                LocalPlayer.Character.Humanoid.JumpPower = 50
            end
            createNotification("تم تعطيل Bang")
        end
    end)
end

---------------------------
-- الصفحة 3 - Emote (تشغيل ايموت محدد)
---------------------------
do
    local page = Pages[3]
    page:ClearAllChildren()

    local emoteName = "Dolphin Dance" -- اسم الإيموت في Roblox catalog
    local emoteAssetId = 5938365243 -- المعرف الخاص بالإيموت

    local emoteBtn = Instance.new("TextButton", page)
    emoteBtn.Size = UDim2.new(0, 300, 0, 60)
    emoteBtn.Position = UDim2.new(0.5, -150, 0.3, 0)
    emoteBtn.Text = "تشغيل ايموت: Dolphin Dance"
    emoteBtn.Font = Enum.Font.GothamBold
    emoteBtn.TextSize = 24
    emoteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    emoteBtn.BackgroundColor3 = Color3.fromRGB(75, 0, 150)
    addUICorner(emoteBtn, 20)

    local playingEmote = false
    local currentAnimTrack = nil

    local function stopCurrentEmote()
        if currentAnimTrack then
            currentAnimTrack:Stop()
            currentAnimTrack:Destroy()
            currentAnimTrack = nil
        end
        playingEmote = false
    end

    emoteBtn.MouseButton1Click:Connect(function()
        if not LocalPlayer.Character then
            createNotification("الشخصية غير موجودة")
            return
        end

        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            createNotification("لم يتم العثور على Humanoid")
            return
        end

        if playingEmote then
            stopCurrentEmote()
            emoteBtn.Text = "تشغيل ايموت: Dolphin Dance"
            createNotification("تم إيقاف الايموت")
            return
        end

        -- تحميل الانميشن من assetId
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..emoteAssetId

        currentAnimTrack = humanoid:LoadAnimation(animation)
        currentAnimTrack.Priority = Enum.AnimationPriority.Action
        currentAnimTrack:Play()
        playingEmote = true
        emoteBtn.Text = "إيقاف الايموت"
        createNotification("تم تشغيل ايموت Dolphin Dance")
    end)
end

---------------------------
-- الصفحة 4 - معلومات اللاعب
---------------------------
do
    local page = Pages[4]
    page:ClearAllChildren()

    local function createLabel(text, posY)
        local lbl = Instance.new("TextLabel", page)
        lbl.Size = UDim2.new(0, 400, 0, 30)
        lbl.Position = UDim2.new(0, 20, 0, posY)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 22
        lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Text = text
        return lbl
    end

    local nameLabel = createLabel("اسم اللاعب: "..LocalPlayer.Name, 20)
    local userIdLabel = createLabel("UserId: "..LocalPlayer.UserId, 60)
    local accountAgeLabel = createLabel("عمر الحساب: "..LocalPlayer.AccountAge.." يوم", 100)
    local healthLabel = createLabel("الصحة: N/A", 140)
    local walkSpeedLabel = createLabel("سرعة الحركة: N/A", 180)
    local jumpPowerLabel = createLabel("قوة القفز: N/A", 220)

    local function updateStats()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            healthLabel.Text = ("الصحة: %d / %d"):format(humanoid.Health, humanoid.MaxHealth)
            walkSpeedLabel.Text = ("سرعة الحركة: %.1f"):format(humanoid.WalkSpeed)
            jumpPowerLabel.Text = ("قوة القفز: %.1f"):format(humanoid.JumpPower)
        end
    end

    RS.Heartbeat:Connect(updateStats)
end
