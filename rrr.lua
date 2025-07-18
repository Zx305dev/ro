-- ELITE V4 - Ultimate Roblox Hack GUI by pyst + FNLOXER Style
-- Features: Multi-page GUI, Speed, Jump, Fly, Invisible, Teleport, ESP, Chat Spam, 18+ Scripts, Bypass Info
-- Robust, modular, and efficient for top performance on all executors.

-- Anti-double instance
pcall(function()
    local oldGui = game.CoreGui:FindFirstChild("EliteMenu")
    if oldGui then oldGui:Destroy() end
end)

local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Size = UDim2.new(0.28, 0, 0.65, 0)
frame.Position = UDim2.new(0.04, 0, 0.17, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = EliteMenu

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 8)

-- Page Buttons Container
local pageButtonsFrame = Instance.new("Frame", frame)
pageButtonsFrame.Size = UDim2.new(1, 0, 0, 48)
pageButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
pageButtonsFrame.BackgroundTransparency = 1

local pageButtonsLayout = Instance.new("UIListLayout", pageButtonsFrame)
pageButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
pageButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageButtonsLayout.Padding = UDim.new(0.02, 0)

-- Pages Container
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -48)
pagesContainer.Position = UDim2.new(0, 0, 0, 48)
pagesContainer.BackgroundTransparency = 1

-- Toggles state storage
local togglesState = {}

-- Clean function to create toggle buttons
local function createToggleButton(parent, text, posY, key, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0.11, 0)
    btn.Position = UDim2.new(0.075, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.Text = text .. " : OFF"
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 5)

    togglesState[key] = false

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(170, 0, 220)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = togglesState[key] and Color3.fromRGB(210, 0, 255) or Color3.fromRGB(120, 0, 170)
    end)

    btn.MouseButton1Click:Connect(function()
        togglesState[key] = not togglesState[key]
        btn.Text = text .. (togglesState[key] and " : ON" or " : OFF")
        btn.BackgroundColor3 = togglesState[key] and Color3.fromRGB(210, 0, 255) or Color3.fromRGB(120, 0, 170)
        callback(togglesState[key])
    end)

    btn.Parent = parent
    return btn
end

-- Page creation helper
local pages = {}
local currentPage = nil

local function createPage(name)
    local pg = Instance.new("Frame")
    pg.Size = UDim2.new(1, 0, 1, 0)
    pg.BackgroundTransparency = 1
    pg.Visible = false
    pg.Name = name
    pg.Parent = pagesContainer
    pages[name] = pg
    return pg
end

local function hideAllPages()
    for _, pg in pairs(pages) do
        pg.Visible = false
    end
end

local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 85, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = false
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(170, 0, 220)
    end)
    btn.MouseLeave:Connect(function()
        if currentPage ~= name then
            btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if currentPage == name then return end
        hideAllPages()
        pages[name].Visible = true
        currentPage = name

        -- Update buttons color
        for _, sibling in pairs(pageButtonsFrame:GetChildren()) do
            if sibling:IsA("TextButton") then
                sibling.BackgroundColor3 = (sibling == btn) and Color3.fromRGB(170, 0, 220) or Color3.fromRGB(120, 0, 170)
            end
        end
    end)

    btn.Parent = pageButtonsFrame
    return btn
end

-- Create pages
local mainPage = createPage("Main")
local espPage = createPage("ESP")
local chatSpamPage = createPage("ChatSpam")
local eighteenPlusPage = createPage("18+")
local bypassPage = createPage("Bypass")

-- Create page buttons
local pageButtons = {
    createPageButton("Main"),
    createPageButton("ESP"),
    createPageButton("ChatSpam"),
    createPageButton("18+"),
    createPageButton("Bypass")
}

-- Set default page
pageButtons[1].BackgroundColor3 = Color3.fromRGB(170, 0, 220)
pages["Main"].Visible = true
currentPage = "Main"

-- ========== Main Page Toggles ==========

