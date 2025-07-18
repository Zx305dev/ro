-- ELITE V2 - Purple GUI SCRIPT مع صفحات وخواص متقدمة
-- مخصص للاستخدام مع Executors (Synapse X, KRNL, Fluxus...)

-- منع تشغيل أكثر من نسخة
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- إنشاء GUI رئيسي
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false

local frame = Instance.new("Frame", EliteMenu)
frame.Name = "MainFrame"
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Position = UDim2.new(0.05, 0, 0.15, 0)
frame.Size = UDim2.new(0.3, 0, 0.65, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 8)

-- عنوان الواجهة
local title = Instance.new("TextLabel", frame)
title.Text = "ELITE V2"
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24

-- حاوية الصفحات
local pagesContainer = Instance.new("Frame", frame)
pagesContainer.Name = "PagesContainer"
pagesContainer.BackgroundTransparency = 1
pagesContainer.Size = UDim2.new(1, 0, 0.8, 0)
pagesContainer.Position = UDim2.new(0, 0, 0.12, 0)

-- جدول الصفحات
local pages = {}

local function showPage(name)
    for k,v in pairs(pages) do
        v.Visible = (k == name)
    end
end

-- إنشاء أزرار التنقل بين الصفحات
local btnNames = {"Main", "ESP", "ChatSpam", "18+"}
local btnContainer = Instance.new("Frame", frame)
btnContainer.Size = UDim2.new(1, 0, 0.1, 0)
btnContainer.Position = UDim2.new(0, 0, 0.93, 0)
btnContainer.BackgroundTransparency = 1

