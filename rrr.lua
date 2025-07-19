--[[
Elite Roblox Hack GUI - Full Script
Features:
- Player Info UI (Avatar, Name, UserID, Account Age)
- ESP with configurable colors
- Hacks page with toggles for Noclip, Fly, Speed, Jump
- Bang target follow system
- Notifications system
- Smooth UI with rounded corners and Arabic text

Made for Roblox exploiting contexts.
]]

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Color Definitions
local COLORS = {
    white = Color3.fromRGB(255,255,255),
    purple = Color3.fromRGB(145, 57, 255),
    red = Color3.fromRGB(255, 57, 57),
    green = Color3.fromRGB(57, 255, 57),
    darkBackground = Color3.fromRGB(40, 40, 50),
}

-- Helper: Add rounded corners to UI
local function addUICorner(obj, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = obj
end

-- Notification function
local function notify(msg)
    print("[Notify] " .. msg) -- replace with UI notif if needed
end

-- Main Screen GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
screenGui.Name = "EliteHackGUI"

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 500, 0, 350)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
mainFrame.BackgroundColor3 = COLORS.darkBackground
mainFrame.BorderSizePixel = 0
addUICorner(mainFrame, 12)

-- Pages container
local pagesContainer = Instance.new("Frame", mainFrame)
pagesContainer.Size = UDim2.new(1, 0, 1, 0)
pagesContainer.BackgroundTransparency = 1

-- Pages table
local pages = {}

-- ===================== Player Info Page =====================
do
    local page = Instance.new("Frame", pagesContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = true
    pages["PlayerInfo"] = page

    local titleLabel = Instance.new("TextLabel", page)
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 26
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "معلومات اللاعب"

    local playerImage = Instance.new("ImageLabel", page)
    playerImage.Size = UDim2.new(0, 140, 0, 140)
    playerImage.Position = UDim2.new(0, 20, 0, 55)
    playerImage.BackgroundColor3 = COLORS.darkBackground
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

    -- Refresh player image every 60 seconds
    coroutine.wrap(function()
        while true do
            wait(60)
            playerImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"
        end
    end)()
end

-- ===================== ESP Page =====================
do
    local espPage = Instance.new("Frame", pagesContainer)
    espPage.Size = UDim2.new(1, 0, 1, 0)
    espPage.BackgroundTransparency = 1
    espPage.Visible = false
    pages["ESP"] = espPage

    local espTitle = Instance.new("TextLabel", espPage)
    espTitle.Size = UDim2.new(1, -40, 0, 40)
    espTitle.Position = UDim2.new(0, 20, 0, 10)
    espTitle.BackgroundTransparency = 1
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 24
    espTitle.TextColor3 = COLORS.white
    espTitle.Text = "نظام ESP"

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
    colorDropdown.BackgroundColor3 = COLORS.darkBackground
    addUICorner(colorDropdown, 8)

    local hackSettings = {
        esp = {
            enabled = false,
            color = COLORS.purple,
            boxes = {}
        },
        noclip = { enabled = false },
        fly = { enabled = false },
        speed = { enabled = false },
        jump = { enabled = false },
        bang = { active = false, target = nil, oscillationFrequency = 2, oscillationAmplitude = 5, baseFollowDistance = 5 }
    }

    local function createESPBox(player)
        local box = Instance.new("BillboardGui")
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        box.Adornee = hrp
        box.Size = UDim2.new(0, 100, 0, 40)
        box.AlwaysOnTop = true

        local frame = Instance.new("Frame", box)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.5
        frame.BackgroundColor3 = hackSettings.esp.color
        frame.BorderSizePixel = 1
        frame.BorderColor3 = COLORS.white
        addUICorner(frame, 8)
        box.Frame = frame

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
            -- Create boxes for all players except local
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
            updateESPColor(colorDropdown.Text)
        end
    end)
end

