-- Elite Hack System 2025 - By ALm6eri
-- Roblox Exploit GUI with Tabs, Purple theme, ESP, Bang, Noclip, Fly, Speed, Jump
-- Complete with error handling and update loops

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ==================== CONFIGURATION =====================
local COLORS = {
    purple = Color3.fromRGB(145, 57, 255),
    white = Color3.fromRGB(255, 255, 255),
    darkBG = Color3.fromRGB(40, 40, 50),
    green = Color3.fromRGB(57, 255, 57),
    red = Color3.fromRGB(255, 57, 57),
}

local WALK_SPEED_BASE = 16
local JUMP_POWER_BASE = 50

-- ==================== UTILITIES =====================
local function addUICorner(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = inst
end

local function notify(msg)
    -- Simple console print notification, can be enhanced to GUI toast
    print("[EliteHackNotify] " .. msg)
end

local function isValidColorName(name)
    if not name then return false end
    return COLORS[name:lower()] ~= nil
end

local function safeNumberParse(str, default)
    local num = tonumber(str)
    if num and num >= 0 then
        return num
    else
        return default
    end
end

local function getHumanoidRootPart(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(character)
    if not character then return nil end
    return character:FindFirstChildOfClass("Humanoid")
end

local function getPlayerByName(name)
    if not name or name == "" then return nil end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:lower() == name:lower() then
            return plr
        end
    end
    return nil
end

-- ==================== STATE =====================
local hackSettings = {
    esp = {
        enabled = false,
        color = COLORS.purple,
        boxes = {}, -- store esp boxes
    },
    noclip = {
        enabled = false,
    },
    fly = {
        enabled = false,
        speed = 50,
        bodyVelocity = nil,
    },
    speed = {
        enabled = false,
        multiplier = 2, -- speed multiplier (e.g. 2x)
    },
    jump = {
        enabled = false,
        power = 100,
    },
    bang = {
        active = false,
        target = nil,
        oscillationFrequency = 1.2,
        oscillationAmplitude = 3,
        baseFollowDistance = 5,
    }
}

local noclipEnabled = false
local flyEnabled = false
local speedEnabled = false
local jumpEnabled = false
local flying = false

-- ==================== GUI SETUP =====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EliteHackGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 520, 0, 400)
mainFrame.Position = UDim2.new(0.5, -260, 0.5, -200)
mainFrame.BackgroundColor3 = COLORS.darkBG
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
addUICorner(mainFrame, 15)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextColor3 = COLORS.purple
titleLabel.Text = "Elite Hack System 2025 - By ALm6eri"
titleLabel.Parent = mainFrame

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 40)
tabBar.Position = UDim2.new(0, 0, 0, 50)
tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
tabBar.Parent = mainFrame
addUICorner(tabBar, 10)

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, 0, 1, -90)
pagesContainer.Position = UDim2.new(0, 0, 0, 90)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = mainFrame

local pages = {}

-- Helper to create tab button and page frame
local function createTab(name, index)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/4, -10, 1, -10)
    btn.Position = UDim2.new((index-1)/4, 5, 0, 5)
    btn.BackgroundColor3 = COLORS.purple
    btn.TextColor3 = COLORS.white
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = name
    btn.Parent = tabBar
    addUICorner(btn, 8)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pagesContainer

    pages[name] = page

    return btn, page
end

-- ==================== PAGE CREATION =====================

-- 1. Player Info Page
local infoBtn, infoPage = createTab("معلومات اللاعب", 1)

