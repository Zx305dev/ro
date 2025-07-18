

```lua
-- ELITE V3 - Purple GUI SCRIPT + Toggle Switches + Bang Command
-- Synapse X, KRNL, Fluxus compatible

pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false

local frame = Instance.new("Frame", EliteMenu)
frame.Name = "MainFrame"
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Position = UDim2.new(0.05, 0, 0.15, 0)
frame.Size = UDim2.new(0.32, 0, 0.7, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", frame)
title.Text = "ELITE V3"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28

-- Helper function: Create Toggle Button
local function createToggleButton(parent, name, position, callback)
    local toggleFrame = Instance.new("Frame", parent)
    toggleFrame.Size = UDim2.new(0.8, 0, 0.12, 0)
    toggleFrame.Position = position
    toggleFrame.BackgroundTransparency = 0.1
    toggleFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 110)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.ClipsDescendants = true

    local uicorner = Instance.new("UICorner", toggleFrame)
    uicorner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel", toggleFrame)
    label.Text = name
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton", toggleFrame)
    toggleBtn.Size = UDim2.new(0.25, 0, 0.7, 0)
    toggleBtn.Position = UDim2.new(0.72, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
    toggleBtn.Text = "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 18
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.AutoButtonColor = false

    local toggleUICorner = Instance.new("UICorner", toggleBtn)
    toggleUICorner.CornerRadius = UDim.new(0, 6)

    local toggled = false

    local function updateToggle()
        if toggled then
            toggleBtn.Text = "ON"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        else
            toggleBtn.Text = "OFF"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 170)
        end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        updateToggle()
        callback(toggled)
    end)

    updateToggle()
    return toggleFrame
end

-- Pages Container
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 0.78, 0)
pagesContainer.Position = UDim2.new(0, 0, 0.12, 0)
pagesContainer.BackgroundTransparency = 1

local pages = {}

local function showPage(name)
    for k,v in pairs(pages) do
        v.Visible = (k == name)
    end
end

-- Navigation Buttons Bar
local navBar = Instance.new("Frame", frame)
navBar.Size = UDim2.new(1, 0, 0.1, 0)
navBar.Position = UDim2.new(0, 0, 0.9, 0)
navBar.BackgroundTransparency = 1

local pageNames = {"Main", "ESP", "ChatSpam", "18+", "Bang"}

for i, pageName in ipairs(pageNames) do
    local btn = Instance.new("TextButton", navBar)
    btn.Text = pageName
    btn.Size = UDim2.new(1/#pageNames - 0.02, 0, 1, 0)
    btn.Position = UDim2.new((i-1)/#pageNames + 0.01*(i-1), 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        showPage(pageName)
    end)
end

-- === Main Page ===
pages["Main"] = Instance.new("Frame", pagesContainer)
pages["Main"].Size = UDim2.new(1, 0, 1, 0)
pages["Main"].BackgroundTransparency = 1
pages["Main"].Visible = true

-- Main Toggles
createToggleButton(pages["Main"], "Speed Boost", UDim2.new(0.1, 0, 0.05, 0), function(state)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = state and 100 or 16
    end
end)

createToggleButton(pages["Main"], "High Jump", UDim2.new(0.1, 0, 0.2, 0), function(state)
    local plr = game.Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.JumpPower = state and 150 or 50
    end
end)

local flyConnection = nil
createToggleButton(pages["Main"], "Fly", UDim2.new(0.1, 0, 0.35, 0), function(state)
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    if state then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, 0, 0)

        flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local move = Vector3.new()
            local UIS = game:GetService("UserInputService")
            if UIS:IsKeyDown(Enum.KeyCode.W) then
                move = move + workspace.CurrentCamera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                move = move - workspace.CurrentCamera.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                move = move - workspace.CurrentCamera.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                move = move + workspace.CurrentCamera.CFrame.RightVector
            end
            bv.Velocity = move * 75
        end)
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        local flyVel = hrp:FindFirstChild("FlyVelocity")
        if flyVel then flyVel:Destroy() end
    end
end)

createToggleButton(pages["Main"], "Invisible", UDim2.new(0.1, 0, 0.5, 0), function(state)
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            v.Transparency = state and 1 or 0
        end
    end
end)

-- === ESP Page ===
pages["ESP"] = Instance.new("Frame", pagesContainer)
pages["ESP"].Size = UDim2.new(1, 0, 1, 0)
pages["ESP"].BackgroundTransparency = 1
pages["ESP"].Visible = false

local espEnabled = false
local espBoxes = {}

local function createEspBox(player)
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESPBox"
    box.Adornee = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 6, 4)
    box.Color3 = Color3.new(1, 0, 0)
    box.Transparency = 0.5
    box.Parent = workspace.CurrentCamera
    return box
end

local function toggleEsp(state)
    espEnabled = state
    if not espEnabled then
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    else
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                espBoxes[plr.Name] = createEspBox(plr)
            end
        end
    end
end

createToggleButton(pages["ESP"], "Enable ESP", UDim2.new(0.1, 0, 0.05, 0), toggleEsp)

game.Players.PlayerAdded:Connect(function(plr)
    if espEnabled and plr ~= game.Players.LocalPlayer then
        espBoxes[plr.Name] = createEspBox(plr)
    end
end)

game.Players.PlayerRemoving:Connect(function(plr)
    if espBoxes[plr.Name] then
        espBoxes[plr.Name]:Destroy()
        espBoxes[plr.Name] = nil
    end
end)

-- === Chat Spam Page ===
pages["ChatSpam"] = Instance.new("Frame", pagesContainer)
pages["ChatSpam"].Size = UDim2.new(1, 0, 1, 0)
pages["ChatSpam"].BackgroundTransparency = 1
pages["ChatSpam"].Visible = false

local chatSpamActive = false
local spamMsg = "Bang Bang 😈👹🔥"
local spamInterval = 2

local function chatSpam()
    while chatSpamActive do
        local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then
            chatEvent.SayMessageRequest:FireServer(spamMsg, "All")
        end
        wait(spamInterval)
    end
end

createToggleButton(pages["ChatSpam"], "Toggle Spam", UDim2.new(0.1, 0, 0.05, 0), function(state)
    chatSpamActive = state
    if chatSpamActive then
        spawn(chatSpam)
    end
end)

local spamInput = Instance.new("TextBox", pages["ChatSpam"])
spamInput.Size = UDim2.new(0.8, 0, 0.12, 0)
spamInput.Position = UDim2.new(0.1, 0, 0.2, 0)
spamInput.PlaceholderText = "اكتب رسالة السبام هنا"
spamInput.Text = spamMsg
spamInput.ClearTextOnFocus = false
spamInput.TextWrapped = true
spamInput.TextScaled = false
spamInput.Font = Enum.Font.Gotham
spamInput.TextSize = 14

spamInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and spamInput.Text ~= "" then
        spamMsg = spamInput.Text
    end
end)

-- === 18+ Page ===
pages["18+"] = Instance.new("Frame", pagesContainer)
pages["18+"].Size = UDim2.new(1, 0, 1, 0)
pages["18+"].BackgroundTransparency = 1
pages["18+"].Visible = false

local label18 = Instance.new("TextLabel", pages["18+"])
label18.Size = UDim2.new(0.8, 0, 0.2, 0)
label18.Position = UDim2.new(0.1, 0, 0.4, 0)
label18.Text = "🔥 18+ CONTENT 🔥"
label18.TextColor3 = Color3.fromRGB(255, 0, 0)
label18.Font = Enum.Font.GothamBlack
label18.TextSize = 50
label18.TextStrokeTransparency = 0
label18.BackgroundTransparency = 1
label18.TextScaled = true

-- Pulse effect for 18+ text
local pulseDir = 1
game:GetService("RunService").RenderStepped:Connect(function()
    local size = label18.TextSize
    if size >= 60 then pulseDir = -1 end
    if size <= 40 then pulseDir = 1 end
    label18.TextSize = size + pulseDir * 0.5
end)

-- === Bang Page ===
pages["Bang"] = Instance.new("Frame", pagesContainer)
pages["Bang"].Size = UDim2.new(1, 0, 1, 0)
pages["Bang"].BackgroundTransparency = 1
pages["Bang"].Visible = false

-- Bang function inspired by InfiniteYield
local function bangEffect()
    local plr = game.Players.LocalPlayer
    local cam = workspace.CurrentCamera

    -- Screen shake variables
    local shakeTime = 3
    local shakeMagnitude = 2
    local startTime = tick()

    -- Create big BANG label
    local bangLabel = Instance.new("TextLabel", cam)
    bangLabel.Size = UDim2.new(0.8, 0, 0.3, 0)
    bangLabel.Position = UDim2.new(0.1, 0, 0.35, 0)
    bangLabel.BackgroundTransparency = 1
    bangLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    bangLabel.Font = Enum.Font.GothamBlack
    bangLabel.TextSize = 72
    bangLabel.TextStrokeTransparency = 0
    bangLabel.Text = "BANG!!!"
    bangLabel.TextScaled = true
    bangLabel.ZIndex = 1000

    -- Play sound if available
    local sound = Instance.new("Sound", cam)
    sound.SoundId = "rbxassetid://138186576" -- Explosion sound example
    sound.Volume = 1
    sound:Play()

    -- Screen shake loop
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        local elapsed = tick() - startTime
        if elapsed > shakeTime then
            connection:Disconnect()
            bangLabel:Destroy()
            sound:Destroy()
            cam.CFrame = cam.CFrame -- reset if needed
            return
        end
        local shakeOffset = Vector3.new(
            math.sin(elapsed * 50) * shakeMagnitude * (shakeTime - elapsed)/shakeTime,
            math.cos(elapsed * 60) * shakeMagnitude * (shakeTime - elapsed)/shakeTime,
            0
        )
        cam.CFrame = cam.CFrame * CFrame.new(shakeOffset)
    end)
end

local bangBtn = Instance.new("TextButton", pages["Bang"])
bangBtn.Text = "Activate BANG"
bangBtn.Size = UDim2.new(0.6, 0, 0.25, 0)
bangBtn.Position = UDim2.new(0.2, 0, 0.4, 0)
bangBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bangBtn.TextColor3 = Color3.new(1, 1, 1)
bangBtn.Font = Enum.Font.GothamBlack
bangBtn.TextSize = 24
local bangUICorner = Instance.new("UICorner", bangBtn)
bangUICorner.CornerRadius = UDim.new(0, 10)

bangBtn.MouseButton1Click:Connect(bangEffect)

-- إخفاء وإظهار الواجهة بـ M
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)
