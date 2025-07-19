-- Elite Hack System 2025 - Roblox Lua Script
-- Made by ALm6eri
-- Theme color: Purple
-- بنظام Bang مع List لاعبين و إعدادات جاهزة

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Constants for base walk speed and jump power
local WALK_SPEED_BASE = 16
local JUMP_POWER_BASE = 50

-- Colors palette
local COLORS = {
    purple = Color3.fromRGB(128, 0, 128),
    white = Color3.new(1,1,1),
    darkBG = Color3.fromRGB(35, 35, 45),
    red = Color3.fromRGB(220, 50, 50),
}

-- Utility: Add rounded corners to UI elements
local function addUICorner(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = inst
end

-- Notify function (simple console output, can be replaced by GUI notifications)
local function notify(text)
    print("[Notify] " .. text)
end

-- Get HumanoidRootPart safely
local function getHumanoidRootPart(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- Get Humanoid safely
local function getHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

-- Safe number parser with default fallback
local function safeNumberParse(str, default)
    local num = tonumber(str)
    if num and num >= 0 then return num end
    return default
end

-- Get player by exact name
local function getPlayerByName(name)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name == name then return plr end
    end
    return nil
end

-- Hack Settings storage
local hackSettings = {
    noclip = {enabled = false},
    fly = {enabled = false, speed = 50},
    speed = {enabled = false, multiplier = 3},
    jump = {enabled = false, power = 100},
    esp = {enabled = false, color = COLORS.purple, boxes = {}},
    bang = {
        active = false,
        target = nil,
        oscillationFrequency = 1.5, -- Hz
        oscillationAmplitude = 3, -- studs up/down
        baseFollowDistance = 4 -- studs in front of target
    }
}

-- Flags for toggles
local noclipEnabled = false
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local bangActive = false

-- UI containers
local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
ScreenGui.Name = "EliteHackSystem"

local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 400, 0, 450)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -225)
mainFrame.BackgroundColor3 = COLORS.darkBG
addUICorner(mainFrame, 16)

-- Title label
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextColor3 = COLORS.purple
titleLabel.Text = "Elite Hack System 2025 - ALm6eri"

-- Tab Buttons Container
local tabButtonsFrame = Instance.new("Frame", mainFrame)
tabButtonsFrame.Size = UDim2.new(1, -20, 0, 40)
tabButtonsFrame.Position = UDim2.new(0, 10, 0, 60)
tabButtonsFrame.BackgroundTransparency = 1

-- Pages container
local pagesContainer = Instance.new("Frame", mainFrame)
pagesContainer.Size = UDim2.new(1, -20, 1, -110)
pagesContainer.Position = UDim2.new(0, 10, 0, 110)
pagesContainer.BackgroundTransparency = 1

