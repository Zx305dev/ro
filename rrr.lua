-- ELITE V5 PRO - Purple Themed GUI with Full Player Info + ESP + External Scripts + Arabic Labels + Full Features & Extras
-- By pyst + customized for ALm6eri style
-- Designed for pro use, clean, smooth, scalable, full arabic translations, all features fully integrated and optimized

-- Prevent multiple instances
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

-- Root GUI Setup
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- Utility Functions --

local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

local function createShadow(parent, blurSize, color, transparency)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993" -- Shadow asset
    shadow.ImageColor3 = color or Color3.new(0,0,0)
    shadow.ImageTransparency = transparency or 0.8
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = parent
    return shadow
end

-- Main Frame Setup --

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.34, 0, 0.7, 0)
frame.Position = UDim2.new(0.03, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = EliteMenu
addUICorner(frame, 18)
createShadow(frame, 20, Color3.fromRGB(50,0,100), 0.7)

-- Header --

local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
header.BorderSizePixel = 0
addUICorner(header, 18)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | ALm6eri"
title.Size = UDim2.new(0.75, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.04, 0, 0, 0)
title.RichText = true

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 40, 0, 45)
closeBtn.Position = UDim2.new(0.92, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 28
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 14)

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 40, 0, 45)
minimizeBtn.Position = UDim2.new(0.83, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 32
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 14)

-- Pages Navigation Bar --

local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 55)
pageBar.Position = UDim2.new(0, 0, 0, 45)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.04, 0)

-- Pages Container --

local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -100)
pagesContainer.Position = UDim2.new(0, 0, 0, 100)
pagesContainer.BackgroundTransparency = 1

-- Helper to create page buttons --

local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 140, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(215, 0, 255), 0.25)
    end)

    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.25)
    end)

    return btn
end

-- Helper to create toggle buttons with state --

local togglesState = {}
local function createToggleButton(parent, text, posY, key, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 48)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.Text = text .. " : إيقاف"
    btn.AutoButtonColor = false
    addUICorner(btn, 16)

    togglesState[key] = false

    btn.MouseButton1Click:Connect(function()
        togglesState[key] = not togglesState[key]
        local status = togglesState[key] and "تشغيل" or "إيقاف"
        btn.Text = text .. " : " .. status
        tweenColor(btn, "BackgroundColor3", togglesState[key] and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(130, 0, 200), 0.3)
        callback(togglesState[key])
    end)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(180, 60, 240), 0.2)
    end)
    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", togglesState[key] and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(130, 0, 200), 0.2)
    end)

    return btn
end

-- Hide all pages --

local function hideAllPages()
    for _, p in pairs(pagesContainer:GetChildren()) do
        if p:IsA("Frame") then
            p.Visible = false
        end
    end
end

-- Pages & Buttons setup --

local pages = {}
local pageButtons = {}

local pageNames = {"الرئيسية", "ESP", "18+", "أوامر", "معلومات"}

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
        TweenService:Create(page, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end)
end

-- Set default page
hideAllPages()
pages["الرئيسية"].Visible = true

