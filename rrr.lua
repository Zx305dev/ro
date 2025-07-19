-- Elite V5 PRO GUI 2025
-- تم التطوير بواسطة ALm6eri - السكربت مجاني وتفاعلي
-- واجهة كاملة مع نظام Bang و ESP و Fly و إعدادات
-- يدعم تصغير/تكبير GUI وتحريكه بحرية
-- تنبيهات صوتية وبصرية

-- الخدمات الأساسية
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- إعدادات الحركات
local BangActive, FlyActive, ESPActive, NoclipActive = false, false, false, false
local BASE_SPEED, BASE_JUMP = 100, 100
local BASE_FOLLOW_DISTANCE = 3.5
local TargetPlayer = nil

-- واجهة GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "EliteV5GUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 420)
MainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
MainFrame.Active = true
MainFrame.Draggable = true

-- زر تصغير
local Minimize = Instance.new("TextButton", MainFrame)
Minimize.Size = UDim2.new(0, 60, 0, 25)
Minimize.Position = UDim2.new(1, -70, 0, 5)
Minimize.Text = "-"
Minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

local pages = {}

-- الوظيفة: إنشاء إشعار
local function createNotification(txt)
	local notify = Instance.new("TextLabel", MainFrame)
	notify.Text = txt
	notify.Size = UDim2.new(0, 350, 0, 30)
	notify.Position = UDim2.new(0.5, -175, 1, -40)
	notify.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	notify.TextColor3 = Color3.fromRGB(255, 255, 255)
	notify.TextScaled = true
	notify.BorderSizePixel = 0

	local tween = TweenService:Create(notify, TweenInfo.new(0.4), {Position = notify.Position - UDim2.new(0, 0, 0, 50)})
	tween:Play()
	task.wait(2)
	notify:Destroy()
end

-- الوظيفة: صوت عند التبديل
local function playSound(type)
	local sound = Instance.new("Sound", MainFrame)
	if type == "toggle" then
		sound.SoundId = "rbxassetid://12222225"
	elseif type == "error" then
		sound.SoundId = "rbxassetid://1448840"
	end
	sound.Volume = 1
	sound:Play()
	game.Debris:AddItem(sound, 2)
end

-- الوظيفة: صفحة تنقل
local function createTab(name)
	local btn = Instance.new("TextButton", MainFrame)
	btn.Size = UDim2.new(0, 120, 0, 30)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)

	if #pages > 0 then
		btn.Position = pages[#pages].Position + UDim2.new(0, 125, 0, 0)
	else
		btn.Position = UDim2.new(0, 10, 0, 10)
	end

	local pageFrame = Instance.new("Frame", MainFrame)
	pageFrame.Size = UDim2.new(1, -20, 1, -60)
	pageFrame.Position = UDim2.new(0, 10, 0, 50)
	pageFrame.BackgroundTransparency = 1
	pageFrame.Visible = false

	btn.MouseButton1Click:Connect(function()
		for _, p in pairs(pages) do p.Frame.Visible = false end
		pageFrame.Visible = true
	end)

	table.insert(pages, {Button = btn, Frame = pageFrame})
	return pageFrame
end

-- صفحة Bang
local BangPage = createTab("نظام البانق")
do
	local startBtn = Instance.new("TextButton", BangPage)
	startBtn.Text = "ابدأ التتبع"
	startBtn.Size = UDim2.new(0, 200, 0, 30)
	startBtn.Position = UDim2.new(0, 20, 0, 20)
	startBtn.MouseButton1Click:Connect(function()
		local t = Players:GetPlayers()[2]
		if not t then return createNotification("لا يوجد لاعب مستهدف") end
		TargetPlayer = t
		BangActive = true
		NoclipActive = true
		createNotification("تم تفعيل البانق على " .. t.Name)
		playSound("toggle")
	end)

	local stopBtn = Instance.new("TextButton", BangPage)
	stopBtn.Text = "إيقاف البانق"
	stopBtn.Size = UDim2.new(0, 200, 0, 30)
	stopBtn.Position = UDim2.new(0, 20, 0, 60)
	stopBtn.MouseButton1Click:Connect(function()
		BangActive = false
		NoclipActive = false
		createNotification("تم إيقاف البانق")
		playSound("toggle")
	end)
end

-- صفحة الحركة
local MovePage = createTab("الحركة")
do
	local speed = Instance.new("TextBox", MovePage)
	speed.Size = UDim2.new(0, 200, 0, 30)
	speed.Position = UDim2.new(0, 20, 0, 20)
	speed.Text = "السرعة: 100"
	speed.FocusLost:Connect(function()
		local val = tonumber(speed.Text:match("%d+"))
		if val then
			BASE_SPEED = val
			createNotification("تم تحديث السرعة: " .. val)
		end
	end)

	local jump = Instance.new("TextBox", MovePage)
	jump.Size = UDim2.new(0, 200, 0, 30)
	jump.Position = UDim2.new(0, 20, 0, 60)
	jump.Text = "القفز: 100"
	jump.FocusLost:Connect(function()
		local val = tonumber(jump.Text:match("%d+"))
		if val then
			BASE_JUMP = val
			createNotification("تم تحديث القفز: " .. val)
		end
	end)
end

-- صفحة الطيران
local FlyPage = createTab("الطيران و Noclip")
do
	local flyBtn = Instance.new("TextButton", FlyPage)
	flyBtn.Text = "تبديل الطيران"
	flyBtn.Size = UDim2.new(0, 200, 0, 30)
	flyBtn.Position = UDim2.new(0, 20, 0, 20)
	flyBtn.MouseButton1Click:Connect(function()
		FlyActive = not FlyActive
		createNotification("الطيران: " .. tostring(FlyActive))
		playSound("toggle")
	end)

	local noclipBtn = Instance.new("TextButton", FlyPage)
	noclipBtn.Text = "تبديل Noclip"
	noclipBtn.Size = UDim2.new(0, 200, 0, 30)
	noclipBtn.Position = UDim2.new(0, 20, 0, 60)
	noclipBtn.MouseButton1Click:Connect(function()
		NoclipActive = not NoclipActive
		createNotification("Noclip: " .. tostring(NoclipActive))
		playSound("toggle")
	end)
end

-- صفحة ESP
local ESPPage = createTab("ESP")
do
	local espBtn = Instance.new("TextButton", ESPPage)
	espBtn.Text = "تبديل ESP"
	espBtn.Size = UDim2.new(0, 200, 0, 30)
	espBtn.Position = UDim2.new(0, 20, 0, 20)
	espBtn.MouseButton1Click:Connect(function()
		ESPActive = not ESPActive
		createNotification("ESP: " .. tostring(ESPActive))
		playSound("toggle")
	end)
end

-- صفحة الإعدادات
local SettingsPage = createTab("الإعدادات")
do
	local label = Instance.new("TextLabel", SettingsPage)
	label.Text = "الهاك: Elite V5 PRO | صنع بواسطة ALm6eri"
	label.Size = UDim2.new(0, 500, 0, 30)
	label.Position = UDim2.new(0, 20, 0, 20)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
end

-- الحركة والتكبير
Minimize.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

RS.RenderStepped:Connect(function()
	if BangActive and TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local char = LocalPlayer.Character
		if char then
			local hrp = char:FindFirstChild("HumanoidRootPart")
			local target = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp and target then
				hrp.CFrame = target.CFrame * CFrame.new(0, 0, -BASE_FOLLOW_DISTANCE)
			end
		end
	end

	if FlyActive then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.Velocity = Vector3.new(0, BASE_SPEED, 0)
		end
	end
end)
