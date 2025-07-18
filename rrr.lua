-- // Elite Menu by FNLOXER - v5 Custom GUI //

-- Anti-double instance
pcall(function() game.CoreGui:FindFirstChild("EliteMenu"):Destroy() end)

-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI BASE
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteMenu"
EliteMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
EliteMenu.ResetOnSpawn = false

-- DRAG FUNCTION
local function dragify(Frame)
	local dragToggle = nil
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	RunService.Heartbeat:Connect(function()
		if dragToggle and dragInput then
			updateInput(dragInput)
		end
	end)
end

-- MAIN FRAME
local Main = Instance.new("Frame", EliteMenu)
Main.Name = "Main"
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Main.Position = UDim2.new(0.35, 0, 0.3, 0)
Main.Size = UDim2.new(0, 420, 0, 300)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = false
dragify(Main)

-- TITLE
local Title = Instance.new("TextLabel", Main)
Title.Name = "Title"
Title.Text = "🔥 ELITE MENU V5 🔥"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 20
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1

-- TABS
local Tabs = Instance.new("Frame", Main)
Tabs.Name = "Tabs"
Tabs.Size = UDim2.new(1,0,0,30)
Tabs.Position = UDim2.new(0,0,0,30)
Tabs.BackgroundTransparency = 1

local TabLayout = Instance.new("UIListLayout", Tabs)
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0,6)

-- PAGES
local Pages = Instance.new("Folder", Main)
Pages.Name = "Pages"
Pages.Position = UDim2.new(0, 0, 0, 60)

-- FUNCTION: Create Tab Button
local function createTab(name)
	local btn = Instance.new("TextButton", Tabs)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	return btn
end

-- FUNCTION: Create Page
local function createPage()
	local page = Instance.new("ScrollingFrame", Pages)
	page.Size = UDim2.new(1, 0, 1, -60)
	page.Position = UDim2.new(0, 0, 0, 60)
	page.CanvasSize = UDim2.new(0, 0, 2, 0)
	page.ScrollBarThickness = 3
	page.Visible = false

	local layout = Instance.new("UIListLayout", page)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 5)

	return page
end

-- FUNCTION: Create Button
local function createButton(parent, name, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 400, 0, 35)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderSizePixel = 0

	btn.MouseButton1Click:Connect(callback)
end

-- ============ TABS & PAGES =============

local tabMain = createTab("👤 Main")
local pageMain = createPage()

local tabESP = createTab("👁️ ESP")
local pageESP = createPage()

local tabTroll = createTab("🔞 18+")
local pageTroll = createPage()

local AllPages = {
	[tabMain] = pageMain,
	[tabESP] = pageESP,
	[tabTroll] = pageTroll
}

for tab, page in pairs(AllPages) do
	tab.MouseButton1Click:Connect(function()
		for _, p in pairs(Pages:GetChildren()) do
			p.Visible = false
		end
		page.Visible = true
	end)
end

pageMain.Visible = true

-- ========== MAIN PAGE ==========
createButton(pageMain, "Show Player Info", function()
	local name = LocalPlayer.Name
	local model = LocalPlayer.Character and LocalPlayer.Character.Name or "No Character"
	local health = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health or 0
	game.StarterGui:SetCore("SendNotification", {
		Title = "Player Info",
		Text = "👤 "..name.."\n🧍 "..model.."\n❤️ "..math.floor(health),
		Duration = 6
	})
end)

createButton(pageMain, "ESP Toggle", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/gu5KkFHp"))()
end)

-- ========== ESP PAGE ==========
createButton(pageESP, "🧠 WallHack (Basic)", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/V1ZFgVt4"))()
end)

createButton(pageESP, "💡 Name ESP", function()
	loadstring(game:HttpGet("https://pastebin.com/raw/Cb0SYyyK"))()
end)

-- ========== TROLL 18+ PAGE ==========

local buttons18 = {
    {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
    {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
    {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
    {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
    {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
}

for _, btn in pairs(buttons18) do
    createButton(pageTroll, btn.name, function()
        local rigType = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("Humanoid").RigType == Enum.HumanoidRigType.R6) and "r6" or "r15"
        local scriptUrl = btn[rigType]
        loadstring(game:HttpGet(scriptUrl))()
    end)
end
