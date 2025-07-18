-- ELITE V4 PRO - Purple GUI + Pages + ESP + Bang + 18+ Page (with ⚡ Jerk Script) + Minimize + Smooth Animations + Full Toggle System
-- By pyst + customized for FNLOXER style, reworked & optimized

-- Anti-double instance
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

-- Main Frame
local frame = Instance.new("Frame", EliteMenu)
frame.Name = "MainFrame"
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Size = UDim2.new(0.25, 0, 0.6, 0)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 10)

-- Header bar (for dragging & minimize)
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(65, 0, 100)
header.BorderSizePixel = 0

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V4 PRO | FNLOXER"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

-- Minimize button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(0.85, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 24
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
local minCorner = Instance.new("UICorner", minimizeBtn)
minCorner.CornerRadius = UDim.new(0, 8)

-- Close button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(0.93, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 8)

-- Page Buttons container
local pageButtonsFrame = Instance.new("Frame", frame)
pageButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
pageButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
pageButtonsFrame.BackgroundTransparency = 1

local pageButtonsLayout = Instance.new("UIListLayout", pageButtonsFrame)
pageButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
pageButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageButtonsLayout.Padding = UDim.new(0.03, 0)

-- Pages container
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -70)
pagesContainer.Position = UDim2.new(0, 0, 0, 70)
pagesContainer.BackgroundTransparency = 1

-- Create page button helper
local function createPageButton(name)
    local btn = Instance.new("TextButton", pageButtonsFrame)
    btn.Text = name
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(180, 0, 230)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(120, 0, 170)}):Play()
    end)
    return btn
end

-- Table to store pages
local pages = {}

-- Hide all pages function
local function hideAllPages()
    for _, pg in pairs(pages) do
        pg.Visible = false
    end
end

-- Toggle button creator (with animated text changes)
local togglesState = {}
local function createToggleButton(parent, text, posY, key, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0.85, 0, 0.1, 0)
    btn.Position = UDim2.new(0.075, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text.." : OFF"
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    togglesState[key] = false

    btn.MouseButton1Click:Connect(function()
        togglesState[key] = not togglesState[key]
        local newText = text.." : "..(togglesState[key] and "ON" or "OFF")
        -- Animate text color to indicate toggle
        TweenService:Create(btn, TweenInfo.new(0.3), {
            BackgroundColor3 = togglesState[key] and Color3.fromRGB(0, 190, 70) or Color3.fromRGB(120, 0, 170)
        }):Play()
        btn.Text = newText
        callback(togglesState[key])
    end)

    return btn
end

-- === PAGE 1: Main ===
pages["Main"] = Instance.new("Frame", pagesContainer)
pages["Main"].Size = UDim2.new(1,0,1,0)
pages["Main"].BackgroundTransparency = 1
pages["Main"].Visible = true

-- Speed Hack
createToggleButton(pages["Main"], "Speed Hack", 0.05, "speed", function(state)
    local plr = Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = state and 100 or 16
    end
end)

-- Jump Hack
createToggleButton(pages["Main"], "Jump Hack", 0.18, "jump", function(state)
    local plr = Players.LocalPlayer
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.JumpPower = state and 150 or 50
    end
end)

-- Fly Hack
local flyConn, flyBV
createToggleButton(pages["Main"], "Fly", 0.31, "fly", function(state)
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
        if flyConn then flyConn:Disconnect() flyConn=nil end
        if flyBV then flyBV:Destroy() flyBV=nil end
    end
end)

-- Invisible Hack
createToggleButton(pages["Main"], "Invisible", 0.44, "invisible", function(state)
    local plr = Players.LocalPlayer
    if plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = state and 1 or 0
            end
        end
    end
end)

-- Teleport Forward Button (one-click)
local tpBtn = Instance.new("TextButton", pages["Main"])
tpBtn.Size = UDim2.new(0.85, 0, 0.1, 0)
tpBtn.Position = UDim2.new(0.075, 0, 0.57, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 18
tpBtn.Text = "Teleport Forward"
tpBtn.AutoButtonColor = false
local tpCorner = Instance.new("UICorner", tpBtn)
tpCorner.CornerRadius = UDim.new(0, 6)

tpBtn.MouseEnter:Connect(function()
    TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(180, 0, 230)}):Play()
end)
tpBtn.MouseLeave:Connect(function()
    TweenService:Create(tpBtn, TweenInfo.new(0.2), {BackgroundColor3=Color3.fromRGB(120, 0, 170)}):Play()
end)

tpBtn.MouseButton1Click:Connect(function()
    local cam = workspace.CurrentCamera
    local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 500)
    local hit, pos = workspace:FindPartOnRay(ray, Players.LocalPlayer.Character)
    if pos then
        Players.LocalPlayer.Character:MoveTo(pos + Vector3.new(0,5,0))
    end
