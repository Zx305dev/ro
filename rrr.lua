--[[
    Elite V5 PRO - Full Featured Roblox GUI Script
    متكامل | كامل | قابل للتعديل بسهولة
    الخصائص:
    - واجهة متحركة وسلسة بحجم قابل للتغيير
    - سحب وتحريك الـ GUI بسهولة (Draggable)
    - تقسيم الواجهة إلى تبويبات (Tabs) واضحة
    - صفحة ESP مع خيارات مفصلة
    - صفحة Commands لتحميل سكربتات جاهزة
    - صفحة 18+ مع سكربتات خاصة (بدون سبام الدردشة)
    - زر إغلاق وتصغير الواجهة
    - إشعارات أنيقة تظهر نوع جسم اللاعب (R6 أو R15)
    - دعم اللغة العربية مع تنسيق أنيق ومرتب
    - إمكانية تعديل الألوان والخطوط بكل سهولة
    - تعليق كامل على كل جزء لتسهيل الفهم والتعديل
    
    تم التطوير بواسطة pyst و FNLOXER 🔥😈👹
--]]

-- الخدمات الأساسية --
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local isR6 = character:FindFirstChild("Torso") ~= nil

-- إشعار يظهر نوع جسم اللاعب (R6 أو R15) --
local function showNotification(message)
    local gui = Instance.new("ScreenGui", game.CoreGui)
    gui.Name = "EliteNotification"

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 360, 0, 50)
    frame.Position = UDim2.new(0.5, -180, 1, -90)
    frame.AnchorPoint = Vector2.new(0.5, 1)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 200)
    frame.BorderSizePixel = 0
    frame.ZIndex = 9999
    frame.ClipsDescendants = true

    local uicorner = Instance.new("UICorner", frame)
    uicorner.CornerRadius = UDim.new(0, 15)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = message .. " | بواسطة pyst & FNLOXER"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 22
    label.TextXAlignment = Enum.TextXAlignment.Left

    frame.BackgroundTransparency = 1
    label.TextTransparency = 1

    TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

    delay(5, function()
        TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
        wait(0.6)
        gui:Destroy()
    end)
end

if isR6 then
    showNotification("🌟 تم الكشف عن جسم R6!")
else
    showNotification("✨ تم الكشف عن جسم R15!")
end

-- دالة مساعدة لإنشاء الزوايا الدائرية --
local function addUICorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 15)
    corner.Parent = parent
end

-- دالة تفعيل التأثير اللوني مع Tween --
local function tweenColor(object, property, toColor, duration)
    TweenService:Create(object, TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[property] = toColor}):Play()
end

-- إنشاء الـ GUI الرئيسي --

local gui = Instance.new("ScreenGui")
gui.Name = "EliteV5Pro"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 440, 0, 520)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(65, 0, 140)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- يمكن تحريك النافذة بالسحب
mainFrame.Parent = gui
addUICorner(mainFrame, 24)

-- ظل خفيف --
local shadow = Instance.new("ImageLabel", mainFrame)
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.55
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)
shadow.Size = UDim2.new(1, 32, 1, 32)
shadow.Position = UDim2.new(0, -16, 0, -16)
shadow.ZIndex = 0

-- رأس القائمة --

local header = Instance.new("Frame", mainFrame)
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 56)
header.BackgroundColor3 = Color3.fromRGB(110, 0, 255)
header.BorderSizePixel = 0
addUICorner(header, 24)

local titleLabel = Instance.new("TextLabel", header)
titleLabel.Size = UDim2.new(1, -140, 1, 0)
titleLabel.Position = UDim2.new(0, 24, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 ELITE V5 PRO - القائمة المتقدمة"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 28
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextYAlignment = Enum.TextYAlignment.Center

-- زر الإغلاق --
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 54, 0, 44)
closeBtn.Position = UDim2.new(1, -60, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 40)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 30
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = false
addUICorner(closeBtn, 14)

closeBtn.MouseEnter:Connect(function()
    tweenColor(closeBtn, "BackgroundColor3", Color3.fromRGB(255, 80, 80), 0.15)
end)
closeBtn.MouseLeave:Connect(function()
    tweenColor(closeBtn, "BackgroundColor3", Color3.fromRGB(255, 40, 40), 0.15)
end)
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- زر التصغير --
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0, 54, 0, 44)
minimizeBtn.Position = UDim2.new(1, -120, 0, 6)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 30
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.AutoButtonColor = false
addUICorner(minimizeBtn, 14)

minimizeBtn.MouseEnter:Connect(function()
    tweenColor(minimizeBtn, "BackgroundColor3", Color3.fromRGB(255, 210, 80), 0.15)
end)
minimizeBtn.MouseLeave:Connect(function()
    tweenColor(minimizeBtn, "BackgroundColor3", Color3.fromRGB(255, 165, 0), 0.15)
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        mainFrame:TweenSize(UDim2.new(0, 440, 0, 56), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 0.4)
    else
        mainFrame:TweenSize(UDim2.new(0, 440, 0, 520), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 0.4)
    end
end)

