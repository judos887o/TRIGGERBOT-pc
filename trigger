local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local Shared = getgenv().SchmecktHubPC or {}
getgenv().SchmecktHubPC = Shared
Shared.TriggerBot = true

local key = "TriggerBot"
Shared.Connections = Shared.Connections or {}
if Shared.Connections[key] then
    for _, conn in pairs(Shared.Connections[key]) do
        pcall(function() conn:Disconnect() end)
    end
end
Shared.Connections[key] = {}

local player = Players.LocalPlayer
local Mouse = player:GetMouse() -- Wichtig für das Looten System

local Config = {
    FIRE_RATE = 0.1, -- Angepasst an Looten Standard (0.1)
    -- Radius und Distanz werden nicht mehr benötigt, da Looten Mouse.Target nutzt
}

local lastFireTime = 0

-- Hier ist das Aim System von Looten (Mouse.Target) implementiert
local function GetTargetLootenStyle()
    -- Looten Logic: Prüft ob die Maus direkt auf einem Spieler ist
    if Mouse.Target then
        local targetPart = Mouse.Target
        
        -- Wir suchen das Model (den Charakter) basierend auf dem getroffenen Teil
        local character = targetPart:FindFirstAncestorOfClass("Model")
        
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            -- Prüft ob es ein Spieler ist, ob er lebt und ob wir es nicht selbst sind
            if humanoid and humanoid.Health > 0 and character.Name ~= player.Name then
                return character
            end
        end
    end
    return nil
end

local function Fire()
    local character = player.Character
    if not character then return end
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
    end
end

table.insert(Shared.Connections[key], RunService.Heartbeat:Connect(function()
    if not Shared.TriggerBot then return end
    
    local currentTime = tick()
    if currentTime - lastFireTime < Config.FIRE_RATE then return end
    
    -- Nutzt jetzt die Looten-Detection Logik
    local target = GetTargetLootenStyle()
    
    if target then
        Fire()
        lastFireTime = currentTime
    end
end))