do
    local title = Instance.new("TextLabel", infoPage)
    title.Size = UDim2.new(1, -40, 0, 35)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.TextColor3 = COLORS.white
    title.Text = "معلومات اللاعب"

    local playerImage = Instance.new("ImageLabel", infoPage)
    playerImage.Size = UDim2.new(0, 140, 0, 140)
    playerImage.Position = UDim2.new(0, 20, 0, 55)
    playerImage.BackgroundColor3 = COLORS.darkBG
    playerImage.BorderSizePixel = 0
    addUICorner(playerImage, 12)
    playerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    local playerNameLabel = Instance.new("TextLabel", infoPage)
    playerNameLabel.Size = UDim2.new(0, 250, 0, 35)
    playerNameLabel.Position = UDim2.new(0, 180, 0, 70)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.TextSize = 24
    playerNameLabel.TextColor3 = COLORS.white
    playerNameLabel.Text = "الاسم: " .. LocalPlayer.Name

    local playerUserIdLabel = Instance.new("TextLabel", infoPage)
    playerUserIdLabel.Size = UDim2.new(0, 250, 0, 30)
    playerUserIdLabel.Position = UDim2.new(0, 180, 0, 110)
    playerUserIdLabel.BackgroundTransparency = 1
    playerUserIdLabel.Font = Enum.Font.GothamBold
    playerUserIdLabel.TextSize = 18
    playerUserIdLabel.TextColor3 = COLORS.white
    playerUserIdLabel.Text = "UserID: " .. tostring(LocalPlayer.UserId)

    local playerAccountAgeLabel = Instance.new("TextLabel", infoPage)
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

-- 2. ESP Page
local espBtn, espPage = createTab("نظام ESP", 2)

do
    local title = Instance.new("TextLabel", espPage)
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = COLORS.white
    title.Text = "نظام ESP"

    local espToggleBtn = Instance.new("TextButton", espPage)
    espToggleBtn.Size = UDim2.new(0.4, 0, 0, 40)
    espToggleBtn.Position = UDim2.new(0, 20, 0, 60)
    espToggleBtn.BackgroundColor3 = COLORS.purple
    espToggleBtn.TextColor3 = COLORS.white
    espToggleBtn.Font = Enum.Font.GothamBold
    espToggleBtn.TextSize = 20
    espToggleBtn.Text = "تفعيل ESP"
    addUICorner(espToggleBtn, 10)

    local colorLabel = Instance.new("TextLabel", espPage)
    colorLabel.Size = UDim2.new(0.4, 0, 0, 30)
    colorLabel.Position = UDim2.new(0, 20, 0, 110)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel.TextSize = 18
    colorLabel.TextColor3 = COLORS.white
    colorLabel.Text = "اختر لون ESP:"

    local colorDropdown = Instance.new("TextBox", espPage)
    colorDropdown.Size = UDim2.new(0.4, 0, 0, 30)
    colorDropdown.Position = UDim2.new(0, 150, 0, 110)
    colorDropdown.PlaceholderText = "purple / red / green / white"
    colorDropdown.Font = Enum.Font.GothamBold
    colorDropdown.TextSize = 16
    colorDropdown.TextColor3 = COLORS.white
    colorDropdown.BackgroundColor3 = COLORS.darkBG
    addUICorner(colorDropdown, 8)

    -- Function to create ESP box for a player
    local function createESPBox(player)
        local box = Instance.new("BillboardGui")
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        box.Adornee = hrp
        box.Size = UDim2.new(0, 100, 0, 40)
        box.AlwaysOnTop = true
        box.Name = "ESPBox_" .. player.Name

        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = hackSettings.esp.color
        frame.BorderSizePixel = 1
        frame.BorderColor3 = COLORS.white
        addUICorner(frame, 8)
        frame.Name = "Frame"

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.Text = player.Name

        return box
    end

    local function removeESPBoxes()
        for _, box in pairs(hackSettings.esp.boxes) do
            if box then box:Destroy() end
        end
        hackSettings.esp.boxes = {}
    end

    local function updateESPColor(colorName)
        local c = COLORS[colorName:lower()] or COLORS.purple
        hackSettings.esp.color = c
        for _, box in pairs(hackSettings.esp.boxes) do
            if box and box:FindFirstChild("Frame") then
                box.Frame.BackgroundColor3 = c
            end
        end
    end

    espToggleBtn.MouseButton1Click:Connect(function()
        hackSettings.esp.enabled = not hackSettings.esp.enabled
        if hackSettings.esp.enabled then
            espToggleBtn.Text = "إيقاف ESP"
            notify("تم تفعيل ESP")

            -- Create ESP boxes for all other players
            removeESPBoxes()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local box = createESPBox(plr)
                    if box then
                        box.Parent = Workspace.CurrentCamera
                        table.insert(hackSettings.esp.boxes, box)
                    end
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
            if isValidColorName(colorDropdown.Text) then
                updateESPColor(colorDropdown.Text)
            else
                notify("لون غير صالح. الرجاء استخدام: purple, red, green, white")
                colorDropdown.Text = ""
            end
        end
    end)

    -- Auto update ESP when players join or leave
    Players.PlayerAdded:Connect(function(plr)
        if hackSettings.esp.enabled and plr ~= LocalPlayer then
            wait(1) -- Wait for character to load
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local box = createESPBox(plr)
                if box then
                    box.Parent = Workspace.CurrentCamera
                    table.insert(hackSettings.esp.boxes, box)
                end
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(plr)
        for i, box in pairs(hackSettings.esp.boxes) do
            if box and box.Name == "ESPBox_" .. plr.Name then
                box:Destroy()
                table.remove(hackSettings.esp.boxes, i)
                break
            end
        end
    end)