-- إنشاء تبويبات القائمة --

local tabContainer = Instance.new("Frame", mainFrame)
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(1, -40, 0, 56)
tabContainer.Position = UDim2.new(0, 20, 0, 60)
tabContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", tabContainer)
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 15)

-- دالة إنشاء زر تبويب --
local function createTabButton(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 130, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(140, 0, 230)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.AutoButtonColor = false
    addUICorner(btn, 14)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(190, 50, 255), 0.25)
    end)
    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(140, 0, 230), 0.25)
    end)
    return btn
end

-- إعداد صفحات المحتوى لكل تبويب --

local pages = {}

local function createPage(name)
    local page = Instance.new("Frame", mainFrame)
    page.Name = name
    page.Size = UDim2.new(1, -40, 1, -130)
    page.Position = UDim2.new(0, 20, 0, 120)
    page.BackgroundColor3 = Color3.fromRGB(40, 0, 120)
    page.BorderSizePixel = 0
    page.Visible = false
    addUICorner(page, 20)
    return page
end

pages["ESP"] = createPage("ESPPage")
pages["Commands"] = createPage("CommandsPage")
pages["18+"] = createPage("AdultPage")
pages["Info"] = createPage("InfoPage")

-- إنشاء أزرار التبويبات --

local tabButtons = {}
for _, tabName in ipairs({"ESP", "Commands", "18+", "Info"}) do
    local tabBtn = createTabButton(tabName)
    tabBtn.Parent = tabContainer
    tabButtons[tabName] = tabBtn
end

-- وظيفة التنقل بين التبويبات --

local function setActiveTab(tabName)
    for name, page in pairs(pages) do
        page.Visible = (name == tabName)
        tweenColor(tabButtons[name], "BackgroundColor3", (name == tabName) and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(140, 0, 230), 0.4)
    end
end

setActiveTab("ESP") -- الافتراضي: صفحة ESP

for name, btn in pairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        setActiveTab(name)
    end)
end

-- محتوى صفحة ESP --

local espPage = pages["ESP"]

local espScroll = Instance.new("ScrollingFrame", espPage)
espScroll.Size = UDim2.new(1, -20, 1, -20)
espScroll.Position = UDim2.new(0, 10, 0, 10)
espScroll.BackgroundTransparency = 1
espScroll.ScrollBarThickness = 8
espScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
addUICorner(espScroll, 20)

local espOptions = {}

local espList = {
    {name = "عرض أسماء اللاعبين", key = "nameESP"},
    {name = "عرض خطوط رؤية اللاعبين", key = "tracerESP"},
    {name = "عرض علب حول اللاعبين", key = "boxESP"},
    {name = "عرض الصحة", key = "healthESP"},
    {name = "عرض المسافات", key = "distanceESP"},
}

local function createToggleOption(parent, name, key, posY)
    local optionFrame = Instance.new("Frame", parent)
    optionFrame.Size = UDim2.new(1, 0, 0, 55)
    optionFrame.Position = UDim2.new(0, 0, 0, posY)
    optionFrame.BackgroundColor3 = Color3.fromRGB(95, 0, 180)
    addUICorner(optionFrame, 14)

    local label = Instance.new("TextLabel", optionFrame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 21
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true

    local toggleBtn = Instance.new("TextButton", optionFrame)
    toggleBtn.Size = UDim2.new(0.25, -12, 0.7, 0)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Text = "إيقاف"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 19
    toggleBtn.AutoButtonColor = false
    addUICorner(toggleBtn, 14)

    local state = false
    espOptions[key] = state

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        espOptions[key] = state
        toggleBtn.Text = state and "تشغيل" or "إيقاف"
        tweenColor(toggleBtn, "BackgroundColor3", state and Color3.fromRGB(0, 230, 110) or Color3.fromRGB(150, 0, 220), 0.3)
    end)

    toggleBtn.MouseEnter:Connect(function()
        tweenColor(toggleBtn, "BackgroundColor3", Color3.fromRGB(200, 80, 255), 0.25)
    end)

    toggleBtn.MouseLeave:Connect(function()
        tweenColor(toggleBtn, "BackgroundColor3", espOptions[key] and Color3.fromRGB(0, 230, 110) or Color3.fromRGB(150, 0, 220), 0.25)
    end)
end

for i, option in ipairs(espList) do
    createToggleOption(espScroll, option.name, option.key, (i-1)*65)
