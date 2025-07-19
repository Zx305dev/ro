-- Elite Hack System Purple Edition FULL by ALm6eri & FNLOXER [Extended]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Colors palette
local COLORS = {
    background = Color3.fromRGB(45, 15, 65),
    darkBackground = Color3.fromRGB(30, 10, 45),
    purpleMain = Color3.fromRGB(150, 80, 200),
    purpleAccent = Color3.fromRGB(180, 120, 230),
    white = Color3.new(1,1,1),
    green = Color3.fromRGB(90, 200, 130),
    red = Color3.fromRGB(220, 50, 50),
    gray = Color3.fromRGB(120,120,120),
    blackTransparent = Color3.new(0,0,0),
}

-- Utility: Add rounded corners
local function addUICorner(inst, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = inst
end

-- Utility: Tween for fade in/out UI
local function tweenObject(inst, properties, duration, callback)
    local tween = TweenService:Create(inst, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    if callback then
        tween.Completed:Connect(callback)
    end
    return tween
end

-- Main ScreenGui container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteHackMenu"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = true

-- Main Frame setup
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 480)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -240)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
addUICorner(mainFrame, 20)
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Shadow effect frame (subtle glow)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = COLORS.purpleAccent
shadow.BackgroundTransparency = 0.8
shadow.ZIndex = 0
addUICorner(shadow, 25)
shadow.Parent = mainFrame

-- Bring shadow to back
shadow.ZIndex = 0
mainFrame.ZIndex = 1

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = COLORS.purpleMain
titleBar.BorderSizePixel = 0
addUICorner(titleBar, 20)
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -150, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Elite Hack System - Purple Edition"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = COLORS.white
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local madeByLabel = Instance.new("TextLabel")
madeByLabel.Size = UDim2.new(0, 130, 1, 0)
madeByLabel.Position = UDim2.new(1, -140, 0, 0)
madeByLabel.BackgroundTransparency = 1
madeByLabel.Text = "Made By ALm6eri & FNLOXER"
madeByLabel.Font = Enum.Font.Gotham
madeByLabel.TextSize = 14
madeByLabel.TextColor3 = COLORS.purpleAccent
madeByLabel.TextXAlignment = Enum.TextXAlignment.Right
madeByLabel.Parent = titleBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -42, 0, 4)
closeBtn.BackgroundColor3 = COLORS.red
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = COLORS.white
addUICorner(closeBtn, 8)
closeBtn.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 36, 0, 36)
minimizeBtn.Position = UDim2.new(1, -88, 0, 4)
minimizeBtn.BackgroundColor3 = COLORS.gray
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 32
minimizeBtn.TextColor3 = COLORS.white
addUICorner(minimizeBtn, 8)
minimizeBtn.Parent = titleBar

-- Resize Button
local resizeBtn = Instance.new("Frame")
resizeBtn.Size = UDim2.new(0, 24, 0, 24)
resizeBtn.Position = UDim2.new(1, -34, 1, -34)
resizeBtn.BackgroundColor3 = COLORS.purpleAccent
addUICorner(resizeBtn, 8)
resizeBtn.Parent = mainFrame

local resizeIcon = Instance.new("ImageLabel")
resizeIcon.Size = UDim2.new(1, -6, 1, -6)
resizeIcon.Position = UDim2.new(0, 3, 0, 3)
resizeIcon.BackgroundTransparency = 1
resizeIcon.Image = "rbxassetid://6031090991"
resizeIcon.Parent = resizeBtn

-- Tabs
local tabs = {"Bang", "Movement", "Flight", "Freecam", "Silent Aim", "ESP", "Profile"}
local pages = {}
local tabButtons = {}
local currentPage = 1

local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -40, 0, 44)
tabHolder.Position = UDim2.new(0, 20, 0, 55)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

-- Create Tabs Buttons
for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*115, 0, 0)
    btn.BackgroundColor3 = COLORS.purpleMain
    btn.Text = tabName
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    addUICorner(btn, 12)
    btn.Parent = tabHolder
    tabButtons[i] = btn
end

-- Notification function with fade
local function createNotification(text, duration)
    duration = duration or 3
    local notif = Instance.new("TextLabel")
    notif.Size = UDim2.new(0, 350, 0, 40)
    notif.Position = UDim2.new(0.5, -175, 0, 15)
    notif.BackgroundColor3 = COLORS.purpleAccent
    notif.BackgroundTransparency = 0.3
    notif.TextColor3 = COLORS.white
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Text = text
    notif.TextWrapped = true
    addUICorner(notif, 15)
    notif.Parent = ScreenGui
    notif.ZIndex = 100

    tweenObject(notif, {BackgroundTransparency = 0, Position = UDim2.new(0.5, -175, 0, 60)}, 0.4)
    delay(duration, function()
        tweenObject(notif, {BackgroundTransparency = 1, Position = UDim2.new(0.5, -175, 0, 15)}, 0.4, function()
            notif:Destroy()
        end)
    end)
