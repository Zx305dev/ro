--[[
    Roblox Player Highlighter Script (E Key Toggle Menu & Chat Commands)

    This LocalScript now features:
    - A togglable UI menu that appears/disappears when the 'E' key is pressed.
    - Controls within the UI menu for player WalkSpeed, JumpPower, and toggling highlights.
    - Continuation of chat commands for WalkSpeed (/speed [value]), JumpPower (/jump [value]),
      and toggling highlights (/highlight [on/off]).

    It should be placed in StarterPlayerScripts or any other
    client-side location where it can run.

    How it works:
    1. A ScreenGui is created and managed. Its 'Enabled' property is toggled by pressing 'E'.
    2. UI elements (Textboxes, Buttons) are created within this ScreenGui.
    3. The script listens for 'E' key presses via UserInputService.
    4. It also continues to listen for chat commands for flexibility.
    5. When highlighting is enabled (via UI or chat), it continuously checks for all players
       and applies a 'Highlight' instance to their character models every 5 seconds.
    6. Existing highlights are destroyed before new ones are created to ensure
       a fresh highlight effect and prevent multiple highlights stacking up.
    7. When highlighting is disabled, all existing highlights are removed.
]]

-- Define constants for the highlight properties
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 255, 0) -- Bright yellow highlight
local HIGHLIGHT_TRANSPARENCY = 0.5 -- Semi-transparent fill
local HIGHLIGHT_OUTLINE_TRANSPARENCY = 0 -- Fully opaque outline

-- Game Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- Needed for 'E' key input
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
            local playersInGame = Players:GetPlayers() -- Get a list of all players currently in the game

            for _, player in ipairs(playersInGame) do
                -- Optional: Uncomment the line below if you don't want to highlight the local player
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
ScreenGui.Enabled = false -- Start with the UI disabled (hidden)
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
        LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
            Text = "Your speed has been set to: " .. newSpeed,
            Font = Enum.Font.SourceSansBold,
            Color = Color3.fromRGB(0, 200, 0),
            TextSize = 18
        })
    else
        warn("Invalid speed input: " .. (SpeedTextBox.Text or "nil"))
        LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
            Text = "Invalid speed value. Please enter a number.",
            Font = Enum.Font.SourceSans,
            Color = Color3.fromRGB(200, 0, 0),
            TextSize = 16
        })
    end

    if jumpInput and jumpInput >= 0 then
        humanoid.JumpPower = jumpInput
        LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
            Text = "Your jump power has been set to: " .. newJumpPower,
            Font = Enum.Font.SourceSansBold,
            Color = Color3.fromRGB(0, 200, 0),
            TextSize = 18
        })
    else
        warn("Invalid jump input: " .. (JumpTextBox.Text or "nil"))
        LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
            Text = "Invalid jump power value. Please enter a number.",
            Font = Enum.Font.SourceSans,
            Color = Color3.fromRGB(200, 0, 0),
            TextSize = 16
        })
    end
end)

ToggleHighlightButton.MouseButton1Click:Connect(function()
    highlightingEnabled = not highlightingEnabled -- Toggle the state
    if highlightingEnabled then
        startHighlighting()
        ToggleHighlightButton.Text = "Highlights: ON"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0) -- Green
        LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
            Text = "Player highlighting ON.",
            Font = Enum.Font.SourceSansBold,
            Color = Color3.fromRGB(0, 170, 0),
            TextSize = 18
        })
    else
        stopHighlighting()
        ToggleHighlightButton.Text = "Highlights: OFF"
        ToggleHighlightButton.BackgroundColor3 = Color3.fromRGB(170, 0, 0) -- Red
        LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
            Text = "Player highlighting OFF.",
            Font = Enum.Font.SourceSansBold,
            Color = Color3.fromRGB(170, 0, 0),
            TextSize = 18
        })
    end
end)

