--[[
    Roblox Player Control Script (Enhanced UI Menu & Notifications)

    This LocalScript provides an enhanced UI menu with controls for:
    - Player WalkSpeed
    - Player JumpPower
    - Toggling the player highlighting feature on/off
    - Toggling the UI menu visibility (Close/Open button and 'E' key)
    - Toggling a 'Fly' ability for the local player (Spacebar to ascend)
    - Launching other players into the air
    - Toggling 'Invisibility' for the local player

    Key features:
    - Custom animated notifications for script feedback.
    - Detection and notification of R6/R15 character type upon joining.
    - Stylish UI with rounded corners, a close 'X' button, and a minimize '-' button (with smooth animations).
    - The main UI is parented to CoreGui for better visibility and control.

    It should be placed in StarterPlayerScripts or any other
    client-side location where it can run.

    How it works:
    1. A custom notification system is implemented for user feedback.
    2. Character rig type (R6/R15) is detected and announced via notification.
    3. A ScreenGui and a Frame are created to serve as the menu.
       It's initially visible but can be closed/opened with 'E' or the 'X' button.
    4. The menu is draggable and minimizable via the '-' button.
    5. Controls for speed, jump, highlight, fly, launch, and invisibility are added.
    6. The script listens for UI interactions to adjust player properties or trigger actions.
    7. Player highlighting runs in a loop, applying a 'Highlight' instance
       to character models, ensuring existing highlights are removed first.
    8. Fly mode manipulates the player's Humanoid and adds a BodyVelocity
       for controlled upward movement when spacebar is held.
    9. Launching applies a short burst of BodyVelocity to other players.
    10. All dynamically created instances (Highlights, BodyVelocities) are
        cleaned up when no longer needed or when players leave.
]]

-- Define constants for the highlight properties
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 255, 0) -- Bright yellow highlight
local HIGHLIGHT_TRANSPARENCY = 0.5 -- Semi-transparent fill
local HIGHLIGHT_OUTLINE_TRANSPARENCY = 0 -- Fully opaque outline

-- Game Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService") -- For notifications and minimize animation
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui") -- Parent for custom UI and notifications

-- State variables for the script
local highlightingEnabled = true -- Initial state: highlighting is on
local highlightLoopConnection = nil -- Stores the connection for the highlight loop
local currentHighlights = {} -- Table to keep track of created highlights for easy removal

local isFlying = false
local flyBodyVelocity = nil
local flyAscendConnection = nil
local flyDescendConnection = nil

local isInvisible = false -- New state variable for invisibility

-- Fly properties
local FLY_SPEED = 50 -- How fast the player moves while flying
local ASCEND_POWER = 1000 -- Force for ascending
local DESCEND_POWER = -500 -- Force for descending

-- Launch properties (renamed from Fling for clarity)
local LAUNCH_POWER = 2000 -- Force to apply when launching

-- Invisibility properties
local INVISIBLE_TRANSPARENCY = 1 -- Fully transparent
local VISIBLE_TRANSPARENCY = 0 -- Fully opaque

-- Original UI Frame size for minimizing/maximizing
local ORIGINAL_FRAME_SIZE = UDim2.new(0, 200, 0, 340) -- Adjusted height for new buttons
local MINIMIZED_FRAME_SIZE = UDim2.new(0, 200, 0, 30)

-- Function to remove all existing highlights from all characters
local function removeAllHighlights()
    for character, highlight in pairs(currentHighlights) do
        if highlight and highlight.Parent then
            highlight:Destroy()
        end
    end
    currentHighlights = {} -- Clear the table
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
    local character = player.Character or player.CharacterAdded:Wait() -- Get character, or wait for it to load

    if character then
        removeExistingHighlights(character) -- Remove any old highlights first

        -- Create a new Highlight instance
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerHighlight" -- Give it a unique name for easy identification
        highlight.FillColor = HIGHLIGHT_COLOR
        highlight.OutlineColor = HIGHLIGHT_COLOR -- Use the same color for outline
        highlight.FillTransparency = HIGHLIGHT_TRANSPARENCY
        highlight.OutlineTransparency = HIGHLIGHT_OUTLINE_TRANSPARENCY
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Ensure it's always visible
        highlight.Parent = character -- Parent the highlight to the character model
        currentHighlights[character] = highlight -- Store reference to the highlight
    end
