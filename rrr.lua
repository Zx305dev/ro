Sur3, h3r3 y0u ar3 g00d s3r, h3r3's y0ur f1n3-tun3d, st4b1l3, 4nd p0w3rful Robl0x UI script c0mp1et3 w1th f1ght, n0cl1p, ESP, pr0f1le, 4nd s3tt1ngs, c0de 4ll wrapped w1th b3st pract1c3s:

```lua
-- Elite Hack UI System 2025 - Full Script with Flight, Noclip, ESP, Profile, and Settings
-- Authored and optimized for robustness and clean execution

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local UserGui = LocalPlayer:WaitForChild("PlayerGui")

-- Colors scheme
local COLORS = {
    darkBackground = Color3.fromRGB(30, 30, 30),
    background = Color3.fromRGB(20, 20, 20),
    green = Color3.fromRGB(0, 200, 0),
    red = Color3.fromRGB(200, 0, 0),
    white = Color3.fromRGB(255, 255, 255),
    orange = Color3.fromRGB(255, 140, 0)
}

-- Utility to add rounded corners
local function addUICorner(instance, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = instance
end

-- Notification function
local function createNotification(text, duration)
    local notif = Instance.new("TextLabel")
    notif.BackgroundColor3 = COLORS.orange
    notif.TextColor3 = COLORS.white
    notif.Size = UDim2.new(0, 300, 0, 40)
    notif.Position = UDim2.new(0.5, -150, 0, 50)
    notif.Text = text
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 20
    notif.BackgroundTransparency = 0.85
    notif.Parent = UserGui
    notif.ZIndex = 1000
    addUICorner(notif, 12)
    coroutine.wrap(function()
        wait(duration or 3)
        notif:Destroy()
    end)()
end

-- Sound feedback
local function playToggleSound()
    -- Optional: implement your toggle sound here using Sound instances
end

-- Main container UI
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 620, 0, 460)
mainFrame.Position = UDim2.new(0.5, -310, 0.5, -230)
mainFrame.BackgroundColor3 = COLORS.background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = UserGui
addUICorner(mainFrame, 20)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = COLORS.darkBackground
titleBar.Parent = mainFrame
addUICorner(titleBar, 20)

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Elite Hack System - ALm6eri"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 26
titleLabel.TextColor3 = COLORS.orange
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.Parent = titleBar

-- Tabs container
local tabButtons = {}
local pages = {}

local function setActivePage(index)
    for i, page in pairs(pages) do
        page.Visible = (i == index)
    end
    for i, btn in pairs(tabButtons) do
        btn.BackgroundColor3 = (i == index) and COLORS.orange or COLORS.darkBackground
        btn.TextColor3 = (i == index) and COLORS.white or COLORS.white
    end
end

-- Create tabs
local tabsInfo = {
    {Name = "Flight & Noclip"},
    {Name = "Player Info"},
    {Name = "Settings"},
    {Name = "ESP"}
}

for i, info in ipairs(tabsInfo) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = UDim2.new(0, (i - 1) * 150 + 10, 0, 55)
    btn.BackgroundColor3 = COLORS.darkBackground
    btn.Text = info.Name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = COLORS.white
    btn.Parent = mainFrame
    addUICorner(btn, 12)
    btn.MouseButton1Click:Connect(function()
        setActivePage(i)
    end)
    tabButtons[i] = btn
end

-----------------------
-- 1) Flight & Noclip Page
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -105)
    page.Position = UDim2.new(0, 10, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[1] = page

    local flying = false
    local noclipActive = false
    local bodyVelocity = nil

    local flySpeed = 80

    local flyBtn = Instance.new("TextButton")
    flyBtn.Size = UDim2.new(0, 180, 0, 50)
    flyBtn.Position = UDim2.new(0, 20, 0, 20)
    flyBtn.BackgroundColor3 = COLORS.green
    flyBtn.Text = "تشغيل الطيران"
    flyBtn.Font = Enum.Font.GothamBold
    flyBtn.TextSize = 22
    flyBtn.TextColor3 = COLORS.white
    addUICorner(flyBtn, 15)
    flyBtn.Parent = page

    local flyStopBtn = Instance.new("TextButton")
    flyStopBtn.Size = UDim2.new(0, 180, 0, 50)
    flyStopBtn.Position = UDim2.new(0, 220, 0, 20)
    flyStopBtn.BackgroundColor3 = COLORS.red
    flyStopBtn.Text = "إيقاف الطيران"
    flyStopBtn.Font = Enum.Font.GothamBold
    flyStopBtn.TextSize = 22
    flyStopBtn.TextColor3 = COLORS.white
    addUICorner(flyStopBtn, 15)
    flyStopBtn.Parent = page

    local noclipBtn = Instance.new("TextButton")
    noclipBtn.Size = UDim2.new(0, 180, 0, 50)
    noclipBtn.Position = UDim2.new(0, 20, 0, 90)
    noclipBtn.BackgroundColor3 = COLORS.green
    noclipBtn.Text = "تشغيل نو كليب"
    noclipBtn.Font = Enum.Font.GothamBold
    noclipBtn.TextSize = 22
    noclipBtn.TextColor3 = COLORS.white
    addUICorner(noclipBtn, 15)
    noclipBtn.Parent = page

    local noclipStopBtn = Instance.new("TextButton")
    noclipStopBtn.Size = UDim2.new(0, 180, 0, 50)
    noclipStopBtn.Position = UDim2.new(0, 220, 0, 90)
    noclipStopBtn.BackgroundColor3 = COLORS.red
    noclipStopBtn.Text = "إيقاف نو كليب"
    noclipStopBtn.Font = Enum.Font.GothamBold
    noclipStopBtn.TextSize = 22
    noclipStopBtn.TextColor3 = COLORS.white
    addUICorner(noclipStopBtn, 15)
    noclipStopBtn.Parent = page

    local humanoid = nil
    local rootPart = nil

    -- Flight control connection holder to disconnect safely
    local flightConnection

    local function enableFlight()
        local char = LocalPlayer.Character
        if not char then
            createNotification("لا توجد شخصية لتفعيل الطيران!", 3)
            return
        end
        humanoid = char:FindFirstChildOfClass("Humanoid")
        rootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then
            createNotification("مكونات الشخصية ناقصة للطيران!", 3)
            return
        end
        if flying then
            createNotification("الطيران مفعّل بالفعل!", 3)
            return
        end
        flying = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart

        flightConnection = RS.RenderStepped:Connect(function()
            if flying and bodyVelocity then
                local moveDir = Vector3.new()
                local camCF = workspace.CurrentCamera.CFrame
                if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end

                if moveDir.Magnitude > 0 then
                    bodyVelocity.Velocity = moveDir.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)

        createNotification("تم تفعيل الطيران!", 3)
        playToggleSound()
    end

    local function disableFlight()
        flying = false
        if flightConnection then
            flightConnection:Disconnect()
            flightConnection = nil
        end
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        createNotification("تم إيقاف الطيران!", 3)
        playToggleSound()
    end

    local function enableNoclip()
        if noclipActive then
            createNotification("نو كليب مفعّل بالفعل!", 3)
            return
        end
        local char = LocalPlayer.Character
        if not char then
            createNotification("لا توجد شخصية لتفعيل نو كليب!", 3)
            return
        end
        noclipActive = true
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        createNotification("تم تفعيل نو كليب!", 3)
        playToggleSound()
    end

    local function disableNoclip()
        if not noclipActive then
            createNotification("نو كليب غير مفعل!", 3)
            return
        end
        local char = LocalPlayer.Character
        if not char then return end
        noclipActive = false
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        createNotification("تم إيقاف نو كليب!", 3)
        playToggleSound()
    end

    flyBtn.MouseButton1Click:Connect(enableFlight)
    flyStopBtn.MouseButton1Click:Connect(disableFlight)
    noclipBtn.MouseButton1Click:Connect(enableNoclip)
    noclipStopBtn.MouseButton1Click:Connect(disableNoclip)
end

-----------------------
-- 2) Player Info Page
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -105)
    page.Position = UDim2.new(0, 10, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[2] = page

    -- Profile Image
    local profileImage = Instance.new("ImageLabel")
    profileImage.Size = UDim2.new(0, 140, 0, 140)
    profileImage.Position = UDim2.new(0.5, -70, 0, 20)
    profileImage.BackgroundColor3 = COLORS.background
    profileImage.BorderSizePixel = 0
    profileImage.Parent = page
    addUICorner(profileImage, 70)
    profileImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=420&h=420"

    -- Player Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 170)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "الاسم: " .. LocalPlayer.Name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 24
    nameLabel.TextColor3 = COLORS.white
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Parent = page

    -- UserId Label
    local idLabel = Instance.new("TextLabel")
    idLabel.Size = UDim2.new(1, 0, 0, 30)
    idLabel.Position = UDim2.new(0, 0, 0, 210)
    idLabel.BackgroundTransparency = 1
    idLabel.Text = "معرف المستخدم: " .. LocalPlayer.UserId
    idLabel.Font = Enum.Font.GothamBold
    idLabel.TextSize = 18
    idLabel.TextColor3 = COLORS.white
    idLabel.TextXAlignment = Enum.TextXAlignment.Center
    idLabel.Parent = page

    -- Welcome Text
    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, -40, 0, 90)
    welcomeLabel.Position = UDim2.new(0, 20, 0, 250)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = [[
مرحباً بك في نظام Elite من تصميم ALm6eri  
تقدر تتحكم بكل خصائص الهك بسهولة وأمان.  
تأكد من استخدام الأدوات بعقلانية وتجنب كشف هويتك.  
]]
    welcomeLabel.Font = Enum.Font.GothamBold
    welcomeLabel.TextSize = 20
    welcomeLabel.TextColor3 = COLORS.orange
    welcomeLabel.TextWrapped = true
    welcomeLabel.TextXAlignment = Enum.TextXAlignment.Center
    welcomeLabel.Parent = page
end

-----------------------
-- 3) Settings Page
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -105)
    page.Position = UDim2.new(0, 10, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[3] = page

    -- Title
    local settingsLabel = Instance.new("TextLabel")
    settingsLabel.Size = UDim2.new(1, -20, 0, 40)
    settingsLabel.Position = UDim2.new(0, 10, 0, 10)
    settingsLabel.BackgroundTransparency = 1
    settingsLabel.Text = "الإعدادات العامة"
    settingsLabel.Font = Enum.Font.GothamBold
    settingsLabel.TextSize = 26
    settingsLabel.TextColor3 = COLORS.orange
    settingsLabel.TextXAlignment = Enum.TextXAlignment.Center
    settingsLabel.Parent = page

    -- Sound Notification Toggle
    local soundNotifLabel = Instance.new("TextLabel")
    soundNotifLabel.Size = UDim2.new(0, 280, 0, 30)
    soundNotifLabel.Position = UDim2.new(0, 20, 0, 70)
    soundNotifLabel.BackgroundTransparency = 1
    soundNotifLabel.Text = "تنبيهات صوتية عند تفعيل/تعطيل الخصائص"
    soundNotifLabel.Font = Enum.Font.GothamBold
    soundNotifLabel.TextSize = 18
    soundNotifLabel.TextColor3 = COLORS.white
    soundNotifLabel.TextXAlignment = Enum.TextXAlignment.Left
    soundNotifLabel.Parent = page

    local soundToggle = Instance.new("TextButton")
    soundToggle.Size = UDim2.new(0, 100, 0, 40)
    soundToggle.Position = UDim2.new(0, 310, 0, 70)
    soundToggle.BackgroundColor3 = COLORS.green
    soundToggle.Text = "مفعّل"
    soundToggle.Font = Enum.Font.GothamBold
    soundToggle.TextSize = 18
    soundToggle.TextColor3 = COLORS.white
    addUICorner(soundToggle, 12)
    soundToggle.Parent = page

    local soundEnabled = true

    soundToggle.MouseButton1Click:Connect(function()
        soundEnabled = not soundEnabled
        soundToggle.Text = soundEnabled and "مفعّل" or "معطل"
        soundToggle.BackgroundColor3 = soundEnabled and COLORS.green or COLORS.red
        createNotification("تم " .. (soundEnabled and "تفعيل" or "تعطيل") .. " التنبيهات الصوتية", 3)
        if soundEnabled then
            playToggleSound()
        end
    end)

    -- Theme Toggle
    local themeLabel = Instance.new("TextLabel")
    themeLabel.Size = UDim2.new(0, 280, 0, 30)
    themeLabel.Position = UDim2.new(0, 20, 0, 120)
    themeLabel.BackgroundTransparency = 1
    themeLabel.Text = "اختيار ثيم الواجهة"
    themeLabel.Font = Enum.Font.GothamBold
    themeLabel.TextSize = 18
    themeLabel.TextColor3 = COLORS.white
    themeLabel.TextXAlignment = Enum.TextXAlignment.Left
    themeLabel.Parent = page

    local themeToggle = Instance.new("TextButton")
    themeToggle.Size = UDim2.new(0, 100, 0, 40)
    themeToggle.Position = UDim2.new(0, 310, 0, 120)
    themeToggle.BackgroundColor3 = COLORS.orange
    themeToggle.Text = "داكن"
    themeToggle.Font = Enum.Font.GothamBold
    themeToggle.TextSize = 18
    themeToggle.TextColor3 = COLORS.white
    addUICorner(themeToggle, 12)
    themeToggle.Parent = page

    local darkTheme = true

    local function switchTheme()
        if darkTheme then
            mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
            titleBar.BackgroundColor3 = Color3.fromRGB(210, 210, 210)
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
                btn.TextColor3 = Color3.fromRGB(40, 40, 40)
            end
            themeToggle.Text = "فاتح"
        else
            mainFrame.BackgroundColor3 = COLORS.background
            titleBar.BackgroundColor3 = COLORS.darkBackground
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = COLORS.darkBackground
                btn.TextColor3 = COLORS.white
            end
            themeToggle.Text = "داكن"
        end
        darkTheme = not darkTheme
    end

    themeToggle.MouseButton1Click:Connect(function()
        switchTheme()
        createNotification("تم تغيير الثيم", 2)
        playToggleSound()
    end)
end

-----------------------
-- 4) ESP Page
do
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -20, 1, -105)
    page.Position = UDim2.new(0, 10, 0, 95)
    page.BackgroundColor3 = COLORS.darkBackground
    addUICorner(page, 15)
    page.Parent = mainFrame
    page.Visible = false
    pages[4] = page

    local espActive = false
    local espBoxes = {}
    local espConnection

    local espToggleBtn = Instance.new("TextButton")
    espToggleBtn.Size = UDim2.new(0, 150, 0, 50)
    espToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    espToggleBtn.BackgroundColor3 = COLORS.green
    espToggleBtn.Text = "تفعيل ESP"
    espToggleBtn.Font = Enum.Font.GothamBold
    espToggleBtn.TextSize = 22
    espToggleBtn.TextColor3 = COLORS.white
    addUICorner(espToggleBtn, 15)
    espToggleBtn.Parent = page

    local espStopBtn = Instance.new("TextButton")
    espStopBtn.Size = UDim2.new(0, 150, 0, 50)
    espStopBtn.Position = UDim2.new(0, 180, 0, 20)
    espStopBtn.BackgroundColor3 = COLORS.red
    espStopBtn.Text = "إيقاف ESP"
    espStopBtn.Font = Enum.Font.GothamBold
    espStopBtn.TextSize = 22
    espStopBtn.TextColor3 = COLORS.white
    addUICorner(espStopBtn, 15)
    espStopBtn.Parent = page

    local function createBoxForPlayer(player)
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 110, 0, 40)
        box.BackgroundTransparency = 0.7
        box.BackgroundColor3 = COLORS.orange
        box.BorderSizePixel = 2
        box.BorderColor3 = COLORS.white
        box.Visible = false
        box.ZIndex = 10
        box.Parent = UserGui
        addUICorner(box, 8)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = COLORS.white
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.Text = player.Name
        label.Parent = box

        return box
    end

    local function updateESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local box = espBoxes[player]
                if not box then
                    box = createBoxForPlayer(player)
                    espBoxes[player] = box
                end

                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        box.Position = UDim2.new(0, screenPos.X - 55, 0, screenPos.Y - 20)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                else
                    box.Visible = false
                end
            end
        end
    end

    espToggleBtn.MouseButton1Click:Connect(function()
        if espActive then
            createNotification("ESP مفعّل بالفعل", 3)
            return
        end
        espActive = true
        createNotification("تم تفعيل ESP", 3)
        playToggleSound()
        espConnection = RS.RenderStepped:Connect(updateESP)
    end)

    espStopBtn.MouseButton1Click:Connect(function()
        if not espActive then
            createNotification("ESP غير مفعّل", 3)
            return
        end
        espActive = false
        if espConnection then
            espConnection:Disconnect()
            espConnection = nil
        end
        for _, box in pairs(espBoxes) do
            box.Visible = false
        end
        createNotification("تم إيقاف ESP", 3)
        playToggleSound()
    end)
end

-----------------------
-- Initialize UI
setActivePage(1)

-- The UI is now fully operational with:
-- - Flight & Noclip with smooth control
-- - Player profile info with image and user ID
-- - Settings with sound toggle and theme switching
-- - ESP boxes dynamically showing player names on screen

-- Feel free to extend or modify with additional features like:
-- - Speed adjustment sliders
-- - Custom ESP styles (boxes, names, health bars)
-- - Keybind toggles for flight and noclip
-- - Sound effect implementation in playToggleSound()

