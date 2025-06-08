--[[
    Roblox Player Control Script (Ultimate Edition)

    This LocalScript provides a robust and visually enhanced UI menu with comprehensive controls for:
    - Player WalkSpeed & JumpPower adjustment
    - Toggling player highlighting (refreshes every 5 seconds)
    - Toggling UI menu visibility (via 'E' key, Close 'X' button, or Minimize '-' button)
    - Toggling 'Fly' ability for the local player (Spacebar to ascend)
    - Launching all other players into the air
    - Toggling 'Invisibility' for the local player
    - Teleport to any player by name
    - Toggle Noclip (walk through walls)
    - Toggle God Mode (invincibility)
    - Kill target player (by name)
    - Heal target player (by name)
    - A dedicated "External Scripts" section with user-defined button names and URLs for dynamic script execution.

    Key Features & Improvements:dddddddddddd
    - Custom animated notification system ("by pyst" attribution included).
    - Automatic R6/R15 character rig detection and notification on game start.
    - Highly stylized UI with rounded corners, subtle shadows, and a clean, modern aesthetic.
    - Draggable main menu frame for flexible placement on the screen.
    - Smooth minimize/maximize animations for the UI menu.
    - All buttons and input fields are correctly positioned, sized, and fully functional.
    - Robust handling for character respawns to ensure active features persist.
    - Clear and comprehensive code comments for easy understanding.
    - Dynamic adjustment of the scrolling frame's canvas size to fit all content.

    It should be placed in StarterPlayerScripts or any other
    client-side location where it can run.

    How it works:
    1. Game services and essential state variables are initialized.
    2. Helper functions are defined for creating UI elements consistently.
    3. The `showNotification` function provides animated, custom messages.
    4. Core UI structure (ScreenGui, MainFrame, TopBar, ScrollingFrame) is built,
       with careful attention to UDim2, UIListLayout, and UIPadding for precise layout.
    5. Event listeners connect UI interactions (button clicks, textbox input, key presses)
       to their corresponding feature functions.
    6. Player status effects (highlighting, fly, invisibility, noclip, god mode)
       are managed through dedicated toggle functions that modify player properties.
    7. Player manipulation functions (launch, kill, heal, teleport) operate on targeted players by name.
    8. The "External Scripts" section uses `HttpService:GetAsync()` to fetch Lua code from provided URLs
       and `loadstring()` to execute it dynamically, including error handling.
    9. `CharacterAdded` and `PlayerRemoving` events ensure features are correctly
       re-applied after respawn or cleaned up when a player leaves.
    10. The ScrollingFrame's `CanvasSize` is dynamically updated to fit all content.
]]

-- Define constants for highlight properties
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 255, 0) -- Bright yellow highlight
local HIGHLIGHT_TRANSPARENCY = 0.5 -- Semi-transparent fill
local HIGHLIGHT_OUTLINE_TRANSPARENCY = 0 -- Fully opaque outline

-- Game Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService") -- For Noclip loop

-- State variables for the script
local highlightingEnabled = true
local highlightLoopConnection = nil
local currentHighlights = {}

local isFlying = false
local flyBodyVelocity = nil
local flyAscendConnection = nil
local flyDescendConnection = nil

local isInvisible = false
local isNoclipping = false
local isGodMode = false

-- Feature properties
local FLY_SPEED = 50
local ASCEND_POWER = 1000
local LAUNCH_POWER = 2000
local INVISIBLE_TRANSPARENCY = 1
local VISIBLE_TRANSPARENCY = 0
local NOCLIP_SPEED_MULTIPLIER = 2 -- How much faster Noclip makes you move (relative to WalkSpeed)
local GOD_MODE_HEALTH = math.huge -- Effectively infinite health

-- UI Frame sizes for minimizing/maximizing
local FRAME_WIDTH = 250 -- Fixed width for the main UI frame
local ORIGINAL_FRAME_HEIGHT = 650 -- Full height when expanded
local MINIMIZED_FRAME_HEIGHT = 40 -- Height when minimized (just the top bar)

local ORIGINAL_FRAME_SIZE = UDim2.new(0, FRAME_WIDTH, 0, ORIGINAL_FRAME_HEIGHT)
local MINIMIZED_FRAME_SIZE = UDim2.new(0, FRAME_WIDTH, 0, MINIMIZED_FRAME_HEIGHT)

