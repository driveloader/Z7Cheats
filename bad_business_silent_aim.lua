--// Setup & services.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if not shared.SilentAim then --// If the table doesn't exist. Create one.
    shared.SilentAim = {
        Enabled = true,
        HeadshotChance = 100
    }
end

--// Main script.
--// Of course you could just do require(game:GetService("ReplicatedStorage"):WaitForChild("TS")), but why do it the easy way?

local TS = nil
for Index, Value in pairs(getgc(true)) do --// Looping through the garbage collection.
    if typeof(Value) == "table" and rawget(Value, "InitProjectile") then --// Seeing if we can find the Projectiles table by searching for the "InitProjectile" function that is paired to said table.
        if Value.TS then --// If it has the games main module in it then we successfully found the game's main module.
            TS = Value.TS
            break
        end
    end
end

local function OnClientTeam(Player) --// Checking if the player we are looking for is on the client's (your) team using in-game functions.
    if TS.Teams:ArePlayersFriendly(Player, LocalPlayer) then
        return true
    end

    return false
end

local function GetHeadPart(Player) --// Getting the head part of a player.
    local Character = TS.Characters:GetCharacter(Player)
    local Body = (Character and Character:FindFirstChild("Body"))

    if Character and Body then
        return Body:FindFirstChild("Head")
    end
end 

local function GetClosestPlayerCharacterToCursor()
    local ClosestPlayer = nil
    local FarthestDistance = math.huge

    for Index, Player in pairs(Players:GetPlayers()) do --// Loop through all the players.
        if Player == LocalPlayer then continue end --// Skip over this iteration if it is the Clients.
        if OnClientTeam(Player) then continue end --// Skip over this iteration if the player is on the client's team.

        local HeadPart = GetHeadPart(Player)

        if HeadPart then
            local HeadPosition, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(HeadPart.Position) --// Converting the 3D position to a screen position to make it easier.

            if OnScreen then --// Check if they are visible/on screen in the roblox window area.
                local MouseDistanceFromPlayer = (Vector2.new(HeadPosition.X, HeadPosition.Y) - UserInputService:GetMouseLocation()).Magnitude --// Check the mouse distance from the player.
                
                if MouseDistanceFromPlayer < FarthestDistance then
                    FarthestDistance = MouseDistanceFromPlayer --// Make the farthest distance the mouse distance.
                    ClosestPlayer = Player --// Closest player is the player iteration we are on for now, may change later on.
                end
            end
        end
    end

    return TS.Characters:GetCharacter(ClosestPlayer) --// Return the player's character.
end

local OldFireProjectile = TS.Projectiles.InitProjectile --// Making a backup of the old function so we can use it to spoof later on.
TS.Projectiles.InitProjectile = function(self, ...) --// Hooking the function.
    local Arguments = {...} --// Converting the function arguments to a table.
    
    if shared.SilentAim.Enabled and Arguments[4] == LocalPlayer then
        local ClosestPlayer = GetClosestPlayerCharacterToCursor()
        local HeadshotChance = math.random(shared.SilentAim.HeadshotChance, 100)

        --// Reference: https://coasts.cool/uploads/zo0BmqjIm0TBlmsy1Mkn.png
        --// Position: Arguments[2]
        --// Velocity: Arguments[3]

        if ClosestPlayer and (ClosestPlayer.Health.Value > 0) then
            if HeadshotChance == 100 then --// If the random number hits 100 we goto the head because it got the top number.
                Arguments[2] = (ClosestPlayer.Hitbox.Head.Position - Arguments[3])
            else
                Arguments[2] = (ClosestPlayer.Hitbox.Chest.Position - Arguments[3]) --// If not, we will hit at their chest.
            end

            --// Subtracting with the velocity to get the exact position to hit on the player's head.
            --// From google: Velocity is the rate at which the position changes. The average velocity is the displacement or position change (a vector quantity) per time ratio.
        end
    end
    
    return OldFireProjectile(self, unpack(Arguments)) --// Unpacking the arguments. Basically replcaing parts of the game's fired arguments with our spoofed ones.
end