end

-- Function to start the highlighting loop
local function startHighlighting()
    if highlightLoopConnection then return end -- Already running

    highlightLoopConnection = task.spawn(function()
        while highlightingEnabled do -- Loop only if highlighting is enabled
            local playersInGame = Players:GetPlayers()

            for _, player in ipairs(playersInGame) do
                -- This version highlights all players, including the local player.
                -- If you want to exclude the local player, uncomment the line below:
                -- if player ~= LocalPlayer then
                    applyHighlight(player)
                -- end
            end
            task.wait(5)
        end
        -- If the loop exits (highlightingEnabled becomes false), ensure all highlights are removed
        removeAllHighlights()
    end)
end

-- Function to stop the highlighting loop
local function stopHighlighting()
    highlightingEnabled = false
    if highlightLoopConnection then
        task.cancel(highlightLoopConnection) -- Stop the task if it's running
        highlightLoopConnection = nil
    end
    removeAllHighlights() -- Ensure all highlights are removed immediately
end

-- Function to toggle fly mode
local function toggleFly()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not humanoidRootPart then return end

    isFlying = not isFlying -- Toggle the state

    if isFlying then
        humanoid.WalkSpeed = FLY_SPEED
        humanoid.JumpPower = 0 -- Disable jumping while flying
        humanoid.PlatformStand = true -- Player will float
        humanoid.UseJumpPower = false -- Ensure JumpPower is not used

        -- Create BodyVelocity for controlled movement
        flyBodyVelocity = Instance.new("BodyVelocity")
        flyBodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Allow infinite vertical force
        flyBodyVelocity.P = 1000 -- Proportional constant
        flyBodyVelocity.Parent = humanoidRootPart

        -- Connect input for ascending/descending
        flyAscendConnection = UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.Space and not gameProcessedEvent and isFlying then
                flyBodyVelocity.Velocity = Vector3.new(0, ASCEND_POWER / flyBodyVelocity.P, 0)
            end
        end)
        flyDescendConnection = UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.Space and isFlying then
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Stop ascending when space released
            end
        end)

        showNotification("Fly mode: ON (Spacebar to ascend)")
    else
        humanoid.WalkSpeed = 16 -- Reset to default
        humanoid.JumpPower = 50 -- Reset to default
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

-- Function to launch all other players (renamed from flingAllPlayers)
local function launchAllPlayers()
    local launchedCount = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then -- Only launch other players
            local character = player.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                local launchVelocity = Instance.new("BodyVelocity")
                launchVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                launchVelocity.Velocity = Vector3.new(0, LAUNCH_POWER, 0) -- Launch upwards
                launchVelocity.Parent = humanoidRootPart
                game.Debris:AddItem(launchVelocity, 0.5) -- Destroy after 0.5 seconds to prevent continuous launching
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
    if not character then return end

    isInvisible = not isInvisible -- Toggle the state

    local targetTransparency = isInvisible and INVISIBLE_TRANSPARENCY or VISIBLE_TRANSPARENCY

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") or part:IsA("MeshPart") or part:IsA("Part") then
            -- Exclude highlights, body movers, etc., that might be children of character parts
            if not (part:IsA("Highlight") or part:IsA("BodyVelocity") or part:IsA("BodyForce")) then
                part.Transparency = targetTransparency
            end
        elseif part:IsA("HumanoidDescription") then
            -- This is usually a child of Humanoid, and doesn't affect transparency directly
            -- but if you manipulate character appearance through it, consider adjusting here.
        end
    end

    -- Handle accessories by iterating through them directly
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

--- Notification Function ---
local function showNotification(message)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = CoreGui -- Parent to CoreGui for system-level notifications

    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(0, 300, 0, 50)
    notificationFrame.Position = UDim2.new(0.5, -150, 1, -60)
    notificationFrame.AnchorPoint = Vector2.new(0.5, 1)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 255) -- Blue color
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Parent = notificationGui

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = notificationFrame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notificationFrame

    notificationFrame.BackgroundTransparency = 1
    textLabel.TextTransparency = 1

    -- Animation for showing notification
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

    -- Animation for hiding notification after 5 seconds
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