local plr = game.Players.LocalPlayer

-- Speed Hack Toggle
createToggleButton(mainPage, "Speed Hack", 0.05, "speed", function(state)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.WalkSpeed = state and 100 or 16
    end
end)

-- Jump Hack Toggle
createToggleButton(mainPage, "Jump Hack", 0.17, "jump", function(state)
    if plr.Character and plr.Character:FindFirstChild("Humanoid") then
        plr.Character.Humanoid.JumpPower = state and 150 or 50
    end
end)

-- Fly Toggle Implementation
local flyConnection
local flyBodyVelocity
local UserInputService = game:GetService("UserInputService")
createToggleButton(mainPage, "Fly", 0.29, "fly", function(state)
    if not plr.Character then return end
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if state then
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
        flyBodyVelocity.Parent = hrp

        flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            local moveVector = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector - workspace.CurrentCamera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector - workspace.CurrentCamera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + workspace.CurrentCamera.CFrame.RightVector end
            flyBodyVelocity.Velocity = moveVector.Unit * 75
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    end
end)

-- Invisible Toggle
createToggleButton(mainPage, "Invisible", 0.41, "invisible", function(state)
    if not plr.Character then return end
    for _, part in pairs(plr.Character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        end
    end
end)

-- Teleport Forward Button (one-click)
local tpBtn = Instance.new("TextButton", mainPage)
tpBtn.Size = UDim2.new(0.85, 0, 0.11, 0)
tpBtn.Position = UDim2.new(0.075, 0, 0.53, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 16
tpBtn.Text = "Teleport Forward"
local tpCorner = Instance.new("UICorner", tpBtn)
tpCorner.CornerRadius = UDim.new(0, 5)

tpBtn.MouseEnter:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 220) end)
tpBtn.MouseLeave:Connect(function() tpBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 170) end)

tpBtn.MouseButton1Click:Connect(function()
    local cam = workspace.CurrentCamera
    local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 500)
    local hit, pos = workspace:FindPartOnRay(ray, plr.Character)
    if pos then
        plr.Character:MoveTo(pos + Vector3.new(0, 5, 0))
    end
end)

-- Close Menu Button
local closeBtn = Instance.new("TextButton", mainPage)
closeBtn.Size = UDim2.new(0.85, 0, 0.11, 0)
closeBtn.Position = UDim2.new(0.075, 0, 0.67, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.Text = "Close Menu"
local closeCorner = Instance.new("UICorner", closeBtn)
closeCorner.CornerRadius = UDim.new(0, 5)

closeBtn.MouseEnter:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80) end)
closeBtn.MouseLeave:Connect(function() closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50) end)

closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

-- Respawn protection & re-apply toggles
plr.CharacterAdded:Connect(function(char)
    wait(1)
    local humanoid = char:WaitForChild("Humanoid")
    if togglesState.speed then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = 16
    end
    if togglesState.jump then
        humanoid.JumpPower = 150
    else
        humanoid.JumpPower = 50
    end
    if togglesState.invisible then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
end)

-- ========== ESP Page ==========

local espEnabled = false
local espBoxes = {}

local function createEspBox(plr)
    if not plr.Character then return nil end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = hrp
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
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= plr then
                espBoxes[player.Name] = createEspBox(player)
            end
        end
    else
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end
end

createToggleButton(espPage, "Enable ESP", 0.05, "esp", toggleEsp)

game.Players.PlayerAdded:Connect(function(player)
    if espEnabled and player ~= plr then
        espBoxes[player.Name] = createEspBox(player)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    if espBoxes[player.Name] then
        espBoxes[player.Name]:Destroy()
        espBoxes[player.Name] = nil
    end
end)

-- ========== Chat Spam Page ==========

local chatSpamActive = false
local spamMessage = "Bang Bang 😈👹🔥"
local spamInterval = 2
local chatSpamThread = nil