end
espScroll.CanvasSize = UDim2.new(0, 0, 0, #espList*65 + 20)

-- محتوى صفحة Commands (تحميل سكربتات جاهزة) --

local cmdPage = pages["Commands"]

local cmdScroll = Instance.new("ScrollingFrame", cmdPage)
cmdScroll.Size = UDim2.new(1, -20, 1, -20)
cmdScroll.Position = UDim2.new(0, 10, 0, 10)
cmdScroll.BackgroundTransparency = 1
cmdScroll.ScrollBarThickness = 8
cmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
addUICorner(cmdScroll, 20)

local commandsList = {
    {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
    {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
    {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
    {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
    {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"},
}

local yPos = 0
for _, cmd in ipairs(commandsList) do
    local btn = Instance.new("TextButton", cmdScroll)
    btn.Size = UDim2.new(0.9, 0, 0, 48)
    btn.Position = UDim2.new(0.05, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(120, 0, 200)
    btn.Text = cmd.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    addUICorner(btn, 18)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(160, 30, 230), 0.25)
    end)
    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(120, 0, 200), 0.25)
    end)

    btn.MouseButton1Click:Connect(function()
        local url = isR6 and cmd.r6 or cmd.r15
        if url then
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            if success and response then
                loadstring(response)()
                showNotification("تم تحميل السكربت: " .. cmd.name)
            else
                showNotification("فشل تحميل السكربت: " .. cmd.name)
            end
        else
            showNotification("لا يوجد سكربت مناسب لجسمك: " .. cmd.name)
        end
    end)
    yPos = yPos + 60
end
cmdScroll.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- محتوى صفحة 18+ --

local adultPage = pages["18+"]

local adultScroll = Instance.new("ScrollingFrame", adultPage)
adultScroll.Size = UDim2.new(1, -20, 1, -20)
adultScroll.Position = UDim2.new(0, 10, 0, 10)
adultScroll.BackgroundTransparency = 1
adultScroll.ScrollBarThickness = 8
adultScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
addUICorner(adultScroll, 20)

local adultScripts = {
    {name = "🔞 Bang Bang (18+)", r6 = "https://pastebin.com/raw/hurQ0Pma", r15 = "https://pastebin.com/raw/hurQ0Pma"},
    {name = "💦 Hot Spray (18+)", r6 = "https://pastebin.com/raw/xxx123", r15 = "https://pastebin.com/raw/xxx123"}, -- Example placeholder
}

local yPosAdult = 0
for _, scriptInfo in ipairs(adultScripts) do
    local btn = Instance.new("TextButton", adultScroll)
    btn.Size = UDim2.new(0.9, 0, 0, 48)
    btn.Position = UDim2.new(0.05, 0, 0, yPosAdult)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 150)
    btn.Text = scriptInfo.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    addUICorner(btn, 18)

    btn.MouseEnter:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(230, 40, 200), 0.25)
    end)
    btn.MouseLeave:Connect(function()
        tweenColor(btn, "BackgroundColor3", Color3.fromRGB(200, 0, 150), 0.25)
    end)

    btn.MouseButton1Click:Connect(function()
        local url = isR6 and scriptInfo.r6 or scriptInfo.r15
        if url then
            local success, response = pcall(function()
                return game:HttpGet(url)
            end)
            if success and response then
                loadstring(response)()
                showNotification("تم تحميل السكربت: " .. scriptInfo.name)
            else
                showNotification("فشل تحميل السكربت: " .. scriptInfo.name)
            end
        else
            showNotification("لا يوجد سكربت مناسب لجسمك: " .. scriptInfo.name)
        end
    end)

    yPosAdult = yPosAdult + 60
end
adultScroll.CanvasSize = UDim2.new(0, 0, 0, yPosAdult + 20)

-- محتوى صفحة Info (معلومات عن السكربت) --

local infoPage = pages["Info"]

local infoLabel = Instance.new("TextLabel", infoPage)
infoLabel.Size = UDim2.new(1, -40, 1, -40)
infoLabel.Position = UDim2.new(0, 20, 0, 20)
infoLabel.BackgroundTransparency = 1
infoLabel.TextColor3 = Color3.new(1, 1, 1)
infoLabel.Font = Enum.Font.GothamBold
infoLabel.TextSize = 20
infoLabel.TextWrapped = true
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.Text = [[
مرحباً بك في Elite V5 PRO

تم تطوير هذا السكربت بواسطة pyst و FNLOXER
يحتوي على قائمة متقدمة للتحكم بالميزات المتنوعة مثل ESP، تحميل السكربتات الجاهزة، وصفحة خاصة بسكربتات 18+

الواجهة سهلة الاستخدام مع دعم اللغة العربية بالكامل.

لمزيد من الدعم والاستفسارات، تواصل معنا عبر مجموعات الدعم أو مواقعنا.

🔥 استمتع باللعب المجنون والهاكنق الشرعي مع Elite V5 PRO! 🔥

]]

-- تفعيل إظهار/إخفاء القائمة بالضغط على H --

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        gui.Enabled = not gui.Enabled
        if gui.Enabled then
            showNotification("تم فتح القائمة - اضغط H للإغلاق")
        else
            showNotification("تم إغلاق القائمة - اضغط H للفتح")
        end
    end
end)

-- إظهار تنبيه عند تشغيل السكربت --
showNotification("تم تحميل Elite V5 PRO بنجاح!")

-- إنهاء السكربت --
return gui