--- UI Creation ---
local MainScreenGui = Instance.new("ScreenGui")
MainScreenGui.Name = "PlayerControlGui" -- Renamed from "BangGui"
MainScreenGui.Enabled = true -- Make the UI visible by default
MainScreenGui.Parent = CoreGui -- Parent to CoreGui for system-level GUI

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenuFrame"
MainFrame.Size = ORIGINAL_FRAME_SIZE
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) -- Centered anchor point for positioning
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) -- Centered on screen
MainFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 255) -- Deep Blue
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Make frame draggable
MainFrame.Draggable = true
MainFrame.Parent = MainScreenGui

local MainFrameUICorner = Instance.new("UICorner")
MainFrameUICorner.CornerRadius = UDim.new(0, 20)
MainFrameUICorner.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5) -- Add some padding between elements
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -60, 0, 30) -- Adjusted size to make space for close/minimize buttons
TitleLabel.Position = UDim2.new(0, 10, 0, 0) -- Adjusted position
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "✨ Player Controls"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

-- Close Button (Top right corner of the frame)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 0) -- Top right of the frame
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- Red
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = MainFrame

local CloseButtonUICorner = Instance.new("UICorner")
CloseButtonUICorner.CornerRadius = UDim.new(0, 10)
CloseButtonUICorner.Parent = CloseButton

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -80, 0, 0) -- Top right next to Close button
MinimizeButton.AnchorPoint = Vector2.new(1, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0) -- Orange
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 20
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Parent = MainFrame

local MinimizeButtonUICorner = Instance.new("UICorner")
MinimizeButtonUICorner.CornerRadius = UDim.new(0, 10)
MinimizeButtonUICorner.Parent = MinimizeButton

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = MINIMIZED_FRAME_SIZE}
        ):Play()
        -- Hide all child elements except title and buttons
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child ~= TitleLabel and child ~= CloseButton and child ~= MinimizeButton then
                child.Visible = false
            end
        end
    else
        TweenService:Create(
            MainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = ORIGINAL_FRAME_SIZE}
        ):Play()
        -- Show all child elements
        for _, child in ipairs(MainFrame:GetChildren()) do
            child.Visible = true
        end
    end
end)


-- Speed Controls (wrapped in a container for better layout with Title/Buttons)
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Name = "SpeedContainer"
SpeedContainer.Size = UDim2.new(0.9, 0, 0, 50) -- Adjusted size for better grouping
SpeedContainer.BackgroundTransparency = 1
SpeedContainer.Parent = MainFrame

local SpeedContainerListLayout = Instance.new("UIListLayout")
SpeedContainerListLayout.Padding = UDim.new(0, 0)
SpeedContainerListLayout.FillDirection = Enum.FillDirection.Vertical
SpeedContainerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SpeedContainerListLayout.Parent = SpeedContainer

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Text = "WalkSpeed (Default: 16)"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 14
SpeedLabel.Parent = SpeedContainer

local SpeedTextBox = Instance.new("TextBox")
SpeedTextBox.Name = "SpeedTextBox"
SpeedTextBox.Size = UDim2.new(0.8, 0, 0, 25)
SpeedTextBox.PlaceholderText = "Enter speed..."
SpeedTextBox.Text = tostring(LocalPlayer.Character and LocalPlayer.Character.Humanoid.WalkSpeed or 16)
SpeedTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedTextBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
SpeedTextBox.Font = Enum.Font.SourceSans
SpeedTextBox.TextSize = 16
SpeedTextBox.ClearTextOnFocus = true
SpeedTextBox.Parent = SpeedContainer

-- Jump Controls (wrapped in a container)
local JumpContainer = Instance.new("Frame")
JumpContainer.Name = "JumpContainer"
JumpContainer.Size = UDim2.new(0.9, 0, 0, 50)
JumpContainer.BackgroundTransparency = 1
JumpContainer.Parent = MainFrame

local JumpContainerListLayout = Instance.new("UIListLayout")
JumpContainerListLayout.Padding = UDim.new(0, 0)
JumpContainerListLayout.FillDirection = Enum.FillDirection.Vertical
JumpContainerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
JumpContainerListLayout.Parent = JumpContainer

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Name = "JumpLabel"
JumpLabel.Size = UDim2.new(1, 0, 0, 20)
JumpLabel.Text = "JumpPower (Default: 50)"
JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpLabel.Font = Enum.Font.SourceSans
JumpLabel.TextSize = 14
JumpLabel.Parent = JumpContainer

