    local closest = nil
    local minDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                closest = player
                minDist = dist
            end
        end
    end
    return closest
end

local function Bang()
    if BangCooldown then return end
    BangCooldown = true
    local target = GetNearestPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.Character.HumanoidRootPart.Position
        local behindVec = (target.Character.HumanoidRootPart.CFrame.LookVector * -Settings.BangDistance)
        local newPos = targetPos + behindVec

        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tween = TweenService:Create(hrp, TweenInfo.new(Settings.BangSmooth), {CFrame = CFrame.new(newPos)})
            tween:Play()
        end
    end
    task.wait(0.5)
    BangCooldown = false
end

-- ✈️ FLY Mode
local BodyVelocity = Instance.new("BodyVelocity")
BodyVelocity.Velocity = Vector3.new()
BodyVelocity.MaxForce = Vector3.new(0, 0, 0)
BodyVelocity.Name = "FlyVelocity"

local function ToggleFly()
    FlyEnabled = not FlyEnabled
    if FlyEnabled then
        local HRP = LP.Character:WaitForChild("HumanoidRootPart")
        BodyVelocity.Parent = HRP
        BodyVelocity.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    else
        BodyVelocity:Destroy()
    end
end

RunService.RenderStepped:Connect(function()
    if FlyEnabled then
        local cam = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.RightVector end
        BodyVelocity.Velocity = moveVec.Unit * 100
    end
end)

-- 🌀 Noclip
RunService.Stepped:Connect(function()
    if NoclipEnabled and LP.Character then
        for _, part in pairs(LP.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

local function ToggleNoclip()
    NoclipEnabled = not NoclipEnabled
end

-- 🏃‍♂️ Movement Buff
LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    char:WaitForChild("Humanoid").WalkSpeed = 16 * Settings.SpeedMultiplier
    char:WaitForChild("Humanoid").JumpPower = Settings.JumpPower
end)

if LP.Character then
    LP.Character:WaitForChild("Humanoid").WalkSpeed = 16 * Settings.SpeedMultiplier
    LP.Character:WaitForChild("Humanoid").JumpPower = Settings.JumpPower
end

-- 🧠 KeyBinds
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Settings.KeyToBang then
        Bang()
    elseif input.KeyCode == Settings.FlyKey then
        ToggleFly()
    elseif input.KeyCode == Settings.NoclipKey then
        ToggleNoclip()
    end
end)

-- 🎨 GUI
local function CreateGui()
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 300, 0, 180)
    Frame.Position = UDim2.new(0.35, 0, 0.15, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true

    local UICorner = Instance.new("UICorner", Frame)
    UICorner.CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.Text = "🔥 ELITE BANG SYSTEM V5 🔥"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1
    Title.TextScaled = true
    Title.Font = Enum.Font.SourceSansBold

    local Info = Instance.new("TextLabel", Frame)
    Info.Size = UDim2.new(1, 0, 0, 120)
    Info.Position = UDim2.new(0, 0, 0, 40)
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.BackgroundTransparency = 1
    Info.Text = "B = Bang\nF = Fly\nN = Noclip\nSpeed x2.5\nJump = 120"
    Info.Font = Enum.Font.Code
    Info.TextSize = 18
    Info.TextYAlignment = Enum.TextYAlignment.Top
end

CreateGui()

-- ✅ Complete!
print("✅ Elite Bang System Loaded!")
