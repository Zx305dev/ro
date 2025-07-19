-- Elite Purple Hack System v2.0
-- Made By ALm6eri
-- تحديث شامل: تحكم محسّن بالـBang, Fly, All Hacks Page, واجهة متطورة قابلة للتصغير والتكبير والسحب

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local COLORS = {
    purpleMain = Color3.fromRGB(128, 0, 128),
    purpleAccent = Color3.fromRGB(186, 85, 211),
    darkBackground = Color3.fromRGB(35, 0, 45),
    background = Color3.fromRGB(50, 0, 60),
    white = Color3.fromRGB(255, 255, 255),
}

-- Helper function to add rounded corners
local function addUICorner(inst, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = inst
end

-- Notification system
local function createNotification(text, duration)
    duration = duration or 2
    local notif = Instance.new("TextLabel")
    notif.BackgroundColor3 = COLORS.purpleAccent
    notif.TextColor3 = COLORS.white
    notif.Text = text
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0, 10)
    notif.AnchorPoint = Vector2.new(0.5, 0)
    notif.BackgroundTransparency = 0.2
    addUICorner(notif, 10)
    notif.Parent = LocalPlayer:WaitForChild("PlayerGui")

    spawn(function()
        wait(duration)
        notif:Destroy()
    end)
end

-- ScreenGui container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ElitePurpleHack"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main frame with default size and position
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 480, 0, 420) -- default size
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.BackgroundColor3 = COLORS.darkBackground
mainFrame.Active = true
mainFrame.Draggable = true
addUICorner(mainFrame, 20)
mainFrame.Parent = ScreenGui

-- Top bar for title and buttons
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = COLORS.purpleMain
topBar.Parent = mainFrame
addUICorner(topBar, 20)

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Elite - Made By ALm6eri"
titleLabel.TextColor3 = COLORS.white
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Close Button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.BackgroundColor3 = COLORS.purpleAccent
closeBtn.TextColor3 = COLORS.white
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
addUICorner(closeBtn, 20)
closeBtn.Parent = topBar

closeBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Minimize Button (-)
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 22
minimizeBtn.BackgroundColor3 = COLORS.purpleAccent
minimizeBtn.TextColor3 = COLORS.white
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
addUICorner(minimizeBtn, 20)
minimizeBtn.Parent = topBar

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then
        mainFrame.Size = UDim2.new(0, 200, 0, 40)
        for _, page in pairs(pages) do
            page.Visible = false
        end
        tabHolder.Visible = false
        minimized = true
    else
        mainFrame.Size = UDim2.new(0, 480, 0, 420)
        tabHolder.Visible = true
        setActivePage(currentPage)
        minimized = false
    end
end)

-- Resize handle
local resizeBtn = Instance.new("Frame")
resizeBtn.Size = UDim2.new(0, 20, 0, 20)
resizeBtn.Position = UDim2.new(1, -20, 1, -20)
resizeBtn.BackgroundColor3 = COLORS.purpleAccent
resizeBtn.BorderSizePixel = 0
resizeBtn.ZIndex = 10
resizeBtn.Parent = mainFrame
resizeBtn.Cursor = "SizeNWSE"
addUICorner(resizeBtn, 10)

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

-- Tab buttons container
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -40, 0, 50)
tabHolder.Position = UDim2.new(0, 20, 0, 40)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = mainFrame

local tabButtons = {}
local pages = {}
local currentPage = 1

local tabNames = {"Bang", "Movement", "Flight", "Profile", "All Hacks"}

local function setActivePage(index)
    currentPage = index
    for i, page in pairs(pages) do
        page.Visible = (i == index)
    end
    for i, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (i == index) and COLORS.purpleAccent or COLORS.purpleMain
    end
end

-- Create Tab Buttons
for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * 95, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = COLORS.white
    btn.BackgroundColor3 = COLORS.purpleMain
    addUICorner(btn, 10)
    btn.Parent = tabHolder
    tabButtons[i] = btn
end

