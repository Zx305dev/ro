-- Elite V5 PRO 2025 - Full Enhanced Script
-- Author: FNLOXER-inspired pro version

-- Cleanup old menu if exists
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Create main GUI container
local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.Parent = game.CoreGui
EliteMenu.ResetOnSpawn = false

-- Utility: Add UICorner to UI elements
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 12)
    corner.Parent = parent
    return corner
end

-- Notification system
local function createNotification(text, duration)
    duration = duration or 3
    local notifGui = Instance.new("ScreenGui", game.CoreGui)
    notifGui.Name = "NotifGui"

    local frame = Instance.new("Frame", notifGui)
    frame.Size = UDim2.new(0, 320, 0, 50)
    frame.Position = UDim2.new(0.5, -160, 0.85, 0)
    frame.BackgroundColor3 = Color3.fromRGB(120, 0, 180)
    frame.BorderSizePixel = 0
    addUICorner(frame, 18)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 0}):Play()
    TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    task.delay(duration, function()
        TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        notifGui:Destroy()
    end)
end

-- Main Frame Setup
local MainFrame = Instance.new("Frame", EliteMenu)
local defaultSize = UDim2.new(0, 560, 0, 500)
local minimizedSize = UDim2.new(0, 560, 0, 45)

MainFrame.Size = defaultSize
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 15, 60)
MainFrame.BorderSizePixel = 0
addUICorner(MainFrame, 20)

-- Title Label
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 28
Title.TextColor3 = Color3.fromRGB(255, 215, 255)
Title.Text = "🔥 Elite V5 PRO 2025 🔥"

-- Close Button
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 20, 20)
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 30
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.AutoButtonColor = false
addUICorner(CloseBtn, 12)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(190, 20, 20)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    EliteMenu.Enabled = false
    createNotification("تم إغلاق Elite V5 PRO")
end)

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 40, 0, 40)
MinimizeBtn.Position = UDim2.new(1, -90, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(170, 140, 30)
MinimizeBtn.Text = "–"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 34
MinimizeBtn.TextColor3 = Color3.new(1, 1, 1)
MinimizeBtn.AutoButtonColor = false
addUICorner(MinimizeBtn, 12)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = defaultSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = true end
        end)
        isMinimized = false
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = minimizedSize}):Play()
        task.delay(0.4, function()
            for _, p in pairs(Pages) do p.Visible = false end
        end)
        isMinimized = true
    end
end)

-- Tabs Setup
local Tabs = {"الرئيسية", "Bang", "Emote", "معلومات اللاعب"}
local TabButtons = {}
Pages = {}

local function createTabButton(name, idx)
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(0, 140, 0, 35)
    btn.Position = UDim2.new(0, 10 + (idx - 1) * 150, 0, 45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.BackgroundColor3 = Color3.fromRGB(65, 15, 85)
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(110, 25, 140)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if Pages[idx].Visible then
            TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(65, 15, 85)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        for i, p in pairs(Pages) do
            p.Visible = false
            TweenService:Create(TabButtons[i], TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(65, 15, 85)}):Play()
        end
        Pages[idx].Visible = true
        TweenService:Create(btn, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(90, 20, 120)}):Play()
    end)

    return btn
end

for i, tabName in ipairs(Tabs) do
    TabButtons[i] = createTabButton(tabName, i)
    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -90)
    page.Position = UDim2.new(0, 10, 0, 85)
    page.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
    page.Visible = (i == 1)
    addUICorner(page, 18)
    Pages[i] = page
end