end

-- Set Active Page helper
local function setActivePage(index)
    for i, page in ipairs(pages) do
        page.Visible = (i == index)
        tabButtons[i].BackgroundColor3 = (i == index) and COLORS.purpleAccent or COLORS.purpleMain
    end
    currentPage = index
end

-- =========================================
-- PAGE 1: Bang System with Auto Tracking and Noclip
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[1] = page

    -- Target Dropdown
    local targetDropdown = Instance.new("TextButton")
    targetDropdown.Size = UDim2.new(0, 200, 0, 42)
    targetDropdown.Position = UDim2.new(0, 20, 0, 20)
    targetDropdown.BackgroundColor3 = COLORS.purpleMain
    targetDropdown.Text = "اختر هدف"
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.TextColor3 = COLORS.white
    addUICorner(targetDropdown, 12)
    targetDropdown.Parent = page

    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(0, 200, 0, 150)
    dropdownList.Position = UDim2.new(0, 20, 0, 68)
    dropdownList.BackgroundColor3 = COLORS.background
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.CanvasSize = UDim2.new(0,0,0,0)
    addUICorner(dropdownList, 12)
    dropdownList.Parent = page

    local function refreshDropdown()
        dropdownList:ClearAllChildren()
        local y = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 36)
                btn.Position = UDim2.new(0, 0, 0, y)
                btn.BackgroundColor3 = COLORS.purpleMain
                btn.Text = plr.Name
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 18
                btn.TextColor3 = COLORS.white
                addUICorner(btn, 10)
                btn.Parent = dropdownList
                y = y + 42
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

    -- Oscillation Speed Label & Box
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 210, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 230)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة التذبذب: 1.5"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 90, 0, 30)
    speedBox.Position = UDim2.new(0, 230, 0, 230)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "1.5"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 20
    addUICorner(speedBox, 12)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    -- Follow Distance Label & Box
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0, 210, 0, 30)
    distLabel.Position = UDim2.new(0, 20, 0, 270)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "المسافة من الهدف: 3.5"
    distLabel.Font = Enum.Font.GothamBold
    distLabel.TextSize = 20
    distLabel.TextColor3 = COLORS.white
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = page

    local distBox = Instance.new("TextBox")
    distBox.Size = UDim2.new(0, 90, 0, 30)
    distBox.Position = UDim2.new(0, 230, 0, 270)
    distBox.BackgroundColor3 = COLORS.background
    distBox.Text = "3.5"
    distBox.TextColor3 = COLORS.white
    distBox.Font = Enum.Font.GothamBold
    distBox.TextSize = 20
    addUICorner(distBox, 12)
    distBox.ClearTextOnFocus = false
    distBox.Parent = page

    -- Auto Bang Toggle
    local autoBangToggle = Instance.new("TextButton")
    autoBangToggle.Size = UDim2.new(0, 150, 0, 42)
    autoBangToggle.Position = UDim2.new(0, 20, 0, 320)
    autoBangToggle.BackgroundColor3 = COLORS.purpleMain
    autoBangToggle.Text = "تشغيل Bang (OFF)"
    autoBangToggle.Font = Enum.Font.GothamBold
    autoBangToggle.TextSize = 20
    autoBangToggle.TextColor3 = COLORS.white
    addUICorner(autoBangToggle, 15)
    autoBangToggle.Parent = page

    local bangActive = false

    autoBangToggle.MouseButton1Click:Connect(function()
        bangActive = not bangActive
        autoBangToggle.Text = "تشغيل Bang ("..(bangActive and "ON" or "OFF")..")"
        createNotification("Bang System "..(bangActive and "مفعل" or "موقف"))
    end)

    -- Bang Logic Loop
    coroutine.wrap(function()
        local waveDirection = 1
        local currentOffset = 0
        while true do
            RS.Heartbeat:Wait()
            if bangActive then
                -- Validate inputs
                local speed = tonumber(speedBox.Text) or 1.5
                local dist = tonumber(distBox.Text) or 3.5
                local targetName = targetDropdown.Text
                local targetPlayer = Players:FindFirstChild(targetName)
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        -- Oscillate offset between -dist and +dist
                        currentOffset = currentOffset + speed * waveDirection * RS.Heartbeat:Wait()
                        if math.abs(currentOffset) > dist then
                            waveDirection = -waveDirection
                        end
                        -- Aim at target + offset
                        local targetPos = targetPlayer.Character.HumanoidRootPart.Position
                        local aimPos = targetPos + Vector3.new(currentOffset, 0, 0)
                        -- Aim your mouse or camera towards aimPos (pseudo)
                        -- (In Roblox, this is demo, actual camera manipulation may require client manipulation or exploit tools)
                        -- Placeholder:
                        workspace.CurrentCamera.CFrame = CFrame.new(root.Position, aimPos)
                    end
                end
            end
        end
    end)()
end

-- =========================================
-- PAGE 2: Movement (Speed & Jump)
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    -- Speed Label & TextBox
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(0, 210, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 20)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "سرعة الحركة: 16"
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.TextColor3 = COLORS.white
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = page

    local speedBox = Instance.new("TextBox")
    speedBox.Size = UDim2.new(0, 90, 0, 30)
    speedBox.Position = UDim2.new(0, 230, 0, 20)
    speedBox.BackgroundColor3 = COLORS.background
    speedBox.Text = "16"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 20
    addUICorner(speedBox, 12)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    -- Jump Power Label & TextBox
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 210, 0, 30)
    jumpLabel.Position = UDim2.new(0, 20, 0, 70)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "قوة القفز: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 20
    jumpLabel.TextColor3 = COLORS.white
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = page

    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 90, 0, 30)
    jumpBox.Position = UDim2.new(0, 230, 0, 70)
    jumpBox.BackgroundColor3 = COLORS.background
    jumpBox.Text = "50"
    jumpBox.TextColor3 = COLORS.white
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 20
    addUICorner(jumpBox, 12)
    jumpBox.ClearTextOnFocus = false
    jumpBox.Parent = page

    -- Apply Button
    local applyBtn = Instance.new("TextButton")
    applyBtn.Size = UDim2.new(0, 150, 0, 42)
    applyBtn.Position = UDim2.new(0, 20, 0, 120)
    applyBtn.BackgroundColor3 = COLORS.purpleMain
    applyBtn.Text = "تطبيق"
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 20
    applyBtn.TextColor3 = COLORS.white
    addUICorner(applyBtn, 15)
    applyBtn.Parent = page

    applyBtn.MouseButton1Click:Connect(function()
        local speed = tonumber(speedBox.Text)
        local jump = tonumber(jumpBox.Text)
        if speed and jump then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = math.clamp(speed, 8, 50)
                humanoid.JumpPower = math.clamp(jump, 20, 100)
                createNotification("تم تطبيق سرعة الحركة والقفز بنجاح")
            else
                createNotification("خطأ: لم يتم العثور على الـ Humanoid", 4)
            end
        else
            createNotification("الرجاء إدخال أرقام صحيحة", 4)
        end
    end)
end

-- =========================================
-- PAGE 3: Flight Mode
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    local flightToggle = Instance.new("TextButton")
    flightToggle.Size = UDim2.new(0, 180, 0, 48)
    flightToggle.Position = UDim2.new(0, 20, 0, 20)
    flightToggle.BackgroundColor3 = COLORS.purpleMain
    flightToggle.Text = "تفعيل الطيران (OFF)"
    flightToggle.Font = Enum.Font.GothamBold
    flightToggle.TextSize = 20
    flightToggle.TextColor3 = COLORS.white
    addUICorner(flightToggle, 15)
    flightToggle.Parent = page

    local flying = false
    local flySpeed = 100

    flightToggle.MouseButton1Click:Connect(function()
        flying = not flying
        flightToggle.Text = "تفعيل الطيران ("..(flying and "ON" or "OFF")..")"
        createNotification("وضع الطيران "..(flying and "مفعل" or "موقف"))
    end)

    coroutine.wrap(function()
        while true do
            RS.Heartbeat:Wait()
            if flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = LocalPlayer.Character.HumanoidRootPart
                local cam = workspace.CurrentCamera
                local direction = Vector3.new(0,0,0)
                local moveDir = Vector3.new(0,0,0)

                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end

                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit
                    root.Velocity = moveDir * flySpeed
                else
                    root.Velocity = Vector3.new(0,0,0)
                end
            else
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end
        end
    end)()
end

-- =========================================
-- PAGE 4: Freecam Mode
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[4] = page

    local freecamToggle = Instance.new("TextButton")
    freecamToggle.Size = UDim2.new(0, 180, 0, 48)
    freecamToggle.Position = UDim2.new(0, 20, 0, 20)
    freecamToggle.BackgroundColor3 = COLORS.purpleMain
    freecamToggle.Text = "تفعيل Freecam (OFF)"
    freecamToggle.Font = Enum.Font.GothamBold
    freecamToggle.TextSize = 20
    freecamToggle.TextColor3 = COLORS.white
    addUICorner(freecamToggle, 15)
    freecamToggle.Parent = page

    local freecamActive = false
    local cam = workspace.CurrentCamera
    local freecamSpeed = 75
    local freecamCF = nil

    freecamToggle.MouseButton1Click:Connect(function()
        freecamActive = not freecamActive
        freecamToggle.Text = "تفعيل Freecam ("..(freecamActive and "ON" or "OFF")..")"
        if freecamActive then
            freecamCF = cam.CFrame
            cam.CameraType = Enum.CameraType.Scriptable
        else
            cam.CameraType = Enum.CameraType.Custom
        end
        createNotification("Freecam "..(freecamActive and "مفعل" or "موقف"))
    end)

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if freecamActive and not gameProcessed then
            local delta = Vector3.new(0,0,0)
            if input.KeyCode == Enum.KeyCode.W then delta = delta + cam.CFrame.LookVector end
            if input.KeyCode == Enum.KeyCode.S then delta = delta - cam.CFrame.LookVector end
            if input.KeyCode == Enum.KeyCode.A then delta = delta - cam.CFrame.RightVector end
            if input.KeyCode == Enum.KeyCode.D then delta = delta + cam.CFrame.RightVector end
            if input.KeyCode == Enum.KeyCode.Space then delta = delta + Vector3.new(0,1,0) end
            if input.KeyCode == Enum.KeyCode.LeftShift then delta = delta - Vector3.new(0,1,0) end

            freecamCF = freecamCF * CFrame.new(delta.Unit * freecamSpeed * RS.Heartbeat:Wait())
            cam.CFrame = freecamCF
        end
    end)

    RS.Heartbeat:Connect(function()
        if freecamActive then
            local mouseDelta = UIS:GetMouseDelta()
            local yaw = -mouseDelta.X * 0.002
            local pitch = -mouseDelta.Y * 0.002
            freecamCF = freecamCF * CFrame.Angles(pitch, yaw, 0)
            cam.CFrame = freecamCF
        end
    end)
end

-- =========================================
-- PAGE 5: Silent Aim (Basic Demo)
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[5] = page

    local silentAimToggle = Instance.new("TextButton")
    silentAimToggle.Size = UDim2.new(0, 180, 0, 48)
    silentAimToggle.Position = UDim2.new(0, 20, 0, 20)
    silentAimToggle.BackgroundColor3 = COLORS.purpleMain
    silentAimToggle.Text = "تفعيل Silent Aim (OFF)"
    silentAimToggle.Font = Enum.Font.GothamBold
    silentAimToggle.TextSize = 20
    silentAimToggle.TextColor3 = COLORS.white
    addUICorner(silentAimToggle, 15)
    silentAimToggle.Parent = page

    local silentAimActive = false

    silentAimToggle.MouseButton1Click:Connect(function()
        silentAimActive = not silentAimActive
        silentAimToggle.Text = "تفعيل Silent Aim ("..(silentAimActive and "ON" or "OFF")..")"
        createNotification("Silent Aim "..(silentAimActive and "مفعل" or "موقف"))
    end)

    -- Placeholder silent aim logic
    -- Requires external exploit for real effect
    RS.Heartbeat:Connect(function()
        if silentAimActive then
            -- Demo logic (No real aim assistance in vanilla Roblox)
        end
    end)
end

-- =========================================
-- PAGE 6: ESP System (Simple)
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[6] = page

    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0, 180, 0, 48)
    espToggle.Position = UDim2.new(0, 20, 0, 20)
    espToggle.BackgroundColor3 = COLORS.purpleMain
    espToggle.Text = "تفعيل ESP (OFF)"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 20
    espToggle.TextColor3 = COLORS.white
    addUICorner(espToggle, 15)
    espToggle.Parent = page

    local espActive = false
    local espBoxes = {}

    espToggle.MouseButton1Click:Connect(function()
        espActive = not espActive
        espToggle.Text = "تفعيل ESP ("..(espActive and "ON" or "OFF")..")"
        createNotification("ESP "..(espActive and "مفعل" or "موقف"))
        if not espActive then
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}
        end
    end)

    RS.Heartbeat:Connect(function()
        if espActive then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not espBoxes[plr] then
                        local box = Instance.new("BillboardGui")
                        box.Size = UDim2.new(0, 100, 0, 40)
                        box.Adornee = plr.Character.HumanoidRootPart
                        box.AlwaysOnTop = true
                        box.Parent = ScreenGui

                        local label = Instance.new("TextLabel")
                        label.BackgroundTransparency = 0.5
                        label.BackgroundColor3 = COLORS.purpleMain
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.Text = plr.Name
                        label.TextColor3 = COLORS.white
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 18
                        label.Parent = box

                        espBoxes[plr] = box
                    end
                else
                    if espBoxes[plr] then
                        espBoxes[plr]:Destroy()
                        espBoxes[plr] = nil
                    end
                end
            end
        end
    end)
