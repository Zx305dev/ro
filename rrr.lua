-- ELITE V1 - PURPLE GUI SCRIPT
-- Made for Executors (Synapse X, KRNL, Fluxus...)

-- Anti-double instance
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- Create GUI
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false

local frame = Instance.new("Frame", EliteMenu)
frame.Name = "MainFrame"
frame.BackgroundColor3 = Color3.fromRGB(85, 0, 127)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.Size = UDim2.new(0.25, 0, 0.5, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local UICorner = Instance.new("UICorner", frame)
UICorner.CornerRadius = UDim.new(0, 8)

local buttons = {
	{"Speed", function()
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
	end},
	{"Jump", function()
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = 150
	end},
	{"Fly", function()
		-- Simple basic fly
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
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
				move = move + workspace.CurrentCamera.CFrame.LookVector
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
				move = move - workspace.CurrentCamera.CFrame.LookVector
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
				move = move - workspace.CurrentCamera.CFrame.RightVector
			end
			if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
				move = move + workspace.CurrentCamera.CFrame.RightVector
			end
			bv.Velocity = move * 75
		end)

		wait(10)
		bv:Destroy()
		conn:Disconnect()
	end},
	{"Invisible", function()
		for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
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

-- Create Buttons
for i, btn in ipairs(buttons) do
	local b = Instance.new("TextButton", frame)
	b.Name = btn[1].."Btn"
	b.Text = btn[1]
	b.Size = UDim2.new(0.8, 0, 0.1, 0)
	b.Position = UDim2.new(0.1, 0, 0.05 + (i-1)*0.13, 0)
	b.BackgroundColor3 = Color3.fromRGB(120, 0, 170)
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.MouseButton1Click:Connect(btn[2])

	local ui = Instance.new("UICorner", b)
	ui.CornerRadius = UDim.new(0, 4)
end

-- Optional: M to show/hide
local UIS = game:GetService("UserInputService")
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.M then
		frame.Visible = not frame.Visible
	end
end)
