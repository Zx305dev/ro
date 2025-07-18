-- ELITE V5 PRO - Purple Themed GUI with Pages, Smooth Animations, and External Scripts Loader
-- By pyst + customized for FNLOXER style
-- Designed for professional usage, clean, smooth, and scalable

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

-- Utility: Tween Color with Promise-like approach
local function tweenColor(instance, property, goalColor, duration)
    TweenService:Create(instance, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = goalColor}):Play()
end

-- === MAIN FRAME ===
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.3, 0, 0.65, 0)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = EliteMenu
addUICorner(frame, 12)

-- === HEADER BAR ===
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(70, 0, 110)
header.BorderSizePixel = 0
addUICorner(header, 12)

local title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | FNLOXER"
title.Size = UDim2.new(0.7, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

-- Close Button
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(0.93, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 22
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 10)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(0.85, 0, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 195, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 28
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 10)

-- === PAGE BUTTONS BAR ===
local pageBar = Instance.new("Frame", frame)
pageBar.Size = UDim2.new(1, 0, 0, 45)
pageBar.Position = UDim2.new(0, 0, 0, 35)
pageBar.BackgroundTransparency = 1

local pageLayout = Instance.new("UIListLayout", pageBar)
pageLayout.FillDirection = Enum.FillDirection.Horizontal
pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
pageLayout.VerticalAlignment = Enum.VerticalAlignment.Center
pageLayout.Padding = UDim.new(0.03, 0)

-- === PAGES CONTAINER ===
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Size = UDim2.new(1, 0, 1, -80)
pagesContainer.Position = UDim2.new(0, 0, 0, 80)
pagesContainer.BackgroundTransparency = 1

-- Helper: Create Page Button
local function createPageButton(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.AutoButtonColor = false
    addUICorner(btn, 10)

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
    btn.Text = text .. " : OFF"
    btn.AutoButtonColor = false
    addUICorner(btn, 12)

    togglesState[key] = false

    btn.MouseButton1Click:Connect(function()
        togglesState[key] = not togglesState[key]
        local status = togglesState[key] and "ON" or "OFF"
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

local pageNames = {"Main", "ESP", "18+"}

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
pages["Main"].Visible = true

-- === MAIN PAGE CONTENT ===
do
    local page = pages["Main"]

    -- Speed Hack Toggle
    createToggleButton(page, "Speed Hack", 0.05, "speed", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = state and 100 or 16
        end
    end)

    -- Jump Hack Toggle
    createToggleButton(page, "Jump Hack", 0.15, "jump", function(state)
        local plr = Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = state and 150 or 50
        end
    end)

    -- Fly Toggle (complex)
    local flyBV, flyConn
    createToggleButton(page, "Fly", 0.25, "fly", function(state)
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
    createToggleButton(page, "Invisible", 0.35, "invisible", function(state)
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
    tpBtn.Position = UDim2.new(0.075, 0, 0.48, 0)
    tpBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 200)
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 20
    tpBtn.Text = "Teleport Forward"
    tpBtn.AutoButtonColor = false
    addUICorner(tpBtn, 12)

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

    -- Scroll frame for lots of toggles or options
    local scroll = Instance.new("ScrollingFrame", page)
    scroll.Size = UDim2.new(1, -20, 1, -20)
    scroll.Position = UDim2.new(0, 10, 0, 10)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 8
    scroll.CanvasSize = UDim2.new(0, 0, 0, 300)

    local layout = Instance.new("UIListLayout", scroll)
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- ESP State and boxes
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

    -- Toggle Button for ESP
    local espToggle = createToggleButton(scroll, "Enable ESP", 0, "esp", toggleEsp)
    espToggle.Parent = scroll

    -- Auto add/remove ESP when players join/leave
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
end

-- === 18+ PAGE CONTENT ===
do
    local page = pages["18+"]

    -- Scrolling frame to hold buttons for external scripts
    local scroll18 = Instance.new("ScrollingFrame", page)
    scroll18.Size = UDim2.new(1, -20, 1, -20)
    scroll18.Position = UDim2.new(0, 10, 0, 10)
    scroll18.BackgroundTransparency = 1
    scroll18.ScrollBarThickness = 8
    scroll18.CanvasSize = UDim2.new(0, 0, 0, 300)

    local layout18 = Instance.new("UIListLayout", scroll18)
    layout18.Padding = UDim.new(0, 10)
    layout18.HorizontalAlignment = Enum.HorizontalAlignment.Center

    -- List of External Scripts (Added your ⚡ Jerk scripts)
    local bangScripts = {
        {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
        {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
        {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
        {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
        {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
    }

    -- Determine rig type (R6 or R15)
    local player = Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local isR6 = character:FindFirstChild("Torso") ~= nil

    -- Load external script helper
    local function loadExternalScript(url)
        local success, err = pcall(function()
            local scriptContent = game:HttpGet(url)
            loadstring(scriptContent)()
        end)
        if not success then
            warn("Failed to load script from URL:", url, err)
        end
    end

    -- Create buttons for each external bang script
    for i, bang in ipairs(bangScripts) do
        local btn = Instance.new("TextButton", scroll18)
        btn.Size = UDim2.new(0.85, 0, 0, 50)
        btn.BackgroundColor3 = Color3.fromRGB(180, 0, 255)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.Text = bang.name
        btn.AutoButtonColor = false
        addUICorner(btn, 14)
        btn.Position = UDim2.new(0.075, 0, 0, (i-1)*60)

        btn.MouseEnter:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(240, 100, 255), 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tweenColor(btn, "BackgroundColor3", Color3.fromRGB(180, 0, 255), 0.2)
        end)

        btn.MouseButton1Click:Connect(function()
            local url = isR6 and bang.r6 or bang.r15
            loadExternalScript(url)
        end)
    end
    scroll18.CanvasSize = UDim2.new(0, 0, 0, #bangScripts * 60)
end

-- === MINIMIZE BUTTON FUNCTIONALITY ===
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then
        -- Minimize: Shrink frame and hide page buttons & pages with fade
        local tween1 = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 150, 0, 45)})
        tween1:Play()

        -- Fade out pages and page buttons
        for _, btn in pairs(pageBar:GetChildren()) do
            if btn:IsA("TextButton") then
                tweenColor(btn, "TextTransparency", 1, 0.3)
                tweenColor(btn, "BackgroundTransparency", 1, 0.3)
            end
        end

        for _, page in pairs(pagesContainer:GetChildren()) do
            if page:IsA("Frame") and page.Visible then
                local tweenPage = TweenService:Create(page, TweenInfo.new(0.3), {BackgroundTransparency = 1})
                tweenPage:Play()
                tweenPage.Completed:Wait()
                page.Visible = false
            end
        end

        minimized = true
    else
        -- Restore full size
        local tween2 = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0.3, 0, 0.65, 0)})
        tween2:Play()

        -- Restore page buttons visibility
        for _, btn in pairs(pageBar:GetChildren()) do
            if btn:IsA("TextButton") then
                tweenColor(btn, "TextTransparency", 0, 0.3)
                tweenColor(btn, "BackgroundTransparency", 0, 0.3)
            end
        end

        -- Show current page again (default to Main)
        pages["Main"].Visible = true
        pages["Main"].BackgroundTransparency = 0

        minimized = false
    end
end)

-- === CLOSE BUTTON FUNCTIONALITY ===
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu:Destroy()
end)

-- === DRAGGING LOGIC ===
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
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

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- === FINAL SETUP NOTES ===
print("Elite V5 PRO GUI loaded. Ready to rock, FNLOXER!")

-- End of scriptd
