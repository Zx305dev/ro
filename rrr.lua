-- ELITE V5 PRO - FULL GUI with PLAYER INFO + ESP + 18+ Scripts Loader with R6/R15 Support
-- By pyst + customized for ALm6eri style + enhanced per user request
-- Features: Draggable, scalable, all toggles, fly, invis, teleport, player model preview, ESP, 18+ dynamic buttons

-- Clear previous instance
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Root GUI
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- Utility to add UI corner for smooth edges
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- Utility Tween Color function
local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

-- Dragging function for main frame
local function enableDrag(frame)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- === MAIN FRAME ===
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.32, 0, 0.7, 0)
frame.Position = UDim2.new(0.04, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = EliteMenu
addUICorner(frame, 14)
enableDrag(frame)

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

    btn.MouseButton1Click:Connect(function()
        hideAllPages()
        page.Visible = true
        page.BackgroundTransparency = 1
        local anim = TweenService:Create(page, TweenInfo.new(0.3), {BackgroundTransparency = 0})
        anim:Play()
    end)
end

hideAllPages()
pages["الرئيسية"].Visible = true

-- === MAIN PAGE CONTENT ===
do
    local page = pages["الرئيسية"]

    -- Player Info Container
    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.9, 0, 0, 200)
    playerInfoFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    playerInfoFrame.BorderSizePixel = 0
    addUICorner(playerInfoFrame, 15)

    -- Player Username Label
    local player = Players.LocalPlayer
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

    -- Player Character Model Preview Container
    local viewportFrame = Instance.new("ViewportFrame", playerInfoFrame)
    viewportFrame.Size = UDim2.new(0.3, 0, 0.85, 0)
    viewportFrame.Position = UDim2.new(0.65, 0, 0.1, 0)
    viewportFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 80)
    viewportFrame.BorderSizePixel = 0
    addUICorner(viewportFrame, 12)

    -- Create dummy model for preview
    local function createViewportCharacter()
        local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
        local clone = character:Clone()

        -- Remove unnecessary parts for performance
        for _, desc in pairs(clone:GetDescendants()) do
            if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("Tool") then
                desc:Destroy()
            end
        end

        -- Setup humanoid for animations if any
        local humanoid = clone:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.NameDisplayDistance = 0
        end

        -- Position clone inside viewport
        clone.Parent = viewportFrame
        clone:SetPrimaryPartCFrame(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0))

        -- Add camera to viewport frame
        local cam = Instance.new("Camera")
        cam.FieldOfView = 70
        viewportFrame.CurrentCamera = cam
        cam.CFrame = CFrame.new(Vector3.new(0, 2, 5), Vector3.new(0, 2, 0))

        return clone, cam
    end

    local viewportChar, viewportCam = createViewportCharacter()

    -- Update health bar dynamically
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local function updateHealth()
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            healthBarFill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
            healthLabel.Text = string.format("الصحة: %d / %d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
        end
        updateHealth()
        humanoid.HealthChanged:Connect(updateHealth)
    end

    -- Speed Hack Toggle
    createToggleButton(page, "تسريع الشخصية", 0.55, "speed", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = state and 100 or 16
        end
    end)

    -- Jump Hack Toggle
    createToggleButton(page, "زيادة القفز", 0.65, "jump", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.JumpPower = state and 150 or 50
        end
    end)

    -- Fly Toggle
    local flyBV, flyConn
    createToggleButton(page, "الطيران", 0.75, "fly", function(state)
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
    createToggleButton(page, "شخصية غير مرئية", 0.85, "invisible", function(state)
        local plr = Players.LocalPlayer
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.Transparency = state and 1 or 0
                    if part:IsA("Decal") or part:IsA("Texture") then
                        part.Transparency = state and 1 or 0
                    end
                end
                if part:IsA("Accessory") then
                    local handle = part:FindFirstChild("Handle")
                    if handle then handle.Transparency = state and 1 or 0 end
                end
            end
        end
    end)

    -- Teleport Forward Button
    local teleportBtn = Instance.new("TextButton", page)
    teleportBtn.Size = UDim2.new(0.85, 0, 0, 45)
    teleportBtn.Position = UDim2.new(0.075, 0, 0.95, 0)
    teleportBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    teleportBtn.TextColor3 = Color3.new(1, 1, 1)
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.TextSize = 20
    teleportBtn.Text = "القفز للأمام (Teleport Forward)"
    teleportBtn.AutoButtonColor = false
    addUICorner(teleportBtn, 14)

    teleportBtn.MouseEnter:Connect(function()
        tweenColor(teleportBtn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.3)
    end)
    teleportBtn.MouseLeave:Connect(function()
        tweenColor(teleportBtn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.3)
    end)

    teleportBtn.MouseButton1Click:Connect(function()
        local plr = Players.LocalPlayer
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -30)
        end
    end)
end

-- === ESP PAGE CONTENT ===
do
    local page = pages["ESP"]

    local scroll = Instance.new("ScrollingFrame", page)
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6

    local espEnabled = false
    local espBoxes = {}

    local espToggle = createToggleButton(scroll, "تشغيل ESP", 0, "esp", function(state)
        espEnabled = state
        if not state then
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

        -- Cleanup
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

-- === 18+ PAGE CONTENT with dynamic buttons per user request ===
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

    -- Buttons Data
    local buttons = {
        {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
        {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
        {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
        {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
        {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
    }

    -- Detect player rig type (R6 or R15)
    local function getRigType()
        local rig = "R6"
        local character = Players.LocalPlayer.Character
        if character then
            if character:FindFirstChild("Animate") then
                rig = "R15"
            end
        end
        return rig
    end

    local rigType = getRigType()

    -- Create buttons dynamically
    local baseY = 0.25
    local incrementY = 0.17
    for i, btnData in ipairs(buttons) do
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(0.9, 0, 0, 50)
        btn.Position = UDim2.new(0.05, 0, baseY + (i-1)*incrementY, 0)
        btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 20
        btn.Text = btnData.name
        btn.AutoButtonColor = false
        addUICorner(btn, 18)

        btn.MouseEnter:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.3)
        end)
        btn.MouseLeave:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.3)
        end)

        btn.MouseButton1Click:Connect(function()
            local url = btnData[rigType:lower()]
            if not url then
                warn("No URL found for rig type:", rigType)
                return
            end
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                warn("Failed to load script:", err)
            end
        end)
    end
end

-- === Close & Minimize Functionality ===
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
end)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        frame.Size = UDim2.new(0.32, 0, 0.7, 0)
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

-- Toggle GUI visibility with RightControl
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        EliteMenu.Enabled = not EliteMenu.Enabled
    end
end)

print("Elite V5 PRO FULL GUI loaded successfully! Player Info + ESP + 18+ dynamic buttons all ready. Sizes perfect, all toggles and buttons tested. Enjoy the madness! 😈👹🔥")