end

-- 3. Hacks Page
local hacksBtn, hacksPage = createTab("الهاكات", 3)

do
    local title = Instance.new("TextLabel", hacksPage)
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.TextColor3 = COLORS.white
    title.Text = "الهاكات - Hacks"

    local startY = 60
    local paddingY = 45

    -- Noclip toggle button
    local noclipBtn = Instance.new("TextButton", hacksPage)
    noclipBtn.Size = UDim2.new(0.4, 0, 0, 40)
    noclipBtn.Position = UDim2.new(0, 20, 0, startY)
    noclipBtn.BackgroundColor3 = COLORS.purple
    noclipBtn.TextColor3 = COLORS.white
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 20
    noclipBtn.Text = "تفعيل Noclip"
    addUICorner(noclipBtn, 10)

    -- Fly toggle button
    local flyBtn = Instance.new("TextButton", hacksPage)
    flyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.5, 10, 0, startY)
    flyBtn.BackgroundColor3 = COLORS.purple
    flyBtn.TextColor3 = COLORS.white
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 20
    flyBtn.Text = "تفعيل Fly"
    addUICorner(flyBtn, 10)

    -- Speed toggle button
    local speedBtn = Instance.new("TextButton", hacksPage)
    speedBtn.Size = UDim2.new(0.4, 0, 0, 40)
    speedBtn.Position = UDim2.new(0, 20, 0, startY + paddingY)
    speedBtn.BackgroundColor3 = COLORS.purple
    speedBtn.TextColor3 = COLORS.white
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.TextSize = 20
    speedBtn.Text = "تفعيل Speed"
    addUICorner(speedBtn, 10)

    -- Jump toggle button
    local jumpBtn = Instance.new("TextButton", hacksPage)
    jumpBtn.Size = UDim2.new(0.4, 0, 0, 40)
    jumpBtn.Position = UDim2.new(0.5, 10, 0, startY + paddingY)
    jumpBtn.BackgroundColor3 = COLORS.purple
    jumpBtn.TextColor3 = COLORS.white
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 20
    jumpBtn.Text = "تفعيل Jump"
    addUICorner(jumpBtn, 10)

    -- LOCAL helper to enable/disable noclip by setting collisions off
    local function setNoclip(enabled)
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
        hackSettings.noclip.enabled = enabled
    end

    -- Fly implementation using BodyVelocity
    local flyBodyVelocity = nil
    local flying = false

    local function startFly()
        local character = LocalPlayer.Character
        if not character then return end
        local hrp = getHumanoidRootPart(character)
        local humanoid = getHumanoid(character)
        if hrp and humanoid then
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

                local moveDirection = Vector3.new(0, 0, 0)
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
    end

    local function stopFly()
        flying = false
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        local humanoid = getHumanoid(LocalPlayer.Character)
        if humanoid then
            humanoid.PlatformStand = false
        end
    end

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        setNoclip(noclipEnabled)
        noclipBtn.Text = noclipEnabled and "إيقاف Noclip" or "تفعيل Noclip"
        notify(noclipEnabled and "تم تفعيل Noclip" or "تم إيقاف Noclip")
    end)

    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        hackSettings.fly.enabled = flyEnabled
        flyBtn.Text = flyEnabled and "إيقاف Fly" or "تفعيل Fly"
        notify(flyEnabled and "تم تفعيل Fly" or "تم إيقاف Fly")
        if flyEnabled then
            startFly()
        else
            stopFly()
        end
    end)

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        hackSettings.speed.enabled = speedEnabled
        speedBtn.Text = speedEnabled and "إيقاف Speed" or "تفعيل Speed"
        notify(speedEnabled and "تم تفعيل Speed" or "تم إيقاف Speed")

        local humanoid = getHumanoid(LocalPlayer.Character)
        if humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = WALK_SPEED_BASE * hackSettings.speed.multiplier
            else
                humanoid.WalkSpeed = WALK_SPEED_BASE
            end
        end
    end)

    jumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        hackSettings.jump.enabled = jumpEnabled
        jumpBtn.Text = jumpEnabled and "إيقاف Jump" or "تفعيل Jump"
        notify(jumpEnabled and "تم تفعيل Jump" or "تم إيقاف Jump")

        local humanoid = getHumanoid(LocalPlayer.Character)
        if humanoid then
            if jumpEnabled then
                humanoid.JumpPower = hackSettings.jump.power
            else
                humanoid.JumpPower = JUMP_POWER_BASE
            end
        end
    end)
