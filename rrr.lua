--[[
    Roblox Player Highlighter Script (UI Menu)

    This LocalScript now includes a simple UI menu to control:
    - Player WalkSpeed
    - Player JumpPower
    - Toggling the player highlighting feature on/off

    It should be placed in StarterPlayerScripts or any other
    client-side location where it can run.

    How it works:
    1. A ScreenGui and a Frame are created to serve as the menu, visible by default.
    2. TextBoxes for speed and jump input, and buttons for applying stats
       and toggling highlights are added to the menu.
    3. The script listens for UI interactions to:
       - Update the local player's WalkSpeed and JumpPower.
       - Start or stop the player highlighting loop.
    4. When highlighting is enabled, it continuously checks for all players
       and applies a 'Highlight' instance to their character models every 5 seconds.
    5. Existing highlights are destroyed before new ones are created to ensure
       a fresh highlight effect and prevent multiple highlights stacking up.
    6. When highlighting is disabled, all existing highlights are removed.
    7. Highlights are cleaned up when a player leaves the game.
]]

-- Define constants for the highlight properties
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 255, 0) -- Bright yellow highlight
local HIGHLIGHT_TRANSPARENCY = 0.5 -- Semi-transparent fill
local HIGHLIGHT_OUTLINE_TRANSPARENCY = 0 -- Fully opaque outline

-- Game Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- State variables for the script
local highlightingEnabled = true -- Initial state: highlighting is on
local highlightLoopConnection = nil -- Stores the connection for the highlight loop
local currentHighlights = {} -- Table to keep track of created highlights for easy removal

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
            print("Refreshing player highlights...")
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

--- UI Creation ---
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerControlMenu"
ScreenGui.Enabled = true -- Make the UI visible by default
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenuFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 200) -- Small fixed size for the menu
MainFrame.Position = UDim2.new(0.5, -100, 0.1, 0) -- Center horizontally, 10% from top
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true -- Make frame draggable
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 5) -- Add some padding between elements
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Text = "Player Controls"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame

-- Speed Controls
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Text = "WalkSpeed (Default: 16)"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextSize = 14
SpeedLabel.Parent = MainFrame

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
SpeedTextBox.Parent = MainFrame

-- Jump Controls
local JumpLabel = Instance.new("TextLabel")
JumpLabel.Name = "JumpLabel"
JumpLabel.Size = UDim2.new(1, 0, 0, 20)
JumpLabel.Text = "JumpPower (Default: 50)"
JumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
JumpLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JumpLabel.Font = Enum.Font.SourceSans
JumpLabel.TextSize = 14
JumpLabel.Parent = MainFrame

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
JumpTextBox.Parent = MainFrame

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

--- UI Event Connections ---
ApplyStatsButton.MouseButton1Click:Connect(function()
    local humanoid = LocalPlayer.Character and LocalPlayer.Character.Humanoid
    if not humanoid then return end

    local speedInput = tonumber(SpeedTextBox.Text)
    local jumpInput = tonumber(JumpTextBox.Text)

    if speedInput and speedInput >= 0 then
        humanoid.WalkSpeed = speedInput
        print("WalkSpeed set to: " .. speedInput)
    else
        warn("Invalid speed input: " .. (SpeedTextBox.Text or "nil"))
    end

    if jumpInput and jumpInput >= 0 then
        humanoid.JumpPower = jumpInput
        print("JumpPower set to: " .. jumpInput)
    else
        warn("Invalid jump input: " .. (JumpTextBox.Text or "nil"))
    end
end)

ToggleHighlightButton.MouseButton1Click:Connect(function()
    highlightingEnabled = not highlightingEnabled -- Toggle the state
    if highlightingEnabled then
        startHighlighting()
        ToggleHighlightButton.Text = "Highlights: ON"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green
        print("Player highlighting ON")
    else
        stopHighlighting()
        ToggleHighlightButton.Text = "Highlights: OFF"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- Red
        print("Player highlighting OFF")
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

-- Listen for character changes (e.g., player respawns) to update Humanoid values in textboxes
LocalPlayer.CharacterAdded:Connect(function(character)
    local humanoid = character:WaitForChild("Humanoid")
    SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
    JumpTextBox.Text = tostring(humanoid.JumpPower)
end)

-- Initial setting of textboxes if character already exists
if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
        JumpTextBox.Text = tostring(humanoid.JumpPower)
    end
end

-- Clean up highlights when a player leaves the game
Players.PlayerRemoving:Connect(function(playerLeaving)
    local character = playerLeaving.Character
    if character and currentHighlights[character] then
        currentHighlights[character]:Destroy()
        currentHighlights[character] = nil
    end
end)