-- Helper function: create tab button and page
local pages = {}
local function createTab(name, index)
    local btn = Instance.new("TextButton", tabButtonsFrame)
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Position = UDim2.new(0, (index - 1) * 95, 0, 0)
    btn.BackgroundColor3 = COLORS.purple
    btn.TextColor3 = COLORS.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = name
    addUICorner(btn, 8)

    local page = Instance.new("Frame", pagesContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    pages[name] = page

    return btn, page
end

-- ================== Tab 1: Player Info ==================
local infoBtn, infoPage = createTab("معلومات اللاعب", 1)

do
    local page = infoPage

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 35)
    infoLabel.Position = UDim2.new(0, 20, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 26
    infoLabel.TextColor3 = COLORS.white
    infoLabel.Text = "معلومات اللاعب"

    local playerImage = Instance.new("ImageLabel", page)
    playerImage.Size = UDim2.new(0, 140, 0, 140)
    playerImage.Position = UDim2.new(0, 20, 0, 55)
    playerImage.BackgroundColor3 = COLORS.darkBG
    playerImage.BorderSizePixel = 0
    addUICorner(playerImage, 12)
    playerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    local playerNameLabel = Instance.new("TextLabel", page)
    playerNameLabel.Size = UDim2.new(0, 250, 0, 35)
    playerNameLabel.Position = UDim2.new(0, 180, 0, 70)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextSize = 24
    playerNameLabel.TextColor3 = COLORS.white
    playerNameLabel.Text = "الاسم: " .. LocalPlayer.Name

    local playerUserIdLabel = Instance.new("TextLabel", page)
    playerUserIdLabel.Size = UDim2.new(0, 250, 0, 30)
    playerUserIdLabel.Position = UDim2.new(0, 180, 0, 110)
    playerUserIdLabel.BackgroundTransparency = 1
    playerUserIdLabel.Font = Enum.Font.GothamBold
    playerUserIdLabel.TextSize = 18
    playerUserIdLabel.TextColor3 = COLORS.white
    playerUserIdLabel.Text = "UserID: " .. tostring(LocalPlayer.UserId)

    local playerAccountAgeLabel = Instance.new("TextLabel", page)
    playerAccountAgeLabel.Size = UDim2.new(0, 250, 0, 30)
    playerAccountAgeLabel.Position = UDim2.new(0, 180, 0, 145)
    playerAccountAgeLabel.BackgroundTransparency = 1
    playerAccountAgeLabel.Font = Enum.Font.GothamBold
    playerAccountAgeLabel.TextSize = 18
    playerAccountAgeLabel.TextColor3 = COLORS.white
    playerAccountAgeLabel.Text = "عمر الحساب: " .. tostring(LocalPlayer.AccountAge) .. " يوم"

    coroutine.wrap(function()
        while true do
            wait(60)
            playerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
        end
    end)()
end

-- ================== Tab 2: ESP System ==================
local espBtn, espPage = createTab("نظام ESP", 2)

do
    local page = espPage

    local espTitle = Instance.new("TextLabel", page)
    espTitle.Size = UDim2.new(1, -40, 0, 40)
    espTitle.Position = UDim2.new(0, 20, 0, 10)
    espTitle.BackgroundTransparency = 1
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 24
    espTitle.TextColor3 = COLORS.white
    espTitle.Text = "نظام ESP"

    local espToggleBtn = Instance.new("TextButton", page)
    espToggleBtn.Size = UDim2.new(0.4, 0, 0, 40)
    espToggleBtn.Position = UDim2.new(0, 20, 0, 60)
    espToggleBtn.BackgroundColor3 = COLORS.purple
    espToggleBtn.TextColor3 = COLORS.white
    espToggleBtn.Font = Enum.Font.GothamBold
    espToggleBtn.TextSize = 20
    espToggleBtn.Text = "تفعيل ESP"
    addUICorner(espToggleBtn, 10)

    local colorLabel = Instance.new("TextLabel", page)
    colorLabel.Size = UDim2.new(0.4, 0, 0, 30)
    colorLabel.Position = UDim2.new(0, 20, 0, 110)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel.TextSize = 18
    colorLabel.TextColor3 = COLORS.white
    colorLabel.Text = "اختر لون ESP:"

    local colorDropdown = Instance.new("TextBox", page)
    colorDropdown.Size = UDim2.new(0.4, 0, 0, 30)
    colorDropdown.Position = UDim2.new(0, 150, 0, 110)
    colorDropdown.PlaceholderText = "purple / red / green / white"
    colorDropdown.Font = Enum.Font.GothamBold
    colorDropdown.TextSize = 16
    colorDropdown.TextColor3 = COLORS.white
    colorDropdown.BackgroundColor3 = COLORS.darkBG
    addUICorner(colorDropdown, 8)

    local function createESPBox(player)
        local box = Instance.new("BillboardGui")
        box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        box.Size = UDim2.new(0, 100, 0, 40)
        box.AlwaysOnTop = true
        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = hackSettings.esp.color
        frame.BorderSizePixel = 1
        frame.BorderColor3 = COLORS.white
        addUICorner(frame, 8)
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Text = player.Name
        return box
    end

    local function updateESPColor(colorName)
        local c = COLORS[colorName:lower()] or COLORS.purple
        hackSettings.esp.color = c
        for _, box in pairs(hackSettings.esp.boxes) do
            if box and box.Frame then
                box.Frame.BackgroundColor3 = c
            end
        end
    end

    local function removeESPBoxes()
        for _, box in pairs(hackSettings.esp.boxes) do
            if box then box:Destroy() end
        end
        hackSettings.esp.boxes = {}
    end

    espToggleBtn.MouseButton1Click:Connect(function()
        hackSettings.esp.enabled = not hackSettings.esp.enabled
        if hackSettings.esp.enabled then
            espToggleBtn.Text = "إيقاف ESP"
            notify("تم تفعيل ESP")
            -- إنشاء الصناديق لكل اللاعبين
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local box = createESPBox(plr)
                    box.Parent = workspace.CurrentCamera
                    box.Frame = box:FindFirstChildOfClass("Frame")
                    table.insert(hackSettings.esp.boxes, box)
                end
            end
        else
            espToggleBtn.Text = "تفعيل ESP"
            notify("تم إيقاف ESP")
            removeESPBoxes()
        end
    end)

    colorDropdown.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            updateESPColor(colorDropdown.Text)
        end
    end)
end

-- ================== Tab 3: Hacks (Noclip, Fly, Speed, Jump) ==================
local hacksBtn, hacksPage = createTab("الهاكات", 3)

do
    local page = hacksPage
    local startY = 20
    local paddingY = 50

    -- Noclip toggle button
    local noclipBtn = Instance.new("TextButton", page)
    noclipBtn.Size = UDim2.new(0.4, 0, 0, 40)
    noclipBtn.Position = UDim2.new(0, 20, 0, startY)
    noclipBtn.BackgroundColor3 = COLORS.purple
    noclipBtn.TextColor3 = COLORS.white
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 20
    noclipBtn.Text = "تفعيل Noclip"
    addUICorner(noclipBtn, 10)

    local function setNoclip(state)
        noclipEnabled = state
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not state
                end
            end
        end
    end

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        setNoclip(noclipEnabled)
        noclipBtn.Text = noclipEnabled and "إيقاف Noclip" or "تفعيل Noclip"
        notify(noclipEnabled and "تم تفعيل Noclip" or "تم إيقاف Noclip")
    end)

    -- Fly toggle button
    local flyBtn = Instance.new("TextButton", page)
    flyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.5, 10, 0, startY)
    flyBtn.BackgroundColor3 = COLORS.purple
    flyBtn.TextColor3 = COLORS.white
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 20
    flyBtn.Text = "تفعيل Fly"
    addUICorner(flyBtn, 10)

    local flying = false
    local flyBodyVelocity = nil

    local function stopFly()
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        local humanoid = getHumanoid(LocalPlayer.Character)
        if humanoid then
            humanoid.PlatformStand = false
        end
        flying = false
    end

    local function startFly()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = getHumanoidRootPart(char)
        local humanoid = getHumanoid(char)
        if not hrp or not humanoid then return end
        humanoid.PlatformStand = true
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp
        flying = true

        RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 1, function()
            if not flying or not flyBodyVelocity then
                RS:UnbindFromRenderStep("FlyMovement")
                return
            end
            local moveDirection = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end

            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit
            end

            flyBodyVelocity.Velocity = moveDirection * hackSettings.fly.speed
        end)
    end

    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        if flyEnabled then
            startFly()
            flyBtn.Text = "إيقاف Fly"
            notify("تم تفعيل Fly")
        else
            stopFly()
            flyBtn.Text = "تفعيل Fly"
            notify("تم إيقاف Fly")
        end
    end)

    -- Speed toggle button
    local speedBtn = Instance.new("TextButton", page)
    speedBtn.Size = UDim2.new(0.4, 0, 0, 40)
    speedBtn.Position = UDim2.new(0, 20, 0, startY + paddingY)
    speedBtn.BackgroundColor3 = COLORS.purple
    speedBtn.TextColor3 = COLORS.white
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.TextSize = 20
    speedBtn.Text = "تفعيل Speed"
    addUICorner(speedBtn, 10)

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        local humanoid = getHumanoid(LocalPlayer.Character)
        if humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = WALK_SPEED_BASE * hackSettings.speed.multiplier
                speedBtn.Text = "إيقاف Speed"
                notify("تم تفعيل Speed")
            else
                humanoid.WalkSpeed = WALK_SPEED_BASE
                speedBtn.Text = "تفعيل Speed"
                notify("تم إيقاف Speed")
            end
        end
    end)

    -- Jump toggle button
    local jumpBtn = Instance.new("TextButton", page)
    jumpBtn.Size = UDim2.new(0.4, 0, 0, 40)
    jumpBtn.Position = UDim2.new(0.5, 10, 0, startY + paddingY)
    jumpBtn.BackgroundColor3 = COLORS.purple
    jumpBtn.TextColor3 = COLORS.white
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 20
    jumpBtn.Text = "تفعيل Jump"
    addUICorner(jumpBtn, 10)

    jumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        local humanoid = getHumanoid(LocalPlayer.Character)
        if humanoid then
            if jumpEnabled then
                humanoid.JumpPower = hackSettings.jump.power
                jumpBtn.Text = "إيقاف Jump"
                notify("تم تفعيل Jump")
            else
                humanoid.JumpPower = JUMP_POWER_BASE
                jumpBtn.Text = "تفعيل Jump"
                notify("تم إيقاف Jump")
            end
        end
    end)
