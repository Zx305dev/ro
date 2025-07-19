--[[
🔥 Elite V5 PRO - FULL EDITION 🔥
Made by: ALm6eri
GUI Style: Purple | No Bugs | Optimized | Powerful Bang System

Pages:
1️⃣ Bang System (with Auto Noclip + Lock Movement)
2️⃣ Player Hacks (Fly, Speed, Jump, Noclip)
3️⃣ Player & Server Info
4️⃣ Settings / Toggle UI

🎮 Roblox Lua (LocalScript) - Works in Executor
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI INIT
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "EliteV5Pro"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 480, 0, 360)
Frame.Position = UDim2.new(0.5, -240, 0.5, -180)
Frame.BackgroundColor3 = Color3.fromRGB(45, 0, 70)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 16)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "🔥 Elite V5 PRO - By ALm6eri 🔥"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(200, 130, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22

-- Pages
local pages = {
    "Bang System",
    "Player Hacks",
    "Player Info",
    "Settings"
}

local currentPage = 1
local pageContent = Instance.new("Frame", Frame)
pageContent.Position = UDim2.new(0, 0, 0, 50)
pageContent.Size = UDim2.new(1, 0, 1, -50)
pageContent.BackgroundTransparency = 1

-- Switch buttons
local function createTabButtons()
    for i, tab in ipairs(pages) do
        local b = Instance.new("TextButton", Frame)
        b.Size = UDim2.new(0, 100, 0, 30)
        b.Position = UDim2.new(0, 10 + (i-1)*110, 0, 360)
        b.Text = tab
        b.BackgroundColor3 = Color3.fromRGB(70, 0, 90)
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.Gotham
        b.TextSize = 14
        b.MouseButton1Click:Connect(function()
            currentPage = i
            updatePages()
        end)
    end
end

-- Clear + draw pages
local function updatePages()
    pageContent:ClearAllChildren()
    if currentPage == 1 then
        -- Bang Page
        local Title = Instance.new("TextLabel", pageContent)
        Title.Text = "BANG SYSTEM 🔥"
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 20
        Title.Size = UDim2.new(1, 0, 0, 30)
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundTransparency = 1

        local target = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                target = p.Character
                break
            end
        end

        local bangActive = false
        local function doBang()
            if not target then return end
            local hrp = LocalPlayer.Character:WaitForChild("HumanoidRootPart")
            local thrp = target:FindFirstChild("HumanoidRootPart")
            if not thrp then return end

            -- Disable movement
            UIS.InputBegan:Connect(function(input)
                if bangActive and (input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S) then
                    input:Capture()
                end
            end)

            bangActive = true

            -- Noclip ON
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end

            -- Bang loop
            while bangActive and target and target.Parent do
                hrp.CFrame = thrp.CFrame * CFrame.new(0, 0, -3.5 + math.sin(tick()*5))
                RS.RenderStepped:Wait()
            end
        end

        local BangBtn = Instance.new("TextButton", pageContent)
        BangBtn.Text = "Activate BANG"
        BangBtn.Size = UDim2.new(0, 200, 0, 40)
        BangBtn.Position = UDim2.new(0, 20, 0, 40)
        BangBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
        BangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        BangBtn.Font = Enum.Font.GothamBold
        BangBtn.TextSize = 16
        BangBtn.MouseButton1Click:Connect(function()
            doBang()
        end)
    elseif currentPage == 2 then
        -- Player Hacks Page
        local function toggleFly()
            local fly = true
            local hum = LocalPlayer.Character:WaitForChild("Humanoid")
            hum.PlatformStand = true
            while fly do
                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 25, 0)
                wait(0.1)
            end
        end

        local function toggleSpeed()
            LocalPlayer.Character.Humanoid.WalkSpeed = 100
        end

        local function toggleJump()
            LocalPlayer.Character.Humanoid.JumpPower = 200
        end

        local function toggleNoclip()
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end

        local hacks = {
            {"Fly", toggleFly},
            {"Speed", toggleSpeed},
            {"Jump", toggleJump},
            {"Noclip", toggleNoclip}
        }

        for i, h in ipairs(hacks) do
            local b = Instance.new("TextButton", pageContent)
            b.Text = h[1]
            b.Size = UDim2.new(0, 200, 0, 30)
            b.Position = UDim2.new(0, 20, 0, 10 + i*35)
            b.BackgroundColor3 = Color3.fromRGB(110, 0, 160)
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.Font = Enum.Font.GothamBold
            b.TextSize = 14
            b.MouseButton1Click:Connect(function()
                h[2]()
            end)
        end
    elseif currentPage == 3 then
        -- Player Info
        local label = Instance.new("TextLabel", pageContent)
        label.Size = UDim2.new(1, 0, 0, 30)
        label.Text = "👤 "..LocalPlayer.DisplayName.." (@"..LocalPlayer.Name..")"
        label.Font = Enum.Font.GothamBold
        label.TextSize = 16
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 10, 0, 10)
    elseif currentPage == 4 then
        -- Settings Page
        local Close = Instance.new("TextButton", pageContent)
        Close.Size = UDim2.new(0, 200, 0, 40)
        Close.Position = UDim2.new(0, 20, 0, 20)
        Close.Text = "❌ Close Menu"
        Close.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
        Close.TextColor3 = Color3.fromRGB(255, 255, 255)
        Close.Font = Enum.Font.GothamBold
        Close.TextSize = 16
        Close.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
    end
end

-- INIT
createTabButtons()
updatePages()