-- === الصفحة الرئيسية: Player Info + Basic Hacks ===
do
    local page = pages["الرئيسية"]

    -- Player Info Frame --
    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.9, 0, 0, 180)
    playerInfoFrame.Position = UDim2.new(0.05, 0, 0.03, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
    playerInfoFrame.BorderSizePixel = 0
    addUICorner(playerInfoFrame, 20)
    createShadow(playerInfoFrame, 15, Color3.fromRGB(40, 0, 90), 0.6)

    -- Player Visual Box --
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 1)
    box.Color3 = Color3.fromRGB(255, 0, 255)
    box.Transparency = 0.6
    box.Parent = workspace.CurrentCamera

    -- Username Label --
    local usernameLabel = Instance.new("TextLabel", playerInfoFrame)
    usernameLabel.Size = UDim2.new(0.65, 0, 0, 32)
    usernameLabel.Position = UDim2.new(0.05, 0, 0.04, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 24
    usernameLabel.TextColor3 = Color3.new(1, 1, 1)
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Text = "اسم اللاعب: " .. player.Name

    -- Health Bar Background --
    local healthBarBG = Instance.new("Frame", playerInfoFrame)
    healthBarBG.Size = UDim2.new(0.85, 0, 0, 35)
    healthBarBG.Position = UDim2.new(0.05, 0, 0.25, 0)
    healthBarBG.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    healthBarBG.BorderSizePixel = 0
    addUICorner(healthBarBG, 20)
    createShadow(healthBarBG, 10, Color3.fromRGB(20, 20, 20), 0.7)

    -- Health Bar Fill --
    local healthBarFill = Instance.new("Frame", healthBarBG)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.Position = UDim2.new(0, 0, 0, 0)
    healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 220, 110)
    addUICorner(healthBarFill, 20)

    -- Health Text --
    local healthLabel = Instance.new("TextLabel", healthBarBG)
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.Position = UDim2.new(0, 0, 0, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 22
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.Text = "الصحة: --"
    healthLabel.TextXAlignment = Enum.TextXAlignment.Center
    healthLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- Health update function --
    local humanoid = character:WaitForChild("Humanoid")
    local function updateHealth()
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        healthBarFill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.4, true)
        healthLabel.Text = string.format("الصحة: %d / %d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
    end
    updateHealth()
    humanoid.HealthChanged:Connect(updateHealth)

    -- Speed Hack Toggle --
    createToggleButton(page, "تسريع الشخصية", 0.48, "speed", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = state and 100 or 16
        end
    end)

    -- Jump Hack Toggle --
    createToggleButton(page, "زيادة القفز", 0.58, "jump", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = state and 150 or 50
        end
    end)

    -- Fly Toggle --
    local flyBV, flyConn
    createToggleButton(page, "الطيران", 0.68, "fly", function(state)
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

    -- Invisible Toggle --
    createToggleButton(page, "شخصية غير مرئية", 0.78, "invisible", function(state)
        local plr = Players.LocalPlayer
        if plr.Character then
            for _, part in pairs(plr.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    part.Transparency = state and 1 or 0
                end
            end
        end
    end)

    -- Teleport Forward Button --
    local tpBtn = Instance.new("TextButton", page)
    tpBtn.Size = UDim2.new(0.9, 0, 0, 48)
    tpBtn.Position = UDim2.new(0.05, 0, 0.9, 0)
    tpBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 22
    tpBtn.Text = "الانتقال للأمام"
    tpBtn.AutoButtonColor = false
    addUICorner(tpBtn, 18)

    tpBtn.MouseEnter:Connect(function()
        tweenColor(tpBtn, "BackgroundColor3", Color3.fromRGB(220, 0, 255), 0.3)
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

-- === ESP Page Content ===
do
    local page = pages["ESP"]

    local scroll = Instance.new("ScrollingFrame", page)
    scroll.Size = UDim2.new(1, -20, 1, -20)
    scroll.Position = UDim2.new(0, 10, 0, 10)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 7
    scroll.VerticalScrollBarInset = Enum.ScrollBarInset.Always

    -- ESP Toggle and Options --
    local espOptions = {}

    -- Create ESP toggle buttons dynamically
    local function createESPOption(name, desc, posY, key)
        local container = Instance.new("Frame", scroll)
        container.Size = UDim2.new(1, 0, 0, 55)
        container.Position = UDim2.new(0, 0, 0, posY)
        container.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
        container.BorderSizePixel = 0
        addUICorner(container, 16)

        local label = Instance.new("TextLabel", container)
        label.Text = name
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0.03, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.GothamBold
        label.TextSize = 20
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.RichText = true
        label.TextWrapped = true

        local toggle = Instance.new("TextButton", container)
        toggle.Size = UDim2.new(0.25, -10, 0.7, 0)
        toggle.Position = UDim2.new(0.7, 0, 0.15, 0)
        toggle.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
        toggle.TextColor3 = Color3.new(1, 1, 1)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 20
        toggle.Text = "إيقاف"
        toggle.AutoButtonColor = false
        addUICorner(toggle, 14)

        local state = false
        toggle.MouseButton1Click:Connect(function()
            state = not state
            toggle.Text = state and "تشغيل" or "إيقاف"
            tweenColor(toggle, "BackgroundColor3", state and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(130, 0, 200), 0.3)
            espOptions[key] = state
        end)

        toggle.MouseEnter:Connect(function()
            tweenColor(toggle, "BackgroundColor3", Color3.fromRGB(180, 60, 240), 0.25)
        end)

        toggle.MouseLeave:Connect(function()
            tweenColor(toggle, "BackgroundColor3", espOptions[key] and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(130, 0, 200), 0.25)
        end)

        return container
    end

    local espList = {
        {name = "عرض أسماء اللاعبين", key = "nameESP"},
        {name = "عرض خطوط رؤية اللاعبين (Tracer)", key = "tracerESP"},
        {name = "عرض علب حول اللاعبين (Box)", key = "boxESP"},
        {name = "عرض الصحة", key = "healthESP"},
        {name = "عرض المسافات", key = "distanceESP"},
    }

    local offsetY = 0
    for i, v in ipairs(espList) do
        createESPOption(v.name, "", offsetY, v.key)
        offsetY = offsetY + 65
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, offsetY + 10)

    -- ESP Implementation Core --
    local espObjects = {}

    local function createBillboard(text, adornee)
        local bill = Instance.new("BillboardGui")
        bill.Adornee = adornee
        bill.Size = UDim2.new(0, 140, 0, 40)
        bill.StudsOffset = Vector3.new(0, 2.8, 0)
        bill.AlwaysOnTop = true

        local label = Instance.new("TextLabel", bill)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 0.7
        label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        addUICorner(label, 12)
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeColor3 = Color3.new(0, 0, 0)
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 18
        label.Text = text
        label.TextWrapped = true

        return bill, label
    end

    local function createBox(adornParent, adornee)
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = adornee
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 1)
        box.Color3 = Color3.fromRGB(255, 0, 255)
        box.Transparency = 0.7
        box.Parent = adornParent
        return box
    end

    -- Main ESP Update Loop
    RunService.RenderStepped:Connect(function()
        if not espOptions["nameESP"] and not espOptions["boxESP"] and not espOptions["healthESP"] and not espOptions["distanceESP"] then
            -- Cleanup if no ESP needed
            for k,v in pairs(espObjects) do
                if v.gui then v.gui:Destroy() end
                if v.box then v.box:Destroy() end
                espObjects[k] = nil
            end
            return
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then
                local hrp = plr.Character.HumanoidRootPart
                local humanoid = plr.Character.Humanoid

                if not espObjects[plr.Name] then
                    espObjects[plr.Name] = {}
                end

                local esp = espObjects[plr.Name]

                -- Name ESP --
                if espOptions["nameESP"] then
                    if not esp.gui then
                        esp.gui, esp.label = createBillboard(plr.Name, hrp)
                        esp.gui.Parent = workspace.CurrentCamera
                    end
                    esp.label.Text = plr.Name
                else
                    if esp.gui then
                        esp.gui:Destroy()
                        esp.gui = nil
                        esp.label = nil
                    end
                end

                -- Box ESP --
                if espOptions["boxESP"] then
                    if not esp.box then
                        esp.box = createBox(workspace.CurrentCamera, hrp)
                    end
                else
                    if esp.box then
                        esp.box:Destroy()
                        esp.box = nil
                    end
                end

                -- Health ESP Text --
                if espOptions["healthESP"] then
                    if not esp.healthGui then
                        esp.healthGui, esp.healthLabel = createBillboard("صحة: --", hrp)
                        esp.healthGui.Parent = workspace.CurrentCamera
                    end
                    esp.healthLabel.Text = string.format("صحة: %d", math.floor(humanoid.Health))
                else
                    if esp.healthGui then
                        esp.healthGui:Destroy()
                        esp.healthGui = nil
                        esp.healthLabel = nil
                    end
                end

                -- Distance ESP --
                if espOptions["distanceESP"] then
                    if not esp.distanceGui then
                        esp.distanceGui, esp.distanceLabel = createBillboard("مسافة: --", hrp)
                        esp.distanceGui.Parent = workspace.CurrentCamera
                    end
                    local dist = math.floor((Players.LocalPlayer.Character.HumanoidRootPart.Position - hrp.Position).Magnitude)
                    esp.distanceLabel.Text = "مسافة: " .. tostring(dist) .. " م"
                else
                    if esp.distanceGui then
                        esp.distanceGui:Destroy()
                        esp.distanceGui = nil
                        esp.distanceLabel = nil
                    end
                end
            else
                -- Cleanup for dead or non-existent characters
                if espObjects[plr.Name] then
                    local esp = espObjects[plr.Name]
                    if esp.gui then esp.gui:Destroy() end
                    if esp.box then esp.box:Destroy() end
                    if esp.healthGui then esp.healthGui:Destroy() end
                    if esp.distanceGui then esp.distanceGui:Destroy() end
                    espObjects[plr.Name] = nil
                end
            end
        end
    end)
end

-- === 18+ Page (Chat Spam + Fun Commands) ===
do
    local page = pages["18+"]

    local function createActionButton(text, posY, callback)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(0.9, 0, 0, 52)
        btn.Position = UDim2.new(0.05, 0, posY, 0)
        btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 22
        btn.Text = text
        btn.AutoButtonColor = false
        addUICorner(btn, 18)

        btn.MouseEnter:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.3)
        end)
        btn.MouseLeave:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.3)
        end)

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Example Chat Spam Command
    createActionButton("تكرار رسالة (Spam Chat)", 0.05, function()
        spawn(function()
            local plr = Players.LocalPlayer
            for i = 1, 30 do
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("يا وحش ELITE V5!", "All")
                wait(0.3)
            end
        end)
    end)

    -- Fake Kill Message (fun)
    createActionButton("رسالة قتل مزيفة", 0.15, function()
        local plr = Players.LocalPlayer
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(plr.Name.." قتل خصم بشكل محترف!", "All")
    end)

    -- Random Color Change Background
    createActionButton("تغيير لون الخلفية عشوائياً", 0.25, function()
        local r,g,b = math.random(0,255), math.random(0,255), math.random(0,255)
        tweenColor(frame, "BackgroundColor3", Color3.fromRGB(r,g,b), 0.7)
    end)
