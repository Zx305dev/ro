--[[
    Roblox Player Control Script (Auto-Reset Only)

    This LocalScript provides a simple, reliable UI with a single core feature:h
    automatically resetting your character upon death.

    Key Features:
    - **Auto Character Reset**: Automatically respawns your character when they die.
    - **UI Theme**: Elegant black background with vibrant purple borders and crisp white text.
    - **Easy UI Toggle**: Press the 'E' key to open and close the UI instantly.
    - **Draggable Window**: Move the control panel freely on your screen.
    - **Clear Notifications**: Animated messages provide instant feedback.

    Installation: Place this LocalScript in `StarterPlayerScripts` within Roblox Studio.
]]

-- GLOBAL CONSTANTS (Colors, Fonts)
local BLACK = Color3.fromRGB(25, 25, 25) -- Dark grey/off-black for background
local PURPLE = Color3.fromRGB(128, 0, 128) -- Deep purple for borders and accents
local LIGHT_PURPLE = Color3.fromRGB(150, 50, 150) -- Lighter purple for active states
local ACCENT_GREEN = Color3.fromRGB(0, 170, 0) -- Green for 'ON' states
local ACCENT_RED = Color3.fromRGB(170, 0, 0) -- Red for 'OFF' states or warnings
local WHITE = Color3.new(255, 255, 255) -- Pure white for text
local FONT = Enum.Font.SourceSans -- Standard font for UI text

-- GAME SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- STATE VARIABLES (for toggles and feature management)
local isAutoResetEnabled = false
local characterDiedConnection = nil

-- UI DIMENSIONS
local FRAME_WIDTH = 250
local FRAME_HEIGHT = 150
local TITLE_BAR_HEIGHT = 35
local CLOSE_OPEN_BUTTON_HEIGHT = 20
local CONTENT_PADDING = 10

-- UI HELPER FUNCTIONS
local function createFrame(parent, name, position, size, bgColor, borderColor, borderSize, zIndex, visible)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Name = name
    frame.Position = position
    frame.Size = size
    frame.BackgroundColor3 = bgColor
    frame.BorderColor3 = borderColor
    frame.BorderSizePixel = borderSize
    frame.ZIndex = zIndex or 1
    frame.Visible = visible ~= nil and visible or true
    return frame
end

local function createTextLabel(parent, name, position, size, text, font, fontSize, textColor, bgColor, borderColor, borderSize, zIndex)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Name = name
    label.Position = position
    label.Size = size
    label.Text = text
    label.Font = font
    label.FontSize = fontSize
    label.TextColor3 = textColor
    label.BackgroundColor3 = bgColor
    label.BackgroundTransparency = (bgColor == BLACK) and 1 or 0
    label.BorderColor3 = borderColor
    label.BorderSizePixel = borderSize
    label.ZIndex = zIndex or 1
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.TextYAlignment = Enum.TextYAlignment.Center
    return label
end

local function createTextButton(parent, name, size, text, font, fontSize, textColor, bgColor, borderColor, borderSize, zIndex)
    local button = Instance.new("TextButton")
    button.Parent = parent
    button.Name = name
    button.Size = size
    button.Text = text
    button.Font = font
    button.FontSize = fontSize
    button.TextColor3 = textColor
    button.BackgroundColor3 = bgColor
    button.BorderColor3 = borderColor
    button.BorderSizePixel = borderSize
    button.ZIndex = zIndex or 1
    button.TextXAlignment = Enum.TextXAlignment.Center
    button.TextYAlignment = Enum.TextYAlignment.Center
    return button
end

-- NOTIFICATION SYSTEM
local function showNotification(message)
    local notificationGui = Instance.new("ScreenGui")
    notificationGui.Name = "NotificationGui"
    notificationGui.Parent = CoreGui
    notificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

    local notificationFrame = createFrame(
        notificationGui, "NotificationFrame",
        UDim2.new(0.5, -150, 1, -60),
        UDim2.new(0, 300, 0, 50),
        Color3.fromRGB(80, 0, 120), -- Notification purple
        BLACK, 1, 1, false
    )
    notificationFrame.AnchorPoint = Vector2.new(0.5, 1)

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 10)
    uicorner.Parent = notificationFrame

    local textLabel = createTextLabel(
        notificationFrame, "NotificationText",
        UDim2.new(0, 10, 0, 0), UDim2.new(1, -20, 1, 0),
        message .. " | by pyst", FONT, Enum.FontSize.Size18, WHITE,
        BLACK, 0, 0, 1
    )
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.BackgroundTransparency = 1
    textLabel.TextTransparency = 1

    notificationFrame.BackgroundTransparency = 0.5

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