end

-- =========================================
-- PAGE 7: Profile Page
-- =========================================

do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -110)
    page.Position = UDim2.new(0, 20, 0, 105)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 20)
    page.Parent = mainFrame
    page.Visible = false
    pages[7] = page

    -- Player Thumbnail
    local thumbnail = Instance.new("ImageLabel")
    thumbnail.Size = UDim2.new(0, 140, 0, 140)
    thumbnail.Position = UDim2.new(0, 20, 0, 20)
    thumbnail.BackgroundColor3 = COLORS.background
    thumbnail.BorderSizePixel = 0
    addUICorner(thumbnail, 20)
    thumbnail.Parent = page

    -- Load player thumbnail
    local thumbUrl = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    thumbnail.Image = thumbUrl

    -- Player Name Label
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 300, 0, 40)
    nameLabel.Position = UDim2.new(0, 180, 0, 40)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "اللاعب: " .. LocalPlayer.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 28
    nameLabel.TextColor3 = COLORS.white
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = page

    -- UserId Label
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(0, 300, 0, 30)
    idLabel.Position = UDim2.new(0, 180, 0, 90)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "UserId: " .. LocalPlayer.UserId
    idLabel.Font = Enum.Font.Gotham
    idLabel.TextSize = 20
    idLabel.TextColor3 = COLORS.purpleAccent
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.Parent = page

    -- Placeholder Stats (can be extended)
    local statsLabel = Instance.new("TextLabel")
    statsLabel.Size = UDim2.new(0, 460, 0, 60)
    statsLabel.Position = UDim2.new(0, 20, 0, 180)
    statsLabel.BackgroundTransparency = 1
    statsLabel.Text = "إحصائيات (قريباً):\n- نقاط: 0\n- قتلى: 0\n- مكانة: لا شيء"
    statsLabel.Font = Enum.Font.Gotham
    statsLabel.TextSize = 22
    statsLabel.TextColor3 = COLORS.white
    statsLabel.TextWrapped = true
    statsLabel.TextXAlignment = Enum.TextXAlignment.Left
    statsLabel.Parent = page
end

-- Setup Tab Buttons Click
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
end

setActivePage(1)

-- Close Button logic
closeBtn.MouseButton1Click:Connect(function()
    -- Smooth fade out
    tweenObject(mainFrame, {BackgroundTransparency = 1, Position = mainFrame.Position + UDim2.new(0, 0, 0, 50)}, 0.3, function()
        ScreenGui.Enabled = false
    end)
end)

-- Minimize Button logic (hide content except title bar)
minimizeBtn.MouseButton1Click:Connect(function()
    local isMinimized = mainFrame.Size.Y.Scale < 0.2
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 500, 0, 480), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        tabHolder.Visible = true
        for _, page in ipairs(pages) do page.Visible = (pages[currentPage] == page) end
    else
        mainFrame:TweenSize(UDim2.new(0, 500, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        tabHolder.Visible = false
        for _, page in ipairs(pages) do page.Visible = false end
    end
end)

-- Resize drag logic
local resizing = false
local resizeStart = Vector2.new()
local frameStart = UDim2.new()
resizeBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = true
        resizeStart = input.Position
        frameStart = mainFrame.Size
    end
end)

UIS.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - resizeStart
        local newWidth = math.clamp(frameStart.X.Offset + delta.X, 400, 800)
        local newHeight = math.clamp(frameStart.Y.Offset + delta.Y, 300, 600)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        resizing = false
    end
end)

-- Keyboard shortcut to toggle menu (Insert)
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.Insert then
            ScreenGui.Enabled = not ScreenGui.Enabled
            if ScreenGui.Enabled then
                createNotification("قائمة الهاك مفعلة")
            else
                createNotification("قائمة الهاك مغلقة")
            end
        end
    end
end)

-- Welcome Notification
createNotification("مرحبا بك في Elite Hack System 2025 - اضغط Insert لفتح القائمة")

-- Script fully loaded
print("[Elite Hack System] Loaded successfully")

-- END OF SCRIPT
