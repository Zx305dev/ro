-- Elite V5 PRO 2025 - Full Robust Lua Script for Roblox
-- Author: FNLOXER Inspired - Ultimate Freecam, Fly, Bang & Emotes with Player Info

-- Cleanup old menu
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Main GUI container
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.Parent = game.CoreGui
EliteMenu.ResetOnSpawn = false

-- Utility UICorner
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

-- Notification helper
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
    label.TextColor3 = Color3.new(1, 1, 1)
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

--------------------------------
-- Tab 1: الرئيسية (Main Tab)
--------------------------------
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

    -- Fly Mode movement handler
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
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end

        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity", root)
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end

        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro", root)
            bodyGyro.MaxTorque = Vector3.new(4e5, 4e5, 4e5)
            bodyGyro.P = 20e3
            bodyGyro.CFrame = cam.CFrame
        end

        bodyVelocity.Velocity = moveDir * speed
        bodyGyro.CFrame = cam.CFrame
    end)
end

-------------------------
-- Tab 2: Bang System
-------------------------
do
    local page = Pages[2]
    page:ClearAllChildren()

    -- Target player dropdown + bang trigger behind target
    local targetLabel = Instance.new("TextLabel", page)
    targetLabel.Size = UDim2.new(0, 200, 0, 35)
    targetLabel.Position = UDim2.new(0, 20, 0, 20)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Text = "اختر لاعب للـ Bang:"
    targetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 22

    local targetDropdown = Instance.new("TextButton", page)
    targetDropdown.Size = UDim2.new(0, 200, 0, 35)
    targetDropdown.Position = UDim2.new(0, 230, 0, 20)
    targetDropdown.BackgroundColor3 = Color3.fromRGB(80, 0, 130)
    targetDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 20
    targetDropdown.Text = "لا يوجد هدف"
    addUICorner(targetDropdown, 14)

    local dropdownList = Instance.new("Frame", page)
    dropdownList.Size = UDim2.new(0, 200, 0, 150)
    dropdownList.Position = UDim2.new(0, 230, 0, 55)
    dropdownList.BackgroundColor3 = Color3.fromRGB(30, 10, 70)
    dropdownList.Visible = false
    addUICorner(dropdownList, 14)

    local scrollingFrame = Instance.new("ScrollingFrame", dropdownList)
    scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.ScrollBarThickness = 6
    scrollingFrame.BackgroundTransparency = 1

    local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local selectedTarget = nil

    local function updateDropdownPlayers()
        for _, child in pairs(scrollingFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        local totalHeight = 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton", scrollingFrame)
                btn.Size = UDim2.new(1, -10, 0, 30)
                btn.Position = UDim2.new(0, 5, 0, totalHeight)
                btn.BackgroundColor3 = Color3.fromRGB(70, 0, 120)
                btn.Text = plr.Name
                btn.TextColor3 = Color3.new(1, 1, 1)
                btn.Font = Enum.Font.Gotham
                btn.TextSize = 18
                addUICorner(btn, 12)
                btn.MouseButton1Click:Connect(function()
                    selectedTarget = plr
                    targetDropdown.Text = plr.Name
                    dropdownList.Visible = false
                end)
                totalHeight = totalHeight + 35
            end
        end
        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end

    targetDropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then
            updateDropdownPlayers()
        end
    end)

    local bangBtn = Instance.new("TextButton", page)
    bangBtn.Size = UDim2.new(0, 120, 0, 40)
    bangBtn.Position = UDim2.new(0, 20, 0, 80)
    bangBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 50)
    bangBtn.Text = "تنفيذ Bang 😈"
    bangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    bangBtn.Font = Enum.Font.GothamBold
    bangBtn.TextSize = 22
    addUICorner(bangBtn, 16)

    -- Bang behind target function (teleport + simple attack animation)
    local function executeBang(targetPlayer)
        if not targetPlayer or not targetPlayer.Character then
            createNotification("لم يتم اختيار هدف صالح!", 4)
            return
        end
        local targetRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot or not localRoot then
            createNotification("خطأ في إيجاد نقاط التحرك!", 4)
            return
        end

        -- Position player 2 studs behind the target
        local behindCFrame = targetRoot.CFrame * CFrame.new(0, 0, 2)
        if LocalPlayer.Character then
            LocalPlayer.Character:SetPrimaryPartCFrame(behindCFrame)
        end

        -- Optional: simple punch animation (if available)
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:LoadAnimation(Instance.new("Animation", LocalPlayer.Character){AnimationId = "rbxassetid://507766666"}):Play()
        end

        createNotification("Bang executed on "..targetPlayer.Name.." 😈", 3)
    end

    bangBtn.MouseButton1Click:Connect(function()
        executeBang(selectedTarget)
    end)
end