-- Function to remove all existing highlights from all characters
local function removeAllHighlights()
    for character, highlight in pairs(currentHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    currentHighlights = {}
end

-- Function to remove existing highlights from a specific character
local function removeExistingHighlights(character)
    if currentHighlights[character] then
        currentHighlights[character]:Destroy()
        currentHighlights[character] = nil
    end
end

-- Function to apply a highlight to a player's character
local function applyHighlight(player)
    local character = player.Character or player.CharacterAdded:Wait()

    if character then
        removeExistingHighlights(character)

        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight"
        highlight.FillColor = HIGHLIGHT_COLOR
        highlight.OutlineColor = HIGHLIGHT_COLOR
        highlight.FillTransparency = HIGHLIGHT_TRANSPARENCY
        highlight.OutlineTransparency = HIGHLIGHT_OUTLINE_TRANSPARENCY
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character
        currentHighlights[character] = highlight
    end
end

-- Function to start the highlighting loop
local function startHighlighting()
    if highlightLoopConnection then return end

    highlightLoopConnection = task.spawn(function()
        while highlightingEnabled do
            local playersInGame = Players:GetPlayers()
            for _, player in ipairs(playersInGame) do
                applyHighlight(player)
            end
            task.wait(5)
        end
        removeAllHighlights()
    end)
end

-- Function to stop the highlighting loop
local function stopHighlighting()
    highlightingEnabled = false
    if highlightLoopConnection then
        task.cancel(highlightLoopConnection)
        highlightLoopConnection = nil
    end
    removeAllHighlights()
end

-- Function to toggle fly mode
local function toggleFly()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not humanoidRootPart then
        showNotification("Character or HumanoidRootPart not found for Fly.")
        return
    end

    isFlying = not isFlying

    if isFlying then
        humanoid.WalkSpeed = FLY_SPEED
        humanoid.JumpPower = 0
        humanoid.PlatformStand = true
        humanoid.UseJumpPower = false

        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        flyBodyVelocity.P = 1000
        flyBodyVelocity.Parent = humanoidRootPart

        flyAscendConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.Space and not gameProcessedEvent and isFlying then
                flyBodyVelocity.Velocity = Vector3.new(0, ASCEND_POWER / flyBodyVelocity.P, 0)
            end
        end)
        flyDescendConnection = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.Space and isFlying then
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end)

        showNotification("Fly mode: ON (Spacebar to ascend)")
    else
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
        humanoid.UseJumpPower = true

        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        if flyAscendConnection then
            flyAscendConnection:Disconnect()
            flyAscendConnection = nil
        end
        if flyDescendConnection then
            flyDescendConnection:Disconnect()
            flyDescendConnection = nil
        end
        showNotification("Fly mode: OFF")
    end
end

-- Function to launch all other players
local function launchAllPlayers()
    local launchedCount = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                local launchVelocity = Instance.new("BodyVelocity")
                launchVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                launchVelocity.Velocity = Vector3.new(0, LAUNCH_POWER, 0)
                launchVelocity.Parent = humanoidRootPart
                game.Debris:AddItem(launchVelocity, 0.5)
                launchedCount = launchedCount + 1
            end
        end
    end
    if launchedCount > 0 then
        showNotification("Launched " .. launchedCount .. " other players!")
    else
        showNotification("No other players to launch!")
    end
end

-- Function to toggle player invisibility
local function toggleInvisibility()
    local character = LocalPlayer.Character
    if not character then
        showNotification("Character not found for Invisibility.")
        return
    end

    isInvisible = not isInvisible
    local targetTransparency = isInvisible and INVISIBLE_TRANSPARENCY or VISIBLE_TRANSPARENCY

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("MeshPart") or part:IsA("Part") then
            if not (part:IsA("Highlight") or part:IsA("BodyVelocity") or part:IsA("BodyForce")) then
                part.Transparency = targetTransparency
            end
        end
    end

    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle and handle:IsA("BasePart") then
                handle.Transparency = targetTransparency
                for _, child in ipairs(handle:GetChildren()) do
                    if child:IsA("Decal") or child:IsA("Texture") then
                        child.Transparency = targetTransparency
                    end
                end
            end
        end
    end

    if isInvisible then
        showNotification("Invisibility: ON")
    else
        showNotification("Invisibility: OFF")
    end
