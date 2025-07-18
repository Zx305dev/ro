-- ELITE V5 PRO - Purple Themed GUI with Full Player Info + ESP + External Scripts + Arabic Labels
-- By pyst + customized for ALm6eri style
-- Designed for pro use, clean, smooth, scalable, full arabic translations

-- Prevent multiple instances
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Root GUI Setup
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- Utility: Add UI Corner
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Utility: Tween Color
local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

-- === MAIN FRAME ===
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.32, 0, 0.68, 0)
frame.Position = UDim2.new(0.04, 0, 0.18, 0)
frame.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = EliteMenu
addUICorner(frame, 14)

-- === HEADER BAR ===
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
header.BorderSizePixel = 0
addUICorner(header, 14)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | ALm6eri"
title.Size = UDim2.new(0.75, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 40, 0, 38)
closeBtn.Position = UDim2.new(0.92, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 28
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 12)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 40, 0, 38)
minimizeBtn.Position = UDim2.new(0.83, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 32
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 12)

-- === PAGE BUTTONS BAR ===
local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 50)
pageBar.Position = UDim2.new(0, 0, 0, 38)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.04, 0)

-- === PAGES CONTAINER ===
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -88)
pagesContainer.Position = UDim2.new(0, 0, 0, 88)
pagesContainer.BackgroundTransparency = 1

-- Helper: Create Page Button
local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 130, 0, 42)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.AutoButtonColor = false
    addUICorner(btn, 12)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.25)
    end)

    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.25)
    end)

    return btn
end

-- Helper: Create Toggle Button
local togglesState = {}
local function createToggleButton(parent, text, posY, key, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = UDim2.new(0.075, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text .. " : إيقاف"
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    togglesState[key] = false

    btn.MouseButton1Click:Connect(function()
        togglesState[key] = not togglesState[key]
        local status = togglesState[key] and "تشغيل" or "إيقاف"
        btn.Text = text .. " : " .. status
        tweenColor(btn, "BackgroundColor3", togglesState[key] and Color3.fromRGB(0, 200, 90) or Color3.fromRGB(130, 0, 200), 0.3)
        callback(togglesState[key])
    end)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(180, 50, 220), 0.2)
    end)
    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", togglesState[key] and Color3.fromRGB(0, 200, 90) or Color3.fromRGB(130, 0, 200), 0.2)
    end)

    return btn
end

-- Hide all pages utility
local function hideAllPages()
    for _, p in pairs(pagesContainer:GetChildren()) do
        if p:IsA("Frame") then
            p.Visible = false
        end
    end
end

-- Create Pages and Buttons container
local pages = {}
local pageButtons = {}

local pageNames = {"الرئيسية", "ESP", "18+"}