-- ===================== Hacks Page =====================
do
    local hacksPage = Instance.new("Frame", pagesContainer)
    hacksPage.Size = UDim2.new(1, 0, 1, 0)
    hacksPage.BackgroundTransparency = 1
    hacksPage.Visible = false
    pages["Hacks"] = hacksPage

    local hacksTitle = Instance.new("TextLabel", hacksPage)
    hacksTitle.Size = UDim2.new(1, -40, 0, 40)
    hacksTitle.Position = UDim2.new(0, 20, 0, 10)
    hacksTitle.BackgroundTransparency = 1
    hacksTitle.Font = Enum.Font.GothamBold
    hacksTitle.TextSize = 26
    hacksTitle.TextColor3 = COLORS.white
    hacksTitle.Text = "الهاكات - Hacks"

    local startY = 60
    local paddingY = 45

    -- Noclip toggle
    local noclipBtn = Instance.new("TextButton", hacksPage)
    noclipBtn.Size = UDim2.new(0.4, 0, 0, 40)
    noclipBtn.Position = UDim2.new(0, 20, 0, startY)
    noclipBtn.BackgroundColor3 = COLORS.purple
    noclipBtn.TextColor3 = COLORS.white
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 20
    noclipBtn.Text = "تفعيل Noclip"
    addUICorner(noclipBtn, 10)

    local noclipEnabled = false
    local noclipConnection

    local function setNoclip(enabled)
        if enabled then
            noclipConnection = RS.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    noclipBtn.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        hackSettings.noclip.enabled = noclipEnabled
        setNoclip(noclipEnabled)
        noclipBtn.Text = noclipEnabled and "إيقاف Noclip" or "تفعيل Noclip"
        notify(noclipEnabled and "تم تفعيل Noclip" or "تم إيقاف Noclip")
    end)

    -- Fly toggle
    local flyBtn = Instance.new("TextButton", hacksPage)
    flyBtn.Size = UDim2.new(0.4, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.5, 10, 0, startY)
    flyBtn.BackgroundColor3 = COLORS.purple
    flyBtn.TextColor3 = COLORS.white
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 20
    flyBtn.Text = "تفعيل Fly"
    addUICorner(flyBtn, 10)

    local flyEnabled = false
    local flyBodyVelocity
    local flying = false
    local flySpeed = 50

    local function getFlyMoveDirection()
        local moveDir = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + Workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - Workspace.CurrentCamera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - Workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + Workspace.CurrentCamera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
        end
        return moveDir
    end

    flyBtn.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        hackSettings.fly.enabled = flyEnabled
        flyBtn.Text = flyEnabled and "إيقاف Fly" or "تفعيل Fly"
        notify(flyEnabled and "تم تفعيل Fly" or "تم إيقاف Fly")

        local character = LocalPlayer.Character
        if flyEnabled then
            if character then
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    humanoid.PlatformStand = true
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
                    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
                    flyBodyVelocity.Parent = hrp
                    flying = true
                end
            end
        else
            if flying and flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
                flying = false
            end
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end)

    -- Run fly velocity update on render step
    RS:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value + 3, function(dt)
        if hackSettings.fly.enabled and flying and flyBodyVelocity then
            local moveDirection = getFlyMoveDirection()
            flyBodyVelocity.Velocity = moveDirection * flySpeed
        end
    end)

    -- Speed toggle
    local speedBtn = Instance.new("TextButton", hacksPage)
    speedBtn.Size = UDim2.new(0.4, 0, 0, 40)
    speedBtn.Position = UDim2.new(0, 20, 0, startY + 45)
    speedBtn.BackgroundColor3 = COLORS.purple
    speedBtn.TextColor3 = COLORS.white
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.TextSize = 20
    speedBtn.Text = "تفعيل Speed"
    addUICorner(speedBtn, 10)

    local speedEnabled = false
    local speedMult = 3 -- speed multiplier

    speedBtn.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        hackSettings.speed.enabled = speedEnabled
        speedBtn.Text = speedEnabled and "إيقاف Speed" or "تفعيل Speed"
        notify(speedEnabled and "تم تفعيل Speed" or "تم إيقاف Speed")

        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if speedEnabled then
                humanoid.WalkSpeed = 16 * speedMult
            else
                humanoid.WalkSpeed = 16
            end
        end
    end)

    -- Jump toggle
    local jumpBtn = Instance.new("TextButton", hacksPage)
    jumpBtn.Size = UDim2.new(0.4, 0, 0, 40)
    jumpBtn.Position = UDim2.new(0.5, 10, 0, startY + 45)
    jumpBtn.BackgroundColor3 = COLORS.purple
    jumpBtn.TextColor3 = COLORS.white
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.TextSize = 20
    jumpBtn.Text = "تفعيل Jump"
    addUICorner(jumpBtn, 10)

    local jumpEnabled = false
    local jumpPower = 100

    jumpBtn.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        hackSettings.jump.enabled = jumpEnabled
        jumpBtn.Text = jumpEnabled and "إيقاف Jump" or "تفعيل Jump"
        notify(jumpEnabled and "تم تفعيل Jump" or "تم إيقاف Jump")

        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if jumpEnabled then
                humanoid.JumpPower = jumpPower
            else
                humanoid.JumpPower = 50
            end
        end
    end)
