local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local Camera = Workspace.CurrentCamera

local function GetClosestPlayer()
    local ClosestPlayer = nil
    local FarthestDistance = math.huge

    for Index, Player in pairs(Players.GetPlayers(Players)) do
        if Player ~= LocalPlayer and Player.Character then
            local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                local RootScreenPosition, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)

                if OnScreen then
                    local MouseDistanceFromPlayer = (Vector2.new(RootScreenPosition.X, RootScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                    
                    if MouseDistanceFromPlayer < FarthestDistance then
                        FarthestDistance = MouseDistanceFromPlayer
                        ClosestPlayer = Player
                    end
                end
            end
        end
    end

    return ClosestPlayer
end

local FireFunction = nil
for Index, Value in pairs(getgc(true)) do
    if typeof(Value) == "table" and rawget(Value, "Fire") then
        if Value.ToggleCrouch and Value.UpdateAmmoGui then
            FireFunction = Value.Fire
            break
        end
    end
end

if not FireFunction then
    LocalPlayer:Kick("Failed to get required function(s).")
    return
end

local OldFireFunction = nil
OldFireFunction = hookfunction(FireFunction, function(...)
    local Arguments = {...}

    if shared.SilentAim then
        local ClosestPlayer = GetClosestPlayer()

        if ClosestPlayer and ClosestPlayer.Character then
            Arguments[2] = ClosestPlayer.Character.Head.Position
        end
    end
    
    return OldFireFunction(unpack(Arguments))
end)
