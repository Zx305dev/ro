--🔥 Elite V5 PRO | Made by Alm6eri 🔥
-- حذف أي نسخة سابقة
pcall(function() game.CoreGui:FindFirstChild("Elite"):Destroy() end)

-- الخدمات
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- واجهة
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Elite"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- إطار رئيسي
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 500, 0, 400)
Main.Position = UDim2.new(0.5, -250, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- Corner
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

-- Scroll داخل الإطار
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.Parent = Main

-- قائمة
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- إضافة زر
local function AddButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 16
    Button.Parent = ScrollingFrame

    local corner = Instance.new("UICorner", Button)
    corner.CornerRadius = UDim.new(0, 6)

    Button.MouseButton1Click:Connect(callback)
end

-- Bang System
local function BangSystem()
    local target = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            target = p
            break
        end
    end
    if target then
        RunService:BindToRenderStep("BangMove", Enum.RenderPriority.Character.Value + 1, function()
            if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local offset = Vector3.new(0, 0, -2)
                local targetPos = target.Character.HumanoidRootPart.Position + offset
                LocalPlayer.Character:MoveTo(targetPos)
            end
        end)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Bang Started",
            Text = "جارٍ تتبع الهدف",
            Duration = 5
        })
    end
end

-- Fly
local flyToggle = false
local function Fly()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.MaxForce = Vector3.new(99999,99999,99999)
    bodyVelocity.Parent = character.HumanoidRootPart

    RunService.RenderStepped:Connect(function()
        if not flyToggle then return end
        local direction = Vector3.new()
        if UIS:IsKeyDown(Enum.KeyCode.W) then direction = direction + workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then direction = direction - workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then direction = direction - workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then direction = direction + workspace.CurrentCamera.CFrame.RightVector end
        bodyVelocity.Velocity = direction * 50
    end)
end

-- ESP بسيط
local function ESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local box = Instance.new("BoxHandleAdornment")
            box.Adornee = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            box.Size = Vector3.new(3,6,3)
            box.AlwaysOnTop = true
            box.ZIndex = 5
            box.Color3 = Color3.fromRGB(255,0,255)
            box.Transparency = 0.4
            box.Parent = CoreGui
        end
    end
end

-- أزرار القائمة
AddButton("🚀 Bang Player (AutoFollow)", BangSystem)
AddButton("🛸 Toggle Fly", function() flyToggle = not flyToggle Fly() end)
AddButton("🎯 Enable ESP", ESP)
AddButton("❌ إغلاق السكربت", function() ScreenGui:Destroy() end)

-- تحكم بالسحب والتصغير
local dragging, dragInput, dragStart, startPos
Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- نهاية السكربت