-------------------------------
-- Tab 1: الرئيسية (Main Tab)
-------------------------------
do
    local page = Pages[1]
    page:ClearAllChildren()

    local options = {
        {Name = "Speed Hack", State = false},
        {Name = "ESP", State = false},
        {Name = "Jump Boost", State = false},
        {Name = "Fly Mode", State = false},
    }

    local labels = {}
    local toggles = {}

    local humanoid = nil
    local function updateHumanoid()
        if LocalPlayer.Character then
            humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        else
            humanoid = nil
        end
    end
    LocalPlayer.CharacterAdded:Connect(updateHumanoid)
    updateHumanoid()

    local flyEnabled = false
    local flySpeed = 50
    local bodyGyro, bodyVelocity

    for i, option in ipairs(options) do
        local label = Instance.new("TextLabel", page)
        label.Size = UDim2.new(0, 200, 0, 35)
        label.Position = UDim2.new(0, 20, 0, 20 + (i - 1) * 50)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(230, 230, 230)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 22
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = option.Name
        labels[i] = label

        local toggle = Instance.new("TextButton", page)
        toggle.Size = UDim2.new(0, 80, 0, 35)
        toggle.Position = UDim2.new(0, 230, 0, 20 + (i - 1) * 50)
        toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
        toggle.Font = Enum.Font.GothamBold
        toggle.TextSize = 20
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.Text = "OFF"
        addUICorner(toggle, 14)

        toggle.MouseButton1Click:Connect(function()
            options[i].State = not options[i].State
            toggle.Text = options[i].State and "ON" or "OFF"
            toggle.BackgroundColor3 = options[i].State and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(100, 0, 150)

            if option.Name == "Speed Hack" then
                if humanoid then
                    humanoid.WalkSpeed = options[i].State and 50 or 16
                    createNotification("Speed Hack " .. (options[i].State and "مفعل" or "معطل"))
                end
            elseif option.Name == "Jump Boost" then
                if humanoid then
                    humanoid.JumpPower = options[i].State and 100 or 50
                    createNotification("Jump Boost " .. (options[i].State and "مفعل" or "معطل"))
                end
            elseif option.Name == "Fly Mode" then
                flyEnabled = options[i].State
                if flyEnabled then
                    createNotification("Fly Mode مفعل - استخدم WASD + Space + Ctrl للطيران")
                else
                    createNotification("Fly Mode معطل")
                    if bodyGyro then
                        bodyGyro:Destroy()
                        bodyGyro = nil
                    end
                    if bodyVelocity then
                        bodyVelocity:Destroy()
                        bodyVelocity = nil
                    end
                end
            elseif option.Name == "ESP" then
                if options[i].State then
                    createNotification("ESP مفعل")
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not plr.Character:FindFirstChild("BoxESP") then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Name = "BoxESP"
                                box.Adornee = plr.Character.HumanoidRootPart
                                box.AlwaysOnTop = true
                                box.ZIndex = 10
                                box.Size = Vector3.new(2, 5, 1)
                                box.Transparency = 0.6
                                box.Color3 = Color3.fromRGB(255, 0, 0)
                                box.Parent = plr.Character.HumanoidRootPart
                            end
                        end
                    end
                else
                    createNotification("ESP معطل")
                    for _, plr in pairs(Players:GetPlayers()) do
                        if plr.Character and plr.Character:FindFirstChild("BoxESP") then
                            plr.Character.BoxESP:Destroy()
                        end
                    end
                end
            end
        end)
        toggles[i] = toggle
    end

    -- Fly Mode Movement Handler
    RS:BindToRenderStep("FlyControl", Enum.RenderPriority.Character.Value + 1, function()
        if not flyEnabled or not LocalPlayer.Character or not humanoid then return end

        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end

        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0, 0, 0)
        local speed = flySpeed

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * speed
        else
            moveDir = Vector3.new(0,0,0)
        end

        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.P = 1e4
            bodyVelocity.Parent = root
        end

        if not bodyGyro then
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            bodyGyro.P = 1e4
            bodyGyro.Parent = root
        end

        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = cam.CFrame
    end)
end

