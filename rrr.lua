-- Elite V5 PRO 2025 - Full Enhanced Script with R6/R15 compatible Emotes
-- Author: FNLOXER-inspired pro version

-- Cleanup old menu if exists
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Create main GUI container
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.Parent = game.CoreGui
EliteMenu.ResetOnSpawn = false

-- Utility: Add UICorner to UI elements
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

-- Notification system
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

-- Main Frame Setup
local MainFrame = Instance.new("Frame", EliteMenu)
local defaultSize = UDim2.new(0, 560, 0, 500)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

-- Title Label
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 215, 255)
Title.Text = "🔥 Elite V5 PRO 2025 🔥"

-- Close Button
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

-- Minimize Button
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
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = true end
        end)
        isMinimized = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = false end
        end)
        isMinimized = true
    end
end)

-- Tabs Setup
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

-------------------------------
-- Tab 1: الرئيسية (Main Tab)
-------------------------------
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

    local humanoid = nil
    local function updateHumanoid()
        if LocalPlayer.Character then
            humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        else
            humanoid = nil
        end
    end
    LocalPlayer.CharacterAdded:Connect(updateHumanoid)
    updateHumanoid()

    local flyEnabled = false
    local flySpeed = 50
    local bodyGyro, bodyVelocity

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

            if option.Name == "Speed Hack" then
                if humanoid then
                    humanoid.WalkSpeed = options[i].State and 50 or 16
                    createNotification("Speed Hack " .. (options[i].State and "مفعل" or "معطل"))
                end
            elseif option.Name == "Jump Boost" then
                if humanoid then
                    humanoid.JumpPower = options[i].State and 100 or 50
                    createNotification("Jump Boost " .. (options[i].State and "مفعل" or "معطل"))
                end
            elseif option.Name == "Fly Mode" then
                flyEnabled = options[i].State
                if flyEnabled then
                    createNotification("Fly Mode مفعل - استخدم WASD + Space + Ctrl للطيران")
                else
                    createNotification("Fly Mode معطل")
                    if bodyGyro then
                        bodyGyro:Destroy()
                        bodyGyro = nil
                    end
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
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

    -- Fly Mode Movement Handler
    RS:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value + 1, function()
        if not flyEnabled or not LocalPlayer.Character or not humanoid then return end

        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        local speed = flySpeed

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
            moveDir = moveDir.Unit * speed
        else
            moveDir = Vector3.new(0,0,0)
        end

        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = root
        end
        bodyVelocity.Velocity = moveDir

        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.CFrame = cam.CFrame
            bodyGyro.Parent = root
        end
        bodyGyro.CFrame = cam.CFrame
    end)
end

----------------------
-- Tab 2: Bang System --
----------------------
do
    local page = Pages[2]
    page:ClearAllChildren()

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -20, 0, 50)
    infoLabel.Position = UDim2.new(0, 10, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.Text = "نظام Bang: يتحرك اللاعب تلقائيًا خلف الهدف المحدد."

    local targetLabel = Instance.new("TextLabel", page)
    targetLabel.Size = UDim2.new(1, -20, 0, 35)
    targetLabel.Position = UDim2.new(0, 10, 0, 70)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 18
    targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    targetLabel.Text = "الهدف الحالي: لا يوجد"

    local toggleBtn = Instance.new("TextButton", page)
    toggleBtn.Size = UDim2.new(0, 150, 0, 40)
    toggleBtn.Position = UDim2.new(0, 10, 0, 115)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 160)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 20
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    toggleBtn.Text = "تفعيل Bang"
    addUICorner(toggleBtn, 18)

    local isBangActive = false
    local targetPlayer = nil

    -- Helper function to find closest player to mouse
    local function getClosestPlayerToMouse()
        local mouse = LocalPlayer:GetMouse()
        local closestPlayer = nil
        local shortestDist = math.huge

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if onScreen then
                    local mousePos = Vector2.new(mouse.X, mouse.Y)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist and dist < 150 then -- 150 pixels threshold
                        shortestDist = dist
                        closestPlayer = plr
                    end
                end
            end
        end
        return closestPlayer
    end

    toggleBtn.MouseButton1Click:Connect(function()
        if not isBangActive then
            local closest = getClosestPlayerToMouse()
            if closest then
                targetPlayer = closest
                targetLabel.Text = "الهدف الحالي: " .. targetPlayer.Name
                createNotification("تم تحديد الهدف: " .. targetPlayer.Name)
                toggleBtn.Text = "إيقاف Bang"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 90)
                isBangActive = true
            else
                createNotification("لم يتم العثور على هدف بالقرب من مؤشر الفأرة", 3)
            end
        else
            isBangActive = false
            targetPlayer = nil
            targetLabel.Text = "الهدف الحالي: لا يوجد"
            toggleBtn.Text = "تفعيل Bang"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(140, 0, 160)
            createNotification("تم إيقاف نظام Bang")
        end
    end)

    RS:BindToRenderStep("BangMove", Enum.RenderPriority.Character.Value + 1, function()
        if isBangActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = targetPlayer.Character.HumanoidRootPart
            local localHRP = LocalPlayer.Character.HumanoidRootPart
            -- Position player 1.5 studs behind the target (relative to target lookVector)
            local behindPos = targetHRP.CFrame * CFrame.new(0, 0, 1.5)
            localHRP.CFrame = CFrame.new(behindPos.Position.X, localHRP.Position.Y, behindPos.Position.Z)
        end
    end)