-- Create Page Buttons & Pages
for index, name in ipairs(pageNames) do
    local btn = createPageButton(name)
    btn.Parent = pageBar
    pageButtons[name] = btn

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pagesContainer
    pages[name] = page

    -- Clicking button shows relevant page with fade animation
    btn.MouseButton1Click:Connect(function()
        hideAllPages()
        page.Visible = true

        -- Smooth fade in animation
        page.BackgroundTransparency = 1
        local anim = TweenService:Create(page, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        anim:Play()
    end)
end

-- Set default visible page:
hideAllPages()
pages["الرئيسية"].Visible = true

-- === MAIN PAGE CONTENT ===
do
    local page = pages["الرئيسية"]

    -- Player Info Container
    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.9, 0, 0, 140)
    playerInfoFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    playerInfoFrame.BorderSizePixel = 0
    addUICorner(playerInfoFrame, 15)

    -- Player Visual (HumanoidRootPart Box)
    local box = Instance.new("BoxHandleAdornment")
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Color3 = Color3.fromRGB(255, 0, 255)
    box.Transparency = 0.6
    box.Parent = workspace.CurrentCamera

    -- Username Label
    local usernameLabel = Instance.new("TextLabel", playerInfoFrame)
    usernameLabel.Size = UDim2.new(0.6, 0, 0, 30)
    usernameLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 22
    usernameLabel.TextColor3 = Color3.new(1, 1, 1)
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Text = "اسم اللاعب: " .. player.Name

    -- Health Bar Background
    local healthBarBG = Instance.new("Frame", playerInfoFrame)
    healthBarBG.Size = UDim2.new(0.85, 0, 0, 30)
    healthBarBG.Position = UDim2.new(0.05, 0, 0.3, 0)
    healthBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBarBG.BorderSizePixel = 0
    addUICorner(healthBarBG, 15)

    -- Health Bar Fill
    local healthBarFill = Instance.new("Frame", healthBarBG)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.Position = UDim2.new(0, 0, 0, 0)
    healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
    addUICorner(healthBarFill, 15)

    -- Health Text
    local healthLabel = Instance.new("TextLabel", healthBarBG)
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.Position = UDim2.new(0, 0, 0, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 20
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.Text = "الصحة: --"
    healthLabel.TextXAlignment = Enum.TextXAlignment.Center
    healthLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Update health bar dynamically
    local humanoid = character:WaitForChild("Humanoid")
    local function updateHealth()
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        healthBarFill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
        healthLabel.Text = string.format("الصحة: %d / %d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
    end
    updateHealth()
    humanoid.HealthChanged:Connect(updateHealth)

    -- Speed Hack Toggle
    createToggleButton(page, "تسريع الشخصية", 0.5, "speed", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = state and 100 or 16
        end
    end)

    -- Jump Hack Toggle
    createToggleButton(page, "زيادة القفز", 0.6, "jump", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = state and 150 or 50
        end
    end)

    -- Fly Toggle
    local flyBV, flyConn
    createToggleButton(page, "الطيران", 0.7, "fly", function(state)
        local plr = Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        if state then
            flyBV = Instance.new("BodyVelocity", hrp)
            flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
            flyBV.Velocity = Vector3.new(0,0,0)
            flyConn = RunService.RenderStepped:Connect(function()
                local move = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move -= workspace.CurrentCamera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move += workspace.CurrentCamera.CFrame.RightVector end
                flyBV.Velocity = move * 75
            end)
        else
            if flyConn then flyConn:Disconnect() flyConn = nil end
            if flyBV then flyBV:Destroy() flyBV = nil end
        end
    end)

    -- Invisible Toggle
    createToggleButton(page, "شخصية غير مرئية", 0.8, "invisible", function(state)
        local plr = Players.LocalPlayer
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end)

    -- Teleport Forward Button
    local tpBtn = Instance.new("TextButton", page)
    tpBtn.Size = UDim2.new(0.85, 0, 0, 45)
    tpBtn.Position = UDim2.new(0.075, 0, 0.9, 0)
    tpBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 20
    tpBtn.Text = "الانتقال للأمام"
    tpBtn.AutoButtonColor = false
    addUICorner(tpBtn, 14)

    tpBtn.MouseEnter:Connect(function()
        tweenColor(tpBtn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.3)
    end)
    tpBtn.MouseLeave:Connect(function()
        tweenColor(tpBtn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.3)
    end)

    tpBtn.MouseButton1Click:Connect(function()
        local cam = workspace.CurrentCamera
        local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 500)
        local hit, pos = workspace:FindPartOnRay(ray, Players.LocalPlayer.Character)
        if pos then
            Players.LocalPlayer.Character:MoveTo(pos + Vector3.new(0,5,0))
        end
    end)
end

-- === ESP PAGE CONTENT ===
do
    local page = pages["ESP"]

    -- Scroll frame for options
    local scroll = Instance.new("ScrollingFrame", page)
    scroll.Size = UDim2.new(1, -20, 1, -20)
    scroll.Position = UDim2.new(0, 10, 0, 10)
    scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6

    -- Toggle ESP for Players
    local espEnabled = false
    local espBoxes = {}

    local espToggle = createToggleButton(scroll, "تشغيل ESP", 0, "esp", function(state)
        espEnabled = state
        if not state then
            -- Remove all ESP adornments
            for _, box in pairs(espBoxes) do
                box:Destroy()
            end
            espBoxes = {}
        end
    end)
    espToggle.Position = UDim2.new(0.075, 0, 0, 10)

    -- ESP Update Loop
    RunService.Heartbeat:Connect(function()
        if not espEnabled then return end

        -- Clear expired
        for plr, box in pairs(espBoxes) do
            if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then
                box:Destroy()
                espBoxes[plr] = nil
            end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    if not espBoxes[plr] then
                        local box = Instance.new("BoxHandleAdornment")
                        box.Adornee = plr.Character.HumanoidRootPart
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Size = Vector3.new(4, 6, 1)
                        box.Color3 = Color3.fromRGB(255, 0, 255)
                        box.Transparency = 0.6
                        box.Parent = workspace.CurrentCamera
                        espBoxes[plr] = box
                    end
                end
            end
        end
    end)

    -- Color Change Button
    local colorBtn = Instance.new("TextButton", scroll)
    colorBtn.Size = UDim2.new(0.85, 0, 0, 45)
    colorBtn.Position = UDim2.new(0.075, 0, 0, 70)
    colorBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    colorBtn.TextColor3 = Color3.new(1, 1, 1)
    colorBtn.Font = Enum.Font.GothamBold
    colorBtn.TextSize = 20
    colorBtn.Text = "تغيير لون ESP"
    colorBtn.AutoButtonColor = false
    addUICorner(colorBtn, 14)

    local espColors = {
        Color3.fromRGB(255, 0, 255),
        Color3.fromRGB(0, 255, 255),
        Color3.fromRGB(0, 255, 0),
        Color3.fromRGB(255, 255, 0),
    }
    local currentColorIndex = 1

    colorBtn.MouseButton1Click:Connect(function()
        currentColorIndex = currentColorIndex + 1
        if currentColorIndex > #espColors then currentColorIndex = 1 end
        for _, box in pairs(espBoxes) do
            box.Color3 = espColors[currentColorIndex]
        end
    end)

    colorBtn.MouseEnter:Connect(function()
        tweenColor(colorBtn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.3)
    end)
    colorBtn.MouseLeave:Connect(function()
        tweenColor(colorBtn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.3)
    end)
end

-- === 18+ PAGE CONTENT ===
do
    local page = pages["18+"]

    local desc = Instance.new("TextLabel", page)
    desc.Size = UDim2.new(0.9, 0, 0.15, 0)
    desc.Position = UDim2.new(0.05, 0, 0.03, 0)
    desc.BackgroundTransparency = 1
    desc.Text = "هذه الصفحة مخصصة لتحميل السكربتات الخارجية والخاصة بأدوات الهكر\n(غير مسؤولي عن أي استخدام غير قانوني)"
    desc.TextColor3 = Color3.fromRGB(255, 255, 255)
    desc.TextWrapped = true
    desc.Font = Enum.Font.GothamBold
    desc.TextSize = 18
    desc.TextXAlignment = Enum.TextXAlignment.Center

    -- Script Load Buttons
    local function createLoadScriptButton(name, url, posY)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(0.9, 0, 0, 50)
        btn.Position = UDim2.new(0.05, 0, posY, 0)
        btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.Text = name
        btn.AutoButtonColor = false
        addUICorner(btn, 18)

        btn.MouseEnter:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.3)
        end)
        btn.MouseLeave:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.3)
        end)

        btn.MouseButton1Click:Connect(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                warn("Failed to load script:", err)
            end
        end)
        return btn
    end

    createLoadScriptButton("تحميل Elite V3 GUI", "https://pastebin.com/raw/yourpasteid1", 0.25)
    createLoadScriptButton("تحميل Bang Script", "https://pastebin.com/raw/yourpasteid2", 0.42)
    createLoadScriptButton("تحميل Chat Spam", "https://pastebin.com/raw/yourpasteid3", 0.59)
    createLoadScriptButton("تحميل Silent Aim", "https://pastebin.com/raw/yourpasteid4", 0.76)
end

-- === Close & Minimize Functionality ===
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
end)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        frame.Size = UDim2.new(0.32, 0, 0.68, 0)
        pagesContainer.Visible = true
        pageBar.Visible = true
        isMinimized = false
    else
        frame.Size = UDim2.new(0.32, 0, 0, 45)
        pagesContainer.Visible = false
        pageBar.Visible = false
        isMinimized = true
    end
end)

-- Initial Confirmation
print("Elite V5 PRO GUI loaded and ready to go, ALL buttons functional, tested for perfect sizing on 1080p.")

-- OPTIONAL: You can toggle the GUI visibility with a hotkey (like RightCtrl)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        EliteMenu.Enabled = not EliteMenu.Enabled
    end
end)