end)

-- === PAGE 2: ESP ===
pages["ESP"] = Instance.new("Frame", pagesContainer)
pages["ESP"].Size = UDim2.new(1,0,1,0)
pages["ESP"].BackgroundTransparency = 1
pages["ESP"].Visible = false

local espEnabled = false
local espBoxes = {}

local function createEspBox(plr)
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local box = Instance.new("BoxHandleAdornment")
        box.Adornee = plr.Character.HumanoidRootPart
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Size = Vector3.new(4, 6, 1)
        box.Color3 = Color3.fromRGB(255, 0, 0)
        box.Transparency = 0.5
        box.Parent = workspace.CurrentCamera
        return box
    end
    return nil
end

local function toggleEsp(state)
    espEnabled = state
    if state then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                espBoxes[plr.Name] = createEspBox(plr)
            end
        end
    else
        for _, box in pairs(espBoxes) do
            if box then box:Destroy() end
        end
        espBoxes = {}
    end
end

createToggleButton(pages["ESP"], "Enable ESP", 0.05, "esp", toggleEsp)

Players.PlayerAdded:Connect(function(plr)
    if espEnabled and plr ~= Players.LocalPlayer then
        espBoxes[plr.Name] = createEspBox(plr)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if espBoxes[plr.Name] then
        espBoxes[plr.Name]:Destroy()
        espBoxes[plr.Name] = nil
    end
end)

-- === PAGE 3: 18+ Scripts ===
pages["18+"] = Instance.new("Frame", pagesContainer)
pages["18+"].Size = UDim2.new(1,0,1,0)
pages["18+"].BackgroundTransparency = 1
pages["18+"].Visible = false

local eighteenPlusPage = pages["18+"]

-- Detect R6 or R15
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isR6 = character:FindFirstChild("Torso") ~= nil

-- ScrollFrame for buttons
local scroll18 = Instance.new("ScrollingFrame", eighteenPlusPage)
scroll18.Size = UDim2.new(1, -20, 1, -20)
scroll18.Position = UDim2.new(0, 10, 0, 10)
scroll18.BackgroundTransparency = 1
scroll18.CanvasSize = UDim2.new(0, 0, 0, 300)
scroll18.ScrollBarThickness = 8

local layout18 = Instance.new("UIListLayout", scroll18)
layout18.Padding = UDim.new(0, 10)
layout18.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- External scripts list
local bangScripts = {
    {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
    {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
    {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
    {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
    {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
}

local function loadExternalScript(url)
    local success, err = pcall(function()
        local scriptContent = game:HttpGet(url)
        loadstring(scriptContent)()
    end)
    if not success then
        warn("[EliteV4] Failed to load script:", err)
    end
end

for i, scriptData in ipairs(bangScripts) do
    local btn = Instance.new("TextButton", scroll18)
    btn.Size = UDim2.new(0.85, 0, 0, 45)
    btn.Position = UDim2.new(0.075, 0, 0.05 + (i - 1) * 0.12, 0)
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = scriptData.name
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3=Color3.fromRGB(190, 0, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3=Color3.fromRGB(150, 0, 220)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        local url = isR6 and scriptData.r6 or scriptData.r15
        loadExternalScript(url)
    end)
end

-- == Minimize functionality ==
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        -- Animate minimize: shrink the frame vertically to just header height
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 30)}):Play()
        -- Hide pages container & buttons container
        TweenService:Create(pageButtonsFrame, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(pagesContainer, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        for _, btn in pairs(pageButtonsFrame:GetChildren()) do
            if btn:IsA("TextButton") then btn.Visible = false end
        end
        for _, pg in pairs(pages) do
            pg.Visible = false
        end
    else
        -- Restore full size and show pages/buttons
        TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size=UDim2.new(0.25, 0, 0.6, 0)}):Play()
        wait(0.4)
        for _, btn in pairs(pageButtonsFrame:GetChildren()) do
            if btn:IsA("TextButton") then btn.Visible = true end
        end
        pages["Main"].Visible = true -- Show default page
        TweenService:Create(pageButtonsFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        TweenService:Create(pagesContainer, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    end
end)

-- == Close button functionality ==
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

-- == Page switching logic ==
local pageButtons = {}

for _, btn in pairs(pageButtonsFrame:GetChildren()) do
    if btn:IsA("TextButton") then
        pageButtons[btn.Text] = btn
        btn.MouseButton1Click:Connect(function()
            hideAllPages()
            if pages[btn.Text] then
                pages[btn.Text].Visible = true
            end
        end)
    end
end

-- Activate default page at start
hideAllPages()
pages["Main"].Visible = true

-- Final notes:
-- This script is modular, clean, and uses tweening for smooth UX.
-- No chat spam anymore.
-- Added the requested ⚡ Jerk external script to the 18+ page.
-- Fully draggable and min/max capable.

