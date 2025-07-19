--[[  
	🌌 Elite Hack System 2025 - Final Edition
	🟣 Theme: Purple | ✨ Pages UI | 😈 Full Bang + Utilities
	🛡️ Stable. Modular. No Errors.
	Made by: Alm6eri 🔥🔥  
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = workspace.CurrentCamera

-- Variables
local BangTarget = nil
local BangActive = false
local NoclipActive = false
local FlyActive = false
local SpeedActive = false
local JumpBoost = false
local FlySpeed = 2
local UI = Instance.new("ScreenGui", game.CoreGui)
UI.Name = "EliteSystem2025_UI"

-- GUI Setup
function CreateButton(text, parent, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(90, 30, 140)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- Main Frame
local MainFrame = Instance.new("Frame", UI)
MainFrame.Size = UDim2.new(0, 400, 0, 320)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
MainFrame.BorderSizePixel = 0

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(150, 0, 255)
UIStroke.Thickness = 2

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "Elite Hack System 2025 | by Alm6eri"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Page container
local Pages = {}
local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 120, 1, -40)
TabFrame.Position = UDim2.new(0, 0, 0, 40)
TabFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 40)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -120, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 100)

-- Pages
local function CreatePage(name)
	local btn = CreateButton(name, TabFrame, function()
		for _, v in pairs(Pages) do v.Visible = false end
		Pages[name].Visible = true
	end)
	local frame = Instance.new("Frame", ContentFrame)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
	Pages[name] = frame
end

-- Bang Page
CreatePage("Bang")
CreatePage("Player")
CreatePage("Info")

-- Bang Tab
do
	local page = Pages["Bang"]

	local dropdown = Instance.new("TextBox", page)
	dropdown.Size = UDim2.new(0.8, 0, 0, 30)
	dropdown.Position = UDim2.new(0.1, 0, 0.05, 0)
	dropdown.PlaceholderText = "Enter Player Name"
	dropdown.Text = ""
	dropdown.BackgroundColor3 = Color3.fromRGB(90, 0, 130)
	dropdown.TextColor3 = Color3.new(1, 1, 1)

	CreateButton("Activate Bang", page, function()
		local target = Players:FindFirstChild(dropdown.Text)
		if target and target.Character then
			BangTarget = target
			BangActive = true
			NoclipActive = true
		end
	end).Position = UDim2.new(0.1, 0, 0.2, 0)

	CreateButton("Deactivate", page, function()
		BangActive = false
		NoclipActive = false
	end).Position = UDim2.new(0.1, 0, 0.3, 0)
end

-- Player Hacks Page
do
	local page = Pages["Player"]
	CreateButton("Fly Toggle", page, function()
		FlyActive = not FlyActive
	end)

	CreateButton("Speed Boost", page, function()
		SpeedActive = not SpeedActive
	end)

	CreateButton("Jump Boost", page, function()
		JumpBoost = not JumpBoost
	end)

	CreateButton("Toggle Noclip", page, function()
		NoclipActive = not NoclipActive
	end)

	CreateButton("Close UI", page, function()
		UI:Destroy()
	end)
end

-- Info Page
do
	local page = Pages["Info"]
	local lbl1 = Instance.new("TextLabel", page)
	lbl1.Text = "Player: " .. LP.Name
	lbl1.Size = UDim2.new(1, 0, 0, 30)
	lbl1.BackgroundTransparency = 1
	lbl1.TextColor3 = Color3.new(1, 1, 1)

	local lbl2 = Instance.new("TextLabel", page)
	lbl2.Text = "Game: " .. tostring(game.Name or "Unknown")
	lbl2.Position = UDim2.new(0, 0, 0.1, 0)
	lbl2.Size = UDim2.new(1, 0, 0, 30)
	lbl2.BackgroundTransparency = 1
	lbl2.TextColor3 = Color3.new(1, 1, 1)
end

-- Movement Logic
RunService.RenderStepped:Connect(function()
	if BangActive and BangTarget and BangTarget.Character and LP.Character then
		local you = LP.Character:FindFirstChild("HumanoidRootPart")
		local them = BangTarget.Character:FindFirstChild("HumanoidRootPart")
		if you and them then
			local offset = Vector3.new(0, 0, -2 + math.sin(tick() * 3))
			you.CFrame = them.CFrame * CFrame.new(offset)
		end
	end

	if NoclipActive and LP.Character then
		for _, part in pairs(LP.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end

	if FlyActive and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
		local HRP = LP.Character.HumanoidRootPart
		HRP.Velocity = Camera.CFrame.LookVector * FlySpeed * 10
	end

	if SpeedActive and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
		LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 50
	else
		if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
			LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
		end
	end

	if JumpBoost and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
		LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = 120
	else
		if LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
			LP.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
		end
	end
end)
