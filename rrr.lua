-- Elite Hack System (Purple Edition)
-- Made By ALm6eri
-- Maintained for FNLOXER

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Colors: Purple-themed palette
local COLORS = {
    background = Color3.fromRGB(45, 15, 65),
    darkBackground = Color3.fromRGB(30, 10, 45),
    purpleMain = Color3.fromRGB(150, 80, 200),
    purpleAccent = Color3.fromRGB(180, 120, 230),
    white = Color3.new(1,1,1),
    green = Color3.fromRGB(90, 200, 130),
    red = Color3.fromRGB(220, 50, 50),
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHackMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local function addUICorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = inst
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 420)
mainFrame.Position = UDim2.new(0.5, -240, 0.5, -210)
mainFrame.BackgroundColor3 = COLORS.background
addUICorner(mainFrame, 18)
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Bar with drag, close, resize functionality
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = COLORS.purpleMain
titleBar.Parent = mainFrame
addUICorner(titleBar, 18)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Elite Hack System"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = COLORS.white
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local madeByLabel = Instance.new("TextLabel")
madeByLabel.Size = UDim2.new(0, 120, 1, 0)
madeByLabel.Position = UDim2.new(1, -130, 0, 0)
madeByLabel.BackgroundTransparency = 1
madeByLabel.Text = "Made By ALm6eri"
madeByLabel.Font = Enum.Font.GothamBold
madeByLabel.TextSize = 14
madeByLabel.TextColor3 = COLORS.purpleAccent
madeByLabel.TextXAlignment = Enum.TextXAlignment.Right
madeByLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 4)
closeBtn.BackgroundColor3 = COLORS.red
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = COLORS.white
addUICorner(closeBtn, 6)
closeBtn.Parent = titleBar

-- Resize Button (bottom right corner)
local resizeBtn = Instance.new("Frame")
resizeBtn.Size = UDim2.new(0, 20, 0, 20)
resizeBtn.Position = UDim2.new(1, -25, 1, -25)
resizeBtn.BackgroundColor3 = COLORS.purpleAccent
resizeBtn.AnchorPoint = Vector2.new(0,0)
resizeBtn.Parent = mainFrame
addUICorner(resizeBtn, 5)

local resizeIcon = Instance.new("ImageLabel")
resizeIcon.Size = UDim2.new(1, -4, 1, -4)
resizeIcon.Position = UDim2.new(0, 2, 0, 2)
resizeIcon.BackgroundTransparency = 1
resizeIcon.Image = "rbxassetid://6031090991" -- diagonal resize icon
resizeIcon.Parent = resizeBtn

-- Tabs Setup
local tabs = {"Bang System", "Movement", "Flight"}
local pages = {}
local tabButtons = {}
local currentPage = 1

local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -40, 0, 42)
tabHolder.Position = UDim2.new(0, 20, 0, 45)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*150, 0, 0)
    btn.BackgroundColor3 = COLORS.purpleMain
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 12)
    btn.Parent = tabHolder
    tabButtons[i] = btn
end

local function setActivePage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
        tabButtons[i].BackgroundColor3 = (i == index) and COLORS.purpleAccent or COLORS.purpleMain
    end
    currentPage = index
end

-- Utility notification function
local function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 320, 0, 40)
    notif.Position = UDim2.new(0.5, -160, 0, 40)
    notif.BackgroundColor3 = COLORS.purpleMain
    notif.TextColor3 = COLORS.white
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Text = text
    notif.BackgroundTransparency = 0.2
    notif.Parent = ScreenGui
    addUICorner(notif, 12)

    local tweenIn = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -160, 0, 100), BackgroundTransparency = 0})
    tweenIn:Play()

    delay(duration, function()
        local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5, -160, 0, 40), BackgroundTransparency = 1})
        tweenOut:Play()
        tweenOut.Completed:Wait()
        notif:Destroy()
    end)
end

--[[
-- Begin Bang System Page
--]]

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[1] = page

    -- Target Dropdown
    local targetDropdown = Instance.new("TextButton")
    targetDropdown.Size = UDim2.new(0, 180, 0, 40)
    targetDropdown.Position = UDim2.new(0, 20, 0, 20)
    targetDropdown.BackgroundColor3 = COLORS.purpleMain
    targetDropdown.Text = "اختر هدف"
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.TextColor3 = COLORS.white
    addUICorner(targetDropdown, 10)
    targetDropdown.Parent = page

    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0, 180, 0, 160)
    dropdownList.Position = UDim2.new(0, 20, 0, 65)
    dropdownList.BackgroundColor3 = COLORS.background
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    addUICorner(dropdownList, 10)
    dropdownList.Parent = page

    local function refreshDropdown()
        dropdownList:ClearAllChildren()
        local y = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 35)
                btn.Position = UDim2.new(0, 0, 0, y)
                btn.BackgroundColor3 = COLORS.purpleMain
                btn.Text = plr.Name
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 18
                btn.TextColor3 = COLORS.white
                addUICorner(btn, 8)
                btn.Parent = dropdownList
                y = y + 40
                btn.MouseButton1Click:Connect(function()
                    targetDropdown.Text = btn.Text
                    dropdownList.Visible = false
                end)
            end
        end
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, y)
    end

    targetDropdown.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
        if dropdownList.Visible then refreshDropdown() end
    end)

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 240)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.5"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 25)
    speedBox.Position = UDim2.new(0, 230, 0, 240)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "1.5"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 20
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 200, 0, 25)
    distLabel.Position = UDim2.new(0, 20, 0, 275)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3.5"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 20
    distLabel.TextColor3 = COLORS.white
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = page

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0, 80, 0, 25)
    distBox.Position = UDim2.new(0, 230, 0, 275)
    distBox.BackgroundColor3 = COLORS.background
    distBox.Text = "3.5"
    distBox.TextColor3 = COLORS.white
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 20
    addUICorner(distBox, 8)
    distBox.ClearTextOnFocus = false
    distBox.Parent = page

    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0, 180, 0, 45)
    startBtn.Position = UDim2.new(0, 20, 0, 310)
    startBtn.BackgroundColor3 = COLORS.green
    startBtn.Text = "تشغيل Bang + Noclip"
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 22
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 12)
    startBtn.Parent = page

    local stopBtn = Instance.new("TextButton")
    stopBtn.Size = UDim2.new(0, 180, 0, 45)
    stopBtn.Position = UDim2.new(0, 270, 0, 310)
    stopBtn.BackgroundColor3 = COLORS.red
    stopBtn.Text = "إيقاف Bang"
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 22
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 12)
    stopBtn.Parent = page

    local BangActive = false
    local TargetPlayer = nil
    local OSCILLATION_FREQUENCY = 1.5
    local OSCILLATION_AMPLITUDE = 1
    local BASE_FOLLOW_DISTANCE = 3.5

    local moveInput = {forward=false, backward=false}

    local function SetNoclip(enabled)
        local char = LocalPlayer.Character
        if not char then return end
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not enabled
            end
        end
    end

    local function GetPlayerByName(name)
        name = name:lower()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name) then
                return plr
            end
        end
        return nil
    end

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedBox.Text)
            if val and val > 0 and val <= 10 then
                OSCILLATION_FREQUENCY = val
                speedLabel.Text = "سرعة التذبذب: " .. tostring(val)
            else
                speedBox.Text = tostring(OSCILLATION_FREQUENCY)
                createNotification("ادخل رقم بين 0.1 و 10 للسرعة", 3)
            end
        end
    end)

    distBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(distBox.Text)
            if val and val >= 1 and val <= 20 then
                BASE_FOLLOW_DISTANCE = val
                distLabel.Text = "المسافة من الهدف: " .. tostring(val)
            else
                distBox.Text = tostring(BASE_FOLLOW_DISTANCE)
                createNotification("ادخل رقم بين 1 و 20 للمسافة", 3)
            end
        end
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if BangActive then
            if input.KeyCode == Enum.KeyCode.W then
                moveInput.forward = true
            elseif input.KeyCode == Enum.KeyCode.S then
                moveInput.backward = true
            end
        end
    end)

    UIS.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if BangActive then
            if input.KeyCode == Enum.KeyCode.W then
                moveInput.forward = false
            elseif input.KeyCode == Enum.KeyCode.S then
                moveInput.backward = false
            end
        end
    end)

    local function FollowTarget()
        if not BangActive or not TargetPlayer then return end
        if not TargetPlayer.Character then return end
        if not LocalPlayer.Character then return end

        local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetHRP or not localHRP then return end

        local lookVector = targetHRP.CFrame.LookVector
        local posBase = targetHRP.Position - lookVector * BASE_FOLLOW_DISTANCE

        local oscillation = math.sin(tick() * OSCILLATION_FREQUENCY * math.pi * 2) * OSCILLATION_AMPLITUDE
        local desiredPos = posBase + Vector3.new(0, oscillation, 0)

        local moveDirection = Vector3.new(0, 0, 0)
        if moveInput.forward then
            moveDirection = moveDirection + lookVector
        end
        if moveInput.backward then
            moveDirection = moveDirection - lookVector
        end

        local moveSpeed = 7

        local vectorToPlayer = localHRP.Position - targetHRP.Position
        local projectedLength = vectorToPlayer:Dot(lookVector)

        local maxDistance = BASE_FOLLOW_DISTANCE + 1
        local minDistance = BASE_FOLLOW_DISTANCE - 1

        if moveInput.forward and projectedLength > maxDistance then
            moveDirection = Vector3.new(0, 0, 0)
        elseif moveInput.backward and projectedLength < minDistance then
            moveDirection = Vector3.new(0, 0, 0)
        end

        desiredPos = desiredPos + moveDirection * moveSpeed * RS.RenderStepped:Wait()

        local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(localHRP, tweenInfo, {CFrame = CFrame.new(desiredPos, targetHRP.Position)})
        tween:Play()
    end

    local function StartBang(targetName)
        if BangActive then
            createNotification("Bang مفعل بالفعل!", 3)
            return
        end
        local plr = GetPlayerByName(targetName)
        if not plr then
            createNotification("لم يتم العثور على اللاعب: "..targetName, 3)
            return
        end
        if plr == LocalPlayer then
            createNotification("لا يمكنك اختيار نفسك!", 3)
            return
        end
        TargetPlayer = plr
        BangActive = true
        SetNoclip(true)
        createNotification("تم تفعيل Bang على "..plr.Name, 3)
    end

    local function StopBang()
        if not BangActive then
            createNotification("Bang غير مفعل!", 3)
            return
        end
        BangActive = false
        SetNoclip(false)
        TargetPlayer = nil
        createNotification("تم إيقاف Bang", 3)
    end

    startBtn.MouseButton1Click:Connect(function()
        StartBang(targetDropdown.Text)
    end)

    stopBtn.MouseButton1Click:Connect(function()
        StopBang()
    end)

    RS.RenderStepped:Connect(function()
        if BangActive then
            FollowTarget()
        end
    end)