-- ==== PAGE 1: Bang System ====
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.background
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[1] = page

    -- Target dropdown (simple dropdown simulation)
    local targetDropdown = Instance.new("TextBox")
    targetDropdown.Size = UDim2.new(0, 280, 0, 40)
    targetDropdown.Position = UDim2.new(0, 20, 0, 20)
    targetDropdown.PlaceholderText = "اكتب اسم اللاعب للمتابعة"
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 22
    targetDropdown.TextColor3 = COLORS.white
    targetDropdown.BackgroundColor3 = COLORS.purpleMain
    addUICorner(targetDropdown, 10)
    targetDropdown.Parent = page

    -- Speed slider
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Text = "سرعة المتابعة: 12"
    speedLabel.Size = UDim2.new(0, 280, 0, 30)
    speedLabel.Position = UDim2.new(0, 20, 0, 70)
    speedLabel.TextColor3 = COLORS.white
    speedLabel.BackgroundTransparency = 1
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 20
    speedLabel.Parent = page

    local speedSlider = Instance.new("TextBox")
    speedSlider.Size = UDim2.new(0, 80, 0, 30)
    speedSlider.Position = UDim2.new(0, 320, 0, 70)
    speedSlider.Text = "12"
    speedSlider.Font = Enum.Font.GothamBold
    speedSlider.TextSize = 20
    speedSlider.TextColor3 = COLORS.white
    speedSlider.BackgroundColor3 = COLORS.purpleMain
    speedSlider.ClearTextOnFocus = false
    addUICorner(speedSlider, 8)
    speedSlider.Parent = page

    -- Start Bang Button
    local startBtn = Instance.new("TextButton")
    startBtn.Text = "تشغيل Bang"
    startBtn.Size = UDim2.new(0, 180, 0, 50)
    startBtn.Position = UDim2.new(0, 20, 0, 120)
    startBtn.BackgroundColor3 = COLORS.purpleAccent
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 24
    startBtn.TextColor3 = COLORS.white
    addUICorner(startBtn, 15)
    startBtn.Parent = page

    -- Stop Bang Button
    local stopBtn = Instance.new("TextButton")
    stopBtn.Text = "إيقاف Bang"
    stopBtn.Size = UDim2.new(0, 180, 0, 50)
    stopBtn.Position = UDim2.new(0, 220, 0, 120)
    stopBtn.BackgroundColor3 = COLORS.purpleAccent
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 24
    stopBtn.TextColor3 = COLORS.white
    addUICorner(stopBtn, 15)
    stopBtn.Parent = page

    local BangActive = false
    local TargetPlayer = nil
    local FollowSpeed = 12
    local NoclipEnabled = false

    -- Enable/disable noclip (simple implementation)
    local function SetNoclip(state)
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
        NoclipEnabled = state
    end

    local function GetPlayerByName(name)
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Name:lower():find(name:lower()) then
                return plr
            end
        end
        return nil
    end

    local function FollowTarget()
        if not BangActive or not TargetPlayer or not TargetPlayer.Character then return end
        local char = LocalPlayer.Character
        if not char then return end
        local localHRP = char:FindFirstChild("HumanoidRootPart")
        local targetHRP = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localHRP or not targetHRP then return end

        -- Get direction vector from local player to target
        local targetPos = targetHRP.Position
        local offset = Vector3.new(0, 0, 0) -- You can add offset here if you want to hover around

        -- Calculate desired position close to target (1.5 studs behind)
        local direction = (targetPos - localHRP.Position).Unit
        local desiredPos = targetPos - direction * 1.5 + offset

        -- Move smoothly towards the target position based on FollowSpeed
        local currentPos = localHRP.Position
        local newPos = currentPos:Lerp(desiredPos, math.clamp(FollowSpeed / 20, 0, 1))

        localHRP.CFrame = CFrame.new(newPos, targetPos)

        if NoclipEnabled then
            SetNoclip(true)
        else
            SetNoclip(false)
        end
    end

    local function StartBang(targetName)
        if BangActive then
            createNotification("Bang مفعل بالفعل", 3)
            return
        end
        local plr = GetPlayerByName(targetName)
        if not plr then
            createNotification("الهدف غير موجود!", 3)
            return
        end
        TargetPlayer = plr
        BangActive = true
        SetNoclip(true)
        createNotification("تم تشغيل Bang على "..plr.Name, 3)
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

    -- Update speed when input changes
    speedSlider.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(speedSlider.Text)
            if val and val >= 1 and val <= 20 then
                FollowSpeed = val
                speedLabel.Text = "سرعة المتابعة: "..val
                createNotification("تم تعديل سرعة المتابعة", 3)
            else
                speedSlider.Text = tostring(FollowSpeed)
                createNotification("الرجاء إدخال سرعة بين 1 و 20", 3)
            end
        end
    end)

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