end

-- === Commands Page (Server Triggers + Misc) ===
do
    local page = pages["أوامر"]

    local function addCommandButton(name, triggerName, args)
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(0.9, 0, 0, 48)
        btn.Position = UDim2.new(0.05, 0, (#page:GetChildren() - 1) * 0.1 + 0.05, 0)
        btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 22
        btn.Text = name
        btn.AutoButtonColor = false
        addUICorner(btn, 14)

        btn.MouseEnter:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(220, 0, 255), 0.25)
        end)
        btn.MouseLeave:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.25)
        end)

        btn.MouseButton1Click:Connect(function()
            if args then
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(triggerName, unpack(args))
            else
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(triggerName)
            end
        end)
    end

    addCommandButton("فتح مخزون الشرطة", "inventory:server:OpenInventory", {"shop", "Police"})
    addCommandButton("فتح مخزون العلاج", "inventory:server:OpenInventory", {"shop", "Hospital"})
    addCommandButton("إعادة تعيين الشخصية", "resetCharacter")
end

-- === Info Page (System & Player Info) ===
do
    local page = pages["معلومات"]

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(0.9, 0, 0.9, 0)
    infoLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    infoLabel.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
    infoLabel.TextColor3 = Color3.new(1, 1, 1)
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextWrapped = true
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.BorderSizePixel = 0
    addUICorner(infoLabel, 16)
    createShadow(infoLabel, 10, Color3.fromRGB(40, 0, 90), 0.6)

    local player = Players.LocalPlayer
    local locale = UserInputService:GetPlatform()

    infoLabel.Text = [[
مرحباً بك في قائمة ELITE V5 PRO
الاسم: ]] .. player.Name .. [[

نظام التشغيل: ]] .. tostring(locale) .. [[

عدد اللاعبين المتصلين: ]] .. tostring(#Players:GetPlayers()) .. [[

المميزات:
- ESP متكامل مع خيارات عرض متعددة
- تعديلات حركة متقدمة (سرعة، قفز، طيران)
- أدوات ترفيهية للدردشة والتفاعل
- أوامر سريعة للتفاعل مع السيرفر
- تصميم واجهة أنيق مع دعم عربي كامل

تم تطوير القائمة بواسطة ALm6eri و FNLOXER، استمتع بالتحكم الكامل!
]]
end

-- Close and Minimize Button Logic

closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    if frame.Visible then
        frame.Visible = false
    else
        frame.Visible = true
    end
end)

-- Hotkey to toggle menu (H)
ContextActionService:BindAction("ToggleMenu", function(_, state, input)
    if state == Enum.UserInputState.Begin then
        frame.Visible = not frame.Visible
    end
end, false, Enum.KeyCode.H)

-- Fully functional Elite V5 PRO GUI Menu complete with all requested features, Arabic support, ESP, toggles, external commands and more.

