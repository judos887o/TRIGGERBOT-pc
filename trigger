--// TRIGGERBOT ALWAYS ON //--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Config = {
    FIRE_RATE    = 0,       -- Sekunden zwischen Schüssen (0 = kein Delay)
    MAX_DISTANCE = 1500,
    validBodyParts = {
        ["Head"] = true, ["HumanoidRootPart"] = true, ["Torso"] = true, ["Left Leg"] = true,
        ["Right Leg"] = true, ["Left Arm"] = true, ["Right Arm"] = true, ["UpperTorso"] = true,
        ["LowerTorso"] = true, ["LeftUpperArm"] = true, ["LeftLowerArm"] = true, ["RightUpperArm"] = true,
        ["RightLowerArm"] = true, ["LeftHand"] = true, ["RightHand"] = true, ["LeftUpperLeg"] = true,
        ["LeftLowerLeg"] = true, ["RightUpperLeg"] = true, ["RightLowerLeg"] = true, ["LeftFoot"] = true,
        ["RightFoot"] = true
    }
}

local lastFireTime = 0

RunService.RenderStepped:Connect(function()
    local currentTime = time()
    if currentTime - lastFireTime < Config.FIRE_RATE then return end

    local character = player.Character
    if not character then return end

    local equippedTool = character:FindFirstChildOfClass("Tool")
    if not equippedTool then return end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {character}

    local rayOrigin = camera.CFrame.Position
    local rayDirection = camera.CFrame.LookVector * Config.MAX_DISTANCE
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)

    if raycastResult then
        local hitPart = raycastResult.Instance
        if Config.validBodyParts[hitPart.Name] then
            local targetModel = hitPart:FindFirstAncestorWhichIsA("Model")
            if targetModel then
                local hum = targetModel:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    equippedTool:Activate()
                    lastFireTime = currentTime
                end
            end
        end
    end
end)