-- ==== PAGE 2: Movement (Speed & Jump) ====
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.background
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
    speedBox.BackgroundColor3 = COLORS.purpleMain
    speedBox.Text = "16"
    speedBox.TextColor3 = COLORS.white
    speedBox.Font = Enum.Font.GothamBold
    speedBox.TextSize = 22
    addUICorner(speedBox, 8)
    speedBox.ClearTextOnFocus = false
    speedBox.Parent = page

    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Size = UDim2.new(0, 200, 0, 30)
    jumpLabel.Position = UDim2.new(0, 20, 0, 80)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.Text = "قوة القفز: 50"
    jumpLabel.Font = Enum.Font.GothamBold
    jumpLabel.TextSize = 22
    jumpLabel.TextColor3 = COLORS.white
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = page

    local jumpBox = Instance.new("TextBox")
    jumpBox.Size = UDim2.new(0, 80, 0, 30)
    jumpBox.Position = UDim2.new(0, 230, 0, 80)
    jumpBox.BackgroundColor3 = COLORS.purpleMain
    jumpBox.Text = "50"
    jumpBox.TextColor3 = COLORS.white
    jumpBox.Font = Enum.Font.GothamBold
    jumpBox.TextSize = 22
    addUICorner(jumpBox, 8)
    jumpBox.ClearTextOnFocus = false
    jumpBox.Parent = page

    local applyBtn = Instance.new("TextButton")
    applyBtn.Text = "تطبيق التغييرات"
    applyBtn.Size = UDim2.new(0, 200, 0, 50)
    applyBtn.Position = UDim2.new(0, 20, 0, 130)
    applyBtn.BackgroundColor3 = COLORS.purpleAccent
    applyBtn.Font = Enum.Font.GothamBold
    applyBtn.TextSize = 24
    applyBtn.TextColor3 = COLORS.white
    addUICorner(applyBtn, 15)
    applyBtn.Parent = page

    local function applyMovementSettings()
        local speedVal = tonumber(speedBox.Text)
        local jumpVal = tonumber(jumpBox.Text)
        if speedVal and speedVal >= 8 and speedVal <= 100 and jumpVal and jumpVal >= 10 and jumpVal <= 300 then
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = speedVal
                    humanoid.JumpPower = jumpVal
                    createNotification("تم تطبيق سرعة المشي وقوة القفز", 3)
                end
            end
        else
            createNotification("الرجاء إدخال قيم صحيحة:\nسرعة: 8-100\nقفز: 10-300", 4)
        end
    end

    applyBtn.MouseButton1Click:Connect(applyMovementSettings)
end

-- ==== PAGE 3: Flight ====
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.background
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    local flyToggle = Instance.new("TextButton")
    flyToggle.Text = "تشغيل الطيران"
    flyToggle.Size = UDim2.new(0, 180, 0, 50)
    flyToggle.Position = UDim2.new(0, 20, 0, 20)
    flyToggle.BackgroundColor3 = COLORS.purpleAccent
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 24
    flyToggle.TextColor3 = COLORS.white
    addUICorner(flyToggle, 15)
    flyToggle.Parent = page

    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Text = "سرعة الطيران: 50"
    flySpeedLabel.Size = UDim2.new(0, 200, 0, 30)
    flySpeedLabel.Position = UDim2.new(0, 220, 0, 30)
    flySpeedLabel.TextColor3 = COLORS.white
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Font = Enum.Font.GothamBold
    flySpeedLabel.TextSize = 22
    flySpeedLabel.Parent = page

    local flySpeedBox = Instance.new("TextBox")
    flySpeedBox.Size = UDim2.new(0, 80, 0, 30)
    flySpeedBox.Position = UDim2.new(0, 220, 0, 70)
    flySpeedBox.BackgroundColor3 = COLORS.purpleMain
    flySpeedBox.Text = "50"
    flySpeedBox.TextColor3 = COLORS.white
    flySpeedBox.Font = Enum.Font.GothamBold
    flySpeedBox.TextSize = 22
    addUICorner(flySpeedBox, 8)
    flySpeedBox.ClearTextOnFocus = false
    flySpeedBox.Parent = page

    local flying = false
    local flySpeed = 50

    flyToggle.MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            flyToggle.Text = "إيقاف الطيران"
            createNotification("تم تشغيل الطيران", 3)
        else
            flyToggle.Text = "تشغيل الطيران"
            createNotification("تم إيقاف الطيران", 3)
        end
    end)

    flySpeedBox.FocusLost:Connect(function(enter)
        if enter then
            local val = tonumber(flySpeedBox.Text)
            if val and val >= 10 and val <= 200 then
                flySpeed = val
                flySpeedLabel.Text = "سرعة الطيران: "..val
                createNotification("تم تعديل سرعة الطيران", 3)
            else
                flySpeedBox.Text = tostring(flySpeed)
                createNotification("الرجاء إدخال سرعة بين 10 و 200", 3)
            end
        end
    end)

    RS.RenderStepped:Connect(function(dt)
        if flying then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    humanoid.PlatformStand = true
                    local moveDirection = Vector3.new()
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0,1,0) end

                    hrp.Velocity = moveDirection.Unit * flySpeed
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end)
end

