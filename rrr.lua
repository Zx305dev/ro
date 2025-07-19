--! LocalScript inside StarterPlayerScripts

-- الخدمات
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- إعدادات النظام
local bangActive = false
local targetPlayer = nil
local targetName = ""
local waveDirection = 1
local currentOffset = 0
local speed = 4.0         -- سرعة التذبذب (يمكن تعديلها)
local maxDist = 5.0       -- مدى التذبذب على محور X (يمكن تعديلها)

-- إنشاء واجهة المستخدم (GUI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BangSystemGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 120)
Frame.Position = UDim2.new(0.5, -120, 0.85, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 0.35
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Text = "Bang System Controller"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Parent = Frame

local TargetInput = Instance.new("TextBox")
TargetInput.PlaceholderText = "Enter Target Player Name"
TargetInput.Font = Enum.Font.Gotham
TargetInput.TextSize = 18
TargetInput.Size = UDim2.new(1, -20, 0, 35)
TargetInput.Position = UDim2.new(0, 10, 0, 40)
TargetInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TargetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetInput.ClearTextOnFocus = false
TargetInput.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Activate Bang"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 20
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
ToggleButton.Size = UDim2.new(1, -20, 0, 35)
ToggleButton.Position = UDim2.new(0, 10, 0, 85)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Parent = Frame

-- دالة لتحديث اللاعب الهدف من الاسم المدخل
local function updateTargetFromName(name)
    if name and name ~= "" then
        local player = Players:FindFirstChild(name)
        if player and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer = player
            targetName = name
            print("[Bang] Target set to:", targetName)
            return true
        else
            print("[Bang] Player not found or invalid target.")
            targetPlayer = nil
            targetName = ""
            return false
        end
    else
        print("[Bang] No target name entered.")
        targetPlayer = nil
        targetName = ""
        return false
    end
end

-- تفعيل النظام
local function activateBang()
    if updateTargetFromName(TargetInput.Text) then
        bangActive = true
        ToggleButton.Text = "Deactivate Bang"
        print("[Bang] Activated")
    else
        bangActive = false
        ToggleButton.Text = "Activate Bang"
        print("[Bang] Activation failed. Invalid target.")
    end
end

-- إيقاف النظام
local function deactivateBang()
    bangActive = false
    ToggleButton.Text = "Activate Bang"
    -- إعادة الكاميرا للوضع الافتراضي
    Camera.CameraType = Enum.CameraType.Custom
    print("[Bang] Deactivated")
end

-- التعامل مع ضغطة زر التفعيل
ToggleButton.MouseButton1Click:Connect(function()
    if bangActive then
        deactivateBang()
    else
        activateBang()
    end
end)

-- تحديث الهدف عند انتهاء الإدخال
TargetInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        updateTargetFromName(TargetInput.Text)
    end
end)

-- تحديث حركة الكاميرا بشكل مستمر
RS.Heartbeat:Connect(function(dt)
    if bangActive and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if localRoot then
            -- تحديث التذبذب
            currentOffset = currentOffset + speed * waveDirection * dt
            if math.abs(currentOffset) >= maxDist then
                waveDirection = -waveDirection
                currentOffset = math.clamp(currentOffset, -maxDist, maxDist)
            end

            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local aimPos = targetPos + Vector3.new(currentOffset, 0, 0)

            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = CFrame.new(localRoot.Position, aimPos)
        else
            print("[Bang] Local player root part missing.")
            deactivateBang()
        end
    else
        if bangActive then
            print("[Bang] Target lost or invalid.")
            deactivateBang()
        end
    end
end)