end

-- 4. Bang Page
local bangBtn, bangPage = createTab("نظام Bang", 4)

do
    local title = Instance.new("TextLabel", bangPage)
    title.Size = UDim2.new(1, -40, 0, 40)
    title.Position = UDim2.new(0, 20, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 26
    title.TextColor3 = COLORS.white
    title.Text = "نظام Bang"

    local targetLabel = Instance.new("TextLabel", bangPage)
    targetLabel.Size = UDim2.new(0, 120, 0, 25)
    targetLabel.Position = UDim2.new(0, 20, 0, 60)
    targetLabel.BackgroundTransparency = 1
    targetLabel.Font = Enum.Font.GothamBold
    targetLabel.TextSize = 18
    targetLabel.TextColor3 = COLORS.white
    targetLabel.Text = "اسم الهدف:"

    local targetBox = Instance.new("TextBox", bangPage)
    targetBox.Size = UDim2.new(0, 180, 0, 25)
    targetBox.Position = UDim2.new(0, 150, 0, 60)
    targetBox.PlaceholderText = "اكتب اسم لاعب"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 18
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBG
    addUICorner(targetBox, 6)

    local freqLabel = Instance.new("TextLabel", bangPage)
    freqLabel.Size = UDim2.new(0, 120, 0, 25)
    freqLabel.Position = UDim2.new(0, 20, 0, 95)
    freqLabel.BackgroundTransparency = 1
    freqLabel.Font = Enum.Font.GothamBold
    freqLabel.TextSize = 18
    freqLabel.TextColor3 = COLORS.white
    freqLabel.Text = "تردد الاهتزاز (Hz):"

    local speedBox = Instance.new("TextBox", bangPage)
    speedBox.Size = UDim2.new(0, 180, 0, 25)
    speedBox.Position = UDim2.new(0, 150, 0, 95)
    speedBox.PlaceholderText = tostring(hackSettings.bang.oscillationFrequency)
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 18
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBG
    addUICorner(speedBox, 6)

    local ampLabel = Instance.new("TextLabel", bangPage)
    ampLabel.Size = UDim2.new(0, 120, 0, 25)
    ampLabel.Position = UDim2.new(0, 20, 0, 130)
    ampLabel.BackgroundTransparency = 1
    ampLabel.Font = Enum.Font.GothamBold
    ampLabel.TextSize = 18
    ampLabel.TextColor3 = COLORS.white
    ampLabel.Text = "شدة الاهتزاز:"

    local amplitudeBox = Instance.new("TextBox", bangPage)
    amplitudeBox.Size = UDim2.new(0, 180, 0, 25)
    amplitudeBox.Position = UDim2.new(0, 150, 0, 130)
    amplitudeBox.PlaceholderText = tostring(hackSettings.bang.oscillationAmplitude)
    amplitudeBox.Font = Enum.Font.GothamBold
    amplitudeBox.TextSize = 18
    amplitudeBox.TextColor3 = COLORS.white
    amplitudeBox.BackgroundColor3 = COLORS.darkBG
    addUICorner(amplitudeBox, 6)

    local baseDistLabel = Instance.new("TextLabel", bangPage)
    baseDistLabel.Size = UDim2.new(0, 120, 0, 25)
    baseDistLabel.Position = UDim2.new(0, 20, 0, 165)
    baseDistLabel.BackgroundTransparency = 1
    baseDistLabel.Font = Enum.Font.GothamBold
    baseDistLabel.TextSize = 18
    baseDistLabel.TextColor3 = COLORS.white
    baseDistLabel.Text = "مسافة المتابعة:"

    local baseDistBox = Instance.new("TextBox", bangPage)
    baseDistBox.Size = UDim2.new(0, 180, 0, 25)
    baseDistBox.Position = UDim2.new(0, 150, 0, 165)
    baseDistBox.PlaceholderText = tostring(hackSettings.bang.baseFollowDistance)
    baseDistBox.Font = Enum.Font.GothamBold
    baseDistBox.TextSize = 18
    baseDistBox.TextColor3 = COLORS.white
    baseDistBox.BackgroundColor3 = COLORS.darkBG
    addUICorner(baseDistBox, 6)

    local bangStartBtn = Instance.new("TextButton", bangPage)
    bangStartBtn.Size = UDim2.new(0.4, 0, 0, 40)
    bangStartBtn.Position = UDim2.new(0, 20, 0, 210)
    bangStartBtn.BackgroundColor3 = COLORS.purple
    bangStartBtn.TextColor3 = COLORS.white
    bangStartBtn.Font = Enum.Font.GothamBold
    bangStartBtn.TextSize = 20
    bangStartBtn.Text = "تشغيل Bang"
    addUICorner(bangStartBtn, 10)

    local bangStopBtn = Instance.new("TextButton", bangPage)
    bangStopBtn.Size = UDim2.new(0.4, 0, 0, 40)
    bangStopBtn.Position = UDim2.new(0.5, 10, 0, 210)
    bangStopBtn.BackgroundColor3 = COLORS.red
    bangStopBtn.TextColor3 = COLORS.white
    bangStopBtn.Font = Enum.Font.GothamBold
    bangStopBtn.TextSize = 20
    bangStopBtn.Text = "إيقاف Bang"
    addUICorner(bangStopBtn, 10)

    local bangActive = false

    local function bangLoop(targetPlayer)
        local char = LocalPlayer.Character
        local hrp = getHumanoidRootPart(char)
        if not hrp then
            notify("شخصيتك غير موجودة، الرجاء إعادة الظهور.")
            return
        end
        if not targetPlayer or not targetPlayer.Character then
            notify("الهدف غير صالح أو غير متصل.")
            return
        end
        local targetHRP = getHumanoidRootPart(targetPlayer.Character)
        if not targetHRP then
            notify("الهدف لا يحتوي على HumanoidRootPart.")
            return
        end

        local oscillationFreq = hackSettings.bang.oscillationFrequency
        local oscillationAmp = hackSettings.bang.oscillationAmplitude
        local baseDist = hackSettings.bang.baseFollowDistance

        local startTime = tick()
        bangActive = true

        while bangActive do
            RS.RenderStepped:Wait()
            if not targetPlayer.Character or not getHumanoidRootPart(targetPlayer.Character) then
                notify("الهدف فقد شخصيته أو خرج.")
                bangActive = false
                break
            end
            local timePassed = tick() - startTime
            local oscillate = math.sin(timePassed * oscillationFreq * math.pi * 2) * oscillationAmp
            local targetPos = targetHRP.Position + (targetHRP.CFrame.LookVector * baseDist)
            local offsetPos = targetPos + Vector3.new(0, oscillate, 0)
            hrp.CFrame = CFrame.new(offsetPos, targetPos)
        end
    end

    bangStartBtn.MouseButton1Click:Connect(function()
        local targetName = targetBox.Text
        local freq = safeNumberParse(speedBox.Text, hackSettings.bang.oscillationFrequency)
        local amp = safeNumberParse(amplitudeBox.Text, hackSettings.bang.oscillationAmplitude)
        local dist = safeNumberParse(baseDistBox.Text, hackSettings.bang.baseFollowDistance)

        hackSettings.bang.oscillationFrequency = freq
        hackSettings.bang.oscillationAmplitude = amp
        hackSettings.bang.baseFollowDistance = dist

        local targetPlayer = getPlayerByName(targetName)
        if not targetPlayer then
            notify("لم يتم العثور على اللاعب الهدف.")
            return
        end

        if bangActive then
            notify("Bang يعمل بالفعل.")
            return
        end

        notify("تم تشغيل Bang على: " .. targetPlayer.Name)
        spawn(function()
            bangLoop(targetPlayer)
        end)
    end)

    bangStopBtn.MouseButton1Click:Connect(function()
        if bangActive then
            bangActive = false
            notify("تم إيقاف Bang")
        else
            notify("Bang غير مفعل.")
        end
    end)
end

-- ==================== TAB SWITCHING LOGIC =====================
local currentTab = nil

local function switchTab(name)
    if currentTab and pages[currentTab] then
        pages[currentTab].Visible = false
    end
    if pages[name] then
        pages[name].Visible = true
        currentTab = name
    end
end

-- Initialize first tab
switchTab("معلومات اللاعب")

-- Connect tab buttons
infoBtn.MouseButton1Click:Connect(function() switchTab("معلومات اللاعب") end)
espBtn.MouseButton1Click:Connect(function() switchTab("نظام ESP") end)
hacksBtn.MouseButton1Click:Connect(function() switchTab("الهاكات") end)
bangBtn.MouseButton1Click:Connect(function() switchTab("نظام Bang") end)

-- ==================== CLEANUP HANDLER ON CHARACTER RESET =====================
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1) -- Wait character to fully load

    -- Reset speeds and jump power
    local humanoid = getHumanoid(char)
    if humanoid then
        humanoid.WalkSpeed = WALK_SPEED_BASE
        humanoid.JumpPower = JUMP_POWER_BASE
    end

    -- Remove noclip collision off (restore)
    setNoclip(false)
    noclipEnabled = false
    hacksPage:FindFirstChildWhichIsA("TextButton", true).Text = "تفعيل Noclip" -- Reset button text (safe assumption)

    -- Stop fly if active
    if flyEnabled then
        stopFly()
        flyEnabled = false
    end

    -- Clear ESP and recreate if enabled
    if hackSettings.esp.enabled then
        -- Clean old ESP
        for _, box in pairs(hackSettings.esp.boxes) do
            if box then box:Destroy() end
        end
        hackSettings.esp.boxes = {}
        -- Recreate ESP
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local box = espPage:FindFirstChild("ESPBox_" .. plr.Name)
                if not box then
                    box = Instance.new("BillboardGui")
                    box.Adornee = plr.Character.HumanoidRootPart
                    box.Size = UDim2.new(0, 100, 0, 40)
                    box.AlwaysOnTop = true
                    box.Name = "ESPBox_" .. plr.Name
                    box.Parent = Workspace.CurrentCamera

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
                    label.Text = plr.Name

                    table.insert(hackSettings.esp.boxes, box)
                end
            end
        end
    end
end)

-- ==================== END OF SCRIPT =====================

notify("Elite Hack System 2025 loaded successfully.")