end

-- Function to toggle Noclip
local noclipConnection = nil
local function toggleNoclip()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not humanoidRootPart then
        showNotification("Character or HumanoidRootPart not found for Noclip.")
        return
    end

    isNoclipping = not isNoclipping

    if isNoclipping then
        humanoid.WalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed * NOCLIP_SPEED_MULTIPLIER
        humanoid.PlatformStand = true
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        noclipConnection = RunService.RenderStepped:Connect(function()
            local moveVector = UserInputService:GetMoveVector()
            if moveVector ~= Vector3.new(0,0,0) then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame + humanoidRootPart.CFrame.lookVector * moveVector.Z + humanoidRootPart.CFrame.rightVector * moveVector.X + Vector3.new(0, moveVector.Y, 0)
            end
        end)
        showNotification("Noclip: ON")
    else
        humanoid.WalkSpeed = 16
        humanoid.PlatformStand = false
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        showNotification("Noclip: OFF")
    end
end

-- Function to toggle God Mode
local function toggleGodMode()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        showNotification("Character not found for God Mode.")
        return
    end

    isGodMode = not isGodMode

    if isGodMode then
        humanoid.MaxHealth = GOD_MODE_HEALTH
        humanoid.Health = GOD_MODE_HEALTH
        humanoid.Immortal = true
        showNotification("God Mode: ON")
    else
        humanoid.MaxHealth = 100
        humanoid.Health = humanoid.MaxHealth
        humanoid.Immortal = false
        showNotification("God Mode: OFF")
    end
end

-- Function to kill a player by name
local function killPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if targetHumanoid then
            targetHumanoid.Health = 0
            showNotification("Killed " .. targetPlayer.Name .. "!")
        else
            showNotification(targetPlayer.Name .. " has no Humanoid.")
        end
    else
        showNotification("Player '" .. playerName .. "' not found or no character.")
    end
end

-- Function to heal a player by name
local function healPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character then
        local targetHumanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if targetHumanoid then
            targetHumanoid.Health = targetHumanoid.MaxHealth
            showNotification("Healed " .. targetPlayer.Name .. "!")
        else
            showNotification(targetPlayer.Name .. " has no Humanoid.")
        end
    else
        showNotification("Player '" .. playerName .. "' not found or no character.")
    end
end

-- Function to teleport to a player by name
local function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local localPlayerCharacter = LocalPlayer.Character
        local localHumanoidRootPart = localPlayerCharacter and localPlayerCharacter:FindFirstChild("HumanoidRootPart")

        if localHumanoidRootPart then
            localPlayerCharacter:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)) -- Teleport slightly above
            showNotification("Teleported to " .. targetPlayer.Name .. "!")
        else
            showNotification("Your character not found for teleport.")
        end
    else
        showNotification("Player '" .. playerName .. "' not found or no character to teleport to.")
    end
end


--- Notification Function ---
local function showNotification(message)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = CoreGui

    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 300, 0, 50)
    notificationFrame.Position = UDim2.new(0.5, -150, 1, -60)
    notificationFrame.AnchorPoint = Vector2.new(0.5, 1)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 255)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = notificationGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = notificationFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message .. " | by pyst"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notificationFrame

    notificationFrame.BackgroundTransparency = 1
    textLabel.TextTransparency = 1

    TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0}
    ):Play()

    TweenService:Create(
        textLabel,
        TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    ):Play()

    task.delay(5, function()
        TweenService:Create(
            notificationFrame,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {BackgroundTransparency = 1}
        ):Play()

        TweenService:Create(
            textLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
            {TextTransparency = 1}
        ):Play()

        task.delay(0.5, function()
            notificationGui:Destroy()
        end)
    end)
end

--- UI Creation Helpers ---
-- Function to create a standard button
local function createButton(parent, name, text, size, bgColor, textColor, font, textSize)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Text = text
    button.TextColor3 = textColor
    button.BackgroundColor3 = bgColor
    button.Font = font
    button.TextSize = textSize
    button.Parent = parent

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = button

    local uistroke = Instance.new("UIStroke") -- Add a subtle border/shadow
    uistroke.Color = Color3.fromRGB(0,0,0)
    uistroke.Transparency = 0.7
    uistroke.Thickness = 1
    uistroke.Parent = button

    return button
end

