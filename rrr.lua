-- Elite V5 PRO 2025 - Full Complete Script | Bang from behind + Noclip + Speed control + Target selector + ESP + Notifications + Hotkeys + Anti-AFK + Infinite Jump + God Mode Toggle

pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- // Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- // Variables
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui
local frame, header, closeBtn, title

local isBangActive = false
local noclipEnabled = false
local godModeEnabled = false
local infiniteJumpEnabled = false
local espEnabled = false
local targetPlayer = nil
local currentSpeed = 0.5

local jumpConnection = nil

-- // Helper functions

local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createNotification(text)
    local notifGui = Instance.new("ScreenGui")
    notifGui.Name = "NotifGui"
    notifGui.Parent = game.CoreGui

    local frameNotif = Instance.new("Frame", notifGui)
    frameNotif.Size = UDim2.new(0, 300, 0, 50)
    frameNotif.Position = UDim2.new(0.5, -150, 0.9, 0)
    frameNotif.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
    frameNotif.BorderSizePixel = 0
    addUICorner(frameNotif, 20)

    local labelNotif = Instance.new("TextLabel", frameNotif)
    labelNotif.Size = UDim2.new(1, -20, 1, 0)
    labelNotif.Position = UDim2.new(0, 10, 0, 0)
    labelNotif.BackgroundTransparency = 1
    labelNotif.Text = text
    labelNotif.TextColor3 = Color3.new(1, 1, 1)
    labelNotif.Font = Enum.Font.GothamBold
    labelNotif.TextSize = 20
    labelNotif.TextXAlignment = Enum.TextXAlignment.Left

    TweenService:Create(frameNotif, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(labelNotif, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    task.delay(4, function()
        TweenService:Create(frameNotif, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(labelNotif, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        task.wait(0.5)
        notifGui:Destroy()
    end)
end

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

local function findPlayerByPrefix(prefix)
    prefix = prefix:lower()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Name:sub(1, #prefix):lower() == prefix then
            return plr
        end
    end
    return nil
end

-- // GUI Setup

frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 560, 0, 650)
frame.Position = UDim2.new(0.5, -280, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = false
frame.Parent = EliteMenu
addUICorner(frame, 20)
makeDraggable(frame)

header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(100, 0, 180)
header.BorderSizePixel = 0
addUICorner(header, 20)

title = Instance.new("TextLabel", header)
title.Text = "Elite V5 PRO | Full Options"
title.Size = UDim2.new(0.75, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Position = UDim2.new(0.03, 0, 0, 0)

closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 50, 1, 0)
closeBtn.Position = UDim2.new(0.92, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 36
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 20)
closeBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
end)

-- // Target Input
local targetInputLabel = Instance.new("TextLabel", frame)
targetInputLabel.Size = UDim2.new(0, 300, 0, 30)
targetInputLabel.Position = UDim2.new(0.05, 0, 0.15, 0)
targetInputLabel.BackgroundTransparency = 1
targetInputLabel.Text = "أكتب أول حرفين من اسم الهدف:"
targetInputLabel.TextColor3 = Color3.new(1, 1, 1)
targetInputLabel.Font = Enum.Font.GothamBold
targetInputLabel.TextSize = 20
targetInputLabel.TextXAlignment = Enum.TextXAlignment.Left

local targetInput = Instance.new("TextBox", frame)
targetInput.Size = UDim2.new(0, 300, 0, 40)
targetInput.Position = UDim2.new(0.05, 0, 0.20, 0)
targetInput.PlaceholderText = "مثال: Al"
targetInput.Font = Enum.Font.Gotham
targetInput.TextSize = 24
targetInput.TextColor3 = Color3.new(0, 0, 0)
addUICorner(targetInput, 16)

-- // Toggle Bang Button
local toggleBangBtn = Instance.new("TextButton", frame)
toggleBangBtn.Size = UDim2.new(0, 240, 0, 50)
toggleBangBtn.Position = UDim2.new(0.05, 0, 0.30, 0)
toggleBangBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 180)
toggleBangBtn.Font = Enum.Font.GothamBold
toggleBangBtn.TextSize = 26
toggleBangBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBangBtn.Text = "تفعيل Bang من الخلف"
toggleBangBtn.AutoButtonColor = false
addUICorner(toggleBangBtn, 24)

-- // Speed Control Slider
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(0, 240, 0, 30)
speedLabel.Position = UDim2.new(0.05, 0, 0.40, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 20
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.Text = "سرعة الحركة: 0.5"

local speedSlider = Instance.new("Frame", frame)
speedSlider.Size = UDim2.new(0, 240, 0, 40)
speedSlider.Position = UDim2.new(0.05, 0, 0.45, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(110, 0, 170)
addUICorner(speedSlider, 20)

local fillBar = Instance.new("Frame", speedSlider)
fillBar.Size = UDim2.new(0.16, 0, 1, 0)
fillBar.BackgroundColor3 = Color3.fromRGB(230, 50, 230)
addUICorner(fillBar, 20)

-- // ESP Toggle
local toggleESPBtn = Instance.new("TextButton", frame)
toggleESPBtn.Size = UDim2.new(0, 240, 0, 50)
toggleESPBtn.Position = UDim2.new(0.05, 0, 0.56, 0)
toggleESPBtn.BackgroundColor3 = Color3.fromRGB(70, 150, 255)
toggleESPBtn.Font = Enum.Font.GothamBold
toggleESPBtn.TextSize = 26
toggleESPBtn.TextColor3 = Color3.new(1, 1, 1)
toggleESPBtn.Text = "تفعيل ESP"
toggleESPBtn.AutoButtonColor = false
addUICorner(toggleESPBtn, 24)

-- // Noclip Toggle
local toggleNoclipBtn = Instance.new("TextButton", frame)
toggleNoclipBtn.Size = UDim2.new(0, 240, 0, 50)
toggleNoclipBtn.Position = UDim2.new(0.55, 0, 0.30, 0)
toggleNoclipBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleNoclipBtn.Font = Enum.Font.GothamBold
toggleNoclipBtn.TextSize = 26
toggleNoclipBtn.TextColor3 = Color3.new(1, 1, 1)
toggleNoclipBtn.Text = "تفعيل Noclip"
toggleNoclipBtn.AutoButtonColor = false
addUICorner(toggleNoclipBtn, 24)

-- // God Mode Toggle
local toggleGodModeBtn = Instance.new("TextButton", frame)
toggleGodModeBtn.Size = UDim2.new(0, 240, 0, 50)
toggleGodModeBtn.Position = UDim2.new(0.55, 0, 0.41, 0)
toggleGodModeBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
toggleGodModeBtn.Font = Enum.Font.GothamBold
toggleGodModeBtn.TextSize = 26
toggleGodModeBtn.TextColor3 = Color3.new(0, 0, 0)
toggleGodModeBtn.Text = "تفعيل God Mode"
toggleGodModeBtn.AutoButtonColor = false
addUICorner(toggleGodModeBtn, 24)

-- // Infinite Jump Toggle
local toggleInfiniteJumpBtn = Instance.new("TextButton", frame)
toggleInfiniteJumpBtn.Size = UDim2.new(0, 240, 0, 50)
toggleInfiniteJumpBtn.Position = UDim2.new(0.55, 0, 0.52, 0)
toggleInfiniteJumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
toggleInfiniteJumpBtn.Font = Enum.Font.GothamBold
toggleInfiniteJumpBtn.TextSize = 26
toggleInfiniteJumpBtn.TextColor3 = Color3.new(1, 1, 1)
toggleInfiniteJumpBtn.Text = "تفعيل Infinite Jump"
toggleInfiniteJumpBtn.AutoButtonColor = false
addUICorner(toggleInfiniteJumpBtn, 24)

-- // Anti AFK Toggle
local toggleAntiAFKBtn = Instance.new("TextButton", frame)
toggleAntiAFKBtn.Size = UDim2.new(0, 240, 0, 50)
toggleAntiAFKBtn.Position = UDim2.new(0.05, 0, 0.63, 0)
toggleAntiAFKBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
toggleAntiAFKBtn.Font = Enum.Font.GothamBold
toggleAntiAFKBtn.TextSize = 26
toggleAntiAFKBtn.TextColor3 = Color3.new(1, 1, 1)
toggleAntiAFKBtn.Text = "تفعيل Anti AFK"
toggleAntiAFKBtn.AutoButtonColor = false
addUICorner(toggleAntiAFKBtn, 24)

-- // Variables for Anti AFK
local antiAFKConnection = nil

-- // Toggle Handlers
toggleBangBtn.MouseButton1Click:Connect(function()
    if not targetInput.Text or #targetInput.Text < 2 then
        createNotification("يجب كتابة أول حرفين من اسم اللاعب")
        return
    end
    local plr = findPlayerByPrefix(targetInput.Text)
    if not plr then
        createNotification("لم يتم العثور على لاعب بهذا الاسم")
        return
    end
    targetPlayer = plr
    isBangActive = not isBangActive
    toggleBangBtn.Text = isBangActive and "إيقاف Bang" or "تفعيل Bang من الخلف"
    createNotification(isBangActive and ("Bang مفعّل على "..targetPlayer.Name) or "Bang متوقف")
end)

-- Speed Slider Drag
local dragging = false
speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)
speedSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
speedSlider.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relativeX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, speedSlider.AbsoluteSize.X)
        local percent = relativeX / speedSlider.AbsoluteSize.X
        fillBar.Size = UDim2.new(percent, 0, 1, 0)
        currentSpeed = math.clamp(percent * 3, 0.1, 3)
        speedLabel.Text = string.format("سرعة الحركة: %.2f", currentSpeed)
    end
end)

-- Noclip toggle
toggleNoclipBtn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    toggleNoclipBtn.Text = noclipEnabled and "إيقاف Noclip" or "تفعيل Noclip"
    createNotification(noclipEnabled and "Noclip مفعّل" or "Noclip متوقف")
end)

-- God Mode toggle
toggleGodModeBtn.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    toggleGodModeBtn.Text = godModeEnabled and "إيقاف God Mode" or "تفعيل God Mode"
    createNotification(godModeEnabled and "God Mode مفعّل" or "God Mode متوقف")
end)