end

-------------------
-- Tab 3: Emotes --
-------------------
do
    local page = Pages[3]
    page:ClearAllChildren()

    local emotes = {
        {Name = "Dolphin Dance", AnimationId = "rbxassetid://5938365243"},
        {Name = "Wave", AnimationId = "rbxassetid://4949273707"},
        {Name = "Laugh", AnimationId = "rbxassetid://507766666"},
    }

    local emoteList = Instance.new("ScrollingFrame", page)
    emoteList.Size = UDim2.new(1, -20, 1, -60)
    emoteList.Position = UDim2.new(0, 10, 0, 10)
    emoteList.BackgroundColor3 = Color3.fromRGB(50, 10, 70)
    emoteList.BorderSizePixel = 0
    emoteList.CanvasSize = UDim2.new(0, 0, 0, #emotes * 50)
    emoteList.ScrollBarThickness = 6
    addUICorner(emoteList, 14)

    local selectedEmoteIndex = 1
    local emoteButtons = {}

    local function updateSelected(index)
        for i, btn in pairs(emoteButtons) do
            btn.BackgroundColor3 = (i == index) and Color3.fromRGB(120, 20, 180) or Color3.fromRGB(80, 0, 120)
        end
        selectedEmoteIndex = index
    end

    for i, emote in ipairs(emotes) do
        local btn = Instance.new("TextButton", emoteList)
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, (i-1)*45)
        btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(120, 20, 180) or Color3.fromRGB(80, 0, 120)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 22
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = emote.Name
        addUICorner(btn, 12)

        btn.MouseButton1Click:Connect(function()
            updateSelected(i)
        end)

        emoteButtons[i] = btn
    end

    -- Play Emote Button
    local playBtn = Instance.new("TextButton", page)
    playBtn.Size = UDim2.new(0, 150, 0, 40)
    playBtn.Position = UDim2.new(0.5, -75, 1, -50)
    playBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 90)
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextSize = 22
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.Text = "تشغيل الحركة"
    addUICorner(playBtn, 14)

    -- Emote player function compatible with R6 and R15
    local function playEmote(character, animationId)
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = humanoid
        end

        local animation = Instance.new("Animation")
        animation.AnimationId = animationId

        local animTrack = animator:LoadAnimation(animation)
        animTrack.Priority = Enum.AnimationPriority.Action
        animTrack:Play()

        -- Optional: loop animation
        animTrack.Stopped:Connect(function()
            animTrack:Play()
        end)

        return animTrack
    end

    playBtn.MouseButton1Click:Connect(function()
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChildOfClass("Humanoid") then
            createNotification("شخصيتك غير موجودة أو لا تحتوي على Humanoid!", 3)
            return
        end

        local animId = emotes[selectedEmoteIndex].AnimationId
        playEmote(character, animId)
        createNotification("تم تشغيل الحركة: " .. emotes[selectedEmoteIndex].Name, 3)
    end)
end

--------------------------
-- Tab 4: Player Info --
--------------------------
do
    local page = Pages[4]
    page:ClearAllChildren()

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -20, 0, 60)
    infoLabel.Position = UDim2.new(0, 10, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 22
    infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoLabel.Text = "معلومات اللاعب - تحديث مباشر"

    local statsText = Instance.new("TextLabel", page)
    statsText.Size = UDim2.new(1, -20, 1, -80)
    statsText.Position = UDim2.new(0, 10, 0, 80)
    statsText.BackgroundTransparency = 1
    statsText.Font = Enum.Font.Gotham
    statsText.TextSize = 18
    statsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statsText.TextWrapped = true
    statsText.TextYAlignment = Enum.TextYAlignment.Top
    statsText.Text = ""

    local function updateStats()
        local plr = LocalPlayer
        local char = plr.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")

        local health = humanoid and math.floor(humanoid.Health) or "غير معروف"
        local maxHealth = humanoid and math.floor(humanoid.MaxHealth) or "غير معروف"
        local walkSpeed = humanoid and math.floor(humanoid.WalkSpeed) or "غير معروف"
        local jumpPower = humanoid and math.floor(humanoid.JumpPower) or "غير معروف"
        local position = char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.Position or Vector3.new(0,0,0)

        statsText.Text = 
            "الاسم: " .. plr.Name .. "\n" ..
            "الصحة: " .. health .. " / " .. maxHealth .. "\n" ..
            "سرعة المشي: " .. walkSpeed .. "\n" ..
            "قوة القفز: " .. jumpPower .. "\n" ..
            string.format("الموقع: (%.2f, %.2f, %.2f)", position.X, position.Y, position.Z)
    end

    RS:BindToRenderStep("UpdatePlayerInfo", Enum.RenderPriority.Character.Value + 2, function()
        updateStats()
    end)
end

-- Enable the menu toggle key: RightControl
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        EliteMenu.Enabled = not EliteMenu.Enabled
        createNotification("قائمة Elite V5 PRO " .. (EliteMenu.Enabled and "مفتوحة" or "مغلقة"))
    end
end)

-- Start with menu hidden
EliteMenu.Enabled = false

createNotification("تم تحميل Elite V5 PRO بنجاح! اضغط RightControl لفتح القائمة.")

-- END OF SCRIPT