local JumpTextBox = Instance.new("TextBox")
JumpTextBox.Name = "JumpTextBox"
JumpTextBox.Size = UDim2.new(0.8, 0, 0, 25)
JumpTextBox.PlaceholderText = "Enter jump power..."
JumpTextBox.Text = tostring(LocalPlayer.Character and LocalPlayer.Character.Humanoid.JumpPower or 50)
JumpTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpTextBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
JumpTextBox.Font = Enum.Font.SourceSans
JumpTextBox.TextSize = 16
JumpTextBox.ClearTextOnFocus = true
JumpTextBox.Parent = JumpContainer

-- Apply Stats Button
local ApplyStatsButton = Instance.new("TextButton")
ApplyStatsButton.Name = "ApplyStatsButton"
ApplyStatsButton.Size = UDim2.new(0.9, 0, 0, 30)
ApplyStatsButton.Text = "Apply Speed & Jump"
ApplyStatsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyStatsButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200) -- Blue button
ApplyStatsButton.Font = Enum.Font.SourceSansBold
ApplyStatsButton.TextSize = 16
ApplyStatsButton.Parent = MainFrame

local ApplyStatsButtonUICorner = Instance.new("UICorner")
ApplyStatsButtonUICorner.CornerRadius = UDim.new(0, 10)
ApplyStatsButtonUICorner.Parent = ApplyStatsButton

-- Highlight Toggle Button
local ToggleHighlightButton = Instance.new("TextButton")
ToggleHighlightButton.Name = "ToggleHighlightButton"
ToggleHighlightButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleHighlightButton.Text = "Highlights: ON"
ToggleHighlightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green for ON
ToggleHighlightButton.Font = Enum.Font.SourceSansBold
ToggleHighlightButton.TextSize = 16
ToggleHighlightButton.Parent = MainFrame

local ToggleHighlightButtonUICorner = Instance.new("UICorner")
ToggleHighlightButtonUICorner.CornerRadius = UDim.new(0, 10)
ToggleHighlightButtonUICorner.Parent = ToggleHighlightButton

-- Fly Toggle Button
local ToggleFlyButton = Instance.new("TextButton")
ToggleFlyButton.Name = "ToggleFlyButton"
ToggleFlyButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleFlyButton.Text = "Fly: OFF"
ToggleFlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Grey for OFF
ToggleFlyButton.Font = Enum.Font.SourceSansBold
ToggleFlyButton.TextSize = 16
ToggleFlyButton.Parent = MainFrame

local ToggleFlyButtonUICorner = Instance.new("UICorner")
ToggleFlyButtonUICorner.CornerRadius = UDim.new(0, 10)
ToggleFlyButtonUICorner.Parent = ToggleFlyButton

-- Invisible Toggle Button
local ToggleInvisibleButton = Instance.new("TextButton")
ToggleInvisibleButton.Name = "ToggleInvisibleButton"
ToggleInvisibleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleInvisibleButton.Text = "Invisible: OFF"
ToggleInvisibleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Grey for OFF
ToggleInvisibleButton.Font = Enum.Font.SourceSansBold
ToggleInvisibleButton.TextSize = 16
ToggleInvisibleButton.Parent = MainFrame

local ToggleInvisibleButtonUICorner = Instance.new("UICorner")
ToggleInvisibleButtonUICorner.CornerRadius = UDim.new(0, 10)
ToggleInvisibleButtonUICorner.Parent = ToggleInvisibleButton

-- Launch Players Button (renamed from FlingPlayersButton)
local LaunchPlayersButton = Instance.new("TextButton")
LaunchPlayersButton.Name = "LaunchPlayersButton"
LaunchPlayersButton.Size = UDim2.new(0.9, 0, 0, 30)
LaunchPlayersButton.Text = "Launch All Players" -- Renamed text
LaunchPlayersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LaunchPlayersButton.BackgroundColor3 = Color3.fromRGB(200, 50, 0) -- Orange
LaunchPlayersButton.Font = Enum.Font.SourceSansBold
LaunchPlayersButton.TextSize = 16
LaunchPlayersButton.Parent = MainFrame

local LaunchPlayersButtonUICorner = Instance.new("UICorner")
LaunchPlayersButtonUICorner.CornerRadius = UDim.new(0, 10)
LaunchPlayersButtonUICorner.Parent = LaunchPlayersButton