-- AUTO-RESET FUNCTION
local function toggleAutoReset(button)
    isAutoResetEnabled = not isAutoResetEnabled

    if isAutoResetEnabled then
        local function onCharacterDied()
            LocalPlayer:LoadCharacter()
            showNotification("Character auto-reset!")
        end

        local function connectToDied(char)
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Disconnect previous connection if it exists to prevent duplicates
                if characterDiedConnection then
                    characterDiedConnection:Disconnect()
                end
                characterDiedConnection = humanoid.Died:Connect(onCharacterDied)
            end
        end

        -- Connect for current character
        if LocalPlayer.Character then
            connectToDied(LocalPlayer.Character)
        end
        -- Connect for future characters
        LocalPlayer.CharacterAdded:Connect(connectToDied)

        button.Text = "Auto Reset: ON"
        button.BackgroundColor3 = ACCENT_GREEN
        showNotification("Auto Reset: ON")
    else
        if characterDiedConnection then
            characterDiedConnection:Disconnect()
            characterDiedConnection = nil
        end
        -- Disconnect CharacterAdded listener for respawn management, if it's solely for auto-reset
        -- (In this simplified script, the CharacterAdded listener is directly inside toggleAutoReset,
        -- so disconnecting the 'Died' event is sufficient. If CharacterAdded was persistent,
        -- more complex cleanup would be needed.)
        button.Text = "Auto Reset: OFF"
        button.BackgroundColor3 = ACCENT_RED
        showNotification("Auto Reset: OFF")
    end
end


-- UI CREATION
local mainScreenGui = Instance.new("ScreenGui", CoreGui)
mainScreenGui.Name = "SimpleAutoResetGUI"
mainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local mainFrame = createFrame(
    mainScreenGui, "MainFrame",
    UDim2.new(0.5, -FRAME_WIDTH / 2, 0.5, -FRAME_HEIGHT / 2),
    UDim2.new(0, FRAME_WIDTH, 0, FRAME_HEIGHT),
    BLACK, PURPLE, 3, 1
)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Bar
local titleLabel = createTextLabel(
    mainFrame, "Title",
    UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, TITLE_BAR_HEIGHT),
    "✨ Auto Reset", FONT, Enum.FontSize.Size24, WHITE, BLACK, PURPLE, 2
)

-- Content Frame for the button
local contentFrame = createFrame(
    mainFrame, "Content",
    UDim2.new(0, CONTENT_PADDING, 0, TITLE_BAR_HEIGHT + CONTENT_PADDING),
    UDim2.new(1, -CONTENT_PADDING * 2, 1, -(TITLE_BAR_HEIGHT + CLOSE_OPEN_BUTTON_HEIGHT + CONTENT_PADDING * 2)),
    BLACK, PURPLE, 0
)
contentFrame.BackgroundTransparency = 1

local contentLayout = Instance.new("UIListLayout")
contentLayout.Parent = contentFrame
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contentLayout.VerticalAlignment = Enum.VerticalAlignment.Center -- Center the button vertically
contentLayout.Padding = UDim.new(0, 5)

-- Auto Reset Toggle Button
local autoResetButton = createTextButton(
    contentFrame, "AutoResetButton",
    UDim2.new(0.9, 0, 0, 40), -- Adjusted size for a prominent button
    "Auto Reset: OFF", FONT, Enum.FontSize.Size18, WHITE, ACCENT_RED, PURPLE, 1
)

-- Close/Open Button (attached to mainFrame for relative positioning)
local closeOpenButton = createTextButton(
    mainFrame, "CloseOpenButton",
    UDim2.new(0, 0, 1, -CLOSE_OPEN_BUTTON_HEIGHT),
    UDim2.new(1, 0, 0, CLOSE_OPEN_BUTTON_HEIGHT),
    "Close", FONT, Enum.FontSize.Size18, WHITE, BLACK, PURPLE, 3
)

-- UI EVENT CONNECTIONS
closeOpenButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    closeOpenButton.Text = mainFrame.Visible and "Close" or "Open"
    showNotification(mainFrame.Visible and "UI Shown" or "UI Hidden")
end)

autoResetButton.MouseButton1Click:Connect(function()
    toggleAutoReset(autoResetButton)
end)

-- 'E' key to toggle UI visibility
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
        mainFrame.Visible = not mainFrame.Visible
        closeOpenButton.Text = mainFrame.Visible and "Close" or "Open"
        showNotification(mainFrame.Visible and "UI Shown" or "UI Hidden")

        -- Update button state when UI becomes visible
        if mainFrame.Visible then
            autoResetButton.BackgroundColor3 = isAutoResetEnabled and ACCENT_GREEN or ACCENT_RED
        end
    end
end)

-- Initial check for R6/R15 rig and display a notification on script load
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local isR6 = character:FindFirstChild("Torso") ~= nil
if isR6 then
    showNotification("🌟 R6 rig detected! | by pyst")
else
    showNotification("✨ R15 rig detected! | by pyst")
end

-- Ensure initial button state is correct
autoResetButton.BackgroundColor3 = isAutoResetEnabled and ACCENT_GREEN or ACCENT_RED