for i, name in ipairs(btnNames) do
    local btn = Instance.new("TextButton", btnContainer)
    btn.Text = name
    btn.Size = UDim2.new(1/#btnNames - 0.02, 0, 1, 0)
    btn.Position = UDim2.new((i-1)/#btnNames + 0.01*(i-1), 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    local uic = Instance.new("UICorner", btn)
    uic.CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(function()
        showPage(name)
    end)
end

-- الصفحة 1: Main
pages["Main"] = Instance.new("Frame", pagesContainer)
pages["Main"].Size = UDim2.new(1, 0, 1, 0)
pages["Main"].BackgroundTransparency = 1
pages["Main"].Visible = true

local mainButtonsData = {
    {"Speed", function()
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 100
        end
    end},
    {"Jump", function()
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChild("Humanoid") then
            plr.Character.Humanoid.JumpPower = 150
        end
    end},
    {"Fly", function()
        local plr = game.Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local flying = true
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(99999,99999,99999)

        local conn = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying then return end
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

        wait(10)
        flying = false
        bv:Destroy()
        conn:Disconnect()
    end},
    {"Invisible", function()
        local char = game.Players.LocalPlayer.Character
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end},
    {"Teleport", function()
        local cam = workspace.CurrentCamera
        local ray = Ray.new(cam.CFrame.Position, cam.CFrame.LookVector * 500)
        local hit, pos = workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character)
        if pos then
            game.Players.LocalPlayer.Character:MoveTo(pos + Vector3.new(0, 5, 0))
        end
    end},
    {"Close", function()
        EliteMenu:Destroy()
    end},
}

-- إنشاء أزرار Main Page
for i, btn in ipairs(mainButtonsData) do
    local b = Instance.new("TextButton", pages["Main"])
    b.Name = btn[1].."Btn"
    b.Text = btn[1]
    b.Size = UDim2.new(0.8, 0, 0.1, 0)
    b.Position = UDim2.new(0.1, 0, 0.05 + (i-1)*0.11, 0)
    b.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 16
    b.MouseButton1Click:Connect(btn[2])

    local ui = Instance.new("UICorner", b)
    ui.CornerRadius = UDim.new(0, 4)
end

-- الصفحة 2: ESP
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

-- زر تفعيل ESP
local espBtn = Instance.new("TextButton", pages["ESP"])
espBtn.Name = "ToggleESPBtn"
espBtn.Text = "Toggle ESP"
espBtn.Size = UDim2.new(0.8, 0, 0.15, 0)
espBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
espBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 18
local espUICorner = Instance.new("UICorner", espBtn)
espUICorner.CornerRadius = UDim.new(0, 6)

espBtn.MouseButton1Click:Connect(function()
    toggleEsp(not espEnabled)
end)

-- تحديث ESP على انضمام أو خروج اللاعبين
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

-- الصفحة 3: Chat Spam
pages["ChatSpam"] = Instance.new("Frame", pagesContainer)
pages["ChatSpam"].Size = UDim2.new(1, 0, 1, 0)
pages["ChatSpam"].BackgroundTransparency = 1
pages["ChatSpam"].Visible = false

local chatSpamActive = false
local spamMsg = "Bang Bang 😈👹🔥"
local spamInterval = 2 -- ثواني بين الرسائل

local function chatSpam()
    while chatSpamActive do
        game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(spamMsg, "All")
        wait(spamInterval)
    end
end

local spamToggleBtn = Instance.new("TextButton", pages["ChatSpam"])
spamToggleBtn.Name = "SpamToggleBtn"
spamToggleBtn.Text = "Toggle Spam"
spamToggleBtn.Size = UDim2.new(0.8, 0, 0.15, 0)
spamToggleBtn.Position = UDim2.new(0.1, 0, 0.1, 0)
spamToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
spamToggleBtn.TextColor3 = Color3.new(1,1,1)
spamToggleBtn.Font = Enum.Font.GothamBold
spamToggleBtn.TextSize = 18
local spamUICorner = Instance.new("UICorner", spamToggleBtn)
spamUICorner.CornerRadius = UDim.new(0, 6)

spamToggleBtn.MouseButton1Click:Connect(function()
    chatSpamActive = not chatSpamActive
    if chatSpamActive then
        spawn(chatSpam)
    end
end)

-- نص لتعديل رسالة السبام (اختياري)
local spamInput = Instance.new("TextBox", pages["ChatSpam"])
spamInput.Size = UDim2.new(0.8, 0, 0.1, 0)
spamInput.Position = UDim2.new(0.1, 0, 0.3, 0)
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

-- الصفحة 4: 18+ Page مع تأثير Bang
pages["18+"] = Instance.new("Frame", pagesContainer)
pages["18+"].Size = UDim2.new(1, 0, 1, 0)
pages["18+"].BackgroundTransparency = 1
pages["18+"].Visible = false

local bangLabel = Instance.new("TextLabel", pages["18+"])
bangLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
bangLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
bangLabel.Text = "BANG! 😈🔥"
bangLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
bangLabel.Font = Enum.Font.GothamBlack
bangLabel.TextSize = 50
bangLabel.TextStrokeTransparency = 0
bangLabel.BackgroundTransparency = 1
bangLabel.TextScaled = true

-- تأثير نبض النص (Pulse)
local pulseDirection = 1
game:GetService("RunService").RenderStepped:Connect(function()
    local size = bangLabel.TextSize
    if size >= 60 then pulseDirection = -1 end
    if size <= 40 then pulseDirection = 1 end
    bangLabel.TextSize = size + pulseDirection * 0.5
end)

-- Bypass Detection:  
-- ملاحظة: تجاوز الحماية عادة يحتاج حقن خارجي + تعديل Process، لكنه يمكن إضافة بعض حيل داخل السكربت لتحسين التمويه.
-- مثال على تعطيل التحقق من اللعبة داخل السكربت (مثال بدائي):

local function bypassAntiCheat()
    -- حذف بعض الأحداث أو تعديل وظائف الكشف إن أمكن (حسب اللعبة)
    -- هذا مكان مخصص للتطوير حسب اللعبة والباك اند الخاص بها
    print("[Bypass] Attempting bypass - customize حسب اللعبة")
end

bypassAntiCheat()

-- إخفاء الواجهة بضغط M
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.M then
        frame.Visible = not frame.Visible
    end
end)