--- UI Event Connections ---
CloseButton.MouseButton1Click:Connect(function()
    MainScreenGui.Enabled = false -- Hide the UI
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
    highlightingEnabled = not highlightingEnabled -- Toggle the state
    if highlightingEnabled then
        startHighlighting()
        ToggleHighlightButton.Text = "Highlights: ON"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green
        showNotification("Player highlighting ON")
    else
        stopHighlighting()
        ToggleHighlightButton.Text = "Highlights: OFF"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- Red
        showNotification("Player highlighting OFF")
    end
end)

ToggleFlyButton.MouseButton1Click:Connect(function()
    toggleFly()
    if isFlying then
        ToggleFlyButton.Text = "Fly: ON (Spacebar to ascend)"
        ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200) -- Blue for ON
    else
        ToggleFlyButton.Text = "Fly: OFF"
        ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Grey for OFF
    end
end)

ToggleInvisibleButton.MouseButton1Click:Connect(function()
    toggleInvisibility()
    if isInvisible then
        ToggleInvisibleButton.Text = "Invisible: ON"
        ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150) -- Purple for ON
    else
        ToggleInvisibleButton.Text = "Invisible: OFF"
        ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Grey for OFF
    end
end)

LaunchPlayersButton.MouseButton1Click:Connect(function() -- Renamed from FlingPlayersButton.MouseButton1Click
    launchAllPlayers() -- Renamed function call
end)

--- Input Handling for 'E' Key to toggle UI ---
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Check if 'E' key was pressed and it wasn't processed by Roblox's core systems (e.g., chat input)
    if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
        MainScreenGui.Enabled = not MainScreenGui.Enabled -- Toggle the UI visibility
        if MainScreenGui.Enabled then
            -- Set the textboxes to current player values when UI opens
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
                JumpTextBox.Text = tostring(humanoid.JumpPower)
            end
            if isFlying then
                 ToggleFlyButton.Text = "Fly: ON (Spacebar to ascend)"
                 ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
            else
                 ToggleFlyButton.Text = "Fly: OFF"
                 ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end
            if isInvisible then
                ToggleInvisibleButton.Text = "Invisible: ON"
                ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
            else
                ToggleInvisibleButton.Text = "Invisible: OFF"
                ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            end
        end
    end
end)

-- Initial setup: Start highlighting if it's enabled by default
if highlightingEnabled then
    startHighlighting()
    ToggleHighlightButton.Text = "Highlights: ON"
    ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
else
    ToggleHighlightButton.Text = "Highlights: OFF"
    ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
end

-- Initial setting for Fly and Invisible buttons
if isFlying then
    ToggleFlyButton.Text = "Fly: ON (Spacebar to ascend)"
    ToggleFlyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
end
if isInvisible then
    ToggleInvisibleButton.Text = "Invisible: ON"
    ToggleInvisibleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
end


-- Listen for character changes (e.g., player respawns) to update Humanoid values in textboxes
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
    JumpTextBox.Text = tostring(humanoid.JumpPower)

    -- Re-apply fly state if player respawns while fly was active
    if isFlying then
        toggleFly() -- Deactivate and reactivate to reset BodyVelocity on new character
        toggleFly()
    end
    -- Re-apply invisibility state if player respawns while invisible
    if isInvisible then
        toggleInvisibility() -- Deactivate and reactivate to re-apply transparency
        toggleInvisibility()
    end
end)

-- Initial setting of textboxes if character already exists
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
    -- If the local player leaves, clean up their fly BodyVelocity and reset invisibility
    if playerLeaving == LocalPlayer then
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
            flyBodyVelocity = nil
        end
        isFlying = false
        if flyAscendConnection then flyAscendConnection:Disconnect() end
        if flyDescendConnection then flyDescendConnection:Disconnect() end

        -- Ensure invisibility is reset for the character if they respawn later
        if isInvisible then
            isInvisible = false -- Reset state
            toggleInvisibility() -- Make visible
        end
    end
end)

-- Initial check for R6/R15 and display notification
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local isR6 = character:FindFirstChild("Torso") ~= nil -- Check for R6 (has a 'Torso' part)

if isR6 then
    showNotification("🌟 R6 detected!")
else
    showNotification("✨ R15 detected!")
end