-- ==== PAGE 4: Profile ====
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.background
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[4] = page

    local profilePic = Instance.new("ImageLabel")
    profilePic.Size = UDim2.new(0, 120, 0, 120)
    profilePic.Position = UDim2.new(0, 20, 0, 20)
    profilePic.BackgroundTransparency = 1
    profilePic.Image = LocalPlayer.UserThumbnail -- Roblox User Thumbnail API usage example
    profilePic.Parent = page
    addUICorner(profilePic, 60)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Text = "الاسم: "..LocalPlayer.Name
    nameLabel.TextColor3 = COLORS.white
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 22
    nameLabel.Size = UDim2.new(0, 280, 0, 40)
    nameLabel.Position = UDim2.new(0, 160, 0, 30)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = page

    local idLabel = Instance.new("TextLabel")
    idLabel.Text = "ID: "..LocalPlayer.UserId
    idLabel.TextColor3 = COLORS.white
    idLabel.Font = Enum.Font.GothamBold
    idLabel.TextSize = 20
    idLabel.Size = UDim2.new(0, 280, 0, 30)
    idLabel.Position = UDim2.new(0, 160, 0, 80)
    idLabel.BackgroundTransparency = 1
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.Parent = page
end

-- ==== PAGE 5: All Hacks ====
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -40, 1, -100)
    page.Position = UDim2.new(0, 20, 0, 95)
    page.BackgroundColor3 = COLORS.background
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[5] = page

    -- Speed Hack Toggle and Input
    local speedHackToggle = Instance.new("TextButton")
    speedHackToggle.Text = "تشغيل/إيقاف سرعة المشي"
    speedHackToggle.Size = UDim2.new(0, 200, 0, 50)
    speedHackToggle.Position = UDim2.new(0, 20, 0, 20)
    speedHackToggle.BackgroundColor3 = COLORS.purpleAccent
    speedHackToggle.Font = Enum.Font.GothamBold
    speedHackToggle.TextSize = 22
    speedHackToggle.TextColor3 = COLORS.white
    addUICorner(speedHackToggle, 15)
    speedHackToggle.Parent = page

    local speedHackBox = Instance.new("TextBox")
    speedHackBox.Size = UDim2.new(0, 80, 0, 30)
    speedHackBox.Position = UDim2.new(0, 230, 0, 35)
    speedHackBox.BackgroundColor3 = COLORS.purpleMain
    speedHackBox.Text = "16"
    speedHackBox.TextColor3 = COLORS.white
    speedHackBox.Font = Enum.Font.GothamBold
    speedHackBox.TextSize = 20
    addUICorner(speedHackBox, 8)
    speedHackBox.ClearTextOnFocus = false
    speedHackBox.Parent = page

    local speedHackActive = false

    speedHackToggle.MouseButton1Click:Connect(function()
        speedHackActive = not speedHackActive
        if speedHackActive then
            local speedVal = tonumber(speedHackBox.Text)
            if speedVal and speedVal >= 8 and speedVal <= 100 then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = speedVal
                        createNotification("تم تفعيل سرعة المشي: "..speedVal, 3)
                    end
                end
            else
                createNotification("الرجاء إدخال سرعة صحيحة بين 8 و 100", 3)
                speedHackActive = false
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                    createNotification("تم إيقاف سرعة المشي", 3)
                end
            end
        end
    end)

    -- Fly Hack Toggle and Speed
    local flyHackToggle = Instance.new("TextButton")
    flyHackToggle.Text = "تشغيل/إيقاف الطيران"
    flyHackToggle.Size = UDim2.new(0, 200, 0, 50)
    flyHackToggle.Position = UDim2.new(0, 20, 0, 80)
    flyHackToggle.BackgroundColor3 = COLORS.purpleAccent
    flyHackToggle.Font = Enum.Font.GothamBold
    flyHackToggle.TextSize = 22
    flyHackToggle.TextColor3 = COLORS.white
    addUICorner(flyHackToggle, 15)
    flyHackToggle.Parent = page

    local flyHackBox = Instance.new("TextBox")
    flyHackBox.Size = UDim2.new(0, 80, 0, 30)
    flyHackBox.Position = UDim2.new(0, 230, 0, 95)
    flyHackBox.BackgroundColor3 = COLORS.purpleMain
    flyHackBox.Text = "50"
    flyHackBox.TextColor3 = COLORS.white
    flyHackBox.Font = Enum.Font.GothamBold
    flyHackBox.TextSize = 20
    addUICorner(flyHackBox, 8)
    flyHackBox.ClearTextOnFocus = false
    flyHackBox.Parent = page

    local flyHackActive = false
    local flyHackSpeed = 50

    flyHackToggle.MouseButton1Click:Connect(function()
        flyHackActive = not flyHackActive
        if flyHackActive then
            local val = tonumber(flyHackBox.Text)
            if val and val >= 10 and val <= 200 then
                flyHackSpeed = val
                createNotification("تم تشغيل الطيران بسرعه: "..val, 3)
            else
                createNotification("ادخل سرعة بين 10 و 200", 3)
                flyHackActive = false
            end
        else
            createNotification("تم إيقاف الطيران", 3)
        end
    end)

    -- Noclip Toggle
    local noclipToggle = Instance.new("TextButton")
    noclipToggle.Text = "تشغيل/إيقاف Noclip"
    noclipToggle.Size = UDim2.new(0, 200, 0, 50)
    noclipToggle.Position = UDim2.new(0, 20, 0, 140)
    noclipToggle.BackgroundColor3 = COLORS.purpleAccent
    noclipToggle.Font = Enum.Font.GothamBold
    noclipToggle.TextSize = 22
    noclipToggle.TextColor3 = COLORS.white
    addUICorner(noclipToggle, 15)
    noclipToggle.Parent = page

    local noclipActive = false

    local function setNoclip(state)
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end

    noclipToggle.MouseButton1Click:Connect(function()
        noclipActive = not noclipActive
        setNoclip(noclipActive)
        if noclipActive then
            createNotification("تم تفعيل Noclip", 3)
        else
            createNotification("تم تعطيل Noclip", 3)
        end
    end)

    -- Infinity Jump Toggle
    local infinityJumpToggle = Instance.new("TextButton")
    infinityJumpToggle.Text = "تشغيل/إيقاف القفز اللانهائي"
    infinityJumpToggle.Size = UDim2.new(0, 200, 0, 50)
    infinityJumpToggle.Position = UDim2.new(0, 20, 0, 200)
    infinityJumpToggle.BackgroundColor3 = COLORS.purpleAccent
    infinityJumpToggle.Font = Enum.Font.GothamBold
    infinityJumpToggle.TextSize = 22
    infinityJumpToggle.TextColor3 = COLORS.white
    addUICorner(infinityJumpToggle, 15)
    infinityJumpToggle.Parent = page

    local infinityJumpActive = false

    local function onJumpRequest()
        if infinityJumpActive then
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end

    infinityJumpToggle.MouseButton1Click:Connect(function()
        infinityJumpActive = not infinityJumpActive
        if infinityJumpActive then
            createNotification("تم تفعيل القفز اللانهائي", 3)
        else
            createNotification("تم تعطيل القفز اللانهائي", 3)
        end
    end)

    UIS.JumpRequest:Connect(onJumpRequest)

    -- Speed input update
    speedHackBox.FocusLost:Connect(function(enter)
        if enter and speedHackActive then
            local val = tonumber(speedHackBox.Text)
            if val and val >= 8 and val <= 100 then
                local char = LocalPlayer.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = val
                        createNotification("تم تعديل سرعة المشي: "..val, 3)
                    end
                end
            else
                speedHackBox.Text = tostring(16)
                createNotification("الرجاء إدخال سرعة بين 8 و 100", 3)
            end
        end
    end)

    -- Fly input update
    flyHackBox.FocusLost:Connect(function(enter)
        if enter and flyHackActive then
            local val = tonumber(flyHackBox.Text)
            if val and val >= 10 and val <= 200 then
                flyHackSpeed = val
                createNotification("تم تعديل سرعة الطيران: "..val, 3)
            else
                flyHackBox.Text = tostring(flyHackSpeed)
                createNotification("ادخل سرعة بين 10 و 200", 3)
            end
        end
    end)

    RS.RenderStepped:Connect(function()
        if flyHackActive then
            local char = LocalPlayer.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if hrp and humanoid then
                    humanoid.PlatformStand = true
                    local moveDir = Vector3.new()
                    if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end

                    hrp.Velocity = moveDir.Unit * flyHackSpeed
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
    end)
end

-- Tab buttons click
for i, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
end

-- Start with first page active
setActivePage(1)