local function chatSpam()
    while chatSpamActive do
        local chatEvent = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatEvent then
            chatEvent.SayMessageRequest:FireServer(spamMessage, "All")
        end
        task.wait(spamInterval)
    end
end

createToggleButton(chatSpamPage, "Toggle Spam", 0.05, "chatSpam", function(state)
    chatSpamActive = state
    if state then
        chatSpamThread = task.spawn(chatSpam)
    end
end)

local spamInput = Instance.new("TextBox", chatSpamPage)
spamInput.Size = UDim2.new(0.85, 0, 0.13, 0)
spamInput.Position = UDim2.new(0.075, 0, 0.2, 0)
spamInput.PlaceholderText = "Type spam message here"
spamInput.Text = spamMessage
spamInput.ClearTextOnFocus = false
spamInput.TextWrapped = true
spamInput.Font = Enum.Font.Gotham
spamInput.TextSize = 14

spamInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and spamInput.Text ~= "" then
        spamMessage = spamInput.Text
    end
end)

-- ========== 18+ Page (Loads External Scripts) ==========

local isR6 = plr.Character and plr.Character:FindFirstChild("Torso") ~= nil

local bangScripts = {
    {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
    {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
    {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
    {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/9GSjMRTN", r15 = "https://pastebin.com/raw/eZ4Z6Jhv"}
}

local function loadExternalScript(url)
    local success, err = pcall(function()
        local HttpService = game:GetService("HttpService")
        local scriptContent = game:HttpGet(url)
        loadstring(scriptContent)()
    end)
    if not success then
        warn("Failed to load script:", err)
    end
end

for i, scriptData in ipairs(bangScripts) do
    local scrBtn = Instance.new("TextButton", eighteenPlusPage)
    scrBtn.Size = UDim2.new(0.85, 0, 0.1, 0)
    scrBtn.Position = UDim2.new(0.075, 0, 0.05 + (i - 1) * 0.12, 0)
    scrBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
    scrBtn.TextColor3 = Color3.new(1, 1, 1)
    scrBtn.Font = Enum.Font.GothamBold
    scrBtn.TextSize = 16
    scrBtn.Text = scriptData.name
    local corner = Instance.new("UICorner", scrBtn)
    corner.CornerRadius = UDim.new(0, 6)

    scrBtn.MouseEnter:Connect(function()
        scrBtn.BackgroundColor3 = Color3.fromRGB(190, 0, 255)
    end)
    scrBtn.MouseLeave:Connect(function()
        scrBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
    end)

    scrBtn.MouseButton1Click:Connect(function()
        local url = isR6 and scriptData.r6 or scriptData.r15
        loadExternalScript(url)
    end)
end

-- ========== Bypass Page ==========

local bypassLabel = Instance.new("TextLabel", bypassPage)
bypassLabel.Size = UDim2.new(0.95, 0, 0.8, 0)
bypassLabel.Position = UDim2.new(0.025, 0, 0.05, 0)
bypassLabel.BackgroundTransparency = 1
bypassLabel.TextColor3 = Color3.new(1, 1, 1)
bypassLabel.Font = Enum.Font.Gotham
bypassLabel.TextSize = 16
bypassLabel.TextWrapped = true
bypassLabel.Text = [[
🔥 Bypass Info 🔥

- This hack uses local manipulation only; no server files are modified.
- ESP works by adornments attached client-side; stealth mode to avoid detection.
- Fly uses BodyVelocity for smooth movement, can be toggled off instantly.
- Speed and Jump Hacks adjust Humanoid properties, careful in certain games with server checks.
- Teleport is a quick position move forward, safe distance, limited use.
- Chat Spam sends messages via DefaultChat events; avoid spamming excessively.
- External 18+ scripts load from trusted Pastebin raw URLs; use at your own risk.
- Menu is draggable and toggle buttons provide clear ON/OFF state.

Stay smart, stay undetected. Happy hacking! 😈👹🔥
]]

-- ========== End of Script ==========

print("[ELITE V4] Hack menu loaded successfully.")

