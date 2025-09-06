local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Config = {
    IsEnabled = false, 
    TriggerKey = Enum.KeyCode.Q,
    FIRE_RATE = 0,
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
local mainGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
mainGui.ResetOnSpawn = false
mainGui.Name = "Reliable_TriggerBot_GUI"
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local triggerStatusLabel = Instance.new("TextLabel", mainGui)
triggerStatusLabel.Size = UDim2.new(0, 180, 0, 40)
triggerStatusLabel.Position = UDim2.new(0.02, 0, 0.5, -20)
triggerStatusLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
triggerStatusLabel.BackgroundTransparency = 0.3
triggerStatusLabel.Font = Enum.Font.GothamBold
triggerStatusLabel.TextSize = 18
triggerStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
triggerStatusLabel.Text = "Trigger: OFF"
local corner = Instance.new("UICorner", triggerStatusLabel)
corner.CornerRadius = UDim.new(0, 8)

task.spawn(function()
    local introText = "TriggerBot v7.0 | By Schmeckt, press Q to toggle bot (PAID PC VERSION)..."
    
    local introLabel = Instance.new("TextLabel", mainGui)
    introLabel.Size = UDim2.new(0, 500, 0, 50)
    introLabel.Position = UDim2.new(0.5, -250, 1, 0)
    introLabel.BackgroundTransparency = 1
    introLabel.Font = Enum.Font.GothamBold
    introLabel.TextSize = 24
    introLabel.TextColor3 = Color3.new(1, 1, 1)
    introLabel.Text = ""
    
    local stroke = Instance.new("UIStroke", introLabel)
    stroke.Color = Color3.new(0,0,0)
    stroke.Thickness = 1.5

    local introSound = Instance.new("Sound", introLabel)
    introSound.SoundId = "rbxassetid://5106954314"
    introSound.Volume = 0.5
    
    local tweenInfoIn = TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local goalIn = { Position = UDim2.new(0.5, -250, 0.4, 0) }
    local tweenIn = TweenService:Create(introLabel, tweenInfoIn, goalIn)
    
    tweenIn:Play()
    introSound:Play()
    tweenIn.Completed:Wait()
    
    for i = 1, #introText do
        introLabel.Text = string.sub(introText, 1, i)
        task.wait(0.05)
    end
    
    task.wait(3)
    
    local tweenInfoOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local goalOut = { Position = UDim2.new(0.5, -250, -0.2, 0) }
    local tweenOut = TweenService:Create(introLabel, tweenInfoOut, goalOut)
    
    tweenOut:Play()
    tweenOut.Completed:Wait()
    introLabel:Destroy()
end)

local function updateGuiStatus()
    if Config.IsEnabled then
        triggerStatusLabel.Text = "Trigger: ON"
    else
        triggerStatusLabel.Text = "Trigger: OFF"
        triggerStatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Config.TriggerKey then
        Config.IsEnabled = not Config.IsEnabled
        updateGuiStatus()
    end
end)

task.spawn(function()
    local speed = 5
    while true do
        if Config.IsEnabled then
            local hue = (tick() * speed / 10) % 1
            triggerStatusLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
        end
        task.wait()
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.IsEnabled then return end
    
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
            if targetModel and targetModel:FindFirstChildOfClass("Humanoid") and targetModel.Humanoid.Health > 0 then
                equippedTool:Activate()
                lastFireTime = currentTime
            end
        end
    end
end)

updateGuiStatus()