-- Infinite Jump toggle
toggleInfiniteJumpBtn.MouseButton1Click:Connect(function()
    infiniteJumpEnabled = not infiniteJumpEnabled
    toggleInfiniteJumpBtn.Text = infiniteJumpEnabled and "إيقاف Infinite Jump" or "تفعيل Infinite Jump"
    createNotification(infiniteJumpEnabled and "Infinite Jump مفعّل" or "Infinite Jump متوقف")
end)

-- ESP toggle
toggleESPBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    toggleESPBtn.Text = espEnabled and "إيقاف ESP" or "تفعيل ESP"
    createNotification(espEnabled and "ESP مفعّل" or "ESP متوقف")
end)

-- Anti AFK toggle
toggleAntiAFKBtn.MouseButton1Click:Connect(function()
    if antiAFKConnection then
        antiAFKConnection:Disconnect()
        antiAFKConnection = nil
        toggleAntiAFKBtn.Text = "تفعيل Anti AFK"
        createNotification("Anti AFK متوقف")
    else
        antiAFKConnection = UserInputService.Idled:Connect(function()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)
        toggleAntiAFKBtn.Text = "إيقاف Anti AFK"
        createNotification("Anti AFK مفعّل")
    end
end)

-- Jump Handling (infinite jump)
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Noclip function
local function noclip()
    if noclipEnabled then
        local character = LocalPlayer.Character
        if not character then return end
        for _, part in pairs(character:GetChildren()) do
            if