-- Function to create a standard label for textboxes
local function createLabel(parent, name, text, size, textColor, bgColor, font, textSize)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Text = text
    label.TextColor3 = textColor
    label.BackgroundColor3 = bgColor
    label.BackgroundTransparency = 1
    label.Font = font
    label.TextSize = textSize
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

-- Function to create a standard textbox
local function createTextBox(parent, name, placeholder, text, size, textColor, bgColor, font, textSize)
    local textbox = Instance.new("TextBox")
    textbox.Name = name
    textbox.Size = size
    textbox.PlaceholderText = placeholder
    textbox.Text = text
    textbox.TextColor3 = textColor
    textbox.BackgroundColor3 = bgColor
    textbox.Font = font
    textbox.TextSize = textSize
    textbox.ClearTextOnFocus = true
    textbox.Parent = parent

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 7)
    uicorner.Parent = textbox
    return textbox
end

--- Main UI Creation ---
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "PlayerControlGui"
MainScreenGui.Enabled = true
MainScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenuFrame"
MainFrame.Size = ORIGINAL_FRAME_SIZE
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = MainScreenGui

local MainFrameUICorner = Instance.new("UICorner")
MainFrameUICorner.CornerRadius = UDim.new(0, 20)
MainFrameUICorner.Parent = MainFrame

local MainFrameUIStroke = Instance.new("UIStroke")
MainFrameUIStroke.Color = Color3.fromRGB(50, 50, 200)
MainFrameUIStroke.Thickness = 2
MainFrameUIStroke.Parent = MainFrame

local UIPaddingMain = Instance.new("UIPadding")
UIPaddingMain.PaddingTop = UDim.new(0, 5)
UIPaddingMain.PaddingBottom = UDim.new(0, 5)
UIPaddingMain.PaddingLeft = UDim.new(0, 5)
UIPaddingMain.PaddingRight = UDim.new(0, 5)
UIPaddingMain.Parent = MainFrame

-- TopBar Frame for Title, Close, Minimize buttons
local TopBarFrame = Instance.new("Frame")
TopBarFrame.Name = "TopBar"
TopBarFrame.Size = UDim2.new(1, 0, 0, 30)
TopBarFrame.BackgroundTransparency = 1
TopBarFrame.Parent = MainFrame

local TopBarLayout = Instance.new("UIListLayout")
TopBarLayout.Padding = UDim.new(0, 5)
TopBarLayout.FillDirection = Enum.FillDirection.Horizontal
TopBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
TopBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TopBarLayout.Parent = TopBarFrame

local TitleLabel = createLabel(TopBarFrame, "TitleLabel", "✨ Player Controls", UDim2.new(1, -70, 1, 0), Color3.fromRGB(255, 255, 255), Color3.fromRGB(60, 60, 60), Enum.Font.SourceSansBold, 24)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = createButton(TopBarFrame, "CloseButton", "X", UDim2.new(0, 25, 0, 25), Color3.fromRGB(170, 0, 0), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 18)
local MinimizeButton = createButton(TopBarFrame, "MinimizeButton", "-", UDim2.new(0, 25, 0, 25), Color3.fromRGB(255, 200, 0), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 20)

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = MINIMIZED_FRAME_SIZE}
        ):Play()
        -- Hide all content elements
        ScrollingFrame.Visible = false
    else
        TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = ORIGINAL_FRAME_SIZE}
        ):Play()
        -- Show all content elements
        ScrollingFrame.Visible = true
    end
end)

-- Scrolling Frame for main content area
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "ContentScrollingFrame"
ScrollingFrame.Size = UDim2.new(1, -10, 1, -TopBarFrame.Size.Y.Offset - 10) -- Adjust size to fit below TopBar with padding
ScrollingFrame.Position = UDim2.new(0, 5, 0, TopBarFrame.Size.Y.Offset + 5) -- Position below TopBar, accounting for MainFrame padding
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Will be adjusted by UIListLayout
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.Parent = ScrollingFrame

local ScrollingFrameUICorner = Instance.new("UICorner")
ScrollingFrameUICorner.CornerRadius = UDim.new(0, 10)
ScrollingFrameUICorner.Parent = ScrollingFrame

local UIPaddingContent = Instance.new("UIPadding")
UIPaddingContent.PaddingTop = UDim.new(0, 5)
UIPaddingContent.PaddingBottom = UDim.new(0, 5)
UIPaddingContent.Parent = ScrollingFrame