--- Input Handling for 'E' Key ---
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    -- Check if 'E' key was pressed and it wasn't processed by Roblox's core systems (e.g., chat input)
    if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
        ScreenGui.Enabled = not ScreenGui.Enabled -- Toggle the UI visibility
        if ScreenGui.Enabled then
            -- Set the textboxes to current player values when UI opens
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                SpeedTextBox.Text = tostring(humanoid.WalkSpeed)
                JumpTextBox.Text = tostring(humanoid.JumpPower)
            end
        end
    end
end)

--- Chat Command Handling ---
LocalPlayer.Chatted:Connect(function(message)
    local args = message:split(" ") -- Split the message into parts

    local command = args[1]:lower() -- Get the first part as the command (lowercase)
    local value = args[2] and args[2]:lower() -- Get the second part as a value/sub-command (lowercase)

    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end -- Exit if humanoid not found (e.g., player hasn't spawned yet)

    if command == "/speed" then
        local newSpeed = tonumber(value)
        if newSpeed and newSpeed >= 0 then
            humanoid.WalkSpeed = newSpeed
            LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                Text = "Your speed has been set to: " .. newSpeed,
                Font = Enum.Font.SourceSansBold,
                Color = Color3.fromRGB(0, 200, 0),
                TextSize = 18
            })
        else
            LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                Text = "Invalid speed value. Please use /speed [number].",
                Font = Enum.Font.SourceSans,
                Color = Color3.fromRGB(200, 0, 0),
                TextSize = 16
            })
        end
    elseif command == "/jump" then
        local newJumpPower = tonumber(value)
        if newJumpPower and newJumpPower >= 0 then
            humanoid.JumpPower = newJumpPower
            LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                Text = "Your jump power has been set to: " .. newJumpPower,
                Font = Enum.Font.SourceSansBold,
                Color = Color3.fromRGB(0, 200, 0),
                TextSize = 18
            })
        else
            LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                Text = "Invalid jump power value. Please use /jump [number].",
                Font = Enum.Font.SourceSans,
                Color = Color3.fromRGB(200, 0, 0),
                TextSize = 16
            })
        end
    elseif command == "/highlight" then
        if value == "on" then
            if not highlightingEnabled then
                highlightingEnabled = true
                startHighlighting()
                LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                    Text = "Player highlighting is now ON.",
                    Font = Enum.Font.SourceSansBold,
                    Color = Color3.fromRGB(0, 170, 0),
                    TextSize = 18
                })
            else
                LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                    Text = "Player highlighting is already ON.",
                    Font = Enum.Font.SourceSans,
                    Color = Color3.fromRGB(255, 165, 0),
                    TextSize = 16
                })
            end
        elseif value == "off" then
            if highlightingEnabled then
                highlightingEnabled = false
                stopHighlighting()
                LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                    Text = "Player highlighting is now OFF.",
                    Font = Enum.Font.SourceSansBold,
                    Color = Color3.fromRGB(170, 0, 0),
                    TextSize = 18
                })
            else
                LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                    Text = "Player highlighting is already OFF.",
                    Font = Enum.Font.SourceSans,
                    Color = Color3.fromRGB(255, 165, 0),
                    TextSize = 16
                })
            end
        else
            LocalPlayer:GetPlayerGui():SetCore("ChatMakeSystemMessage", {
                Text = "Invalid /highlight command. Use /highlight on or /highlight off.",
                Font = Enum.Font.SourceSans,
                Color = Color3.fromRGB(200, 0, 0),
                TextSize = 16
            })
        end
    end
end)

-- Initial setup: Start highlighting if it's enabled by default
if highlightingEnabled then
    startHighlighting()
end

-- Listen for character changes (e.g., player respawns) to re-apply highlights if needed
LocalPlayer.CharacterAdded:Connect(function(character)
    if highlightingEnabled then
        -- The highlight loop will automatically pick up new characters.
        -- If you want immediate highlight on respawn, uncomment the line below:
        -- applyHighlight(LocalPlayer)
        print("Player character added, highlights will refresh soon if enabled.")
    end
end)
