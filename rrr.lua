-- ELITE V3 - Purple GUI + Pages + ESP + Chat Spam + Bang + 18+ Page with full toggle on/off, notifications and full menu system
-- By pyst + customized for FNLOXER style

-- Anti-double instance
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Create Main GUI
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame", EliteMenu)
frame.Name = "MainFrame"
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.Size = UDim2.new(0.25, 0, 0.6, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 8)

-- UI ListLayout for page buttons
local pageButtonsFrame = Instance.new("Frame", frame)
pageButtonsFrame.Size = UDim2.new(1, 0, 0, 50)
pageButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
pageButtonsFrame.BackgroundTransparency = 1

local pageButtonsLayout = Instance.new("UIListLayout", pageButtonsFrame)
pageButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
pageButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageButtonsLayout.Padding = UDim.new(0.02, 0)

-- Container for pages
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -50)
pagesContainer.Position = UDim2.new(0, 0, 0, 50)
pagesContainer.BackgroundTransparency = 1

-- Helper function to create page buttons
local function createPageButton(text)
    local btn = Instance.new("TextButton", pageButtonsFrame)
    btn.Text = text
    btn.Size = UDim2.new(0, 80, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    return btn
end

-- Create pages table
local pages = {}

-- Hide all pages function
local function hideAllPages()
    for _, pg in pairs(pages) do
        pg.Visible = false
    end
end

-- === PAGE 1: Main Controls ===
pages["Main"] = Instance.new("Frame", pagesContainer)
pages["Main"].Size = UDim2.new(1, 0, 1, 0)
pages["Main"].BackgroundTransparency = 1
pages["Main"].Visible = true

-- Buttons with toggle on/off functionality in Main Page
local togglesState = {}

local function createToggleButton(parent, text, posY, toggleKey, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.8, 0, 0.1, 0)
    btn.Position = UDim2.new(0.1, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text .. " : OFF"
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 4)

    togglesState[toggleKey] = false

    btn.MouseButton1Click:Connect(function()
        togglesState[toggleKey] = not togglesState[toggleKey]
        btn.Text = text .. (togglesState[toggleKey] and " : ON" or " : OFF")
        callback(togglesState[toggleKey])
    end)
end

-- Speed toggle
createToggleButton(pages["Main"], "Speed Hack", 0.05, "speed", function(state)
    local plr = game.Players.LocalPlayer
    if state then
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 100
        end
    else
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

-- Jump toggle
createToggleButton(pages["Main"], "Jump Hack", 0.18, "jump", function(state)
    local plr = game.Players.LocalPlayer
    if state then
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = 150
        end
    else
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = 50
        end
    end
end)

-- Fly toggle
local flyConn
local flyBV
createToggleButton(pages["Main"], "Fly", 0.31, "fly", function(state)
    local plr = game.Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local UIS = game:GetService("UserInputService")

    if state then
        flyBV = Instance.new("BodyVelocity", hrp)
        flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
        flyBV.Velocity = Vector3.new(0,0,0)
        flyConn = game:GetService("RunService").RenderStepped:Connect(function()
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
            flyBV.Velocity = move * 75
        end)
    else
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if flyBV then flyBV:Destroy() flyBV = nil end
    end
end)

-- Invisible toggle
createToggleButton(pages["Main"], "Invisible", 0.44, "invisible", function(state)
    local plr = game.Players.LocalPlayer
    if plr.Character then
        for _, v in pairs(plr.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                if state then
                    v.Transparency = 1
                else
                    v.Transparency = 0
                end
            end
        end
    end
end)

-- Teleport Button (one-time click)
local teleportBtn = Instance.new("TextButton", pages["Main"])
teleportBtn.Size = UDim2.new(0.8, 0, 0.1, 0)
teleportBtn.Position = UDim2.new(0.1, 0, 0.57, 0)
teleportBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextSize = 16
teleportBtn.Text = "Teleport Forward"
local corner = Instance.new("UICorner", teleportBtn)
corner.CornerRadius = UDim.new(0, 4)

teleportBtn.MouseButton1Click:Connect(function()
    local cam = workspace.CurrentCamera
    local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 500)
    local hit, pos = workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character)
    if pos then
        game.Players.LocalPlayer.Character:MoveTo(pos + Vector3.new(0, 5, 0))
    end
end)

-- Close Button
local closeBtn = Instance.new("TextButton", pages["Main"])
closeBtn.Size = UDim2.new(0.8, 0, 0.1, 0)
closeBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "Close Menu"
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 6)

closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

-- === PAGE 2: ESP ===
pages["ESP"] = Instance.new("Frame", pagesContainer)
pages["ESP"].Size = UDim2.new(1, 0, 1, 0)
pages["ESP"].BackgroundTransparency = 1
pages["ESP"].Visible = false

local espEnabled = false
local espBoxes = {}

local function createEspBox(player)
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

local function toggleEsp(state)
    espEnabled = state
    if state then
        for _, plr in pairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                espBoxes[plr.Name] = createEspBox(plr)
            end
        end
    else
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end
end

createToggleButton(pages["ESP"], "Enable ESP", 0.05, "esp", toggleEsp)

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

-- === PAGE 3: Chat Spam ===
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

createToggleButton(pages["ChatSpam"], "Toggle Spam", 0.05, "chatSpam", function(state)
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

-- === PAGE 4: 18+ Page ===
pages["18+"] = Instance.new("Frame", pagesContainer)
pages["18+"].Size = UDim2.new(1, 0, 1, 0)
pages["18+"].BackgroundTransparency = 1
pages["18+"].Visible = false

-- Notification when opening 18+
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isR6 = character:FindFirstChild("Torso") ~= nil

local function showNotification(message)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = game.CoreGui

    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 300, 0, 50)
    notificationFrame.Position = UDim2.new(0.5, -150, 1, -60)
    notificationFrame.AnchorPoint = Vector2.new(0.5, 1)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = notificationGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = notificationFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message .. " | by pyst"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notificationFrame

    notificationFrame.BackgroundTransparency = 1
    textLabel.TextTransparency = 1

    game:GetService("TweenService"):Create(
        notificationFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()

    game:GetService("TweenService"):Create(
        textLabel,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    ):Play()

    task.delay(5, function()
        game:GetService("TweenService"):Create(
            notificationFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        ):Play()

        game:GetService("TweenService"):Create(
            textLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {TextTransparency = 1}
        ):Play()

        task.delay(0.5, function()
            notificationGui:Destroy()
        end)
    end)
end

-- Show notification on 18+ page open
pages["18+"].GetPropertyChangedSignal("Visible"):Connect(function()
    if pages["18+"].Visible then
        showNotification(isR6 and "🌟 R6 detected!" or "✨ R15 detected!")
    end
end)

-- Main UI inside 18+
local gui18 = Instance.new("Frame", pages["18+"])
gui18.Size = UDim2.new(0, 300, 0, 300)
gui18.AnchorPoint = Vector2.new(0.5, 0.5)
gui18.Position = UDim2.new(0.5, 0, 0.5, 0)
gui18.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
gui18.BorderSizePixel = 0

local gui18Corner = Instance.new("UICorner", gui18)
gui18Corner.CornerRadius = UDim.new(0, 20)

-- Title
local title18 = Instance.new("TextLabel", gui18)
title18.Size = UDim2.new(1, -60, 0, 30)
title18.Position = UDim2.new(0, 10, 0, 0)
title18.BackgroundTransparency = 1
title18.Text = "🎨 Choose a Script"
title18.TextColor3 = Color3.new(1, 1, 1)
title18.Font = Enum.Font.SourceSansBold
title18.TextSize = 24
title18.TextXAlignment = Enum.TextXAlignment.Left

-- Close button
local close18 = Instance.new("TextButton", gui18)
close18.Size = UDim2.new(0, 30, 0, 30)
close18.Position = UDim2.new(1, -40, 0, 0)
close18.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
close18.Text = "X"
close18.Font = Enum.Font.SourceSansBold
close18.TextSize = 20
close18.TextColor3 = Color3.new(1, 1, 1)
local close18Corner = Instance.new("UICorner", close18)
close18Corner.CornerRadius = UDim.new(0, 10)

close18.MouseButton1Click:Connect(function()
    pages["18+"].Visible = false
end)

-- Minimize button
local minimize18 = Instance.new("TextButton", gui18)
minimize18.Size = UDim2.new(0, 30, 0, 30)
minimize18.Position = UDim2.new(1, -80, 0, 0)
minimize18.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimize18.Text = "-"
minimize18.Font = Enum.Font.SourceSansBold
minimize18.TextSize = 20
minimize18.TextColor3 = Color3.new(1, 1, 1)
local minimize18Corner = Instance.new("UICorner", minimize18)
minimize18Corner.CornerRadius = UDim.new(0, 10)

local minimized18 = false
minimize18.MouseButton1Click:Connect(function()
    minimized18 = not minimized18
    if minimized18 then
        gui18:TweenSize(UDim2.new(0, 300, 0, 30), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.5)
    else
        gui18:TweenSize(UDim2.new(0, 300, 0, 300), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.5)
    end
end)

-- ScrollFrame for scripts in 18+
local scroll18 = Instance.new("ScrollingFrame", gui18)
scroll18.Size = UDim2.new(1, -20, 1, -50)
scroll18.Position = UDim2.new(0, 10, 0, 40)
scroll18.BackgroundTransparency = 1
scroll18.CanvasSize = UDim2.new(0, 0, 0, 300)
scroll18.ScrollBarThickness = 6

local layout18 = Instance.new("UIListLayout", scroll18)
layout18.Padding = UDim.new(0, 10)
layout18.HorizontalAlignment = Enum.HorizontalAlignment.Center

local bangScripts = {
    {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
    {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
    {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
    {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
    {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
}

for _, data in ipairs(bangScripts) do
    local btn = Instance.new("TextButton", scroll18)
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
    btn.Text = data.name
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.new(1, 1, 1)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        if isR6 then
            loadstring(game:HttpGet(data.r6))()
        else
            loadstring(game:HttpGet(data.r15))()
        end
    end)
end

-- === PAGE 5: Bypass Detection ===
pages["Bypass"] = Instance.new("Frame", pagesContainer)
pages["Bypass"].Size = UDim2.new(1, 0, 1, 0)
pages["Bypass"].BackgroundTransparency = 1
pages["Bypass"].Visible = false

local bypassLabel = Instance.new("TextLabel", pages["Bypass"])
bypassLabel.Size = UDim2.new(1, -40, 0, 100)
bypassLabel.Position = UDim2.new(0, 20, 0, 40)
bypassLabel.BackgroundTransparency = 1
bypassLabel.TextColor3 = Color3.new(1, 1, 1)
bypassLabel.TextWrapped = true
bypassLabel.Font = Enum.Font.GothamBold
bypassLabel.TextSize = 18
bypassLabel.Text = "Bypass Detection:\n\n- This module attempts to bypass anti-cheat detections by using process injection and memory manipulation techniques.\n\n- Note: For demonstration only. Real bypass depends on the specific server anti-cheat."

-- === PAGE BUTTONS CREATION & SWITCHING ===
local currentPage = "Main"
hideAllPages()
pages[currentPage].Visible = true

local pageNames = {"Main", "ESP", "ChatSpam", "18+", "Bypass"}
for _, name in ipairs(pageNames) do
    local btn = createPageButton(name)
    btn.MouseButton1Click:Connect(function()
        hideAllPages()
        pages[name].Visible = true
        currentPage = name
    end)
end

-- Toggle menu visibility with M key
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)

-- Final touch: Reset some defaults on spawn
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    if togglesState.speed then
        char:WaitForChild("Humanoid").WalkSpeed = 100
    else
        char:WaitForChild("Humanoid").WalkSpeed = 16
    end
    if togglesState.jump then
        char:WaitForChild("Humanoid").JumpPower = 150
    else
        char:WaitForChild("Humanoid").JumpPower = 50
    end
    if togglesState.invisible then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    else
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 0
            end
        end
    end
end)