end

-- ================== Tab 4: Bang System ==================
local bangBtn, bangPage = createTab("نظام Bang", 4)

do
    local page = bangPage

    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 26
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "نظام Bang"

    -- Player selection dropdown (simple listbox)
    local targetLabel = Instance.new("TextLabel", page)
    targetLabel.Size = UDim2.new(0.9, 0, 0, 25)
    targetLabel.Position = UDim2.new(0, 20, 0, 60)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 18
    targetLabel.TextColor3 = COLORS.white
    targetLabel.Text = "اختر اللاعب الهدف:"

    local playerList = Instance.new("ScrollingFrame", page)
    playerList.Size = UDim2.new(0.9, 0, 0, 120)
    playerList.Position = UDim2.new(0, 20, 0, 90)
    playerList.BackgroundColor3 = COLORS.darkBG
    playerList.BorderSizePixel = 0
    addUICorner(playerList, 10)
    playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    playerList.ScrollBarThickness = 6

    -- Selected player name display
    local selectedPlayerName = Instance.new("TextLabel", page)
    selectedPlayerName.Size = UDim2.new(0.9, 0, 0, 30)
    selectedPlayerName.Position = UDim2.new(0, 20, 0, 215)
    selectedPlayerName.BackgroundColor3 = COLORS.darkBG
    selectedPlayerName.TextColor3 = COLORS.white
    selectedPlayerName.Font = Enum.Font.GothamBold
    selectedPlayerName.TextSize = 18
    selectedPlayerName.Text = "لا يوجد لاعب محدد"
    addUICorner(selectedPlayerName, 10)

    -- Bang Settings Label (read-only, ready settings)
    local settingsLabel = Instance.new("TextLabel", page)
    settingsLabel.Size = UDim2.new(0.9, 0, 0, 50)
    settingsLabel.Position = UDim2.new(0, 20, 0, 255)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 16
    settingsLabel.TextColor3 = COLORS.white
    settingsLabel.Text = string.format(
        "التردد: %.2f Hz\nالشدة: %.1f studs\nالمسافة: %.1f studs",
        hackSettings.bang.oscillationFrequency,
        hackSettings.bang.oscillationAmplitude,
        hackSettings.bang.baseFollowDistance
    )

    -- Start Bang Button
    local bangStartBtn = Instance.new("TextButton", page)
    bangStartBtn.Size = UDim2.new(0.4, 0, 0, 40)
    bangStartBtn.Position = UDim2.new(0, 20, 0, 320)
    bangStartBtn.BackgroundColor3 = COLORS.purple
    bangStartBtn.TextColor3 = COLORS.white
    bangStartBtn.Font = Enum.Font.GothamBold
    bangStartBtn.TextSize = 20
    bangStartBtn.Text = "تشغيل Bang"
    addUICorner(bangStartBtn, 10)

    -- Stop Bang Button
    local bangStopBtn = Instance.new("TextButton", page)
    bangStopBtn.Size = UDim2.new(0.4, 0, 0, 40)
    bangStopBtn.Position = UDim2.new(0.5, 10, 0, 320)
    bangStopBtn.BackgroundColor3 = COLORS.red
    bangStopBtn.TextColor3 = COLORS.white
    bangStopBtn.Font = Enum.Font.GothamBold
    bangStopBtn.TextSize = 20
    bangStopBtn.Text = "إيقاف Bang"
    addUICorner(bangStopBtn, 10)

    -- Populate playerList with buttons for each player except LocalPlayer
    local function refreshPlayerList()
        for _, child in pairs(playerList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        local yPos = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local plrBtn = Instance.new("TextButton")
                plrBtn.Name = "PlayerBtn_" .. plr.UserId
                plrBtn.Size = UDim2.new(1, -10, 0, 30)
                plrBtn.Position = UDim2.new(0, 5, 0, yPos)
                plrBtn.BackgroundColor3 = COLORS.purple
                plrBtn.TextColor3 = COLORS.white
                plrBtn.Font = Enum.Font.GothamBold
                plrBtn.TextSize = 16
                plrBtn.Text = plr.Name
                plrBtn.Parent = playerList
                addUICorner(plrBtn, 6)

                plrBtn.MouseButton1Click:Connect(function()
                    hackSettings.bang.target = plr
                    selectedPlayerName.Text = "اللاعب المحدد: " .. plr.Name
                end)

                yPos = yPos + 35
            end
        end
        playerList.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end

    refreshPlayerList()
    -- تحديث القائمة عند انضمام أو خروج اللاعبين
    Players.PlayerAdded:Connect(refreshPlayerList)
    Players.PlayerRemoving:Connect(refreshPlayerList)

    -- Bang Coroutine handle
    local bangCoroutine = nil

    -- Start Bang function
    local function startBang()
        if bangActive then notify("Bang بالفعل شغال") return end
        if not hackSettings.bang.target or not hackSettings.bang.target.Character then
            notify("يرجى اختيار لاعب صحيح")
            return
        end

        local targetChar = hackSettings.bang.target.Character
        local targetHRP = getHumanoidRootPart(targetChar)
        local localChar = LocalPlayer.Character
        local localHRP = getHumanoidRootPart(localChar)

        if not targetHRP or not localHRP then
            notify("تعذر الحصول على أجزاء الجسم المطلوبة")
            return
        end

        bangActive = true
        notify("تم بدء Bang على " .. hackSettings.bang.target.Name)

        local startTime = tick()

        bangCoroutine = coroutine.create(function()
            while bangActive do
                local elapsed = tick() - startTime
                if not hackSettings.bang.target or not hackSettings.bang.target.Character then
                    notify("اللاعب الهدف خرج من اللعبة أو الشخصية غير موجودة")
                    break
                end
                targetHRP = getHumanoidRootPart(hackSettings.bang.target.Character)
                if not targetHRP then
                    notify("تعذر تحديث جزء الجسم للاعب الهدف")
                    break
                end

                -- حساب موقع متذبذب أعلى وأسفل بالنسبة للاعب الهدف
                local offsetY = math.sin(elapsed * 2 * math.pi * hackSettings.bang.oscillationFrequency) * hackSettings.bang.oscillationAmplitude

                -- اتجاه أمام اللاعب الهدف (النظر) مع مسافة
                local forward = targetHRP.CFrame.LookVector * hackSettings.bang.baseFollowDistance

                -- موقع متذبذب أمام الهدف مع ارتفاع متغير
                local bangPos = targetHRP.Position + forward + Vector3.new(0, offsetY, 0)

                -- تحريك الشخصية المحلية إلى موقع Bang
                if localHRP and localChar then
                    localChar:PivotTo(CFrame.new(bangPos))
                else
                    notify("تعذر تحديث شخصية اللاعب المحلي")
                    break
                end

                wait(0.03) -- تحديث عالي التردد للحركة سلسة
            end
            -- إعادة الشخصية إلى الوضع الطبيعي بعد إيقاف Bang
            if localChar and localChar:FindFirstChildOfClass("Humanoid") then
                local humanoid = localChar:FindFirstChildOfClass("Humanoid")
                humanoid.WalkSpeed = WALK_SPEED_BASE
                humanoid.JumpPower = JUMP_POWER_BASE
            end
            bangActive = false
            notify("تم إيقاف Bang")
        end)

        coroutine.resume(bangCoroutine)
    end

    local function stopBang()
        if not bangActive then
            notify("Bang غير مفعل حالياً")
            return
        end
        bangActive = false
    end

    bangStartBtn.MouseButton1Click:Connect(function()
        startBang()
    end)

    bangStopBtn.MouseButton1Click:Connect(function()
        stopBang()
    end)
end

-- ================== Tabs Switching ==================

local currentTabName = "معلومات اللاعب"

local function switchToTab(name)
    for tabName, page in pairs(pages) do
        page.Visible = (tabName == name)
    end
    currentTabName = name
end

-- Initial tab
switchToTab(currentTabName)

-- Connect buttons to switch
local btns = {infoBtn, espBtn, hacksBtn, bangBtn}
local tabNames = {"معلومات اللاعب", "نظام ESP", "الهاكات", "نظام Bang"}

for i, btn in ipairs(btns) do
    btn.MouseButton1Click:Connect(function()
        switchToTab(tabNames[i])
    end)
end

-- ================== Cleanup and Error Handling ==================
-- يمكن إضافة فواصل حماية إضافية هنا لو حبيت

notify("تم تحميل السكربت بنجاح. تقدر تبدأ باستخدام النظام.")