--------------------------------
-- Tab 2: Bang System (خلف اللاعب الهدف)
--------------------------------
do
    local page = Pages[2]
    page:ClearAllChildren()

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 50)
    infoLabel.Position = UDim2.new(0, 20, 0, 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.GothamBold
    infoLabel.TextSize = 20
    infoLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
    infoLabel.Text = "اختر هدف من القائمة أدناه ثم فعّل Bang system"

    local targetDropdown = Instance.new("TextButton", page)
    targetDropdown.Size = UDim2.new(0, 200, 0, 35)
    targetDropdown.Position = UDim2.new(0, 20, 0, 70)
    targetDropdown.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    targetDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    targetDropdown.Font = Enum.Font.GothamBold
    targetDropdown.TextSize = 18
    targetDropdown.Text = "اختيار الهدف"
    addUICorner(targetDropdown, 14)

    local dropdownOpen = false
    local dropdownList = Instance.new("ScrollingFrame", page)
    dropdownList.Size = UDim2.new(0, 200, 0, 150)
    dropdownList.Position = UDim2.new(0, 20, 0, 110)
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 10, 80)
    dropdownList.BorderSizePixel = 0
    dropdownList.Visible = false
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    addUICorner(dropdownList, 14)

    local targetSelected = nil
    local bangActive = false

    local function updateDropdown()
        for _, child in pairs(dropdownList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local yPos = 0
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local btn = Instance.new("TextButton", dropdownList)
                btn.Size = UDim2.new(1, 0, 0, 30)
                btn.Position = UDim2.new(0, 0, 0, yPos)
                btn.BackgroundColor3 = Color3.fromRGB(85, 25, 120)
                btn.Text = plr.Name
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 16
                addUICorner(btn, 10)

                btn.MouseButton1Click:Connect(function()
                    targetSelected = plr
                    targetDropdown.Text = "الهدف: " .. plr.Name
                    dropdownList.Visible = false
                    dropdownOpen = false
                end)

                yPos = yPos + 35
            end
        end
        dropdownList.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end

    targetDropdown.MouseButton1Click:Connect(function()
        dropdownOpen = not dropdownOpen
        dropdownList.Visible = dropdownOpen
        if dropdownOpen then
            updateDropdown()
        end
    end)

    -- Toggle Button for Bang System
    local bangToggle = Instance.new("TextButton", page)
    bangToggle.Size = UDim2.new(0, 120, 0, 35)
    bangToggle.Position = UDim2.new(0, 240, 0, 70)
    bangToggle.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    bangToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
    bangToggle.Font = Enum.Font.GothamBold
    bangToggle.TextSize = 20
    bangToggle.Text = "OFF"
    addUICorner(bangToggle, 14)

    bangToggle.MouseButton1Click:Connect(function()
        if not targetSelected then
            createNotification("يجب اختيار هدف أولاً")
            return
        end

        bangActive = not bangActive
        bangToggle.Text = bangActive and "ON" or "OFF"
        bangToggle.BackgroundColor3 = bangActive and Color3.fromRGB(0, 150, 70) or Color3.fromRGB(100, 0, 150)

        createNotification("Bang system " .. (bangActive and "مفعل" or "معطل"))
    end)

    -- Bang system logic: Position player behind target with smooth update
    RS:BindToRenderStep("BangSystem", Enum.RenderPriority.Character.Value + 1, function()
        if not bangActive or not targetSelected or not targetSelected.Character then return end
        local targetRoot = targetSelected.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not targetRoot or not localRoot then return end

        -- Calculate position behind the target (~3 studs behind target facing direction)
        local targetCFrame = targetRoot.CFrame
        local behindPos = targetCFrame.Position - targetCFrame.LookVector * 3 + Vector3.new(0, 1, 0)

        -- Smoothly move local player to behind position
        localRoot.CFrame = CFrame.new(behindPos, targetCFrame.Position)

        -- Optional: Keep humanoid root part velocity zero to avoid physics glitches
        if LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = true
        end
    end)
end

-------------------------------
-- Tab 3: Emote Control
-------------------------------
do
    local page = Pages[3]
    page:ClearAllChildren()

    local emoteLabel = Instance.new("TextLabel", page)
    emoteLabel.Size = UDim2.new(1, -40, 0, 40)
    emoteLabel.Position = UDim2.new(0, 20, 0, 10)
    emoteLabel.BackgroundTransparency = 1
    emoteLabel.Font = Enum.Font.GothamBold
    emoteLabel.TextSize = 20
    emoteLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
    emoteLabel.Text = "اختر حركة Emote ثم اضغط تشغيل"

    -- Emote selector dropdown
    local emotes = {
        ["Dolphin Dance"] = 5938365243, -- example asset ID
        ["Wave"] = 241667845, -- sample ID
        ["Dance1"] = 507766666, -- sample ID
    }

    local emoteDropdown = Instance.new("TextButton", page)
    emoteDropdown.Size = UDim2.new(0, 200, 0, 35)
    emoteDropdown.Position = UDim2.new(0, 20, 0, 70)
    emoteDropdown.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    emoteDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    emoteDropdown.Font = Enum.Font.GothamBold
    emoteDropdown.TextSize = 18
    emoteDropdown.Text = "اختيار Emote"
    addUICorner(emoteDropdown, 14)

    local emoteOpen = false
    local emoteList = Instance.new("ScrollingFrame", page)
    emoteList.Size = UDim2.new(0, 200, 0, 150)
    emoteList.Position = UDim2.new(0, 20, 0, 110)
    emoteList.BackgroundColor3 = Color3.fromRGB(50, 10, 80)
    emoteList.BorderSizePixel = 0
    emoteList.Visible = false
    emoteList.CanvasSize = UDim2.new(0, 0, 0, 0)
    addUICorner(emoteList, 14)

    local selectedEmote = nil

    local function updateEmoteList()
        for _, child in pairs(emoteList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local yPos = 0
        for emoteName, assetId in pairs(emotes) do
            local btn = Instance.new("TextButton", emoteList)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, yPos)
            btn.BackgroundColor3 = Color3.fromRGB(85, 25, 120)
            btn.Text = emoteName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 16
            addUICorner(btn, 10)

            btn.MouseButton1Click:Connect(function()
                selectedEmote = emoteName
                emoteDropdown.Text = "Emote: " .. emoteName
                emoteList.Visible = false
                emoteOpen = false
            end)

            yPos = yPos + 35
        end
        emoteList.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end

    emoteDropdown.MouseButton1Click:Connect(function()
        emoteOpen = not emoteOpen
        emoteList.Visible = emoteOpen
        if emoteOpen then
            updateEmoteList()
        end
    end)

    -- Play Button
    local playBtn = Instance.new("TextButton", page)
    playBtn.Size = UDim2.new(0, 100, 0, 35)
    playBtn.Position = UDim2.new(0, 240, 0, 70)
    playBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextSize = 20
    playBtn.Text = "تشغيل"
    addUICorner(playBtn, 14)

    -- Speed control slider label
    local speedLabel = Instance.new("TextLabel", page)
    speedLabel.Size = UDim2.new(0, 150, 0, 25)
    speedLabel.Position = UDim2.new(0, 20, 0, 270)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 16
    speedLabel.Text = "سرعة الحركة: 1.0x"

    -- Speed slider (simple)
    local speedSlider = Instance.new("TextButton", page)
    speedSlider.Size = UDim2.new(0, 150, 0, 20)
    speedSlider.Position = UDim2.new(0, 20, 0, 300)
    speedSlider.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    speedSlider.Text = ""
    addUICorner(speedSlider, 12)

    local speedFill = Instance.new("Frame", speedSlider)
    speedFill.Size = UDim2.new(0.5, 0, 1, 0) -- default 0.5 = 1x speed
    speedFill.BackgroundColor3 = Color3.fromRGB(0, 150, 70)
    addUICorner(speedFill, 12)

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
            speedFill.Size = UDim2.new(percent, 0, 1, 0)
            local speedValue = (percent * 2) -- speed range 0 to 2
            speedLabel.Text = string.format("سرعة الحركة: %.2fx", speedValue)
        end
    end)

    -- Animation playing logic
    local currentAnim = nil
    local animator = nil

    playBtn.MouseButton1Click:Connect(function()
        if not selectedEmote then
            createNotification("يرجى اختيار Emote أولاً")
            return
        end
        if not LocalPlayer.Character then
            createNotification("لا يوجد شخصية حالياً")
            return
        end

        if animator == nil then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)
            end
        end
        if animator == nil then
            createNotification("تعذر إيجاد Animator")
            return
        end

        if currentAnim then
            currentAnim:Stop()
            currentAnim:Destroy()
            currentAnim = nil
        end

        local assetId = emotes[selectedEmote]
        if not assetId then
            createNotification("تعذر إيجاد الAnimation")
            return
        end

        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. tostring(assetId)

        currentAnim = animator:LoadAnimation(animation)
        currentAnim:Play()

        -- Adjust speed based on slider
        local speedPercent = speedFill.Size.X.Scale
        currentAnim.Speed = math.clamp(speedPercent * 2, 0.1, 2)

        createNotification("تم تشغيل Emote: " .. selectedEmote)
    end)
