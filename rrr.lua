--[[
    Roblox Player Highlighter Script (Automatic)

    This LocalScript automatically highlights all players in the game,
    refreshing the highlights every 5 seconds. There is no UI or chat
    command functionality in this version.

    It's designed to be placed in StarterPlayerScripts or any other
    client-side location where it can run.

    How it works:
    1. It continuously checks for all players in the game every 5 seconds.
    2. For each player, it creates a 'Highlight' instance.
    3. The 'Highlight' is parented to the player's Character model.
    4. Existing highlights are destroyed before new ones are created to ensure
       a fresh highlight effect and prevent multiple highlights stacking up.
]]

-- Define constants for the highlight properties
local HIGHLIGHT_COLOR = Color3.fromRGB(255, 255, 0) -- Bright yellow highlight
local HIGHLIGHT_TRANSPARENCY = 0.5 -- Semi-transparent fill
local HIGHLIGHT_OUTLINE_TRANSPARENCY = 0 -- Fully opaque outline

-- Game Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer -- Still useful for potential future local player exclusions

-- Table to keep track of created highlights for easy removal
local currentHighlights = {}

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

-- Main loop to refresh highlights every 5 seconds
while task.wait(5) do -- This loop will run indefinitely, waiting 5 seconds each iteration
    print("Refreshing player highlights...")
    local playersInGame = Players:GetPlayers() -- Get a list of all players currently in the game

    for _, player in ipairs(playersInGame) do
        -- This version highlights all players, including the local player.
        -- If you want to exclude the local player, uncomment the line below:
        -- if player ~= LocalPlayer then
            applyHighlight(player)
        -- end
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

-- The script starts running immediately when loaded, automatically highlighting players.
