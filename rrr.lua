-- Elite V5 PRO 2025 - تعديل Face Bang إلى Bang (من وراء اللاعب الهدف) مع noclip وبطء حركة محسّن

pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

local EliteMenu = Instance.new("ScreenGui")
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false
EliteMenu.Parent = game.CoreGui

local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
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

-- إنشاء الواجهة الرئيسية
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 520, 0, 580)
frame.Position = UDim2.new(0.5, -260, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(70, 0, 130)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable
