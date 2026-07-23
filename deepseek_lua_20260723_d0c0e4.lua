-- RAMZ UI Menu Template dengan Keybind (Tekan 'L' untuk Toggle)
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local AutoFarmBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Background putih biru
MainFrame.Name = "JetyxFram"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(240, 248, 255) -- Biru sangat muda (AliceBlue)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Stroke biru
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 100, 255) -- Biru terang
UIStroke.Thickness = 2

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.00
Title.Position = UDim2.new(0, 16, 0, 16)
Title.Size = UDim2.new(0, 200, 0, 20)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "JetyxFram"
Title.TextColor3 = Color3.fromRGB(0, 80, 200) -- Biru gelap
Title.TextSize = 16.00
Title.TextXAlignment = Enum.TextXAlignment.Left

-- AutoFarm Button (Putih dengan border biru)
AutoFarmBtn.Name = "AutoFarmBtn"
AutoFarmBtn.Parent = MainFrame
AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Putih
AutoFarmBtn.Position = UDim2.new(0, 16, 0, 50)
AutoFarmBtn.Size = UDim2.new(0, 150, 0, 35)
AutoFarmBtn.Font = Enum.Font.SourceSansBold
AutoFarmBtn.Text = "Start AutoFarm"
AutoFarmBtn.TextColor3 = Color3.fromRGB(0, 80, 200) -- Biru gelap
AutoFarmBtn.TextSize = 14
AutoFarmBtn.BorderColor3 = Color3.fromRGB(0, 100, 255) -- Border biru
AutoFarmBtn.BorderSizePixel = 2

-- Tambahkan UICorner untuk button
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = AutoFarmBtn

-- Status Label (Biru gelap)
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundTransparency = 1
StatusLabel.Position = UDim2.new(0, 16, 0, 100)
StatusLabel.Size = UDim2.new(0, 200, 0, 20)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(0, 60, 150) -- Biru gelap
StatusLabel.TextSize = 14
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Variables
local autoFarmActive = false
local targetNPCs = {}
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Function to find NPCs in South Bronx Trenches
local function findNPCs()
    local npcs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():match("npc|enemy|zombie|bandit|gang|thug") then
            local humanoid = v:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local rootPart = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Torso")
                if rootPart then
                    table.insert(npcs, v)
                end
            end
        end
    end
    return npcs
end

-- Smooth teleport with random delay to avoid anti-cheat
local function smoothTeleport(targetPart)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local rootPart = character.HumanoidRootPart
    local targetPos = targetPart.Position
    local currentPos = rootPart.Position
    
    -- Add small random offset to look natural
    local offset = Vector3.new(
        math.random(-2, 2),
        0,
        math.random(-2, 2)
    )
    targetPos = targetPos + offset
    
    -- Calculate distance
    local distance = (targetPos - currentPos).Magnitude
    
    -- Adjust speed based on distance (slower for short distances, faster for long)
    local speed = 50 -- Base speed
    if distance < 20 then
        speed = 30 -- Slower for short distances
    elseif distance > 100 then
        speed = 80 -- Faster for long distances
    end
    
    -- Randomize speed slightly
    speed = speed * (0.8 + math.random() * 0.4)
    
    local timeToMove = distance / speed
    local startTime = tick()
    local startPos = currentPos
    
    -- Move gradually
    while (tick() - startTime) < timeToMove do
        local alpha = (tick() - startTime) / timeToMove
        local newPos = startPos:Lerp(targetPos, alpha)
        rootPart.CFrame = CFrame.new(newPos)
        RunService.Heartbeat:Wait()
    end
    
    -- Final snap with small random delay
    wait(math.random(5, 15) / 100)
    rootPart.CFrame = CFrame.new(targetPos)
end

-- AutoFarm function
local function startAutoFarm()
    autoFarmActive = true
    StatusLabel.Text = "Status: Farming..."
    StatusLabel.TextColor3 = Color3.fromRGB(0, 150, 50) -- Hijau
    AutoFarmBtn.Text = "Stop AutoFarm"
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 200) -- Merah muda
    AutoFarmBtn.TextColor3 = Color3.fromRGB(200, 0, 0) -- Merah
    
    while autoFarmActive do
        -- Find nearest NPC
        local npcs = findNPCs()
        local nearestNPC = nil
        local nearestDist = math.huge
        
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            wait(1)
            continue
        end
        
        local rootPart = character.HumanoidRootPart
        
        for _, npc in pairs(npcs) do
            local npcRoot = npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso")
            if npcRoot then
                local dist = (npcRoot.Position - rootPart.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestNPC = npc
                end
            end
        end
        
        if nearestNPC then
            local npcRoot = nearestNPC:FindFirstChild("HumanoidRootPart") or nearestNPC:FindFirstChild("Torso")
            if npcRoot then
                -- Teleport with anti-cheat bypass
                smoothTeleport(npcRoot)
                
                -- Attack NPC (simulate)
                local humanoid = nearestNPC:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    -- Simulate attack with random damage
                    humanoid.Health = humanoid.Health - math.random(5, 15)
                    StatusLabel.Text = "Status: Attacking " .. nearestNPC.Name
                    
                    -- Random wait between attacks (1-3 seconds)
                    wait(math.random(10, 30) / 10)
                else
                    wait(0.5)
                end
            end
        else
            -- No NPC found, wait and search again
            StatusLabel.Text = "Status: Searching for NPCs..."
            wait(1)
        end
        
        -- Random break to avoid detection
        if math.random(1, 100) > 80 then
            wait(math.random(2, 5))
        end
    end
end

-- Stop AutoFarm
local function stopAutoFarm()
    autoFarmActive = false
    StatusLabel.Text = "Status: Stopped"
    StatusLabel.TextColor3 = Color3.fromRGB(0, 60, 150) -- Biru gelap
    AutoFarmBtn.Text = "Start AutoFarm"
    AutoFarmBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Putih
    AutoFarmBtn.TextColor3 = Color3.fromRGB(0, 80, 200) -- Biru gelap
end

-- Button Click
AutoFarmBtn.MouseButton1Click:Connect(function()
    if not autoFarmActive then
        startAutoFarm()
    else
        stopAutoFarm()
    end
end)

-- Keybind untuk menyembunyikan/menampilkan menu menggunakan tombol L
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.L then
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)

-- Cleanup when character dies
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    if autoFarmActive then
        stopAutoFarm()
    end
end)