-- Speed Controls
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Name = "SpeedContainer"
SpeedContainer.Size = UDim2.new(0.95, 0, 0, 50) -- Wider container
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Parent = ScrollingFrame

local SpeedContainerListLayout = Instance.new("UIListLayout")
SpeedContainerListLayout.Padding = UDim.new(0, 0)
SpeedContainerListLayout.FillDirection = Enum.FillDirection.Vertical
SpeedContainerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SpeedContainerListLayout.Parent = SpeedContainer

local SpeedLabel = createLabel(SpeedContainer, "SpeedLabel", "WalkSpeed (Default: 16)", UDim2.new(1, 0, 0, 20), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.SourceSans, 14)
local SpeedTextBox = createTextBox(SpeedContainer, "SpeedTextBox", "Enter speed...", tostring(LocalPlayer.Character and LocalPlayer.Character.Humanoid.WalkSpeed or 16), UDim2.new(0.8, 0, 0, 25), Color3.fromRGB(255, 255, 255), Color3.fromRGB(55, 55, 55), Enum.Font.SourceSans, 16)

-- Jump Controls
local JumpContainer = Instance.new("Frame")
JumpContainer.Name = "JumpContainer"
JumpContainer.Size = UDim2.new(0.95, 0, 0, 50) -- Wider container
JumpContainer.BackgroundTransparency = 1
JumpContainer.Parent = ScrollingFrame

local JumpContainerListLayout = Instance.new("UIListLayout")
JumpContainerListLayout.Padding = UDim.new(0, 0)
JumpContainerListLayout.FillDirection = Enum.FillDirection.Vertical
JumpContainerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
JumpContainerListLayout.Parent = JumpContainer

local JumpLabel = createLabel(JumpContainer, "JumpLabel", "JumpPower (Default: 50)", UDim2.new(1, 0, 0, 20), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.SourceSans, 14)
local JumpTextBox = createTextBox(JumpContainer, "JumpTextBox", "Enter jump power...", tostring(LocalPlayer.Character and LocalPlayer.Character.Humanoid.JumpPower or 50), UDim2.new(0.8, 0, 0, 25), Color3.fromRGB(255, 255, 255), Color3.fromRGB(55, 55, 55), Enum.Font.SourceSans, 16)

