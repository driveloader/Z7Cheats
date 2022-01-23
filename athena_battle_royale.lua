local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local EquippedWeapon = LocalPlayer.Character:WaitForChild("Equipped")
local ItemScript = LocalPlayer.PlayerScripts:WaitForChild("ItemScriptㅤ") --//  Wow the devs added a special character to prevent getting the script!!!!
local MouseModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Mouse"))

local Events = ReplicatedStorage:WaitForChild("Events")
local RecoilEvent = Events:WaitForChild("Recoil")
local ShakeEvent = Events:WaitForChild("Shake")

if not getgenv().Library then --// pair with my universal (https://github.com/coastss/universal)
    getgenv().Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/coastss/universal/main/utilities/ui_library.lua"))()
end

local function GetClosestPlayer()
    if not LocalPlayer.Character then return end

    local ClosestPlayer = nil
    local FarthestDistance = math.huge

    for Index, Player in pairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and (Player.Character and Player.Character:FindFirstChildWhichIsA("Humanoid").Health > 0) then
            local HumanoidRootPart = Player.Character:FindFirstChild("HumanoidRootPart")

            if HumanoidRootPart then
                local Distance = nil

                if Library.flags["Silent Aim Method"] == "Mouse" then
                    local ScreenPosition, OnScreen = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)

                    if OnScreen then
                        Distance = (Vector2.new(ScreenPosition.X, ScreenPosition.Y) - UserInputService:GetMouseLocation()).Magnitude
                    end
                elseif Library.flags["Silent Aim Method"] == "Character" then
                    Distance = LocalPlayer:DistanceFromCharacter(HumanoidRootPart.Position)
                end
                        
                if Distance and (Distance < FarthestDistance) then
                    FarthestDistance = Distance
                    ClosestPlayer = Player
                end
            end
        end
    end

    return ClosestPlayer
end

--// Silent Aim
local OldRayNew = nil
OldRayNew = hookfunction(Ray.new, function(...)
    local Arguments = {...}
    
    if getfenv(2).script == ItemScript and Library.flags["Silent Aim Enabled"] then
        local ClosestPlayer = GetClosestPlayer()
        local WeaponConfig = require(EquippedWeapon.Value:FindFirstChild("Config"))
        local Muzzle = (EquippedWeapon.Value:FindFirstChild("Handle") and EquippedWeapon.Value:FindFirstChild("Handle"):FindFirstChild("Muzzle"))

        if (ClosestPlayer and ClosestPlayer.Character) and WeaponConfig and Muzzle then
            local HitPart = ClosestPlayer.Character:FindFirstChild("HumanoidRootPart")

            if math.random(Library.flags["Silent Aim Headshot Chance"], 100) == 100 then
                HitPart = ClosestPlayer.Character:FindFirstChild("Head")
            end

            if HitPart then
                Arguments[2] = (CFrame.new(Muzzle.WorldPosition, HitPart.Position).LookVector * WeaponConfig.Range)
            end
        end
    end
    
    return OldRayNew(unpack(Arguments))
end)

--// Weapon Mods
local OldNameCall = nil
OldNameCall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local NamecallMethod = getnamecallmethod()
    local Arguments = {...}
    
    if NamecallMethod == "Fire" then
        if self == RecoilEvent and Library.flags["No Recoil"] then
            Arguments[1] = Vector3.new()
        elseif self == ShakeEvent and Library.flags["No Shake"] then
            Arguments[1] = 0
        end
    end

    if NamecallMethod == "FireServer" and self.Name == "Hit" then
        print(self, ...)
    end
    
    return OldNameCall(self, unpack(Arguments))
end))


--// Library
local AthenaBRTab = Library:CreateWindow("Athena: BR!")

local SilentAim = AthenaBRTab:AddFolder("Silent Aim")
SilentAim:AddToggle({text = "Enabled", flag = "Silent Aim Enabled"})
SilentAim:AddSlider({
    text = "Headshot Chance %",
    flag = "Silent Aim Headshot Chance",
    min = 0,
    max = 100,
    float = 1
})

SilentAim:AddList({
    text = "Closest To",
    flag = "Silent Aim Method",
    values = {"Mouse", "Character"}
})

local WeaponMods = AthenaBRTab:AddFolder("Weapon Mods")
WeaponMods:AddToggle({text = "No Recoil", flag = "No Recoil"})
WeaponMods:AddToggle({text = "No Shake", flag = "No Shake"})

Library:Init()

UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
    if GameProcessedEvent then return end
    if Input.KeyCode == Enum.KeyCode.RightControl then
        Library:Close()
    end
end)