end

-- ===================== Bang Follow System =====================
do
    local bangPage = Instance.new("Frame", pagesContainer)
    bangPage.Size = UDim2.new(1, 0, 1, 0)
    bangPage.BackgroundTransparency = 1
    bangPage.Visible = false
    pages["Bang"] = bangPage

    local titleLabel = Instance.new("TextLabel", bangPage)
    titleLabel.Size = UDim2.new(1, -40, 0, 35)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 26
    titleLabel.TextColor3 = COLORS.white
    titleLabel.Text = "Bang Follow System"

    local targetBox = Instance.new("TextBox", bangPage)
    targetBox.Size = UDim2.new(0.5, 0, 0, 30)
    targetBox.Position = UDim2.new(0, 20, 0, 60)
    targetBox.PlaceholderText = "ادخل اسم اللاعب الهدف"
    targetBox.Font = Enum.Font.GothamBold
    targetBox.TextSize = 18
    targetBox.TextColor3 = COLORS.white
    targetBox.BackgroundColor3 = COLORS.darkBackground
    addUICorner(targetBox, 8)

    local bangStartBtn = Instance.new("TextButton", bangPage)
    bangStartBtn.Size = UDim2.new(0.2, 0, 0, 35)
    bangStartBtn.Position = UDim2.new(0.52, 10, 0, 60)
    bangStartBtn.BackgroundColor3 = COLORS.green
    bangStartBtn.TextColor3 = COLORS.white
    bangStartBtn.Font = Enum.Font.GothamBold
    bangStartBtn.TextSize = 18
    bangStartBtn.Text = "ابدأ"
    addUICorner(bangStartBtn, 8)

    local bangStopBtn = Instance.new("TextButton", bangPage)
    bangStopBtn.Size = UDim2.new(0.2, 0, 0, 35)
    bangStopBtn.Position = UDim2.new(0.75, 10, 0, 60)
    bangStopBtn.BackgroundColor3 = COLORS.red
    bangStopBtn.TextColor3 = COLORS.white
    bangStopBtn.Font = Enum.Font.GothamBold
    bangStopBtn.TextSize = 18
    bangStopBtn.Text = "إيقاف"
    addUICorner(bangStopBtn, 8)

    local speedBox = Instance.new("TextBox", bangPage)
    speedBox.Size = UDim2.new(0.3, 0, 0, 30)
    speedBox.Position = UDim2.new(0, 20, 0, 110)
    speedBox.PlaceholderText = "تردد التذبذب (Frequency)"
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 16
    speedBox.TextColor3 = COLORS.white
    speedBox.BackgroundColor3 = COLORS.darkBackground
    speedBox.Text = tostring(hackSettings.bang.oscillationFrequency)
    addUICorner(speedBox, 8)

    local amplitudeBox = Instance.new("TextBox", bangPage)
    amplitudeBox.Size = UDim2.new(0.3, 0, 0, 30)
    amplitudeBox.Position = UDim2.new(0.35, 10, 0, 110)
    amplitudeBox.PlaceholderText = "سعة التذبذب (Amplitude)"
    amplitudeBox.Font = Enum.Font.GothamBold
    amplitudeBox.TextSize = 16
    amplitudeBox.TextColor3 = COLORS.white
    amplitudeBox.BackgroundColor3 = COLORS.darkBackground
    amplitudeBox.Text = tostring(hackSettings.bang.oscillationAmplitude)
    addUICorner(amplitudeBox, 8)

    local baseDistBox = Instance.new("TextBox", bangPage)
    baseDistBox.Size = UDim2.new(0.3, 0, 0, 30)
    baseDistBox.Position = UDim2.new(0.7, 10, 0, 110)
    baseDistBox.PlaceholderText = "المسافة الأساسية (Base Distance)"
    baseDistBox.Font = Enum.Font.GothamBold
    baseDistBox.TextSize = 16
    baseDistBox.TextColor3 = COLORS.white
    baseDistBox.BackgroundColor3 = COLORS.darkBackground
    baseDistBox.Text = tostring(hackSettings.bang.baseFollowDistance)
    addUICorner(baseDistBox, 8)

    -- Find player by name helper
    local function getPlayerByName(name)
        for _, p in pairs(Players:GetPlayers()) do
            if p.Name:lower() == name:lower() then
                return p
            end
        end
        return nil
    end

    local function setNoclip(enabled)
        if hackSettings.noclip.enabled ~= enabled then
            hackSettings.noclip.enabled = enabled
            -- We reuse noclip function above
            -- But no direct connection to RS here, so just set noclipEnabled var and rely on that
        end
    end

    local lastTime = 0

    local function bangFollow(dt)
        if not hackSettings.bang.active or not hackSettings.bang.target then return end
        local targetChar = hackSettings.bang.target.Character
        local localChar = LocalPlayer.Character
        if not targetChar or not localChar then return end
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        local localHRP = localChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local oscFreq = hackSettings.bang.oscillationFrequency
        local oscAmp = hackSettings.bang.oscillationAmplitude
        local baseDist = hackSettings.bang.baseFollowDistance

        local time = tick()
        local oscillation = math.sin(time * oscFreq) * oscAmp

        local targetCF = targetHRP.CFrame
        -- Calculate offset oscillating on X axis relative to target facing direction
        local offsetVec = targetCF.RightVector * oscillation + targetCF.LookVector * baseDist

        local desiredPos = targetCF.Position + offsetVec
        local bodyVelocity = localHRP:FindFirstChild("BodyVelocity")
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Parent = localHRP
        end
        bodyVelocity.Velocity = (desiredPos - localHRP.Position) * 10 -- smooth follow velocity

        -- Set camera to target
        Workspace.CurrentCamera.CameraSubject = targetHRP
    end

    -- Bang follow bind to RenderStep
    RS:BindToRenderStep("BangFollow", Enum.RenderPriority.Character.Value + 4, function(dt)
        if hackSettings.bang.active then
            bangFollow(dt)
        end
    end)

    -- Notification function for Bang
    local function notifyBang(status, targetName)
        local msg = status and ("Bang مفعل على: " .. targetName) or "تم إيقاف Bang"
        notify(msg)
    end

    -- Start Bang function with notification
    local function startBangWithNotif(targetName)
        local target = getPlayerByName(targetName)
        if not target then
            notify("اللاعب غير موجود: " .. targetName)
            return false
        end
        hackSettings.bang.target = target
        hackSettings.bang.active = true
        setNoclip(true)
        -- Optional: modify camera for Bang, done inside bangFollow
        notifyBang(true, target.Name)
        return true
    end

    bangStartBtn.MouseButton1Click:Connect(function()
        local targetName = targetBox.Text
        if targetName == "" then
            notify("يرجى إدخال اسم اللاعب الهدف")
            return
        end
        -- Update bang settings from UI
        local freq = tonumber(speedBox.Text)
        local amp = tonumber(amplitudeBox.Text)
        local baseDist = tonumber(baseDistBox.Text)
        if freq and freq > 0 then
            hackSettings.bang.oscillationFrequency = freq
        else
            speedBox.Text = tostring(hackSettings.bang.oscillationFrequency)
        end
        if amp and amp >= 0 then
            hackSettings.bang.oscillationAmplitude = amp
        else
            amplitudeBox.Text = tostring(hackSettings.bang.oscillationAmplitude)
        end
        if baseDist and baseDist >= 0 then
            hackSettings.bang.baseFollowDistance = baseDist
        else
            baseDistBox.Text = tostring(hackSettings.bang.baseFollowDistance)
        end
        startBangWithNotif(targetName)
    end)

    bangStopBtn.MouseButton1Click:Connect(function()
        hackSettings.bang.active = false
        hackSettings.bang.target = nil
        setNoclip(false)
        Workspace.CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") or Workspace.CurrentCamera.CameraSubject
        notifyBang(false)
        -- Remove BodyVelocity on local humanoid root part if exists
        local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if localHRP then
            local bodyVelocity = localHRP:FindFirstChild("BodyVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
    end)
end

-- ===================== Page Switching =====================
do
    -- Simple tab buttons to switch pages
    local tabs = {"PlayerInfo", "ESP", "Hacks", "Bang"}
    local tabButtons = {}

    local tabBar = Instance.new("Frame", mainFrame)
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 0)
    tabBar.BackgroundColor3 = Color3.fromRGB(30,30,40)
    addUICorner(tabBar, 12)

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1/#tabs, -5, 1, -10)
        btn.Position = UDim2.new((i-1)/#tabs, 5, 0, 5)
        btn.BackgroundColor3 = COLORS.purple
        btn.TextColor3 = COLORS.white
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.Text = tabName
        addUICorner(btn, 8)

        btn.MouseButton1Click:Connect(function()
            for _, page in pairs(pages) do
                page.Visible = false
            end
            if pages[tabName] then
                pages[tabName].Visible = true
            end
        end)

        tabButtons[tabName] = btn
    end
end
