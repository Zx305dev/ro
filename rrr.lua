-- Elite V5 PRO GUI متكامل مع سكربتات 18+ حصرية بدون حقوق | تحسين كامل للواجهة | تحريك النافذة

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

-- Utility Functions
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

-- Dragging Functionality for any frame
local function makeDraggable(frame)
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

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 460, 0, 520) -- أكبر حجم محسّن
frame.Position = UDim2.new(0.25, 0, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = EliteMenu
addUICorner(frame, 20)
makeDraggable(frame)

-- Header Bar
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
header.BorderSizePixel = 0
addUICorner(header, 20)
makeDraggable(header)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | ALm6eri"
title.Size = UDim2.new(0.75, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 50, 1, 0)
closeBtn.Position = UDim2.new(0.91, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 36
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 18)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 50, 1, 0)
minimizeBtn.Position = UDim2.new(0.82, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 38
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 18)

-- Pages Bar
local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 60)
pageBar.Position = UDim2.new(0, 0, 0, 45)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.04, 0)

-- Pages Container
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -105)
pagesContainer.Position = UDim2.new(0, 0, 0, 105)
pagesContainer.BackgroundTransparency = 1

-- Create Page Buttons
local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 150, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 24
    btn.AutoButtonColor = false
    addUICorner(btn, 18)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 255), 0.25)
    end)

    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(130, 0, 200), 0.25)
    end)

    return btn
end