end

--[[
-- Movement Page (Speed & Jump)
--]]

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 30)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة المشي: 16"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 22
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 30)
    speedBox.Position = UDim2.new(0, 230, 0, 30)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "16"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 22
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 200, 0, 30)
    jumpLabel.Position = UDim2.new(0, 20, 0, 75)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "قوة القفز: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 22
    jumpLabel.TextColor3 = COLORS.white
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = page

    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 80, 0, 30)
    jumpBox.Position = UDim2.new(0, 230, 0, 75)
    jumpBox.BackgroundColor3 = COLORS.background
    jumpBox.Text = "50"
    jumpBox.TextColor3 = COLORS.white
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 22
    addUICorner(jumpBox, 8)
    jumpBox.ClearTextOnFocus = false
    jumpBox.Parent = page

    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 290, 0, 50)
    applyBtn.Position = UDim2.new(0, 20, 0, 120)
    applyBtn.BackgroundColor3 = COLORS.purpleAccent
    applyBtn.Text = "تطبيق القيم"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 24
    applyBtn.TextColor3 = COLORS.white
    addUICorner(applyBtn, 15)
    applyBtn.Parent = page

    local function ApplyMovementSettings()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local speed = tonumber(speedBox.Text)
        if not speed or speed < 8 or speed > 100 then
            createNotification("سرعة غير صحيحة (8-100)", 3)
            return
        end

        local jumpPower = tonumber(jumpBox.Text)
        if not jumpPower or jumpPower < 10 or jumpPower > 200 then
            createNotification("قوة القفز غير صحيحة (10-200)", 3)
            return
        end

        humanoid.WalkSpeed = speed
        humanoid.JumpPower = jumpPower
        createNotification("تم تطبيق الحركة: سرعة = "..speed.." ، قفز = "..jumpPower, 3)
    end

    applyBtn.MouseButton1Click:Connect(ApplyMovementSettings)
end

--[[
-- Flight Page
--]]

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    local flyEnabled = false
    local flightSpeed = 40

    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0, 290, 0, 50)
    flyBtn.Position = UDim2.new(0, 20, 0, 20)
    flyBtn.BackgroundColor3 = COLORS.purpleAccent
    flyBtn.Text = "تفعيل/تعطيل الطيران"
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 24
    flyBtn.TextColor3 = COLORS.white
    addUICorner(flyBtn, 15)
    flyBtn.Parent = page

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 200, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 100)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة الطيران: 40"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 22
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 80, 0, 30)
    speedBox.Position = UDim2.new(0, 230, 0, 100)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "40"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 22
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local player = LocalPlayer
    local UserInputService = UIS
    local RunService = RS

    local bodyVelocity
    local bodyGyro

    local function startFlight()
        if flyEnabled then return end
        local character = player.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e4, 9e4, 9e4)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = rootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart

        flyEnabled = true
        createNotification("تم تفعيل الطيران", 3)
    end

    local function stopFlight()
        if not flyEnabled then return end
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
        flyEnabled = false
        createNotification("تم تعطيل الطيران", 3)
    end

    local function UpdateFlightVelocity()
        if not flyEnabled then return end
        local character = player.Character
        if not character then return end
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local moveVec = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec = moveVec + (rootPart.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveVec = moveVec - (rootPart.CFrame.LookVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveVec = moveVec - (rootPart.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveVec = moveVec + (rootPart.CFrame.RightVector)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveVec = moveVec + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
            moveVec = moveVec - Vector3.new(0,1,0)
        end

        if moveVec.Magnitude > 0 then
            moveVec = moveVec.Unit * flightSpeed
        end

        bodyVelocity.Velocity = moveVec
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end

    flyBtn.MouseButton1Click:Connect(function()
        if flyEnabled then
            stopFlight()
        else
            startFlight()
        end
    end)

    speedBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local val = tonumber(speedBox.Text)
            if val and val >= 10 and val <= 200 then
                flightSpeed = val
                speedLabel.Text = "سرعة الطيران: "..val
                createNotification("تم ضبط سرعة الطيران: "..val, 3)
            else
                speedBox.Text = tostring(flightSpeed)
                createNotification("الرجاء إدخال سرعة بين 10 و 200", 3)
            end
        end
    end)

    RS.RenderStepped:Connect(function()
        if flyEnabled then
            UpdateFlightVelocity()
        end
    end)
end

-- Tabs buttons connection
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
end

setActivePage(1)

-- Toggle Menu visibility with F1
local menuVisible = true
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        menuVisible = not menuVisible
        ScreenGui.Enabled = menuVisible
    end
end)

-- Resizing logic for the resizeBtn
local resizing = false
resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
    end
end)
resizeBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UIS:GetMouseLocation()
        local newWidth = math.clamp(mousePos.X - mainFrame.AbsolutePosition.X, 300, 800)
        local newHeight = math.clamp(mousePos.Y - mainFrame.AbsolutePosition.Y, 250, 600)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Notification on load
createNotification("تم تحميل قائمة Elite Hack System (Purple Edition) بنجاح", 4)
