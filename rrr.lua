-- Elite Bang + NoClip + Emote integrated script for Roblox
-- By Your Expert AI Rebel, tuned for max power and smooth UX
-- Features:
-- - Bang system with behind-target follow
-- - Auto NoClip while Bang active to prevent collisions
-- - Auto play emote (Dolphin Dance or customizable)
-- - Emote menu UI integrated & toggleable
-- - Notifications & performance safe loops

-- Services and Core Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local StarterGui = game:GetService("StarterGui")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- CONFIGURATION --
local EMOTE_NAME = "Dolphin Dance" -- The emote to play on Bang toggle ON (can be changed)
local EMOTE_ID = 5938365243 -- Roblox Asset ID for Dolphin Dance emote (confirm this ID in your game)

-- Bang and NoClip State
local BangActive = false
local NoClipActive = false

-- Target Player Variable (player to Bang behind)
local BangTarget = nil

-- UI Setup --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EliteBangNoClipGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 120, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 100)
ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Text = "Toggle Bang"
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextScaled = true
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.AutoButtonColor = true
ToggleButton.ClipsDescendants = true
ToggleButton.BorderSizePixel = 0

-- Notification helper function
local function Notify(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5
    })
end

-- NoClip Functionality
local function setNoClip(state)
    NoClipActive = state
    local character = LocalPlayer.Character
    if not character then return end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- When NoClip is active, set CanCollide false on all parts
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not state
        end
    end

    if state then
        Notify("NoClip", "NoClip enabled", 3)
    else
        Notify("NoClip", "NoClip disabled", 3)
    end
end

-- Emote Playing Function (plays Roblox emote by ID)
local function playEmoteById(emoteId)
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local success, animTrack = pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://" .. tostring(emoteId)
        local track = humanoid:LoadAnimation(anim)
        track:Play()
        return track
    end)
    
    if not success then
        Notify("Emote Error", "Failed to play emote", 5)
    else
        Notify("Emote", "Playing emote: " .. tostring(EMOTE_NAME), 3)
    end
end

-- Bang Functionality: Follow Target From Behind
local function bangFollow(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    local localHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP or not localHRP then return end

    -- Position offset behind target (2 studs behind, slightly down for ground clearance)
    local offsetDistance = 2
    local targetCFrame = targetHRP.CFrame
    local behindPos = targetCFrame.Position - targetCFrame.LookVector * offsetDistance
    local desiredCFrame = CFrame.new(behindPos.X, behindPos.Y, behindPos.Z, targetCFrame.LookVector.X, targetCFrame.LookVector.Y, targetCFrame.LookVector.Z)

    -- Smoothly move LocalPlayer's HumanoidRootPart behind target
    localHRP.CFrame = CFrame.new(behindPos.X, behindPos.Y, behindPos.Z) * CFrame.Angles(0, math.atan2(targetCFrame.LookVector.X, targetCFrame.LookVector.Z), 0)
end

-- Bang toggle toggle function
local function toggleBang()
    BangActive = not BangActive
    if BangActive then
        -- Select target player nearest to mouse or nearest player excluding self
        local nearestDist = math.huge
        local nearestPlayer = nil
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = plr
                end
            end
        end
        
        if nearestPlayer then
            BangTarget = nearestPlayer
            setNoClip(true) -- Activate NoClip with Bang ON
            playEmoteById(EMOTE_ID) -- Play Dolphin Dance or selected emote
            Notify("Bang Mode", "Activated behind " .. BangTarget.Name, 5)
        else
            Notify("Bang Mode", "No valid target found!", 5)
            BangActive = false
            setNoClip(false)
        end
    else
        BangTarget = nil
        setNoClip(false) -- Disable NoClip when Bang OFF
        Notify("Bang Mode", "Deactivated", 3)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleBang)

-- Main RunService loop to update Bang follow position if active
RunService.Heartbeat:Connect(function()
    if BangActive and BangTarget then
        -- Check if target is still valid
        if BangTarget.Character and BangTarget.Character:FindFirstChild("HumanoidRootPart") then
            bangFollow(BangTarget)
        else
            -- Target lost, turn Bang off
            BangActive = false
            BangTarget = nil
            setNoClip(false)
            Notify("Bang Mode", "Target lost, Bang off", 5)
        end
    end
end)

-- Emote Menu UI Integration
-- The following is an extremely simplified emote toggle to open your Emote GUI
-- You can replace this with the full emote script you posted for a full-featured emote menu.

local function openEmoteMenu()
    -- Toggle your full Emote UI here
    if CoreGui:FindFirstChild("Emotes") then
        CoreGui.Emotes.Enabled = not CoreGui.Emotes.Enabled
        Notify("Emotes", CoreGui.Emotes.Enabled and "Emote Menu Opened" or "Emote Menu Closed", 3)
    else
        Notify("Emotes", "Emote UI not found", 5)
    end
end

-- Bind emote menu toggle to ',' key (comma)
ContextActionService:BindAction("ToggleEmotes", function(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        openEmoteMenu()
    end
end, false, Enum.KeyCode.Comma)

-- INITIAL NOTIFICATION
Notify("Elite Bang Script", "Press 'Toggle Bang' to start. Press ',' to toggle Emote Menu.", 8)

-- END OF SCRIPT