-- Toggle Button Creator
local togglesState = {}
local function createToggleButton(parent, text, posY, key, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 24
    btn.Text = text .. " : إيقاف"
    btn.AutoButtonColor = false
    addUICorner(btn, 20)

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

-- Pages setup
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
        TweenService:Create(page, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
    end)
end
hideAllPages()
pages["الرئيسية"].Visible = true

-- ====== الصفحة الرئيسية (Main) ======
do
    local page = pages["الرئيسية"]

    -- Player Info Frame
    local playerInfoFrame = Instance.new("Frame", page)
    playerInfoFrame.Size = UDim2.new(0.9, 0, 0, 140)
    playerInfoFrame.Position = UDim2.new(0.05, 0, 0.03, 0)
    playerInfoFrame.BackgroundColor3 = Color3.fromRGB(75, 0, 130)
    playerInfoFrame.BorderSizePixel = 0
    addUICorner(playerInfoFrame, 20)

    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")

    -- Username Label
    local usernameLabel = Instance.new("TextLabel", playerInfoFrame)
    usernameLabel.Size = UDim2.new(0.6, 0, 0, 40)
    usernameLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Font = Enum.Font.GothamBold
    usernameLabel.TextSize = 28
    usernameLabel.TextColor3 = Color3.new(1, 1, 1)
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.Text = "اسم اللاعب: " .. player.Name

    -- Health Bar Background
    local healthBarBG = Instance.new("Frame", playerInfoFrame)
    healthBarBG.Size = UDim2.new(0.85, 0, 0, 40)
    healthBarBG.Position = UDim2.new(0.05, 0, 0.5, 0)
    healthBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBarBG.BorderSizePixel = 0
    addUICorner(healthBarBG, 20)

    -- Health Bar Fill
    local healthBarFill = Instance.new("Frame", healthBarBG)
    healthBarFill.Size = UDim2.new(1, 0, 1, 0)
    healthBarFill.BackgroundColor3 = Color3.fromRGB(0, 200, 90)
    addUICorner(healthBarFill, 20)

    -- Health Text
    local healthLabel = Instance.new("TextLabel", healthBarBG)
    healthLabel.Size = UDim2.new(1, 0, 1, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Font = Enum.Font.GothamBold
    healthLabel.TextSize = 24
    healthLabel.TextColor3 = Color3.new(1, 1, 1)
    healthLabel.TextXAlignment = Enum.TextXAlignment.Center
    healthLabel.TextYAlignment = Enum.TextYAlignment.Center
    healthLabel.Text = "الصحة: --"

    -- Update health bar dynamically
    local function updateHealth()
        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        healthBarFill:TweenSize(UDim2.new(healthPercent, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
        healthLabel.Text = string.format("الصحة: %d / %d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
    end
    updateHealth()
    humanoid.HealthChanged:Connect(updateHealth)

    -- Speed Hack Toggle
    createToggleButton(page, "تسريع الشخصية", 0.4, "speed", function(state)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = state and 100 or 16
        end
    end)

    -- Jump Hack Toggle
    createToggleButton(page, "زيادة القفز", 0.5, "jump", function(state)
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.JumpPower = state and 150 or 50
        end
    end)

    -- Fly Toggle
    local flyBV, flyConn
    createToggleButton(page, "الطيران", 0.6, "fly", function(state)
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        if state then
            flyBV = Instance.new("BodyVelocity", hrp)
            flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            flyBV.Velocity = Vector3.new(0,0,0)
            flyConn = RunService.Heartbeat:Connect(function()
                local cam = workspace.CurrentCamera
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    flyBV.Velocity = cam.CFrame.LookVector * 50
                elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    flyBV.Velocity = -cam.CFrame.LookVector * 50
                else
                    flyBV.Velocity = Vector3.new(0,0,0)
                end
            end)
        else
            if flyBV then flyBV:Destroy() flyBV = nil end
            if flyConn then flyConn:Disconnect() flyConn = nil end
        end
    end)

end

-- ====== صفحة ESP (رؤية اللاعبين) ======
do
    local page = pages["ESP"]
    local espEnabled = false
    local espBoxes = {}

    local function clearESP()
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end

    local function createESP(player)
        if player == Players.LocalPlayer then return end
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 1)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.Parent = workspace.CurrentCamera
        return box
    end

    local toggleBtn = createToggleButton(page, "تشغيل ESP", 0.1, "esp", function(state)
        espEnabled = state
        if espEnabled then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local box = createESP(plr)
                    if box then
                        espBoxes[plr] = box
                    end
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if espEnabled then
                    repeat wait() until plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    local box = createESP(plr)
                    if box then espBoxes[plr] = box end
                end
            end)
            Players.PlayerRemoving:Connect(function(plr)
                if espBoxes[plr] then
                    espBoxes[plr]:Destroy()
                    espBoxes[plr] = nil
                end
            end)
        else
            clearESP()
        end
    end)

end

-- ====== صفحة 18+ ======
do
    local page = pages["18+"]

    -- Label
    local label = Instance.new("TextLabel", page)
    label.Size = UDim2.new(0.9, 0, 0, 40)
    label.Position = UDim2.new(0.05, 0, 0.05, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = "سكربتات 18+ حصرية وبدون حقوق"

    -- Function to run an injected script (simulate a '18+ script')
    local function runHotScript(name)
        if name == "Bang Bang V3" then
            local plr = Players.LocalPlayer
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = 30
                hum.JumpPower = 75
                task.delay(5, function()
                    if hum then
                        hum.WalkSpeed = 16
                        hum.JumpPower = 50
                    end
                end)
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Bang Bang V3",
                    Text = "تم تفعيل سكربت Bang Bang 18+ بنجاح!",
                    Duration = 4
                })
            end
        elseif name == "Hot Spray" then
            local plr = Players.LocalPlayer
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local particle = Instance.new("ParticleEmitter")
            particle.Texture = "rbxassetid://258128463"
            particle.Lifetime = NumberRange.new(0.5, 0.8)
            particle.Rate = 150
            particle.Speed = NumberRange.new(5, 10)
            particle.Parent = hrp
            game.StarterGui:SetCore("SendNotification", {
                Title = "Hot Spray",
                Text = "تم تفعيل رشاش الماء الساخن (18+)!",
                Duration = 4
            })
            task.delay(8, function()
                particle.Enabled = false
                task.wait(1)
                particle:Destroy()
            end)
        elseif name == "Jerk Mode" then
            local plr = Players.LocalPlayer
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                for i = 1, 10 do
                    hum.WalkSpeed = 50
                    wait(0.2)
                    hum.WalkSpeed = 10
                    wait(0.2)
                end
                hum.WalkSpeed = 16
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Jerk Mode",
                    Text = "تم تفعيل وضع Jerk 18+ بنجاح!",
                    Duration = 4
                })
            end
        end
    end

    -- Buttons List
    local scriptNames = {
        "Bang Bang V3",
        "Hot Spray",
        "Jerk Mode"
    }

    for i, scriptName in ipairs(scriptNames) do
        local btn = Instance.new("TextButton", page)
        btn.Size = UDim2.new(0.8, 0, 0, 50)
        btn.Position = UDim2.new(0.1, 0, 0.15 + (i-1)*0.12, 0)
        btn.BackgroundColor3 = Color3.fromRGB(180, 20, 180)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 22
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Text = scriptName
        btn.AutoButtonColor = false
        addUICorner(btn, 15)

        btn.MouseEnter:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(230, 50, 230), 0.25)
        end)
        btn.MouseLeave:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(180, 20, 180), 0.25)
        end)

        btn.MouseButton1Click:Connect(function()
            runHotScript(scriptName)
        end)
    end
end

-- Close & Minimize logic
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame:TweenSize(UDim2.new(0, 460, 0, 45), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.5)
        pageBar.Visible = false
        pagesContainer.Visible = false
    else
        frame:TweenSize(UDim2.new(0, 460, 0, 520), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
        pageBar.Visible = true
        pagesContainer.Visible = true
    end
end)

-- Ready message
game.StarterGui:SetCore("SendNotification", {
    Title = "Elite V5 PRO",
    Text = "تم تحميل القائمة بنجاح! استمتع بالسكربتات.",
    Duration = 5
})
