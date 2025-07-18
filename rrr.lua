--[[
🔥 Elite V5 PRO 2025 - الإصدار المحسّن 🔥
GUI كامل متكامل + صفحات + تأثيرات + Bang خلف الهدف + Noclip + سرعة + معلومات حية
--]]

-- تنظيف المينيو السابق لو كان موجود
pcall(function()
    game.CoreGui:FindFirstChild("EliteMenu"):Destroy()
end)

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- GUI الأساسية
local EliteMenu = Instance.new("ScreenGui", game.CoreGui)
EliteMenu.Name = "EliteMenu"
EliteMenu.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame", EliteMenu)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.05
MainFrame.Visible = true

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(255, 255, 255)
UIStroke.Thickness = 1.2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- عنوان المينيو
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "🔥 Elite V5 PRO 🔥"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)

-- قائمة الصفحات
local TabButtons = {}
local Pages = {}
local Tabs = {"🏹 الأسلحة", "👤 اللاعب", "🚗 المركبة", "📡 الإكسبلويت", "👁️ العرض"}

local function createTabButton(name, index)
    local button = Instance.new("TextButton", MainFrame)
    button.Size = UDim2.new(0, 100, 0, 30)
    button.Position = UDim2.new(0, 10 + (index - 1) * 110, 0, 40)
    button.Text = name
    button.Font = Enum.Font.Gotham
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    button.BorderSizePixel = 0

    local corner = Instance.new("UICorner", button)
    corner.CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        for i, page in pairs(Pages) do
            page.Visible = false
            TabButtons[i].BackgroundColor3 = Color3.fromRGB(55, 55, 65)
        end
        Pages[index].Visible = true
        button.BackgroundColor3 = Color3.fromRGB(85, 85, 110)
    end)

    return button
end

for i, tabName in ipairs(Tabs) do
    TabButtons[i] = createTabButton(tabName, i)

    local page = Instance.new("Frame", MainFrame)
    page.Size = UDim2.new(1, -20, 1, -90)
    page.Position = UDim2.new(0, 10, 0, 80)
    page.BackgroundTransparency = 1
    page.Visible = (i == 1)
    Pages[i] = page
end

-- التالي: بناء صفحات الأدوات الداخلية (أسلحة، اللاعب، الخ) مع الوظائف الفعلية
-- 🔥 استعد للقادم... كل زر بيكون فيه كود تنفيذي من مستوى محترف