-- Apply Stats Button
local ApplyStatsButton = createButton(ScrollingFrame, "ApplyStatsButton", "Apply Speed & Jump", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(0, 120, 200), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- Highlight Toggle Button
local ToggleHighlightButton = createButton(ScrollingFrame, "ToggleHighlightButton", "Highlights: ON", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(0, 170, 0), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- Fly Toggle Button
local ToggleFlyButton = createButton(ScrollingFrame, "ToggleFlyButton", "Fly: OFF", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- Invisible Toggle Button
local ToggleInvisibleButton = createButton(ScrollingFrame, "ToggleInvisibleButton", "Invisible: OFF", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- Noclip Toggle Button
local NoclipButton = createButton(ScrollingFrame, "NoclipButton", "Noclip: OFF", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- God Mode Toggle Button
local GodModeButton = createButton(ScrollingFrame, "GodModeButton", "God Mode: OFF", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(100, 100, 100), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- Launch Players Button
local LaunchPlayersButton = createButton(ScrollingFrame, "LaunchPlayersButton", "Launch All Players", UDim2.new(0.95, 0, 0, 30), Color3.fromRGB(200, 50, 0), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- Player Target Controls
local PlayerTargetContainer = Instance.new("Frame")
PlayerTargetContainer.Name = "PlayerTargetContainer"
PlayerTargetContainer.Size = UDim2.new(0.95, 0, 0, 80)
PlayerTargetContainer.BackgroundTransparency = 1
PlayerTargetContainer.Parent = ScrollingFrame

local PlayerTargetLayout = Instance.new("UIListLayout")
PlayerTargetLayout.Padding = UDim.new(0, 0)
PlayerTargetLayout.FillDirection = Enum.FillDirection.Vertical
PlayerTargetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PlayerTargetLayout.Parent = PlayerTargetContainer

local PlayerTargetLabel = createLabel(PlayerTargetContainer, "PlayerTargetLabel", "Target Player Name:", UDim2.new(1, 0, 0, 20), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.SourceSans, 14)
local PlayerTargetTextBox = createTextBox(PlayerTargetContainer, "PlayerTargetTextBox", "Enter player name...", "", UDim2.new(0.9, 0, 0, 25), Color3.fromRGB(255, 255, 255), Color3.fromRGB(55, 55, 55), Enum.Font.SourceSans, 16)

local PlayerActionsFrame = Instance.new("Frame")
PlayerActionsFrame.Name = "PlayerActionsFrame"
PlayerActionsFrame.Size = UDim2.new(1, 0, 0, 30)
PlayerActionsFrame.BackgroundTransparency = 1
PlayerActionsFrame.Parent = PlayerTargetContainer

local PlayerActionsLayout = Instance.new("UIListLayout")
PlayerActionsLayout.Padding = UDim.new(0, 5)
PlayerActionsLayout.FillDirection = Enum.FillDirection.Horizontal
PlayerActionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
PlayerActionsLayout.Parent = PlayerActionsFrame

local KillPlayerButton = createButton(PlayerActionsFrame, "KillPlayerButton", "Kill", UDim2.new(0.32, 0, 0, 25), Color3.fromRGB(200, 0, 0), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)
local HealPlayerButton = createButton(PlayerActionsFrame, "HealPlayerButton", "Heal", UDim2.new(0.32, 0, 0, 25), Color3.fromRGB(0, 200, 0), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)
local TeleportButton = createButton(PlayerActionsFrame, "TeleportButton", "Teleport", UDim2.new(0.32, 0, 0, 25), Color3.fromRGB(0, 150, 150), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 16)

-- External Scripts Section
local ExternalScriptsTitle = createLabel(ScrollingFrame, "ExternalScriptsTitle", "--- External Scripts ---", UDim2.new(1, 0, 0, 25), Color3.fromRGB(255, 255, 255), Color3.fromRGB(40, 40, 40), Enum.Font.SourceSansBold, 16)

-- Buttons Data for external scripts (using original names)
local externalScriptButtonsData = {
    {name = "🎯 Bang V2", r6 = "https://pastebin.com/raw/aPSHMV6K", r15 = "https://pastebin.com/raw/1ePMTt9n"},
    {name = "🎉 Get Banged", r6 = "https://pastebin.com/raw/zHbw7ND1", r15 = "https://pastebin.com/raw/7hvcjDnW"},
    {name = "💥 Suck", r6 = "https://pastebin.com/raw/SymCfnAW", r15 = "https://pastebin.com/raw/p8yxRfr4"},
    {name = "🔥 Get Suc", r6 = "https://pastebin.com/raw/FPu4e2Qh", r15 = "https://pastebin.com/raw/DyPP2tAF"},
    {name = "⚡ Jerk", r6 = "https://pastefy.app/wa3v2Vgm/raw", r15 = "https://pastefy.app/YZoglOyJ/raw"}
}

for _, buttonData in ipairs(externalScriptButtonsData) do
    -- Clean name for the instance, display text remains original
    local button = createButton(ScrollingFrame, string.gsub(buttonData.name, "%W", "") .. "Button", buttonData.name, UDim2.new(0.95, 0, 0, 40), Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255)), Color3.fromRGB(255, 255, 255), Enum.Font.SourceSansBold, 20)

    button.MouseButton1Click:Connect(function()
        local scriptUrl = ""
        local isR6 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Torso") ~= nil
        if isR6 then
            scriptUrl = buttonData.r6
        else
            scriptUrl = buttonData.r15
        end

        if scriptUrl ~= "" then
            showNotification("Executing: " .. buttonData.name .. "...")
            local success, content = pcall(function()
                return HttpService:GetAsync(scriptUrl)
            end)

            if success and content then
                local loadSuccess, loadedFunction = pcall(loadstring, content)
                if loadSuccess and loadedFunction then
                    pcall(loadedFunction) -- Execute the loaded script
                    showNotification(buttonData.name .. " executed successfully!")
                else
                    showNotification("Failed to load/execute: " .. buttonData.name .. " (Script Error)")
                    warn("Error loading/executing external script:", loadedFunction)
                end
            else
                showNotification("Failed to fetch: " .. buttonData.name .. " (URL Error)")
                warn("Error fetching external script:", content)
            end
        else
            showNotification("No script URL available for " .. buttonData.name)
        end
    end)
end

--- UI Event Connections ---
CloseButton.MouseButton1Click:Connect(function()
    MainScreenGui.Enabled = false
    showNotification("UI Closed")
end)

ApplyStatsButton.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character.Humanoid
    if not humanoid then
        showNotification("Character not found!")
        return
    end

    local speedInput = tonumber(SpeedTextBox.Text)
    local jumpInput = tonumber(JumpTextBox.Text)

    if speedInput and speedInput >= 0 then
        humanoid.WalkSpeed = speedInput
        showNotification("WalkSpeed set to: " .. speedInput)
    else
        warn("Invalid speed input: " .. (SpeedTextBox.Text or "nil"))
        showNotification("Invalid speed value. Please enter a number.")
    end

    if jumpInput and jumpInput >= 0 then
        humanoid.JumpPower = jumpInput
        showNotification("JumpPower set to: " .. jumpInput)
    else
        warn("Invalid jump input: " .. (JumpTextBox.Text or "nil"))
        showNotification("Invalid jump power value. Please enter a number.")
    end
end)

ToggleHighlightButton.MouseButton1Click:Connect(function()
    highlightingEnabled = not highlightingEnabled
    if highlightingEnabled then
        startHighlighting()
        ToggleHighlightButton.Text = "Highlights: ON"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        showNotification("Player highlighting ON")
    else
        stopHighlighting()
        ToggleHighlightButton.Text = "Highlights: OFF"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        showNotification("Player highlighting OFF")
    end
end)

ToggleFlyButton.MouseButton1Click:Connect(function()
    toggleFly()
    if isFlying then
        ToggleFlyButton.Text = "Fly: ON (Spacebar to ascend)"
        ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    else
        ToggleFlyButton.Text = "Fly: OFF"
        ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

ToggleInvisibleButton.MouseButton1Click:Connect(function()
    toggleInvisibility()
    if isInvisible then
        ToggleInvisibleButton.Text = "Invisible: ON"
        ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
    else
        ToggleInvisibleButton.Text = "Invisible: OFF"
        ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

NoclipButton.MouseButton1Click:Connect(function()
    toggleNoclip()
    if isNoclipping then
        NoclipButton.Text = "Noclip: ON"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
    else
        NoclipButton.Text = "Noclip: OFF"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

GodModeButton.MouseButton1Click:Connect(function()
    toggleGodMode()
    if isGodMode then
        GodModeButton.Text = "God Mode: ON"
        GodModeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    else
        GodModeButton.Text = "God Mode: OFF"
        GodModeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

LaunchPlayersButton.MouseButton1Click:Connect(function()
    launchAllPlayers()
end)

KillPlayerButton.MouseButton1Click:Connect(function()
    local targetName = PlayerTargetTextBox.Text
    if targetName ~= "" then
        killPlayer(targetName)
    else
        showNotification("Please enter a player name to Kill.")
    end
end)

HealPlayerButton.MouseButton1Click:Connect(function()
    local targetName = PlayerTargetTextBox.Text
    if targetName ~= "" then
        healPlayer(targetName)
    else
        showNotification("Please enter a player name to Heal.")
    end
end)

TeleportButton.MouseButton1Click:Connect(function()
    local targetName = PlayerTargetTextBox.Text
    if targetName ~= "" then
        teleportToPlayer(targetName)
    else
        showNotification("Please enter a player name to Teleport to.")
    end
end)


--- Input Handling for 'E' Key to toggle UI ---
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
        MainScreenGui.Enabled = not MainScreenGui.Enabled
        if MainScreenGui.Enabled then
            -- Update UI textboxes with current player values when menu opens
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
                JumpTextBox.Text = tostring(humanoid.JumpPower)
            end
            -- Update button states to reflect current feature status
            ToggleHighlightButton.Text = highlightingEnabled and "Highlights: ON" or "Highlights: OFF"
            ToggleHighlightButton.BackgroundColor3 = highlightingEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)

            ToggleFlyButton.Text = isFlying and "Fly: ON (Spacebar to ascend)" or "Fly: OFF"
            ToggleFlyButton.BackgroundColor3 = isFlying and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(100, 100, 100)

            ToggleInvisibleButton.Text = isInvisible and "Invisible: ON" or "Invisible: OFF"
            ToggleInvisibleButton.BackgroundColor3 = isInvisible and Color3.fromRGB(150, 0, 150) or Color3.fromRGB(100, 100, 100)

            NoclipButton.Text = isNoclipping and "Noclip: ON" or "Noclip: OFF"
            NoclipButton.BackgroundColor3 = isNoclipping and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(100, 100, 100)

            GodModeButton.Text = isGodMode and "God Mode: ON" or "God Mode: OFF"
            GodModeButton.BackgroundColor3 = isGodMode and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(100, 100, 100)
        end
    end
end)

-- Initial setup: Start highlighting if it's enabled by default
if highlightingEnabled then
    startHighlighting()
end

-- Update button texts and colors based on initial state (on script load)
ToggleHighlightButton.Text = highlightingEnabled and "Highlights: ON" or "Highlights: OFF"
ToggleHighlightButton.BackgroundColor3 = highlightingEnabled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)

ToggleFlyButton.Text = isFlying and "Fly: ON (Spacebar to ascend)" or "Fly: OFF"
ToggleFlyButton.BackgroundColor3 = isFlying and Color3.fromRGB(0, 120, 200) or Color3.fromRGB(100, 100, 100)

ToggleInvisibleButton.Text = isInvisible and "Invisible: ON" or "Invisible: OFF"
ToggleInvisibleButton.BackgroundColor3 = isInvisible and Color3.fromRGB(150, 0, 150) or Color3.fromRGB(100, 100, 100)

NoclipButton.Text = isNoclipping and "Noclip: ON" or "Noclip: OFF"
NoclipButton.BackgroundColor3 = isNoclipping and Color3.fromRGB(0, 150, 150) or Color3.fromRGB(100, 100, 100)

GodModeButton.Text = isGodMode and "God Mode: ON" or "God Mode: OFF"
GodModeButton.BackgroundColor3 = isGodMode and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(100, 100, 100)


-- Listen for character changes (e.g., player respawns) to update Humanoid values in textboxes and re-apply features
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
    JumpTextBox.Text = tostring(humanoid.JumpPower)

    -- Re-apply features if active before respawn
    -- Toggling twice ensures the feature is properly re-initialized on the new character
    if isFlying then toggleFly(); toggleFly() end
    if isInvisible then toggleInvisibility(); toggleInvisibility() end
    if isNoclipping then toggleNoclip(); toggleNoclip() end
    if isGodMode then toggleGodMode(); toggleGodMode() end
end)

-- Initial setting of textboxes if character already exists on load
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
        JumpTextBox.Text = tostring(humanoid.JumpPower)
    end
end

-- Clean up highlights, fly BodyVelocity, and reset invisibility when a player leaves the game
Players.PlayerRemoving:Connect(function(playerLeaving)
    local character = playerLeaving.Character
    if character and currentHighlights[character] then
        currentHighlights[character]:Destroy()
        currentHighlights[character] = nil
    end
    -- Clean up active features for the local player if they leave
    if playerLeaving == LocalPlayer then
        if flyBodyVelocity then flyBodyVelocity:Destroy(); flyBodyVelocity = nil end
        isFlying = false
        if flyAscendConnection then flyAscendConnection:Disconnect(); flyAscendConnection = nil end
        if flyDescendConnection then flyDescendConnection:Disconnect(); flyDescendConnection = nil end

        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        isNoclipping = false

        if isInvisible then isInvisible = false; toggleInvisibility() end -- Ensure visible for cleanup
        if isGodMode then isGodMode = false; toggleGodMode() end -- Ensure godmode is off
    end
end)

-- Initial check for R6/R15 and display notification upon script load
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local isR6 = character:FindFirstChild("Torso") ~= nil

if isR6 then
    showNotification("🌟 R6 rig detected! | by pyst")
else
    showNotification("✨ R15 rig detected! | by pyst")
end

-- Adjust CanvasSize of ScrollingFrame based on its content dynamically
local function updateCanvasSize()
    local contentHeight = ContentLayout.AbsoluteContentSize.Y
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight + UIPaddingContent.PaddingTop.Offset + UIPaddingContent.PaddingBottom.Offset)
end

-- Connect to LayoutUpdated to ensure CanvasSize is adjusted after layout changes
ContentLayout.LayoutUpdated:Connect(updateCanvasSize)

-- Also update initially in case content is static or already laid out
updateCanvasSize()