--------------------------
-- Tab 3: Emote System
--------------------------
do
    local page = Pages[3]
    page:ClearAllChildren()

    local emotes = {
        {Name = "Dolphin Dance", AnimationId = "rbxassetid://5938365243"},
        {Name = "Wave", AnimationId = "rbxassetid://4949273707"},
        {Name = "Laugh", AnimationId = "rbxassetid://507766666"},
    }

    local selectedEmoteIndex = 1

    local emoteLabel = Instance.new("TextLabel", page)
    emoteLabel.Size = UDim2.new(0, 300, 0, 40)
    emoteLabel.Position = UDim2.new(0, 20, 0, 20)
    emoteLabel.BackgroundTransparency = 1
    emoteLabel.TextColor3 = Color3.new(1,1,1)
    emoteLabel.Font = Enum.Font.GothamBold
    emoteLabel.TextSize = 24
    emoteLabel.Text = "اختر الحركة: " .. emotes[selectedEmoteIndex].Name

    local prevBtn = Instance.new("TextButton", page)
    prevBtn.Size = UDim2.new(0, 60, 0, 40)
    prevBtn.Position = UDim2.new(0, 330, 0, 20)
    prevBtn.Text = "<"
    prevBtn.Font = Enum.Font.GothamBold
    prevBtn.TextSize = 32
    prevBtn.TextColor3 = Color3.new(1,1,1)
    prevBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 140)
    addUICorner(prevBtn, 14)

    local nextBtn = Instance.new("TextButton", page)
    nextBtn.Size = UDim2.new(0, 60, 0, 40)
    nextBtn.Position = UDim2.new(0, 400, 0, 20)
    nextBtn.Text = ">"
    nextBtn.Font = Enum.Font.GothamBold
    nextBtn.TextSize = 32
    nextBtn.TextColor3 = Color3.new(1,1,1)
    nextBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 140)
    addUICorner(nextBtn, 14)

    local playBtn = Instance.new("TextButton", page)
    playBtn.Size = UDim2.new(0, 160, 0, 50)
    playBtn.Position = UDim2.new(0, 20, 0, 80)
    playBtn.Text = "تشغيل الحركة"
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextSize = 28
    playBtn.TextColor3 = Color3.new(1,1,1)
    playBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
    addUICorner(playBtn, 20)

    prevBtn.MouseButton1Click:Connect(function()
        selectedEmoteIndex = selectedEmoteIndex - 1
        if selectedEmoteIndex < 1 then
            selectedEmoteIndex = #emotes
        end
        emoteLabel.Text = "اختر الحركة: " .. emotes[selectedEmoteIndex].Name
    end)

    nextBtn.MouseButton1Click:Connect(function()
        selectedEmoteIndex = selectedEmoteIndex + 1
        if selectedEmoteIndex > #emotes then
            selectedEmoteIndex = 1
        end
        emoteLabel.Text = "اختر الحركة: " .. emotes[selectedEmoteIndex].Name
    end)

    playBtn.MouseButton1Click:Connect(function()
        local animId = emotes[selectedEmoteIndex].AnimationId
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animation = Instance.new("Animation")
            animation.AnimationId = animId
            local animTrack = humanoid:LoadAnimation(animation)
            animTrack:Play()
            createNotification("تم تشغيل الحركة: "..emotes[selectedEmoteIndex].Name, 3)
        else
            createNotification("لم يتم العثور على شخصية اللاعب!", 3)
        end
    end)
end

----------------------------
-- Tab 4: معلومات اللاعب
----------------------------
do
    local page = Pages[4]
    page:ClearAllChildren()

    local infoLabels = {}

    local function updatePlayerInfo()
        local plr = LocalPlayer
        local character = plr.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        infoLabels["Name"].Text = "الاسم: "..plr.Name
        infoLabels["UserId"].Text = "معرف المستخدم: "..plr.UserId
        if humanoid then
            infoLabels["Health"].Text = ("الصحة: %.1f / %.1f"):format(humanoid.Health, humanoid.MaxHealth)
            infoLabels["WalkSpeed"].Text = "سرعة المشي: "..humanoid.WalkSpeed
            infoLabels["JumpPower"].Text = "قوة القفز: "..humanoid.JumpPower
        else
            infoLabels["Health"].Text = "الصحة: غير متاح"
            infoLabels["WalkSpeed"].Text = "سرعة المشي: غير متاح"
            infoLabels["JumpPower"].Text = "قوة القفز: غير متاح"
        end
    end

    local keys = {"Name", "UserId", "Health", "WalkSpeed", "JumpPower"}
    for i, key in ipairs(keys) do
        local label = Instance.new("TextLabel", page)
        label.Size = UDim2.new(1, -40, 0, 30)
        label.Position = UDim2.new(0, 20, 0, 20 + (i-1)*40)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 22
        label.Text = key .. ": ..."
        infoLabels[key] = label
    end

    -- Refresh player info every 1 second
    RS:BindToRenderStep("UpdatePlayerInfo", Enum.RenderPriority.Camera.Value, function()
        updatePlayerInfo()
    end)
end

-- Show the menu on start
EliteMenu.Enabled = true
createNotification("تم تشغيل Elite V5 PRO 🔥", 3)