end

-------------------------------
-- Tab 4: معلومات اللاعب (Player Info)
-------------------------------
do
    local page = Pages[4]
    page:ClearAllChildren()

    local infoTitle = Instance.new("TextLabel", page)
    infoTitle.Size = UDim2.new(1, -40, 0, 50)
    infoTitle.Position = UDim2.new(0, 20, 0, 10)
    infoTitle.BackgroundTransparency = 1
    infoTitle.Font = Enum.Font.GothamBold
    infoTitle.TextSize = 24
    infoTitle.TextColor3 = Color3.fromRGB(255, 200, 200)
    infoTitle.Text = "معلومات اللاعب (Player Info)"

    local infoLabel = Instance.new("TextLabel", page)
    infoLabel.Size = UDim2.new(1, -40, 0, 150)
    infoLabel.Position = UDim2.new(0, 20, 0, 70)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 18
    infoLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.Text = "جاري تحميل المعلومات..."

    local function updateInfo()
        if not LocalPlayer.Character then
            infoLabel.Text = "لا يوجد شخصية حالياً"
            return
        end

        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

        if not humanoid or not root then
            infoLabel.Text = "تعذر إيجاد المكونات الأساسية"
            return
        end

        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local position = root.Position
        local walkSpeed = humanoid.WalkSpeed
        local jumpPower = humanoid.JumpPower

        infoLabel.Text = string.format(
            [[
اسم اللاعب: %s
الصحة: %.1f / %.1f
الموقع: X=%.1f, Y=%.1f, Z=%.1f
سرعة المشي: %.1f
قوة القفز: %.1f
            ]],
            LocalPlayer.Name,
            health,
            maxHealth,
            position.X, position.Y, position.Z,
            walkSpeed,
            jumpPower
        )
    end

    -- تحديث كل نصف ثانية
    RS:BindToRenderStep("UpdatePlayerInfo", Enum.RenderPriority.Last.Value, function()
        updateInfo()
    end)
end
